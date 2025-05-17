#ifndef CPPQML_H
#define CPPQML_H

#include <QObject>
#include <QTime>
#include <QTimer>
#include <QSettings>

#include "dcdb.h"// IWYU pragma: keep //Подавляет предупреждение от clang.
#include "dcclass.h"
#include "datatitul.h"
#include "dataspisok.h"
#include "dataelement.h"
#include "datadannie.h"
#include "dataplan.h"
#include "dcfiledialog.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(uint	untHeight
                    READ untHeight
                    WRITE setUntHeight
                    NOTIFY untHeightChanged FINAL)
    Q_PROPERTY(uint	untWidth
                    READ untWidth
                    WRITE setUntWidth
                    NOTIFY untWidthChanged FINAL)
    Q_PROPERTY(bool blPdfViewer
                    READ blPdfViewer
                    WRITE setBlPdfViewer
                    NOTIFY blPdfViewerChanged FINAL)
    Q_PROPERTY(uint untNastroikiMaxLength
                    READ untNastroikiMaxLength
                    NOTIFY untNastroikiMaxLengthChanged FINAL)

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
                    READ blSpisokPervi
                    NOTIFY blSpisokPerviChanged FINAL)

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
                    READ blElementPervi
                    NOTIFY blElementPerviChanged FINAL)

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
	Q_PROPERTY(QString strDannieStr
                    READ strDannieStr
                    WRITE setStrDannieStr
                    NOTIFY strDannieStrChanged FINAL)
    Q_PROPERTY(QString strDannieUrl
                    READ strDannieUrl
                    NOTIFY strDannieUrlChanged FINAL)
	Q_PROPERTY(bool blDanniePervi
                    READ blDanniePervi
                    NOTIFY blDanniePerviChanged FINAL)

    Q_PROPERTY(QString strFileDialog
                    READ strFileDialog
                    WRITE setStrFileDialog
                    NOTIFY strFileDialogChanged FINAL)
    Q_PROPERTY(QString strFileDialogPut
                    READ strFileDialogPut
                    WRITE setStrFileDialogPut
                    NOTIFY strFileDialogPutChanged FINAL)
    Q_PROPERTY(QString strFileDialogModel
                    READ strFileDialogModel
                    WRITE setStrFileDialogModel
                    NOTIFY strFileDialogModelChanged FINAL)
    Q_PROPERTY(bool blFileDialogCopy
                    READ blFileDialogCopy
                    NOTIFY blFileDialogCopyChanged FINAL)

    Q_PROPERTY(bool blPlanPervi
                    READ blPlanPervi
                    NOTIFY blPlanPerviChanged FINAL)

    Q_PROPERTY(QString strDebug
                    READ strDebug
                    WRITE setStrDebug
                    NOTIFY strDebugChanged FINAL)
public:
    explicit	DCCppQml(QObject* proditel = nullptr);//Конструктор.
	~			DCCppQml();//Деструктор.
	//---Методы Q_PROPERTY---//
    uint		untHeight() { return m_untHeight; }//Возвращаем высоту окна.
    void		setUntHeight(const uint& untHeight);//Изменяем высоту окна приложения.
    uint		untWidth() { return m_untWidth; }//Возвращаем ширину окна.
    void		setUntWidth(const uint& untWidth);//Изменяем ширину окна приложения.
    bool		blPdfViewer() { return m_blPdfViewer; }//Возвращаем флаг просмотщика.
    void		setBlPdfViewer(const bool& blPdfViewer);//Изменяем просмотрщик pdf документов.
    uint 		untNastroikiMaxLength() { return m_untNastroikiMaxLength; }//Максимальная длина строки текста

    QString		strTitul();//Получить имя Титула.
    void		setStrTitul(const QString& strTitulNovi);//Изменение имени Титула.
    QString		strTitulOpisanie();//Возвращает Описание имени Титула.
    void		setStrTitulOpisanie(const QString& strOpisanieNovi);//Изменить описание титула.

    QString		strSpisok();//Получить элемента Списка.
    void		setStrSpisok (const QString& strSpisokNovi);//Изменение элемента списка.
    Q_INVOKABLE bool delStrSpisok(QString strSpisokKod);//Удалить Список по коду.
    QString		strSpisokDB();//Возвратить JSON строку Списка.
    void		setStrSpisokDB(const QString& strSpisokNovi);//Изменение JSON запроса Списка.
	Q_INVOKABLE bool renStrSpisokDB(QString strSpisok, QString strSpisokNovi);//Переимен. элемент Списка
    quint64		ullSpisokKod();//Возвращает Код элемента Списка.
    void		setUllSpisokKod(const quint64 ullSpisokKodNovi);//Изменить Код списка.
    QString		strSpisokOpisanie();//Возвращает Описание элемента Списка
    void		setStrSpisokOpisanie(const QString& strOpisanieNovi);//Изменить описание списка.
    bool 		blSpisokPervi() { return m_blSpisokPervi; }//Возвращает флаг Первый в Списке?

    QString		strElement();//Возвратить элемент.
    void		setStrElement(const QString& strElementNovi);//Измененит Элемент.
    Q_INVOKABLE bool delStrElement(QString strElementKod);//Удалить Элемент по коду.
    QString		strElementDB();//Возвратить JSON строку элемента.
    void		setStrElementDB(const QString& strElementNovi);//Изменение JSON запроса Элемента.
    Q_INVOKABLE bool renStrElementDB(QString strElement, QString strElementNovi);//Переимен. Элемент списка
    quint64		ullElementKod();//Возвращает Код Элемента.
    void		setUllElementKod(const quint64 ullElementKodNovi);//Изменить Код Элемента.
    QString		strElementOpisanie();//Возвращает Описание Элемента
    void		setStrElementOpisanie(const QString& strOpisanieNovi);//Изменить описание Элемента.
    bool 		blElementPervi() { return m_blElementPervi; }//Возвращает флаг Первый Элемент?

    QString		strDannie();//Возвратить Данные.
    void		setStrDannie(const QString& strDannieNovi);//Измененит Данные.
    Q_INVOKABLE bool delStrDannie(QString strDannieKod);//Удалить Данные по коду.
    QString		strDannieDB();//Возвратить JSON строку Данных.
    void		setStrDannieDB(const QString& strDannieNovi);//Изменение JSON запроса Данных.
    Q_INVOKABLE bool renStrDannieDB(QString strDannie, QString strDannieNovi);//Переименоваовать Данные.
    quint64		ullDannieKod();//Возвращает Код Данных.
    void		setUllDannieKod(const quint64 ullDannieKodNovi);//Изменить Код Данных.
    QString		strDannieStr();//Возвратить номер страницы Документа из БД.
    void		setStrDannieStr(const QString& strDannieStrNovi);//Изменение номера страницы Документа.
	QString 	strDannieUrl();//Возвращаем Url путь с именем файла.
    bool 		blDanniePervi() { return m_blDanniePervi; }//Возвращает флаг Первые Данные?

    QString		strFileDialog();//Возвратить JSON строку с папками и файлами.
    void		setStrFileDialog(const QString& strFileDialogNovi);//Изменение JSON запроса с папками и файлами.
    QString		strFileDialogPut();//Возвратить путь папки, содержимое которой нужно отобразить.
    void		setStrFileDialogPut(const QString& strFileDialogPutNovi);//Изменение отображаемого пути папки.
    QString 	strFileDialogModel() { return m_strFileDialogModel; }//Возвращаем 0-папка или 1-файл.
    void  		setStrFileDialogModel(const QString& strFileDialogImya);//Принимаем папку или файл.
    bool 		blFileDialogCopy() { return m_blFileDialogCopy; }//Флаг Копирования Документа, инверсируется.

    bool 		blPlanPervi();//Возвращает флаг Первый План?
														   //
    Q_INVOKABLE bool isPdfPoisk(const QString strPoisk);//Пустой запрос на поиск?

    QString		strDebug();//Возвращает ошибку.
    void		setStrDebug(QString& strErrorNovi);//Установить Новую ошибку.
	//---Методы---//
	QString 	redaktorTexta(QString strTekst);//Редактор текста по стандартам Приложения.
	//---Ошибки---//
	void 		qdebug(QString strDebug);//Передаёт ошибки в QML через Q_PROPERTY.

signals:
    void untHeightChanged();//Сигнал о том, что высота окна изменилась.
    void untWidthChanged();//Сигнал о том, что ширина окна изменилась.
    void blPdfViewerChanged();//Сигнал о том, что просмотрщик pdf документов поменялся.
    void untNastroikiMaxLengthChanged();//Сигнал о том, что максимальная длина текста изменилась.

    void strTitulChanged();//Сигнал о том, что имя Титула изменилось.
    void strTitulOpisanieChanged();//Сигнал, что описание Титула изменилось.

    void strSpisokChanged();//Сигнал о том, что добавился новый элемент Списка.
    void strSpisokDBChanged();//Сигнал о том, что записан элемент Списка в БД.
    void ullSpisokKodChanged();//Сигнал, что Код выбранного элемента Списка изменился.
    void strSpisokOpisanieChanged();//Сигнал, что описание изменилось.
    void blSpisokPerviChanged();//Сигнал, что флаг изменился.

    void strElementChanged();//Сигнал о том, что записан новый элемент.
    void strElementDBChanged();//Сигнал о том, что записан элемент в БД.
    void ullElementKodChanged();//Сигнал, что Код выбранного Элемента изменился.
    void strElementOpisanieChanged();//Сигнал, что описание изменилось.
    void blElementPerviChanged();//Сигнал о том, что изменился флаг.

    void strDannieChanged();//Сигнал о том, что записан новые Данные.
    void strDannieDBChanged();//Сигнал о том, что записаны Данные в БД.
    void ullDannieKodChanged();//Сигнал, что Код выбранных Данных изменился.
    void strDannieStrChanged();//Сигнал о том, что номер страницы Документа записан в БД.
    void strDannieUrlChanged();//Сигнал о том, что ссылка на pdf Документ изменился.
    void blDanniePerviChanged();//Сигнал о том, что флаг изменился.

    void strFileDialogChanged();//Сигнал о том, что изменился каталог папок и файлов.
    void strFileDialogPutChanged();//Сигнал о том, что изменился путь отображаемой папки.
    void strFileDialogModelChanged();//Сигнал о том, что изменилась на 0-папка или 1-файл
    void blFileDialogCopyChanged();//Сигнал о том, что скопировался файл или нет.

    void blPlanPerviChanged();//Сигнал, что флаг изменился.
								//
    void strDebugChanged();//Сигнал, что новая ошибка появилась.

public	slots:
    void slotFileDialogCopy(bool);//Слот обрабатывающий статус скопированного документа из Проводника.
	void slotDebug(QString strDebug);//Слот обрабатывающий ошибку приходящую по сигналу.
	void slotTimerDebug();//Слот прерывания от таймена Отладчика.

private:
    //---настройки-в-реестре---//
    QSettings m_sttReestr;//Настройки программы которые будут хранится в системном реестре.
    void ustReestr();//Запись настроек программы
    void polReestr();//Чтение настроек программы

    uint	m_untHeight;//Высота окна приложения.
    uint	m_untWidth;//Ширина окна приложения.
    bool	m_blPdfViewer;//Флаг pdf просмотрщика.
    uint	m_untNastroikiMaxLength;//Максимальная длина строки текста в Свойстве Q_PROPERTY

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
    QString m_strDannieStr;//Номер страницы Документа в Свойстве Q_PROPERTY
	QString m_strDannieUrl;//Url путь с именем файла в Свойстве Q_PROPERTY.
    bool 	m_blDanniePervi;//Флаг Первые Данные? в Свойстве Q_PROPERTY.

    QString m_strFileDialog;//переменная записывающая каталог папок и файлов в Свойстве Q_PROPERTY
    QString m_strFileDialogPut;//переменная записывающая путь отображения папки Свойстве Q_PROPERTY
    QString m_strFileDialogModel;//Переменная хранящая 0-папка или 1-файл в Свойстве Q_PROPERTY.
    bool 	m_blFileDialogCopy;//Флаг Копирования Документа Инверсируется постоянно в Свойстве Q_PROPERTY.

    bool 	m_blPlanPervi;//Флаг Первый План? в Свойстве Q_PROPERTY.
							//
    QString m_strDebug;//Текс ошибки.

    DataTitul* 		m_pDataTitul = nullptr;//Указатель на таблицу Титула в БД.
    DataSpisok* 	m_pDataSpisok = nullptr;//Указатель на таблицу Списка в БД.
    DataElement*	m_pDataElement = nullptr;//Указатель на таблицу Элементов в БД.
    DataDannie*		m_pDataDannie = nullptr;//Указатель на таблицу Данных в БД.
    DataPlan*		m_pDataPlan = nullptr;//Указатель на таблицу Данных в БД.
    DCFileDialog*	m_pFileDialog = nullptr;//Указатель на Проводник.
    QTimer*			m_pTimerDebug = nullptr;//Указатель на таймер Отладчика.
    uint 			m_untDebugSec;//Счётчик секунд для таймера отладки.
    DCClass* 		m_pdcclass = nullptr;//Указатель на класс часто используемых методов.
};
#endif // CPPQML_H
