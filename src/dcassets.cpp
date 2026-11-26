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

#ifdef MENTOR_DATA_ENCRYPTED
#include <QJsonDocument>//licenziya.bin из assets защищённого бандла.
#include <QJsonObject>
#include <QJsonArray>
#include <QtEndian>//qToLittleEndian для счётчика nonce чанков GCM.
#include <QCryptographicHash>//HMAC/PBKDF2 ниже собираются из SHA-256 QtCore.
#endif // MENTOR_DATA_ENCRYPTED

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

#ifdef MENTOR_DATA_ENCRYPTED
///////////////////////////////////////////////////////
//---Z A S H I F R O V A N N Y Y   B A N D L   (APK)---//
///////////////////////////////////////////////////////
// Формат "mentor-lic-v1" создаётся утилитой tools/shifruj_dannie.py (описание там же):
//  - dannie.tar.enc - tar всего workingdata, AES-256-GCM чанками по 1 МиБ,
//    каждый чанк: [u32 LE длина шифртекста][шифртекст+тег], nonce = base(4Б)+счётчик u64;
//  - licenziya.bin - таблица устройств: key_i = PBKDF2-HMAC-SHA256(мастер-секрет из
//    бинаря, salt_i, итерации), E_i = AES-256-GCM(key_i, DK); DK шифрует сам blob.
// Криптографию выполняет системный javax.crypto (Android API): приложение не может
// использовать libcrypto.so системы (не в public.libraries.txt), а свои .so в APK
// таскать не нужно. Свой код в списке -> разворачиваем DK -> данные доступны.
static QString slsPosledneyayaOshestka;//Текст ошибки распаковки для журнала приложения.

static bool yniChistitIsklyuchenie(JNIEnv* pEnv);//true если было исключение Java.
static bool yniChistitIsklyuchenie(JNIEnv* pEnv){
    if(pEnv->ExceptionCheck()){
        pEnv->ExceptionClear();
        return true;
    }
    return false;
}

static jbyteArray yniNovijByteArray(JNIEnv* pEnv, const QByteArray& slsDannie){//QByteArray -> byte[]
    jbyteArray arr = pEnv->NewByteArray(slsDannie.size());
    if(arr && !slsDannie.isEmpty())
        pEnv->SetByteArrayRegion(arr, 0, slsDannie.size(),
                                 reinterpret_cast<const jbyte*>(slsDannie.constData()));
    return arr;
}

static QByteArray yniIZByteArray(JNIEnv* pEnv, jbyteArray arr){//byte[] -> QByteArray (ссылку удаляет)
    QByteArray slsDannie;
    if(!arr)
        return slsDannie;
    jsize dlina = pEnv->GetArrayLength(arr);
    slsDannie.resize(int(dlina));
    pEnv->GetByteArrayRegion(arr, 0, dlina, reinterpret_cast<jbyte*>(slsDannie.data()));
    pEnv->DeleteLocalRef(arr);
    return slsDannie;
}

static jclass naidiTclass(JNIEnv* pEnv, const char* strImyaKlassa){//глобальная ссылка!
    jclass cls = pEnv->FindClass(strImyaKlassa);
    if(pEnv->ExceptionCheck())
        pEnv->ExceptionClear();
    if(!cls){
        //Запасной путь: Class.forName через загрузчик классов приложения - на части
        //устройств ART из нативной нити Qt не видит отдельные boot-классы.
        QJniObject imya = QJniObject::fromString(
                QString::fromUtf8(strImyaKlassa).replace(QLatin1Char('/'), QLatin1Char('.')));
        QJniObject konteKst = QNativeInterface::QAndroidApplication::context();
        if(!konteKst.isValid())
            return nullptr;
        QJniObject zagruzchik = konteKst.callObjectMethod("getClassLoader",
                                                          "()Ljava/lang/ClassLoader;");
        if(!zagruzchik.isValid())
            return nullptr;
        QJniObject klass = QJniObject::callStaticObjectMethod(
                "java/lang/Class", "forName",
                "(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;",
                imya.object(), jboolean(false), zagruzchik.object());
        if(pEnv->ExceptionCheck())
            pEnv->ExceptionClear();
        if(!klass.isValid())
            return nullptr;
        return static_cast<jclass>(pEnv->NewGlobalRef(klass.object()));
    }
    jclass clsGlobal = static_cast<jclass>(pEnv->NewGlobalRef(cls));
    pEnv->DeleteLocalRef(cls);
    return clsGlobal;
}

static void xorKluchBlok(const QByteArray& kluch, QByteArray& priyom, char mask){
    for(int i = 0; i < 64; ++i)
        priyom[i] = char(kluch[i] ^ mask);
}

static QByteArray hmacSha256(const QByteArray& parol, const QByteArray& soobshenie){
    //HMAC-SHA256 по RFC 2104 поверх QCryptographicHash (размер блока SHA-256 = 64).
    QByteArray kluch = parol;
    if(kluch.size() > 64)
        kluch = QCryptographicHash::hash(parol, QCryptographicHash::Sha256);
    kluch.append(64 - kluch.size(), '\0');
    QByteArray ipad(64, Qt::Uninitialized);
    xorKluchBlok(kluch, ipad, char(0x36));
    QByteArray opad(64, Qt::Uninitialized);
    xorKluchBlok(kluch, opad, char(0x5c));
    QCryptographicHash hVnutri(QCryptographicHash::Sha256);
    hVnutri.addData(ipad);
    hVnutri.addData(soobshenie);
    QCryptographicHash hVnesh(QCryptographicHash::Sha256);
    hVnesh.addData(opad);
    hVnesh.addData(hVnutri.result());
    return hVnesh.result();
}

static QByteArray pbkdf2Sha256(const QByteArray& parol, const QByteArray& sol,
                               int untIteracii, int untDlinaKlucha){
    //PBKDF2-HMAC-SHA256 (RFC 8018); у нас ключ ровно 32 байта = один выходной блок.
    QByteArray itog;
    int untBlok = 1;
    while(itog.size() < untDlinaKlucha){
        QByteArray blokSol = sol;
        const quint32 ullBe = qToBigEndian<quint32>(quint32(untBlok));
        blokSol.append(reinterpret_cast<const char*>(&ullBe), 4);
        QByteArray u = hmacSha256(parol, blokSol);
        QByteArray t = u;
        for(int i = 1; i < untIteracii; ++i){
            u = hmacSha256(parol, u);
            for(int j = 0; j < t.size(); ++j)
                t[j] = char(t[j] ^ u[j]);
        }
        itog.append(t);
        ++untBlok;
    }
    itog.truncate(untDlinaKlucha);
    return itog;
}

static QByteArray yniAesGcmRasshifrovat(JNIEnv* pEnv, const QByteArray& slsKluch,
                                        const QByteArray& slsNonce,
                                        const QByteArray& slsShifr){//plain или пусто (тег не сошёлся).
    QByteArray slsPlain;
    QString strOshestkaGcm;
    jclass clsCipher = naidiTclass(pEnv, "javax/crypto/Cipher");
    jclass clsSpecKey = naidiTclass(pEnv, "javax/crypto/spec/SecretKeySpec");
    jclass clsSpecGcm = naidiTclass(pEnv, "javax/crypto/spec/GCMParameterSpec");
    if(!clsCipher || !clsSpecKey || !clsSpecGcm){
        if(clsCipher) pEnv->DeleteGlobalRef(clsCipher);
        if(clsSpecKey) pEnv->DeleteGlobalRef(clsSpecKey);
        if(clsSpecGcm) pEnv->DeleteGlobalRef(clsSpecGcm);
        return slsPlain;
    }
    jmethodID midInst = pEnv->GetStaticMethodID(clsCipher, "getInstance",
            "(Ljava/lang/String;)Ljavax/crypto/Cipher;");
    jstring jAlg = pEnv->NewStringUTF("AES/GCM/NoPadding");
    jobject odrCipher = pEnv->CallStaticObjectMethod(clsCipher, midInst, jAlg);
    if(yniChistitIsklyuchenie(pEnv) || !odrCipher)
        strOshestkaGcm = QStringLiteral("JNI: Cipher.getInstance не дал объект");
    jmethodID midKeyCtor = pEnv->GetMethodID(clsSpecKey, "<init>",
                                             "([BLjava/lang/String;)V");
    jbyteArray arrKluch = yniNovijByteArray(pEnv, slsKluch);
    jstring jAes = pEnv->NewStringUTF("AES");
    jobject odrKey = yniChistitIsklyuchenie(pEnv) ? nullptr : pEnv->NewObject(
            clsSpecKey, midKeyCtor, arrKluch, jAes);
    if(yniChistitIsklyuchenie(pEnv) || !odrKey)
        strOshestkaGcm = QStringLiteral("JNI: SecretKeySpec не создан");
    jmethodID midGcmCtor = pEnv->GetMethodID(clsSpecGcm, "<init>", "(I[B)V");
    jbyteArray arrNonce = yniNovijByteArray(pEnv, slsNonce);
    jobject odrGcm = yniChistitIsklyuchenie(pEnv) ? nullptr : pEnv->NewObject(
            clsSpecGcm, midGcmCtor, jsize(128), arrNonce);
    if(yniChistitIsklyuchenie(pEnv) || !odrGcm)
        strOshestkaGcm = QStringLiteral("JNI: GCMParameterSpec не создан");
    jmethodID midInit = pEnv->GetMethodID(clsCipher, "init",
            "(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V");
    if(!midInit || yniChistitIsklyuchenie(pEnv) || !odrCipher || !odrKey || !odrGcm){
        strOshestkaGcm = QStringLiteral("JNI: нет Cipher.init или объекты не готовы");
    } else {
        pEnv->CallVoidMethod(odrCipher, midInit, jsize(2)/*MODE_DECRYPT*/, odrKey, odrGcm);
        if(yniChistitIsklyuchenie(pEnv))
            strOshestkaGcm = QStringLiteral("JNI: Cipher.init бросил исключение");
    }
    jmethodID midDoFinal = pEnv->GetMethodID(clsCipher, "doFinal", "([B)[B");
    jbyteArray arrPlain = nullptr;
    if(!midDoFinal || yniChistitIsklyuchenie(pEnv) || !strOshestkaGcm.isEmpty()){
        //не зовём doFinal с пустым mid - ART abort'ит по mid == null
    } else {
        jbyteArray arrShifr = yniNovijByteArray(pEnv, slsShifr);
        arrPlain = static_cast<jbyteArray>(
                pEnv->CallObjectMethod(odrCipher, midDoFinal, arrShifr));
        pEnv->DeleteLocalRef(arrShifr);
    }
    if(!yniChistitIsklyuchenie(pEnv) && arrPlain)
        slsPlain = yniIZByteArray(pEnv, arrPlain);
    pEnv->DeleteGlobalRef(clsCipher);
    pEnv->DeleteGlobalRef(clsSpecKey);
    pEnv->DeleteGlobalRef(clsSpecGcm);
    pEnv->DeleteLocalRef(jAlg);
    pEnv->DeleteLocalRef(arrKluch);
    pEnv->DeleteLocalRef(jAes);
    pEnv->DeleteLocalRef(odrKey);
    pEnv->DeleteLocalRef(arrNonce);
    pEnv->DeleteLocalRef(odrGcm);
    pEnv->DeleteLocalRef(odrCipher);
    if(!strOshestkaGcm.isEmpty()){
        static bool blUzhePreduprejdeno = false;
        if(!blUzhePreduprejdeno){
            blUzhePreduprejdeno = true;
            qWarning() << "DCAssets GCM:" << strOshestkaGcm;
        }
    }
    return slsPlain;
}

static QString polAndroidIdSjni(){//android_id; тот же способ, что в cppqml.cpp.
    QString strKod;
    QJniObject odrContext = QNativeInterface::QAndroidApplication::context();
    if(!odrContext.isValid())
        return strKod;
    QJniObject odrCr = odrContext.callObjectMethod("getContentResolver",
            "()Landroid/content/ContentResolver;");
    if(!odrCr.isValid())
        return strKod;
    QJniObject odrKluch = QJniObject::fromString(QStringLiteral("android_id"));
    QJniObject odrId = QJniObject::callStaticObjectMethod(
            "android/provider/Settings$Secure", "getString",
            "(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;",
            odrCr.object(), odrKluch.object());
    if(odrId.isValid())
        strKod = odrId.toString();
    return strKod;
}

static bool chitatAssetPolnostyu(AAssetManager* pMenedjerAssets, const QString& strAssetPut,
                                 QByteArray& slsDannie){//Весь ассет в память (для мелких файлов).
    AAsset* pAsset = AAssetManager_open(pMenedjerAssets, strAssetPut.toUtf8().constData(),
                                        AASSET_MODE_STREAMING);
    if(!pAsset)
        return false;
    qint64 dlina = AAsset_getLength64(pAsset);
    bool blResult = false;
    if(dlina > 0 && dlina < (16LL * 1024 * 1024)){
        slsDannie.resize(int(dlina));
        blResult = (AAsset_read(pAsset, slsDannie.data(), int(dlina)) == dlina);
    }
    AAsset_close(pAsset);
    return blResult;
}

static bool chitatRovno(AAsset* pAsset, char* pKuda, int untNado){//Ровно untNado байт или false.
    int untProchitano = 0;
    while(untProchitano < untNado){
        int untStep = AAsset_read(pAsset, pKuda + untProchitano, untNado - untProchitano);
        if(untStep <= 0)
            return false;
        untProchitano += untStep;
    }
    return true;
}

static quint64 tarOctalPole(const char* pZagolovok, int untSmesh, int untDlina){//Поле ustar в octal.
    quint64 ullZnachenie = 0;
    for(int untI = 0; untI < untDlina; untI++){
        char c = pZagolovok[untSmesh + untI];
        if(c < '0' || c > '7') break;
        ullZnachenie = (ullZnachenie << 3) + quint64(c - '0');
    }
    return ullZnachenie;
}

struct TarRasparshivatel {//Минимальный ustar-парсер потока расшифрованных байтов (формат tools).
    QString strKatalogPriemnik;
    QByteArray slsBufer;
    int untPoziciya = 0;
    qint64 ullOstatokFaila = -1;//-1 заголовок ждём, >=0 данные файла пишем
    qint64 ullPropusk = 0;//выравнивание файла до границы 512 байт
    bool blPisatVFail = false;//false у skip-записей (не файлы): данные просто глотаем
    QFile odrFail;
    bool blKonec = false;//встречен пустой блок - архив прочитан
    int untFailovRaspakovan = 0;

    bool dobavitKusok(const QByteArray& slsKusok, QString& strOshestka){
        slsBufer.append(slsKusok);
        while(!blKonec){
            int untDostupno = slsBufer.size() - untPoziciya;
            if(ullOstatokFaila < 0 && ullPropusk == 0){//--- заголовок 512 байт ---
                if(untDostupno < 512) break;
                const char* pZag = slsBufer.constData() + untPoziciya;
                bool blPustoyBlok = true;
                for(int untI = 0; untI < 512; untI++)
                    if(pZag[untI] != 0){ blPustoyBlok = false; break; }
                untPoziciya += 512;
                if(blPustoyBlok){ blKonec = true; break; }
                QByteArray slsImya(pZag, qstrnlen(pZag, 100));
                if(pZag[345] != 0)//префикс каталога ustar (длинные пути)
                    slsImya = QByteArray(pZag + 345, qstrnlen(pZag + 345, 155)) + "/" + slsImya;
                quint64 ullRazmer = tarOctalPole(pZag, 124, 12);
                char cTip = pZag[156];
                QString strPut = QDir(strKatalogPriemnik)
                        .filePath(QString::fromUtf8(slsImya).trimmed());
                if(cTip == '5'){
                    if(!QDir().mkpath(strPut)){
                        strOshestka = QStringLiteral("папка не создана: ") + strPut;
                        return false;
                    }
                    continue;
                }
                blPisatVFail = (cTip == '0' || cTip == '\0');
                if(blPisatVFail){
                    QDir().mkpath(QFileInfo(strPut).absolutePath());
                    odrFail.setFileName(strPut);
                    if(!odrFail.open(QIODevice::WriteOnly | QIODevice::Truncate)){
                        strOshestka = QStringLiteral("файл не создаётся: ") + strPut;
                        return false;
                    }
                }//прочие типы (ссылки, longlink) в бандле нет - данные просто пропускаем
                ullOstatokFaila = qint64(ullRazmer);
                ullPropusk = (512 - (qint64(ullRazmer) % 512)) % 512;
                continue;
            }
            if(ullPropusk > 0 && ullOstatokFaila < 0){
                //-- выравнивание ПОСЛЕ записанных данных файла: выбрасываем --
                qint64 ullZaberu = qMin(ullPropusk, qint64(untDostupno));
                untPoziciya += int(ullZaberu);
                ullPropusk -= ullZaberu;
                if(ullPropusk > 0) break;//хвост выравнивания в следующем куске
                continue;
            }
            {//--- данные текущего файла (сначала пишем, потом выравниваем) ---
                if(ullOstatokFaila > 0){
                    qint64 ullZaberu = qMin(ullOstatokFaila, qint64(untDostupno));
                    if(ullZaberu > 0){
                        if(blPisatVFail){
                            if(odrFail.write(slsBufer.constData() + untPoziciya, int(ullZaberu))
                                    != ullZaberu){
                                strOshestka = QStringLiteral("запись файла не удалась");
                                odrFail.close();
                                return false;
                            }
                        }
                        untPoziciya += int(ullZaberu);
                        ullOstatokFaila -= ullZaberu;
                    }
                    if(untDostupno <= 0) break;
                }
                if(ullOstatokFaila == 0 && !blPisatVFail){
                    ullOstatokFaila = -1;//skip-запись без данных закончена
                } else if(ullOstatokFaila == 0){
                    odrFail.close();
                    untFailovRaspakovan++;
                    untSkopirovanoFailov++;
                    ullOstatokFaila = -1;
                }
            }
            if(untPoziciya > (8 * 1024 * 1024)){//не даём буферу расти бесконечно
                slsBufer = slsBufer.mid(untPoziciya);
                untPoziciya = 0;
            }
        }
        return true;
    }
};

static bool rashifrovatIRaspostavit(const QString& strRabochiPut,
                                    AAssetManager* pMenedjerAssets, JNIEnv* pEnv,
                                    QString& strOshestka){
    QElapsedTimer odrTajmerRaspak;
    odrTajmerRaspak.start();
    QByteArray slsLicenziyaJson;
    if(!chitatAssetPolnostyu(pMenedjerAssets, QStringLiteral("workingdata/licenziya.bin"),
                             slsLicenziyaJson)){
        strOshestka = QStringLiteral("пакет данных повреждён: нет licenziya.bin");
        return false;
    }
    QJsonObject odrLicenziya = QJsonDocument::fromJson(slsLicenziyaJson).object();
    QByteArray slsWersiya;
    chitatAssetPolnostyu(pMenedjerAssets, QStringLiteral("workingdata/bundleversion.txt"),
                         slsWersiya);
    QString strWersiyaIzPaketa = QString::fromUtf8(slsWersiya).trimmed();
    QString strKod = polAndroidIdSjni();//код этого телефона глазами приложения
    if(strKod.isEmpty()){
        strOshestka = QStringLiteral("не удалось получить код устройства");
        return false;
    }
    QString strMarkerPut = QDir(strRabochiPut).filePath(QStringLiteral(".razarkhpovano"));
    if(polWersiyuIzFaila(strMarkerPut) == strWersiyaIzPaketa
            && QFile::exists(QDir(strRabochiPut).filePath(QStringLiteral("druidcat.db"))))
        return true;//данные этой версии уже распакованы
    const QJsonArray arrUstroystva = odrLicenziya.value(QStringLiteral("devices")).toArray();
    QJsonObject odrZapis;
    for(const QJsonValue& znachenie : arrUstroystva){
        if(znachenie.toObject().value(QStringLiteral("code")).toString().compare(
                strKod, Qt::CaseInsensitive) == 0){
            odrZapis = znachenie.toObject();
            break;
        }
    }
    if(odrZapis.isEmpty()){//нет кода в таблице - развернуть DK нечем
        strOshestka = QStringLiteral("устройство не зарегистрировано (код %1); "
                                     "передайте код администратору")
                .arg(strKod);
        return false;
    }
    int untIteracii = odrLicenziya.value(QStringLiteral("iterations")).toInt(100000);
    QByteArray slsMaster = QByteArray::fromHex(QByteArray(MENTOR_MASTER_SECRET_HEX));
    //PBKDF2-HMAC-SHA256 считаем на чистом Qt: JNI PBEKeySpec не на всех
    //устройствах грузится из нативной нити.
    QByteArray sluch = pbkdf2Sha256(slsMaster,
            QByteArray::fromHex(odrZapis.value(QStringLiteral("salt")).toString().toLatin1()),
            untIteracii, 32);
    if(sluch.isEmpty()){
        strOshestka = QStringLiteral("не удалось вычислить ключ устройства");
        return false;
    }
    QByteArray slsDk = yniAesGcmRasshifrovat(pEnv, sluch,
            QByteArray::fromHex(odrZapis.value(QStringLiteral("wrap_nonce")).toString()
                                .toLatin1()),
            QByteArray::fromHex(odrZapis.value(QStringLiteral("wrap_ct")).toString()
                                .toLatin1()));
    if(slsDk.size() != 32){
        strOshestka = QStringLiteral("не удалось развернуть ключ данных (несовместимая лицензия)");
        return false;
    }
    AAsset* pBlob = AAssetManager_open(pMenedjerAssets,
            QStringLiteral("workingdata/dannie.tar.enc").toUtf8().constData(),
            AASSET_MODE_STREAMING);
    if(!pBlob){
        strOshestka = QStringLiteral("пакет данных повреждён: нет dannie.tar.enc");
        return false;
    }
    //Версия изменилась или первый запуск: старые (в т.ч. открытые из прошлых сборок)
    //файлы данных стираем целиком, распаковываем заново из расшифрованного tar.
    QDir odrRabochi(strRabochiPut);
    if(odrRabochi.exists() && !odrRabochi.removeRecursively())
        qWarning() << "DCAssets: старый каталог данных не удалён полностью:" << strRabochiPut;
    QDir().mkpath(strRabochiPut);
    QByteArray slsOsnova = QByteArray::fromHex(
            odrLicenziya.value(QStringLiteral("blob_nonce_base")).toString().toLatin1());
    TarRasparshivatel odrParser;
    odrParser.strKatalogPriemnik = strRabochiPut;
    quint64 ullSchetchik = 0;
    bool blResult = true;
    while(true){
        quint32 ullDlinaShifra = 0;
        if(!chitatRovno(pBlob, reinterpret_cast<char*>(&ullDlinaShifra), 4)){
            AAsset_close(pBlob);
            if(!odrParser.blKonec && ullSchetchik == 0){
                strOshestka = QStringLiteral("dannie.tar.enc пуст");
                return false;
            }
            break;//конец blob
        }
        if(ullDlinaShifra == 0 || ullDlinaShifra > (16u * 1024u * 1024u)){
            strOshestka = QStringLiteral("битая длина чанка в blob");
            AAsset_close(pBlob);
            blResult = false;
            break;
        }
        QByteArray slsChast(ullDlinaShifra + 4, 0);//+4 с запасом на точную установку размера
        slsChast.resize(int(ullDlinaShifra));
        if(!chitatRovno(pBlob, slsChast.data(), int(ullDlinaShifra))){
            strOshestka = QStringLiteral("обрыв blob на чанке %1").arg(ullSchetchik);
            AAsset_close(pBlob);
            blResult = false;
            break;
        }
        QByteArray slsNonce = slsOsnova;
        quint64 ullCtr = qToLittleEndian(ullSchetchik);//8 байт LE счётчик в nonce
        slsNonce.append(reinterpret_cast<const char*>(&ullCtr), 8);
        QByteArray slsPlain = yniAesGcmRasshifrovat(pEnv, slsDk, slsNonce, slsChast);
        if(slsPlain.isEmpty()){//тег GCM не сошёлся: данные или ключ повреждены
            strOshestka = QStringLiteral("ошибка расшифровки чанка %1").arg(ullSchetchik);
            AAsset_close(pBlob);
            blResult = false;
            break;
        }
        if(!odrParser.dobavitKusok(slsPlain, strOshestka)){
            AAsset_close(pBlob);
            blResult = false;
            break;
        }
        ullSchetchik++;
    }
    if(blResult && !odrParser.blKonec){
        strOshestka = QStringLiteral("архив завершился без пустого блока");
        blResult = false;
    }
    if(blResult && odrParser.untFailovRaspakovan == 0){
        strOshestka = QStringLiteral("в архиве нет файлов");
        blResult = false;
    }
    if(blResult){
        QFile odrMarker(strMarkerPut);
        if(odrMarker.open(QIODevice::WriteOnly | QIODevice::Truncate)){
            odrMarker.write(strWersiyaIzPaketa.toUtf8());
            odrMarker.close();
        }
    }
    qDebug() << "DCAssets::rashifrovatIRaspostavit: код" << strKod << ", файлов"
             << odrParser.untFailovRaspakovan << ", чанков" << ullSchetchik
             << ", время (мс)" << odrTajmerRaspak.elapsed() << ", успех" << blResult
             << "| состояние: ostatok" << odrParser.ullOstatokFaila
             << "propusk" << odrParser.ullPropusk
             << "poz" << odrParser.untPoziciya << "buf" << odrParser.slsBufer.size();
    return blResult;
}
#endif // MENTOR_DATA_ENCRYPTED
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
#ifdef MENTOR_DATA_ENCRYPTED
    Q_UNUSED(strWersiyaVKataloge)//Защищённый бандл сверяет версию по своему маркеру.
    Q_UNUSED(blForce)//Принудительная перезапись здесь не нужна: полный переразбор.
    QString strOshestkaRaspak;
    blResult = rashifrovatIRaspostavit(strRabochiPut, pMenedjerAssets, odrEnv.jniEnv(),
                                       strOshestkaRaspak);
    if(!blResult && !strOshestkaRaspak.isEmpty())
        slsPosledneyayaOshestka = strOshestkaRaspak;//сообщение уйдёт в журнал приложения
#else
    blForce = !strWersiyaIzPaketa.isEmpty() && strWersiyaIzPaketa != strWersiyaVKataloge;
    blResult = sinhronizovatKatalog("workingdata", strRabochiPut, odrAssets, pMenedjerAssets,
                                    odrEnv.jniEnv(), blForce);
#endif // MENTOR_DATA_ENCRYPTED
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

QString DCAssets::polPosledneyayaOshestka(){//Текст ошибки распаковки пакета (пусто если ок).
#if defined(MENTOR_DATA_ENCRYPTED) && defined(MENTOR_DB_MOBILE)
    return slsPosledneyayaOshestka;
#else
    return QString();
#endif // MENTOR_DATA_ENCRYPTED && MENTOR_DB_MOBILE
}
