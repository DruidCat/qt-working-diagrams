#ifndef DATAKATALOG_H
#define DATAKATALOG_H

#include <QObject>

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

private:
    DCDB*		m_pdbTitul = nullptr;//Указатель на БД Титула.
    DCDB*		m_pdbSpisok = nullptr;//Указатель на БД Списка.
    DCDB*		m_pdbElement = nullptr;//Указатель на БД Элемента.
    DCDB*		m_pdbDannie = nullptr;//Указатель на БД Данных.

private slots:
    void 		qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
    void signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
};

#endif // DATAKATALOG_H
