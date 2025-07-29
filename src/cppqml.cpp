#include "cppqml.h"

#include <QDebug>

DCCppQml::DCCppQml(QObject* proditel) : QObject{proditel},
                                        m_sttReestr("DruidCat", "Mentor"),
                                        m_untHeight(0),
                                        m_untWidth(0),
                                        m_blPdfViewer(true),
                                        m_blAppRedaktor(true),
                                        m_untShrift(1),
                                        m_untNastroikiMaxLength(33),

										m_strTitul(""),
										m_strTitulOpisanie(""),

										m_strSpisok(""),
										m_strSpisokDB(""),
										m_ullSpisokKod(0),
										m_strSpisokOpisanie(""),
                                        m_blSpisokPervi(false),

                                        m_strElement(""),
										m_strElementDB(""),
										m_ullElementKod(0),
										m_strElementOpisanie(""),
										m_blElementPervi(false),

                                        m_strDannie(""),
                                        m_strDannieDB(""),
                                        m_ullDannieKod(0),
                                        m_strDannieStr(""),
										m_strDannieUrl(""),
                                        m_blDanniePervi(false),

                                        m_strFileDialog(""),
                                        m_strFileDialogPut(""),
                                        m_strFileDialogModel(""),
                                        m_blFileDialogCopy(false),
                                        m_blFileDialogPlan(false),

                                        m_blPlanPervi(false),

                                        m_untKatalogCopy(0),
                                        m_blKatalogStatus(true),

                                        m_strDebug("")
{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
    QString strImyaDB = "druidcat.db";//Имя БД таблиц с титулом, списками, элементами, данными.
    QString strImyaDBData = "druiddat.db";// Имя БД с файлами документов.
	QString strLoginDB = "druidcat";//Логин входа в БД.
	QString strParolDB = "druidcat";//Пароль входа в БД.
    quint64 ullSpisokMax = 999;//Максимальное количество Списков.
    quint64 ullElementMax = 999;//Максимальное количество Элементов.
    quint64 ullDannieMax = 999;//Максимальное количество Данных.
    QString strKatalogDB = "workingdata";//Имя дериктория хранения данных
    QStringList slsFileDialogMaska = QStringList() << "*.pdf" << "*.PDF" << "*.Pdf"<<"*.m4b";

    QDir odrMentor = QDir::current();//Объект каталога приложения.
    if(!odrMentor.cd(strKatalogDB)){//Если перейти к это папке не получается, то...
        if(odrMentor.mkdir(strKatalogDB)){//Создаём начальную дерикторию хранения данных
            if(!odrMentor.cd(strKatalogDB))
                qWarning()<<tr("DataDannie::DataDannie: ошибка перехода в созданную папку хранения "
                        "документов!");
        }
        else
            qWarning()<<tr("DataDannie::DataDannie: ошибка создания папки хранения документов.");
    }
    QString strMentorPut = odrMentor.path();//Присваеваем переменной каталог приложения.

    strImyaDB = strMentorPut + QDir::separator() + strImyaDB;
    strImyaDBData  = strMentorPut + QDir::separator() + strImyaDBData;

    m_pDataTitul = new DataTitul(strImyaDB, strLoginDB, strParolDB);//Титул.
    m_pDataSpisok = new DataSpisok(strImyaDB, strLoginDB, strParolDB, ullSpisokMax);//Список.
    m_pDataElement = new DataElement(strImyaDB, strLoginDB, strParolDB, ullElementMax);//Элементы.
    m_pDataDannie = new DataDannie(strImyaDB, strImyaDBData, strLoginDB, strParolDB, strMentorPut,
                                   ullDannieMax);//Данные.
    m_pDataKatalog = new DataKatalog(strMentorPut);//Каталог.
    m_pDataPlan = new DataPlan(strMentorPut, ullDannieMax);//План.
    m_pFileDialog = new DCFileDialog(slsFileDialogMaska);//Проводник.
    //---передаём-указатели-бд---//
    m_pDataKatalog->ustPDBTitul(m_pDataTitul->polPDB());//Передаем указатель на БД из класса в класс.
    m_pDataKatalog->ustPDBSpisok(m_pDataSpisok->polPDB());//Передаем указатель на БД из класса в класс.
    m_pDataKatalog->ustPDBElement(m_pDataElement->polPDB());//Передаем указатель на БД из класса в класс.
    m_pDataKatalog->ustPDBDannie(m_pDataDannie->polPDB());//Передаем указатель на БД из класса в класс.
    //---debug---//
    connect(	m_pDataTitul,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
	connect(	m_pDataSpisok,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
	connect(	m_pDataElement,
				SIGNAL(signalDebug(QString)),
				this,
				SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    connect(	m_pDataDannie,
                SIGNAL(signalDebug(QString)),
                this,
                SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    connect(	m_pDataPlan,
                SIGNAL(signalDebug(QString)),
                this,
                SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    connect(	m_pDataKatalog,
                SIGNAL(signalDebug(QString)),
                this,
                SLOT(slotDebug(QString)));//Связываем сигнал ошибки со слотом принимающим ошибку.
    //---сигналы-и-слоты---//
    connect(	m_pDataDannie,
                SIGNAL(signalFileDialogCopy(bool)),
                this,
                SLOT(slotFileDialogCopy(bool)));//Связываем сигнал статуса скопированного документа в Проводни
    connect(	m_pDataPlan,
                SIGNAL(signalFileDialogCopy(bool)),
                this,
                SLOT(slotFileDialogCopy(bool)));//Связываем сигнал статуса скопированного документа в Проводни
    connect(	m_pDataKatalog,
                SIGNAL(signalKatalogCopy(bool)),
                this,
                SLOT(slotKatalogCopy(bool)));//Связываем сигнал статуса скопированного документа в Каталог
    m_pDataTitul->dbStart();//Записываем первоначальные данные в БД.
    m_pDataSpisok->dbStart();//Записываем первоначальные данные в БД.
    m_pDataElement->dbStart();//Записываем первоначальные данные в БД.
    m_pDataDannie->dbStart();//Записываем первоначальные данные в БД.
    m_pDataPlan->ustFileDialogPut(m_pFileDialog->polFileDialogPut());//Задаём путь домашнего каталога на старт
    m_pdcclass = new DCClass;//Создаём динамический указатель на класс часто используемых методов.
	m_pTimerDebug = new QTimer();//Указатель на QTimer для Debug
	m_pTimerDebug->setInterval(1000);//Интервал прерывания 1000 мс (1с).
	m_untDebugSec = 0;//Обнуляем счётчик секунд.
	connect( 	m_pTimerDebug,
				SIGNAL(timeout()),
				this,
				SLOT(slotTimerDebug()));//При сигнале на прерывание таймера, запускаем слот таймера.
    //---чтение-настроек-из-реестра---//
    polReestr();//Читаем настройки из реестра.
}
DCCppQml::~DCCppQml(){//Деструктор.
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    ustReestr();//При закрытии программы записываем настройки программы
	delete m_pDataTitul;//Удаляем указатель.
    m_pDataTitul = nullptr;//Указатель на класс Списка c БД обнуляем.
	delete m_pDataSpisok;//Удаляем указатель.
    m_pDataSpisok = nullptr;//Указатель на класс Списка c БД обнуляем.
    delete m_pDataElement;//Удаляем указатель.
    m_pDataElement = nullptr;//Указатель на класс Элементов c БД обнуляем.
    delete m_pDataDannie;//Удаляем указатель.
    m_pDataDannie = nullptr;//Указатель на класс Данных c БД обнуляем.
    delete m_pDataKatalog;//Удаляем указатель.
    m_pDataKatalog = nullptr;//Указатель на класс Каталог с БД обнуляем.
    delete m_pDataPlan;//Удаляем указатель.
    m_pDataPlan = nullptr;//Указатель на таблицу Данных в БД обнуляем.
    delete m_pFileDialog;//Удаляем указатель.
    m_pFileDialog = nullptr;//Указатель на Проводник в БД обнуляем.
	delete m_pTimerDebug;//Удаляем указатель на таймер.
	m_pTimerDebug = nullptr;//Обнуляем указатель на таймер отладки.
	delete m_pdcclass;//Удаляем указатель.
	m_pdcclass = nullptr;//Обнуляем указатель
}

void DCCppQml::ustReestr(){//Запись настроек программы
/////////////////////////////////////////////////////////////
//---З А П И С Ь   Н А С Т Р О Е К   П Р И Л О Ж Е Н И Я---//
/////////////////////////////////////////////////////////////
    m_sttReestr.beginGroup("/Nastroiki");//Открываем группу /Настройки
    m_sttReestr.setValue("/shirina_okna", m_untWidth);//Записываем ширину окна
    m_sttReestr.setValue("/visota_okna", m_untHeight);//Записываем высоту окна
    m_sttReestr.setValue("/pdf_viewer", m_blPdfViewer);//Записываем просмотрщик pdf документов.
    m_sttReestr.setValue("/app_redaktor", m_blAppRedaktor);//Записываем флаг Редактора вкл/выкл.
    m_sttReestr.setValue("/shrift", m_untShrift);//Записываем размер Шрифта 0-мал, 1-средний, 2-большой.
    m_sttReestr.endGroup();//Закрываем группу /Настройки
}
void DCCppQml::polReestr(){//Чтение настроек программы
/////////////////////////////////////////////////////////////
//---Ч Т Е Н И Е   Н А С Т Р О Е К   П Р И Л О Ж Е Н И Я---//
/////////////////////////////////////////////////////////////
    m_sttReestr.beginGroup("/Nastroiki");//Открываем группу /Настройки
    m_untWidth = m_sttReestr.value("/shirina_okna", 640).toInt();//Читаем ширину окна, по умолчанию 640
    m_untHeight = m_sttReestr.value("/visota_okna", 480).toInt();//Читаем высоту окна, по умолчанию 480
    m_blPdfViewer = m_sttReestr.value("/pdf_viewer", true).toBool();//Читаем просмотрщик документов, по умол 1
    m_blAppRedaktor = m_sttReestr.value("/app_redaktor", true).toBool();//Читаем флаг редактора, по умол 1
    m_untShrift = m_sttReestr.value("/shrift", 1).toInt();//Читаем шрифт, по умол 1-средний
    m_sttReestr.endGroup();//Закрываем группу /Настройки
}
void DCCppQml::setUntHeight(const uint& untHeight) {//Изменяем высоту окна приложения.
///////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   В Ы С О Т Ы   О К Н А---//
///////////////////////////////////////////////////
    if(untHeight != m_untHeight){//Если не равны значения, то...
        m_untHeight = untHeight;//Приравниваем.
        emit untHeightChanged();//Излучаем сигнал об изменении аргумента.
    }
}
void DCCppQml::setUntWidth(const uint& untWidth) {//Изменяем ширину окна приложения.
///////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   Ш И Р И Н У   О К Н А---//
///////////////////////////////////////////////////
    if(untWidth != m_untWidth){//Если не равны значения, то...
        m_untWidth = untWidth;//Приравниваем.
        emit untWidthChanged();//Излучаем сигнал об изменении аргумента.
    }
}
void DCCppQml::setBlPdfViewer(const bool& blPdfViewer){//Изменяем просмотрщик pdf документов.
///////////////////////////////////////////////////////////////////////
//---И З М Е Н Я Е М   П Р О С М О Т Р Щ И К   Д О К У М Е Н Т О В---//
///////////////////////////////////////////////////////////////////////
    if (blPdfViewer != m_blPdfViewer){//Если не равны значения, то...
        m_blPdfViewer = blPdfViewer;//Приравниваем.
        emit blPdfViewerChanged();//Излучаем сигнал об изменении аргумента.
    }
}
void DCCppQml::setBlAppRedaktor(const bool& blAppRedaktor){//Изменяем флаг редактора вкл/выкл.
///////////////////////////////////////////////////////
//---И З М Е Н Я Е М   Ф Л А Г   Р Е Д А К Т О Р А---//
///////////////////////////////////////////////////////
    if (blAppRedaktor != m_blAppRedaktor){//Если не равны значения, то...
        m_blAppRedaktor = blAppRedaktor;//Приравниваем.
        emit blAppRedaktorChanged();//Излучаем сигнал об изменении аргумента.
    }
}
void DCCppQml::setUntShrift(const uint& untShrift){//Изменяем значение шрифта.
/////////////////////////////////////////////////////////
//---И З М Е Н Я Е М   З Н А Ч Е Н И Е   Ш Р И Ф Т А---//
/////////////////////////////////////////////////////////
    if((untShrift < 0) && (untShrift > 2)){//Если размер шрифта в этих значениях, то...
        qdebug(tr("Размер шрифта имеет неверное значение."));
    }
    else{//Если нет, то...
        if (untShrift != m_untShrift){//Если не равны значения, то...
            m_untShrift = untShrift;//Приравниваем.
            emit untShriftChanged();//Излучаем сигнал об изменении аргумента.
        }
    }
}
QString DCCppQml::strTitul() {//Получить имя Титула.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   И М Я   Т И Т У Л А---//
///////////////////////////////////////////////
	QString strTitul = m_pDataTitul->polTitul();
	m_strTitul = strTitul;
    return m_strTitul;
}
void DCCppQml::setStrTitul(const QString& strTitulNovi) {//Переименование имени Титула.
///////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Н И Е   И М Е Н И   Т И Т У Л А---//
///////////////////////////////////////////////////////////////
	if(m_pdcclass->isEmpty(strTitulNovi)){//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустое имя титула."));
	}
	else{
        QString strTitulRed = redaktorTexta(strTitulNovi);//Редактируем текст по стандартам приложения.
        if(m_strTitul != strTitulRed){//Если имена титулов не совпадают, то...
            if(m_pDataTitul->renTitul(strTitulRed))//Если имя Титула записалось успешно, то...
				emit strTitulChanged();//Излучаем сигнал об изменении аргумента.
		}
	}
}
QString DCCppQml::strTitulOpisanie() {//Получить описание Титула.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Т И Т У Л А---//
/////////////////////////////////////////////////////////
	QString strTitulOpisanie = m_pDataTitul->polTitulOpisanie();
	m_strTitulOpisanie = strTitulOpisanie;
    return m_strTitulOpisanie;
}
void DCCppQml::setStrTitulOpisanie(const QString& strTitulOpisanieNovi) {//Переименование описание Титула.
/////////////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Н И Е   О П И С А Н И Е   Т И Т У Л А---//
/////////////////////////////////////////////////////////////////////
    QString strTitulOpisanieRed = m_pdcclass->sql_encode(strTitulOpisanieNovi);//Удаляем sql инекции.
    if(m_strTitulOpisanie != strTitulOpisanieRed){//Если описание титулов не совпадают, то...
        if(m_pDataTitul->renTitulOpisanie(strTitulOpisanieRed)){//Если описание Титула записалось успешно
            m_strTitulOpisanie = strTitulOpisanieRed;
            qdebug(tr("Новая запись в описании заголовка."));
            emit strTitulOpisanieChanged();//Излучаем сигнал об изменении аргумента.
        }
    }
}
QString DCCppQml::strSpisok() {//Получить элемента Списка.
///////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Э Л Е М Е Н Т   С П И С К А---//
///////////////////////////////////////////////////////
    return m_strSpisok;
}
void DCCppQml::setStrSpisok(const QString& strSpisokNovi) {//Изменение элемента списка.
///////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   Э Л Е М Е Н Т А   С П И С К А---//
///////////////////////////////////////////////////////////
    if(strSpisokNovi != m_strSpisok)//Если элемент списка не равен выбранному до этого, то...
		m_strSpisok = strSpisokNovi;//Приравниваем.
    emit strSpisokChanged();//Излучаем сигнал об изменении аргумента. ТУТ этот сигнал. Не важно изменение.
}

bool DCCppQml::delStrSpisok(QString strSpisokKod){//Удалить Список по коду.
/////////////////////////////////////
//---У Д А Л И Т Ь   С П И С О К---//
/////////////////////////////////////
    quint64 ullSpisokKod = strSpisokKod.toULongLong();//строку в число.
    QStringList slsElementKod = m_pDataElement->polElementKodi(ullSpisokKod);//Получить кода.
    quint64 ullKolichestvo = slsElementKod.size();//Размер списка.
    for(quint64 ullShag = 0; ullShag < ullKolichestvo; ullShag++){//Перебираем таблицы для удаления.
        quint64 ullElementKod = slsElementKod[ullShag].toULongLong();//Преобразуем строку в число из списка.
        if(m_pDataDannie->udalDannieFaili(ullSpisokKod, ullElementKod)){//Если удалили файлы Элем.
            if(m_pDataDannie->udalDannieTablicu(ullSpisokKod, ullElementKod)){//Удаляем таблицу Элемента, успех.
                if(!m_pDataElement->udalElementDB(ullSpisokKod, ullElementKod)){//Если ошибка Удаления в БД
                    qdebug(tr("Ошибка удаления элемента."));
                    return false;//Ошибка удаления.
                }
            }
            else{//Если удаление таблицы не совершено, то...
                qdebug(tr("Ошибка удаления таблицы выбранного элемента."));
                return false;//Ошибка удаления.
            }
        }
        else{//Если удаление Документов элемента не совершено, то...
            qdebug(tr("Ошибка удаления данных выбранного элемента."));
            return false;//Ошибка удаления.
        }
    }
    if(m_pDataDannie->udalDannieFail(ullSpisokKod)){//Если удалили файлы Плана Списка.
        if(m_pDataElement->udalElementTablicu(ullSpisokKod)){//Если таблица удалилась успешно, то...
            if(m_pDataSpisok->udalSpisokDB(ullSpisokKod)){
                emit strSpisokDBChanged();//Излучаем сигнал об изменении аргумента.
                return true;//Успешно всё удалили
            }
            else//Если ошибка при удалении списка, то...
                qdebug(tr("Ошибка удаления списка."));
        }
    }
    return false;//Ошибка удаление Списка.
}
QString DCCppQml::strSpisokDB() {//Возвратить JSON строку Списка.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   С П И С К А---//
/////////////////////////////////////////////////
    m_strSpisokDB = m_pDataSpisok->polSpisokJSON();//Считываем строку JSON, приравниваем её к переменной.
    m_blSpisokPervi = m_pDataSpisok->polSpisokPervi();//Первый в списке или нет? Строчка обязательна тут.
    return m_strSpisokDB;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrSpisokDB(const QString& strSpisokNovi) {//Запись элемента Списка в БД.
/////////////////////////////////////////////////////
//---З А П И С Ь   Э Л Е М Е Н Т А   С П И С К А---//
/////////////////////////////////////////////////////
	if(m_pdcclass->isEmpty(strSpisokNovi))//Если пустая строка, то...
		qdebug("Нельзя сохранять пустые элементы списка.");
	else{
        QString strSpisokRed = redaktorTexta(strSpisokNovi);//Редактируем текст по стандартам приложения.
		QStringList slsSpisok = m_pDataSpisok->polSpisok();//Получить список всех элементов Списка.
        for(int ntShag = 0; ntShag<slsSpisok.size(); ntShag++){//Проверка на одинаковые имена элементов
            if(slsSpisok[ntShag] == strSpisokRed){
                qdebug(tr("Нельзя сохранять одинаковые элементы списка."));
				return;
			}
		}
        if(m_pDataSpisok->ustSpisok(strSpisokRed)){//Если элемент списка записался успешно, то...
        	emit strSpisokDBChanged();//Излучаем сигнал об изменении аргумента.
		}
	}
}
bool DCCppQml::renStrSpisokDB(QString strSpisok, QString strSpisokNovi){//Переимен. элемент Списка
/////////////////////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т   С П И С К А---//
/////////////////////////////////////////////////////////////////
	if(m_pdcclass->isEmpty(strSpisokNovi)){//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустой элемент списка."));
		return false;//Отмена.
	}
	else{
		strSpisokNovi = redaktorTexta(strSpisokNovi);//Редактируем текст по стандартам приложения.
		QStringList slsSpisok = m_pDataSpisok->polSpisok();//Получить список всех элементов Списка.
        for(int ntShag = 0; ntShag<slsSpisok.size(); ntShag++){//Проверка на одинаковые имена элементов
            if(slsSpisok[ntShag] == strSpisokNovi){
                qdebug(tr("Нельзя переименовывать на одноимённый элемент списка."));
				return false;//Отмена.
			}
		}
		if(m_pDataSpisok->renSpisok(strSpisok, strSpisokNovi))//Если элемент списка записался успешно, то...
        	emit strSpisokDBChanged();//Излучаем сигнал об изменении аргумента.
		else
			return false;//Отмена.
	}
	return true;//Успех.
}
quint64 DCCppQml::ullSpisokKod(){//Возвращает Код элемента Списка.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   С П И С К А---//
///////////////////////////////////////////////
	return m_ullSpisokKod;
}
void DCCppQml::setUllSpisokKod(const quint64 ullSpisokKodNovi){//Изменить код списка.
///////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К О Д   С П И С К А---//
///////////////////////////////////////////////////
    if (ullSpisokKodNovi<0)//Если номер меньше 0, то...
		qdebug("DCCppQml::setUllSpisokKod(quint64): quint64 меньше 0.");
	else {//Иначе...
		if (m_ullSpisokKod != ullSpisokKodNovi){//Если не равны параметры, то...
			m_ullSpisokKod = ullSpisokKodNovi;
			emit ullSpisokKodChanged();//Сигнал о том, что код списка изменился.
		}
	}
}
QString DCCppQml::strSpisokOpisanie(){//Возвращает Описание элемента Списка
/////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////////
	//Используем статическую переменную, чтоб минимизировать обращение к БД.
	static uint stullSpisokKod = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	if(stullSpisokKod != m_ullSpisokKod){//Если коды списка разные, то...
		m_strSpisokOpisanie = m_pDataSpisok->polSpisokOpisanie(m_ullSpisokKod);//По Коду читаем Описание.
		stullSpisokKod = m_ullSpisokKod;//Присваеваем статической переменной Код Описания Списка.
	}
	return m_strSpisokOpisanie;//Возвращаем считаное или не считаное из БД Описание.
}
void DCCppQml::setStrSpisokOpisanie(const QString& strSpisokOpisanieNovi){//Изменить описание списка.
///////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   О П И С А Н И Я   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////
    QString strSpisokOpisanieRed = m_pdcclass->sql_encode(strSpisokOpisanieNovi);//Удаляем sql инекции.
    if(strSpisokOpisanieRed != m_strSpisokOpisanie){//Если Описания разные, то...
        if(m_pDataSpisok->ustSpisokOpisanie(m_ullSpisokKod, strSpisokOpisanieRed)){//Записалось Описание,то
            m_strSpisokOpisanie = strSpisokOpisanieRed;//Новое описание присвоили.
            qdebug("Новая запись в описании списка.");
			emit strSpisokOpisanieChanged();//Сигнал о том, что описание поменялось.
		}
	}
}
QString DCCppQml::strElement() {//Получить элемент.
/////////////////////////////////////////
//---П О Л У Ч И Т Ь   Э Л Е М Е Н Т---//
/////////////////////////////////////////
    return m_strElement;
}
void DCCppQml::setStrElement(const QString& strElementNovi) {//Изменение элемента.
/////////////////////////////////////////////
//---И З М Е Н Е Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////
    if(strElementNovi != m_strElement)//Если элемент не равен выбранному до этого, то...
		m_strElement = strElementNovi;//Приравниваем.
    emit strElementChanged();//Излучаем сигнал об изменении аргумента. ТУТ эта строка, не важно изменение.
}
bool DCCppQml::delStrElement(QString strElementKod){//Удалить Элемент по коду.
///////////////////////////////////////
//---У Д А Л И Т Ь   Э Л Е М Е Н Т---//
///////////////////////////////////////
    quint64 ullElementKod =  strElementKod.toULongLong();//Преобразуем строку в число.
    if(m_pDataDannie->udalDannieFaili(m_ullSpisokKod, ullElementKod)){//Если удалили файлы Элем.
        if(m_pDataDannie->udalDannieTablicu(m_ullSpisokKod, ullElementKod)){//Удаляем таблицу Элемента, успех.
            if(m_pDataElement->udalElementDB(m_ullSpisokKod, ullElementKod)){//Удаляем в БД Элемент.
                emit strElementDBChanged();//Удалили данные из БД, необходимо обновить отрисовку Элемента.
                return true;//Успешное удаление.
            }
            else//Если ошибка удаления Элемента в БД, то...
                qdebug(tr("Ошибка удаления элемента."));
        }
        else//Если удаление таблицы не совершено, то...
            qdebug(tr("Ошибка удаления таблицы выбранного элемента."));
    }
    else//Если удаление Документов элемента не совершено, то...
        qdebug(tr("Ошибка удаления данных выбранного элемента."));
    return false;//Ошибка удаления.
}
QString DCCppQml::strElementDB() {//Возвратить JSON строку Элементов.
///////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   Э Л Е М Е Н Т О В---//
///////////////////////////////////////////////////////
    m_strElementDB = m_pDataElement->polElementJSON(m_ullSpisokKod);//Считываем строку JSON.
	m_blElementPervi = m_pDataElement->polElementPervi();//Первый элемент или нет? Строчка обязательна тут.
    return m_strElementDB;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrElementDB(const QString& strElementNovi) {//Запись Элемента в БД.
///////////////////////////////////////
//---З А П И С Ь   Э Л Е М Е Н Т А---//
///////////////////////////////////////
	if(m_pdcclass->isEmpty(strElementNovi))//Если пустая строка, то...
        qdebug(tr("Нельзя сохранять пустой элемент."));
	else{
        QString strElementRed = redaktorTexta(strElementNovi);//Редактируем текст по стандартам приложения.
        QStringList slsElement = m_pDataElement->polElement(m_ullSpisokKod);//Получить список всех Элементов.
        for(int ntShag = 0; ntShag<slsElement.size(); ntShag++){//Проверка на одинаковые имена элементо
            if(slsElement[ntShag] == strElementRed){
                qdebug(tr("Нельзя сохранять одинаковые элементы."));
				return;
			}
		}
        if(m_pDataElement->ustElement(m_ullSpisokKod, strElementRed)){//Если элемент списка записался успешно
        	emit strElementDBChanged();//Излучаем сигнал об изменении списка Элементов.
		}
    }
}
bool DCCppQml::renStrElementDB(QString strElement, QString strElementNovi) {//Переимен. Элемент
///////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Э Л Е М Е Н Т---//
///////////////////////////////////////////////////
    if(m_pdcclass->isEmpty(strElementNovi)) {//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустой элемент списка."));
        return false;//Отмена.
    }
    else {
        strElementNovi = redaktorTexta(strElementNovi);//Редактируем текст по стандартам приложения.
        QStringList slsElement = m_pDataElement->polElement(m_ullSpisokKod);//Получить список всех Элементов.
        for(int ntShag = 0; ntShag<slsElement.size(); ntShag++){//Проверка на одинаковые имена элементов
            if(slsElement[ntShag] == strElementNovi) {
                qdebug(tr("Нельзя переименовывать на одноимённый элемент списка."));
                return false;//Отмена.
            }
        }
        if(m_pDataElement->renElement(m_ullSpisokKod, strElement, strElementNovi))//элемент записался успешно.
            emit strElementDBChanged();//Излучаем сигнал об изменении Элемента в списке.
        else//Если ошибка записи, то...
            return false;//Отмена.
    }
    return true;//Успех.
}
quint64 DCCppQml::ullElementKod(){//Возвращает Код Элемента.
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////
	return m_ullElementKod;
}
void DCCppQml::setUllElementKod(const quint64 ullElementKodNovi){//Изменить код Элемента.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К О Д   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////
	if (ullElementKodNovi<0)//Если номер меньше 0, то...
		qdebug("DCCppQml::setUllElementKod(quint64): quint64 меньше 0.");
	else {//Иначе...
		if (m_ullElementKod != ullElementKodNovi){//Если не равны параметры, то...
			m_ullElementKod = ullElementKodNovi;
            emit ullElementKodChanged();//Сигнал о том, что код Элемента изменился.
		}
	}
}
QString DCCppQml::strElementOpisanie(){//Возвращает Описание Элемента
/////////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   О П И С А Н И Е   Э Л Е М Е Н Т А---//
/////////////////////////////////////////////////////////////
	//Используем статическую переменную, чтоб минимизировать обращение к БД.
	static uint stullSpisokKod = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	static uint stullElementKod = 0;//Статическая переменная, запоминает данные, и не обнуляется.
	if((stullSpisokKod != m_ullSpisokKod)||(stullElementKod != m_ullElementKod)){//Если коды списка разные, то
		m_strElementOpisanie = m_pDataElement->polElementOpisanie(m_ullSpisokKod, m_ullElementKod);//Описание.
		stullSpisokKod = m_ullSpisokKod;//Присваеваем статической переменной Код Описания Списка.
		stullElementKod = m_ullElementKod;//Присваеваем статической переменной Код Описания Элемента.
	}
	return m_strElementOpisanie;//Возвращаем считаное или не считаное из БД Описание.
}
void DCCppQml::setStrElementOpisanie(const QString& strElementOpisanieNovi){//Изменить описание Элемента.
///////////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   О П И С А Н И Я   Э Л Е М Е Н Т А---//
///////////////////////////////////////////////////////////////
    QString strElementOpisanieRed = m_pdcclass->sql_encode(strElementOpisanieNovi);//Удаляем sql инекции.
    if(strElementOpisanieRed != m_strElementOpisanie){//Если Описания разные, то...
        if(m_pDataElement->ustElementOpisanie(m_ullSpisokKod, m_ullElementKod, strElementOpisanieRed)){
            m_strElementOpisanie = strElementOpisanieRed;//Новое описание присвоили.
            qdebug(tr("Новая запись в описании элемента."));
			emit strElementOpisanieChanged();//Сигнал о том, что описание поменялось.
		}
	}
}
QString DCCppQml::strDannie(){//Получить Данные.
///////////////////////////////////////
//---П О Л У Ч И Т Ь   Д А Н Н Ы Е---//
///////////////////////////////////////
    return m_strDannie;
}
void DCCppQml::setStrDannie(const QString& strDannieNovi) {//Изменение Данных.
/////////////////////////////////////////
//---И З М Е Н Е Н И Е   Д А Н Н Ы Х---//
/////////////////////////////////////////
	m_strDannie = strDannieNovi;//Приравниваем.
	emit strDannieChanged();//Излучаем сигнал об изменении аргумента.
}
bool DCCppQml::delStrDannie(QString strDannieKod){//Удалить данные по коду
/////////////////////////////////////
//---У Д А Л И Т Ь   Д А Н Н Ы Е---//
/////////////////////////////////////
    if(m_pDataDannie->udalDannieDB(m_ullSpisokKod, m_ullElementKod, strDannieKod.toULongLong())){//Если удален
        emit strDannieDBChanged();//Излучаем сигнал, чтоб обновился список Данных, после удаления.
        return true;//Успех удаления записи из БД и Документа.
    }
    return false;//Ошибка удаления записи из БД и Документа.

}
QString DCCppQml::strDannieDB() {//Возвратить JSON строку с Данными.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   J S O N   Д А Н Н Ы Е---//
/////////////////////////////////////////////////
    m_strDannieDB = m_pDataDannie->polDannieJSON(m_ullSpisokKod, m_ullElementKod);//Считываем строку JSON.
    m_blDanniePervi = m_pDataDannie->polDanniePervi();//Первые Данные или нет? Строчка обязательна тут.
    return m_strDannieDB;//И только после этого возвращаем её, это важно.
}
void DCCppQml::setStrDannieDB(const QString& strImyaFaila) {//Запись Данных в БД.
///////////////////////////////////
//---З А П И С Ь   Д А Н Н Ы Х---//
///////////////////////////////////
    if(m_pdcclass->isEmpty(strImyaFaila)){//Если пустая строка, то...
        qdebug(tr("Нельзя сохранить пустые данные."));
		slotFileDialogCopy(false);//Ошибка копирования, отключаем анимацию копирования и всё остальное.
	}
    else{
        QString strDannie = m_pdcclass->baseName(strImyaFaila);//Убираем расширение из имени файла.
        strDannie = redaktorTexta(strDannie);//Редактируем текст по стандартам приложения.
        QStringList slsDannie = m_pDataDannie->polDannie(m_ullSpisokKod, m_ullElementKod);//Получить Данные
        for(int ntShag = 0; ntShag<slsDannie.size(); ntShag++){//Проверка на одинаковые имена Данных
            if(slsDannie[ntShag] == strDannie){
                qdebug(tr("Нельзя сохранять одинаковые данные."));
				slotFileDialogCopy(false);//Ошибка копирования, отключаем анимацию копирования и всё остальное
                return;
            }
        }
        //Копируем Документ в Приложение, делаем запись в БД, а сигнал об этих действиях в slotFileDialogCopy
        m_pDataDannie->ustDannie(m_ullSpisokKod, m_ullElementKod, strImyaFaila, strDannie);//Копируем,записыва
    }
}
bool DCCppQml::renStrDannieDB(QString strDannie, QString strDannieNovi) {//Переименовать Данные.
/////////////////////////////////////////////////
//---П Е Р Е И М Е Н О В А Т Ь   Д А Н Н Ы Е---//
/////////////////////////////////////////////////
    if(m_pdcclass->isEmpty(strDannieNovi)) {//Если пустая строка, то...
        qdebug(tr("Нельзя переименовывать на пустой элемент данных."));
        return false;//Отмена.
    }
    else {
        strDannieNovi = redaktorTexta(strDannieNovi);//Редактируем текст по стандартам приложения.
        QStringList slsDannie = m_pDataDannie->polDannie(m_ullSpisokKod, m_ullElementKod);//получ список Данны
        for(int ntShag = 0; ntShag<slsDannie.size(); ntShag++){//Проверка на одинаковые имена Данных.
            if(slsDannie[ntShag] == strDannieNovi) {
                qdebug(tr("Нельзя переименовывать на одноимённый элемент данных."));
                return false;//Отмена.
            }
        }
        if(m_pDataDannie->renDannie(m_ullSpisokKod, m_ullElementKod, strDannie, strDannieNovi))//Запись успешн
            emit strDannieDBChanged();//Излучаем сигнал об изменении Данных в списке.
        else//Если ошибка записи, то...
            return false;//Отмена.
    }
    return true;//Успех.
}
quint64 DCCppQml::ullDannieKod(){//Возвращает Код Данных.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   К О Д   Д А Н Н Ы Х---//
///////////////////////////////////////////////
    return m_ullDannieKod;
}
void DCCppQml::setUllDannieKod(const quint64 ullDannieKodNovi){//Изменить код Данных.
///////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   К О Д   Д А Н Н Ы Х---//
///////////////////////////////////////////////////
    if (ullDannieKodNovi<0)//Если номер меньше 0, то...
        qdebug("DCCppQml::setUllDannieKod(quint64): quint64 меньше 0.");
    else {//Иначе...
        if (m_ullDannieKod != ullDannieKodNovi){//Если не равны параметры, то...
            m_ullDannieKod = ullDannieKodNovi;
            emit ullDannieKodChanged();//Сигнал о том, что код Данных изменился.
        }
    }
}
QString	DCCppQml::strDannieStr(){//Возвратить номер страницы Документа из БД.
/////////////////////////////////////////////////////////////
//---В О З В Р А Т И Т Ь   Н О М Е Р   Д О К У М Е Н Т А---//
/////////////////////////////////////////////////////////////
	m_strDannieStr = m_pDataDannie->polDannieStr(m_ullSpisokKod, m_ullElementKod, m_ullDannieKod);//Номер стр.
	return m_strDannieStr;//Возвращаем номер страницы Документа.
}
void DCCppQml::setStrDannieStr(const QString& strDannieStrNovi){//Изменение номера страницы Документа.
/////////////////////////////////////////////////////////
//---И З М Е Н И Т Ь   Н О М Е Р   Д О К У М Е Н Т А---//
/////////////////////////////////////////////////////////
    if(strDannieStrNovi != m_strDannieStr){//Если Данные не равны выбранному до этого, то...
		if(m_pDataDannie->ustDannieStr(m_ullSpisokKod, m_ullElementKod, m_ullDannieKod, strDannieStrNovi)){
        	m_strDannieStr = strDannieStrNovi;//Приравниваем.
        	emit strDannieStrChanged();//Излучаем сигнал об изменении аргумента.
		}
    }
}
QString DCCppQml::strDannieUrl(){//Возвратить Url файла.
/////////////////////////////////////////////
//---П О Л У Ч И Т Ь   U R L   Ф А Й Л А---//
/////////////////////////////////////////////
    QString strImyaFaila = m_pDataDannie->polImyaFaila(m_ullSpisokKod, m_ullElementKod, m_ullDannieKod);
    if(!strImyaFaila.isEmpty()){//ЭТО ВАЖНАЯ СТРОКА. Если не пустая строка, то...
        if(m_pDataDannie->estImyaFaila(strImyaFaila)){//Если есть такой файл, то...
            QString strDannieUrl = m_pDataDannie->polMentor() + QDir::separator() + strImyaFaila;
            QUrl rlDannieUrl = QUrl::fromUserInput(strDannieUrl);//Переводим в формат Url адреса.
            m_strDannieUrl = rlDannieUrl.toString();//Перефодим адресс Url в строку.
            return m_strDannieUrl;//Возращаем Url адресс в виде строки.
        }
    }
    delStrDannie(QString::number(m_ullDannieKod));//Удаляем строку несущуествующий Данных из БД.
    m_strDannieUrl = "file:///";//Возвращаем не пустой путь "", чтоб вызвать ошибку в Qml.
    return m_strDannieUrl;//Возращаем Url адресс в виде строки.
}
QString DCCppQml::strFileDialog() {//Возвратить JSON строку с папками и файлами.
///////////////////////////////////////////////
//---П О Л У Ч И Т Ь   F I L E D I A L O G---//
///////////////////////////////////////////////
    m_strFileDialog = m_pFileDialog->polSpisokJSON();//Возвратить список папок и файлов в JSON. Или имя файла.
    return m_strFileDialog;//Возвратить список папок и файлов в формате JSON. Или Имя выбранного файла.
}
void DCCppQml::setStrFileDialog(const QString& strFileDialogNovi) {//Изменение JSON запроса с папками и файлам
/////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   F I L E D I A L O G---//
/////////////////////////////////////////////////
    if(m_pFileDialog->ustSpisokJSON(strFileDialogNovi)){//Если задан новый путь успешно, то...
        emit strFileDialogPutChanged();//Излучаем сигнал об изменении аргумента.
        emit strFileDialogChanged();//Излучаем сигнал об изменении аргумента.
    }
}
QString DCCppQml::strFileDialogPut() {//Возвратить путь отображения содержимого папки.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   П У Т Ь   F I L E D I A L O G---//
/////////////////////////////////////////////////////////
    m_strFileDialogPut = m_pFileDialog->polFileDialogPut();//Получить путь каталога.
	if(m_blFileDialogPlan)//Если выбрано копирование Плана, то...
		m_pDataPlan->ustFileDialogPut(m_strFileDialogPut);//Задаём путь к каталогу,где лежит файл для записи
	else//Если выбрано копирование Данных, то...
		m_pDataDannie->ustFileDialogPut(m_strFileDialogPut);//Задаём путь к каталогу,где лежит файл для записи
    return m_strFileDialogPut;//Возвратить путь отображения содержимого папки.
}
void DCCppQml::setStrFileDialogPut(const QString& strFileDialogPutNovi){//Запис. новый путь отображения папки.
///////////////////////////////////////////////////////////
//---И З М Е Н Е Н И Е   П У Т Ь   F I L E D I A L O G---//
///////////////////////////////////////////////////////////
    //strFileDialogPutNovi = start; обновляет дерикторию при открытии Проводника.
    //strFileDialogPutNovi = dom; Задаёт домашнюю дерикторию.
    //strFileDialogPutNovi = sohranit; Задаёт текущую дерикторию.
    if(strFileDialogPutNovi == "start"){//Если это Старт, то...
        emit strFileDialogPutChanged();//Излучаем сигнал об изменении аргумента и обновляем каталог проводника
    }
    else{//Если это не старт, то...
     if(m_pFileDialog->ustFileDialogPut(strFileDialogPutNovi)){//Если путь изменился успешно, то...
            m_strFileDialogPut = strFileDialogPut();//Изменяем путь переменной.
        }
    }
}
void DCCppQml::setStrFileDialogModel(const QString &strFileDialogImya){//Принимаем папку или файл.
/////////////////////////////////////
//---П А П К А   И Л И   Ф А Й Л---//
/////////////////////////////////////
    if((strFileDialogImya.front() == '[')&&(strFileDialogImya.back() == ']'))//Если папка это, то...
        m_strFileDialogModel = "0";//возвращаем 0-папка
    else//Иначе...
        m_strFileDialogModel = "1";//возвращаем 1-файл
}
void DCCppQml::setBlFileDialogPlan(const bool& blFileDialogPlanNovi){//Изменение флага Плана или Данных.
///////////////////////////////////////
//---П Л А Н   И Л И   Д А Н Н Ы Е---//
///////////////////////////////////////
    if(blFileDialogPlanNovi != m_blFileDialogPlan){//Если Данные не равны выбранному до этого, то...
    	m_blFileDialogPlan = blFileDialogPlanNovi;//Приравниваем.
        emit blFileDialogPlanChanged();//Излучаем сигнал об изменении аргумента.
    }
}
bool DCCppQml::blPlanPervi(){//Возвращает флаг Первый План?
///////////////////////////////////////
//---Э Т О   П Е Р В Ы Й   П Л А Н---//
///////////////////////////////////////
	m_blPlanPervi = m_pDataPlan->polPlanPervi(m_ullSpisokKod, m_ullElementKod);
	return m_blPlanPervi;
}
bool DCCppQml::copyPlan(QString strImyaFaila){//Копировать файл Плана.
///////////////////////////////////////////////
//---К О П И Р У Е М   Ф А Й Л   П Л А Н А---//
///////////////////////////////////////////////
    return m_pDataPlan->ustPlan(m_ullSpisokKod, m_ullElementKod, strImyaFaila);//Копируем файл и возв. статус.
}
QString DCCppQml::polPutImyaPlan(){//Получить полный путь с именем Плана.
///////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   П У Т Ь   И   И М Я   Ф А Й Л А---//
///////////////////////////////////////////////////////////
    QString strPutImya = m_pDataPlan->polMentor()
                         +QDir::separator()
                         +m_pDataPlan->polImyaFaila(m_ullSpisokKod, m_ullElementKod);
	QUrl rlPutImyaUrl = QUrl::fromUserInput(strPutImya);//Переводим в формат Url адреса.
    return rlPutImyaUrl.toString();//Перефодим адресс Url в строку и возвращаем.
}
QString DCCppQml::strDebug(){//Возвращает ошибку.
///////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   Т Е К С Т   О Ш И Б К И---//
///////////////////////////////////////////////////
	return m_strDebug;
}
void DCCppQml::setStrDebug(QString& strDebugNovi){//Установить Новую ошибку.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   Т Е К С Т   О Ш И Б К И---//
///////////////////////////////////////////////////////
    m_untDebugSec = 0;//Обнуляем счётчик секунд в любом случае.
    if(strDebugNovi == "")//Стераем сообщение из Toolbar
        m_pTimerDebug->stop();//Останавливаем таймер.
    else{
        QString strLog = QTime::currentTime().toString("HH:mm:ss");//В строку добавляем текущее время.
        strDebugNovi = strLog + ": " + strDebugNovi;//Добавляем двоеточие и само Сообщение.
        strDebugNovi = strDebugNovi;//Добавляем двоеточие и само Сообщение.
        m_pTimerDebug->start();//Запустить таймер.
    }
	m_strDebug = strDebugNovi;
	qWarning()<<m_strDebug;//Пишем ошибку в отладочную консоль.
    emit strDebugChanged();//Излучаем сигнал в qml с ошибкой.
}
QString DCCppQml::redaktorTexta(QString strTekst){//Редактор текста по стандартам Приложения.
///////////////////////////////////////
//---Р Е Д А К Т О Р   Т Е К С Т А---//
///////////////////////////////////////
	strTekst = strTekst.toUpper();//Делаем все буквы в строке заглавные.
	strTekst = m_pdcclass->udalitProbeli(strTekst);//Удаляем 2 и более пробелов между словами.
	strTekst = m_pdcclass->udalitPustotu(strTekst);//Удаляем пробелы по краям, если есть.
    strTekst.truncate(m_untNastroikiMaxLength);//Обрезаем текс на максимальную длину в настройках приложения.
	return strTekst;//Возвращаем отредактированный текст.
}
void DCCppQml::qdebug(QString strDebug){//Передаёт ошибки в QML через Q_PROPERTY.
/////////////////////
//---Q D E B U G---//
/////////////////////
    slotDebug(strDebug);//Передаём ошибку в метод Q_PROPERTY обязательно через slotDebug() для времени.
}
bool DCCppQml::isPdfPoisk(const QString strPoisk){//Пустой запрос на поиск?
///////////////////////////////////////////////////
//---П У С Т О Й   З А П Р О С   П О И С К А ?---//
///////////////////////////////////////////////////
	return m_pdcclass->isEmpty(strPoisk);//Вернёт true или false.
}
int DCCppQml::polKatalogSummu(){//Получить приблизительное сумарное число файлов в менторе.
/////////////////////////////////////////////
//---П О Л У Ч И Т Ь   P D F   С У М М У---//
/////////////////////////////////////////////
    return m_pDataKatalog->polPdfSummu();//Получить приблизительное сумарное число файлов в менторе.
}
void DCCppQml::copyKatalogStart(){//Начать копирование документов в каталог.
/////////////////////////////////////////////////////////
//---Н А Ч А Т Ь   С О З Д А Н И Е   К А Т А Л О Г А---//
/////////////////////////////////////////////////////////
    m_untKatalogCopy = 0;//Обнуляем обязательно счётчик скопированных документов перед стартом.
    m_blKatalogStatus = true;//Сбрасываем статус на true.
    m_pDataKatalog->copyStart();//Начинаем создавать каталог.
}
void DCCppQml::slotFileDialogCopy(bool blStatusCopy){//Обрабатываем статус скопированного документа из Проводн
///////////////////////////////////////////////////////////////////////////////////
//---С Л О Т   С Т А Т У С А   С К О П И Р О В А Н Н О Г О   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////////////////////////////
    m_blFileDialogCopy = blStatusCopy;//Приравниваем.
    if(!m_blFileDialogPlan){//Если копирование Данных, то...
        if(blStatusCopy){//Если успешно скопировались документы и записались данные, то...
            emit strDannieDBChanged();//Излучаем сигнал об изменении списка Данных.
        }
    }
    emit blFileDialogCopyChanged();//Излучаем сигнал в QML об изменении статуса копирования Документа.
}
void DCCppQml::slotKatalogCopy(bool blStatusCopy){//Обрабатываем статус скопированных документов каталога
///////////////////////////////////////////////////////////////////////////////////
//---С Л О Т   С Т А Т У С А   С К О П И Р О В А Н Н Ы Х   Д О К У М Е Н Т О В---//
///////////////////////////////////////////////////////////////////////////////////
    if (blStatusCopy){//Если удачно скопировался документ в каталог, то...
        m_untKatalogCopy += 1;//Прибаляем счётчик скопированных докуметов в каталог +1
        emit untKatalogCopyChanged();//Сигнал о том, что количество скопированных данных изменилось.
        if(!m_blKatalogStatus){//Если статус создания каталога был авария, то...
            m_blKatalogStatus = true;//Успех
            emit blKatalogStatusChanged();//Излучаем сигнал
        }
    }
    else{//Если ошибка НЕ ОБЯЗАТЕЛЬНО КОПИРОВАНИЯ!!!, то...
        if(m_blKatalogStatus){//Если статус создания каталога был УСПЕХ, то...
            m_blKatalogStatus = false;//Авария
            //ОШИБКИ ПРОПИСЫВАЮТСЯ ТАМ, ГДЕ ИЗЛУЧАЕТСЯ СИГНАЛ СО СТАТУСОМ FALSE!!!
            emit blKatalogStatusChanged();//Излучаем сигнал
        }
    }
}
void DCCppQml::slotDebug(QString strDebug){//Слот обрабатывающий ошибку приходящую по сигналу.
/////////////////////////////////////////////////////////////
//---С Л О Т   О Б Р А Б А Т Ы В А Ю Щ И Й   О Ш И Б К У---//
/////////////////////////////////////////////////////////////
    setStrDebug(strDebug);//Отправляем в Q_PROPERTY ошибку.
}
void DCCppQml::slotTimerDebug(){//Слот прерывания от таймена
/////////////////////////////////////////////////////////
//---Т А Й М Е Р   С О О Б Щ Е Н И Я   О Т Л А Д К И---//
/////////////////////////////////////////////////////////
	m_untDebugSec++;//+1 сек.
	if(m_untDebugSec >= 33)//Если больше 33 секунд, то...
		qdebug("");//Это сигнал о том, что нужно удалять старое сообщение из qml Toolbar.
}
