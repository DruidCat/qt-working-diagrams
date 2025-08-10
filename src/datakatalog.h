#ifndef DATAKATALOG_H
#define DATAKATALOG_H

#include <QObject>
#include <QDate>

#include "copykatalog.h"
#include "dcdb.h"

class DataKatalog : public QObject {
    Q_OBJECT
public:
    explicit 	DataKatalog(const QString strWorkingData,const QString strDomPut,QObject* proditel=nullptr);
    ~			DataKatalog();
    void		ustPDBTitul(DCDB* pdbTitul);//Устанавливаем указатель БД Титула.
    void		ustPDBSpisok(DCDB* pdbSpisok);//Устанавливаем указатель БД Списка.
    void		ustPDBElement(DCDB* pdbElement);//Устанавливаем указатель БД Элемента.
    void		ustPDBDannie(DCDB* pdbDannie);//Устанавливаем указатель БД Данных.

    int 		polPdfSummu();//Возвратим приблизительную сумму всех pdf документов в Менторе.
    void		copyStart();//Старт копирования документов в каталог.
    void		copyStop();//Стоп копирования документов в каталог.

    void		ustDomPut(const QString strDomPut);//Задаём путь папки, где сохранятся каталоги документов.

private:
    DCDB*		m_pdbTitul = nullptr;//Указатель на БД Титула.
    DCDB*		m_pdbSpisok = nullptr;//Указатель на БД Списка.
    DCDB*		m_pdbElement = nullptr;//Указатель на БД Элемента.
    DCDB*		m_pdbDannie = nullptr;//Указатель на БД Данных.
    CopyKatalog* m_pcopykatalog = nullptr;//Указатель на поток копирования файла.

    QDir*		m_pdrPut = nullptr;//Указатель на путь каталогов, в которых заместится документация.
    void		dataStart();//Первоначальные значения переменных.
    bool		sozdatKatalogMentor();//Создаём каталог Ментор.
    bool		sozdatTitul();//Создаём каталог Титул.
    bool		sozdatSpisok(const uint untSpisokNomer);//Создаём список по его Номеру.
    bool		sozdatElement(const uint untElementNomer);//Создаём Элемент по Номеру.
    bool		sozdatDannie(const uint untDannieNomer);//Копирование документа по Номеру.
    bool		sozdatOpisanie();//Создаём ОПИСАНИЕ Титула.txt
    bool		sozdatOpisanie(const uint untSpisokKod);//Создаём ОПИСАНИЕ Списка.txt
    bool		sozdatOpisanie(const uint untSpisokKod, const uint untElementKod);//Создаём ОПИСАНИЕ Элемента.

    bool		nazadSpisok();//Переходим назад в папку со Списками.
    bool		nazadElement();//Переходим назад в папку в Элементами.

    QString		m_strDomPut;//Переменная, которая хранит в себе путь к дериктории Документы.

    bool 		m_blSpisokMax;//true - Последний элемент Списка.
    bool 		m_blElementMax;//true - Последний Элемент в конкретном Списке.
    bool		m_blDannieMax;//true - Последний элемент Данных в конкретном Элементе.

    uint 		m_untSpisokMax;//Переменная Максимального количества элементов Списка.
    uint 		m_untElementMax;//Переменная Максимального количества Элементов в Списке.
    uint  		m_untDannieMax;//Переменная Максимального количества Данных в Элементе.

    uint		m_untMaxSpisok;//Максимальное количество Элементов в конкретном Списке.

    uint 		m_untSpisokKod;//Это код в БД, элемент Списка которого нужно прочитать.
    uint 		m_untElementKod;//Это код в БД, в Списке Элемент которого нужно прочитать.
    uint 		m_untDannieKod;//Это код в БД, Данные Элемента которох нужно прочитать.

    uint 		m_untSpisokNomer;//Это номер в БД, элемент Списка которого нужно прочитать.
    uint 		m_untElementNomer;//Это номер в БД, в Списке Элемент которого нужно прочитать.
    uint 		m_untDannieNomer;//Это номер в БД, Данные Элемента которох нужно прочитать.

    QString		m_strMentor;//Имя создаваемой папки с каталогом документов.
    QString		m_strTitul;//Имя создаваемой папки Титула.
    QString		m_strSpisok;//Имя создаваемой папки Списка.
    QString		m_strElement;//Имя создаваемой папки Элемента.
    uint		m_untDannie;//Суммарное количество документов в БД.

    bool		m_blDataEmpty;//Пустые данные, true - не излучает сигнала Копирования данных в UI.

    uint 		m_untCd;//Считает,вкаком слое папок находится m_pdrPut(4Start-3Mentor-2Titul-1Spisok-0Element)

    QString 	m_strWorkingData;//Путь к каталогу, где находится БД и документы Ментора.

    bool 		m_blStopCopy;//true - остановка копирования каталога.
private slots:
    void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог
    void 		slotCopyDannie(bool);//слот статуса скопированного документа true - скопирован, false - нет

signals:
    void		signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
    void  		signalKatalogCopy(bool);//Сигнал статуса скопированного документа.
    void  		signalKatalogDocCopy(QString);//Сигнал пути скопированного документа.
    void 		signalKatalogStop();//Окончание процесса копирования.
};

#endif // DATAKATALOG_H
