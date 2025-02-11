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
	QStringList	polElement(quint64 ullKod);//Получить полный список всех Элементов по Коду Списка.
	bool 		ustElement(quint64 ullKod, QString strElement);//Записать в БД Элемент.
    bool 		renElement(quint64 ullKod, QString strElement, QString strElementNovi);//Переименовать элемент
    QString		polElementJSON(quint64 ullKod);//Получить JSON строчку Элементов.
    QString 	polElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod);//Получить Описание Элемента
	bool 		ustElementOpisanie(quint64 ullSpisokKod, quint64 ullElementKod, QString strElementOpisanie);
	bool 		polElementPervi() { return m_blElementPervi; }//Вернуть состояние флага Первый Элемент?

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
