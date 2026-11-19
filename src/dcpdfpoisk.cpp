#include "dcpdfpoisk.h"
#include <QPdfLink>
#include <QTimerEvent>
#include <QDebug>

PoiskModelSkanirovannyj::PoiskModelSkanirovannyj(QObject* proditel)
    : QPdfSearchModel(proditel), ntNextPage(0), blIdetObhod(false){//Конструктор.
/////////////////////////////////////////////////////////////////////////

    //Темп как у штатного сканирования PdfMultiPageView: одна страница за тик,
    //чтобы поисковая модель интерфейса успевала заполнять список боковой панели.
    m_tmrTik.setInterval(100);
    connect(&m_tmrTik, &QTimer::timeout, this, &PoiskModelSkanirovannyj::proskanirovatStranicyTik);
}
void PoiskModelSkanirovannyj::timerEvent(QTimerEvent* event){//Перехват таймеров базовой модели.
/////////////////////////////////////////////////////
//---П Е Р Е Х В А Т   Т А Й М Е Р О В---//
/////////////////////////////////////////////////////

    //Все timerEvent этого объекта — от внутренних таймеров базового QPdfSearchModel
    //(наш тик — отдельный QTimer-объект). Гасим базовый таймер и ведём обход сами.
    killTimer(event->timerId());//Гасим внутренний таймер базовой модели.
    if(searchString().isEmpty())//Пустой запрос (например загрузка документа) сканировать незачем.
        return;
    if(!blIdetObhod){//Если наш обход ещё не ведётся, запускаем его с нулевой страницы.
        ntNextPage = 0;
        blIdetObhod = true;
        m_tmrTik.start();
    }
}
void PoiskModelSkanirovannyj::nachatObhod(const QString& strPoisk){//Перезапуск обхода с новым запросом.
/////////////////////////////////////////////////
//---Н А Ч А Л О   О Б Х О Д А---//
/////////////////////////////////////////////////

    ostanovitObhod();//Останавливаем предыдущий обход, если он шёл.
    ntNextPage = 0;//Нумерацию обхода начинаем с первой страницы.
    setSearchString(strPoisk);//База сбросит модель и поднимет свой таймер — тот перехватим.
}
void PoiskModelSkanirovannyj::ostanovitObhod(){//Остановить внешний тик обхода.
//////////////////////////////////////
//---О С Т А Н О В   Т И К А---//
//////////////////////////////////////

    m_tmrTik.stop();//Тик обхода остановлен.
    blIdetObhod = false;//Обход больше не ведётся.
}
void PoiskModelSkanirovannyj::proskanirovatStranicyTik(){//Тик: одна страница за 100 мс.
/////////////////////////////////////////
//---Т И К   О Б Х О Д А---//
/////////////////////////////////////////

    QPdfDocument* pDoc = document();//Документ, к которому прикреплена модель.
    if(searchString().isEmpty()){//На всякий случай: запрос пуст — обход не нужен.
        ostanovitObhod();
        return;
    }
    if(!pDoc || pDoc->pageCount() <= 0){//Документа нет или он пуст — обход не нужен.
        ostanovitObhod();
        return;
    }
    if(ntNextPage >= pDoc->pageCount()){//На всякий случай: границы вышли — завершаем обход.
        ostanovitObhod();
        emit sgnObhodZavershen(pDoc->pageCount());
        return;
    }
    updatePage(ntNextPage);//Ищет эту страницу и дописывает строки в модель.
    ntNextPage += 1;//Страница просмотрена.
    emit sgnTikObhoda(ntNextPage, pDoc->pageCount());
    if(ntNextPage >= pDoc->pageCount()){//Последняя страница просмотрена — обход точечно завершён.
        ostanovitObhod();
        emit sgnObhodZavershen(pDoc->pageCount());
    }
}

DCPdfPoisk::DCPdfPoisk(QObject* proditel) : QObject(proditel){//Конструктор.
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    m_urlPdf = QUrl();//Пустая ссылка на pdf документ.
    m_strPoisk = QString();//Пустой запрос на поиск.
    m_ntSchetchik = 0;//Обнуляем счётчик количества совпадений.
    m_ntProgress = 0;//Прогресс обхода обнулён.
    m_ntPageProsmotra = 0;//Ни одной страницы не просмотрено.
    m_ntVsegoStranic = 0;//Количество страниц документа неизвестно.
    m_isPoisk = false;//true - поиск идёт, false - поиск окончен.
    m_netSovpadenij = false;//Результат «ничего не найдено» выключен.
    m_blZhdemDokument = false;//Ожидание готовности документа не активено.

    m_modelPoiska.setDocument(&m_pdfDoc);//Управляемая модель поиска работает по нашему документу.
    connect(&m_modelPoiska, &PoiskModelSkanirovannyj::sgnTikObhoda,
            this, &DCPdfPoisk::onTikObhoda);//Тики обхода: обновляем счётчики и прогресс.
    connect(&m_modelPoiska, &PoiskModelSkanirovannyj::sgnObhodZavershen,
            this, &DCPdfPoisk::onObhodZavershen);//Точное окончание обхода: подводим итог.
    connect(&m_pdfDoc, &QPdfDocument::statusChanged, this,
            [this](QPdfDocument::Status utSt){//Готовность/ошибка документа: старт или авария обхода.
                onStatusDokumenta(int(utSt));
            });
}
DCPdfPoisk::~DCPdfPoisk(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////

    m_modelPoiska.ostanovitObhod();//Останавливаем обход страниц.
}
QUrl DCPdfPoisk::urlPdf() const{//Возвращает путь к pdf документу.
/////////////////////////////////////////
    return m_urlPdf;
}
QString DCPdfPoisk::strPoisk() const{//Возвращает запрос для поиска.
/////////////////////////////////////////
    return m_strPoisk;
}
bool DCPdfPoisk::isPoisk() const{//Возвращает статус: идёт ли поиск.
/////////////////////////////////////////
    return m_isPoisk;
}
bool DCPdfPoisk::netSovpadenij() const{//Возвращает результат: пуст ли завершённый поиск.
/////////////////////////////////////////
    return m_netSovpadenij;
}
int DCPdfPoisk::ntSchetchik() const{//Возвращает число найденных совпадений.
/////////////////////////////////////////
    return m_ntSchetchik;
}
int DCPdfPoisk::ntProgress() const{//Возвращает процент обхода страниц.
/////////////////////////////////////////
    return m_ntProgress;
}
int DCPdfPoisk::ntPageProsmotra() const{//Возвращает номер просмотренной страницы обхода.
/////////////////////////////////////////
    return m_ntPageProsmotra;
}
bool DCPdfPoisk::ustPdfDoc(const QUrl& urlPdf){//Загрузка своего экземпляра pdf документа.
/////////////////////////////////////
//---З А Г Р У З К А   Д О К У М Е Н Т А---//
/////////////////////////////////////
    m_pdfDoc.close();//Перед загрузкой нового закрываем предыдущий документ.
    if(urlPdf.isValid()){//Если это url ссылка, то...
        if(urlPdf.isLocalFile()){//Если url сслыка - это локальный файл, то...
            m_pdfDoc.load(urlPdf.toLocalFile());//Добавляем ссылку на локальный файл в pdf документ.
            return true;//Успех.
        }
        else{
            if(urlPdf.scheme() == "qrc"){//Если scheme (file, qrc, http) - это qrc, то...
                const QString strPath = ":" + urlPdf.path();//"qrc:/документ.pdf" -> ":/документ.pdf"
                m_pdfDoc.load(strPath);//Загружаем ссылку с путём на файл в pdf документ.
                return true;//Успех.
            }
            else{
                if(urlPdf.scheme().isEmpty()){//Если scheme отсутствует, то...
                    m_pdfDoc.load(urlPdf.toString());//Добавляем строкой url ссылку в pdf документ.
                    return true;//Успех.
                }
            }
        }
    }
    qWarning() << "DCPdfPoisk: не поддерживает такую URL схему:" << urlPdf.toString();
    return false;//Ошибка.
}
void DCPdfPoisk::setUrlPdf(const QUrl& urlPdf){//Задаём путь к pdf документу.
///////////////////////////////////////////////////////////
//---З А Д А Ё М   П У Т Ь   P D F   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////

    if(m_urlPdf != urlPdf){//Если пути не равные, то...
        m_urlPdf = urlPdf;//Приравниваем пути.
        emit urlPdfChanged();//Излучаем сигнал о том, что путь документа pdf изменился.
        if(m_modelPoiska.blIdetObhod)//Если обход шёл, останавливаем: документ меняется.
            m_modelPoiska.ostanovitObhod();
        if(!ustPdfDoc(urlPdf))//Загружаем свой экземпляр документа для точного обхода.
            qWarning() << "DCPdfPoisk: не удалось загрузить документ:" << urlPdf.toString();
        else if(!m_strPoisk.trimmed().isEmpty()){//Если запрос жив, обход перезапустим по готовности.
            m_blZhdemDokument = true;
        }
    }
}
void DCPdfPoisk::setStrPoisk(const QString& strPoisk){//Задаём запрос на поиск
///////////////////////////////////////
//---З А П Р О С   Н А   П О И С К---//
///////////////////////////////////////

    if (m_strPoisk != strPoisk){//Если запрос поиска не совпадает с предыдущим, то...
        m_strPoisk = strPoisk;//Приравниваем значения поиска.
        emit strPoiskChanged();//Излучаем сигнал о том, что запрос на поиск изменился.
        if(m_strPoisk.trimmed().isEmpty()){//Если запрос пуст (или одни пробелы), то...
            m_blZhdemDokument = false;//Ожидание документа больше не нужно.
            m_modelPoiska.ostanovitObhod();//Обход страниц остановлен.
            m_modelPoiska.setSearchString("");//Сбрасываем запрос и в модели: строки очищаются.
            konchilPoisk("запрос пуст");//Сбрасываем состояние поиска.
            if(m_ntSchetchik != 0){//Счётчик совпадений обнуляем.
                m_ntSchetchik = 0;
                emit ntSchetchikChanged();//Излучаем сигнал обнуления счётчика.
            }
        }
        else//Если запрос есть, то...
            nachalPoisk();//Состояние: поиск начался.
    }
}
void DCPdfPoisk::nachalPoisk(){//Состояние: поиск начался, запуск управляемого обхода.
//////////////////////////////////////////
//---Н А Ч А Л   П О И С К---//
//////////////////////////////////////////

    m_blZhdemDokument = false;//Ждать готовности документа больше не нужно.
    m_ntSchetchik = 0;//На новом запросе счётчик совпадений начинаем с нуля.
    emit ntSchetchikChanged();//Сигнал об обнулении счётчика совпадений.
    m_ntPageProsmotra = 0;//Счётчик просмотренных страниц начинаем с нуля.
    emit ntPageProsmotraChanged();//Сигнал об обнулении просмотренной страницы.
    m_ntVsegoStranic = m_pdfDoc.pageCount();//Всего страниц для обхода (0, если грузится).
    if(m_ntVsegoStranic < 0)//На всякий случай: у тонущего документа pageCount может быть -1.
        m_ntVsegoStranic = 0;
    m_netSovpadenij = false;//Снимаем результат «ничего не найдено».
    emit netSovpadenijChanged();//Сигнал об изменении результата поиска.
    if(!m_isPoisk){
        m_isPoisk = true;//Взводим флаг: поиск идёт.
        emit isPoiskChanged();//Сигнал о том, что изменился статус поиска.
    }
    if(m_ntProgress != 0){
        m_ntProgress = 0;
        emit ntProgressChanged();//Сигнал об обнулении прогресса.
    }
    if(m_pdfDoc.status() == QPdfDocument::Status::Ready)//Документ готов — обход стартует сразу.
        m_modelPoiska.nachatObhod(m_strPoisk);
    else//Документ грузится: обход стартует в onStatusDokumenta по готовности.
        m_blZhdemDokument = true;
}
void DCPdfPoisk::onStatusDokumenta(int utStatus){//Готовность/ошибка своего документа.
///////////////////////////////////////
//---С О С Т О Я Н И Е   Д О К У М Е Н Т А---//
///////////////////////////////////////

    const QPdfDocument::Status utSt = static_cast<QPdfDocument::Status>(utStatus);
    if(utSt == QPdfDocument::Status::Ready && m_blZhdemDokument){//Документ догрузился — обход стартует.
        m_blZhdemDokument = false;
        if(m_isPoisk && !m_strPoisk.trimmed().isEmpty())//Запрос всё ещё жив — погнали обход.
            m_modelPoiska.nachatObhod(m_strPoisk);
    }
    else if(utSt == QPdfDocument::Status::Error && m_isPoisk){//Документ открыть не удалось, искать негде.
        qWarning() << "DCPdfPoisk: ошибка открытия документа, поиск прекращён";
        konchilPoisk("ошибка документа");
    }
}
void DCPdfPoisk::onTikObhoda(int ntProsmotreno, int ntVsego){//Тик обхода: счётчики и прогресс.
//////////////////////////////////////////
//---Т И К   О Б Х О Д А---//
//////////////////////////////////////////

    m_ntPageProsmotra = ntProsmotreno;//Просмотренная страница обхода.
    emit ntPageProsmotraChanged();//Сигнал о том, что просмотрена новая страница.
    m_ntVsegoStranic = ntVsego;//Уточняем всего страниц.
    const int ntNovyjSchetchik = m_modelPoiska.rowCount(QModelIndex());//Строк найдено на данный момент.
    if(m_ntSchetchik != ntNovyjSchetchik){//Счётчик совпадений идёт за обходом страница за страницей.
        m_ntSchetchik = ntNovyjSchetchik;
        emit ntSchetchikChanged();//Излучаем сигнал о том, что счётчик изменился.
    }
    const int ntNovyjProgress = (ntVsego > 0) ? (ntProsmotreno * 100 / ntVsego) : 0;
    if(m_ntProgress != ntNovyjProgress){//Если процент изменился, то...
        m_ntProgress = ntNovyjProgress;//Приравниваем прогресс.
        emit ntProgressChanged();//Сигнал о том, что прогресс поиска изменился.
    }
}
void DCPdfPoisk::onObhodZavershen(int ntVsegoStranic){//Обход всех страниц закончен точно.
////////////////////////////////////////////
//---О Б Х О Д   З А В Е Р Ш Е Н---//
////////////////////////////////////////////

    Q_UNUSED(ntVsegoStranic)//Количество страниц у нас уже учтено в тиках обхода.
    konchilPoisk("обход завершён");//Подводим итог: статус, «ничего не найдено», 100%.
}
void DCPdfPoisk::konchilPoisk(const char* strPrichina){//Состояние: поиск окончен, итог.
/////////////////////////////////////////////////
//---К О Н Ч И Л   П О И С К---//
/////////////////////////////////////////////////

    m_modelPoiska.ostanovitObhod();//Обход страниц остановлен.
    m_blZhdemDokument = false;//Больше документ не ждём.
    if(m_ntProgress != 100){//Прогресс доводим до 100% ровно в момент окончания.
        m_ntProgress = 100;
        emit ntProgressChanged();//Сигнал о том, что прогресс стал 100%.
    }
    if(m_isPoisk){//Если поиск шёл, закрываем его формально и подводим итог.
        m_isPoisk = false;//Флаг: поиск окончен.
        emit isPoiskChanged();//Сигнал о том, что изменился статус поиска.
        m_netSovpadenij = (!m_strPoisk.trimmed().isEmpty() && m_ntSchetchik == 0);
        emit netSovpadenijChanged();//Сигнал об итоговом результате поиска.
    }
    else{//Поиск не шёл (пустой запрос/сброс) — снимаем «ничего не найдено».
        if(m_netSovpadenij){
            m_netSovpadenij = false;
            emit netSovpadenijChanged();//Сигнал о снятии результата «пусто».
        }
    }
    Q_UNUSED(strPrichina)//Причина окончания оставлена в сигнатуре для чтения кода.
}
void DCPdfPoisk::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}
