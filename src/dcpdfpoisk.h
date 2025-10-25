#ifndef DCPDFPOISK_H
#define DCPDFPOISK_H

#pragma once
#include <QObject>
#include <QUrl>
#include <QtPdf/QPdfDocument>
#include <QtPdf/QPdfSearchModel>
#include <QVariantList>
#include <QVariantMap>
#include <QRectF>

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


    // === Новые удобные методы для доступа к результатам ===
    // Прочитать {page, location:{x,y,width,height}, index, valid:true} из любой модели по индексу row
    Q_INVOKABLE QVariantMap getFromModel(QObject* modelObj, int row) const;
    // Прочитать текущий результат из любой модели с currentResult
    Q_INVOKABLE QVariantMap getCurrentFromModel(QObject* modelObj) const;
    // Кол-во строк в любой модели
    Q_INVOKABLE int modelCount(QObject* modelObj) const;
    // Сопоставление "глобального" индекса совпадения → page+rect через наш QPdfSearchModel
    Q_INVOKABLE QVariantMap resultAt(int globalIndex) const;
    // Быстрый доступ к общему числу совпадений (то же, что ntSchetchik)
    Q_INVOKABLE int totalResults() const { return m_ntSchetchik; }


private:
    void 	pereschetSchetchika();//Пересчёт количества совпадений при поиске.
    bool 	ustPdfDoc(const QUrl& urlPdf);//Задаём pdf документ по ссылке url.


    // Вспомогательные
    static int findRole(const QAbstractItemModel* model, const QByteArray& roleName);
    static int findFirstOfRoles(const QAbstractItemModel* model, std::initializer_list<const char*> names);
    static QVariantMap rectToMap(const QRectF& r);
    static QVariantMap makeResult(int page, const QRectF& r, int index, bool valid = true);


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

/*
// читать текущий результат из QML-модели
const r = dcPdfPoisk.getCurrentFromModel(pmpDoc.searchModel);
if (r.valid) {
    console.log("Страница:", r.page, "x:", r.location.x, "y:", r.location.y);
}
//Или по конкретному индексу:
const r = dcPdfPoisk.getFromModel(pmpDoc.searchModel, pmpDoc.searchModel.currentResult);
//Если хочешь отобразить/перейти по “глобальному” индексу совпадения, опираясь на внутренний
    C++ QPdfSearchModel (тот, что в DCPdfPoisk)
const r = dcPdfPoisk.resultAt(pmpDoc.searchModel.currentResult);
// или любой другой индекс
//resultAt() маппит глобальный индекс совпадения через твой C++ QPdfSearchModel, разрезая его по спискам
    “locations”/“rectangles” на каждой строке (странице). Это полезно, если хочется полностью обойтись
    без QML-объекта searchModel.
//Если попадётся вариант QPdfSearchModel, который не отдаёт список прямоугольников, а только
    hitCount — координаты извлечь нельзя; в этом случае вернётся valid:false.
*/
