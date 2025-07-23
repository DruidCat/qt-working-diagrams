#ifndef COPYDANNIE_H
#define COPYDANNIE_H

#include <QObject>
#include <QThread>
#include <QFile>

class CopyDannie : public QThread{
    Q_OBJECT
public:
    explicit	CopyDannie();//Конструктор
    ~			CopyDannie();//Деструктор
    void  		run();//Перегруженый метод, копирующий файл.
    void 		ustPutiFailov(QString strAbsolutPutFaila, QString strMentorPutFaila);
private:
    QString 	m_strAbsolutPutFaila;//Путь и сам копируемый файл.
    QString 	m_strMentorPutFaila;//Имя и путь, куда копируется файл.

signals:
    void  		signalCopyDannie(bool);//Сигнал об окончании копирования. true -успех, false - ошибка.

};

#endif // COPYDANNIE_H
