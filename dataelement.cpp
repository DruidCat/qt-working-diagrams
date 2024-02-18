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
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_0");//Создаём нулевую таблицу элементов.
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица создалась, то
		if(!pdbElement->INSERT(	QStringList()<<"Номер"<<"Элемент"<<"Описание",
								QStringList()<<"1"<<"druidcat@yandex.ru"<<"druidcat@yandex.ru"))
			qdebug("DataElement::DataElement: ошибка создания первоначальной записи в таблицу элемент_0.");
	}
	else//Если не создалась таблица, то...
		qdebug("DataElement::DataElement: ошибка создания таблицы элемент_0.");
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем

	m_blElementPervi = false;//Не первый Элемент в Списке элементов.(false)
}
DataElement::~DataElement(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
}
bool DataElement::dbStart(quint64 ullKod){//Создать класс БД элемента Списка.
///////////////////////////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////
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
	qdebug("DataElement::dbStart(quint64): ошибка создания таблицы элемент_"+QString::number(ullKod)+".");
	return false;//Ошибка.
}
QStringList	DataElement::polElement(quint64 ullKod){//Получить полный список всех Элементов.
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////
	QStringList slsElement;//Пустой список Элементов.
	if(m_blElementPervi)//Если это первый записываемый элемент, то нет смысла перебирать все элементы...
		return slsElement;//Возвращаем пустую строку.
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_"+QString::number(ullKod));
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(!pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица не создалась
		qdebug("DataElement::polElement(quint64): ошибка создания таблицы элемент_"
				+QString::number(ullKod)+".");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return slsElement;//Не успех
	}
    quint64 ullKolichestvo = pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
		qdebug("DataElement::polElement(quint64): quint64 = 0, всего PRIMARY KEY 0.");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
        return slsElement;//Возвращаем пустую строку.
	}
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
		QString strElement = pdbElement->SELECT("Код", QString::number(ullShag), "Элемент");
		if(strElement != "")//Если Список не пустая строка, то...
			slsElement = slsElement<<strElement;//Собираем полный список Элементов.
	}
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем
	return slsElement;//Возвращаем полный список Элементов.
}
bool DataElement::ustElement(quint64 ullKod, QString strElement){//Записать в БД Элемент.
/////////////////////////////////////////
//---З А П И С А Т Ь   Э Л Е М Е Н Т---//
/////////////////////////////////////////
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_"+QString::number(ullKod));
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(!pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица не создалась
		qdebug("DataElement::ustElement(quint64, QString): ошибка создания таблицы элемент_"
				+QString::number(ullKod)+".");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return false;//Не успех
	}
    quint64 ullKolichestvo = pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if(pdbElement->INSERT(QStringList()<<"Номер"<<"Элемент"<<"Описание",
                              QStringList()<<QString::number(ullKolichestvo+1)<<strElement
							  <<"Описание. Необходимо его редактировать.")){
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return true;//Успех записи в БД.
	}
	qdebug("DataElement::ustElement(quint64, QString): Ошибка записи Элемента в БД.");
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем
	return false;//Ошибка записи в БД.
}
QString DataElement::polElementJSON(quint64 ullKod) {//Получить JSON строчку Элемента.
///////////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////////
    QString strElementJSON("");//Строка, в которой будет собран JSON запрос.
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_"+QString::number(ullKod));
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(!pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица не создалась
		qdebug("DataElement::polElementJSON(quint64): ошибка создания таблицы элемент_"
				+QString::number(ullKod)+".");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return "";//Не успех
	}
    quint64 ullKolichestvo = pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
		m_blElementPervi = true;//Первый элемент записывается (true).
		qdebug("Нажмите кнопку \"Создать новый элемент.\"");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
        return "[{\"kod\":\"0\",\"nomer\":\"0\",\"element\":\"Создайте новый элемент.\"}]";//Возвращаем строку
	}
	else
		m_blElementPervi = false;//Не первый элемент записывается.
    //Пример: [{"kod":"1","nomer":"1","element":"фаска"},{"kod":"2","nomer":"2","element":"торцовка"}]
    strElementJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
		QString strNomer = pdbElement->SELECT("Код", QString::number(ullShag), "Номер");
		if(strNomer != ""){//Если номер не пустая строка, то...
			QString strElement = pdbElement->SELECT("Код", QString::number(ullShag), "Элемент");
			if(strElement != ""){//Если Список не пустая строка, то...
				strElementJSON = strElementJSON + "{";
				strElementJSON = strElementJSON + "\"kod\":\"" + QString::number(ullShag) + "\",";
				strElementJSON = strElementJSON + "\"nomer\":\"" + strNomer + "\",";
				strElementJSON = strElementJSON + "\"element\":\""	+ strElement + "\"";
				strElementJSON = strElementJSON + "}";//Конец списка объектов.
				if(ullShag<ullKolichestvo)//Если это не последний список объектов, то..
					strElementJSON = strElementJSON + ",";//ставим запятую.
			}
		}
	}
    strElementJSON = strElementJSON + "]";//Конец массива объектов.
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем
    return strElementJSON;
}
QString DataElement::polElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod){//Получ Описание Элемента
/////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////////
	if ((ullSpisokKod <=0)||(ullElementKod <=0)){//Если номера меньше или равны 0, то...
		qdebug("DataElement::polElementOpisanie(quint64, quint64): quint64 меньше или равен 0.");//ошибка
		return "";//Возвращаем пустую строку.
	}
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_"+QString::number(ullSpisokKod));
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(!pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица не создалась
		qdebug("DataElement::polElementOpisanie(quint64,quint64): ошибка создания таблицы элемент_"
				+QString::number(ullSpisokKod)+".");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return "";//Не успех
	}
    QString strElementOpisanie = pdbElement->SELECT("Код", QString::number(ullElementKod), "Описание");
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем
    return strElementOpisanie;
}
bool DataElement::ustElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod, QString strElementOpisanie){
/////////////////////////////////////////////////////////
//---З А П И С А Т Ь   О П И С А Н И Е   С П И С К А---//
/////////////////////////////////////////////////////////
	if ((ullSpisokKod <=0)||(ullElementKod <=0)){//Если номера меньше или равны 0, то...
		qdebug("DataElement::ustElementOpisanie(quint64,quint64,QString): quint64 меньше или равен 0.");//ошиб
		return false;//Возвращаем ошибку.
	}
    DCDB* pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_"+QString::number(ullSpisokKod));
	connect(	pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    pdbElement->setUserName(m_strLoginDB);//Пользователь.
    pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
    if(!pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание")){//Если таблица не создалась
		qdebug("DataElement::ustElementOpisanie(quint64,quint64,QString): ошибка создания таблицы элемент_"
				+QString::number(ullSpisokKod)+".");
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return false;//Не успех
	}
	if(pdbElement->UPDATE(QStringList()<<"Код"<<"Описание",
						QStringList()<<QString::number(ullElementKod)<<strElementOpisanie)){//Успех записи, то
		delete pdbElement;//Удаляем
		pdbElement = nullptr;//Обнуляем
		return true;//Успех
	}
	qdebug("DataElement::ustElementOpisanie(quint64,quint64,QString): ошибка записи Описания.");
	delete pdbElement;//Удаляем
	pdbElement = nullptr;//Обнуляем
	return false;//Ошибка.
}
void DataElement::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
