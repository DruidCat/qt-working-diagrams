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

    auto onChanged = [this]{ pereschetSchetchika(); };//СЛОТ пересчёта счётчика совпадений при поиске.
    connect(	&m_psmModel,
                &QAbstractItemModel::modelReset,
                this,
                onChanged);
    connect(	&m_psmModel,
                &QAbstractItemModel::dataChanged,
                this,
                onChanged);
    connect(	&m_psmModel,
                &QAbstractItemModel::rowsInserted,
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
        if (hitCountRole >= 0)
            ntSchetchik += m_psmModel.data(mdnModel, hitCountRole).toInt();
        else{
            if (regionsRole >= 0)
                ntSchetchik += m_psmModel.data(mdnModel, regionsRole).toList().size();
            else
                ntSchetchik += 1;//фоллбек
        }
    }
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
