#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>

#include "dcdb.h"
#include "dataspisok.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString strSpisok
                   READ strSpisok
                   WRITE setStrSpisok
                   NOTIFY strSpisokChanged FINAL)
public:
    explicit	DCCppQml(QObject* parent = nullptr);
    QString		strSpisok();
    void		setStrSpisok (QString& strSpisokNovi);

signals:
    void strSpisokChanged();

public	slots:
    void slotTest();

private:
    QString m_strSpisok;//аргумент участка в Свойстве Q_PROPERTY
    DataSpisok* m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД.
};

#endif // CPPQML_H
