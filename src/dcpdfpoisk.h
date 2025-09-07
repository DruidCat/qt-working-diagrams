#ifndef DCPDFPOISK_H
#define DCPDFPOISK_H

#pragma once
#include <QObject>
#include <QUrl>
#include <QtPdf/QPdfDocument>
#include <QtPdf/QPdfSearchModel>
#include <QVariantList>

class DCPdfPoisk : public QObject {
    Q_OBJECT
    Q_PROPERTY(QUrl urlPdf
                    READ urlPdf
                    WRITE setUrlPdf
                    NOTIFY urlPdfChanged)
    Q_PROPERTY(QString strPoisk
                    READ strPoisk
                    WRITE setStrPoisk
                    NOTIFY strPoiskChanged)
    Q_PROPERTY(int 	ntSchetchik
                    READ ntSchetchik
                    NOTIFY ntSchetchikChanged)
    Q_PROPERTY(bool isPoisk
                    READ isPoisk
                    NOTIFY isPoiskChanged)
    Q_PROPERTY(QPdfSearchModel* psmModel
                    READ psmModel CONSTANT)

public:
    explicit DCPdfPoisk(QObject* proditel = nullptr);//Конструктор.
    ~ 		DCPdfPoisk();//Деструктор.
    //---Методы Q_PROPERTY---//
    QUrl	urlPdf() const { return m_urlPdf; }//Возвратить путь pdf документа.
    void	setUrlPdf(const QUrl& urlPdf);//Задаём путь к pdf документу.
    QString strPoisk() const { return m_strPoisk; }//Возвратить строку запроса на поиск.
    void 	setStrPoisk(const QString& strPoisk);//Задаём запрос на поиск
    int 	ntSchetchik() const { return m_ntSchetchik; }//Возвратить счётчик совпадений по поиску.
    bool 	isPoisk() const { return m_isPoisk; }//Возвращает статус поиска.
    QPdfSearchModel* psmModel() { return &m_psmModel; }
    Q_INVOKABLE QVariantList resultsOnPage(int ntStranica) const;//Прямоугольники совпадений на странице (нормализованные 0..1)

private:
    void 	pereschetSchetchika();//Пересчёт количества совпадений при поиске.
    bool 	ustPdfDoc(const QUrl& urlPdf);//Задаём pdf документ по ссылке url.

    QUrl	m_urlPdf;//Переменная хранящая ссылку на pdf документ.
    QPdfDocument	m_pdfDoc;//pdf документ, в котором мы будет считать совпадения поиска.
    QPdfSearchModel	m_psmModel;//Модель поиска.
    QString	m_strPoisk;//Запрос на поиск. ЧТо будем искать.
    int		m_ntSchetchik;//Счётчик количества совпадений.
    bool 	m_isPoisk;//Статус поиска. true - поиск идёт, false - поиск окончен.

private slots:
    void	qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог

signals:
    void 	urlPdfChanged();//Сигнал о том, что путь к pdf документу изменилась.
    void 	strPoiskChanged();//Сигнал о том, что запрос поисковый изменился.
    void 	ntSchetchikChanged();//Сигнал о том, что Счётчик совпадений поиска изменился.
    void 	isPoiskChanged();//Сигнал о том, что статус поиска изменился.
    void	signalDebug(QString strDebug);//Испускаем сигнал со строчкой Лог
};

#endif // DCPDFPOISK_H
