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
	//---пробелы-в-начале-текста?---//
	QString udalitPustotu(QString strTekst);//Удаляет пробелы вначале и в конце текста.
	//---данные-в-число---//
	QTime tmMinus(const QTime& tmVremya1, const QTime& tmVremya2 );//Возращает разницу tmVremya1-tmVremya2
	QTime tmPlus(const QTime& tmVremya1, const QTime& tmVremya2 );//Возращает сумму tmVremya1+tmVremya2
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
