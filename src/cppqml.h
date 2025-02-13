#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>
#include <QTime>
#include <QTimer>

#include "dcdb.h"
#include "dcclass.h"
#include "datatitul.h"
#include "dataspisok.h"
#include "dataelement.h"
#include "datadannie.h"
#include "dcfiledialog.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString strTitul
                   READ strTitul
                   WRITE setStrTitul
                   NOTIFY strTitulChanged FINAL)
    Q_PROPERTY(QString strTitulOpisanie
                   READ strTitulOpisanie
                   WRITE setStrTitulOpisanie
                   NOTIFY strTitulOpisanieChanged FINAL)

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
    Q_PROPERTY(bool blSpisokPervi
                   READ blSpisokPervi FINAL)

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
    Q_PROPERTY(QString strElementOpisanie
                   READ strElementOpisanie
                   WRITE setStrElementOpisanie
                   NOTIFY strElementOpisanieChanged FINAL)
    Q_PROPERTY(bool blElementPervi
                   READ blElementPervi FINAL)

    Q_PROPERTY(QString strDannie
                   READ strDannie
                   WRITE setStrDannie
                   NOTIFY strDannieChanged FINAL)
    Q_PROPERTY(QString strDannieDB
                   READ strDannieDB
                   WRITE setStrDannieDB
                   NOTIFY strDannieDBChanged FINAL)
    Q_PROPERTY(quint64 ullDannieKod
                   READ ullDannieKod
                   WRITE setUllDannieKod
                   NOTIFY ullDannieKodChanged FINAL)
    Q_PROPERTY(bool blDanniePervi
                   READ blDanniePervi FINAL)

    Q_PROPERTY(QString strFileDialog
                   READ strFileDialog
                   WRITE setStrFileDialog
                   NOTIFY strFileDialogChanged FINAL)
    Q_PROPERTY(QString strFileDialogPut
                   READ strFileDialogPut
                   WRITE setStrFileDialogPut
                   NOTIFY strFileDialogPutChanged FINAL)
    Q_PROPERTY(bool blFileDialogCopy
                   READ blFileDialogCopy FINAL)

    Q_PROPERTY(QString strDebug
                   READ strDebug
                   WRITE setStrDebug
                   NOTIFY strDebugChanged FINAL)
public:
    explicit	DCCppQml(QObject* proditel = nullptr);//Конструктор.
	~			DCCppQml();//Деструктор.
	//---Методы Q_PROPERTY---//
    QString		strTitul();//Получить имя Титула.
    void		setStrTitul(QString& strTitulNovi);//Изменение имени Титула.
    QString		strTitulOpisanie();//Возвращает Описание имени Титула. 
    void		setStrTitulOpisanie(QString& strOpisanieNovi);//Изменить описание титула.

    QString		strSpisok();//Получить элемента Списка.
    void		setStrSpisok (QString& strSpisokNovi);//Изменение элемента списка.
    QString		strSpisokDB();//Возвратить JSON строку Списка.
    void		setStrSpisokDB(QString& strSpisokNovi);//Изменение JSON запроса Списка.
	Q_INVOKABLE bool renStrSpisokDB(QString strSpisok, QString strSpisokNovi);//Переимен. элемент Списка
    quint64		ullSpisokKod();//Возвращает Код элемента Списка.
    void		setUllSpisokKod(quint64 ullSpisokKodNovi);//Изменить Код списка.
    QString		strSpisokOpisanie();//Возвращает Описание элемента Списка
    void		setStrSpisokOpisanie(QString& strOpisanieNovi);//Изменить описание списка.
    bool 		blSpisokPervi() { return m_blSpisokPervi; }//Возвращает флаг Первый в Списке?

    QString		strElement();//Возвратить элемент.
    void		setStrElement(QString& strElementNovi);//Измененит Элемент.
    QString		strElementDB();//Возвратить JSON строку элемента.
    void		setStrElementDB(QString& strElementNovi);//Изменение JSON запроса Элемента.
    Q_INVOKABLE bool renStrElementDB(QString strElement, QString strElementNovi);//Переимен. Элемент списка
    quint64		ullElementKod();//Возвращает Код Элемента.
    void		setUllElementKod(quint64 ullElementKodNovi);//Изменить Код Элемента.
    QString		strElementOpisanie();//Возвращает Описание Элемента
    void		setStrElementOpisanie(QString& strOpisanieNovi);//Изменить описание Элемента.
    bool 		blElementPervi() { return m_blElementPervi; }//Возвращает флаг Первый Элемент?

    QString		strDannie();//Возвратить Данные.
    void		setStrDannie(QString& strDannieNovi);//Измененит Данные.
    QString		strDannieDB();//Возвратить JSON строку Данных.
    void		setStrDannieDB(QString& strDannieNovi);//Изменение JSON запроса Данных.
    Q_INVOKABLE bool renStrDannieDB(QString strDannie, QString strDannieNovi);//Переименоваовать Данные.
    quint64		ullDannieKod();//Возвращает Код Данных.
    void		setUllDannieKod(quint64 ullDannieKodNovi);//Изменить Код Данных.
    bool 		blDanniePervi() { return m_blDanniePervi; }//Возвращает флаг Первые Данные?

    QString		strFileDialog();//Возвратить JSON строку с папками и файлами.
    void		setStrFileDialog(QString& strFileDialogNovi);//Изменение JSON запроса с папками и файлами.
    QString		strFileDialogPut();//Возвратить путь папки, содержимое которой нужно отобразить.
    void		setStrFileDialogPut(QString& strFileDialogPutNovi);//Изменение отображаемого пути папки.
    bool 		blFileDialogCopy() { return m_blFileDialogCopy; }//Флаг Копирования Документа, инверсируется.

    QString		strDebug();//Возвращает ошибку.
    void		setStrDebug(QString& strErrorNovi);//Установить Новую ошибку.
	//---Методы---//
	QString 	redaktorTexta(QString strTekst);//Редактор текста по стандартам Приложения.
	//---Ошибки---//
	void 		qdebug(QString strDebug);//Передаёт ошибки в QML через Q_PROPERTY.

signals:
    void strTitulChanged();//Сигнал о том, что имя Титула изменилось.
    void strTitulOpisanieChanged();//Сигнал, что описание Титула изменилось.

    void strSpisokChanged();//Сигнал о том, что добавился новый элемент Списка.
    void strSpisokDBChanged();//Сигнал о том, что записан элемент Списка в БД.
    void ullSpisokKodChanged();//Сигнал, что Код выбранного элемента Списка изменился.
    void strSpisokOpisanieChanged();//Сигнал, что описание изменилось.

    void strElementChanged();//Сигнал о том, что записан новый элемент.
    void strElementDBChanged();//Сигнал о том, что записан элемент в БД.
    void ullElementKodChanged();//Сигнал, что Код выбранного Элемента изменился.
    void strElementOpisanieChanged();//Сигнал, что описание изменилось.

    void strDannieChanged();//Сигнал о том, что записан новые Данные.
    void strDannieDBChanged();//Сигнал о том, что записаны Данные в БД.
    void ullDannieKodChanged();//Сигнал, что Код выбранных Данных изменился.

    void strFileDialogChanged();//Сигнал о том, что изменился каталог папок и файлов.
    void strFileDialogPutChanged();//Сигнал о том, что изменился путь отображаемой папки.
    void blFileDialogCopyChanged();//Сигнал о том, что скопировался файл или нет.

    void strDebugChanged();//Сигнал, что новая ошибка появилась.

public	slots:
    void slotFileDialogCopy(bool);//Слот обрабатывающий статус скопированного документа из Проводника.
	void slotDebug(QString strDebug);//Слот обрабатывающий ошибку приходящую по сигналу.
	void slotTimerDebug();//Слот прерывания от таймена Отладчика.

private:
    QString m_strTitul;//аргумент элемента имени Титула в Свойстве Q_PROPERTY
    QString m_strTitulOpisanie;//аргумент описания титула в Свойстве Q_PROPERTY

    QString m_strSpisok;//аргумент элемента списка в Свойстве Q_PROPERTY
    QString m_strSpisokDB;//аргумент JSON запроса Списка в Свойстве Q_PROPERTY
	quint64	m_ullSpisokKod;//Код элемента списка в Свойстве Q_PROPERTY.
    QString m_strSpisokOpisanie;//аргумент описания элемента списка в Свойстве Q_PROPERTY
    bool 	m_blSpisokPervi;//Флаг Первый Список? в Свойстве Q_PROPERTY.

    QString m_strElement;//переменная записывающая Элемент в Свойстве Q_PROPERTY
    QString m_strElementDB;//аргумент JSON запроса Элементов в Свойстве Q_PROPERTY
	quint64	m_ullElementKod;//Код Элемента в Свойстве Q_PROPERTY.
    QString m_strElementOpisanie;//аргумент описания элемента в Свойстве Q_PROPERTY
	bool 	m_blElementPervi;//Флаг Первый Элемент? в Свойстве Q_PROPERTY.

    QString m_strDannie;//переменная записывающая Данные в Свойстве Q_PROPERTY
    QString m_strDannieDB;//аргумент JSON запроса Данных в Свойстве Q_PROPERTY
    quint64	m_ullDannieKod;//Код Данных в Свойстве Q_PROPERTY.
    bool 	m_blDanniePervi;//Флаг Первые Данные? в Свойстве Q_PROPERTY.

    QString m_strFileDialog;//переменная записывающая каталог папок и файлов в Свойстве Q_PROPERTY
    QString m_strFileDialogPut;//переменная записывающая путь отображения папки Свойстве Q_PROPERTY
    bool 	m_blFileDialogCopy;//Флаг Копирования Документа Инверсируется постоянно в Свойстве Q_PROPERTY.

    QString m_strDebug;//Текс ошибки.

    DataTitul* 		m_pDataTitul = nullptr;//Указатель на таблицу Титула в БД.
    DataSpisok* 	m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД.
    DataElement*	m_pDataElement = nullptr;//Указатель на таблицу Элементов в БД.
    DataDannie*		m_pDataDannie = nullptr;//Указатель на таблицу Данных в БД.
    DCFileDialog*	m_pFileDialog = nullptr;//Указатель на Проводник.
    QTimer*			m_pTimerDebug = nullptr;//Указатель на таймер Отладчика.
    uint 			m_untDebugSec;//Счётчик секунд для таймера отладки.
    DCClass* 		m_pdcclass = nullptr;//Указатель на класс часто используемых методов.
};
#endif // CPPQML_H
