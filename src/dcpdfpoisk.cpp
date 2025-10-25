#include "dcpdfpoisk.h"
#include <QAbstractItemModel>
#include <QModelIndex>
#include <QDebug>

DCPdfPoisk::DCPdfPoisk(QObject* proditel) : QObject(proditel){//Конструктор.
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    m_psmModel.setDocument(&m_pdfDoc);//Добавляем pdf документ в Модель Поиска PDF.
    m_ntSchetchik = 0;//Обнуляем счётчик количества совпадений.
    m_isPoisk = false;//true - поиск идёт, false - поиск окончен.

    auto onChanged = [this]{ pereschetSchetchika(); };//СЛОТ пересчёта счётчика совпадений при поиске.
    connect(	&m_psmModel,
                &QAbstractItemModel::modelReset,//Структура всей модели обновляется заново.
                this,
                onChanged);
    connect(	&m_psmModel,
                &QAbstractItemModel::dataChanged,//Изменение данных в модели.
                this,
                onChanged);
    connect(	&m_psmModel,
                &QAbstractItemModel::rowsInserted,//Когда вставляются новые строки в модель.
                this,
                onChanged);
    connect(	&m_psmModel,
                &QAbstractItemModel::rowsRemoved,
                this,
                onChanged);
}
DCPdfPoisk::~DCPdfPoisk(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////

}
bool DCPdfPoisk::ustPdfDoc(const QUrl& urlPdf){//Задаём pdf документ по ссылке url.
///////////////////////////////////////////////
//---З А Д А Ё М   P D F   Д О К У М Е Н Т---//
///////////////////////////////////////////////

    m_pdfDoc.close();//Перед тем как задать путь pdf документа, мы закрываем этот документ.
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
    qdebug(tr("DCPdfPoisk: не поддерживает такую URL схему: ") + urlPdf.toString());
    return false;//Ошибка.
}
void DCPdfPoisk::setUrlPdf(const QUrl& urlPdf){//Задаём путь к pdf документу.
///////////////////////////////////////////////////////////
//---З А Д А Ё М   П У Т Ь   P D F   Д О К У М Е Н Т А---//
///////////////////////////////////////////////////////////

    if(m_urlPdf != urlPdf){//Если пути не равные, то...
        if(ustPdfDoc(urlPdf)){//Передаём путь к документу pdf в метод, если успех, то...
            m_urlPdf = urlPdf;//Приравниваем пути.
            m_psmModel.setSearchString(m_strPoisk);//Применяем текущую строку (если уже была)
            emit urlPdfChanged();//Излучаем сигнал о том, что путь документа pdf изменился.
            pereschetSchetchika();//Пересчитываем количество совпадений при поиске.
        }
    }
}
void DCPdfPoisk::setStrPoisk(const QString& strPoisk){//Задаём запрос на поиск
///////////////////////////////////////
//---З А П Р О С   Н А   П О И С К---//
///////////////////////////////////////

    if (m_strPoisk != strPoisk){//Если запрос поиска не совпадает с предыдущим, то...
        m_strPoisk = strPoisk;//Приравниваем значения поиска.
        m_psmModel.setSearchString(m_strPoisk);//Добавляем в модель Поиска поисковый запрос.
        emit strPoiskChanged();//Излучаем сигнал о том, что запрос на поиск изменился.
        pereschetSchetchika();//Пересчитываем количество совпадений при поиске.
    }
}
void DCPdfPoisk::pereschetSchetchika(){//Пересчёт количества совпадений при поиске.
////////////////////////////////////////////////////////////////////
//---П Е Р Е С Ч Ё Т   К О Л И Ч Е С Т В А   С О В П А Д Е Н И Й--//
////////////////////////////////////////////////////////////////////

    m_isPoisk = true;//Поиск начат
    emit isPoiskChanged();//Сигнал о том, что изменился статус поиска.
    int ntSchetchik = 0;
    const int ntKolichestvoStrok = m_psmModel.rowCount(QModelIndex());//Считаем количество строк в Модели.
    const auto utRoli = m_psmModel.roleNames();
    const int hitCountRole = utRoli.key("hitCount", -1);
    int regionsRole = utRoli.key("locations", -1);
    if (regionsRole < 0)
        regionsRole = utRoli.key("rectangles", -1);
    if (regionsRole < 0)
        regionsRole = utRoli.key("bounds", -1);

    for (int ntShag = 0; ntShag < ntKolichestvoStrok; ++ntShag){//Цикл подсчёта совпадений при поиске.
        const QModelIndex mdnModel = m_psmModel.index(ntShag, 0);
        //qDebug()<<"Страница: "<<mdnModel.data(Qt::UserRole).toInt();
        if (hitCountRole >= 0)
            ntSchetchik += m_psmModel.data(mdnModel, hitCountRole).toInt();
        else{
            if (regionsRole >= 0)
                ntSchetchik += m_psmModel.data(mdnModel, regionsRole).toList().size();
            else
                ntSchetchik += 1;//фоллбек
        }
    }
    m_isPoisk = false;//Поиск окончен
    emit isPoiskChanged();//Сигнал о том, что изменился статус поиска.
    if (m_ntSchetchik != ntSchetchik){//Если счётчик изменился, то...
        m_ntSchetchik = ntSchetchik;//Приравниваем счётчик.
        emit ntSchetchikChanged();//Излучаем сигнал о том, что счётчик изменился.
    }
}

QVariantList DCPdfPoisk::resultsOnPage(int ntStranica) const{//Прямоугольники совпадений на странице
///////////////////////////////////////////////////////////////////////////////////
//---П Р Я М О У Г О Л Ь Н И К И   С О В П А Д Е Н И Й   Н А   С Т Р А Н И Ц Е---//
///////////////////////////////////////////////////////////////////////////////////

    QVariantList vrlResultat;
    const auto utRoli = m_psmModel.roleNames();
    const int ntKolichestvoStranic = utRoli.key("page", -1);
    int ntRegionsRole = utRoli.key("locations", -1);
    if(ntRegionsRole < 0)
        ntRegionsRole = utRoli.key("rectangles", -1);
    if(ntRegionsRole < 0)
        ntRegionsRole = utRoli.key("bounds", -1);

    const int ntKolichestvoStrok = m_psmModel.rowCount(QModelIndex());//Считаем количество строк в Модели.
    for(int ntShag = 0; ntShag < ntKolichestvoStrok; ++ntShag) {//Цикл считающий совпадения на странице
        const QModelIndex mdnIndex = m_psmModel.index(ntShag, 0);
        if(ntKolichestvoStranic >= 0 && m_psmModel.data(mdnIndex, ntKolichestvoStranic).toInt() != ntStranica)
            continue;
        const QVariantList vrlSpisok = m_psmModel.data(mdnIndex, ntRegionsRole).toList();
        for(const QVariant& vrSpisok : vrlSpisok )
            vrlResultat << vrSpisok;
    }
    return vrlResultat;
}

void DCPdfPoisk::qdebug(QString strDebug){//Метод отладки, излучающий строчку  Лог
/////////////////////
//---Q D E B U G---//
/////////////////////
    emit signalDebug(strDebug);//Испускаем сигнал со строчкой Лог
}

// ==== Вспомогательные функции ====
int DCPdfPoisk::findRole(const QAbstractItemModel* model, const QByteArray& roleName)
{
    if (!model) return -1;
    const auto roles = model->roleNames();
    for (auto it = roles.cbegin(); it != roles.cend(); ++it) {
        if (it.value() == roleName)
            return it.key();
    }
    return -1;
}

int DCPdfPoisk::findFirstOfRoles(const QAbstractItemModel* model, std::initializer_list<const char*> names)
{
    for (const char* n : names) {
        const int id = findRole(model, QByteArray(n));
        if (id >= 0) return id;
    }
    return -1;
}

QVariantMap DCPdfPoisk::rectToMap(const QRectF& r)
{
    QVariantMap m;
    m.insert("x", r.x());
    m.insert("y", r.y());
    m.insert("width", r.width());
    m.insert("height", r.height());
    return m;
}

QVariantMap DCPdfPoisk::makeResult(int page, const QRectF& r, int index, bool valid)
{
    QVariantMap out;
    out.insert("page", page);
    out.insert("location", rectToMap(r));
    out.insert("index", index);
    out.insert("valid", valid);
    return out;
}

// ==== Новые публичные методы ====

QVariantMap DCPdfPoisk::getFromModel(QObject* modelObj, int row) const
{
    QVariantMap out;
    auto model = qobject_cast<QAbstractItemModel*>(modelObj);
    if (!model) {
        out.insert("valid", false);
        return out;
    }
    if (row < 0 || row >= model->rowCount(QModelIndex())) {
        out.insert("valid", false);
        return out;
    }

    const int pageRole = findRole(model, "page");
    const int locRole  = findFirstOfRoles(model, { "location", "locations", "rect", "rectangle", "rectangles", "bounds" });

    const QModelIndex idx = model->index(row, 0, QModelIndex());
    int page = -1;
    if (pageRole >= 0)
        page = model->data(idx, pageRole).toInt();

    if (locRole >= 0) {
        const QVariant v = model->data(idx, locRole);
        if (v.canConvert<QRectF>()) {
            const QRectF r = v.toRectF();
            return makeResult(page, r, row, true);
        }
        // Если по ошибке пришёл список — возьмём первый элемент как фоллбек
        const QVariantList lst = v.toList();
        if (!lst.isEmpty() && lst.first().canConvert<QRectF>()) {
            const QRectF r = lst.first().toRectF();
            return makeResult(page, r, row, true);
        }
    }

    out.insert("page", page);
    out.insert("index", row);
    out.insert("valid", false);
    return out;
}

QVariantMap DCPdfPoisk::getCurrentFromModel(QObject* modelObj) const
{
    if (!modelObj) return QVariantMap{ { "valid", false } };
    bool ok = false;
    const int cur = modelObj->property("currentResult").toInt(&ok);
    if (!ok || cur < 0) return QVariantMap{ { "valid", false } };
    return getFromModel(modelObj, cur);
}

int DCPdfPoisk::modelCount(QObject* modelObj) const
{
    auto model = qobject_cast<QAbstractItemModel*>(modelObj);
    if (!model) return 0;
    return model->rowCount(QModelIndex());
}

// Преобразование "глобального" индекса совпадения → (page, rect) через внутренний QPdfSearchModel
QVariantMap DCPdfPoisk::resultAt(int globalIndex) const
{
    QVariantMap out;
    if (globalIndex < 0) return QVariantMap{ { "valid", false } };

    const auto roles = m_psmModel.roleNames();
    const int pageRole = roles.key("page", -1);

    // В разных версиях Qt/платформах роль с прямоугольниками могла называться по-разному
    int regionsRole = roles.key("locations", -1);
    if (regionsRole < 0) regionsRole = roles.key("rectangles", -1);
    if (regionsRole < 0) regionsRole = roles.key("bounds", -1);

    const int hitCountRole = roles.key("hitCount", -1);

    const int rows = m_psmModel.rowCount(QModelIndex());
    int base = 0; // сколько совпадений пропустили до текущей строки

    for (int row = 0; row < rows; ++row) {
        const QModelIndex idx = m_psmModel.index(row, 0);

        QVariantList rects;
        if (regionsRole >= 0) {
            rects = m_psmModel.data(idx, regionsRole).toList();
        } else if (hitCountRole >= 0) {
            // Если прямоугольников не дают, но отдают только количество —
            // то к координатам не подобраться, вернём invalid.
            const int hits = m_psmModel.data(idx, hitCountRole).toInt();
            if (globalIndex < base + hits) {
                // Мы попали в нужную страницу, но координат нет
                out.insert("page", pageRole >= 0 ? m_psmModel.data(idx, pageRole).toInt() : -1);
                out.insert("index", globalIndex);
                out.insert("valid", false);
                return out;
            }
            base += hits;
            continue;
        } else {
            // вообще ничего — допустим, 1 хит на страницу (фоллбек)
            rects = QVariantList{ QVariant::fromValue(QRectF()) };
        }

        const int count = rects.size();
        if (globalIndex < base + count) {
            const int onPage = globalIndex - base;
            QRectF r;
            const QVariant& v = rects.at(onPage);
            if (v.canConvert<QRectF>())
                r = v.toRectF();

            const int page = (pageRole >= 0) ? m_psmModel.data(idx, pageRole).toInt() : -1;
            return makeResult(page, r, globalIndex, true);
        }
        base += count;
    }

    return QVariantMap{ { "valid", false } };
}
