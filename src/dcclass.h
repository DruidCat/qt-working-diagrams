#ifndef DCCLASS_H
#define DCCLASS_H

#include <QObject>
#include <QTimer>
#include <QTime>

class DCClass : public QObject{
	Q_OBJECT
public:
	explicit DCClass(QObject* proditel = nullptr);
	//---пустая-строчка?---//
	bool isEmpty(QString strTekst);//если в строчке пусто, один или множество пробелов, то возвращается true. 
    //---это-папка?---//
    bool isFolder(QString strTekst);//Если это [папка], то истина.
	//---это-папка-ярлык---//
	bool isLabelFolder(QString strTekst);//Если это папка.lnk, то истина.
    //---скрытая-папка?---//
    bool isHideFolder(QString strTekst);//Если папка скрытая, то истина.
	//---пробелы-в-начале-текста?---//
	QString udalitPustotu(QString strTekst);//Удаляет пробелы вначале и в конце текста.
    QString udalitProbeli(QString strTekst);//Удаляем два и более пробела между словами.
    //---удалить-прямые-скобки---//
    QString udalitPryamieSkobki(QString strTekst);//Удаляет прямые скобки [] вначале и в конце текста.
    QString json_encode(QString strTekst);//Преобразует все кавычки(' ") в формат (\' \") и \ на \\_
	//---данные-в-число---//
	QTime tmMinus(const QTime& tmVremya1, const QTime& tmVremya2 );//Возращает разницу tmVremya1-tmVremya2
	QTime tmPlus(const QTime& tmVremya1, const QTime& tmVremya2 );//Возращает сумму tmVremya1+tmVremya2
    //---текст---//
    QString sql_encode(QString strTekst);//Преобразует символы sql инъекций
};

#endif // DCCLASS_H

/////////////////////////////
//---И Н С Т Р У К Ц И И---//
/////////////////////////////
/*
 * //---в test.h---//
 #include "dcclass.h"
 DCClass* m_pdcclass = nullptr;//Указатель на класс часто используемых методов.
 * //---в конструкторе test.cpp---//
 m_pdcclass = new DCClass;//Создаём динамический указатель на класс часто используемых методов.
 */
