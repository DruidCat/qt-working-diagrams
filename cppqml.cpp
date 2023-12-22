#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject *parent) : QObject{parent}, m_strUchastokNazvanie("") {
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

}

QString DCCppQml::strUchastokNazvanie() {
    return m_strUchastokNazvanie;
}

void DCCppQml::slotTest(){
///////////////////////////
//---С Л О Т   Т Е С Т---//
///////////////////////////
    qDebug() << "Тест";
}

void DCCppQml::setStrUchastokNazvanie(QString& strUchastokNazvatieNovi) {
    m_strUchastokNazvanie = strUchastokNazvatieNovi;
}
