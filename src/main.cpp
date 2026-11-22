#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> //Библиотека соединяющая через контекст cpp с qml
#include <QIcon>//Иконки.
#include <QFontDatabase>
#include <QFont>
#include <QDebug>//Отладка.
#include <QQuickWindow>
#include <QSysInfo>//Определение ОС по /etc/os-release (ID=auroraos на Авроре).

#include "cppqml.h"

int main(int argc, char *argv[])
{
	//TODO В Qt6 закоментировать данную строку.
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    // Аврора: экранная клавиатура maliit подключается плагином platforminputcontexts.
    // QPA wayland выбирает его по QT_IM_MODULE=maliit (qwaylandintegration.cpp,
    // reconfigureInputContext). Переменную нужно выставить до создания QGuiApplication,
    // до загрузки платформенной интеграции. На других ОС окружение не трогаем.
    // QT_QPA_WAYLAND_ROTATION=1 включает в плагине maliit трансформацию прямоугольника
    // клавиатуры под client-side поворот (наш ротационный QPA, auroraos/6 ветка maliit).
    // QT_QPA_WAYLAND_AUTO_KEYBOARD_RESIZE=1 — при вызове клавиатуры плагин сам сужает
    // окно фокуса, чтобы поле ввода не перекрывалось (при скрытии геометрия возвращается).
    // MALIIT_SERVER_ADDRESS — адрес приватного D-Bus сокета maliit-server из
    // XDG_RUNTIME_DIR. Внутри песочницы firejail сессионная шина проксируется и
    // запрос адреса org.maliit.server может не вернуться; фиксированный адрес
    // заставляет плагин подключаться к сокету напрямую (minputcontext.cpp, FixedAddress).
    if (QSysInfo::productType().compare(QStringLiteral("auroraos"), Qt::CaseInsensitive) == 0) {
        qputenv("QT_IM_MODULE", QByteArrayLiteral("maliit"));
        qputenv("QT_QPA_WAYLAND_ROTATION", QByteArrayLiteral("1"));
        qputenv("QT_QPA_WAYLAND_AUTO_KEYBOARD_RESIZE", QByteArrayLiteral("1"));
        const QByteArray rtDir = qgetenv("XDG_RUNTIME_DIR");
        if (!rtDir.isEmpty())
            qputenv("MALIIT_SERVER_ADDRESS", "unix:path=" + rtDir + "/maliit-server/dbus-socket");
    }

    QGuiApplication app(argc, argv);
    app.setApplicationVersion(QStringLiteral(APP_VERSION));//<-Cюда попадает автоверсия из CMakeLists.txt<-git
    app.setWindowIcon(QIcon(":/icons/86x86/ru.Mentor.png"));//Выставляем иконку приложения.
    //Qt5 Устанавливаем кодировку UTF-8 во всём проекте и в БД. В Qt6 UTF8 по умолчанию.
    //QTextCodec* ptxcCodec = QTextCodec::codecForName("UTF-8");
    //QTextCodec::setCodecForLocale(ptxcCodec);
    QLocale::setDefault(QLocale(QLocale::Russian, QLocale::Russia));//Настройка локали на кирилицу.

    // Загружаем шрифт до загрузки qml движка.
    int fontId = QFontDatabase::addApplicationFont(":/fonts/verdana.ttf");
    if(fontId == -1)
        qWarning()<<"main.cpp Не удалось загрузить шрифт!";
    else{
        QStringList loadedFamilies = QFontDatabase::applicationFontFamilies(fontId);
        if (!loadedFamilies.isEmpty()){
            QString fontFamily = loadedFamilies.at(0);
            QFont defaultFont(fontFamily);
            app.setFont(defaultFont);
        }
        else
            qWarning()<<"main.cpp Шрифт загружен, но не найдены семейства шрифта.";
    }

    DCCppQml odccppqml;//Создаём объект для движка, который соединит cpp с qml
    QQmlApplicationEngine engine;//Создаём движок qml после объекта C++, иначе ошибки debug при закрытии будут
    //Задача #773: объект-мост должен уметь вызывать retranslate() страниц при смене языка (strYazik).
    odccppqml.ustQmlEngine(&engine);//Передаём движок объекту cppqml.
    engine.addImportPath("qrc:/qml");//Необходимо, чтоб работал qmldir в qml.
    const QUrl url(QStringLiteral("qrc:/qml/ru.Mentor.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    QQmlContext* pkornevoiKontekst = engine.rootContext();//Создаём корневой контекс
    pkornevoiKontekst->setContextProperty("cppqml", &odccppqml);//Передаём имя и объект
    //На Авроре QSysInfo::productType() равно "auroraos" (поле ID из /etc/os-release на устройстве).
    //Qt.platform.os на Авроре возвращает "linux", отличить его от десктопа нельзя, поэтому проверка здесь.
    pkornevoiKontekst->setContextProperty("osAurora",
            QSysInfo::productType().compare(QStringLiteral("auroraos"), Qt::CaseInsensitive) == 0);
    //Задача #28: сборка MENTOR_DB_MOBILE=ON (база и документы в пакете). QML по этому
    //флагу принудительно выключает РЕЖИМ АДМИНИСТРАТОРА (isAdmin), правка базы запрещена.
#ifdef MENTOR_DB_MOBILE
    pkornevoiKontekst->setContextProperty("dbMobileMode", true);
#else
    pkornevoiKontekst->setContextProperty("dbMobileMode", false);
#endif
    engine.load(url);
    return app.exec();
}
