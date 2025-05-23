﻿#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> //Библиотека соединяющая через контекст cpp с qml
#include <QIcon>//Иконки.
#include <QDebug>//Отладка.
#include <QQuickWindow>

#include "cppqml.h"

int main(int argc, char *argv[])
{
	//TODO В Qt6 закоментировать данную строку.
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/icons/86x86/ru.WorkingDiagrams.png"));//Выставляем иконку приложения.
    //Qt5 Устанавливаем кодировку UTF-8 во всём проекте и в БД. В Qt6 UTF8 по умолчанию.
    //QTextCodec* ptxcCodec = QTextCodec::codecForName("UTF-8");
    //QTextCodec::setCodecForLocale(ptxcCodec);
    QLocale::setDefault(QLocale(QLocale::Russian, QLocale::Russia));//Настройка локали на кирилицу.
    DCCppQml odccppqml;//Создаём объект для движка, который соединит cpp с qml
    QQmlApplicationEngine engine;//Создаём движок qml после объекта C++, иначе ошибки debug при закрытии будут
    engine.addImportPath("qrc:/qml");//Необходимо, чтоб работал qmldir в qml.
    const QUrl url(QStringLiteral("qrc:/qml/ru.WorkingDiagrams.qml"));
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
