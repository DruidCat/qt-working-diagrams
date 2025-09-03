#include "dcpdfpoisk.h"
#include <QAbstractItemModel>
#include <QModelIndex>
#include <QDebug>

DCPdfPoisk::DCPdfPoisk(QObject* parent) : QObject(parent){
    m_model.setDocument(&m_doc);

    auto onChanged = [this]{ recomputeMatchCount(); };
    connect(&m_model, &QAbstractItemModel::modelReset,   this, onChanged);
    connect(&m_model, &QAbstractItemModel::dataChanged,  this, onChanged);
    connect(&m_model, &QAbstractItemModel::rowsInserted, this, onChanged);
    connect(&m_model, &QAbstractItemModel::rowsRemoved,  this, onChanged);
}

void DCPdfPoisk::loadFromUrl(const QUrl& url){
    m_doc.close();

    if (!url.isValid())
        return;

    if (url.isLocalFile()) {
        m_doc.load(url.toLocalFile());
        return;
    }
    if (url.scheme() == "qrc") {
        const QString resPath = ":" + url.path(); // "qrc:/a/b.pdf" -> ":/a/b.pdf"
        m_doc.load(resPath);
        return;
    }
    if (url.scheme().isEmpty()) {
        m_doc.load(url.toString());
        return;
    }

    qWarning() << "DCPdfPoisk: unsupported URL scheme" << url;
}

void DCPdfPoisk::setSource(const QUrl& url){
    if (m_source == url) return;
    m_source = url;
    loadFromUrl(m_source);

    // Применяем текущую строку (если уже была)
    m_model.setSearchString(m_query);

    emit sourceChanged();
    recomputeMatchCount();
}

void DCPdfPoisk::setQuery(const QString& q){
    if (m_query == q) return;
    m_query = q;
    m_model.setSearchString(q);
    emit queryChanged();
    recomputeMatchCount();
}

void DCPdfPoisk::recomputeMatchCount(){
    int total = 0;
    const int rc = m_model.rowCount(QModelIndex()); // важно: передаём QModelIndex()

    const auto roles = m_model.roleNames();
    const int hitCountRole = roles.key("hitCount", -1);
    int regionsRole = roles.key("locations", -1);
    if (regionsRole < 0) regionsRole = roles.key("rectangles", -1);
    if (regionsRole < 0) regionsRole = roles.key("bounds", -1);

    for (int row = 0; row < rc; ++row) {
        const QModelIndex idx = m_model.index(row, 0);
        if (hitCountRole >= 0) {
            total += m_model.data(idx, hitCountRole).toInt();
        } else if (regionsRole >= 0) {
            total += m_model.data(idx, regionsRole).toList().size();
        } else {
            total += 1; // фоллбек
        }
    }
    if (m_matchCount != total) {
        m_matchCount = total;
        emit matchCountChanged();
    }
}

QVariantList DCPdfPoisk::resultsOnPage(int page) const{
    QVariantList ret;
    const auto roles = m_model.roleNames();
    const int pageRole = roles.key("page", -1);
    int regionsRole = roles.key("locations", -1);
    if (regionsRole < 0) regionsRole = roles.key("rectangles", -1);
    if (regionsRole < 0) regionsRole = roles.key("bounds", -1);

    const int rc = m_model.rowCount(QModelIndex());
    for (int row = 0; row < rc; ++row) {
        const QModelIndex idx = m_model.index(row, 0);
        if (pageRole >= 0 && m_model.data(idx, pageRole).toInt() != page)
            continue;
        const QVariantList list = m_model.data(idx, regionsRole).toList();
        for (const QVariant& e : list)
            ret << e;
    }
    return ret;
}
