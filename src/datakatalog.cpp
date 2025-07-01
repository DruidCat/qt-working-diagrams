#include "datakatalog.h"

DataKatalog::DataKatalog(const QString strWorkingData, QObject* proditel) : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    m_untDannie = 0;//Суммарное количество документов в БД.
    dataStart();//Первоначальные значения переменных.
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
    uint untSpisokMax(0);//Количество элементов в Списке.
    uint untElement(0);//количество Элементов в конкретном Списке.
    uint untDannie = m_untDannie = 0;//количество Данных в конкретном Элементе обнуляем.

    if(m_pdbSpisok->SELECT("список")){//Если таблица список существует, то...
        untSpisokMax = m_pdbSpisok->SELECTPK();//Количество Списков созданых и удалённых.
        if(!untSpisokMax)//Если таблица создана, но в ней нет ни одного списка, то...
            return m_untDannie;//Возвращаем 0
    }
    else//Если таблица список не существует, то...
        return m_untDannie;//Возвращаем 0.

    for(uint untSpisokKod = 1; untSpisokKod<= untSpisokMax; untSpisokKod++){
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
void DataKatalog::dataStart(){//Первоначальные значения переменных.
/////////////////////////////////////////////////////////////////////////////
//---П Е Р В О Н А Ч А Л Ь Н Ы Е   З Н А Ч Е Н И Я   П Е Р Е М Е Н Н Ы Е---//
/////////////////////////////////////////////////////////////////////////////

    m_blSpisokMax = false;//true - Последний элемент Списка.
    m_blElementMax = false;//true - Последний Элемент в конкретном Списке.
    m_blDannieMax = false;//true - Последний элемент Данных в конкретном Элементе.

    m_untSpisokKod = 0;//Это код в БД, элемент Списка которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untElementKod = 0;//Это код в БД, в Списке Элемент которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untDannieKod = 0;//Это код в БД, Данные Элемента которох нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!

    m_untSpisokNomer = 0;//Это номер в БД, элемент Списка которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untElementNomer = 0;//Это номер в БД, в Списке Элемент которого нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!
    m_untDannieNomer = 0;//Это номер в БД, Данные Элемента которох нужно прочитать. НОЛЬ НЕ ЧИТАЕТСЯ!

    m_blDataEmpty = false;//Пустая переменная, которая не излучает сигнала Копирования данных.

    m_untCd = 4;//Нахождение в слое папок m_pdrPut(4Start-3Mentor-2Titul-1Spisok-0Element)
}
void DataKatalog::copyStart(){//Старт копирования документов в каталог.
/////////////////////////////////////////////////////////
//---Н А Ч А Л О   С О З Д А Н И Я   К А Т А Л О Г А---//
/////////////////////////////////////////////////////////

    dataStart();//Первоначальные значения переменных.
    if(m_untDannie){//Если в БД записан хоть один документ, то...
        m_pdrPut->setPath(m_strDocPut);//Всегда обнуляем путь на заданную по умолчание папку.
        if(sozdatKatalogMentor()){//Если папка Ментор создалась, то...
            if(sozdatTitul()){//Если папка Титул создалась, то...
                if(sozdatSpisok(1)){//Запускаем цикл создания каталогов и копирования документов со списка №1.
                    if(sozdatElement(1)){//Переходим по Коду Списка и Номеру Элемента.
                        if(sozdatDannie(1)){//Копируем документ по первому Номеру.
                            //emit signalKatalogCopy(false);//Сигнал о том, что авария при копировании документа
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
        if(m_pdrPut->cd(strMentor))//Если переход в папку успешный, то...
            m_untCd -= 1;//Минус слой, переходим в папку Mentora.
        else{//Если переход в папку неуспешный, то...
            qdebug(tr("Ошибка перехода в папку Ментор с каталогом документов."));
            return false;//Ошибка.
        }
    }
    else{//Если ошибка создания каталога, то...
        qdebug(tr("Ошибка создания папки Ментор под каталог документов."));
        return false;//Ошибка.
    }
    qDebug()<< "Слой "<<m_untCd;
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
            if(m_pdrPut->cd(strTitul))//Если получилось перейти в папку с именем Титула, то...
                m_untCd -= 1;//Минус слой, переходим в папку Титула, где Списки.
            else{//Если не получилось перейти в папку с именем Титула, то...
                qdebug(tr("Ошибка прехода в папку Титул с каталогом документов."));
                return false;//Ошибка.
            }
        }
        else{//Если папка с именем титула не создалась, то...
            qdebug(tr("Ошибка создания папки Титула под каталог документов."));
            return false;//Ошибка.
        }
    }
    qDebug()<< "Слой "<<m_untCd;
    return true;//Успех
}
bool DataKatalog::sozdatSpisok(const uint untSpisokNomer){//Слот создающий список по его Номеру.
/////////////////////////////////////////////////
//---С О З Д А Т Ь   П А П К У   С П И С К А---//
/////////////////////////////////////////////////

    m_untSpisokNomer = untSpisokNomer;//Приравниваем параметры в начале метода.
    m_untSpisokKod = m_pdbSpisok->SELECT("Номер", QString::number(untSpisokNomer), "Код").toUInt();
    static uint untSpisokMax = 0;//Статическая переменная Максимального количества элементов Списка.
    if(!untSpisokMax){//ВАЖНО! Если = 0, то читаем из БД, Но при последнем элементе Списка ОБНУЛЯЕМ!!!
        untSpisokMax = m_pdbSpisok->SELECTPK();//Подсчитываем количество элементов в Списке.
        if(!untSpisokMax){//Если ноль элементов Списка, то...
            m_blSpisokMax = true;//Последний элемент Списка.
            m_blElementMax = true;//Последний Элемент в Списке.
            m_blDannieMax = true;//Последние Данные в Элементе.
            m_blDataEmpty = true;//Пустые данные.
            slotCopyDannie(true);//Слот статуса скопированного документа.
            return true;//Успех, выходим из метода.
        }
    }
    if((untSpisokNomer > untSpisokMax)||(untSpisokNomer <= 0)){//Если Номер не в эти рамках, то...
        qdebug(tr("Не правильной номер списка для его создания."));
        return false;//Ошибка.
    }
    else{//Если нет, то...
        if(untSpisokNomer == untSpisokMax){//Если равняется, значит последний элемент Списка.
            m_blSpisokMax = true;//Последний элемент Списка.
            untSpisokMax = 0;//ОБЯЗАТЕЛЬНО ОБНУЛЯЕМ!!!
        }
        QString strSpisok = m_pdbSpisok->SELECT("Номер", QString::number(untSpisokNomer), "Список");
        if(strSpisok.isEmpty()){//Если элемент списка пустой, то...
            m_blDataEmpty = true;//Пустые данные.
            m_blElementMax = true;//Для этого номера списка достигнуто максимальное количество Элементов.
            slotCopyDannie(true);//Слот статуса скопированного документа.
        }
        else{//Если элемент списка не пустой, то...
            QString strSpisokNomer = QString("%1").arg(untSpisokNomer, 3, 10, QLatin1Char('0'));//№ Списка
            strSpisok = strSpisokNomer + " " + strSpisok;//Собираем имя Списка с номером его.
            if(m_pdrPut->mkdir(strSpisok)){//Если папка с именем Списка создалась, то...
                if(m_pdrPut->cd(strSpisok))//Если получилось перейти в папку с именем Списка, то...
                    m_untCd -= 1;//Минус слой, переходим в папку Элемента Списка.
                else{//Если не получилось перейти в папку с именем Списка, то...
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
    qDebug()<< "Слой "<<m_untCd;
    return true;//Успех
}
bool DataKatalog::sozdatElement(const uint untElementNomer){//Создать Элемент по Номеру.
/////////////////////////////////////////////////////
//---С О З Д А Т Ь   П А П К У   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////

    m_untElementNomer = untElementNomer;//Приравниваем параметры в начале метода.
    m_untElementKod = m_pdbElement->SELECT("Номер", QString::number(untElementNomer), "Код").toUInt();
    static uint untElementMax = 0;//Статическая переменная Максимального количества Элементов в Списке.
    if(!untElementMax){//ВАЖНО! Если = 0, то читаем из БД, Но при последнем Элементе в Списке ОБНУЛЯЕМ!!!
        QString strImyaTablici = "элемент_"+QString::number(m_untSpisokKod);
        if(m_pdbElement->SELECT(strImyaTablici)){//Если есть такая таблица, то....
            m_pdbElement->ustImyaTablici(strImyaTablici);//Задаём таблицу Элемента
            untElementMax = m_pdbElement->SELECTPK();//Подсчитываем количество Элементов в каждом из Списков.
            if(!untElementMax){//Если ноль элементов, то...
                m_blElementMax = true;//Последний Элемент в Списке.
                m_blDataEmpty = true;//Пустые данные.
                slotCopyDannie(true);//Слот статуса скопированного документа.
                return true;//Успех, выходим из метода.
            }
        }
        else{//Если нет такой таблици, то...
            m_blElementMax = true;//Последний Элемент в Списке.
            m_blDataEmpty = true;//Пустые данные.
            slotCopyDannie(true);//Слот статуса скопированного документа.
            return true;//Успех, выходим из метода.
        }
    }
    if((untElementNomer > untElementMax)||(untElementNomer <= 0)){//Если Номер не в эти рамках, то...
        qdebug(tr("Не правильной номер элемента для его создания."));
        return false;//Ошибка.
    }
    else{//Если нет, то...
        for(uint untShag = untElementNomer; untShag <= untElementMax; untShag++){
            m_untElementNomer = untShag;
            if(untShag == untElementMax){//Если равняется, значит это последний Элемент в Списке
                m_blElementMax = true;//Последний Элемент в Списке.
                untElementMax = 0;//ОБНУЛЯЕМ ОБЯЗАТЕЛЬНО!!!
            }
            QString strElement = m_pdbElement->SELECT("Номер", QString::number(untShag), "Элемент");
            if(strElement.isEmpty()){//Если Элемент в Списке пустой, то...
                m_blDataEmpty = true;//Пустые данные.
                m_blDannieMax = true;//Значит для этого Элемента достигнута максимальное значение Данных.
                qDebug() << "Пустой элемент, пропускаю его.";
            }
            else{//Если Элемент в Списке не пустой, то...
                QString strElementNomer = QString("%1").arg(untShag, 3, 10, QLatin1Char('0'));//№ Элемента
                strElement = strElementNomer + " " + strElement;//Собираем имя Элемента с номером его.
                qDebug()<<strElement << " из " << untElementMax;
                if(m_pdrPut->mkdir(strElement)){//Если папка с именем Элемента создалась, то...
                    if(m_pdrPut->cd(strElement)){//Если получилось перейти в папку с именем Элемента, то...
                        m_untCd -= 1;//Минус слой, переходим в папку Элемента.
                        qDebug()<< "Слой "<<m_untCd << " Выхожу из sozdatElement";
                        return true;//Выскакиеваем из цикла и функции.
                    }
                    else{//Если не получилось перейти в папку с именем Элемента, то...
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
    }
    return true;//Успех
}
bool DataKatalog::sozdatDannie(const uint untDannieNomer){//Cкопировать документ по номеру.
///////////////////////////////////////////////////
//---К О П И Р О В А Н И Е   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////


    m_untDannieNomer = untDannieNomer;//Приравниваем параметры в начале метода.
    static uint  untDannieMax = 0;//Статическая переменная Максимального количества Данных в Элементе.
    if(!untDannieMax){//ВАЖНО! Если = 0, то читаем из БД, Но при последних Данных в Элементе ОБНУЛЯЕМ!!!
        QString strImyaTablici = "данные_" 	+ QString::number(m_untSpisokKod)
                                            + "_"
                                            + QString::number(m_untElementKod);
        qDebug()<< "m_untSpisokKod " << m_untSpisokKod << " m_untElementKod " << m_untElementKod
                 << " Имя таблицы " << strImyaTablici;
        if(m_pdbDannie->SELECT(strImyaTablici)){//Если есть такая таблица, то...
            qDebug()<< "Запускаю sozdatDannie 3";
            m_pdbDannie->ustImyaTablici(strImyaTablici);
            untDannieMax = m_pdbDannie->SELECTPK();//Подсчитываем количество Данных в конкретом Элементе.
            if(!untDannieMax){//Если ноль данных, то...
                qDebug()<< "Запускаю sozdatDannie 4";
                m_blDannieMax = true;//Последние Данные в Элементе.
                m_blDataEmpty = true;//Пустые данные.
                slotCopyDannie(true);//Слот статуса скопированного документа.
                qDebug() << "Выскочил";
                return true;//Успех, выходим из метода.
            }
        }
        else{//Если не такой таблицы, то...
            qDebug()<< "Запускаю sozdatDannie 5";
            m_blDannieMax = true;//Последние Данные в Элементе.
            m_blDataEmpty = true;//Пустые данные.
            slotCopyDannie(true);//Слот статуса скопированного документа.
            qDebug() << "Выскочил +++";
            return true;//Успех, выходим из метода.
        }
    }
    qDebug()<<"Данные, номер " << untDannieNomer <<" из " <<untDannieMax;
    if((untDannieNomer > untDannieMax)||(untDannieNomer <= 0)){//Если Номер не в эти рамках, то...
        qdebug(tr("Не правильной номер данных для его копирования."));
        return false;//Ошибка.
    }
    else{//Если нет, то...
        if(untDannieNomer == untDannieMax){//Если равняется, значит это последние Данные в Элементе.
            m_blDannieMax = true;//Последние Данные в Элементе.
            untDannieMax = 0;//ОБНУЛЯЕМ ОБЯЗАТЕЛЬНО!!!
        }
        qDebug()<<"Номер данных "<<untDannieNomer;
        QString strDannie = m_pdbDannie->SELECT("Номер", QString::number(untDannieNomer), "Данные");
        if(strDannie.isEmpty()){//Если Данные в Элементе пустые, то...
            m_blDataEmpty = true;//Пустые данные.
            slotCopyDannie(true);//Слот статуса скопированного документа.
        }
        else{//Если Данные в Элементе не пустые, то...
            QString strDannieNomer = QString("%1").arg(untDannieNomer, 3, 10, QLatin1Char('0'));//№ Данных.
            strDannie = strDannieNomer + " " + strDannie + ".pdf";//Собираем имя Данных с его номером + pdf.

            m_untDannieKod = m_pdbDannie->SELECT("Номер", QString::number(untDannieNomer), "Код").toUInt();
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
    return true;//Успех.
}
bool DataKatalog::nazadSpisok(){//Переходим назад в папку со Списками.
/////////////////////////////////////
//---Н А З А Д   В   С П И С О К---//
/////////////////////////////////////

    for (uint untShag = m_untCd; untShag < 2; untShag++){
        if(m_pdrPut->cd(".."))//Если получилось перейти в папку назад к Элементам, то...
            m_untCd += 1;//Переходим на слой выше.
        else{//Если не получилось перейти в папку назад к Элементам, то...
            qdebug(tr("Ошибка прехода назад в папку Элемента."));
            return false;//Ошибка.
        }
    }
    qDebug()<< "Слой "<<m_untCd;
    return true;//Успех.
}
bool DataKatalog::nazadElement(){//Переходим назад в папку с Элементами.
///////////////////////////////////////
//---Н А З А Д   В   Э Л Е М Е Н Т---//
///////////////////////////////////////

    qDebug()<<"nazadElement";
    if(m_untCd < 1){//Если 0, то мы внутри папки Элемент, то можно...
        if(m_pdrPut->cd(".."))//Если получилось перейти в папку назад к Элементам, то...
            m_untCd += 1;//Переходим на слой выше.
        else{//Если не получилось перейти в папку назад к Элементам, то...
            qdebug(tr("Ошибка прехода назад в папку Элемента."));
            return false;//Ошибка.
        }
    }
    qDebug()<< "Слой "<<m_untCd;
    return true;//Успех
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
        if(!m_blDataEmpty)//Если флаг не взведён, то...
            emit signalKatalogCopy(blCopyStatus);//отсылаем сигнал 1
        else//Если флаг взведён, то...
            m_blDataEmpty = false;//Сбрасываем флаг пустых данных.

        if(m_blDannieMax){//Если это последние данные в конкретном Элементе, то...
            m_blDannieMax = false;//Обнуляем флаг.
            if(m_blSpisokMax && m_blElementMax){//Если, то это окончание копирования.
                m_blSpisokMax = false;//Сбрасываем флаг.
                m_blElementMax = false;//Сбрасываем флаг.
                emit signalKatalogCopy(false);//Сигнал о том, ЦИКЛ СОЗДАНИЯ КАТАЛОГА ЗАВЕРШЁН!!!
            }
            else{//Если это не конечный Список, то...
                if(m_blElementMax){//Если это конечный Элемент из Списка, то...
                    m_blElementMax = false;//Сбрасываем флаг.
                    if(nazadSpisok()){//Переходим в папку элементов Списка.
                        m_untSpisokNomer +=1;//Увеличиваем Номер Списка на +1.
                        if(sozdatSpisok(m_untSpisokNomer)){//Запускаем цикл создания каталогов и коп. докум.
                            if(sozdatElement(1)){//Переходим по Коду Списка и Номеру Элемента.
                                if(!sozdatDannie(1)){//Если ошибка Копирования документа по первому Номеру, то
                                    emit signalKatalogCopy(false);//Сигнал , что авария при копировании док.
                                }
                            }
                            else
                                emit signalKatalogCopy(false);//Cигнал о том, что авария при создании каталог
                        }
                        else
                            emit signalKatalogCopy(false);//Cигнал о том, что авария при создании каталога.
                    }
                }
                else{//Это последние данные в конкретном Элементе...
                    if(nazadElement()){//Переходим в папку Элементов.
                        m_untElementNomer += 1;//Увеличиваем Номер Элемента на +1.
                        if(sozdatElement(m_untElementNomer)){//Переходим по Коду Списка и Номеру Элемента.
                            qDebug()<< "Запускаю sozdatDannie(1)";
                            if(!sozdatDannie(1))//Если ошибка Копирования документа по первому Номеру, то
                                emit signalKatalogCopy(false);//Сигнал, что авария при копировании документа
                        }
                        else
                            emit signalKatalogCopy(false);//Сигнал о том, что авария при создании каталог
                    }
                }
            }
        }
        else{
            m_untDannieNomer += 1;//Увеличиваем Номер Данных на +1.
            if(!sozdatDannie(m_untDannieNomer))//Если ошибка при копировании документа, то...
                emit signalKatalogCopy(false);//Сигнал о том, что авария при копировании документа
        }
    }
    else{
        qdebug(tr("Ошибка копирования в каталог документов."));
        emit signalKatalogCopy(blCopyStatus);//Отсылаем сигнал об ошибке копирования.
    }
}
