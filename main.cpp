#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> //Библиотека соединяющая черер контекст cpp c qml

#include "cppqml.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qt-working-diagrams/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    DCCppQml odccppqml;//Создаём объект для движка, который соединит cpp c qml
    QQmlContext* pkornevoiKontekst = engine.rootContext();//создаём конревой контек>
    pkornevoiKontekst->setContextProperty("cppqml", &odccppqml);//передаём имя и об>

    engine.load(url);
    return app.exec();
}

