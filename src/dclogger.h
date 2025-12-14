#ifndef DCLOGGER_H
#define DCLOGGER_H

#include <QObject>
#include <QThread>
#include <QFile>
#include <QDir>
#include <QTextStream>
#include <QDebug>

class DCLogger : public QThread{
    Q_OBJECT
public:
    explicit	DCLogger(QString strKatalogDebug);//Конструктор
    ~			DCLogger();//Деструктор
    void  		run();//Запускаем в отдельном потоке запись логов в файл.
    void 		ustDebug(QString strDebug);//Запомнить строку лога.

    QString 	polDebugDen();//Логи за текущие сутки
    QString 	polDebugNedelya();//Логи за последние 7 дней (включая сегодня)
    QString 	polDebugMesyac();//Логи за последние 31 день (включая сегодня)
    QString 	polDebugGod();//Все логи из файла(ов)

private:
    QFile		m_flLogs;//Файл в котором будут записывать логи.
    QTextStream	m_txsPotok;//Поток, в котором будет обрабатываться строка лога для записи.
    QString		m_strDebug;//Переменная хранящая строку для записи.

    QString 	m_logDirPath;//Путь к папке с логами
    QString 	m_currentLogFile;//Полный путь к текущему файлу логов

    QString 	readLogsBetween(const QDate &dateFrom, const QDate &dateTo);
    QString 	readLogsFromFile(const QString &filePath, const QDate &dateFrom, const QDate &dateTo);

signals:
};

#endif // DCLOGGER_H
