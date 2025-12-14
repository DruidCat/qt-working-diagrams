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
    m_logDirPath = odrMentor.path();//запоминаем путь к каталогу логов
    QString strImyaFaila = QDate::currentDate().toString("yyyy") + ".txt";
    QString strFailPut = QDir(odrMentor.path()).filePath(strImyaFaila);//каталог + файл.
    m_currentLogFile = strFailPut;//запоминаем текущий файл логов

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
QString DCLogger::polDebugDen(){//Логи за текущий день
    QDate today = QDate::currentDate();
    return readLogsBetween(today, today);
}
QString DCLogger::polDebugNedelya(){//Логи за последние 7 дней, включая сегодня
    QDate today = QDate::currentDate();
    QDate from  = today.addDays(-6);//сегодня + 6 предыдущих = 7 дней
    return readLogsBetween(from, today);
}
QString DCLogger::polDebugMesyac(){//Логи за последние 31 день, включая сегодня
    QDate today = QDate::currentDate();
    QDate from  = today.addDays(-30);
    return readLogsBetween(from, today);
}
QString DCLogger::polDebugGod(){//Все логи (по всем файлам годов в каталоге)
    QString result;

    QDir logDir(m_logDirPath);
    // Файлы формата "yyyy.txt"
    QStringList filters;
    filters << "*.txt";
    QFileInfoList list = logDir.entryInfoList(filters, QDir::Files | QDir::Readable, QDir::Name);

    for (int i = 0; i < list.size(); ++i) {
        const QFileInfo &fi = list.at(i);

        QFile f(fi.absoluteFilePath());
        if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
            continue;

        QTextStream in(&f);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (!line.isEmpty())
                result += line + "\n";
        }
        f.close();
    }

    return result;
}
// Чтение логов в диапазоне дат [dateFrom; dateTo] включительно
QString DCLogger::readLogsBetween(const QDate &dateFrom, const QDate &dateTo){
    if (!dateFrom.isValid() || !dateTo.isValid() || dateFrom > dateTo)
        return QString();

    QString result;
    QDir logDir(m_logDirPath);

    // Возможные годы в диапазоне
    int yearFrom = dateFrom.year();
    int yearTo   = dateTo.year();

    for (int y = yearFrom; y <= yearTo; ++y) {
        QString fileName = QString::number(y) + ".txt";
        QString filePath = logDir.filePath(fileName);

        QFileInfo fi(filePath);
        if (!fi.exists() || !fi.isFile())
            continue;

        // Для каждого файла годов вызываем вспомогательный метод
        result += readLogsFromFile(filePath, dateFrom, dateTo);
    }

    return result;
}
// Читает строки из одного файла и фильтрует по дате
QString DCLogger::readLogsFromFile(const QString &filePath, const QDate &dateFrom, const QDate &dateTo){
    QString result;

    QFile f(filePath);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return result;

    QTextStream in(&f);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.isEmpty())
            continue;

        // Ожидаем формат: "yyyy.MM.dd-HH:mm:ss ..."
        // Сначала отделим дату-время от текста
        int spacePos = line.indexOf(' ');
        if (spacePos <= 0)
            continue;

        QString datetimeStr = line.left(spacePos);           // "yyyy.MM.dd-HH:mm:ss"
        int dashPos = datetimeStr.indexOf('-');
        if (dashPos <= 0)
            continue;

        QString dateStr = datetimeStr.left(dashPos);         // "yyyy.MM.dd"
        QDate logDate = QDate::fromString(dateStr, "yyyy.MM.dd");
        if (!logDate.isValid())
            continue;

        if (logDate < dateFrom || logDate > dateTo)
            continue;

        // Если дата входит в диапазон – добавляем строку
        result += line + "\n";
    }
    f.close();

    return result;
}
