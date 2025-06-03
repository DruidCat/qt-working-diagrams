#include "datakatalog.h"

DataKatalog::DataKatalog(QObject* proditel) : QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

}

DataKatalog::~DataKatalog(){//Деструктор.
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    m_pdbTitul = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    m_pdbSpisok = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    m_pdbElement = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
    m_pdbDannie = nullptr;//Удалять не нужно, так как он в этом классе не выделялся динамически.
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
    quint64 ullPdfSumma(0);//Сумма Pdf документов.

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
                if(m_pdbDannie->SELECT("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod))){//Проверка наличия табл.
                    m_pdbDannie->ustImyaTablici("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));//Задаём Таблицу.
                    qdebug("данные_"+QString::number(ullSpisokKod)+"_"+QString::number(ullElementKod));
                }
            }
        }
    }
    return ullSpisok;
}
void DataKatalog::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
