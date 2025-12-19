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
    m_strPutKatalog = odrMentor.path();//запоминаем путь к каталогу логов
    QString strImyaFaila = QDate::currentDate().toString("yyyy") + ".txt";
    m_strPutFaila = QDir(odrMentor.path()).filePath(strImyaFaila);//каталог + файл.
    m_flFail.setFileName(m_strPutFaila);
}
DCLogger::~DCLogger(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////
    if(m_flFail.isOpen()) m_flFail.close();//Если файл открыт, закрываем его.
}
void DCLogger::run(){//Запускаем в отдельном потоке запись логов в файл.
///////////////////////////////////////////////
//---З А П И С Ь   L O G   В   П О Т О К Е---//
///////////////////////////////////////////////
    if(m_flFail.open(QIODevice::Append | QIODevice::Text)){//Режим добавления в конец файла|перевод строки \n
        QTextStream txsPotok;//Поток, в котором будет обрабатываться строка лога для записи.
        txsPotok.setDevice(&m_flFail);//добавляем в поток файл через ссылку, с которым он будет работать.
        txsPotok << m_strDebug << "\n";//Добавляем в поток Лог для записи + переход на новую строку.
        m_flFail.flush();//Записываем в файл.
        m_flFail.close();//Если файл открыт, закрываем его.
    }
    else qWarning() << "DCLogger::run(): Файл для записи логов не открылся.";
}
void DCLogger::ustDebug(QString strDebug){//Запомнить строку лога.
///////////////////////////////////////////////////
//---З А П О М Н И Т Ь   С Т Р О К У   Л О Г А---//
///////////////////////////////////////////////////
    m_strDebug = strDebug;//Запоминаем строку, которую мы запишем в файл.
}
QString DCLogger::polDebugDen(){//Логи за текущий день
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Д Е Н Ь   Л О Г О В---//
///////////////////////////////////////////////
    QDate odtSegodnya = QDate::currentDate();//Сегодняшняя дата.
    return polLogiData(odtSegodnya, odtSegodnya);//Получаем строку с логами по промежутку дат.
}
QString DCLogger::polDebugNedelya(){//Логи за последние 7 дней, включая сегодня
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н Е Д Е Л Ю   Л О Г О В---//
///////////////////////////////////////////////////
    QDate odtSegodnya = QDate::currentDate();//Сегодняшняя дата.
    QDate odtNedelya  = odtSegodnya.addDays(-6);//Сегодня + 6 предыдущих = 7 дней
    return polLogiData(odtNedelya, odtSegodnya);//Получаем строку с логами по промежутку дат.
}
QString DCLogger::polDebugMesyac(){//Логи за последние 31 день, включая сегодня
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   М Е С Я Ц   Л О Г О В---//
/////////////////////////////////////////////////
    QDate odtSegodnya = QDate::currentDate();//Сегодняшняя дата.
    QDate odtMesyac  = odtSegodnya.addDays(-30);//Сегодня + 30 предыдущих = 31 день.
    return polLogiData(odtMesyac, odtSegodnya);//Получаем строку с логами по промежутку дат.
}
QString DCLogger::polDebugGod(){//Получить Год логов
/////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Г О Д   Л О Г О В---//
/////////////////////////////////////////////
    QDate odtSegodnya = QDate::currentDate();//Сегодняшняя дата.
    QDate odtMesyac  = odtSegodnya.addDays(-364);//Сегодня + 364 предыдущих = 365 дней, это год.
    return polLogiData(odtMesyac, odtSegodnya);//Получаем строку с логами по промежутку дат.
}
QString DCLogger::polDebugVse(){//Все логи (по всем файлам годов в каталоге)
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   В С Е   Л О Г И---//
///////////////////////////////////////////
    QString strDebug("");//Строка, в которой будет собираться весь лог
    QDir odrPutKatalog(m_strPutKatalog);//папка, в которой файлы с логами.
    QStringList slsFilter;//Список строк, в который запишется в себе все файлы логов.
    slsFilter << "*.txt";//Задаём маску логов.
    QFileInfoList filList = odrPutKatalog.entryInfoList(slsFilter, QDir::Files | QDir::Readable, QDir::Name);
    for (uint untShag = 0; untShag < filList.size(); ++untShag) {//Перебираем все файлы *.txt в папке логов
        const QFileInfo &flnInfo = filList.at(untShag);//Получаем информация по файлу, перебирая все года.
        QFile flFail(flnInfo.absoluteFilePath());//Файл на конкретный год.
        if (!flFail.open(QIODevice::ReadOnly | QIODevice::Text))//Если файл не открылся, то...
            continue;//Тогда просматриваем следующий лог года в цикле.
        QTextStream txsPotok(&flFail);//Задаём Поток, для чтения файла.
        while (!txsPotok.atEnd()) {//Цикл чтения строк, пока он не закончится.
            QString strLog = txsPotok.readLine();//Считиваем строку в файле.
            if (!strLog.isEmpty())//Если строка не пустая, то...
                strDebug += strLog + "\n";//Прибавляем новую строку с переходом на новую строку.
        }
        flFail.close();//Закрываем файл, когда он закончился.
    }
    return strDebug;//Возвращаем результат чтения всех
}
QString DCLogger::polLogiData(const QDate &dtOt, const QDate &dtDo){//Получаем строку с логами по датам.
///////////////////////////////////////////////////
//---П О Л У Ч А Е М   Л О Г И   П О   Д А Т Е---//
///////////////////////////////////////////////////
    if (!dtOt.isValid() || !dtDo.isValid() || dtOt > dtDo)//Если входящие даты-не даты или не те что нужно, то
        return "DCLogger::polDataLogi: ошибка ввода дат.";//Выходим из метода.
    QString strDebug("");//Строка, в которой соберётся весь лог.
    QDir drKatalog(m_strPutKatalog);//Папка, в котрой лежит лог файл.
    int ntGodOt = dtOt.year();//Возможный год в диапазоне ОТ
    int ntGodDo = dtDo.year();//Возможный год в диапазоне ДО
    for (int ntGodShag = ntGodOt; ntGodShag <= ntGodDo; ++ntGodShag) {//Цикл перебора годов.
        QString strImyaFaila = QString::number(ntGodShag) + ".txt";//Имя файла года в цикле.
        QString strPutFaila = drKatalog.filePath(strImyaFaila);//Путь к файлу.
        QFileInfo flnInfo(strPutFaila);//Информация по файлу.
        if (!flnInfo.exists() || !flnInfo.isFile())//Если это не файл или он не существует, то...
            continue;//Следующий файл в цикле.
        strDebug += polLogiFail(strPutFaila, dtOt, dtDo);//Для каждого файла годов вызываем метод
    }
    return strDebug;//Возвращаем строку лога в заданных параметрах.
}
QString DCLogger::polLogiFail(const QString &strPut, const QDate &dtOt, const QDate &dtDo){//Из файла логи.
/////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Л О Г И   И З   Ф А Й Л А---//
/////////////////////////////////////////////////////
    QString strDebug("");//Строка, в которой соберётся весь лог.
    QFile flFail(strPut);//Файл, в котором будим читать логи.
    if (!flFail.open(QIODevice::ReadOnly | QIODevice::Text))//Если файл не открылся, то...
        return "DCLogger::polLogiFail: ошибка открытия логов.";//Выходим из метода.
    QTextStream txsPotok(&flFail);//Задаём Поток, для чтения файла.
    while (!txsPotok.atEnd()) {//Цикл чтения строк, пока он не закончится.
        QString strLog = txsPotok.readLine();//Считиваем строку в файле.
        if (strLog.isEmpty())//Если пустая строка, то...
            continue;//Следующая строчка в цикле.
        //Ожидаем формат: "yyyy.MM.dd-HH:mm:ss ..."
        int ntDataVremya = strLog.indexOf(' ');//Отделяем дату-время от текста.
        if (ntDataVremya <= 0)//Если меньше или равна 0, то...
            continue;//следующий лог смотрим.
        QString strDataVremya = strLog.left(ntDataVremya);//Запоминаем строку "yyyy.MM.dd-HH:mm:ss"
        int ntData = strDataVremya.indexOf('-');//Отделяем дату от времени.
        if (ntData <= 0)//Если меньше или равно 0, то...
            continue;//Следующий лог смотрим.
        QString strData = strDataVremya.left(ntData);//Запоминаем строку "yyyy.MM.dd"
        QDate dtData = QDate::fromString(strData, "yyyy.MM.dd");//Дата.
        if (!dtData.isValid())//Если это не дата, то...
            continue;//Следующий лог смотрим.
        if (dtData < dtOt || dtData > dtDo)//Если это дата не в заданных пределах, то...
            continue;//Следующий лог смотрим.
        strDebug += strLog + "\n";//Если дата входит в диапазон – добавляем строку
    }
    flFail.close();//Закрываем файл для чтения логов.
    return strDebug;//Возвращаем строку отсортированных логов.
}
