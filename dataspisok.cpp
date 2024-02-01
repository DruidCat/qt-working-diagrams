#include "dataspisok.h"

DataSpisok::DataSpisok(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent) : QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
	m_slsSpisok.clear();//Пустой список элементов Списка.
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
	QString strOpisanieFormovki = "Описание участка формовки.";
	QString strOpisanieSvarki = "Описание участка сварки.";
	QString strOpisanieOtdelki = "Описание участка отделки. Оборудование участка распологается со второго по четвёртый пролёт. Начало участки на 28 оси второго пролёта начинается на Транспорте 5. Оканчивается на 28 оси третьего пролёта Транспорта 9. Так же на Оси 47 есть перекатная телега с третьего в четвёртый пролёт. На участке много разнообразных акрегатов, это Транспорты 5, 6, 7, 8, 9. Это Экспандер 1 и 2, это агрегат шлифования сварочных швов. Также это две ультразвуковые остановки проверки качества сварочного шва.";
    if(!m_pdbSpisok->SELECT()){//Если нет ни одной записи в таблице, то...
        if(m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
                              QStringList()<<"1"<<"ФОРМОВКА"<<strOpisanieFormovki<<"")){
            if(m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
                                  QStringList()<<"2"<<"СВАРКА"<<strOpisanieSvarki<<"")){
                if(!m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
                                       QStringList()<<"3"<<"ОТДЕЛКА"<<strOpisanieOtdelki<<"")){
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
QString DataSpisok::polSpisok(uint untNomer) {//Получить название элемента Списка по номеру.
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е---//
///////////////////////////////////////////
	if (untNomer <=0){//Если номер меньше или равен 0, то...
		qdebug("DataSpisok::polSpisok(uint untNomer): untNomer меньше или равен 0");//Транслируем ошибку.
		return "";//Возвращаем пустую строку.
	}
    QString strSpisok = m_pdbSpisok->SELECT("Номер", QString::number(untNomer), "Список");
    return strSpisok;
}
QStringList	DataSpisok::polSpisok(){//Получить полный список всех элементов Списка.
///////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К---//
///////////////////////////////////////
	return m_slsSpisok;//Возвращаем полный список элементов Списка.
}
QString DataSpisok::polSpisokJSON() {//Получить JSON строчку Списка.
///////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   С П И С К А---//
///////////////////////////////////////////////////////////////
    QString strSpisokJSON("");//Строка, в которой будет собран JSON запрос.
    quint64 ullKolichestvo = m_pdbSpisok->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
		qdebug("DataSpisok::polSpisokJSON(): quint64 ullKolichestvo = 0, всего PRIMARY KEY 0.");
        return "";//Возвращаем пустую строку.
	}
	m_slsSpisok.clear();//Пустой список элементов списка.
    //Пример: [{"nomer":"1","spisok":"формовка"},{"nomer":"2","spisok":"сварка"}]
    strSpisokJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        strSpisokJSON = strSpisokJSON + "{\"nomer\":\"";//Начало списка объектов.
		QString strNomer = m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Номер");
		if(strNomer == ""){//Если номер пустая строка, то...
			qdebug("DataSpisok::polSpisokJSON(): strNomer="", Нет Номера в БД по заданному Коду.");
			m_slsSpisok.clear();//Пустой список элементов списка.
			return "";
		}
        strSpisokJSON = strSpisokJSON + strNomer;
        strSpisokJSON = strSpisokJSON + "\",\"spisok\":\"";
		QString strSpisok = m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Список");
		m_slsSpisok = m_slsSpisok<<strSpisok;//
		if(strSpisok == ""){//Если Список пустая строка, то...
			qdebug("DataSpisok::polSpisokJSON(): strSpisok="", Нет элемента Списка в БД по заданному Коду.");
			m_slsSpisok.clear();//Пустой список элементов списка.
			return "";
		}
        strSpisokJSON = strSpisokJSON + strSpisok;
        strSpisokJSON = strSpisokJSON + "\",\"opisanie\":\"";
		QString strOpisanie = m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Описание");
        strSpisokJSON = strSpisokJSON + strOpisanie;
        strSpisokJSON = strSpisokJSON + "\"}";//Конец списка объектов.
		if(ullShag<ullKolichestvo)//Если это не последний список объектов, то..
            strSpisokJSON = strSpisokJSON + ",";//ставим запятую.
	}
    strSpisokJSON = strSpisokJSON + "]";//Конец массива объектов.
    return strSpisokJSON;
}
QString DataSpisok::polSpisokOpisanie(uint untNomer){//Полчить Описание элемента Списка по номеру.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   С П И С К А---//
/////////////////////////////////////////////////////////
	if (untNomer <=0){//Если номер меньше или равен 0, то...
		qdebug("DataSpisok::polSpisokOpisanie(uint untNomer): untNomer меньше или равен 0");//Транслир. ошибку
		return "";//Возвращаем пустую строку.
	}
    QString strSpisokOpisanie = m_pdbSpisok->SELECT("Номер", QString::number(untNomer), "Описание");
    return strSpisokOpisanie;
}
bool DataSpisok::ustSpisokOpisanie(uint untNomer, QString strSpisokOpisanie){//Записать в БД описание списка.
/////////////////////////////////////////////////////////
//---З А П И С А Т Ь   О П И С А Н И Е   С П И С К А---//
/////////////////////////////////////////////////////////
		if(m_pdbSpisok->UPDATE(QStringList()<<"Номер"<<"Описание",
							QStringList()<<QString::number(untNomer)<<strSpisokOpisanie))//Если успех записи
			return true;
		qdebug("DataSpisok::ustSpisokOpisanie() - ошибка записи Описания.");
		return false;//Ошибка.
}
void DataSpisok::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
