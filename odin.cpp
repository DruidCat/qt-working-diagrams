#include "odin.h"

Odin::Odin(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent) : QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    //Настройки соединения к БД Настроек.
    m_strImyaBD = strImyaBD;//Имя локальной базы данных.
    m_strLoginBD = strLoginBD;//Логин локальной базы данных.
    m_strParolBD = strParolBD;//Пароль локальной базы данных.

    m_pdbOdin = new DCDB("QSQLITE", m_strImyaBD, "один");//Таблица с данными по Подключ.
    m_pdbOdin->setUserName(m_strLoginBD);//Пользователь.
    m_pdbOdin->setPassword(m_strParolBD);//Устанавливаем пароль.
    m_pdbOdin->CREATE(QStringList()<<"#Код"<<"Номер"<<"Название"<<"Описание"<<"Список");
}

Odin::~Odin(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbOdin;//Удаляем указатель на БД Один
    m_pdbOdin = nullptr;//Обнуляем указатель.
}

bool Odin::dbStart() {//Иннициализируем БД, и записываем в нёё данные, если она пустая.
///////////////////////////////////////////
//---З А П И С Ы В А Е М   Д А Н Н Ы Е---//
///////////////////////////////////////////
    if(!m_pdbOdin->SELECT()){//Если нет ни одной записи в таблице, то...
        if(m_pdbOdin->INSERT(QStringList()<<"Номер"<<"Название"<<"Описание"<<"Список",
                              QStringList()<<"1"<<"Формовка"<<"Описание участка формовки."<<"")){
            if(m_pdbOdin->INSERT(QStringList()<<"Номер"<<"Название"<<"Описание"<<"Список",
                                  QStringList()<<"2"<<"Сварка"<<"Описание участка сварки."<<"")){
                if(!m_pdbOdin->INSERT(QStringList()<<"Номер"<<"Название"<<"Описание"<<"Список",
                                       QStringList()<<"3"<<"Отделка"<<"Описание участка отделки."<<"")){
                    return false;//Выход, ошибка.
                }
            }
            else//В противном случае...
                return false;//Выход, ошибка.
        }
        else//Если БД не отрылась, то...
            return false;//Выход, ошибка.
    }
    return true;//Выход, успех!
}

QString Odin::polOdin(int ntNomer) {//Получить данные по номеру
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е---//
///////////////////////////////////////////
    QString strNazvanie = m_pdbOdin->SELECT("Номер", QString::number(ntNomer), "Название");
    return strNazvanie;
}


QString Odin::polOdinJSON() {//Получить JSON строчку первой вкладки (участки).
/////////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   П Е Р В О Й   В К Л А Д К И---//
/////////////////////////////////////////////////////////////////
	QString strOdinJSON("");//Строка, в которой будет собран JSON запрос.
	quint64 ullKolichestvo = m_pdbOdin->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo)//Если ноль, то...
		return strOdinJSON;//Возвращаем пустую строку.
	//Пример: [{"nomer":"1","uchastok":"формовка"},{"nomer":"2","uchastok":"сварка"}]
	strOdinJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
		strOdinJSON = strOdinJSON + "{\"nomer\":\"";//Начало списка объектов.
    	strOdinJSON = strOdinJSON + m_pdbOdin->SELECT("Код", QString::number(ullShag), "Номер");
		strOdinJSON = strOdinJSON + "\",\"uchastok\":\"";
    	strOdinJSON = strOdinJSON + m_pdbOdin->SELECT("Код", QString::number(ullShag), "Название");
		strOdinJSON = strOdinJSON + "\",\"opisanie\":\"";
    	strOdinJSON = strOdinJSON + m_pdbOdin->SELECT("Код", QString::number(ullShag), "Описание");
		strOdinJSON = strOdinJSON + "\"}";//Конец списка объектов.
		if(ullShag<ullKolichestvo)//Если это не последний список объектов, то..
			strOdinJSON = strOdinJSON + ",";//ставим запятую.
	}
	strOdinJSON = strOdinJSON + "]";//Конец массива объектов.

	return strOdinJSON;
}
