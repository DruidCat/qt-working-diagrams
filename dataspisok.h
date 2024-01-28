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
    QString		polSpisok(uint untNomer);//Получить название элемента Списка по номеру.
    QString		polSpisokJSON();//Получить JSON строчку Списка
	QString 	polSpisokOpisanie(uint untNomer);//Полчить Описание элемента Списка по номеру.
	bool 		ustSpisokOpisanie(uint untNomer, QString strSpisokOpisanie);//Записать в БД описание списка.

private:
    DCDB* m_pdbSpisok = nullptr;//Указатель на базу данных таблицы списков.
	void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог
								  
    QString m_strImyaBD;//Имя БД
    QString m_strLoginBD;//Логин БД
    QString m_strParolBD;//Пароль БД

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};

#endif // DATASPISOK_H
