#include "datasostav.h"

DataSostav::DataSostav(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent)
	: QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    //Настройки соединения к БД Настроек.
    m_strImyaBD = strImyaBD;//Имя локальной базы данных.
    m_strLoginBD = strLoginBD;//Логин локальной базы данных.
    m_strParolBD = strParolBD;//Пароль локальной базы данных.
/*
    m_pdbSpisok = new DCDB("QSQLITE", m_strImyaBD, "список");//Таблица с данными по Подключ.
    m_pdbSpisok->setUserName(m_strLoginBD);//Пользователь.
    m_pdbSpisok->setPassword(m_strParolBD);//Устанавливаем пароль.
    m_pdbSpisok->CREATE(QStringList()<<"#Код"<<"Номер"<<"Список"<<"Описание"<<"Состав");
*/
}
DataSostav::~DataSostav(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbSostav;//Удаляем указатель на БД Спмска
    m_pdbSostav = nullptr;//Обнуляем указатель.
}
void DataSostav::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
