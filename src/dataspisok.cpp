#include "dataspisok.h"

DataSpisok::DataSpisok(QString strImyaDB, QString strLoginDB, QString strParolDB, QObject* proditel)
    : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
	m_pdcclass = new DCClass();//Мой класс с методами по работе с текстом.
	m_slsSpisok.clear();//Пустой список элементов Списка.
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.
    m_pdbSpisok = new DCDB("QSQLITE", m_strImyaDB, "список");//Таблица с данными по Подключ.
    m_pdbSpisok->setUserName(m_strLoginDB);//Пользователь.
    m_pdbSpisok->setPassword(m_strParolDB);//Устанавливаем пароль.
	connect(	m_pdbSpisok,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.
    if(!m_pdbSpisok->CREATE(QStringList()<<"#Код"<<"Номер"<<"Список"<<"Описание"))//таблица не создаась, то...
		qWarning()<<tr("DataSpisok::DataSpisok: ошибка создания таблицы список.");
    m_blSpisokPervi = false;//Не первый Список в Списке.(false)
}
DataSpisok::~DataSpisok(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbSpisok;//Удаляем указатель на БД Спмска
    m_pdbSpisok = nullptr;//Обнуляем указатель.
	delete m_pdcclass;//Удаляем указатель
	m_pdcclass = nullptr;//Обнуляем указатель.
}
bool DataSpisok::dbStart() {//Иннициализируем БД, и записываем в нёё данные, если она пустая.
///////////////////////////////////////////
//---З А П И С Ы В А Е М   Д А Н Н Ы Е---//
///////////////////////////////////////////
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.
    return true;//Выход, успех!
}
QString DataSpisok::polSpisok(quint64 ullKod) {//Получить название элемента Списка по Коду.
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е---//
///////////////////////////////////////////
	if (ullKod <=0){//Если номер меньше или равен 0, то...
        qdebug(tr("DataSpisok::polSpisok(quint64): quint64 меньше или равен 0."));//Транслируем ошибку.
		return "";//Возвращаем пустую строку.
	}
    QString strSpisok = m_pdbSpisok->SELECT("Код", QString::number(ullKod), "Список");
	if(strSpisok.isEmpty()){//Если элемент списка пустой, то...
        qdebug(tr("DataSpisok::polSpisok(quint64): Код: ")
                + QString::number(ullKod) + tr(" отсутствует, т.к. пустой элемент списка."));
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
    if(m_pdbSpisok->INSERT(QStringList()<<"Номер"<<"Список"<<"Описание",
                              QStringList()<<QString::number(ullKolichestvo+1)<<strSpisok
                              <<tr("Описание. Необходимо его редактировать."))){
		return true;//Успех записи в БД.
	}
    qdebug(("DataSpisok::ustSpisok(QString): Ошибка записи элемента Списка в БД."));
	return false;//Ошибка записи в БД.
}
bool DataSpisok::renSpisok(QString strSpisok, QString strSpisokNovi){//Переименовать в БД элемент списка.
/////////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т   С П И С К А---//
/////////////////////////////////////////////////////////////////
    if(m_pdbSpisok->UPDATE("Список", QStringList()<<strSpisok<<strSpisokNovi))
        return true;//Успех
    return false;//Неудача
}
QString DataSpisok::polSpisokJSON() {//Получить JSON строчку Списка.
///////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   С П И С К А---//
///////////////////////////////////////////////////////////////
    quint64 ullKolichestvo = m_pdbSpisok->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
        m_blSpisokPervi = true;//Флаг - это будет первый в списке.
        return tr("[{\"kod\":\"0\",\"nomer\":\"0\",\"spisok\":\"Создайте новый элемент.\"}]");//Возвращаем
	}
    else
        m_blSpisokPervi = false;//Флаг - не первый в списке.
    QString strSpisokJSON("");//Строка, в которой будет собран JSON запрос.
	m_slsSpisok.clear();//Пустой список элементов списка.
    //Пример: [{"kod":"1","nomer":"1","spisok":"формовка"},{"kod":"2","nomer":"2","spisok":"сварка"}]
    strSpisokJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strNomer = m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Номер");
		if(strNomer != ""){//Если номер не пустая строка, то...
			QString strSpisok = m_pdcclass->
                json_encode(m_pdbSpisok->SELECT("Код", QString::number(ullShag), "Список"));
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
        qdebug(tr("DataSpisok::polSpisokOpisanie(quint64): quint64 меньше или равен 0."));//ошибка
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
        qdebug(tr("DataSpisok::ustSpisokOpisanie(quint64, QString): ошибка записи Описания."));
		return false;//Ошибка.
}
quint64 DataSpisok::polKod(QString strSpisok){//Получить Код по названию элемента списка.
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////
	if (m_pdcclass->isEmpty(strSpisok)){//Если это пустая строка, то...
        qdebug(tr("DataSpisok::polKod(QString): QString пустая строка."));//Транслируем ошибку.
		return 0;//Возвращаем пустую строку.
	}
    QString strKod = m_pdbSpisok->SELECT("Список", strSpisok, "Код");
	if(strKod.isEmpty()){//Если строка Кода пустая, то...
        qdebug(tr("DataSpisok::polKod(QString) - элемент Списка: ")
                + strSpisok + tr(" отсутствует."));
		return 0;
	}
    return strKod.toULongLong();//Возвращаем код элемента строки.
}
void DataSpisok::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
