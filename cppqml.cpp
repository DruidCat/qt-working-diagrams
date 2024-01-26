#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject* parent) : 	QObject{parent},
										m_strSpisok(""),
										m_untSpisokNomer(0),
										m_strSpisokOpisanie(""),
										m_strDebug("")
{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pDataSpisok = new DataSpisok("druidcat.dc", "druidcat", "druidcat");
    m_pDataSpisok->dbStart();

	connect(	m_pDataSpisok,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
}

QString DCCppQml::strSpisok() {//Возвратить JSON строку Списка.
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е   У Ч А С Т К А---//
///////////////////////////////////////////////////////////
//    m_strSpisok = "[{\"nomer\":\"1\",\"uchastok\":\"Формовка\",\"opisanie\":\"Участок формовки и всё такое.\"},{\"nomer\":\"2\",\"uchastok\":\"Сварка\",\"opisanie\":\"Участок сварки и всё такое.\"},{\"nomer\":\"3\",\"uchastok\":\"Отделка\",\"opisanie\":\"Участок отделки и всё такое.\"}]";
    m_strSpisok = m_pDataSpisok->polSpisokJSON();
    return m_strSpisok;
}

void DCCppQml::setStrSpisok(QString& strSpisokNovi) {//Изменение элемента списка.
/////////////////////////////////////////
//---И З М Е Н Е Н И Я   С П И С К А---//
/////////////////////////////////////////
    if (strSpisokNovi != m_strSpisok){
        m_strSpisok = strSpisokNovi;
        emit strSpisokChanged();//Излучаем сигнал об изменении аргумента.
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
	m_strSpisokOpisanie = m_pDataSpisok->polSpisokOpisanie(m_untSpisokNomer);//По Номеру читаем Описание.
	return m_strSpisokOpisanie;
}

void DCCppQml::setStrSpisokOpisanie(QString& strSpisokOpisanieNovi){//Изменить описание списка.
///////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   О П И С А Н И Я   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////
	if(strSpisokOpisanieNovi != m_strSpisokOpisanie){
		m_strSpisokOpisanie = strSpisokOpisanieNovi;
		emit strSpisokOpisanieChanged();//Сигнал о том, что описание поменялось.
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
	if(strDebugNovi != m_strDebug){
		m_strDebug = strDebugNovi;
		qDebug()<<m_strDebug;//Пишем ошибку в отладочную консоль.
		emit strDebugChanged();
	}
}

void DCCppQml::qdebug(QString strDebug){//Передаёт ошибки в QML через Q_PROPERTY.
/////////////////////
//---Q D E B U G---//
/////////////////////
	setStrDebug(strDebug);//Передаём ошибку в метод Q_PROPERTY
}

void DCCppQml::slotTest(){
///////////////////////////
//---С Л О Т   Т Е С Т---//
///////////////////////////
    qDebug() << "СлотТест:" << m_strDebug;
}

void DCCppQml::slotDebug(QString strDebug){//Слот обрабатывающий ошибку приходящую по сигналу.
/////////////////////////////////////////////////////////////
//---С Л О Т   О Б Р А Б А Т Ы В А Ю Щ И Й   О Ш И Б К У---//
/////////////////////////////////////////////////////////////
	setStrDebug(strDebug);//Передаём ошибку на Q_PROPERTY
}
