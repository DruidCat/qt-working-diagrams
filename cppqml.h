#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>

#include "dcdb.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString strUchastokNazvanie READ getUchastokNazvanie WRITE slotUchastokNazvanie
                   NOTIFY signalUchastokNazvanieChanged FINAL)
public:
    explicit DCCppQml(QObject* parent = nullptr);
    QString	getUchastokNazvanie();

signals:
    void signalUchastokNazvanieChanged();

public	slots:
    void slotTest();
    void slotUchastokNazvanie (QString strUchastokNazvatie);

private:
    QString m_strUchastokNazvanie;

};

#endif // CPPQML_H
