﻿#ifndef DATADANNIE_H
#define DATADANNIE_H

#include <QObject>

#include "dcdb.h"
#include "dcclass.h"

class DataDannie : public QObject {
     Q_OBJECT
public:
    explicit	DataDannie(QString strImyaDB, QString strImyaDBData, QString strLoginDB, QString strParolDB,
                           QObject* proditel = nullptr);//Конструктор
    ~			DataDannie();//Деструктор
    bool 		dbStart();//Создать первоначальные Данные.
	void 		ustWorkingDiagrams(QString strWorkingDiagramsPut);//Задаём каталог хранения Документов.
    QStringList	polDannie(quint64 ullKodSpisok, quint64 ullKodElement);//Получить список всех Данных.
    bool 		ustDannie(quint64 ullKodSpisok, quint64 ullKodElement, QString strDannie);//Записать в БД.
    bool 		renDannie(quint64 ullKodSpisok,quint64 ullKodElement,QString strDannie,QString strDannieNovi);
    QString		polDannieJSON(quint64 ullKodSpisok, quint64 ullKodElement);//Получить JSON строчку Данных.
    bool 		polDanniePervi() { return m_blDanniePervi; }//Вернуть состояние флага Первые Данные?
	void 		ustFileDialogPut(QString strFileDialogPut);//Задать путь к каталогу, в котором файл записи.
    QString 	polImyaFaila(qint64 ullSpisok, qint64 ullElement, qint64 ullDannie);//Получить имя файла.
    bool  		estImyaFaila(QString strImyaFaila);//Есть такой файл в каталоге?
    bool  		udalImyaFaila(QString strImyaFaila);//Удалить файл в каталоге.
    bool 		copyDannie(QString strAbsolutPut, QString strImyaFaila);//Копируем файл в приложение.

private:
    bool 		m_blDanniePervi;//Первый элемент в Данных.
    DCDB* 		m_pdbDannie = nullptr;//Указатель на базу данных таблицы данных.
    DCClass* 	m_pdcclass = nullptr;//Указатель на мой класс с методами.

    QString 	m_strImyaDB;//Имя БД
    QString 	m_strImyaDBData;//Имя БД данных.
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД
	QString 	m_strFileDialogPut;//Путь к каталогу, в котором лежит файл для записи.
	QString 	m_strWorkingDiagramsPut;//Каталог хранения документов.

private slots:
    void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
    void		signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог

};

#endif // DATADANNIE_H
