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

private:
    QFile		m_flLogs;//Файл в котором будут записывать логи.
    QTextStream	m_txsPotok;//Поток, в котором будет обрабатываться строка лога для записи.
    QString		m_strDebug;//Переменная хранящая строку для записи.

signals:
};

#endif // DCLOGGER_H
