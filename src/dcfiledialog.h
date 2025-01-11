#ifndef DCFILEDIALOG_H
#define DCFILEDIALOG_H

#include <QObject>

class DCFileDialog : public QObject {
    Q_OBJECT
public:
    explicit	DCFileDialog(QObject* proditel = nullptr);
    ~			DCFileDialog();//Деструктор.

private:
    bool 		m_blFileDialogPervi;//Первоначальный запуск Проводника.

signals:

};

#endif // DCFILEDIALOG_H
