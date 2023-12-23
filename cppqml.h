#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>

#include "dcdb.h"
#include "odin.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString strUchastokNazvanie
                   READ strUchastokNazvanie
                   WRITE setStrUchastokNazvanie
                   NOTIFY strUchastokNazvanieChanged FINAL)
public:
    explicit	DCCppQml(QObject* parent = nullptr);
    QString		strUchastokNazvanie();
    void		setStrUchastokNazvanie (QString& strUchastokNazvanieNovi);

signals:
    void strUchastokNazvanieChanged();

public	slots:
    void slotTest();

private:
    QString m_strUchastokNazvanie;//аргумент участка в Свойстве Q_PROPERTY
    Odin* m_pOdin = nullptr;//Указатель на таблицу Один в БД.

};

#endif // CPPQML_H
