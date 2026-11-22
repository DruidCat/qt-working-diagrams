#pragma once

#include <QObject>
#include <QUrl>
#include <QTimer>
#include <QString>
#include <QtPdf/QPdfDocument>
#include <QtPdf/QPdfSearchModel>
#include <QtPdf/QPdfLink>
#include <QPolygonF>
#include <QAbstractItemModel>

//Модель поиска с управляемым сканированием страниц. Базовый QPdfSearchModel
//устроен «вечно»: у него нет сигнала окончания, счётчик недостоверен, и он
//тихо сканирует страницы внутренним таймером. Потомок перехватывает эти
//внутренние таймеры в timerEvent, гасит их и ведёт обход сам: своим тиком
//100 мс двигает updatePage(страница) по одной странице за тик. Это ЕДИНСТВЕН-
//НАЯ модель поиска в приложении: боковая панель, PdfMultiPageView (подсветка,
//прыжок pageNavigator.jump, жёлтый полигон) и счётчики живут от неё одной,
//поэтому гонки двух поисков больше нет. Роли строк — родные Qt (page,
//indexOnPage, location, contextBefore, contextAfter), делегаты не менялись.
//Класс добавляет свойства, на которые смотрит DCPdfMultiPageView.qml:
//currentResult, currentPage, count, currentResultLink, полигоны подсветки.
class PoiskModelSkanirovannyj : public QPdfSearchModel {
    Q_OBJECT
    //Номер выбранного совпадения: -1 (не выбрано) .. count-1, с клампом при записи.
    Q_PROPERTY(int currentResult READ currentResult WRITE setCurrentResult
               NOTIFY currentResultChanged FINAL)
    //Страница выбранного совпадения (для подсветки DCPdfMultiPageView), -1 если нет.
    Q_PROPERTY(int currentPage READ currentPage NOTIFY currentPageChanged FINAL)
    //Ссылка на выбранный результат: по ней pageNavigator.jump прыгает на страницу.
    Q_PROPERTY(QPdfLink currentResultLink READ currentResultLink
               NOTIFY currentResultChanged FINAL)
    //Полигоны выбранного совпадения: жёлтая подсветка текущего результата.
    Q_PROPERTY(QList<QPolygonF> currentResultBoundingPolygons
               READ currentResultBoundingPolygons
               NOTIFY currentResultBoundingPolygonsChanged FINAL)
public:
    explicit PoiskModelSkanirovannyj(QObject* proditel = nullptr);//Конструктор.
    void nachatObhod(const QString& strPoisk);//Задать запрос: базовый таймер будет перехвачен.
    void ostanovitObhod();//Остановить внешний тик обхода (смена документа/запроса).
    int ntNextPage;//Индекс следующей страницы для обхода.
    bool blIdetObhod;//true - обход ведут наш тик, не таймеры базового класса.

    int currentResult() const;//Номер выбранного совпадения.
    void setCurrentResult(int ntNovyj);//Выбрать совпадение: клампим в [-1 .. count-1].
    int currentPage() const;//Страница выбранного совпадения, -1 если ничего не выбрано.
    int ntVsegoStrok() const;//Число найденных строк модели (родной count не переопределяем).
    QPdfLink currentResultLink() const;//Ссылка выбранного результата для jump().
    QList<QPolygonF> currentResultBoundingPolygons() const;//Полигоны выбранного результата.
    Q_INVOKABLE QList<QPolygonF> boundingPolygonsOnPage(int ntStranica);//Все хиты страницы.
public slots:
    void proskanirovatStranicyTik();//Тик обхода: одна страница updatePage за 100 мс.
signals:
    void sgnTikObhoda(int ntProsmotreno, int ntVsego);//Прогресс обхода страниц.
    void sgnObhodZavershen(int ntVsegoStranic);//Обход всех страниц завершён точно.
    void currentResultChanged();//Сменилось выбранное совпадение.
    void currentPageChanged();//Сменилась страница выбранного совпадения.
    void currentResultBoundingPolygonsChanged();//Сменились полигоны выбранного совпадения.
    void currentPageBoundingPolygonsChanged();//Родное имя сигнала базовой QPdfSearchModel:
    //DCPdfMultiPageView по нему перезапускает подсветку всех страниц (новые строки обхода).
protected:
    void timerEvent(QTimerEvent* event) override;//Перехват и гашение таймеров базовой модели.
private:
    int ntRolStranicy() const;//Роль «page» в ролевой таблице базовой модели.
    int m_ntTekushijResulta;//Выбранное совпадение (-1 — ничего не выбрано).
    QTimer m_tmrTik;//Тик 100 мс, которым сами ведём обход страниц.
};

//Бизнес-логика поиска в pdf документе. Класс держит СВОЙ экземпляр QPdfDocument
//и управляемую модель поиска, поэтому точно знает: когда поиск начался, сколько
//страниц просмотрено, сколько найдено совпадений и когда обход реально закончен.
//QML получает: isPoisk (поиск идёт), netSovpadenij (поиск окончен, ничего нет),
//ntSchetchik (число совпадений), ntProgress (процент обхода), ntPageProsmotra
//(номер просмотренной страницы). Для подсветки в PdfMultiPageView используется
//штатный поиск того же вида, но его ходом мы не управляем: только строчками.
class DCPdfPoisk : public QObject {
    Q_OBJECT
    //Ссылка на pdf документ.
    Q_PROPERTY(QUrl urlPdf READ urlPdf WRITE setUrlPdf NOTIFY urlPdfChanged FINAL)
    //Запрос для поиска.
    Q_PROPERTY(QString strPoisk READ strPoisk WRITE setStrPoisk NOTIFY strPoiskChanged FINAL)
    //true - поиск идёт (обход страниц не завершён), false - поиск окончен.
    Q_PROPERTY(bool isPoisk READ isPoisk NOTIFY isPoiskChanged FINAL)
    //true - поиск закончен и совпадений нет (готовится к показу «Ничего не найдено»).
    Q_PROPERTY(bool netSovpadenij READ netSovpadenij NOTIFY netSovpadenijChanged FINAL)
    //Число найденных совпадений (точная строка счётчика).
    Q_PROPERTY(int ntSchetchik READ ntSchetchik NOTIFY ntSchetchikChanged FINAL)
    //Прогресс обхода страниц поиска 0..100, ровно 100 - обход завершён.
    Q_PROPERTY(int ntProgress READ ntProgress NOTIFY ntProgressChanged FINAL)
    //Номер просмотренной страницы обхода (для подписи вида «страница 37 из 214»).
    Q_PROPERTY(int ntPageProsmotra READ ntPageProsmotra NOTIFY ntPageProsmotraChanged FINAL)
    //Единственная модель поиска: её берут боковая панель и DCPdfMultiPageView.
    Q_PROPERTY(QAbstractItemModel* modelPoiska READ modelPoiska CONSTANT FINAL)
public:
    explicit DCPdfPoisk(QObject* proditel = nullptr);//Конструктор.
    ~DCPdfPoisk();//Деструктор.

    QUrl urlPdf() const;//Возвращает путь к pdf документу.
    void setUrlPdf(const QUrl& urlPdf);//Задаёт путь к pdf документу, загружает свой экземпляр.

    QString strPoisk() const;//Возвращает запрос для поиска.
    void setStrPoisk(const QString& strPoisk);//Задаёт запрос: начал/закончил поиск по факту.

    bool isPoisk() const;//Возвращает статус: идёт ли поиск.
    bool netSovpadenij() const;//Возвращает результат: пуст ли завершённый поиск.
    int ntSchetchik() const;//Возвращает число найденных совпадений.
    int ntProgress() const;//Возвращает процент обхода страниц.
    int ntPageProsmotra() const;//Возвращает номер просмотренной страницы обхода.
    QAbstractItemModel* modelPoiska();//Возвращает единственную модель поиска для QML.
    void qdebug(QString strDebug);//Метод отладки, излучающий строчку Лог.
signals:
    void urlPdfChanged();//Сигнал о том, что изменился путь к pdf документу.
    void strPoiskChanged();//Сигнал о том, что изменился запрос для поиска.
    void isPoiskChanged();//Сигнал о том, что изменился статус поиска.
    void netSovpadenijChanged();//Сигнал о том, что изменился результат «пусто».
    void ntSchetchikChanged();//Сигнал о том, что изменился счётчик совпадений.
    void ntProgressChanged();//Сигнал о том, что изменился прогресс обхода.
    void ntPageProsmotraChanged();//Сигнал о том, что просмотрена новая страница обхода.
    void signalDebug(QString strDebug);//Сигнал отладки со строчкой Лог
public slots:
    void onTikObhoda(int ntProsmotreno, int ntVsego);//Тик обхода: обновить счётчики и прогресс.
    void onObhodZavershen(int ntVsegoStranic);//Обход завершён точно: подводим итог поиска.
    void onStatusDokumenta(int utStatus);//Смена состояния документа: старт/авария обхода.
private slots:
    //Внутренние слоты нет.
private:
    bool ustPdfDoc(const QUrl& urlPdf);//Задаём путь и загружаем свой экземпляр документа.
    void nachalPoisk();//Состояние: поиск начался, запуск управляемого обхода.
    void konchilPoisk(const char* strPrichina);//Состояние: обход окончен, подводим итог.

    QPdfDocument m_pdfDoc;//Свой экземпляр документа: по нему ведём управляемый обход.
    PoiskModelSkanirovannyj m_modelPoiska;//Управляемая модель поиска (прикреплен к m_pdfDoc).
    QUrl m_urlPdf;//Путь к pdf документу.
    QString m_strPoisk;//Запрос для поиска.
    bool m_isPoisk;//true - поиск идёт, false - поиск окончен.
    bool m_netSovpadenij;//true - поиск закончен, совпадений нет.
    bool m_blZhdemDokument;//true - запрос задан, ждём готовности документа.
    int m_ntSchetchik;//Число найденных совпадений (точная строка счётчика).
    int m_ntProgress;//Прогресс обхода страниц 0..100.
    int m_ntPageProsmotra;//Номер просмотренной страницы обхода.
    int m_ntVsegoStranic;//Всего страниц в документе обхода.
};
