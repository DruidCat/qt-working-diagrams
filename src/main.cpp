#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> //Библиотека соединяющая через контекст cpp с qml
#include <QIcon>//Иконки.
#include <QFontDatabase>
#include <QFont>
#include <QDebug>//Отладка.
#include <QQuickWindow>

#include "cppqml.h"

int main(int argc, char *argv[])
{
	//TODO В Qt6 закоментировать данную строку.
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
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
    engine.addImportPath("qrc:/qml");//Необходимо, чтоб работал qmldir в qml.
    const QUrl url(QStringLiteral("qrc:/qml/ru.Mentor.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    QQmlContext* pkornevoiKontekst = engine.rootContext();//Создаём корневой контекс
    pkornevoiKontekst->setContextProperty("cppqml", &odccppqml);//Передаём имя и объект
    engine.load(url);
    return app.exec();
}
