#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>
#include <QTime>

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

    Q_PROPERTY(QString strDebug
                   READ strDebug
                   WRITE setStrDebug
                   NOTIFY strDebugChanged FINAL)

public:
    explicit	DCCppQml(QObject* parent = nullptr);//Конструктор.
	~			DCCppQml();//Деструктор.
	//---Методы Q_PROPERTY---//
    QString		strSpisok();//Возвращает в формате JSON строчку со списком
    void		setStrSpisok (QString& strSpisokNovi);//Добавить новый элемент списка или его изменить.
    uint 		untSpisokNomer();//Возвращает номер элемента Списка.
    void		setUntSpisokNomer(uint untSpisokNomerNovi);//Изменить номер списка.
    QString		strSpisokOpisanie();//Возвращает Описание элемента Списка
    void		setStrSpisokOpisanie(QString& strOpisanieNovi);//Изменить описание списка.
    QString		strDebug();//Возвращает ошибку.
    void		setStrDebug(QString& strErrorNovi);//Установить Новую ошибку.
	//---Ошибки---//
	void 		qdebug(QString strDebug);//Передаёт ошибки в QML через Q_PROPERTY.

signals:
    void strSpisokChanged();//Сигнал о том, что добавился новый элемент Списка.
    void untSpisokNomerChanged();//Сигнал, что номер выбранного элемента Списка изменился.
    void strSpisokOpisanieChanged();//Сигнал, что описание изменилось.
	void strDebugChanged();//Сигнал, что новая ошибка появилась.

public	slots:
	void slotDebug(QString strDebug);//Слот обрабатывающий ошибку приходящую по сигналу.

private:
    QString m_strSpisok;//аргумент списка в Свойстве Q_PROPERTY
	uint	m_untSpisokNomer;//Номер элемента списка в Свойстве Q_PROPERTY.
    QString m_strSpisokOpisanie;//аргумент описания списка в Свойстве Q_PROPERTY
	QString m_strDebug;//Текс ошибки.

    DataSpisok* m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД.
};

#endif // CPPQML_H
