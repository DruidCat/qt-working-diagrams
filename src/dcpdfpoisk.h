#ifndef DCPDFPOISK_H
#define DCPDFPOISK_H

#pragma once
#include <QObject>
#include <QUrl>
#include <QtPdf/QPdfDocument>
#include <QtPdf/QPdfSearchModel>
#include <QVariantList>

class DCPdfPoisk : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(int matchCount READ matchCount NOTIFY matchCountChanged)
    Q_PROPERTY(QPdfSearchModel* model READ model CONSTANT)

public:
    explicit DCPdfPoisk(QObject* parent=nullptr);

    QUrl source() const { return m_source; }
    void setSource(const QUrl& url);

    QString query() const { return m_query; }
    void setQuery(const QString& q);

    int matchCount() const { return m_matchCount; }
    QPdfSearchModel* model() { return &m_model; }

    // Прямоугольники совпадений на странице (нормализованные 0..1)
    Q_INVOKABLE QVariantList resultsOnPage(int page) const;
signals:
    void sourceChanged();
    void queryChanged();
    void matchCountChanged();

private:
    void recomputeMatchCount();
    void loadFromUrl(const QUrl& url);

    QUrl m_source;
    QPdfDocument m_doc;
    QPdfSearchModel m_model;
    QString m_query;
    int m_matchCount = 0;
};

#endif // DCPDFPOISK_H
