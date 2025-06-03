#ifndef DATATITUL_H
#define DATATITUL_H

#include <QObject>

#include "dcdb.h"
#include "dcclass.h"

class DataTitul : public QObject {
    Q_OBJECT
public:
    explicit	DataTitul(QString strImyaDB, QString strLoginDB, QString strParolDB, QObject* parent = nullptr);
    ~			DataTitul();//Деструктор.
    bool		dbStart();//Иннициализируем БД, и записываем в нёё данные, если она пустая.
	QString	polTitul();//Получить Титул.
	bool 		renTitul(QString strTitulNovi);//Переименовать в БД Титул.
	QString 	polTitulOpisanie();//Полчить Описание Титула.
	bool 		renTitulOpisanie(QString strOpisanie);//Переименовать в БД Описание Титула.
    DCDB*		polPDB();//Получить указатель на БД Титула.

private:
    DCDB* 		m_pdbTitul = nullptr;//Указатель на базу данных таблицы 
	DCClass* 	m_pdcclass = nullptr;//Указатель на мой класс с методами.
	
	QString 	m_strTitul;//Переменная хранящая в себе прочитаный из БД
	QString 	m_strOpisanie;//Переменная хранящая в себе прочитаный из БД
    QString 	m_strImyaDB;//Имя БД
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД

private slots:
	void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
};
#endif // DATATITUL_H
