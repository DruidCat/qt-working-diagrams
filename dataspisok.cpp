#include "dataspisok.h"

DataSpisok::DataSpisok(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent) : QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    //Настройки соединения к БД Настроек.
    m_strImyaBD = strImyaBD;//Имя локальной базы данных.
    m_strLoginBD = strLoginBD;//Логин локальной базы данных.
    m_strParolBD = strParolBD;//Пароль локальной базы данных.

    m_pdbSpisok = new DCDB("QSQLITE", m_strImyaBD, "список");//Таблица с данными по Подключ.
    m_pdbSpisok->setUserName(m_strLoginBD);//Пользователь.
    m_pdbSpisok->setPassword(m_strParolBD);//Устанавливаем пароль.
    m_pdbSpisok->CREATE(QStringList()<<"#Код"<<"Номер"<<"Список"<<"Описание"<<"Состав");
}

DataSpisok::~DataSpisok(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbSpisok;//Удаляем указатель на БД Спмска
    m_pdbSpisok = nullptr;//Обнуляем указатель.
}

bool DataSpisok::dbStart() {//Иннициализируем БД, и записываем в нёё данные, если она пустая.
///////////////////////////////////////////
//---З А П И С Ы В А Е М   Д А Н Н Ы Е---//
///////////////////////////////////////////
    if(!m_pdbSpisok->SELECT()){//Если нет ни одной записи в таблице, то...
        if(m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
                              QStringList()<<"1"<<"Формовка"<<"Описание участка формовки."<<"")){
            if(m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
                                  QStringList()<<"2"<<"Сварка"<<"Описание участка сварки."<<"")){
                if(!m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
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

QString DataSpisok::polSpisok(int ntNomer) {//Получить данные по номеру
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е---//
///////////////////////////////////////////
    QString strSpisok = m_pdbSpisok->SELECT("Номер", QString::number(ntNomer), "Список");
    return strSpisok;
}

QString DataSpisok::polSpisokJSON() {//Получить JSON строчку Списка.
///////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   С П И С К А---//
///////////////////////////////////////////////////////////////
    QString strSpisokJSON("");//Строка, в которой будет собран JSON запрос.
    quint64 ullKolichestvo = m_pdbSpisok->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo)//Если ноль, то...
        return strSpisokJSON;//Возвращаем пустую строку.
    //Пример: [{"nomer":"1","spisok":"формовка"},{"nomer":"2","spisok":"сварка"}]
    strSpisokJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        strSpisokJSON = strSpisokJSON + "{\"nomer\":\"";//Начало списка объектов.
        strSpisokJSON = strSpisokJSON + m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Номер");
        strSpisokJSON = strSpisokJSON + "\",\"spisok\":\"";
        strSpisokJSON = strSpisokJSON + m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Список");
        strSpisokJSON = strSpisokJSON + "\",\"opisanie\":\"";
        strSpisokJSON = strSpisokJSON + m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Описание");
        strSpisokJSON = strSpisokJSON + "\"}";//Конец списка объектов.
		if(ullShag<ullKolichestvo)//Если это не последний список объектов, то..
            strSpisokJSON = strSpisokJSON + ",";//ставим запятую.
	}
    strSpisokJSON = strSpisokJSON + "]";//Конец массива объектов.

    return strSpisokJSON;
}
