#ifndef DCFILEDIALOG_H
#define DCFILEDIALOG_H

#include <QObject>
#include <QDebug>
#include <QDir>
#include "dcclass.h"

class DCFileDialog : public QObject {
    Q_OBJECT
public:
    explicit	DCFileDialog(QObject* proditel = nullptr);
    ~			DCFileDialog();//Деструктор.
    QString 	polFileDialogPut(void);
    bool 		ustSpisokJSON(QString strFileDialogPut);//Установить значение нового пути папки.
    QString 	polSpisokJSON();//Метод создающий список каталогов и файлов конкретной дериктории.

private:
    DCClass*	m_pdcclass;//Класс работающий с текстом.
    QDir*		m_pdrPut;//Путь, который в данный момент нужно показать.
    QString 	m_strFileDialogPut;//Путь папки, содержимое которой нужно отобразить.
    bool 		m_blFileDialogPervi;//Первоначальный запуск Проводника.

signals:

};

#endif // DCFILEDIALOG_H
