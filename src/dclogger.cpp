#include "dclogger.h"

DCLogger::DCLogger(QString strKatalogDebug){//Конструктор.
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    m_strDebug = "";
    QDir odrMentor = QDir::current();//Объект каталога приложения.
    if(!odrMentor.cd(strKatalogDebug)){//Если перейти к это папке не получается, то...
        if(odrMentor.mkdir(strKatalogDebug)){//Создаём начальную дерикторию хранения логов
            if(!odrMentor.cd(strKatalogDebug))
                qWarning()<<tr("DCLogger::DCLogger: ошибка перехода в созданную папку хранения логов!");
        }
        else qWarning()<<tr("DCLogger::DCLogger: ошибка создания папки хранения логов.");
    }
    QString strImyaFaila = QDate::currentDate().toString("yyyy") + ".txt";
    QString strFailPut = QDir(odrMentor.path()).filePath(strImyaFaila);//каталог + файл.

    m_flLogs.setFileName(strFailPut);
    if(m_flLogs.open(QIODevice::Append | QIODevice::Text)){//Режим добавления в конец файла|перевод строки \n
        m_txsPotok.setDevice(&m_flLogs);//добавляем в поток файл через ссылку, с которым он будет работать.
    }
    else qWarning()<<"Не удалось открыть файл для записи логов!";
}
DCLogger::~DCLogger(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////
    if(m_flLogs.isOpen()) m_flLogs.close();//Если файл открыт, закрываем его.
}
void DCLogger::run(){//Запускаем в отдельном потоке запись логов в файл.
///////////////////////////////////////////////
//---З А П И С Ь   L O G   В   П О Т О К Е---//
///////////////////////////////////////////////
    if(m_flLogs.isOpen()){//Если файл открылся, то...
        m_txsPotok << m_strDebug << "\n";//Добавляем в поток Лог для записи + переход на новую строку.
        m_flLogs.flush();//Записываем в файл.
    }
    else qWarning() << "DCLogger::run(): Файл для записи логов не открылся.";
}
void DCLogger::ustDebug(QString strDebug){//Запомнить строку лога.
///////////////////////////////////////////////////
//---З А П О М Н И Т Ь   С Т Р О К У   Л О Г А---//
///////////////////////////////////////////////////
    m_strDebug = strDebug;//Запоминаем строку, которую мы запишем в файл.
}
