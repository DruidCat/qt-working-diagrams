#include "dcassets.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QCoreApplication>
#include <QDebug>
#include <QElapsedTimer>
#include <QStandardPaths>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QJniEnvironment>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#endif // Q_OS_ANDROID

#ifdef MENTOR_DB_MOBILE//механизм актуален только для сборок с базой в пакете.

//Файл-маркер версии бандла данных; пишет упаковщик (tools/sync_dbmobile_assets.sh,
//adq_pack.py). Отличается от сохранённого — данные пересобираются с принудительной
//перезаписью, т.к. сверка только по размеру не видит правки файла без изменения размера.
static const QString slsImyaFailaVersii = QStringLiteral("bundleversion.txt");

static quint64 untSkopirovanoFailov = 0;//Счётчик реально скопированных файлов за запуск.

static QString polWersiyuIzFaila(const QString& strFailPut){//Версия бандла из текстового файла.
    QFile odrFail(strFailPut);
    if(!odrFail.open(QIODevice::ReadOnly))
        return QString();//Файла версии ещё нет (первый запуск).
    QByteArray slsDannie = odrFail.read(4096);
    odrFail.close();
    return QString::fromUtf8(slsDannie).trimmed();
}

#ifdef Q_OS_ANDROID
///////////////////////////////////////////////
//---A N D R O I D :   A S S E T S   A P K---//
///////////////////////////////////////////////
static QString polWersiyuIzAsseta(AAssetManager* pMenedjerAssets){//Версия бандла из assets APK.
    QString strAssetPut = QStringLiteral("workingdata/") + slsImyaFailaVersii;
    AAsset* pAsset = AAssetManager_open(pMenedjerAssets, strAssetPut.toUtf8().constData(),
                                        AASSET_MODE_STREAMING);
    if(!pAsset)
        return QString();//Файла версии в пакете нет.
    qint64 dlina = AAsset_getLength64(pAsset);
    QByteArray slsDannie;
    if(dlina > 0 && dlina < 4096){
        slsDannie.resize(int(dlina));
        if(AAsset_read(pAsset, slsDannie.data(), int(dlina)) != int(dlina))
            slsDannie.clear();
    }
    AAsset_close(pAsset);
    return QString::fromUtf8(slsDannie).trimmed();
}

static bool kopirovatEsliIzmenilsya(const QString& strAssetPut, const QString& strFailPut,
                                    AAssetManager* pMenedjerAssets,
                                    bool blForce){//Копирует, если размера нет или он другой.
    AAsset* pAsset = AAssetManager_open(pMenedjerAssets, strAssetPut.toUtf8().constData(),
                                        AASSET_MODE_STREAMING);
    if(!pAsset){
        qWarning() << "DCAssets: ассет не открыт:" << strAssetPut;
        return false;
    }
    qint64 dlinaAsset = AAsset_getLength64(pAsset);//Размер файла внутри APK.
    qint64 dlinaFaila = QFileInfo(strFailPut).size();//-1 если файла ещё нет — тогда точно копируем.
    if(!blForce && dlinaAsset == dlinaFaila && dlinaFaila >= 0){//Файл уже на месте и совпадает.
        AAsset_close(pAsset);
        return true;
    }
    bool blResult = false;
    QFile odrFail(strFailPut);
    if(odrFail.open(QIODevice::WriteOnly | QIODevice::Truncate)){
        blResult = true;
        QByteArray slsBufer(262144, 0);//Буфер 256 КиБ для поточного копирования.
        while(true){
            int untProchitano = AAsset_read(pAsset, slsBufer.data(), slsBufer.size());
            if(untProchitano < 0){blResult = false; break;}//Ошибка чтения ассета.
            if(untProchitano == 0) break;//Конец ассета.
            if(odrFail.write(slsBufer.constData(), untProchitano) != untProchitano){
                blResult = false; break;
            }
        }
        odrFail.close();
        if(!blResult) odrFail.remove();//Недописанный файл удаляем, скопируется заново при старте.
        else untSkopirovanoFailov++;
    }
    else qWarning() << "DCAssets: файл не создаётся:" << strFailPut;
    AAsset_close(pAsset);
    if(!blResult) qWarning() << "DCAssets: не удалось скопировать ассет:" << strAssetPut;
    return blResult;
}

static bool sinhronizovatKatalog(const QString& strAssetPut, const QString& strFailPut,
                                 QJniObject& odrAssets, AAssetManager* pMenedjerAssets,
                                 JNIEnv* pEnv, bool blForce){//В Qt 6.7 JNI-массивы только через JNIEnv.
    QJniObject spsSpisok = odrAssets.callObjectMethod("list",
            "(Ljava/lang/String;)[Ljava/lang/String;", QJniObject::fromString(strAssetPut).object());
    if(!spsSpisok.isValid()){
        qWarning() << "DCAssets: список ассетов не получен:" << strAssetPut;
        return false;
    }
    jobjectArray arrSpisok = static_cast<jobjectArray>(spsSpisok.object());
    bool blResult = true;
    int untKolichestvo = pEnv->GetArrayLength(arrSpisok);
    for(int untI = 0; untI < untKolichestvo; untI++){
        QJniObject odrElement(pEnv->GetObjectArrayElement(arrSpisok, untI));
        QString strImya = odrElement.toString();
        if(strImya.isEmpty()) continue;
        QString strPotomok = strAssetPut + "/" + strImya;
        //list() у файла возвращает пустой массив, у папки — непустой; так их различаем.
        QJniObject spsDety = odrAssets.callObjectMethod("list",
                "(Ljava/lang/String;)[Ljava/lang/String;",
                QJniObject::fromString(strPotomok).object());
        bool blKatalog = spsDety.isValid()
                && pEnv->GetArrayLength(static_cast<jobjectArray>(spsDety.object())) > 0;
        QString strTarget = QDir(strFailPut).filePath(strImya);
        if(blKatalog){
            if(!QDir().mkpath(strTarget)){
                qWarning() << "DCAssets: папка не создана:" << strTarget;
                blResult = false;
                continue;
            }
            blResult &= sinhronizovatKatalog(strPotomok, strTarget, odrAssets, pMenedjerAssets,
                                             pEnv, blForce);
        }
        else blResult &= kopirovatEsliIzmenilsya(strPotomok, strTarget, pMenedjerAssets, blForce);
    }
    return blResult;
}
#else // !Q_OS_ANDROID
///////////////////////////////////////////////////////
//---A V R O R A / D E S K T O P :   К А Т А Л О Г---//
///////////////////////////////////////////////////////
//Каталог workingdata, упакованный в пакет: на Авроре installer переносит содержимое
//RPM в зону /opt/app/<appid>/<ver> и оставляет ссылки /usr/...; путь /usr/share/...
//работает и после релокации. MENTOR_BUNDLE_DIR задаётся сборкой для десктоп-тестов.
static QString polKatalogBundlya(){
    QStringList slsKandidaty;
#ifdef MENTOR_BUNDLE_DIR
    slsKandidaty << QStringLiteral(MENTOR_BUNDLE_DIR);//Каталог проекта (десктоп-проверка режима).
#endif
    slsKandidaty << "/usr/share/ru.druidcat.mentor/workingdata"//Aurora: содержимое RPM.
                 << QDir(QCoreApplication::applicationDirPath()).filePath("workingdata");
    for(const QString& strKandidat : slsKandidaty){
        if(QDir(strKandidat).exists())
            return QDir(strKandidat).absolutePath();
    }
    return QString();//Каталог бандла не найден.
}

static bool kopirovatFailEsliIzmenilsya(const QString& strIsthPut, const QString& strFailPut,
                                        bool blForce){//Копирует, если размера нет или он другой.
    qint64 dlinaIsth = QFileInfo(strIsthPut).size();
    qint64 dlinaFaila = QFileInfo(strFailPut).size();//-1 если файла ещё нет — точно копируем.
    if(!blForce && dlinaIsth == dlinaFaila && dlinaFaila >= 0)
        return true;//Файл уже на месте и совпадает по размеру.
    if(QFile::exists(strFailPut) && !QFile::remove(strFailPut)){
        qWarning() << "DCAssets: старый файл не удалён:" << strFailPut;
        return false;
    }
    if(!QFile::copy(strIsthPut, strFailPut)){
        qWarning() << "DCAssets: не удалось скопировать файл бандла:" << strIsthPut;
        return false;
    }
    untSkopirovanoFailov++;
    return true;
}

static bool sinhronizovatKatalogFailov(const QString& strIsthDir, const QString& strTargetDir,
                                       bool blForce){//Рекурсивная синхронизация каталога.
    QDir odrIsth(strIsthDir);
    bool blResult = true;
    const QFileInfoList slsSpisok = odrIsth.entryInfoList(
            QDir::AllEntries | QDir::NoDotAndDotDot | QDir::Hidden, QDir::Name);
    for(const QFileInfo& odrInfo : slsSpisok){
        QString strTarget = QDir(strTargetDir).filePath(odrInfo.fileName());
        if(odrInfo.isDir()){
            if(!QDir().mkpath(strTarget)){
                qWarning() << "DCAssets: папка не создана:" << strTarget;
                blResult = false;
                continue;
            }
            blResult &= sinhronizovatKatalogFailov(odrInfo.absoluteFilePath(), strTarget, blForce);
        }
        else blResult &= kopirovatFailEsliIzmenilsya(odrInfo.absoluteFilePath(), strTarget, blForce);
    }
    return blResult;
}
#endif // Q_OS_ANDROID

#endif // MENTOR_DB_MOBILE

QString DCAssets::polDataPut(const QString& strImyaKataloga){//Каталог данных приложения + подкаталог.
/////////////////////////////////////////////////////
//---П У Т Ь   Д А Н Н Ы Х   П Р И Л О Ж Е Н И Я---//
/////////////////////////////////////////////////////
#ifdef Q_OS_ANDROID
    QString strDomPut = QDir::homePath();//На Android это приватный каталог files приложения.
#else
    //На Авроре и десктопе — записываемый каталог данных приложения (AppDataLocation).
    QString strDomPut = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if(strDomPut.isEmpty())//Запасной вариант, если стандартный путь недоступен.
        strDomPut = QDir(QDir::homePath()).filePath(".local/share/ru.druidcat.mentor");
#endif
    QDir odrPut(strDomPut);
    if(!odrPut.mkpath(strImyaKataloga))
        qWarning() << "DCAssets::polDataPut: ошибка создания папки:" << strImyaKataloga;
    return odrPut.filePath(strImyaKataloga);
}

bool DCAssets::obnovitRabochieData(const QString& strRabochiPut){//Синхронизация данных из пакета.
///////////////////////////////////////////////////////
//---О Б Н О В И Т Ь   Р А Б О Ч И Е   Д А Н Н Ы Е---//
///////////////////////////////////////////////////////
#ifndef MENTOR_DB_MOBILE
    Q_UNUSED(strRabochiPut)//Классическая сборка: workingdata лежит на файловой системе.
    return true;
#else
    bool blForce = false;//Принудительная перезапись при смене версии бандла.
    QString strWersiyaVKataloge = polWersiyuIzFaila(QDir(strRabochiPut).filePath(slsImyaFailaVersii));
    QElapsedTimer odrTajmer;
    odrTajmer.start();
    bool blResult = false;
#ifdef Q_OS_ANDROID
    QJniObject odrActivity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative",
                                                                "activity", "()Landroid/app/Activity;");
    if(!odrActivity.isValid()){
        qWarning() << "DCAssets::obnovitRabochieData: Activity недоступна, распаковка пропущена.";
        return false;
    }
    QJniObject odrAssets = odrActivity.callObjectMethod("getAssets",
                                                        "()Landroid/content/res/AssetManager;");
    if(!odrAssets.isValid()){
        qWarning() << "DCAssets::obnovitRabochieData: AssetManager недоступен.";
        return false;
    }
    QJniEnvironment odrEnv;//Нужен для получения AAssetManager из Java-объекта.
    AAssetManager* pMenedjerAssets = AAssetManager_fromJava(odrEnv.jniEnv(), odrAssets.object());
    if(!pMenedjerAssets){
        qWarning() << "DCAssets::obnovitRabochieData: AAssetManager не получен.";
        return false;
    }
    QString strWersiyaIzPaketa = polWersiyuIzAsseta(pMenedjerAssets);
    blForce = !strWersiyaIzPaketa.isEmpty() && strWersiyaIzPaketa != strWersiyaVKataloge;
    blResult = sinhronizovatKatalog("workingdata", strRabochiPut, odrAssets, pMenedjerAssets,
                                    odrEnv.jniEnv(), blForce);
#else
    QString strKatalogBundlya = polKatalogBundlya();//Откуда брать workingdata (RPM/проект).
    if(strKatalogBundlya.isEmpty()){
        qWarning() << "DCAssets::obnovitRabochieData: каталог бандла workingdata не найден,"
                   << "распаковка пропущена.";
        return false;
    }
    QString strWersiyaIzPaketa = polWersiyuIzFaila(QDir(strKatalogBundlya)
                                                   .filePath(slsImyaFailaVersii));
    blForce = !strWersiyaIzPaketa.isEmpty() && strWersiyaIzPaketa != strWersiyaVKataloge;
    if(!QDir().mkpath(strRabochiPut)){
        qWarning() << "DCAssets::obnovitRabochieData: каталог данных не создаётся:" << strRabochiPut;
        return false;
    }
    blResult = sinhronizovatKatalogFailov(strKatalogBundlya, strRabochiPut, blForce);
#endif // Q_OS_ANDROID
    qDebug() << "DCAssets::obnovitRabochieData: версия бандла:" << strWersiyaIzPaketa
             << ", принудительно:" << blForce << ", скопировано файлов:" << untSkopirovanoFailov
             << ", время (мс):" << odrTajmer.elapsed() << ", успех:" << blResult;
    return blResult;
#endif // MENTOR_DB_MOBILE
}
