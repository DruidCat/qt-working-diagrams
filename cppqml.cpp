#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject *parent) : QObject{parent} {
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_strUchastokNazvanie = "";
}

QString DCCppQml::getUchastokNazvanie() {
    return m_strUchastokNazvanie;
}

void DCCppQml::slotTest(){
///////////////////////////
//---С Л О Т   Т Е С Т---//
///////////////////////////
    qDebug() << "Тест";
}

void DCCppQml::slotUchastokNazvanie(QString strUchastokNazvatie) {
    m_strUchastokNazvanie = strUchastokNazvatie;
}
