#include "datadannie.h"
DataDannie::DataDannie(QString strImyaDB, QString strImyaDBData, QString strLoginDB, QString strParolDB,
                       QString strWorkingDiagramsPut, quint64 ullDannieMax, QObject* proditel) : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pdcclass = new DCClass();//Мой класс с методами по работе с текстом.
    m_pcopydannie = new CopyDannie();//Класс потока копирования файла.
    connect(	m_pcopydannie,
                SIGNAL(signalCopyDannie(bool)),
                this,
                SLOT(slotCopyDannie(bool)));//Связываем сигнал статуса копирования документа.
    //Настройки соединения к БД Настроек.
    m_strImyaDB = strImyaDB;//Имя локальной базы данных.
	m_strImyaDBData = strImyaDBData;//Имя локальной базы данных файов.
    m_strLoginDB = strLoginDB;//Логин локальной базы данных.
    m_strParolDB = strParolDB;//Пароль локальной базы данных.
    m_pdbDannie = new DCDB("QSQLITE", m_strImyaDB, "данные_0_0");//Таблица с данными по Подключ.
    m_pdbDannie->setUserName(m_strLoginDB);//Пользователь.
    m_pdbDannie->setPassword(m_strParolDB);//Устанавливаем пароль.
    connect(	m_pdbDannie,
                SIGNAL(signalDebug(QString)),
                this,
                SLOT(qdebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.
	if(!m_pdbDannie->CREATE(QStringList()<<"#Код"<<"Номер"<<"Данные"<<"Запись"))
        qWarning()<<tr("DataDannie::DataDannie: ошибка создания таблицы данные_0_0.");
    m_blDanniePervi = false;//Не первый элемент в Данных.(false)
	m_strFileDialogPut = "";//Путь к каталогу, где лежит файл для записи.	
    m_strWorkingDiagramsPut = strWorkingDiagramsPut;//Присваеваем переменной каталог приложения.
    m_ullDannieMax = ullDannieMax;//Приравниваем максимальное количество Данных.
    if(m_ullDannieMax > 999)//Если больше 999, то...
        m_ullDannieMax = 999;//то 999, больше нельзя, алгоритмя приложения не будут работать.
    m_slsINSERT.clear();//Очищаем список данных для запроса записи в БД.
}

DataDannie::~DataDannie(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbDannie;//Удаляем указатель на БД Данных
    m_pdbDannie = nullptr;//Обнуляем указатель.
    delete m_pdcclass;//Удаляем указатель
    m_pdcclass = nullptr;//Обнуляем указатель.
    delete m_pcopydannie;//Удаляем указатель
    m_pcopydannie = nullptr;//Обнуляем указатель.
}
bool DataDannie::dbStart(){//Создать первоначальные Данные.
///////////////////////////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////	
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.
    m_pdbDannie->ustImyaTablici("данные_0_0");
    if(m_pdbDannie->CREATE()){//Если таблица создалась, то
        if(!m_pdbDannie->SELECT()){//если нет ни одной записи в БД, то...
            if(!m_pdbDannie->INSERT(	QStringList()<<"Номер"<<"Данные"<<"Запись",
                                        QStringList()<<"1"<<"druidcat@yandex.ru"<<"1")){
                qWarning()<<tr("DataDannie::DataDannie: ошибка создания первоначальной записи в таблицу"
                          " данные_0_0.");
                return false;//Ошибка.
            }
        }
    }
    else{
        qWarning()<<tr("DataDannie::dbStart(quint64): ошибка создания таблицы данные_0_0.");
        return false;//Ошибка.
    }
    return true;
}
void DataDannie::ustWorkingDiagrams(QString strWorkingDiagramsPut){//Задаём каталог хранения Документов.
/////////////////////////////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К А Т А Л О Г   Х Р А Н Е Н И Я   Д О К У М Е Н Т О В---//
/////////////////////////////////////////////////////////////////////////////////////
	m_strWorkingDiagramsPut = strWorkingDiagramsPut;//Приравниваем пути
}
QStringList	DataDannie::polDannie(quint64 ullSpisokKod, quint64 ullElementKod){//Получить список всех Данных.
/////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   Д А Н Н Ы Х---//
/////////////////////////////////////////////////////
    QStringList slsDannie;//Пустой список Данных.
    if(m_blDanniePervi)//Если это первый записываемые данные, то нет смысла перебирать все данные...
        return slsDannie;//Возвращаем пустую строку.
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
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
bool DataDannie::ustDannie(quint64 ullSpisokKod, quint64 ullElementKod, QString strFail, QString strDannie){
///////////////////////////////////////
//---З А П И С А Т Ь   Д А Н Н Ы Х---//
///////////////////////////////////////
    QString strAbsolutPut=m_strFileDialogPut+QDir::separator()+strFail;//Абсолют путь с именем файла+разшире
    //Имя таблицы задаём тут, а записываем даные в таблицу в слоте slotCopyDannie(bool).
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
    if(!m_pdbDannie->CREATE()){//Если таблица не создалась
        qdebug(tr("DataDannie::ustDannie(quint64,quint64,QString): ошибка создания таблицы данные_")
                + QString::number(ullSpisokKod) + "_"+QString::number(ullElementKod) + ".");
        return false;//Не успех
    }
    quint64 ullKolichestvo = m_pdbDannie->SELECTPK();//максимальне количество созданых PRIMARY KEY в БД.
    if(ullKolichestvo >= m_ullDannieMax){//Если больше максимального количества, то...
        qdebug(("Достигнуто максимальное количество документов в элементе."));
        return false;//Ошибка записи в БД.
    }
    QString strImyaFaila(polImyaFaila(ullSpisokKod, ullElementKod, ullKolichestvo+1));//Задаём имя файла с Док
    m_slsINSERT.clear();//Очищаем список данных для запроса записи в БД.
    m_slsINSERT = m_slsINSERT<<QString::number(ullKolichestvo+1)<<strDannie<<strImyaFaila;
    //Если копирование документа успешно в отдельном потоке, то запись в БД будет в слоте slotCopyDannie(bool)
    return copyDannie(strAbsolutPut, strImyaFaila);//Копируем Документ в отдельном потоке.
}
bool DataDannie::renDannie(quint64 ullSpisokKod,quint64 ullElementKod,QString strDannie,QString strDannieNovi){
 ////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Д А Н Н Ы Е---//
/////////////////////////////////////////////////
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
    if(m_pdbDannie->UPDATE("Данные", QStringList()<<strDannie<<strDannieNovi))//Перезаписываем данные в БД
        return true;//Успех
    return false;//Неудача
}
bool DataDannie::udalDannieDB(quint64 ullSpisokKod,quint64 ullElementKod,quint64 ullDannieKod){//Удалить запис
///////////////////////////////////////////////////////////
//---У Д А Л И Т Ь   Д А Н Н Ы Е   И   Д О К У М Е Н Т---//
///////////////////////////////////////////////////////////
    QString strImyaFaila(polImyaFaila(ullSpisokKod, ullElementKod, ullDannieKod));//Задаём имя файла с Докумен
    if(udalFail(strImyaFaila)){//Если файл удалился, то...
        m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)+"_"
                                    +QString::number(ullElementKod));//Задаём имя таблицы, в которой удалять
        if(m_pdbDannie->DELETE("Код", QString::number(ullDannieKod)))//Удаляем данные в БД
            return true;//Успех
    }
    return false;//Ошибка удаления файла или элемента БД.
}

QString DataDannie::polDannieJSON(quint64 ullSpisokKod, quint64 ullElementKod){//Получить JSON строчку Данных.
///////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С Т Р О К У   Д А Н Н Ы Х---//
///////////////////////////////////////////////////////////////
    QString strDannieJSON("");//Строка, в которой будет собран JSON запрос.
    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
    if(!m_pdbDannie->CREATE()){//Если таблица не создалась. НЕ УДАЛЯТЬ ЭТО СОЗДАНИЕ ТАБЛИЦЫ.
        qdebug(tr("DataDannie::polDannieJSON(quint64,quint64): ошибка создания таблицы данные_")
                +QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod)+".");
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
void DataDannie::ustFileDialogPut(QString strFileDialogPut){//Задать путь к каталогу, в котором файл записи.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т Ь   К   Ф А Й Л У---//
///////////////////////////////////////////////////////
	m_strFileDialogPut = strFileDialogPut;//Приравниваем пути.
}
QString DataDannie::polImyaFaila(qint64 ullSpisokKod, qint64 ullElementKod, qint64 ullDannieKod){//Имя файла.
/////////////////////////////////////////////
//---П О Л У Ч И Т Ь   И М Я   Ф А Й Л А---//
/////////////////////////////////////////////
    uint ntImyaFaila = (ullSpisokKod*1000000)+(ullElementKod*1000)+ullDannieKod;
    QString strImyaFaila = QString("%1").arg(ntImyaFaila, 9, 10, QLatin1Char('0')) + ".dc";//соберём имя файла
    return strImyaFaila;
}
bool DataDannie::estImyaFaila(QString strImyaFaila){//Есть такой файл в каталоге?
/////////////////////////////////////////
//---Е С Т Ь   Т А К О Й   Ф А Й Л ?---//
/////////////////////////////////////////
    QFile flImyaFaila(m_strWorkingDiagramsPut+QDir::separator()+strImyaFaila);//Объект на файл в каталоге.
    if(flImyaFaila.exists())//Есть такой файл, то...
        return true;
    return false;
}
bool DataDannie::udalFail(QString strImyaFaila){//Удалить файл в каталоге.
/////////////////////////////////////////////
//---У Д А Л И Т Ь   Т А К О Й   Ф А Й Л---//
/////////////////////////////////////////////
    QFile flImyaFaila(m_strWorkingDiagramsPut+QDir::separator()+strImyaFaila);//Объект на файл в каталоге.
    if(flImyaFaila.exists()){//Есть такой файл, то...
        if(flImyaFaila.remove())//Если файл удалился, то...
            return true;//Успех
        else{
            qdebug(tr("Невозможно удалить файл ")+strImyaFaila
                   +tr(", так как он может быть открыт в другом приложении. Закройте его!"));
            return false;//Ошибка.
        }
    }
    qdebug(tr("Внимание, файл ")+strImyaFaila+tr(" был кем то удалён."));
    return true;//успех, так как кем то удалённый файл не мешает алгоритму.
}
bool DataDannie::udalDannieFaili(quint64 ullSpisokKod, quint64 ullElementKod){//Удалить все файлы Элемента.
/////////////////////////////////////////////////////
//---У Д А Л И Т Ь   Ф А Й Л Ы   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////
    QDir odrPut(m_strWorkingDiagramsPut);//Создаём объект Дериктории с папкой, где хранятся Документы.
    QStringList slsFaili = odrPut.entryList(QStringList()<<"*.dc", QDir::Files);//Задаём маску файлов
    QStringList slsFailiSort;//Отстортированные файлы по заданым параметрам.
    int ntRazmer = slsFaili.size();//Количество элементов в списке.
    for(int ntShag = 0; ntShag<ntRazmer; ntShag++){//Цикл перебора списка на наличие нужных Документов.
        QString strFail = slsFaili[ntShag];//Строка с файлом.
        if((strFail.mid(0, 3).toULongLong()==ullSpisokKod)&&(strFail.mid(3, 3).toULongLong()==ullElementKod)){
            if(!udalFail(strFail))//Если файл не удалился, то...
                return false;//Ошибка удаления.
        }
    }
    return true;//Успешное удалене файлов Элемента
}

bool DataDannie::udalDannieTablicu(quint64 ullSpisokKod, quint64 ullElementKod){//Удалить таблицу Данных.
/////////////////////////////////////////////////////
//---У Д А Л И Т Ь   Т А Б Л И Ц У   Д А Н Н Ы Х---//
/////////////////////////////////////////////////////
    return true;//Успешное удаление таблицы данных.
}
bool DataDannie::copyDannie(QString strAbsolutPut, QString strImyaFaila){//Копируем файл в приложение.
///////////////////////////////////////////
//---К О П И Р О В А Т Ь   Д А Н Н Ы Е---//
///////////////////////////////////////////
    QFile flDannie (strAbsolutPut);//Файл, который мы хотим скопировать, расположенный...
    if(flDannie.exists()){//Если данный файл существует, то...
        if(estImyaFaila(strImyaFaila)){//Если такой файл с таким же именем существует, то...
            if(!udalFail(strImyaFaila))//Удаляем файл с таким же именем. Если файл не удалился, то...
                return false;//Ошибка удаления.
        }
        m_pcopydannie->ustPutiFailov(strAbsolutPut, m_strWorkingDiagramsPut+QDir::separator()+strImyaFaila);
        m_pcopydannie->start();//Запускаем поток и ждём сигнала о завершении копирования.
        return true;
	}
	else
		qdebug(tr("Выбранный файл отсутствует!"));
	
	return false;
}
void DataDannie::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
void DataDannie::slotCopyDannie(bool blCopyStatus){//Слот получающий статус скопированного документа.
///////////////////////////////////////////////////////////////////////////////////
//---С Л О Т   С Т А Т У С А   С К О П И Р О В А Н Н О Г О   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////////////////////////////
    if(blCopyStatus){//Если копирование прошло успешно, то...
        emit signalFileDialogCopy(m_pdbDannie->INSERT(QStringList()<<"Номер"<<"Данные"<<"Запись",
                                                      m_slsINSERT));//Записываем в БД, и отсылаем сигнал 1или0
    }
    else
        emit signalFileDialogCopy(blCopyStatus);//Отсылаем сигнал об ошибке копирования.
}
