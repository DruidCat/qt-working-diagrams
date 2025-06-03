#ifndef DATAELEMENT_H
#define DATAELEMENT_H

#include <QObject>
#include "dcdb.h"
#include "dcclass.h"

class DataElement : public QObject {
    Q_OBJECT
public:
    explicit	DataElement(QString strImyaDB, QString strLoginDB, QString strParolDB, quint64 ullElementMax,
                    QObject* proditel = nullptr);
    ~			DataElement();//Деструктор.
	bool 		dbStart();//Создать первоначальные Элементы.
    QStringList	polElement(quint64 ullSpisokKod);//Получить полный список всех Элементов по Коду Списка.
    bool 		ustElement(quint64 ullSpisokKod, QString strElement);//Записать в БД Элемент.
    bool 		renElement(quint64 ullSpisokKod, QString strElement, QString strElementNovi);//Переименовать.
    bool 		udalElementDB(quint64 ullSpisokKod,quint64 ullElementKod);//Удалить в БД запись Элемента
    bool 		udalElementTablicu(quint64 ullSpisokKod);//Удалить Таблицу Элемента.
    QString		polElementJSON(quint64 ullSpisokKod);//Получить JSON строчку Элементов.
    QString 	polElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod);//Получить Описание Элемента
	bool 		ustElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod, QString strElementOpisanie);
    QStringList polElementKodi(quint64 ullSpisokKod);//Получить все Коды в таблице Элемент_ullSpisokKod
	bool 		polElementPervi() { return m_blElementPervi; }//Вернуть состояние флага Первый Элемент?
    DCDB*		polPDB();//Получить указатель на БД Элемента.

private:
    QString 	m_strImyaDB;//Имя БД
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД

	bool 		m_blElementPervi;//Первый Элемент в Списке элементов.
    quint64 	m_ullElementMax;//Максимальное количество Элементов.
	DCDB*		m_pdbElement = nullptr;//Указатель на класс DCDB.
	DCClass* 	m_pdcclass = nullptr;//Указатель на класс DCClass.

private slots:
    void		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
    void		signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
						  
};
#endif // DATAELEMENT_H
