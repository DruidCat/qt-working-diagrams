#include "dataplan.h"

DataPlan::DataPlan(	QString strMentorPut, quint64 ullDannieMax, QObject* proditel):QObject{proditel}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pcopyplan = new CopyPlan();//Класс потока копирования файла.
    connect(	m_pcopyplan,
                SIGNAL(signalCopyPlan(bool)),
                this,
                SLOT(slotCopyPlan(bool)));//Связываем сигнал статуса копирования документа.
	//qdebug(); не работает, пока конструктор cppqml полностью не создастся.
    m_blPlanPervi = true;//Первый План.(true)
	m_strFileDialogPut = "";//Путь к каталогу, где лежит файл для записи.	
    m_strMentorPut = strMentorPut;//Присваеваем переменной каталог приложения.
    m_ullDannieMax = ullDannieMax;//Приравниваем максимальное количество Данных.
    if(m_ullDannieMax > 999)//Если больше 999, то...
        m_ullDannieMax = 999;//то 999, больше нельзя, алгоритмя приложения не будут работать.
}

DataPlan::~DataPlan(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pcopyplan;//Удаляем указатель
    m_pcopyplan = nullptr;//Обнуляем указатель.
}
bool DataPlan::dbStart(){//Создать первоначальные Данные.
///////////////////////////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////////	
	//qdebug(); не работает, пока конструктор cppqml поностью не создастся.

    return true;
}
void DataPlan::ustMentor(QString strMentorPut){//Задаём каталог хранения Документов.
/////////////////////////////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К А Т А Л О Г   Х Р А Н Е Н И Я   Д О К У М Е Н Т О В---//
/////////////////////////////////////////////////////////////////////////////////////
    m_strMentorPut = strMentorPut;//Приравниваем пути
}
bool DataPlan::ustPlan(quint64 ullSpisokKod, quint64 ullElementKod, QString strFail){
///////////////////////////////////////
//---З А П И С А Т Ь   Д А Н Н Ы Х---//
///////////////////////////////////////
    QString strAbsolutPut=m_strFileDialogPut+QDir::separator()+strFail;//Абсолют путь с именем файла+разшире
    QString strImyaFaila(polImyaFaila(ullSpisokKod, ullElementKod));//Задаём имя файла с Док
    return copyPlan(strAbsolutPut, strImyaFaila);//Копируем Документ в отдельном потоке.
}
bool DataPlan::polPlanPervi(qint64 ullSpisokKod,qint64 ullElementKod){//Первый План?
///////////////////////////////////////
//---Э Т О   П Е Р В Ы Й   П Л А Н---//
///////////////////////////////////////
	if(estImyaFaila(polImyaFaila(ullSpisokKod, ullElementKod)))//Есть такой файл, то...
		m_blPlanPervi = false;//Не первый План.
	else//Если такого нет файла, то...
		m_blPlanPervi = true;//Это будет первый План.
	
	return m_blPlanPervi;//Возвращаем план первый или нет.
}
void DataPlan::ustFileDialogPut(QString strFileDialogPut){//Задать путь к каталогу, в котором файл записи.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т Ь   К   Ф А Й Л У---//
///////////////////////////////////////////////////////
	m_strFileDialogPut = strFileDialogPut;//Приравниваем пути папки открытой в Проводнике.
}
QString DataPlan::polImyaFaila(qint64 ullSpisokKod, qint64 ullElementKod){//Имя файла.
/////////////////////////////////////////////
//---П О Л У Ч И Т Ь   И М Я   Ф А Й Л А---//
/////////////////////////////////////////////
    uint ntImyaFaila = ullSpisokKod * 1000 + ullElementKod;
    QString strImyaFaila = QString("%1").arg(ntImyaFaila, 6, 10, QLatin1Char('0'))+".pdf";
    return strImyaFaila;
}
bool DataPlan::estImyaFaila(QString strImyaFaila){//Есть такой файл в каталоге?
/////////////////////////////////////////
//---Е С Т Ь   Т А К О Й   Ф А Й Л ?---//
/////////////////////////////////////////
    QFile flImyaFaila(m_strMentorPut+QDir::separator()+strImyaFaila);//Объект на файл в каталоге.
    if(flImyaFaila.exists())//Есть такой файл, то...
        return true;
    return false;
}
bool DataPlan::udalFail(QString strImyaFaila){//Удалить файл в каталоге.
/////////////////////////////////////////////
//---У Д А Л И Т Ь   Т А К О Й   Ф А Й Л---//
/////////////////////////////////////////////
    QFile flImyaFaila(m_strMentorPut+QDir::separator()+strImyaFaila);//Объект на файл в каталоге.
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
bool DataPlan::udalDannieFaili(quint64 ullSpisokKod, quint64 ullElementKod){//Удалить все файлы Элемента.
/////////////////////////////////////////////////////
//---У Д А Л И Т Ь   Ф А Й Л Ы   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////
    QDir odrPut(m_strMentorPut);//Создаём объект Дериктории с папкой, где хранятся Документы.
    QStringList slsFaili = odrPut.entryList(QStringList()<<"*.pdf", QDir::Files);//Задаём маску файлов
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

bool DataPlan::copyPlan(QString strAbsolutPut, QString strImyaFaila){//Копируем файл в приложение.
///////////////////////////////////////////
//---К О П И Р О В А Т Ь   Д А Н Н Ы Е---//
///////////////////////////////////////////
    QFile flDannie (strAbsolutPut);//Файл, который мы хотим скопировать, расположенный...
    if(flDannie.exists()){//Если данный файл существует, то...
        if(estImyaFaila(strImyaFaila)){//Если такой файл с таким же именем существует, то...
            if(!udalFail(strImyaFaila))//Удаляем файл с таким же именем. Если файл не удалился, то...
                return false;//Ошибка удаления.
        }
        m_pcopyplan->ustPutiFailov(strAbsolutPut, m_strMentorPut+QDir::separator()+strImyaFaila);
        m_pcopyplan->start();//Запускаем поток и ждём сигнала о завершении копирования.
        return true;
	}
	else
		qdebug(tr("Выбранный файл отсутствует!"));
	
	return false;
}
void DataPlan::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
void DataPlan::slotCopyPlan(bool blCopyStatus){//Слот получающий статус скопированного документа.
///////////////////////////////////////////////////////////////////////////////////
//---С Л О Т   С Т А Т У С А   С К О П И Р О В А Н Н О Г О   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////////////////////////////
    if(!blCopyStatus)//Если копирование завершено с ошбкой, то...
		qdebug(tr("Ошибка записи в базу данных."));
    emit signalFileDialogCopy(blCopyStatus);//Отсылаем сигнал с результатом копирования.
}
