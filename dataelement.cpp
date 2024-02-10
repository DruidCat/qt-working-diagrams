#include "dataelement.h"

DataElement::DataElement(QString strImyaDB, QString strLoginDB, QString strParolDB, QObject* parent)
	: QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.
	m_ullKod = 0;//Нулевой, такого не будет создано. По 0 будет проверка при создании класса БД.
}
DataElement::~DataElement(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
}
bool DataElement::dbStart(quint64 ullKod){//Создать класс БД элемента Списка.
	return true;
}
void DataElement::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
