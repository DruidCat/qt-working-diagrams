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
#include "datakatalog.h"
#include "dcpdfpoisk.h"
#include "dclogger.h"

class DCCppQml : public QObject {
    Q_OBJECT
    Q_PROPERTY(DCPdfPoisk* pdfPoisk READ pdfPoisk CONSTANT)

    Q_PROPERTY(uint	untHeight
                    READ untHeight
                    WRITE setUntHeight
                    NOTIFY untHeightChanged FINAL)
    Q_PROPERTY(uint	untWidth
                    READ untWidth
                    WRITE setUntWidth
                    NOTIFY untWidthChanged FINAL)
    Q_PROPERTY(uint	untY
                    READ untY
                    WRITE setUntY
                    NOTIFY untYChanged FINAL)
    Q_PROPERTY(uint	untX
                    READ untX
                    WRITE setUntX
                    NOTIFY untXChanged FINAL)
    Q_PROPERTY(bool blPdfMentor
                    READ blPdfMentor
                    WRITE setBlPdfMentor
                    NOTIFY blPdfMentorChanged FINAL)
    Q_PROPERTY(bool blAppRedaktor
                    READ blAppRedaktor
                    WRITE setBlAppRedaktor
                    NOTIFY blAppRedaktorChanged FINAL)
    Q_PROPERTY(uint	untShrift
                    READ untShrift
                    WRITE setUntShrift
                    NOTIFY untShriftChanged FINAL)
    Q_PROPERTY(QString strKatalogPut
                    READ strKatalogPut
                    WRITE setStrKatalogPut
                    NOTIFY strKatalogPutChanged FINAL)
    Q_PROPERTY(uint	untSidebarWidth
                    READ untSidebarWidth
                    WRITE setUntSidebarWidth
                    NOTIFY untSidebarWidthChanged FINAL)
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
    Q_PROPERTY(QString strFileDialogMode
                    READ strFileDialogMode
                    WRITE setStrFileDialogMode
                    NOTIFY strFileDialogModeChanged FINAL)

    Q_PROPERTY(bool blPlanPervi
                    READ blPlanPervi
                    NOTIFY blPlanPerviChanged FINAL)

    Q_PROPERTY(uint untKatalogCopy
                    READ untKatalogCopy
                    NOTIFY untKatalogCopyChanged FINAL)
    Q_PROPERTY(bool blKatalogStatus
                    READ blKatalogStatus
                    NOTIFY blKatalogStatusChanged FINAL)
    Q_PROPERTY(QString strKatalogDocCopy
                    READ strKatalogDocCopy
                    WRITE setStrKatalogDocCopy
                    NOTIFY strKatalogDocCopyChanged FINAL)

    Q_PROPERTY(QString strKatalogUrl
                    READ strKatalogUrl
                    WRITE setStrKatalogUrl
                    NOTIFY strKatalogUrlChanged FINAL)

    Q_PROPERTY(QString strDebug
                    READ strDebug
                    WRITE setStrDebug
                    NOTIFY strDebugChanged FINAL)

    Q_PROPERTY(QString qtVersion
                   READ qtVersion CONSTANT)
public:
    explicit	DCCppQml(QObject* proditel = nullptr);//Конструктор.
	~			DCCppQml();//Деструктор.
	//---Методы Q_PROPERTY---//
    DCPdfPoisk* pdfPoisk() const { return m_pPdfPoisk; }//Возвращаем указатель на класс DCPdfPoisk.
    uint		untHeight() const { return m_untHeight; }//Возвращаем высоту окна.
    void		setUntHeight(const uint& untHeight);//Изменяем высоту окна приложения.
    uint		untWidth() const { return m_untWidth; }//Возвращаем ширину окна.
    void		setUntWidth(const uint& untWidth);//Изменяем ширину окна приложения.
    uint		untY() const { return m_untY; }//Возвращаем Y Координату окна.
    void		setUntY(const uint& untY);//Изменяем Y координату окна приложения.
    uint		untX() const { return m_untX; }//Возвращаем X координату окна.
    void		setUntX(const uint& untX);//Изменяем X координату окна приложения.
    bool		blPdfMentor() const { return m_blPdfMentor; }//Возвращаем флаг просмотщика.
    void		setBlPdfMentor(const bool& blPdfMentor);//Изменяем просмотрщик pdf документов.
    bool		blAppRedaktor() const { return m_blAppRedaktor; }//Возвращаем флаг редактора.
    void		setBlAppRedaktor(const bool& blAppRedaktor);//Изменяем редактор Ментора.
    uint 		untShrift() const { return m_untShrift; }//Возвращаем размер шрифта.
    void		setUntShrift(const uint& untShrift);//Изменяем размер шрифта.
    QString 	strKatalogPut() const { return m_strKatalogPut; }//Возвращаем путь сохранения каталога.
    void		setStrKatalogPut(const QString& strKatalogPut);//Изменяем путь сохранения каталога.
    uint 		untSidebarWidth() const { return m_untSidebarWidth; }//Возвращаем размер боковой панели.
    void		setUntSidebarWidth(const uint& untSidebarWidth);//Изменяем размер боковой панели.
    uint 		untNastroikiMaxLength() const { return m_untNastroikiMaxLength; }//Макс длина строки текста

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
    bool 		blSpisokPervi() const { return m_blSpisokPervi; }//Возвращает флаг Первый в Списке?
    Q_INVOKABLE void ustSpisokSortDB(const QVariantList &jsonSpisok);//Установить отсортированные Списки в БД

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
    bool 		blElementPervi() const { return m_blElementPervi; }//Возвращает флаг Первый Элемент?
    Q_INVOKABLE void ustElementSortDB(const QVariantList &jsonElement);//Установ отсортированные Элементы в БД

    QString		strDannie();//Возвратить Данные.
    void		setStrDannie(const QString& strDannieNovi);//Измененит Данные.
    Q_INVOKABLE bool delStrDannie(QString strDannieKod);//Удалить Данные по коду.
    QString		strDannieDB();//Возвратить JSON строку Данных.
    void		setStrDannieDB(const QString& strDannieNovi);//Изменение JSON запроса Данных.
    Q_INVOKABLE bool copyDannie(const QString strImyaFaila);//Копировать файл Данных.
    Q_INVOKABLE bool renStrDannieDB(QString strDannie, QString strDannieNovi);//Переименовать Данные.
    quint64		ullDannieKod();//Возвращает Код Данных.
    void		setUllDannieKod(const quint64 ullDannieKodNovi);//Изменить Код Данных.
    QString		strDannieStr();//Возвратить номер страницы Документа из БД.
    void		setStrDannieStr(const QString& strDannieStrNovi);//Изменение номера страницы Документа.
	QString 	strDannieUrl();//Возвращаем Url путь с именем файла.
    bool 		blDanniePervi() const { return m_blDanniePervi; }//Возвращает флаг Первые Данные?
    Q_INVOKABLE void ustDannieSortDB(const QVariantList &jsonDannie);//Установить отсортированные Данные в БД

    QString		strFileDialog();//Возвратить JSON строку с папками и файлами.
    void		setStrFileDialog(const QString& strFileDialogNovi);//Изменение JSON запроса с папками и файлами.
    QString		strFileDialogPut();//Возвратить путь папки, содержимое которой нужно отобразить.
    void		setStrFileDialogPut(const QString& strFileDialogPutNovi);//Изменение отображаемого пути папки.
    QString 	strFileDialogModel() const { return m_strFileDialogModel; }//Возвращаем 0-папка или 1-файл.
    void  		setStrFileDialogModel(const QString& strFileDialogImya);//Принимаем папку или файл.
    bool 		blFileDialogCopy() const { return m_blFileDialogCopy; }//Флаг Копир Документа, инверсируется.
    QString 	strFileDialogMode() const { return m_strFileDialogMode; }//Возвращает режим работы проводника.
    void  		setStrFileDialogMode(const QString& strFileDialogModeNovi);//Устанавливаем режим проводника.

    bool 		blPlanPervi();//Возвращает флаг Первый План?
    Q_INVOKABLE bool 	copyPlan(QString strImyaFaila);//Копировать файл Плана.
    Q_INVOKABLE QString polPutImyaPlan();//Получить полный путь с именем Плана.
                                                           //
    Q_INVOKABLE bool 	isPdfPoiskPusto(const QString strPoisk);//Пустой запрос на поиск?
    Q_INVOKABLE bool 	isPdfPoiskTri(const QString strPoisk);//В запросе три и более символов?

    uint		untKatalogCopy() const { return m_untKatalogCopy; }//Возвращ кол-во скопированных документо
    bool		blKatalogStatus() const { return m_blKatalogStatus; }//Возвращает статус создания каталога.
    QString		strKatalogDocCopy() const { return m_strKatalogDocCopy; }//Возвращ путь скопированного докумен
    void		setStrKatalogDocCopy(const QString& strPutNovi);//Установить Новый путь скопированного док.
    QString 	strKatalogUrl() const { return m_strKatalogUrl; }//Возвращаем путь+файл, который нужно открыть
    void		setStrKatalogUrl(const QString& strImyaFaila);//Передаём имя, создаём путь+файл.
    Q_INVOKABLE QString polKatalogUrl(const QString& strImyaFaila);//Возвращаем путь+файл в Каталоге по Имени.
    Q_INVOKABLE int		polKatalogSummu();//Получить приблизительное сумарное число файлов в менторе.
    Q_INVOKABLE void	copyKatalogStart();//Начать копирование документов в каталог.
    Q_INVOKABLE void	copyKatalogStop();//Остановить копирование документов в каталог.

    Q_INVOKABLE QString strDebugDen() const { return m_pdclogger->polDebugDen(); }
    Q_INVOKABLE QString strDebugNedelya() const { return m_pdclogger->polDebugNedelya(); }
    Q_INVOKABLE QString strDebugMesyac() const { return m_pdclogger->polDebugMesyac(); }
    Q_INVOKABLE QString strDebugGod() const { return m_pdclogger->polDebugGod(); }
    QString		strDebug();//Возвращает ошибку.

    QString		qtVersion() const;//Метод возвращающий версию Qt
    void		setStrDebug(QString& strErrorNovi);//Установить Новую ошибку.
	//---Методы---//
	QString 	redaktorTexta(QString strTekst);//Редактор текста по стандартам Приложения.
	//---Ошибки---//
	void 		qdebug(QString strDebug);//Передаёт ошибки в QML через Q_PROPERTY.

signals:
    void untHeightChanged();//Сигнал о том, что высота окна изменилась.
    void untWidthChanged();//Сигнал о том, что ширина окна изменилась.
    void untYChanged();//Сигнал о том, что Y координата окна изменилась.
    void untXChanged();//Сигнал о том, что X координата окна изменилась.
    void blPdfMentorChanged();//Сигнал о том, что просмотрщик pdf документов поменялся.
    void blAppRedaktorChanged();//Сигнал о том, что флаг Редактора поменялся.
    void untShriftChanged();//Сигнал о том, что размер шрифта поменялся.
    void strKatalogPutChanged();//Сигнал о том, что путь размещения каталога изменён.
    void untSidebarWidthChanged();//Сигнал о том, что ширина боковой панели поменялась.
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
    void strFileDialogModeChanged();//Сигнал о том, что изменился режим проводника.

    void blPlanPerviChanged();//Сигнал, что флаг изменился.

    void untKatalogCopyChanged();//Сигнал, что изменился счётчик скопированных документов.
    void blKatalogStatusChanged();//Сигнал, что изменился статус создания каталога.
    void strKatalogDocCopyChanged();//Сигнал, что изменился статус скопированного документа.
    void strKatalogUrlChanged();//Сигнал, что изменился статус открываемого документа.

    void strDebugChanged();//Сигнал, что новая ошибка появилась.

public	slots:
    void slotFileDialogCopy(bool);//Слот обрабатывающий статус скопированного документа из Проводника.
    void slotKatalogCopy(bool);//Слот обрабатывающий статус скопированных pdf документов.
    void slotKatalogDocCopy(QString);//Слот обрабатывающий путь скопированного документова.
    void slotDebug(QString strDebug);//Слот обрабатывающий ошибку приходящую по сигналу.
	void slotTimerDebug();//Слот прерывания от таймена Отладчика.

private:
    //---настройки-в-реестре---//
    QSettings m_sttReestr;//Настройки программы которые будут хранится в системном реестре.
    void ustReestr();//Запись настроек программы
    void polReestr();//Чтение настроек программы

    QString	m_strDomPut;//Путь который будет хранить домашнюю деррикторию приложения.

    uint	m_untHeight;//Высота окна приложения.
    uint	m_untWidth;//Ширина окна приложения.
    uint	m_untY;//Y координата окна приложения.
    uint	m_untX;//X координата окна приложения.
    bool	m_blPdfMentor;//Флаг pdf просмотрщика.
    bool	m_blAppRedaktor;//Флаг Редактора вкл/выкл.
    uint 	m_untShrift;//Размер шрифта 0-маленький, 1-средний, 2-большой.
    QString m_strKatalogPut;//Путь сохранения каталога документов.
    uint 	m_untSidebarWidth;//Ширина боковой панели DCSidebar.qml
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
    QString m_strFileDialogMode;//plan, filedialog, ustkatalog, polkatalog

    bool 	m_blPlanPervi;//Флаг Первый План? в Свойстве Q_PROPERTY.

    uint	m_untKatalogCopy;//Количество скопированных pdf документов.
    bool	m_blKatalogStatus;//Статус создания каталога документов.
    QString m_strKatalogDocCopy;//Путь скопированного документа.
    QString m_strKatalogUrl;//Путь+файл который нужно открыть.

    QString m_strDebug;//Текс ошибки.

    DataTitul* 		m_pDataTitul = nullptr;//Указатель на класс Титула c БД.
    DataSpisok* 	m_pDataSpisok = nullptr;//Указатель на класс Списка c БД.
    DataElement*	m_pDataElement = nullptr;//Указатель на класс Элементов c БД.
    DataDannie*		m_pDataDannie = nullptr;//Указатель на класс Данных c БД.
    DataKatalog*	m_pDataKatalog = nullptr;//Указатель на класс Каталог с БД.
    DataPlan*		m_pDataPlan = nullptr;//Указатель на таблицу Данных в БД.
    DCFileDialog*	m_pFileDialog = nullptr;//Указатель на Проводник.
    DCPdfPoisk*		m_pPdfPoisk = nullptr;//Указатель на pdf поиск.
    QTimer*			m_pTimerDebug = nullptr;//Указатель на таймер Отладчика.
    uint 			m_untDebugSec;//Счётчик секунд для таймера отладки.
    DCClass* 		m_pdcclass = nullptr;//Указатель на класс часто используемых методов.
    DCLogger* m_pdclogger = nullptr;//Указатель на поток записи логов в файл.
};
#endif // CPPQML_H
