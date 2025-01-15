#ifndef DCFILEDIALOG_H
#define DCFILEDIALOG_H

#include <QObject>
#include <QDebug>
#include <QDir>

class DCFileDialog : public QObject {
    Q_OBJECT
public:
    explicit	DCFileDialog(QObject* proditel = nullptr);
    ~			DCFileDialog();//Деструктор.
    QString 	polFileDialogPut(void) { return m_strFileDialogPut; }
    bool 		ustFileDialogPut(QString strFileDialogPut);//Установить значение нового пути папки.
    QString 	polSpisokJSON();//Метод создающий список каталогов и файлов конкретной дериктории.

private:
    QDir*		m_pdrPut;//Путь, который в данный момент нужно показать.
    QString 	m_strFileDialogPut;//Путь папки, содержимое которой нужно отобразить.
    bool 		m_blFileDialogPervi;//Первоначальный запуск Проводника.

signals:

};

#endif // DCFILEDIALOG_H
