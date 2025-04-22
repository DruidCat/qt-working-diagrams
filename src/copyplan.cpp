#include "copyplan.h"

CopyPlan::CopyPlan(QObject *proditel) : QThread{proditel}{
    ///////////////////////////////
    //---К О Н С Т Р У К Т О Р---//
    ///////////////////////////////
    m_strAbsolutPutFaila = "";
    m_strWorkingDiagramsPutFaila = "";
}

CopyPlan::~CopyPlan(){
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////

}

void CopyPlan::run(){//Перегружаемый метод, который копируем файл в потоке.
/////////////////////////////////////////////////////
//---К О П И Р У Е М   Ф А Й Л   В   П О Т О К Е---//
/////////////////////////////////////////////////////
    QFile flDannie (m_strAbsolutPutFaila);//Файл, который мы хотим скопировать, расположенный...
    emit signalCopyPlan(flDannie.copy(m_strWorkingDiagramsPutFaila));//файл скопировался или нет
}

void CopyPlan::ustPutiFailov(QString strAbsolutPutFaila, QString strWorkingDiagramsPutFaila){
/////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т И   Ф А Й Л О В---//
/////////////////////////////////////////////////////
    m_strAbsolutPutFaila = strAbsolutPutFaila;
    m_strWorkingDiagramsPutFaila = strWorkingDiagramsPutFaila;
}
