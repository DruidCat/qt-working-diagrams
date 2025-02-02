#include "datadannie.h"

DataDannie::DataDannie(QString strImyaDB, QString strLoginDB, QString strParolDB, QObject* proditel)
    : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pdcclass = new DCClass();//Мой класс с методами по работе с текстом.
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.
    m_pdbDannie = new DCDB("QSQLITE", m_strImyaDB, "данные_0_0");//Таблица с данными по Подключ.
    m_pdbDannie->setUserName(m_strLoginDB);//Пользователь.
    m_pdbDannie->setPassword(m_strParolDB);//Устанавливаем пароль.
    connect(	m_pdbDannie,
                SIGNAL(signalDebug(QString)),
                this,
                SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    if(!m_pdbDannie->CREATE(QStringList()<<"#Код"<<"Номер"<<"Данные"<<"Запись"))
        qdebug("DataDannie::DataDannie: ошибка создания таблицы данные_0_0.");
    m_blDanniePervi = false;//Не первый элемент в Данных.(false)
}

DataDannie::~DataDannie(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbDannie;//Удаляем указатель на БД Данных
    m_pdbDannie = nullptr;//Обнуляем указатель.
    delete m_pdcclass;//Удаляем указатель
    m_pdcclass = nullptr;//Обнуляем указатель.
}
bool DataDannie::dbStart(){//Создать первоначальные Данные.
///////////////////////////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////
    m_pdbDannie->ustImyaTablici("данные_0_0");
    if(m_pdbDannie->CREATE()){//Если таблица создалась, то
        if(!m_pdbDannie->SELECT()){//если нет ни одной записи в БД, то...
            if(!m_pdbDannie->INSERT(	QStringList()<<"Номер"<<"Данные"<<"Запись",
                                        QStringList()<<"1"<<"druidcat@yandex.ru"<<"1")){
                qdebug(tr("DataDannie::DataDannie: ошибка создания первоначальной записи в таблицу"
                          " данные_0_0."));
                return false;//Ошибка.
            }
        }
    }
    else{
        qdebug(tr("DataDannie::dbStart(quint64): ошибка создания таблицы данные_0_0."));
        return false;//Ошибка.
    }
    return true;
}
QStringList	DataDannie::polDannie(quint64 ullKodSpisok, quint64 ullKodElement){//Получить список всех Данных.
/////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   Д А Н Н Ы Х---//
/////////////////////////////////////////////////////
    QStringList slsDannie;//Пустой список Данных.
    if(m_blDanniePervi)//Если это первый записываемые данные, то нет смысла перебирать все данные...
        return slsDannie;//Возвращаем пустую строку.
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullKodSpisok)+"_"+QString::number(ullKodElement));
    quint64 ullKolichestvo = m_pdbDannie->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
    if (!ullKolichestvo){//Если ноль, то...
        qdebug(tr("DataElement::polDannie(quint64,qint64): quint64 = 0, всего PRIMARY KEY 0."));
        return slsDannie;//Возвращаем пустую строку.
    }
    for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strDannie = m_pdbDannie->SELECT("Код", QString::number(ullShag), "Данные");
        if(strDannie != "")//Если Список не пустая строка, то...
            slsDannie = slsDannie<<strDannie;//Собираем полный список Данных.
    }
    return slsDannie;//Возвращаем полный список Элементов.
}
bool DataDannie::ustDannie(quint64 ullKodSpisok, quint64 ullKodElement, QString strDannie){//Записать в БД.
///////////////////////////////////////
//---З А П И С А Т Ь   Д А Н Н Ы Х---//
///////////////////////////////////////
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullKodSpisok)+"_"+QString::number(ullKodElement));
    if(!m_pdbDannie->CREATE()){//Если таблица не создалась
        qdebug(tr("DataDannie::ustDannie(quint64,quint64,QString): ошибка создания таблицы данные_")
                + QString::number(ullKodSpisok) + "_"+QString::number(ullKodElement) + ".");
        return false;//Не успех
    }
    quint64 ullKolichestvo = m_pdbDannie->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
    if(m_pdbDannie->INSERT(QStringList()<<"Номер"<<"Данные"<<"Запись",
                              QStringList()<<QString::number(ullKolichestvo+1)<<strDannie<<"0")){//0 файл.pdf
        return true;//Успех записи в БД.
    }
    qdebug(tr("DataDannie::ustDannie(quint64,quint64,QString): Ошибка записи Данных в БД."));
    return false;//Ошибка записи в БД.
}
bool DataDannie::renDannie(quint64 ullKodSpisok,quint64 ullKodElement,QString strDannie,QString strDannieNovi){
 ////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Д А Н Н Ы Е---//
/////////////////////////////////////////////////
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullKodSpisok)+"_"+QString::number(ullKodElement));
    if(m_pdbDannie->UPDATE("Данные", QStringList()<<strDannie<<strDannieNovi))//Перезаписываем данные в БД
        return true;//Успех
    return false;//Неудача
}

QString DataDannie::polDannieJSON(quint64 ullKodSpisok, quint64 ullKodElement){//Получить JSON строчку Данных.
///////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   Д А Н Н Ы Х---//
///////////////////////////////////////////////////////////////
    QString strDannieJSON("");//Строка, в которой будет собран JSON запрос.
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullKodSpisok)+"_"+QString::number(ullKodElement));
    if(!m_pdbDannie->CREATE()){//Если таблица не создалась. НЕ УДАЛЯТЬ ЭТО СОЗДАНИЕ ТАБЛИЦЫ.
        qdebug(tr("DataDannie::polDannieJSON(quint64,quint64): ошибка создания таблицы данные_")
                +QString::number(ullKodSpisok)+"_"+QString::number(ullKodElement)+".");
        return "";//Не успех
    }
    quint64 ullKolichestvo = m_pdbDannie->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
    if (!ullKolichestvo){//Если ноль, то...
        m_blDanniePervi = true;//Первые данные, записывается (true).
        return tr("[{\"kod\":\"0\",\"nomer\":\"0\",\"dannie\":\"Добавьте новые данные.\"}]");//Возвращаем
    }
    else
        m_blDanniePervi = false;//Не первые данные записываются.
    //Пример: [{"kod":"1","nomer":"1","dannie":"план"},{"kod":"2","nomer":"2","dannie":"схема"}]
    strDannieJSON = "[";//Начало массива объектов
    for (quint64 ullShag = 1; ullShag <= ullKolichestvo; ullShag++){
        QString strNomer = m_pdbDannie->SELECT("Код", QString::number(ullShag), "Номер");
        if(strNomer != ""){//Если номер не пустая строка, то...
            QString strDannie = m_pdcclass->
                json_encode(m_pdbDannie->SELECT("Код", QString::number(ullShag), "Данные"));
            if(strDannie != ""){//Если Данные не пустая строка, то...
                strDannieJSON = strDannieJSON + "{";
                strDannieJSON = strDannieJSON + "\"kod\":\"" + QString::number(ullShag) + "\",";
                strDannieJSON = strDannieJSON + "\"nomer\":\"" + strNomer + "\",";
                strDannieJSON = strDannieJSON + "\"dannie\":\""	+ strDannie + "\"";
                strDannieJSON = strDannieJSON + "}";//Конец списка объектов.
                if(ullShag<ullKolichestvo)//Если это не последние данные объектов, то..
                    strDannieJSON = strDannieJSON + ",";//ставим запятую.
            }
        }
    }
    strDannieJSON = strDannieJSON + "]";//Конец массива объектов.
    return strDannieJSON;
}
void DataDannie::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
