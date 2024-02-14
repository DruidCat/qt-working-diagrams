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
	QStringList	polElement(quint64 ullKod);//Получить полный список всех Элементов по Коду Списка.
	bool 		ustElement(quint64 ullKod, QString strElement);//Записать в БД Элемент.
    QString		polElementJSON(quint64 ullKod);//Получить JSON строчку Элементов. 
	bool 		polElementPervi() { return m_blElementPervi; }//Вернуть состояние флага Первый Элемент?
private:
    QString 	m_strImyaDB;//Имя БД
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД

	bool 		m_blElementPervi;//Первый Элемент в Списке элементов.

private slots:
	void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATAELEMENT_H
