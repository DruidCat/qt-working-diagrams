#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject* parent) : QObject{parent}, m_strUchastokNazvanie("") {
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    m_pOdin = new Odin("druidcat.dc", "druidcat", "druidcat");
    m_pOdin->dbStart();
}

QString DCCppQml::strUchastokNazvanie() {
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е   У Ч А С Т К А---//
///////////////////////////////////////////////////////////
//    m_strUchastokNazvanie = "[{\"nomer\":\"1\",\"uchastok\":\"Формовка\",\"opisanie\":\"Участок формовки и всё такое.\"},{\"nomer\":\"2\",\"uchastok\":\"Сварка\",\"opisanie\":\"Участок сварки и всё такое.\"},{\"nomer\":\"3\",\"uchastok\":\"Отделка\",\"opisanie\":\"Участок отделки и всё такое.\"}]";
	m_strUchastokNazvanie = m_pOdin->polOdinJSON();
    //m_strUchastokNazvanie = m_pOdin->polOdin(3);
    return m_strUchastokNazvanie;
}

void DCCppQml::slotTest(){
///////////////////////////
//---С Л О Т   Т Е С Т---//
///////////////////////////
    qDebug() << "СлотТест:" << m_strUchastokNazvanie;
}

void DCCppQml::setStrUchastokNazvanie(QString& strUchastokNazvatieNovi) {
///////////////////////////////////////////////////////////
//---С И Г Н А Л   И З М Е Н Е Н И Я   Н А З В А Н И Я---//
///////////////////////////////////////////////////////////
    if (strUchastokNazvatieNovi != m_strUchastokNazvanie){
        m_strUchastokNazvanie = strUchastokNazvatieNovi;
        emit strUchastokNazvanieChanged();//Излучаем сигнал об изменении аргумента.
    }
}
