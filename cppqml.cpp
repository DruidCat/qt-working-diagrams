#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject* parent) : QObject{parent}, m_strSpisok("") {
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_pDataSpisok = new DataSpisok("druidcat.dc", "druidcat", "druidcat");
    m_pDataSpisok->dbStart();
}

QString DCCppQml::strSpisok() {
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е   У Ч А С Т К А---//
///////////////////////////////////////////////////////////
//    m_strSpisok = "[{\"nomer\":\"1\",\"uchastok\":\"Формовка\",\"opisanie\":\"Участок формовки и всё такое.\"},{\"nomer\":\"2\",\"uchastok\":\"Сварка\",\"opisanie\":\"Участок сварки и всё такое.\"},{\"nomer\":\"3\",\"uchastok\":\"Отделка\",\"opisanie\":\"Участок отделки и всё такое.\"}]";
    m_strSpisok = m_pDataSpisok->polSpisokJSON();
    //m_strSpisok = m_pDataSpisok->polSpisok(3);
    return m_strSpisok;
}

void DCCppQml::slotTest(){
///////////////////////////
//---С Л О Т   Т Е С Т---//
///////////////////////////
    qDebug() << "СлотТест:" << m_strSpisok;
}

void DCCppQml::setStrSpisok(QString& strSpisokNovi) {
///////////////////////////////////////////////////////////
//---С И Г Н А Л   И З М Е Н Е Н И Я   Н А З В А Н И Я---//
///////////////////////////////////////////////////////////
    if (strSpisokNovi != m_strSpisok){
        m_strSpisok = strSpisokNovi;
        emit strSpisokChanged();//Излучаем сигнал об изменении аргумента.
    }
}
