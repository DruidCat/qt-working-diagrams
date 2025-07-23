#ifndef COPYPLAN_H
#define COPYPLAN_H

#include <QObject>
#include <QThread>
#include <QFile>

class CopyPlan : public QThread {
    Q_OBJECT
public:
    explicit CopyPlan(QObject *parent = nullptr);
    ~			CopyPlan();//Деструктор
    void  		run();//Перегруженый метод, копирующий файл.
    void 		ustPutiFailov(QString strAbsolutPutFaila, QString strMentorPutFaila);

private:
    QString 	m_strAbsolutPutFaila;//Путь и сам копируемый файл.
    QString 	m_strMentorPutFaila;//Имя и путь, куда копируется файл.

signals:
    void  		signalCopyPlan(bool);//Сигнал об окончании копирования. true -успех, false - ошибка.
};

#endif // COPYPLAN_H
