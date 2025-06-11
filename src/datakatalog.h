#ifndef DATAKATALOG_H
#define DATAKATALOG_H

#include <QObject>
#include <QDate>

#include "copykatalog.h"
#include "dcdb.h"

class DataKatalog : public QObject {
    Q_OBJECT
public:
    explicit 	DataKatalog(QObject* proditel = nullptr);
    ~			DataKatalog();
    void		ustPDBTitul(DCDB* pdbTitul);//Устанавливаем указатель БД Титула.
    void		ustPDBSpisok(DCDB* pdbSpisok);//Устанавливаем указатель БД Списка.
    void		ustPDBElement(DCDB* pdbElement);//Устанавливаем указатель БД Элемента.
    void		ustPDBDannie(DCDB* pdbDannie);//Устанавливаем указатель БД Данных.

    int 		polPdfSummu();//Возвратим приблизительную сумму всех pdf документов в Менторе.
    void		copyStart();//Старт копирования документов в каталог.

private:
    DCDB*		m_pdbTitul = nullptr;//Указатель на БД Титула.
    DCDB*		m_pdbSpisok = nullptr;//Указатель на БД Списка.
    DCDB*		m_pdbElement = nullptr;//Указатель на БД Элемента.
    DCDB*		m_pdbDannie = nullptr;//Указатель на БД Данных.
    CopyKatalog* m_pcopykatalog = nullptr;//Указатель на поток копирования файла.

    QDir*		m_pdrPut = nullptr;//Указатель на путь каталогов, в которых заместится документация.
    bool		sozdatKatalogMentor();//Создаём каталог Ментор.
    bool		sozdatKatalogTitul();//Создаём каталог Титул.

    QString		m_strDocPut;//Переменная, которая хранит в себе путь к дериктории Документы.

private slots:
    void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог
    void 		slotCopyDannie(bool);//слот статуса скопированного документа true - скопирован, false - нет

signals:
    void		signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
    void  		signalKatalogCopy(bool);//Сигнал статуса скопированного документа.
};

#endif // DATAKATALOG_H
