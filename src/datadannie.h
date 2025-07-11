#ifndef DATADANNIE_H
#define DATADANNIE_H

#include <QObject>

#include "copydannie.h"
#include "dcdb.h"
#include "dcclass.h"

class DataDannie : public QObject {
     Q_OBJECT
public:
    explicit	DataDannie(QString strImyaDB, QString strImyaDBData, QString strLoginDB, QString strParolDB,
                           QString strWorkingDiagramsPut, quint64 ullDannieMax, QObject* proditel = nullptr);
    ~			DataDannie();//Деструктор
    bool 		dbStart();//Создать первоначальные Данные.
	void 		ustWorkingDiagrams(QString strWorkingDiagramsPut);//Задаём каталог хранения Документов.
	QString 	polWorkingDiagrams(void){ return m_strWorkingDiagramsPut; }//Получить путь к каталогу файлов
    QStringList	polDannie(quint64 ullSpisokKod, quint64 ullElementKod);//Получить список всех Данных.
    bool 		ustDannie(quint64 ullSpisokKod, quint64 ullElementKod, QString strFail, QString strDannie);
    bool 		renDannie(quint64 ullSpisokKod,quint64 ullElementKod,QString strDannie,QString strDannieNovi);
    bool  		udalDannieDB(quint64 ullSpisokKod,quint64 ullElementKod,quint64 ullDannieKod);//Удалить запись
    QString		polDannieJSON(quint64 ullSpisokKod, quint64 ullElementKod);//Получить JSON строчку Данных.
	bool 		ustDannieStr(quint64 ullSpisokKod,quint64 ullElementKod,quint64 ullDannieKod, QString strStr);
	QString 	polDannieStr(quint64 ullSpisokKod,quint64 ullElementKod,quint64 ullDannieKod);//Номер Страницы
    bool 		polDanniePervi() { return m_blDanniePervi; }//Вернуть состояние флага Первые Данные?
	void 		ustFileDialogPut(QString strFileDialogPut);//Задать путь к каталогу, в котором файл записи.
    QString 	polImyaFaila(qint64 ullSpisokKod,qint64 ullElementKod,qint64 ullDannieKod);//Получить имя файл
    bool  		estImyaFaila(QString strImyaFaila);//Есть такой файл в каталоге?
    bool  		udalFail(QString strImyaFaila);//Удалить файл в каталоге.
    bool  		udalDannieFail(quint64 ullSpisokKod);//Удалить файл Плана Списка.
    bool  		udalDannieFaili(quint64 ullSpisokKod, quint64 ullElementKod);//Удалить все файлы Элемента.
    bool  		udalDannieTablicu(quint64 ullSpisokKod, quint64 ullElementKod);//Удалить таблицу Данных.
    bool 		copyDannie(QString strAbsolutPut, QString strImyaFaila);//Копируем файл в приложение.
    DCDB*		polPDB();//Получить указатель на БД Данных.

private:
    bool 		m_blDanniePervi;//Первый элемент в Данных.
    quint64 	m_ullDannieMax;//Максимальное количество Документов в Элементе.
    DCDB* 		m_pdbDannie = nullptr;//Указатель на базу данных таблицы данных.
    DCClass* 	m_pdcclass = nullptr;//Указатель на мой класс с методами.
    CopyDannie* m_pcopydannie = nullptr;//Указатель на поток копирования файла.

    QString 	m_strImyaDB;//Имя БД
    QString 	m_strImyaDBData;//Имя БД данных.
    QString 	m_strLoginDB;//Логин БД
    QString 	m_strParolDB;//Пароль БД
	QString 	m_strFileDialogPut;//Путь к каталогу, в котором лежит файл для записи.
    QString 	m_strWorkingDiagramsPut;//Каталог хранения документов.
    QStringList m_slsINSERT;//Строка, хранящая данные для Запроса записи в БД.

private slots:
    void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог
    void 		slotCopyDannie(bool);//слот статуса скопированного документа true - скопирован, false - нет

signals:
    void		signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
    void  		signalFileDialogCopy(bool);//Сигнал статуса скопированного документа.

};

#endif // DATADANNIE_H
