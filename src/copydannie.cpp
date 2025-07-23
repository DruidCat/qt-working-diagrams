#include "copydannie.h"

CopyDannie::CopyDannie(){
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_strAbsolutPutFaila = "";
    m_strMentorPutFaila = "";
}

CopyDannie::~CopyDannie(){
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////

}

void CopyDannie::run(){//Перегружаемый метод, который копируем файл в потоке.
/////////////////////////////////////////////////////
//---К О П И Р У Е М   Ф А Й Л   В   П О Т О К Е---//
/////////////////////////////////////////////////////
    QFile flDannie (m_strAbsolutPutFaila);//Файл, который мы хотим скопировать, расположенный...
    emit signalCopyDannie(flDannie.copy(m_strMentorPutFaila));//файл скопировался или нет
}

void CopyDannie::ustPutiFailov(QString strAbsolutPutFaila, QString strMentorPutFaila){
/////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т И   Ф А Й Л О В---//
/////////////////////////////////////////////////////
    m_strAbsolutPutFaila = strAbsolutPutFaila;
    m_strMentorPutFaila = strMentorPutFaila;
}
