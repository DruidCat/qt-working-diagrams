#ifndef DCFILEDIALOG_H
#define DCFILEDIALOG_H

#include <QObject>
#include <QDebug>
#include <QDir>
#include "dcclass.h"

class DCFileDialog : public QObject {
    Q_OBJECT
public:
    explicit	DCFileDialog(QStringList slsFileDialogMaska, QObject* proditel = nullptr);
    ~			DCFileDialog();//Деструктор.
    bool 		ustFileDialogPut(QString strPut);//Устанавливаем фиксированные пути.
    QString 	polFileDialogPut(void);//Получить путь к каталогу.
    bool 		ustSpisokJSON(QString strFileDialogPut);//Установить значение нового пути папки, или имя файла
    QString 	polSpisokJSON();//Метод создающий список каталогов и файлов конкретной дериктории.

private:
    DCClass*	m_pdcclass;//Класс работающий с текстом.
    QDir*		m_pdrPut;//Путь, который в данный момент нужно показать.
    QString 	m_strFileDialogImya;//Имя выбранного файла.
    QString 	m_strFileDialogPut;//Путь папки, содержимое которой нужно отобразить.
    QString 	m_strFileDialogPutDom;//Путь папки, содержащий имя каталога по умолчанию. Домашний.
    QStringList m_slsFileDialogMaska;//Маска, список отображаемых разширений файлов.

signals:

};

#endif // DCFILEDIALOG_H
/////////////////////////////
//---И Н С Т Р У К Ц И Я---//
/////////////////////////////
/*
 * Конструктор  DCFileDialog(	QStringList slsFileDialogMaska);
 *
 * slsFileDialogMaska - устанавливаем маску отображения разширений файлов
 * 		QStringList slsFileDialogMaska = QStringList() << "*.pdf"<<"*.PDF"<<"*.Pdf";
 * Если нужно отобразить все файлы, то:
 * 		QStringList slsFileDialogMaska = QStringList() << "*";
 *
 * bool 	ustSpisokJSON(QString strFileDialogPut);//Установить значение нового пути папки.
 * 		strFileDialogPut - имя [папка] на которую нужно перейти или [..], чтоб вернуться назад
 *
 * QString 	polSpisokJSON();//Метод создающий список каталогов и файлов конкретной дериктории.
 * Этот метод возвращает полноценный JSON строку с отображением всех папок и файлов заданного каталога.
 *
 * bool 	ustFileDialogPut(QString strPut);//Устанавливаем фиксированные пути.
 * 		strPut - задаёт путь по флагам:
 * 			dom - задаёт путь Домашний каталог.
 */
