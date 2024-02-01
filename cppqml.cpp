#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject* parent) : 	QObject{parent},
										m_strSpisok(""),
										m_strSpisokJSON(""),
										m_untSpisokNomer(0),
										m_strSpisokOpisanie(""),
										m_strDebug("")
{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pDataSpisok = new DataSpisok("druidcat.dc", "druidcat", "druidcat");//Динамический указатель на класс.
    m_pDataSpisok->dbStart();//Записываем первоначальные данные в БД.
 	m_pdcclass = new DCClass;//Создаём динамический указатель на класс часто используемых методов.
	connect(	m_pDataSpisok,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
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
	delete m_pDataSpisok;//Удаляем указатель.
    m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД обнуляем.
	delete m_pTimerDebug;//Удаляем указатель на таймер.
	m_pTimerDebug = nullptr;//Обнуляем указатель на таймер отладки.
	delete m_pdcclass;//Удаляем указатель.
	m_pdcclass = nullptr;//Обнуляем указатель
}
QString DCCppQml::strSpisok() {//Получить элемента Списка.
///////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Э Л Е М Е Н Т   С П И С К А---//
///////////////////////////////////////////////////////
    return m_strSpisok;
}
void DCCppQml::setStrSpisok(QString& strSpisokNovi) {//Изменение элемента списка.
/////////////////////////////////////////
//---И З М Е Н Е Н И Я   С П И С К А---//
/////////////////////////////////////////
	if(m_pdcclass->isEmpty(strSpisokNovi)){//Если пустая строка, то...
		qdebug("Нельзя сохранять пустые элементы списка.");
	}
	else{
		strSpisokNovi = strSpisokNovi.toUpper();//Делаем все буквы в строке заглавные.
		strSpisokNovi = m_pdcclass->udalitProbeli(strSpisokNovi);//Удаляем 2 и более пробелов между словами.
		strSpisokNovi = m_pdcclass->udalitPustotu(strSpisokNovi);//Удаляем пробелы по краям, если есть.
		qDebug()<<strSpisokNovi;
		QStringList slsSpisok = m_pDataSpisok->polSpisok();//Получить список всех элементов Списка.
		for(uint untShag = 0; untShag<slsSpisok.size(); untShag++){//Проверка на одинаковые имена элементов 
			if(slsSpisok[untShag] == strSpisokNovi){
				qdebug("Нельзя сохранять одинаковые элементы списка.");
				return;
			}
		}
		m_strSpisok = strSpisokNovi;
		emit strSpisokChanged();//Излучаем сигнал об изменении аргумента.
	}
}
QString DCCppQml::strSpisokJSON() {//Возвратить JSON строку Списка.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С П И С К А---//
/////////////////////////////////////////////////
//    m_strSpisok = "[{\"nomer\":\"1\",\"uchastok\":\"Формовка\",\"opisanie\":\"Участок формовки и всё такое.\"},{\"nomer\":\"2\",\"uchastok\":\"Сварка\",\"opisanie\":\"Участок сварки и всё такое.\"},{\"nomer\":\"3\",\"uchastok\":\"Отделка\",\"opisanie\":\"Участок отделки и всё такое.\"}]";
    m_strSpisokJSON = m_pDataSpisok->polSpisokJSON();//Считываем строку JSON, приравниваем её к переменной.
    return m_strSpisokJSON;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrSpisokJSON(QString& strSpisokJSONNovi) {//Изменение JSON запроса Списка.
///////////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Я   J S O N   З А П Р О С А   С П И С К А---//
///////////////////////////////////////////////////////////////////
    if (strSpisokJSONNovi != m_strSpisokJSON){
        m_strSpisokJSON = strSpisokJSONNovi;
        emit strSpisokJSONChanged();//Излучаем сигнал об изменении аргумента.
    }
}
uint DCCppQml::untSpisokNomer(){//Возвращает номер элемента Списка.
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н О М Е Р   С П И С К А---//
///////////////////////////////////////////////////
	return m_untSpisokNomer;
}
void DCCppQml::setUntSpisokNomer(uint untSpisokNomerNovi){//Изменить номер списка.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   Н О М Е Р   С П И С К А---//
///////////////////////////////////////////////////////
	if (untSpisokNomerNovi<=0)//Если номер меньше или равен 0, то...
		qdebug("DCCppQml::setUntSpisokNomer(uint untSpisokNomerNovi): untSpisokNomerNovi меньше или равен 0");
	else {//Иначе...
		if (m_untSpisokNomer != untSpisokNomerNovi){//Если не равны параметры, то...
			m_untSpisokNomer = untSpisokNomerNovi;
			emit untSpisokNomerChanged();//Сигнал о том, что номер списка изменился.
		}
	}
}
QString DCCppQml::strSpisokOpisanie(){//Возвращает Описание элемента Списка
/////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////////
	//Используем статическую переменную, чтоб минимизировать обращение к БД.
	static uint stuntSpisokNomer = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	if(stuntSpisokNomer != m_untSpisokNomer){//Если номера списка разные, то...
		m_strSpisokOpisanie = m_pDataSpisok->polSpisokOpisanie(m_untSpisokNomer);//По Номеру читаем Описание.
		stuntSpisokNomer = m_untSpisokNomer;//Присваеваем статической переменной номер Описания Списка.
	}
	return m_strSpisokOpisanie;//Возвращаем считаное или не считаное из БД Описание.
}
void DCCppQml::setStrSpisokOpisanie(QString& strSpisokOpisanieNovi){//Изменить описание списка.
///////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   О П И С А Н И Я   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////
	if(strSpisokOpisanieNovi != m_strSpisokOpisanie){//Если Описания разные, то...
		if(m_pDataSpisok->ustSpisokOpisanie(m_untSpisokNomer, strSpisokOpisanieNovi)){//Записалось Описание,то
			m_strSpisokOpisanie = strSpisokOpisanieNovi;//Новое описание присвоили.
			qdebug("Новоя запись Описания.");
			emit strSpisokOpisanieChanged();//Сигнал о том, что описание поменялось.
		}
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
	m_strDebug = strDebugNovi;
	qDebug()<<m_strDebug;//Пишем ошибку в отладочную консоль.
	emit strDebugChanged();
}
void DCCppQml::qdebug(QString strDebug){//Передаёт ошибки в QML через Q_PROPERTY.
/////////////////////
//---Q D E B U G---//
/////////////////////
	slotDebug(strDebug);//Передаём ошибку в метод Q_PROPERTY обязательно через slotDebug() для времени.
}
void DCCppQml::slotDebug(QString strDebug){//Слот обрабатывающий ошибку приходящую по сигналу.
/////////////////////////////////////////////////////////////
//---С Л О Т   О Б Р А Б А Т Ы В А Ю Щ И Й   О Ш И Б К У---//
/////////////////////////////////////////////////////////////
	m_untDebugSec = 0;//Обнуляем счётчик секунд в любом случае.
	if(strDebug == ""){//Стераем сообщение из Toolbar
		m_pTimerDebug->stop();//Останавливаем таймер.
		setStrDebug(strDebug);//Передаём ошибку на Q_PROPERTY
	}
	else{
		QString strLog = QTime::currentTime().toString("HH:mm:ss");//В строку добавляем текущее время.
		strLog = strLog + ": " + strDebug;//Добавляем двоеточие и само Сообщение.
		m_pTimerDebug->start();//Запустить таймер.
		setStrDebug(strLog);//Передаём ошибку на Q_PROPERTY
	}
}
void DCCppQml::slotTimerDebug(){//Слот прерывания от таймена
/////////////////////////////////////////////////////////
//---Т А Й М Е Р   С О О Б Щ Е Н И Я   О Т Л А Д К И---//
/////////////////////////////////////////////////////////
	m_untDebugSec++;//+1 сек.
	if(m_untDebugSec >= 33)//Если больше 33 секунд, то...
		qdebug("");//Это сигнал о том, что нужно удалять старое сообщение из qml Toolbar.
}

