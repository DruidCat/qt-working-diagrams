#ifndef DATASPISOK_H
#define DATASPISOK_H

#include <QObject>

#include "dcdb.h"

class DataSpisok : public QObject {
    Q_OBJECT
public:
    explicit	DataSpisok(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent = nullptr);
    ~			DataSpisok();//Деструктор.
    bool		dbStart();//Иннициализируем БД, и записываем в нёё данные, если она пустая.
    QString		polSpisok(quint64 ullKod);//Получить название элемента Списка по Коду.
	QStringList	polSpisok();//Получить полный список всех элементов Списка.
	bool 		ustSpisok(QString strSpisok);//Записать в БД элемент списка.
    QString		polSpisokJSON();//Получить JSON строчку Списка
	QString 	polSpisokOpisanie(quint64 ullKod);//Полчить Описание элемента Списка по Коду.
	bool 		ustSpisokOpisanie(quint64 ullKod, QString strSpisokOpisanie);//Записать в БД описание списка

private:
    DCDB* m_pdbSpisok = nullptr;//Указатель на базу данных таблицы списков.
	void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог
	
	QStringList m_slsSpisok;//Переменная хранящая в себе прочитаный из БД список элементов Списка.
    QString 	m_strImyaBD;//Имя БД
    QString 	m_strLoginBD;//Логин БД
    QString 	m_strParolBD;//Пароль БД

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATASPISOK_H
