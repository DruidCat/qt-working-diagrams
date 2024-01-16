#ifndef ODIN_H
#define ODIN_H

#include <QObject>

#include "dcdb.h"

class Odin : public QObject {
    Q_OBJECT
public:
    explicit	Odin(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent = nullptr);
    ~			Odin();//Деструктор.
    bool		dbStart();//Иннициализируем БД, и записываем в нёё данные, если она пустая.
    QString		polOdin(int ntNomer);//Получить данные по номеру.
	QString		polOdinJSON();//Получить JSON строчку первой вкладки (участки).

private:
    DCDB* m_pdbOdin = nullptr;//Указатель на базу данных первой таблицы.
    QString m_strImyaBD;//Имя БД
    QString m_strLoginBD;//Логин БД
    QString m_strParolBD;//Пароль БД

signals:

};

#endif // ODIN_H
