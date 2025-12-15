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
    QString 	polDebugNedelya();//Логи за последние 7 дней
    QString 	polDebugMesyac();//Логи за последние 31 день
    QString 	polDebugGod();//Лог за действующий год.
    QString 	polDebugVse();//Все логи из файла(ов)

private:
    QFile		m_flFail;//Файл в котором будут записывать логи.
    QString		m_strDebug;//Переменная хранящая строку для записи.
    QString 	m_strPutKatalog;//Путь к папке с логами
    QString		m_strPutFaila;//Путь к файлу лога нынешнего года.

    QString 	polLogiData(const QDate &dtOt, const QDate &dtDo);//Получаем строку с логами по датам.
    QString 	polLogiFail(const QString &strPut, const QDate &dtOt, const QDate &dtDo);//Из файла логи.

signals:
};

#endif // DCLOGGER_H
