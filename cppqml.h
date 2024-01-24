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

    Q_PROPERTY(uint untSpisokNomer
                   READ untSpisokNomer
                   WRITE setUntSpisokNomer
                   NOTIFY untSpisokNomerChanged FINAL)

    Q_PROPERTY(QString strSpisokOpisanie
                   READ strSpisokOpisanie
                   WRITE setStrSpisokOpisanie
                   NOTIFY strSpisokOpisanieChanged FINAL)

public:
    explicit	DCCppQml(QObject* parent = nullptr);
    QString		strSpisok();//Возвращает в формате JSON строчку со списком
    void		setStrSpisok (QString& strSpisokNovi);//Добавить новый элемент списка или его изменить.
    uint 		untSpisokNomer();//Возвращает номер элемента Списка.
    void		setUntSpisokNomer(uint untSpisokNomerNovi);//Изменить номер списка.
    QString		strSpisokOpisanie();//Возвращает Описание элемента Списка
    void		setStrSpisokOpisanie(QString& strOpisanieNovi);//Изменить описание списка.

														 
signals:
    void strSpisokChanged();
    void untSpisokNomerChanged();
    void strSpisokOpisanieChanged();

public	slots:
    void slotTest();

private:
    QString m_strSpisok;//аргумент списка в Свойстве Q_PROPERTY
	uint	m_untSpisokNomer;//Номер элемента списка в Свойстве Q_PROPERTY.
    QString m_strSpisokOpisanie;//аргумент описания списка в Свойстве Q_PROPERTY
    DataSpisok* m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД.
};

#endif // CPPQML_H
