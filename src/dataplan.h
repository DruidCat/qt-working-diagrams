﻿#ifndef DATAPLAN_H
#define DATAPLAN_H

#include <QObject>
#include <QDir>
#include <QDebug>

#include "copyplan.h"

class DataPlan : public QObject {
     Q_OBJECT
public:
    explicit	DataPlan(QString strMentorPut, quint64 ullDannieMax, QObject* proditel = nullptr);
    ~			DataPlan();//Деструктор
    bool 		dbStart();//Создать первоначальные Данные.
    void 		ustMentor(QString strMentorPut);//Задаём каталог хранения Документов.
    QString 	polMentor(void){ return m_strMentorPut; }//Получить путь к каталогу файлов
    bool 		ustPlan(quint64 ullSpisokKod, quint64 ullElementKod, QString strFail);
    bool 		polPlanPervi(qint64 ullSpisokKod,qint64 ullElementKod);//Первый План?
	void 		ustFileDialogPut(QString strFileDialogPut);//Задать путь к каталогу, в котором файл записи.
    QString 	polImyaFaila(qint64 ullSpisokKod,qint64 ullElementKod);//Получить имя файл
    bool  		estImyaFaila(QString strImyaFaila);//Есть такой файл в каталоге?
    bool  		udalFail(QString strImyaFaila);//Удалить файл в каталоге.
    bool  		udalDannieFaili(quint64 ullSpisokKod, quint64 ullElementKod);//Удалить все файлы Элемента.
    bool 		copyPlan(QString strAbsolutPut, QString strImyaFaila);//Копируем файл в приложение.

private:
    bool 		m_blPlanPervi;//Первый элемент в Данных.
    quint64 	m_ullDannieMax;//Максимальное количество Документов в Элементе.
    CopyPlan*	m_pcopyplan = nullptr;//Указатель на поток копирования файла.

	QString 	m_strFileDialogPut;//Путь к каталогу, в котором лежит файл для записи.
    QString 	m_strMentorPut;//Каталог хранения документов.

private slots:
    void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог
    void 		slotCopyPlan(bool);//слот статуса скопированного документа true - скопирован, false - нет

signals:
    void		signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
    void  		signalFileDialogCopy(bool);//Сигнал статуса скопированного документа.
};

#endif // DATAPLAN_H
