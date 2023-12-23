#ifndef ODIN_H
#define ODIN_H

#include <QObject>

#include "dcdb.h"

class Odin : public QObject {
    Q_OBJECT
public:
    explicit Odin(QString strImyaBD, QObject* parent = nullptr);

signals:

};

#endif // ODIN_H
