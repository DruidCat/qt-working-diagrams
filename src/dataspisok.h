#ifndef DATASPISOK_H
#define DATASPISOK_H

#include <QObject>

#include "dcdb.h"
#include "dcclass.h"

class DataSpisok : public QObject {
    Q_OBJECT
public:
    explicit	DataSpisok(QString strImyaDB, QString strLoginDB, QString strParolDB,
                           QObject* proditel = nullptr);//Конструктор
    ~			DataSpisok();//Деструктор.
    bool		dbStart();//Иннициализируем БД, и записываем в нёё данные, если она пустая.
    QString		polSpisok(quint64 ullKod);//Получить название элемента Списка по Коду.
	QStringList	polSpisok();//Получить полный список всех элементов Списка.
	bool 		ustSpisok(QString strSpisok);//Записать в БД элемент списка.
	bool 		renSpisok(QString strSpisok, QString strSpisokNovi);//Переименовать в БД элемент списка.
    QString		polSpisokJSON();//Получить JSON строчку Списка
	QString 	polSpisokOpisanie(quint64 ullKod);//Полчить Описание элемента Списка по Коду.
	bool 		ustSpisokOpisanie(quint64 ullKod, QString strSpisokOpisanie);//Записать в БД описание списка
	quint64 	polKod(QString strSpisok);//Получить Код по названию элемента списка.
    bool 		polSpisokPervi() { return m_blSpisokPervi; }//Вернуть состояние флага Первый Список?

private:
    bool 		m_blSpisokPervi;//Первый Список в Списке.
    DCDB* 		m_pdbSpisok = nullptr;//Указатель на базу данных таблицы списков.
	DCClass* 	m_pdcclass = nullptr;//Указатель на мой класс с методами.
	
	QStringList m_slsSpisok;//Переменная хранящая в себе прочитаный из БД список элементов Списка.
    QString 	m_strImyaDB;//Имя БД
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД

private slots:
	void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATASPISOK_H
