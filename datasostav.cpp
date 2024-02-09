#include "datasostav.h"

DataSostav::DataSostav(QString strImyaDB, QString strLoginDB, QString strParolDB, uint untSpisokKolichestvo,
		QObject* parent) : QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.
	m_untSpisokKolichestvo = untSpisokKolichestvo;//Количество классов БД Списка.
	m_ullKod = 0;//Нулевой, такого не будет создано. По 0 будет проверка при создании класса БД.
	m_pvctDBSpisok = new QVector<DCDB*>(untSpisokKolichestvo);//Создание классов БД для разный элементов Списка
}
DataSostav::~DataSostav(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
	delete m_pvctDBSpisok;//Удаляем указатель вектора классов БД для разный элементов Списка.
	m_pvctDBSpisok = nullptr;//Облуляем указатель на QVector
}
bool DataSostav::dbStart(quint64 ullKod){//Создать класс БД элемента Списка.
	m_pvctDBSpisok->operator[](ullKod)->ustDriverDB("QSQLITE");
/*
	m_pvctDBSpisok->at(ullKod)->ustImyaDB("состав_"+QString::number(ullKod));
	m_pvctDBSpisok->at(ullKod)->setUserName(m_strLoginDB);//Пользователь.
	m_pvctDBSpisok->at(ullKod)->setPassword(m_strParolDB);//Устанавливаем пароль.
	m_pvctDBSpisok->at(ullKod)->CREATE(QStringList()<<"#Код"<<"Номер"<<"Состав"<<"Описание");
 	m_pvctDBSpisok->at(ullKod)->INSERT(QStringList()<<"Номер"<<"Состав"<<"Описание",
                              QStringList()<<"1"<<"ФОРМОВКА"<<"Описание");
	QString strSostav = m_pvctDBSpisok->at(ullKod)->SELECT("Номер", QString::number(1), "Состав");
	qDebug()<<strSostav;
*/
	return true;
}
void DataSostav::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
