#include "dataspisok.h"

DataSpisok::DataSpisok(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent)
	: QObject{parent}{
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
QString DataSpisok::polSpisok(quint64 ullKod) {//Получить название элемента Списка по Коду.
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е---//
///////////////////////////////////////////
	if (ullKod <=0){//Если номер меньше или равен 0, то...
		qdebug("DataSpisok::polSpisok(uint ullKod): ullKod меньше или равен 0");//Транслируем ошибку.
		return "";//Возвращаем пустую строку.
	}
    QString strSpisok = m_pdbSpisok->SELECT("Код", QString::number(ullKod), "Список");
	if(strSpisok.isEmpty()){//Если элемент списка пустой, то...
		qdebug("DataSpisok::polSpisok(quint64) - Код: "
				+QString::number(ullKod)+" отсутствует, т.к. пустой элемент списка.");
	}
    return strSpisok;
}
QStringList	DataSpisok::polSpisok(){//Получить полный список всех элементов Списка.
///////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К---//
///////////////////////////////////////
	return m_slsSpisok;//Возвращаем полный список элементов Списка.
}
bool DataSpisok::ustSpisok(QString strSpisok){//Записать в БД элемент списка.
///////////////////////////////////////////////////////
//---З А П И С А Т Ь   Э Л Е М Е Н Т   С П И С К А---//
///////////////////////////////////////////////////////
    quint64 ullKolichestvo = m_pdbSpisok->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if(m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание"<<"Состав",
                              QStringList()<<QString::number(ullKolichestvo+1)<<strSpisok
							  <<"Описание. Необходимо его редактировать."<<"")){
		return true;//Успех записи в БД.
	}
	qdebug("DataSpisok::ustSpisok(): Ошибка записи элемента Списка в БД.");
	return false;//Ошибка записи в БД.
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
    //Пример: [{"kod":"1","nomer":"1","spisok":"формовка"},{"kod":"2","nomer":"2","spisok":"сварка"}]
    strSpisokJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
		QString strNomer = m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Номер");
		if(strNomer != ""){//Если номер не пустая строка, то...
			QString strSpisok = m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Список");
			if(strSpisok != ""){//Если Список не пустая строка, то...
				strSpisokJSON = strSpisokJSON + "{";
				strSpisokJSON = strSpisokJSON + "\"kod\":\"" + QString::number(ullShag) + "\",";
				strSpisokJSON = strSpisokJSON + "\"nomer\":\"" + strNomer + "\",";
				strSpisokJSON = strSpisokJSON + "\"spisok\":\""	+ strSpisok + "\"";
				strSpisokJSON = strSpisokJSON + "}";//Конец списка объектов.
				m_slsSpisok = m_slsSpisok<<strSpisok;//Собираем полный список элементов Списка.
				if(ullShag<ullKolichestvo)//Если это не последний список объектов, то..
					strSpisokJSON = strSpisokJSON + ",";//ставим запятую.
			}
		}
	}
    strSpisokJSON = strSpisokJSON + "]";//Конец массива объектов.
    return strSpisokJSON;
}
QString DataSpisok::polSpisokOpisanie(quint64 ullKod){//Полчить Описание элемента Списка по Коду.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   С П И С К А---//
/////////////////////////////////////////////////////////
	if (ullKod <=0){//Если номер меньше или равен 0, то...
		qdebug("DataSpisok::polSpisokOpisanie(quint64 ullKod): ullKod меньше или равен 0");//ошибка
		return "";//Возвращаем пустую строку.
	}
    QString strSpisokOpisanie = m_pdbSpisok->SELECT("Код", QString::number(ullKod), "Описание");
    return strSpisokOpisanie;
}
bool DataSpisok::ustSpisokOpisanie(quint64 ullKod, QString strSpisokOpisanie){//Записать в БД описание списк
/////////////////////////////////////////////////////////
//---З А П И С А Т Ь   О П И С А Н И Е   С П И С К А---//
/////////////////////////////////////////////////////////
		if(m_pdbSpisok->UPDATE(QStringList()<<"Код"<<"Описание",
							QStringList()<<QString::number(ullKod)<<strSpisokOpisanie))//Если успех записи
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
