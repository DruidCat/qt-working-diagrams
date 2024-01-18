#ifndef DATASPISOK_H
#define DATASPISOK_H

#include <QObject>

#include "dcdb.h"

class DataSpisok : public QObject {
    Q_OBJECT
public:
    explicit	DataSpisok(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent = nullptr);
    ~			DataSpisok();//Деструктор.
    bool		dbStart();//Иннициализируем БД, и записываем в нёё данные, если она пустая.
    QString		polSpisok(int ntNomer);//Получить данные по номеру.
    QString		polSpisokJSON();//Получить JSON строчку Списка

private:
    DCDB* m_pdbSpisok = nullptr;//Указатель на базу данных таблицы списков.
    QString m_strImyaBD;//Имя БД
    QString m_strLoginBD;//Логин БД
    QString m_strParolBD;//Пароль БД

signals:

};

#endif // DATASPISOK_H
