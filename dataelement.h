#ifndef DATAELEMENT_H
#define DATAELEMENT_H

#include <QObject>
#include "dcdb.h"

class DataElement : public QObject {
    Q_OBJECT
public:
    explicit	DataElement(QString strImyaDB, QString strLoginDB, QString strParolDB,
					QObject* parent = nullptr);
    ~			DataElement();//Деструктор.
	bool 		dbStart(quint64 ullKod);//Создать класс БД элемента Списка.
private:

    QString 	m_strImyaDB;//Имя БД
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД
	quint64 	m_ullKod;//Код, по которому можно найти класс Списка.

private slots:
	void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATAELEMENT_H
