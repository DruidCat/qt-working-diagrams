#include "datatitul.h"

DataTitul::DataTitul(QString strImyaDB, QString strLoginDB, QString strParolDB, QObject* proditel)
    : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
	m_pdcclass = new DCClass();//Мой класс с методами по работе с текстом.
	m_strTitul.clear();//Пустой 
	m_strOpisanie.clear();//Пустой 
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.

    m_pdbTitul = new DCDB("QSQLITE", m_strImyaDB, "титул");//Таблица с данными по Подключ.
    m_pdbTitul->setUserName(m_strLoginDB);//Пользователь.
    m_pdbTitul->setPassword(m_strParolDB);//Устанавливаем пароль.
    m_pdbTitul->CREATE(QStringList()<<"#Код"<<"Номер"<<"Титул"<<"Описание");
	connect(	m_pdbTitul,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
}
DataTitul::~DataTitul(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbTitul;//Удаляем указатель на БД Спмска
    m_pdbTitul = nullptr;//Обнуляем указатель.
	delete m_pdcclass;//Удаляем указатель
	m_pdcclass = nullptr;//Обнуляем указатель.
}
bool DataTitul::dbStart() {//Иннициализируем БД, и записываем в нёё данные, если она пустая.
///////////////////////////////////////////
//---З А П И С Ы В А Е М   Д А Н Н Ы Е---//
///////////////////////////////////////////
    QString strTitul = tr("ТМК");
    QString strOpisanie = tr("Описание вашего списка.");
    if(!m_pdbTitul->SELECT()){//Если нет ни одной записи в таблице, то...
        if(m_pdbTitul->INSERT(QStringList()<<"Номер"<<"Титул"<<"Описание",
                              QStringList()<<"1"<<strTitul<<strOpisanie)){
			return true;//Успех
        }
        else//Если БД не отрылась, то...
            return false;//Выход, ошибка.
    }
    return true;//Выход, успех!
}

QString	DataTitul::polTitul(){//Получить Титул.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е   Т И Т У Л А---//
/////////////////////////////////////////////////////////
    QString strTitul = m_pdbTitul->SELECT("Код", "1", "Титул");//Читаем имя Титула из БД.
	if(strTitul.isEmpty())//Если Титул пустой, то...
        qdebug(tr("DataTitul::polTitul(): Пустое имя титула."));
	m_strTitul = strTitul;//Приравниваем.
    return strTitul;
}
bool DataTitul::renTitul(QString strTitulNovi){//Переименовать в БД имя титула.
/////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   И М Я   Т И Т У Л А---//
/////////////////////////////////////////////////////////
    if(m_pdbTitul->UPDATE("Титул", QStringList()<<m_strTitul<<strTitulNovi))
		return true;//Успех
	return false;//Неудача
}
QString	DataTitul::polTitulOpisanie(){//Получить Описание Титула.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Т И Т У Л А---//
/////////////////////////////////////////////////////////
    QString strOpisanie = m_pdbTitul->SELECT("Код", "1", "Описание");//Читаем Описание Титула из БД.
	if(strOpisanie.isEmpty())//Если описание Титула пустое, то...
        qdebug(tr("DataTitul::polOpisanie(): Пустое описание титула."));
	m_strOpisanie = strOpisanie;//Приравниваем.
    return strOpisanie;
}
bool DataTitul::renTitulOpisanie(QString strOpisanieNovi){//Переименовать в БД описание титула.
///////////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   О П И С А Н И Е   Т И Т У Л А---//
///////////////////////////////////////////////////////////////////
    if(m_pdbTitul->UPDATE("Описание", QStringList()<<m_strOpisanie<<strOpisanieNovi))
		return true;//Успех
	return false;//Неудача
}
void DataTitul::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
