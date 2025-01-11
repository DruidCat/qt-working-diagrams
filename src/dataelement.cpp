#include "dataelement.h"

DataElement::DataElement(QString strImyaDB, QString strLoginDB, QString strParolDB, QObject* parent)
	: QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pdcclass = new DCClass();//Класс с методами по работе с текстом.
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.
    m_pdbElement = new DCDB("QSQLITE", m_strImyaDB, "элемент_0");//Создаём нулевую таблицу элементов.
    m_pdbElement->setUserName(m_strLoginDB);//Пользователь.
    m_pdbElement->setPassword(m_strParolDB);//Устанавливаем пароль.
	connect(	m_pdbElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    if(!m_pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание"))//Если таблица не создалас
		qdebug("DataElement::DataElement: ошибка создания таблицы элемент_0.");

	m_blElementPervi = false;//Не первый Элемент в Списке элементов.(false)
}
DataElement::~DataElement(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
	delete m_pdbElement;//Удаляем
	m_pdbElement = nullptr;//Обнуляем
	delete m_pdcclass;//Удаляем.
	m_pdcclass = nullptr;//Обнуляем.
}
bool DataElement::dbStart(){//Создать первоначальные Элементы.
///////////////////////////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_0");
	if(m_pdbElement->CREATE()){//Если таблица создалась, то
        if(!m_pdbElement->SELECT()){//если нет ни одной записи в БД, то...
            if(!m_pdbElement->INSERT(	QStringList()<<"Номер"<<"Элемент"<<"Описание",
                                        QStringList()<<"1"<<"druidcat@yandex.ru"<<"druidcat@yandex.ru")){
                qdebug("DataElement::DataElement: ошибка создания первоначальной записи в таблицу элемент_0.");
                return false;//Ошибка.
            }
        }
	}
	else{
		qdebug("DataElement::dbStart(quint64): ошибка создания таблицы элемент_0.");
		return false;//Ошибка.
	}
	return true;
}
QStringList	DataElement::polElement(quint64 ullKod){//Получить полный список всех Элементов.
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////
	QStringList slsElement;//Пустой список Элементов.
	if(m_blElementPervi)//Если это первый записываемый элемент, то нет смысла перебирать все элементы...
		return slsElement;//Возвращаем пустую строку.
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullKod));
    quint64 ullKolichestvo = m_pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
		qdebug("DataElement::polElement(quint64): quint64 = 0, всего PRIMARY KEY 0.");
        return slsElement;//Возвращаем пустую строку.
	}
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strElement = m_pdbElement->SELECT("Код", QString::number(ullShag), "Элемент");
		if(strElement != "")//Если Список не пустая строка, то...
			slsElement = slsElement<<strElement;//Собираем полный список Элементов.
	}
	return slsElement;//Возвращаем полный список Элементов.
}
bool DataElement::ustElement(quint64 ullKod, QString strElement){//Записать в БД Элемент.
/////////////////////////////////////////
//---З А П И С А Т Ь   Э Л Е М Е Н Т---//
/////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullKod));//Задаём имя таблицы, с которой работаем.
    if(!m_pdbElement->CREATE()){//Если таблица не создалась
		qdebug("DataElement::ustElement(quint64, QString): ошибка создания таблицы элемент_"
				+QString::number(ullKod)+".");
		return false;//Не успех
	}
    quint64 ullKolichestvo = m_pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
    if(m_pdbElement->INSERT(QStringList()<<"Номер"<<"Элемент"<<"Описание",
                              QStringList()<<QString::number(ullKolichestvo+1)<<strElement
							  <<"Описание. Необходимо его редактировать.")){
		return true;//Успех записи в БД.
	}
	qdebug("DataElement::ustElement(quint64, QString): Ошибка записи Элемента в БД.");
    return false;//Ошибка записи в БД.
}

bool DataElement::renElement(quint64 ullKod, QString strElement, QString strElementNovi) {//Переиме. элемент
 //////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т---//
///////////////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullKod));//Задаём имя таблицы, с которой работаем.
    if(m_pdbElement->UPDATE("Элемент", QStringList()<<strElement<<strElementNovi))//Перезаписываем данные в БД
        return true;//Успех
    return false;//Неудача
}

QString DataElement::polElementJSON(quint64 ullKod) {//Получить JSON строчку Элемента.
///////////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////////
    QString strElementJSON("");//Строка, в которой будет собран JSON запрос.
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullKod));
    if(!m_pdbElement->CREATE()){//Если таблица не создалась. НЕ УДАЛЯТЬ ЭТО СОЗДАНИЕ ТАБЛИЦЫ.
		qdebug("DataElement::polElementJSON(quint64): ошибка создания таблицы элемент_"
				+QString::number(ullKod)+".");
		return "";//Не успех
	}
    quint64 ullKolichestvo = m_pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
		m_blElementPervi = true;//Первый элемент записывается (true).
		qdebug("Нажмите кнопку \"Создать новый элемент.\"");
        return "[{\"kod\":\"0\",\"nomer\":\"0\",\"element\":\"Создайте новый элемент.\"}]";//Возвращаем строку
	}
	else
		m_blElementPervi = false;//Не первый элемент записывается.
    //Пример: [{"kod":"1","nomer":"1","element":"фаска"},{"kod":"2","nomer":"2","element":"торцовка"}]
    strElementJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strNomer = m_pdbElement->SELECT("Код", QString::number(ullShag), "Номер");
		if(strNomer != ""){//Если номер не пустая строка, то...
			QString strElement = m_pdcclass->
                json_encode(m_pdbElement->SELECT("Код", QString::number(ullShag), "Элемент"));
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
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));
    return m_pdbElement->SELECT("Код", QString::number(ullElementKod), "Описание");
}
bool DataElement::ustElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod, QString strElementOpisanie){
/////////////////////////////////////////////////////////
//---З А П И С А Т Ь   О П И С А Н И Е   С П И С К А---//
/////////////////////////////////////////////////////////
	if ((ullSpisokKod <=0)||(ullElementKod <=0)){//Если номера меньше или равны 0, то...
		qdebug("DataElement::ustElementOpisanie(quint64,quint64,QString): quint64 меньше или равен 0.");//ошиб
		return false;//Возвращаем ошибку.
	}
   m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));
    if(m_pdbElement->UPDATE(QStringList()<<"Код"<<"Описание",
						QStringList()<<QString::number(ullElementKod)<<strElementOpisanie)){//Успех записи, то
		return true;//Успех
	}
	qdebug("DataElement::ustElementOpisanie(quint64,quint64,QString): ошибка записи Описания.");
	return false;//Ошибка.
}
void DataElement::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
