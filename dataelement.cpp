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
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_"+QString::number(ullKod));
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица создалась, то
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return true;//Успех
	}
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем
	qdebug("DataElement::dbStart(quint64) - ошибка создания таблицы элемент_"+QString::number(ullKod));
	return false;//Ошибка.
}
void DataElement::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
