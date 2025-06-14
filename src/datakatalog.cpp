#include "datakatalog.h"

DataKatalog::DataKatalog(const QString strWorkingData, QObject* proditel) : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    m_blSpisokMax = false;//true - Последний элемент Списка.
    m_blElementMax = false;//true - Последний Элемент в конкретном Списке.
    m_blDannieMax = false;//true - Последний элемент Данных в конкретном Элементе.

    m_untSpisokKod = 0;//Это код в БД, элемент Списка которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untElementKod = 0;//Это код в БД, в Списке Элемент которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untDannieKod = 0;//Это код в БД, Данные Элемента которох нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!

    m_untSpisokNomer = 0;//Это номер в БД, элемент Списка которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untElementNomer = 0;//Это номер в БД, в Списке Элемент которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untDannieNomer = 0;//Это номер в БД, Данные Элемента которох нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!

    m_untSpisokMax = 0;//Количество Списков.
    m_untElementMax = 0;//Количество Елементов в отдельно взятом Списке.
    m_untDannieMax = 0;//Количество Данных в конкретном Элементе.

    m_untDannie = 0;//Суммарное количество документов в БД.

    QStringList slsHomePath = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);//Документы
    m_strDocPut = slsHomePath.first();
    m_pdrPut = new QDir (m_strDocPut);//Путь дериктории Документы, в которой будет создаваться каталог.
    m_pcopykatalog = new CopyKatalog();//Класс потока копирования файла.
    connect(	m_pcopykatalog,
                SIGNAL(signalCopyDannie(bool)),
                this,
                SLOT(slotCopyDannie(bool)));//Связываем сигнал статуса копирования документа.

    m_strWorkingData = strWorkingData;//Путь к каталогу, где находится БД и документы Ментора.
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
    m_blSpisokMax = false;//Последний элемент Списка.
    m_blElementMax = false;//Последний Элемент в конкретном Списке.
    m_blDannieMax = false;//Последний элемент Данных в конкретном Элементе.
    uint untElement(0);//количество Элементов в конкретном Списке.
    uint untDannie = m_untDannie = 0;//количество Данных в конкретном Элементе обнуляем.

    if(m_pdbSpisok->SELECT("список")){//Если таблица список существует, то...
        m_untSpisokMax = m_pdbSpisok->SELECTPK();//Количество Списков созданых и удалённых.
        if(!m_untSpisokMax)//Если таблица создана, но в ней нет ни одного списка, то...
            return m_untDannie;//Возвращаем 0
    }
    else//Если таблица список не существует, то...
        return m_untDannie;//Возвращаем 0.

    for(uint untSpisokKod = 1; untSpisokKod<= m_untSpisokMax; untSpisokKod++){
        if(m_pdbElement->SELECT("элемент_"+QString::number(untSpisokKod))){//Проверка наличия таблицы. Важно.
            m_pdbElement->ustImyaTablici("элемент_"+QString::number(untSpisokKod));//Задаём таблицу Элемента
            untElement = m_pdbElement->SELECTPK();//Подсчитываем количество Элементов в каждом из Списков.
            for(uint untElementKod = 1; untElementKod<=untElement; untElementKod++){
                if(m_pdbDannie->SELECT("данные_"+QString::number(untSpisokKod)
                                        +"_"+QString::number(untElementKod))){//Проверка наличия табл.
                    m_pdbDannie->ustImyaTablici("данные_"+QString::number(untSpisokKod)
                                                +"_"+QString::number(untElementKod));//Задаём Таблицу.
                    //qdebug("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
                    untDannie = untDannie + m_pdbDannie->SELECT();//Считаем количество строк в таблице.
                }
            }
        }
    }
    m_untDannie = untDannie;//Приравниваем переменные.
    return m_untDannie;
}
void DataKatalog::copyStart(){//Старт копирования документов в каталог.
/////////////////////////////////////////////////////////
//---Н А Ч А Л О   С О З Д А Н И Я   К А Т А Л О Г А---//
/////////////////////////////////////////////////////////

    if(m_untDannie){//Если в БД записан хоть один документ, то...
        m_pdrPut->setPath(m_strDocPut);//Всегда обнуляем путь на заданную по умолчание папку.
        if(sozdatKatalogMentor()){//Если папка Ментор создалась, то...
            if(sozdatTitul()){//Если папка Титул создалась, то...
                if(sozdatSpisok(1)){//Запускаем цикл создания каталогов и копирования документов со списка №1.
                    if(sozdatElement(1)){//Переходим по Коду Списка и Номеру Элемента.
                        if(sozdatDannie(1)){//Копируем документ по первому Номеру.

                        }
                        else
                            emit signalKatalogCopy(false);//Сигнал о том, что авария при копировании документа
                    }
                    else
                        emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталог
                }
                else
                    emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталога.
            }
            else//Если не создалась папка Титул, то...
                emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталога.
        }
        else//Если ошибка создания папки Ментор, то...
            emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталога.
    }
    else{//Если 0 документов, то...
        qdebug(tr("Список пуст, не добавлено ни одного документа."));
        emit signalKatalogCopy(false);//Излучаем сигнал о том, что авария при создании каталога.
    }
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
bool DataKatalog::sozdatTitul(){//Создаём каталог Титул.
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
    return true;//Успех
}
bool DataKatalog::sozdatSpisok(const uint untSpisokNomer){//Слот создающий список по его Номеру.
/////////////////////////////////////////////////
//---С О З Д А Т Ь   П А П К У   С П И С К А---//
/////////////////////////////////////////////////
    m_untSpisokNomer = untSpisokNomer;//Приравниваем параметры в начале метода.
    if((untSpisokNomer > m_untSpisokMax)||(untSpisokNomer <= 0)){//Если Номер не в эти рамках, то...
        qdebug(tr("Не правильной номер списка для его создания."));
        return false;//Ошибка.
    }
    else{//Если нет, то...
        QString strSpisok = m_pdbSpisok->SELECT("Номер", QString::number(untSpisokNomer), "Список");
        if(strSpisok.isEmpty()){//Если элемент списка пустой, то...
            if(untSpisokNomer != m_untSpisokMax){//Если не равняется, значит следующий элемент Списка смотрим.
                m_untSpisokNomer += 1;//Увеличиваем Номер Списка на +1.
                sozdatSpisok(m_untSpisokNomer);//РЕКУРСИЯ!!! ОПАСНО!!!
            }
        }
        else{//Если не пустой элемент Списка, то...
            if(untSpisokNomer == m_untSpisokMax){//Если равняется, значит это последний элемент Списка
                m_blSpisokMax = true;//Последний элемент Списка.
            }
            QString strSpisokNomer = QString("%1").arg(untSpisokNomer, 3, 10, QLatin1Char('0'));//№ Списка
            strSpisok = strSpisokNomer + " " + strSpisok;//Собираем имя Списка с номером его.
            if(m_pdrPut->mkdir(strSpisok)){//Если папка с именем Списка создалась, то...
                if(!m_pdrPut->cd(strSpisok)){//Если не получилось перейти в папку с именем Списка, то...
                    qdebug(tr("Ошибка прехода в папку Списка: ") + strSpisok);
                    return false;//Ошибка.
                }
            }
            else{//Если папка с именем Списка не создалась, то...
                qdebug(tr("Ошибка создания папки Списка: ") + strSpisok);
                return false;//Ошибка.
            }
        }
    }
    m_untSpisokKod = m_pdbSpisok->SELECT("Номер", QString::number(m_untSpisokNomer), "Код").toUInt();
    return true;//Успех
}
bool DataKatalog::sozdatElement(const uint untElementNomer){//Создать Элемент по Номеру.
/////////////////////////////////////////////////////
//---С О З Д А Т Ь   П А П К У   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////

    m_untElementNomer = untElementNomer;//Приравниваем параметры в начале метода.
    if(!m_untElementMax){//ВАЖНО! Если = 0, то читаем из БД, Но при последнем Элементе в Списке ОБНУЛЯЕМ!!!
        m_pdbElement->ustImyaTablici("элемент_"+QString::number(m_untSpisokKod));//Задаём таблицу Элемента
        m_untElementMax = m_pdbElement->SELECTPK();//Подсчитываем количество Элементов в каждом из Списков.
    }
    if((untElementNomer > m_untElementMax)||(untElementNomer <= 0)){//Если Номер не в эти рамках, то...
        qdebug(tr("Не правильной номер элемента для его создания."));
        return false;//Ошибка.
    }
    else{//Если нет, то...
        QString strElement = m_pdbElement->SELECT("Номер", QString::number(untElementNomer), "Элемент");
        if(strElement.isEmpty()){//Если Элемент в Списке пустой, то...
            if(untElementNomer != m_untElementMax){//Если не равняется, значит следующий Элемент смотрим.
                m_untElementNomer += 1;//Увеличиваем Номер Элемента на +1.
                sozdatElement(m_untElementNomer);//РЕКУРСИЯ!!! ОПАСНО!!!
            }
        }
        else{//Если не пустой Элемент в Списке, то...
            if(untElementNomer == m_untElementMax){//Если равняется, значит это последний Элемент в Списке
                m_blElementMax = true;//Последний Элемент в Списке.
            }
            QString strElementNomer = QString("%1").arg(untElementNomer, 3, 10, QLatin1Char('0'));//№ Элемента
            strElement = strElementNomer + " " + strElement;//Собираем имя Элемента с номером его.
            if(m_pdrPut->mkdir(strElement)){//Если папка с именем Элемента создалась, то...
                if(!m_pdrPut->cd(strElement)){//Если не получилось перейти в папку с именем Элемента, то...
                    qdebug(tr("Ошибка прехода в папку Элемента: ") + strElement);
                    return false;//Ошибка.
                }
            }
            else{//Если папка с именем Элемента не создалась, то...
                qdebug(tr("Ошибка создания папки Элемента: ") + strElement);
                return false;//Ошибка.
            }
        }
    }
    m_untElementKod = m_pdbElement->SELECT("Номер", QString::number(m_untElementNomer), "Код").toUInt();
    return true;//Успех
}
bool DataKatalog::sozdatDannie(const uint untDannieNomer){//Cкопировать документ по номеру.
///////////////////////////////////////////////////
//---К О П И Р О В А Н И Е   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////

    m_untDannieNomer = untDannieNomer;//Приравниваем параметры в начале метода.
    if(!m_untDannieMax){//ВАЖНО! Если = 0, то читаем из БД, Но при последних Данных в Элементе ОБНУЛЯЕМ!!!
        m_pdbDannie->ustImyaTablici("данные_"	+ QString::number(m_untSpisokKod) + "_"
                                                + QString::number(m_untElementKod));
        m_untDannieMax = m_pdbDannie->SELECTPK();//Подсчитываем количество Данных в конкретом Элементе.
    }
    if((untDannieNomer > m_untDannieMax)||(untDannieNomer <= 0)){//Если Номер не в эти рамках, то...
        qdebug(tr("Не правильной номер данных для его копирования."));
        return false;//Ошибка.
    }
    else{//Если нет, то...
        QString strDannie = m_pdbDannie->SELECT("Номер", QString::number(untDannieNomer), "Данные");
        if(strDannie.isEmpty()){//Если Данные в Элементе пустые, то...
            if(untDannieNomer != m_untDannieMax){//Если не равняется, значит следующий Элемент смотрим.
                m_untDannieNomer += 1;//Увеличиваем Номер Данных на +1.
                sozdatDannie(m_untDannieNomer);//РЕКУРСИЯ!!! ОПАСНО!!!
            }
        }
        else{//Если не пустой Элемент в Списке, то...
            if(untDannieNomer == m_untDannieMax){//Если равняется, значит это последние Данные в Элементе.
                m_blDannieMax = true;//Последние Данные в Элементе.
            }

            QString strDannieNomer = QString("%1").arg(untDannieNomer, 3, 10, QLatin1Char('0'));//№ Данных.
            strDannie = strDannieNomer + " " + strDannie + ".pdf";//Собираем имя Данных с его номером + pdf.

            m_untDannieKod = m_pdbDannie->SELECT("Номер", QString::number(m_untDannieNomer), "Код").toUInt();
            uint ntImyaFaila = (m_untSpisokKod*1000000)+(m_untElementKod*1000)+m_untDannieKod;
            QString strImyaFaila = QString("%1").arg(ntImyaFaila, 9, 10, QLatin1Char('0'))+".pdf";//имя файла
            QString strAbsolutPut=m_strWorkingData+QDir::separator()+strImyaFaila;//Абсолют путь с именем файл

            QFile flDannie (strAbsolutPut);//Файл, который мы хотим скопировать, расположенный...
            if(flDannie.exists()){//Если данный файл существует, то...
                m_pcopykatalog->ustPutiFailov(strAbsolutPut, m_pdrPut->absolutePath()+QDir::separator()
                                                                 +strDannie);
                m_pcopykatalog->start();//Запускаем поток и ждём сигнала о завершении копирования.
            }
            else{
                qdebug(tr("Выбранный файл отсутствует!"));
                return false;
            }
        }
    }
    return false;//Успех.
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
