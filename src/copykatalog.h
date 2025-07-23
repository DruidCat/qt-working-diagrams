#ifndef COPYKATALOG_H
#define COPYKATALOG_H

#include <QObject>
#include <QThread>
#include <QFile>
#include <QDebug>

class CopyKatalog: public QThread{
    Q_OBJECT
public:
    explicit	CopyKatalog();//Конструктор
    ~			CopyKatalog();//Деструктор
    void  		run();//Перегруженый метод, копирующий файл.
    void 		ustPutiFailov(QString strAbsolutPutFaila, QString strMentorPutFaila);
private:
    QString 	m_strAbsolutPutFaila;//Путь и сам копируемый файл.
    QString 	m_strMentorPutFaila;//Имя и путь, куда копируется файл.

signals:
    void  		signalCopyDannie(bool);//Сигнал об окончании копирования. true -успех, false - ошибка.

};

#endif // COPYKATALOG_H
