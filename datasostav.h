#ifndef DATASOSTAV_H
#define DATASOSTAV_H

#include <QObject>
#include "dcdb.h"

class DataSostav : public QObject {
    Q_OBJECT
public:
    explicit	DataSostav(QString strImyaDB, QString strLoginDB, QString strParolDB,
					uint untSpisokKolichestvo, QObject* parent = nullptr);
    ~			DataSostav();//Деструктор.
	bool 		dbStart(quint64 ullKod);//Создать класс БД элемента Списка.
private:
	void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

	QVector<DCDB*>* 	m_pvctDBSpisok = nullptr;//Динамическое создание классов БД для разный элементов Списка.
    QString 	m_strImyaDB;//Имя БД
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД
	uint 		m_untSpisokKolichestvo;//Количество элементов Списка.
	quint64 	m_ullKod;//Код, по которому можно найти класс Списка.

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATASOSTAV_H
