﻿#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject* proditel) : QObject{proditel},
                                        m_untNastroikiMaxLength(33),
										m_strTitul(""),
										m_strTitulOpisanie(""),

										m_strSpisok(""),
										m_strSpisokDB(""),
										m_ullSpisokKod(0),
										m_strSpisokOpisanie(""),
                                        m_blSpisokPervi(false),

                                        m_strElement(""),
										m_strElementDB(""),
										m_ullElementKod(0),
										m_strElementOpisanie(""),
										m_blElementPervi(false),

                                        m_strDannie(""),
                                        m_strDannieDB(""),
                                        m_ullDannieKod(0),
                                        m_blDanniePervi(false),

                                        m_strFileDialog(""),
                                        m_strFileDialogPut(""),
                                        m_blFileDialogCopy(false),

                                        m_strDebug("")
{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    QString strImyaDB = "druidcat.db";//Имя БД таблиц с титулом, списками, элементами, данными.
    QString strImyaDBData = "druiddat.db";// Имя БД с файлами документов.
	QString strLoginDB = "druidcat";//Логин входа в БД.
	QString strParolDB = "druidcat";//Пароль входа в БД.
    quint64 ullSpisokMax = 999;//Максимальное количество Списков.
    quint64 ullElementMax = 999;//Максимальное количество Элементов.
    quint64 ullDannieMax = 999;//Максимальное количество Данных.
    QString strKatalogDB = "workingdata";//Имя дериктория хранения данных
    QStringList slsFileDialogMaska = QStringList() << "*.pdf" << "*.PDF" << "*.Pdf"<<"*.m4b";

    QDir odrWorkingDiagrams = QDir::current();//Объект каталога приложения.
    if(!odrWorkingDiagrams.cd(strKatalogDB)){//Если перейти к это папке не получается, то...
        if(odrWorkingDiagrams.mkdir(strKatalogDB)){//Создаём начальную дерикторию хранения данных
            if(!odrWorkingDiagrams.cd(strKatalogDB))
                qWarning()<<tr("DataDannie::DataDannie: ошибка перехода в созданную папку хранения "
                        "документов!");
        }
        else
            qWarning()<<tr("DataDannie::DataDannie: ошибка создания папки хранения документов.");
    }
    QString strWorkingDiagramsPut = odrWorkingDiagrams.path();//Присваеваем переменной каталог приложения.

    strImyaDB = strWorkingDiagramsPut + QDir::separator() + strImyaDB;
    strImyaDBData  = strWorkingDiagramsPut + QDir::separator() + strImyaDBData;

    m_pDataTitul = new DataTitul(strImyaDB, strLoginDB, strParolDB);//Титул.
    m_pDataSpisok = new DataSpisok(strImyaDB, strLoginDB, strParolDB, ullSpisokMax);//Список.
    m_pDataElement = new DataElement(strImyaDB, strLoginDB, strParolDB, ullElementMax);//Элементы.
    m_pDataDannie = new DataDannie(strImyaDB, strImyaDBData, strLoginDB, strParolDB, strWorkingDiagramsPut,
                                   ullDannieMax);//Данные.
    m_pFileDialog = new DCFileDialog(slsFileDialogMaska);//Проводник.
    connect(	m_pDataTitul,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
	connect(	m_pDataSpisok,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
	connect(	m_pDataElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    connect(	m_pDataDannie,
                SIGNAL(signalDebug(QString)),
                this,
                SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    connect(	m_pDataDannie,
                SIGNAL(signalFileDialogCopy(bool)),
                this,
                SLOT(slotFileDialogCopy(bool)));//Связываем сигнал статуса скопированного документа в Проводни
    m_pDataTitul->dbStart();//Записываем первоначальные данные в БД.
    m_pDataSpisok->dbStart();//Записываем первоначальные данные в БД.
    m_pDataElement->dbStart();//Записываем первоначальные данные в БД.
    m_pDataDannie->dbStart();//Записываем первоначальные данные в БД.
    m_pdcclass = new DCClass;//Создаём динамический указатель на класс часто используемых методов.
	m_pTimerDebug = new QTimer();//Указатель на QTimer для Debug
	m_pTimerDebug->setInterval(1000);//Интервал прерывания 1000 мс (1с).
	m_untDebugSec = 0;//Обнуляем счётчик секунд.
	connect( 	m_pTimerDebug,
				SIGNAL(timeout()),
				this,
				SLOT(slotTimerDebug()));//При сигнале на прерывание таймера, запускаем слот таймера.
}
DCCppQml::~DCCppQml(){//Деструктор.
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
	delete m_pDataTitul;//Удаляем указатель.
    m_pDataTitul = nullptr;//Указатель на таблицу Списка в БД обнуляем.
	delete m_pDataSpisok;//Удаляем указатель.
    m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД обнуляем.
    delete m_pDataElement;//Удаляем указатель.
    m_pDataElement = nullptr;//Указатель на таблицу Элементов в БД обнуляем.
    delete m_pDataDannie;//Удаляем указатель.
    m_pDataDannie = nullptr;//Указатель на таблицу Данных в БД обнуляем.
    delete m_pFileDialog;//Удаляем указатель.
    m_pFileDialog = nullptr;//Указатель на Проводник в БД обнуляем.
	delete m_pTimerDebug;//Удаляем указатель на таймер.
	m_pTimerDebug = nullptr;//Обнуляем указатель на таймер отладки.
	delete m_pdcclass;//Удаляем указатель.
	m_pdcclass = nullptr;//Обнуляем указатель
}
QString DCCppQml::strTitul() {//Получить имя Титула.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   И М Я   Т И Т У Л А---//
///////////////////////////////////////////////
	QString strTitul = m_pDataTitul->polTitul();
	m_strTitul = strTitul;
    return m_strTitul;
}
void DCCppQml::setStrTitul(QString& strTitulNovi) {//Переименование имени Титула.
///////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Н И Е   И М Е Н И   Т И Т У Л А---//
///////////////////////////////////////////////////////////////
	if(m_pdcclass->isEmpty(strTitulNovi)){//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустое имя титула."));
	}
	else{
		strTitulNovi = redaktorTexta(strTitulNovi);//Редактируем текст по стандартам приложения.
		if(m_strTitul != strTitulNovi){//Если имена титулов не совпадают, то...
			if(m_pDataTitul->renTitul(strTitulNovi))//Если имя Титула записалось успешно, то...
				emit strTitulChanged();//Излучаем сигнал об изменении аргумента.
		}
	}
}
QString DCCppQml::strTitulOpisanie() {//Получить описание Титула.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Т И Т У Л А---//
/////////////////////////////////////////////////////////
	QString strTitulOpisanie = m_pDataTitul->polTitulOpisanie();
	m_strTitulOpisanie = strTitulOpisanie;
    return m_strTitulOpisanie;
}
void DCCppQml::setStrTitulOpisanie(QString& strTitulOpisanieNovi) {//Переименование описание Титула.
/////////////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Н И Е   О П И С А Н И Е   Т И Т У Л А---//
/////////////////////////////////////////////////////////////////////
    strTitulOpisanieNovi = m_pdcclass->sql_encode(strTitulOpisanieNovi);//Удаляем sql инекции.
    if(m_strTitulOpisanie != strTitulOpisanieNovi){//Если описание титулов не совпадают, то...
        if(m_pDataTitul->renTitulOpisanie(strTitulOpisanieNovi)){//Если описание Титула записалось успешно
            m_strTitulOpisanie = strTitulOpisanieNovi;
            qdebug(tr("Новоя запись в описании заголовка."));
            emit strTitulOpisanieChanged();//Излучаем сигнал об изменении аргумента.
        }
    }
}
QString DCCppQml::strSpisok() {//Получить элемента Списка.
///////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Э Л Е М Е Н Т   С П И С К А---//
///////////////////////////////////////////////////////
    return m_strSpisok;
}
void DCCppQml::setStrSpisok(QString& strSpisokNovi) {//Изменение элемента списка.
///////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   Э Л Е М Е Н Т А   С П И С К А---//
///////////////////////////////////////////////////////////
	if(strSpisokNovi != m_strSpisok){//Если элемент списка не равен выбранному до этого, то...
		m_strSpisok = strSpisokNovi;//Приравниваем.
		emit strSpisokChanged();//Излучаем сигнал об изменении аргумента.
	}
}
QString DCCppQml::strSpisokDB() {//Возвратить JSON строку Списка.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С П И С К А---//
/////////////////////////////////////////////////
    m_strSpisokDB = m_pDataSpisok->polSpisokJSON();//Считываем строку JSON, приравниваем её к переменной.
    m_blSpisokPervi = m_pDataSpisok->polSpisokPervi();//Первый в списке или нет? Строчка обязательна тут.
    return m_strSpisokDB;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrSpisokDB(QString& strSpisokNovi) {//Запись элемента Списка в БД.
/////////////////////////////////////////////////////
//---З А П И С Ь   Э Л Е М Е Н Т А   С П И С К А---//
/////////////////////////////////////////////////////
	if(m_pdcclass->isEmpty(strSpisokNovi))//Если пустая строка, то...
		qdebug("Нельзя сохранять пустые элементы списка.");
	else{
		strSpisokNovi = redaktorTexta(strSpisokNovi);//Редактируем текст по стандартам приложения.
		QStringList slsSpisok = m_pDataSpisok->polSpisok();//Получить список всех элементов Списка.
        for(int ntShag = 0; ntShag<slsSpisok.size(); ntShag++){//Проверка на одинаковые имена элементов
            if(slsSpisok[ntShag] == strSpisokNovi){
                qdebug(tr("Нельзя сохранять одинаковые элементы списка."));
				return;
			}
		}
		if(m_pDataSpisok->ustSpisok(strSpisokNovi)){//Если элемент списка записался успешно, то...
        	emit strSpisokDBChanged();//Излучаем сигнал об изменении аргумента.
		}
	}
}
bool DCCppQml::renStrSpisokDB(QString strSpisok, QString strSpisokNovi){//Переимен. элемент Списка
/////////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т   С П И С К А---//
/////////////////////////////////////////////////////////////////
	if(m_pdcclass->isEmpty(strSpisokNovi)){//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустой элемент списка."));
		return false;//Отмена.
	}
	else{
		strSpisokNovi = redaktorTexta(strSpisokNovi);//Редактируем текст по стандартам приложения.
		QStringList slsSpisok = m_pDataSpisok->polSpisok();//Получить список всех элементов Списка.
        for(int ntShag = 0; ntShag<slsSpisok.size(); ntShag++){//Проверка на одинаковые имена элементов
            if(slsSpisok[ntShag] == strSpisokNovi){
                qdebug(tr("Нельзя переименовывать на одноимённый элемент списка."));
				return false;//Отмена.
			}
		}
		if(m_pDataSpisok->renSpisok(strSpisok, strSpisokNovi))//Если элемент списка записался успешно, то...
        	emit strSpisokDBChanged();//Излучаем сигнал об изменении аргумента.
		else
			return false;//Отмена.
	}
	return true;//Успех.
}
quint64 DCCppQml::ullSpisokKod(){//Возвращает Код элемента Списка.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   С П И С К А---//
///////////////////////////////////////////////
	return m_ullSpisokKod;
}
void DCCppQml::setUllSpisokKod(quint64 ullSpisokKodNovi){//Изменить код списка.
///////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К О Д   С П И С К А---//
///////////////////////////////////////////////////
    if (ullSpisokKodNovi<=0)//Если номер меньше или равен 0, то...
		qdebug("DCCppQml::setUllSpisokKod(quint64): quint64 меньше или равен 0.");
	else {//Иначе...
		if (m_ullSpisokKod != ullSpisokKodNovi){//Если не равны параметры, то...
			m_ullSpisokKod = ullSpisokKodNovi;
			emit ullSpisokKodChanged();//Сигнал о том, что код списка изменился.
		}
	}
}
QString DCCppQml::strSpisokOpisanie(){//Возвращает Описание элемента Списка
/////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////////
	//Используем статическую переменную, чтоб минимизировать обращение к БД.
	static uint stullSpisokKod = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	if(stullSpisokKod != m_ullSpisokKod){//Если коды списка разные, то...
		m_strSpisokOpisanie = m_pDataSpisok->polSpisokOpisanie(m_ullSpisokKod);//По Коду читаем Описание.
		stullSpisokKod = m_ullSpisokKod;//Присваеваем статической переменной Код Описания Списка.
	}
	return m_strSpisokOpisanie;//Возвращаем считаное или не считаное из БД Описание.
}
void DCCppQml::setStrSpisokOpisanie(QString& strSpisokOpisanieNovi){//Изменить описание списка.
///////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   О П И С А Н И Я   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////
    strSpisokOpisanieNovi = m_pdcclass->sql_encode(strSpisokOpisanieNovi);//Удаляем sql инекции.
    if(strSpisokOpisanieNovi != m_strSpisokOpisanie){//Если Описания разные, то...
		if(m_pDataSpisok->ustSpisokOpisanie(m_ullSpisokKod, strSpisokOpisanieNovi)){//Записалось Описание,то
			m_strSpisokOpisanie = strSpisokOpisanieNovi;//Новое описание присвоили.
            qdebug("Новоя запись в описании списка.");
			emit strSpisokOpisanieChanged();//Сигнал о том, что описание поменялось.
		}
	}
}
QString DCCppQml::strElement() {//Получить элемент.
/////////////////////////////////////////
//---П О Л У Ч И Т Ь   Э Л Е М Е Н Т---//
/////////////////////////////////////////
    return m_strElement;
}
void DCCppQml::setStrElement(QString& strElementNovi) {//Изменение элемента.
/////////////////////////////////////////////
//---И З М Е Н Е Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////
	if(strElementNovi != m_strElement){//Если элемент не равен выбранному до этого, то...
		m_strElement = strElementNovi;//Приравниваем.
		emit strElementChanged();//Излучаем сигнал об изменении аргумента.
	}
}
QString DCCppQml::strElementDB() {//Возвратить JSON строку Элементов.
///////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////
    m_strElementDB = m_pDataElement->polElementJSON(m_ullSpisokKod);//Считываем строку JSON.
	m_blElementPervi = m_pDataElement->polElementPervi();//Первый элемент или нет? Строчка обязательна тут.
    return m_strElementDB;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrElementDB(QString& strElementNovi) {//Запись Элемента в БД.
///////////////////////////////////////
//---З А П И С Ь   Э Л Е М Е Н Т А---//
///////////////////////////////////////
	if(m_pdcclass->isEmpty(strElementNovi))//Если пустая строка, то...
        qdebug(tr("Нельзя сохранять пустой элемент."));
	else{
		strElementNovi = redaktorTexta(strElementNovi);//Редактируем текст по стандартам приложения.
        QStringList slsElement = m_pDataElement->polElement(m_ullSpisokKod);//Получить список всех Элементов.
        for(int ntShag = 0; ntShag<slsElement.size(); ntShag++){//Проверка на одинаковые имена элементо
            if(slsElement[ntShag] == strElementNovi){
                qdebug(tr("Нельзя сохранять одинаковые элементы."));
				return;
			}
		}
		if(m_pDataElement->ustElement(m_ullSpisokKod, strElementNovi)){//Если элемент списка записался успешно
        	emit strElementDBChanged();//Излучаем сигнал об изменении списка Элементов.
		}
    }
}
bool DCCppQml::renStrElementDB(QString strElement, QString strElementNovi) {//Переимен. Элемент
///////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т---//
///////////////////////////////////////////////////
    if(m_pdcclass->isEmpty(strElementNovi)) {//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустой элемент списка."));
        return false;//Отмена.
    }
    else {
        strElementNovi = redaktorTexta(strElementNovi);//Редактируем текст по стандартам приложения.
        QStringList slsElement = m_pDataElement->polElement(m_ullSpisokKod);//Получить список всех Элементов.
        for(int ntShag = 0; ntShag<slsElement.size(); ntShag++){//Проверка на одинаковые имена элементов
            if(slsElement[ntShag] == strElementNovi) {
                qdebug(tr("Нельзя переименовывать на одноимённый элемент списка."));
                return false;//Отмена.
            }
        }
        if(m_pDataElement->renElement(m_ullSpisokKod, strElement, strElementNovi))//элемент записался успешно.
            emit strElementDBChanged();//Излучаем сигнал об изменении Элемента в списке.
        else//Если ошибка записи, то...
            return false;//Отмена.
    }
    return true;//Успех.
}
quint64 DCCppQml::ullElementKod(){//Возвращает Код Элемента.
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////
	return m_ullElementKod;
}
void DCCppQml::setUllElementKod(quint64 ullElementKodNovi){//Изменить код Элемента.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К О Д   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////
	if (ullElementKodNovi<=0)//Если номер меньше или равен 0, то...
		qdebug("DCCppQml::setUllElementKod(quint64): quint64 меньше или равен 0.");
	else {//Иначе...
		if (m_ullElementKod != ullElementKodNovi){//Если не равны параметры, то...
			m_ullElementKod = ullElementKodNovi;
			emit ullElementKodChanged();//Сигнал о том, что код Элемента изменился.
		}
	}
}
QString DCCppQml::strElementOpisanie(){//Возвращает Описание Элемента
/////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////////
	//Используем статическую переменную, чтоб минимизировать обращение к БД.
	static uint stullSpisokKod = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	static uint stullElementKod = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	if((stullSpisokKod != m_ullSpisokKod)||(stullElementKod != m_ullElementKod)){//Если коды списка разные, то
		m_strElementOpisanie = m_pDataElement->polElementOpisanie(m_ullSpisokKod, m_ullElementKod);//Описание.
		stullSpisokKod = m_ullSpisokKod;//Присваеваем статической переменной Код Описания Списка.
		stullElementKod = m_ullElementKod;//Присваеваем статической переменной Код Описания Элемента.
	}
	return m_strElementOpisanie;//Возвращаем считаное или не считаное из БД Описание.
}
void DCCppQml::setStrElementOpisanie(QString& strElementOpisanieNovi){//Изменить описание Элемента.
///////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   О П И С А Н И Я   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////
    strElementOpisanieNovi = m_pdcclass->sql_encode(strElementOpisanieNovi);//Удаляем sql инекции.
    if(strElementOpisanieNovi != m_strElementOpisanie){//Если Описания разные, то...
		if(m_pDataElement->ustElementOpisanie(m_ullSpisokKod, m_ullElementKod, strElementOpisanieNovi)){
			m_strElementOpisanie = strElementOpisanieNovi;//Новое описание присвоили.
            qdebug(tr("Новоя запись в описании элемента."));
			emit strElementOpisanieChanged();//Сигнал о том, что описание поменялось.
		}
	}
}
QString DCCppQml::strDannie(){//Получить Данные.
///////////////////////////////////////
//---П О Л У Ч И Т Ь   Д А Н Н Ы Е---//
///////////////////////////////////////
    return m_strDannie;
}
void DCCppQml::setStrDannie(QString& strDannieNovi) {//Изменение Данных.
/////////////////////////////////////////
//---И З М Е Н Е Н И Е   Д А Н Н Ы Х---//
/////////////////////////////////////////
    if(strDannieNovi != m_strDannie){//Если Данные не равны выбранному до этого, то...
        m_strDannie = strDannieNovi;//Приравниваем.
        emit strDannieChanged();//Излучаем сигнал об изменении аргумента.
    }
}
bool DCCppQml::delStrDannie(QString strDannieKod){//Удалить данные по коду
/////////////////////////////////////
//---У Д А Л И Т Ь   Д А Н Н Ы Е---//
/////////////////////////////////////
    if(m_pDataDannie->udalDannie(m_ullSpisokKod, m_ullElementKod, strDannieKod.toULongLong())){//Если удаление
        emit strDannieDBChanged();//Излучаем сигнал, чтоб обновился списик Данных, после удаления.
        return true;//Успех удаления записи из БД и Документа.
    }
    return false;//Ошибка удаления записи из БД и Документа.

}
QString DCCppQml::strDannieDB() {//Возвратить JSON строку с Данными.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   Д А Н Н Ы Е---//
/////////////////////////////////////////////////
    m_strDannieDB = m_pDataDannie->polDannieJSON(m_ullSpisokKod, m_ullElementKod);//Считываем строку JSON.
    m_blDanniePervi = m_pDataDannie->polDanniePervi();//Первые Данные или нет? Строчка обязательна тут.
    return m_strDannieDB;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrDannieDB(QString& strImyaFaila) {//Запись Данных в БД.
///////////////////////////////////
//---З А П И С Ь   Д А Н Н Ы Х---//
///////////////////////////////////
    if(m_pdcclass->isEmpty(strImyaFaila))//Если пустая строка, то...
        qdebug(tr("Нельзя сохранить пустые данные."));
    else{
        QString strDannie = m_pdcclass->baseName(strImyaFaila);//Убираем расширение из имени файла.
        strDannie = redaktorTexta(strDannie);//Редактируем текст по стандартам приложения.
        QStringList slsDannie = m_pDataDannie->polDannie(m_ullSpisokKod, m_ullElementKod);//Получить Данные
        for(int ntShag = 0; ntShag<slsDannie.size(); ntShag++){//Проверка на одинаковые имена Данных
            if(slsDannie[ntShag] == strDannie){
                qdebug(tr("Нельзя сохранять одинаковые данные."));
                return;
            }
        }
        //Копируем Документ в Приложение, делаем запись в БД, а сигнал об этих действиях в slotFileDialogCopy
        m_pDataDannie->ustDannie(m_ullSpisokKod, m_ullElementKod, strImyaFaila, strDannie);//Копируем,записыва
    }
}
bool DCCppQml::renStrDannieDB(QString strDannie, QString strDannieNovi) {//Переименовать Данные.
/////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Д А Н Н Ы Е---//
/////////////////////////////////////////////////
    if(m_pdcclass->isEmpty(strDannieNovi)) {//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустой элемент данных."));
        return false;//Отмена.
    }
    else {
        strDannieNovi = redaktorTexta(strDannieNovi);//Редактируем текст по стандартам приложения.
        QStringList slsDannie = m_pDataDannie->polDannie(m_ullSpisokKod, m_ullElementKod);//получ список Данны
        for(int ntShag = 0; ntShag<slsDannie.size(); ntShag++){//Проверка на одинаковые имена Данных.
            if(slsDannie[ntShag] == strDannieNovi) {
                qdebug(tr("Нельзя переименовывать на одноимённый элемент данных."));
                return false;//Отмена.
            }
        }
        if(m_pDataDannie->renDannie(m_ullSpisokKod, m_ullElementKod, strDannie, strDannieNovi))//Запись успешн
            emit strDannieDBChanged();//Излучаем сигнал об изменении Данных в списке.
        else//Если ошибка записи, то...
            return false;//Отмена.
    }
    return true;//Успех.
}
quint64 DCCppQml::ullDannieKod(){//Возвращает Код Данных.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   Д А Н Н Ы Х---//
///////////////////////////////////////////////
    return m_ullDannieKod;
}
void DCCppQml::setUllDannieKod(quint64 ullDannieKodNovi){//Изменить код Данных.
///////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К О Д   Д А Н Н Ы Х---//
///////////////////////////////////////////////////
    if (ullDannieKodNovi<=0)//Если номер меньше или равен 0, то...
        qdebug("DCCppQml::setUllDannieKod(quint64): quint64 меньше или равен 0.");
    else {//Иначе...
        if (m_ullDannieKod != ullDannieKodNovi){//Если не равны параметры, то...
            m_ullDannieKod = ullDannieKodNovi;
            emit ullDannieKodChanged();//Сигнал о том, что код Данных изменился.
        }
    }
}
QString DCCppQml::strFileDialog() {//Возвратить JSON строку с папками и файлами.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   F I L E D I A L O G---//
///////////////////////////////////////////////
    m_strFileDialog = m_pFileDialog->polSpisokJSON();//Возвратить список папок и файлов в JSON. Или имя файла.
    return m_strFileDialog;//Возвратить список папок и файлов в формате JSON. Или Имя выбранного файла.
}
void DCCppQml::setStrFileDialog(QString& strFileDialogNovi) {//Изменение JSON запроса с папками и файлами.
/////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   F I L E D I A L O G---//
/////////////////////////////////////////////////
    if(m_pFileDialog->ustSpisokJSON(strFileDialogNovi)){//Если задан новый путь успешно, то...
        emit strFileDialogPutChanged();//Излучаем сигнал об изменении аргумента.
        emit strFileDialogChanged();//Излучаем сигнал об изменении аргумента.
    }
}
QString DCCppQml::strFileDialogPut() {//Возвратить путь отображения содержимого папки.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   П У Т Ь   F I L E D I A L O G---//
/////////////////////////////////////////////////////////
    m_strFileDialogPut = m_pFileDialog->polFileDialogPut();//Получить путь каталога.
	m_pDataDannie->ustFileDialogPut(m_strFileDialogPut);//Задаём путь к каталогу, где лежит файл для записи.
    return m_strFileDialogPut;//Возвратить путь отображения содержимого папки.
}
void DCCppQml::setStrFileDialogPut(QString& strFileDialogPutNovi){//Записываем новый путь отображения папки.
///////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   П У Т Ь   F I L E D I A L O G---//
///////////////////////////////////////////////////////////
    //strFileDialogPutNovi = dom; Задаёт домашнюю дерикторию.
    if(m_pFileDialog->ustFileDialogPut(strFileDialogPutNovi)){//Если путь изменился успешно, то...
        m_strFileDialogPut = strFileDialogPut();//Изменяем путь переменной.
        emit strFileDialogPutChanged();//Излучаем сигнал об изменении аргумента.
    }
}
QString DCCppQml::strDebug(){//Возвращает ошибку.
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Т Е К С Т   О Ш И Б К И---//
///////////////////////////////////////////////////
	return m_strDebug;
}
void DCCppQml::setStrDebug(QString& strDebugNovi){//Установить Новую ошибку.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   Т Е К С Т   О Ш И Б К И---//
///////////////////////////////////////////////////////
    m_untDebugSec = 0;//Обнуляем счётчик секунд в любом случае.
    if(strDebugNovi == "")//Стераем сообщение из Toolbar
        m_pTimerDebug->stop();//Останавливаем таймер.
    else{
        QString strLog = QTime::currentTime().toString("HH:mm:ss");//В строку добавляем текущее время.
        strDebugNovi = strLog + ": " + strDebugNovi;//Добавляем двоеточие и само Сообщение.
        m_pTimerDebug->start();//Запустить таймер.
    }
	m_strDebug = strDebugNovi;
	qWarning()<<m_strDebug;//Пишем ошибку в отладочную консоль.
    emit strDebugChanged();//Излучаем сигнал в qml с ошибкой.
}
QString DCCppQml::redaktorTexta(QString strTekst){//Редактор текста по стандартам Приложения.
///////////////////////////////////////
//---Р Е Д А К Т О Р   Т Е К С Т А---//
///////////////////////////////////////
	strTekst = strTekst.toUpper();//Делаем все буквы в строке заглавные.
	strTekst = m_pdcclass->udalitProbeli(strTekst);//Удаляем 2 и более пробелов между словами.
	strTekst = m_pdcclass->udalitPustotu(strTekst);//Удаляем пробелы по краям, если есть.
    strTekst.truncate(m_untNastroikiMaxLength);//Обрезаем текс на максимальную длину в настройках приложения.
	return strTekst;//Возвращаем отредактированный текст.
}
void DCCppQml::qdebug(QString strDebug){//Передаёт ошибки в QML через Q_PROPERTY.
/////////////////////
//---Q D E B U G---//
/////////////////////
    slotDebug(strDebug);//Передаём ошибку в метод Q_PROPERTY обязательно через slotDebug() для времени.
}
void DCCppQml::slotFileDialogCopy(bool blStatusCopy){//Обрабатываем статус скопированного документа из Проводн
///////////////////////////////////////////////////////////////////////////////////
//---С Л О Т   С Т А Т У С А   С К О П И Р О В А Н Н О Г О   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////////////////////////////
    m_blFileDialogCopy = blStatusCopy;//Приравниваем.
    if(blStatusCopy){//Если успешно скопировались документы и записались данные, то...
        emit strDannieDBChanged();//Излучаем сигнал об изменении списка Данных.
    }
    emit blFileDialogCopyChanged();//Излучаем сигнал в QML об изменении статуса копирования Документа.
}
void DCCppQml::slotDebug(QString strDebug){//Слот обрабатывающий ошибку приходящую по сигналу.
/////////////////////////////////////////////////////////////
//---С Л О Т   О Б Р А Б А Т Ы В А Ю Щ И Й   О Ш И Б К У---//
/////////////////////////////////////////////////////////////
    setStrDebug(strDebug);//Отправляем в Q_PROPERTY ошибку.
}
void DCCppQml::slotTimerDebug(){//Слот прерывания от таймена
/////////////////////////////////////////////////////////
//---Т А Й М Е Р   С О О Б Щ Е Н И Я   О Т Л А Д К И---//
/////////////////////////////////////////////////////////
	m_untDebugSec++;//+1 сек.
	if(m_untDebugSec >= 33)//Если больше 33 секунд, то...
		qdebug("");//Это сигнал о том, что нужно удалять старое сообщение из qml Toolbar.
}

