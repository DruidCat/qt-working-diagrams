#ifndef DATASOSTAV_H
#define DATASOSTAV_H

#include <QObject>

#include "dcdb.h"

class DataSostav : public QObject {
    Q_OBJECT
public:
    explicit	DataSostav(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent = nullptr);
    ~			DataSostav();//Деструктор.
private:
    DCDB* m_pdbSostav = nullptr;//Указатель на базу данных таблицы.
	void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

    QString 	m_strImyaBD;//Имя БД
    QString 	m_strLoginBD;//Логин БД
    QString 	m_strParolBD;//Пароль БД

signals:
	void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATASOSTAV_H
