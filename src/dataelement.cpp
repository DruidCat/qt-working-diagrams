#include "dataelement.h"

DataElement::DataElement(QString strImyaDB, QString strLoginDB, QString strParolDB, quint64 ullElementMax,
                         QObject* parent) : QObject{parent}{
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
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.
    if(!m_pdbElement->CREATE(QStringList()<<"#Код"<<"Номер"<<"Элемент"<<"Описание"))//таблица не создалась,то
		qWarning()<<tr("DataElement::DataElement: ошибка создания таблицы элемент_0.");
	m_blElementPervi = false;//Не первый Элемент в Списке элементов.(false)
    m_ullElementMax = ullElementMax;//Приравниваем максимальное количество Элементов.
    if(m_ullElementMax > 999)//Если больше 999, то...
        m_ullElementMax = 999;//то 999, больше нельзя, алгоритмя приложения не будут работать.
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
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.
    m_pdbElement->ustImyaTablici("элемент_0");
	if(m_pdbElement->CREATE()){//Если таблица создалась, то
        if(!m_pdbElement->SELECT()){//если нет ни одной записи в БД, то...
            if(!m_pdbElement->INSERT(	QStringList()<<"Номер"<<"Элемент"<<"Описание",
                                        QStringList()<<"1"<<"druidcat@yandex.ru"<<"druidcat@yandex.ru")){
                qWarning()<<tr("DataElement::DataElement: ошибка создания первоначальной записи в таблицу "
						" элемент_0.");
                return false;//Ошибка.
            }
        }
	}
	else{
		qWarning()<<tr("DataElement::dbStart(quint64): ошибка создания таблицы элемент_0.");
		return false;//Ошибка.
	}
	return true;
}
QStringList	DataElement::polElement(quint64 ullSpisokKod){//Получить полный список всех Элементов.
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////
	QStringList slsElement;//Пустой список Элементов.
	if(m_blElementPervi)//Если это первый записываемый элемент, то нет смысла перебирать все элементы...
		return slsElement;//Возвращаем пустую строку.
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));
    quint64 ullKolichestvo = m_pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
        qdebug(tr("DataElement::polElement(quint64): quint64 = 0, всего PRIMARY KEY 0."));
        return slsElement;//Возвращаем пустую строку.
	}
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strElement = m_pdbElement->SELECT("Код", QString::number(ullShag), "Элемент");
		if(strElement != "")//Если Список не пустая строка, то...
			slsElement = slsElement<<strElement;//Собираем полный список Элементов.
	}
	return slsElement;//Возвращаем полный список Элементов.
}
bool DataElement::ustElement(quint64 ullSpisokKod, QString strElement){//Записать в БД Элемент.
/////////////////////////////////////////
//---З А П И С А Т Ь   Э Л Е М Е Н Т---//
/////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));//Задаём имя таблицы
    if(!m_pdbElement->CREATE()){//Если таблица не создалась
        qdebug(tr("DataElement::ustElement(quint64, QString): ошибка создания таблицы элемент_")
                +QString::number(ullSpisokKod)+".");
		return false;//Не успех
	}
    quint64 ullKolichestvo = m_pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
    if(ullKolichestvo >= m_ullElementMax){//Если больше максимального количества, то...
        qdebug(("Достигнуто максимальное количество элементов."));
        return false;//Ошибка записи в БД.
    }
    else{//Если не максимальное количество, то...
        if(m_pdbElement->INSERT(QStringList()<<"Номер"<<"Элемент"<<"Описание",
                                  QStringList()<<QString::number(ullKolichestvo+1)<<strElement
                                  <<tr("Описание. Необходимо его редактировать."))){//Запись Элемента в БД
            return true;//Успех записи в БД.
        }
    }
    qdebug(tr("DataElement::ustElement(quint64, QString): Ошибка записи Элемента в БД."));
    return false;//Ошибка записи в БД.
}
bool DataElement::renElement(quint64 ullSpisokKod, QString strElement, QString strElementNovi) {//Переиме.элем
 //////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т---//
///////////////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));//Задаём имя таблицы.
    if(m_pdbElement->UPDATE("Элемент", QStringList()<<strElement<<strElementNovi))//Перезаписываем данные в БД
        return true;//Успех
    return false;//Неудача
}
bool DataElement::renElement(quint64 ullSpisokKod, const QVariantList jsonElement){//Перезапис. весь Элемент.
///////////////////////////////////////////////////////////////
//---П Е Р Е З А П И С Ы В А Е М   В Е С Ь   Э Л Е М Е Н Т---//
///////////////////////////////////////////////////////////////


    //каждый элемент — QVariantMap с ключами "kod", "nomer", "imya"
    qDebug()<<ullSpisokKod << jsonElement;
    return true;//Успех
}
bool DataElement::udalElementDB(quint64 ullSpisokKod,quint64 ullElementKod){//Удалить в БД запись Элемента
///////////////////////////////////////////////////////
//---У Д А Л И Т Ь   З А П И С Ь   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));//Имя таблицы, в которой удалять.
    if(m_pdbElement->DELETE("Код", QString::number(ullElementKod)))//Удаляем данные в БД
        return true;//Успех
    return false;//Ошибка удаления файла или элемента БД.
}
bool DataElement::udalElementTablicu(quint64 ullSpisokKod){//Удалить Таблицу Элемента.
/////////////////////////////////////////////////////////
//---У Д А Л И Т Ь   Т А Б Л И Ц У   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));
    if(!m_pdbElement->DROP())//Если таблица не удалилась, то...
        return false;//Ошибка удаления таблицы.
    return true;//Успешное удаление таблицы.
}
QString DataElement::polElementJSON(quint64 ullSpisokKod) {//Получить JSON строчку Элемента.
///////////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////////
    QString strElementJSON("");//Строка, в которой будет собран JSON запрос.
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));
    if(!m_pdbElement->CREATE()){//Если таблица не создалась. НЕ УДАЛЯТЬ ЭТО СОЗДАНИЕ ТАБЛИЦЫ.
        qdebug(tr("DataElement::polElementJSON(quint64): ошибка создания таблицы элемент_")
                +QString::number(ullSpisokKod)+".");
		return "";//Не успех
	}
    quint64 ullKolichestvo = m_pdbElement->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
	if (!ullKolichestvo){//Если ноль, то...
		m_blElementPervi = true;//Первый элемент записывается (true).
        return tr("[{\"kod\":\"0\",\"nomer\":\"0\",\"imya\":\"Создайте новый элемент.\"}]");//Возвращаем
	}
	else
		m_blElementPervi = false;//Не первый элемент записывается.
    //Пример: [{"kod":"1","nomer":"1","imya":"фаска"},{"kod":"2","nomer":"2","imya":"торцовка"}]
    strElementJSON = "[";//Начало массива объектов
	for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strKod = m_pdbElement->SELECT("Номер", QString::number(ullShag), "Код");
        if(strKod  != ""){//Если номер не пустая строка, то...
			QString strElement = m_pdcclass->
                json_encode(m_pdbElement->SELECT("Номер", QString::number(ullShag), "Элемент"));
			if(strElement != ""){//Если Список не пустая строка, то...
				strElementJSON = strElementJSON + "{";
                strElementJSON = strElementJSON + "\"kod\":\"" + strKod + "\",";
                strElementJSON = strElementJSON + "\"nomer\":\"" + QString::number(ullShag)  + "\",";
                strElementJSON = strElementJSON + "\"imya\":\""	+ strElement + "\"";
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
        qdebug(tr("DataElement::polElementOpisanie(quint64, quint64): quint64 меньше или равен 0."));//ошибка
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
        qdebug(tr("DataElement::ustElementOpisanie(quint64,quint64,QString): quint64 меньше или равен 0."));
		return false;//Возвращаем ошибку.
	}
    m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));
    if(m_pdbElement->UPDATE(QStringList()<<"Код"<<"Описание",
						QStringList()<<QString::number(ullElementKod)<<strElementOpisanie)){//Успех записи, то
		return true;//Успех
	}
    qdebug(tr("DataElement::ustElementOpisanie(quint64,quint64,QString): ошибка записи Описания."));
    return false;//Ошибка.
}
QStringList DataElement::polElementKodi(quint64 ullSpisokKod){//Получить Коды в таблице Элемент_ullSpisokKod
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   К О Д О В---//
///////////////////////////////////////////////////
    QStringList slsKod;//Коди строк в таблице.
    QString strNomer;//Переменная, в которую будет читаться номер из БД.
	QString strImyaTablici = "элемент_" + QString::number(ullSpisokKod);//Имя таблицы
	if(m_pdbElement->SELECT(strImyaTablici)){
		m_pdbElement->ustImyaTablici(strImyaTablici);
		quint64 ullKolichestvo = m_pdbElement->SELECTPK();//Получаем полное количество созданных когда то строк.
		for(quint64 ullShag = 1; ullShag<=ullKolichestvo; ullShag++){//Перебираем все строки в таблице.
			strNomer = m_pdbElement->SELECT("Код", QString::number(ullShag), "Номер");//Считываем номер из таблицы
			if(!strNomer.isEmpty()){//Если не пустая строка, значит строка существует.
				slsKod = slsKod << QString::number(ullShag);//Записываем этот код в список.
			}
		}
	}
    return slsKod;
}
DCDB* DataElement::polPDB(){//Получить указатель на БД Элемента.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   У К А З А Т Е Л Ь   Н А   Б Д---//
/////////////////////////////////////////////////////////
    return m_pdbElement;//Возвращаем указатель на БД Элемента.
}
void DataElement::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
	emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
