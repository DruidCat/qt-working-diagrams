#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> //Библиотека соединяющая через контекст cpp с qml

#include "cppqml.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Устанавливаем кодировку UTF-8 во всём проекте и в БД в первую очередь.
    QTextCodec* ptxcCodec = QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForLocale(ptxcCodec);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/ru.WorkingDiagrams.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

	DCCppQml odccppqml;//Создаём объект для движка, который соединит cpp с qml
    QQmlContext* pkornevoiKontekst = engine.rootContext();//Создаём корневой контекс
    pkornevoiKontekst->setContextProperty("cppqml", &odccppqml);//Передаём имя и объ

    engine.load(url);

    return app.exec();
}
