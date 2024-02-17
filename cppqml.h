#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>
#include <QTime>
#include <QTimer>

#include "dcdb.h"
#include "dcclass.h"
#include "dataspisok.h"
#include "dataelement.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString strSpisok
                   READ strSpisok
                   WRITE setStrSpisok
                   NOTIFY strSpisokChanged FINAL)
    Q_PROPERTY(QString strSpisokDB
                   READ strSpisokDB
                   WRITE setStrSpisokDB
                   NOTIFY strSpisokDBChanged FINAL)
    Q_PROPERTY(quint64 ullSpisokKod
                   READ ullSpisokKod
                   WRITE setUllSpisokKod
                   NOTIFY ullSpisokKodChanged FINAL)
    Q_PROPERTY(QString strSpisokOpisanie
                   READ strSpisokOpisanie
                   WRITE setStrSpisokOpisanie
                   NOTIFY strSpisokOpisanieChanged FINAL)
    Q_PROPERTY(QString strElement
                   READ strElement
                   WRITE setStrElement
                   NOTIFY strElementChanged FINAL)
    Q_PROPERTY(QString strElementDB
                   READ strElementDB
                   WRITE setStrElementDB
                   NOTIFY strElementDBChanged FINAL)
    Q_PROPERTY(quint64 ullElementKod
                   READ ullElementKod
                   WRITE setUllElementKod
                   NOTIFY ullElementKodChanged FINAL)
    Q_PROPERTY(bool blElementPervi
                   READ blElementPervi FINAL)
    Q_PROPERTY(QString strDebug
                   READ strDebug
                   WRITE setStrDebug
                   NOTIFY strDebugChanged FINAL)
public:
    explicit	DCCppQml(QObject* parent = nullptr);//Конструктор.
	~			DCCppQml();//Деструктор.
	//---Методы Q_PROPERTY---//
    QString		strSpisok();//Получить элемента Списка.
    void		setStrSpisok (QString& strSpisokNovi);//Изменение элемента списка.
    QString		strSpisokDB();//Возвратить JSON строку Списка.
    void		setStrSpisokDB(QString& strSpisokNovi);//Изменение JSON запроса Списка.
	Q_INVOKABLE bool renStrSpisokDB(QString strSpisok, QString strSpisokNovi);//Переимен. элемент Списка
    quint64		ullSpisokKod();//Возвращает Код элемента Списка.
    void		setUllSpisokKod(quint64 ullSpisokKodNovi);//Изменить Код списка.
    QString		strSpisokOpisanie();//Возвращает Описание элемента Списка
    void		setStrSpisokOpisanie(QString& strOpisanieNovi);//Изменить описание списка.
    QString		strElement();//Возвратить элемент.
    void		setStrElement(QString& strElementNovi);//Измененит Элемент.
    QString		strElementDB();//Возвратить JSON строку элемента.
    void		setStrElementDB(QString& strElementNovi);//Изменение JSON запроса Элемента.
    quint64		ullElementKod();//Возвращает Код Элемента.
    void		setUllElementKod(quint64 ullElementKodNovi);//Изменить Код Элемента.
    bool 		blElementPervi() { return m_blElementPervi; }//Возвращает флаг Первый Элемент?
    QString		strDebug();//Возвращает ошибку.
    void		setStrDebug(QString& strErrorNovi);//Установить Новую ошибку.
	//---Методы---//
	QString 	redaktorTexta(QString strTekst);//Редактор текста по стандартам Приложения.
	//---Ошибки---//
	void 		qdebug(QString strDebug);//Передаёт ошибки в QML через Q_PROPERTY.

signals:
    void strSpisokChanged();//Сигнал о том, что добавился новый элемент Списка.
    void strSpisokDBChanged();//Сигнал о том, что записан элемент Списка в БД.
    void ullSpisokKodChanged();//Сигнал, что Код выбранного элемента Списка изменился.
    void strSpisokOpisanieChanged();//Сигнал, что описание изменилось.
    void strElementChanged();//Сигнал о том, что записан новый элемент.
    void strElementDBChanged();//Сигнал о том, что записан элемент в БД.
    void ullElementKodChanged();//Сигнал, что Код выбранного Элемента изменился.
	void strDebugChanged();//Сигнал, что новая ошибка появилась.

public	slots:
	void slotDebug(QString strDebug);//Слот обрабатывающий ошибку приходящую по сигналу.
	void slotTimerDebug();//Слот прерывания от таймена Отладчика.

private:
    QString m_strSpisok;//аргумент элемента списка в Свойстве Q_PROPERTY
    QString m_strSpisokDB;//аргумент JSON запроса Списка в Свойстве Q_PROPERTY
	quint64	m_ullSpisokKod;//Код элемента списка в Свойстве Q_PROPERTY.
    QString m_strSpisokOpisanie;//аргумент описания элемента списка в Свойстве Q_PROPERTY
    QString m_strElement;//переменная записывающая Элемент в Свойстве Q_PROPERTY
    QString m_strElementDB;//аргумент JSON запроса Элементов в Свойстве Q_PROPERTY
	quint64	m_ullElementKod;//Код Элемента в Свойстве Q_PROPERTY.
	bool 	m_blElementPervi;//Флаг Первый Элемент? в Свойстве Q_PROPERTY.
	QString m_strDebug;//Текс ошибки.

    DataSpisok* m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД.
    DataElement* m_pDataElement = nullptr;//Указатель на таблицу Элементов в БД.
	QTimer*		m_pTimerDebug = nullptr;//Указатель на таймер Отладчика.
	uint 		m_untDebugSec;//Счётчик секунд для таймера отладки.
 	DCClass* 	m_pdcclass = nullptr;//Указатель на класс часто используемых методов.
};
#endif // CPPQML_H
