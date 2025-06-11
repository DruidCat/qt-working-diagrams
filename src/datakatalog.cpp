#include "datakatalog.h"

DataKatalog::DataKatalog(QObject* proditel) : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    QStringList slsHomePath = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);//Документы
    m_strDocPut = slsHomePath.first();
    m_pdrPut = new QDir (m_strDocPut);//Путь дериктории Документы, в которой будет создаваться каталог.
    m_pcopykatalog = new CopyKatalog();//Класс потока копирования файла.
    connect(	m_pcopykatalog,
                SIGNAL(signalCopyDannie(bool)),
                this,
                SLOT(slotCopyDannie(bool)));//Связываем сигнал статуса копирования документа.
}

DataKatalog::~DataKatalog(){//Деструктор.
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    m_pdbTitul = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    m_pdbSpisok = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    m_pdbElement = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    m_pdbDannie = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    delete m_pdrPut;//Удаляем указатель.
    m_pdrPut = nullptr;//Обнуляем указатель.
    delete m_pcopykatalog;//Удаляем указатель
    m_pcopykatalog = nullptr;//Обнуляем указатель.
}

void DataKatalog::ustPDBTitul(DCDB* pdbTitul){//Устанавливаем указатель БД Титула.
/////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   У К А З А Т Е Л Ь   Н А   Б Д---//
/////////////////////////////////////////////////////////////
    m_pdbTitul = pdbTitul;//Запоминаем адресс класса БД Титула.
}
void DataKatalog::ustPDBSpisok(DCDB* pdbSpisok){//Устанавливаем указатель БД Списка.
/////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   У К А З А Т Е Л Ь   Н А   Б Д---//
/////////////////////////////////////////////////////////////
    m_pdbSpisok = pdbSpisok;//Запоминаем адресс класса БД Списка.
}
void DataKatalog::ustPDBElement(DCDB* pdbElement){//Устанавливаем указатель БД Элемента.
/////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   У К А З А Т Е Л Ь   Н А   Б Д---//
/////////////////////////////////////////////////////////////
    m_pdbElement = pdbElement;//Запоминаем адресс класса БД Элемента.
}
void DataKatalog::ustPDBDannie(DCDB* pdbDannie){//Устанавливаем указатель БД Данных.
/////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   У К А З А Т Е Л Ь   Н А   Б Д---//
/////////////////////////////////////////////////////////////
    m_pdbDannie = pdbDannie;//Запоминаем адресс класса БД Данных.
}
int DataKatalog::polPdfSummu(){//Возвратим приблизительную сумму всех pdf документов в Менторе.
/////////////////////////////////////////////
//---П О Л У Ч И Т Ь   P D F   С У М М У---//
/////////////////////////////////////////////
    quint64 ullSpisok(0);//Количество Списков.
    quint64 ullElement(0);//количество Элементов в конкретном Списке.
    quint64 ullDannie(0);//количество Данных в конкретном Элементе.

    if(m_pdbSpisok->SELECT("список")){//Если таблица список существует, то...
        ullSpisok = m_pdbSpisok->SELECTPK();//Количество Списков созданых и удалённых.
        if(!ullSpisok)//Если таблица создана, но в ней нет ни одного списка, то...
            return 0;//Возвращаем 0
    }
    else//Если таблица список не существует, то...
        return 0;//Возвращаем 0.

    for(quint64 ullSpisokKod = 1; ullSpisokKod<= ullSpisok; ullSpisokKod++){
        if(m_pdbElement->SELECT("элемент_"+QString::number(ullSpisokKod))){//Проверка наличия таблицы. Важно.
            m_pdbElement->ustImyaTablici("элемент_"+QString::number(ullSpisokKod));//Задаём таблицу Элемента
            ullElement = m_pdbElement->SELECTPK();//Подсчитываем количество Элементов в каждом из Списков.
            for(quint64 ullElementKod = 1; ullElementKod<=ullElement; ullElementKod++){
                if(m_pdbDannie->SELECT("данные_"+QString::number(ullSpisokKod)
                                        +"_"+QString::number(ullElementKod))){//Проверка наличия табл.
                    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)
                                                +"_"+QString::number(ullElementKod));//Задаём Таблицу.
                    //qdebug("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
                    ullDannie = ullDannie + m_pdbDannie->SELECT();//Считаем количество строк в таблице.
                }
            }
        }
    }
    return ullDannie;
}
void DataKatalog::copyStart(){//Старт копирования документов в каталог.
/////////////////////////////////////////////////////////
//---Н А Ч А Л О   С О З Д А Н И Я   К А Т А Л О Г А---//
/////////////////////////////////////////////////////////
    m_pdrPut->setPath(m_strDocPut);//Всегда обнуляем путь на заданную по умолчание папку.
    if(sozdatKatalogMentor()){//Если папка Ментор создалась, то...
        if(sozdatKatalogTitul()){//Если папка Титул создалась, то...
        }
        else//Если не создалась папка Титул, то...
            emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталога.
    }
    else//Если ошибка создания папки Ментор, то...
        emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталога.
}
bool DataKatalog::sozdatKatalogMentor(){//Создаём каталог Ментор.
/////////////////////////////////////////////////
//---С О З Д А Т Ь   П А П К У   М Е Н Т О Р---//
/////////////////////////////////////////////////
    QString strData = QDate::currentDate().toString("yyyy-MM-dd");//Создаём строку вида 2022-11-22
    QString strVremya = QTime::currentTime().toString("hh-mm-ss");//Создаём строку вида 22-11-33
    QString strMentor = strData + "_" + strVremya + "_" + "Mentor";
    if(m_pdrPut->mkdir(strMentor)){//Если папка ментор создалась, то...
        if(!m_pdrPut->cd(strMentor)){//Если переход в папку неуспешный, то...
            qdebug(tr("Ошибка перехода в папку Ментор с каталогом документов."));
            return false;//Ошибка.
        }
    }
    else{//Если ошибка создания каталога, то...
        qdebug(tr("Ошибка создания папки Ментор под каталог документов."));
        return false;//Ошибка.
    }
    return true;//В любых остальных случаях Успех.
}
bool DataKatalog::sozdatKatalogTitul(){//Создаём каталог Титул.
/////////////////////////////////////////////////
//---С О З Д А Т Ь   П А П К У   Т И Т У Л А---//
/////////////////////////////////////////////////
    QString strTitul = m_pdbTitul->SELECT("Код", "1", "Титул");//Читаем имя Титула из БД.
    if(strTitul.isEmpty()){//Если Титул пустой, то...
        qdebug(tr("Ошибка, имя Титула не может быть пустым."));
        return false;//Ошибка.
    }
    else{//Если имя Титула не пустое, то...
        if(m_pdrPut->mkdir(strTitul)){//Если папка с именем Титула создалась, то...
            if(!m_pdrPut->cd(strTitul)){//Если не получилось перейти в папку с именем Титула, то...
                qdebug(tr("Ошибка прехода в папку Титул с каталогом документов."));
                return false;//Ошибка.
            }
        }
        else{//Если папка с именем титула не создалась, то...
            qdebug(tr("Ошибка создания папки Титула под каталог документов."));
            return false;//Ошибка.
        }
    }
    return false;
}
void DataKatalog::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
void DataKatalog::slotCopyDannie(bool blCopyStatus){//Слот получающий статус скопированного документа.
///////////////////////////////////////////////////////////////////////////////////
//---С Л О Т   С Т А Т У С А   С К О П И Р О В А Н Н О Г О   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////////////////////////////
    if(blCopyStatus){//Если копирование прошло успешно, то...
        emit signalKatalogCopy(blCopyStatus);//отсылаем сигнал 1
    }
    else{
        qdebug(tr("Ошибка копирования в каталог документов."));
        emit signalKatalogCopy(blCopyStatus);//Отсылаем сигнал об ошибке копирования.
    }
}
