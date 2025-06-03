#ifndef DATAKATALOG_H
#define DATAKATALOG_H

#include <QObject>

class DataKatalog : public QObject
{
    Q_OBJECT
public:
    explicit DataKatalog(QObject *parent = nullptr);

signals:
};

#endif // DATAKATALOG_H
