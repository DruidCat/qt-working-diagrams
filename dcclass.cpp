#include "dcclass.h"

DCClass::DCClass(QObject* parent) : QObject(parent){
}

bool DCClass::isEmpty(QString strTekst){//в строчке пусто, один или множество пробелов, то возвращается true. 
/////////////////////////////////////
//---П У С Т А Я   С Т Р О К А ?---//
/////////////////////////////////////
	if(strTekst.isEmpty())//Если строчка пустая, то...
		return true;//Строчка пустая.
	else{//Если строчка не пустая а содежжит символы, то...
		QByteArray btrTekst = strTekst.toLocal8Bit();//переводим строчку в QByteArray
		for(int ntShag = 0; ntShag < btrTekst.size(); ntShag++){
			if(btrTekst[ntShag] != ' ')//Если это не пробел, то...
				return false;//То строчка не пустая.
		}	
	}
	return true;//Строчка пустая.
}

QString DCClass::udalitPustotu(QString strTekst){//Удаляет пробелы вначале и в конце текста.
/////////////////////////////////////
//---У Д А Л И Т   П У С Т О Т У---//
/////////////////////////////////////
	QByteArray btrTekst = strTekst.toLocal8Bit();//переводим строчку в QByteArray
	int ntTekst = btrTekst.size();//Количество символов в тексте.
	int ntKolPustotiNachalo(0);//Количество пустых символов в начале текста.
	int ntKolPustotiKonec(0);//Количество пустых символов в конце текста.
	for(int ntShag = 0; ntShag < ntTekst; ntShag++){//Цикл подсчёта пустот в начале текста.
		if((btrTekst[ntShag] == ' ')||(btrTekst[ntShag] == '\n'))//Если это пустота, то...
			ntKolPustotiNachalo++;//+1
		else//Если это не пустота, то...
			break;//Если не было пустоты в первом символе, заканчиваю работу цикла 
	}
	if(ntTekst == ntKolPustotiNachalo)//Если это одни пустоты, то...
		return "";//Возвращаем пустую строчку
	else{//Если там есть символы, то...
		for(int ntShag = ntTekst-1; ntShag > 0; ntShag--){//Цикл поиска пустот в конце текста.
			if((btrTekst[ntShag] == ' ')||(btrTekst[ntShag] == '\n'))//Если это пустота, то...
				ntKolPustotiKonec++;//Считаю пустоты в конце текста.
			else//Если это не пустота, то...
				break;//Выходим из цикла, так как подсчитали количество пустот в конце текста.	
		}
	}
	return strTekst.mid(ntKolPustotiNachalo,ntTekst-ntKolPustotiNachalo-ntKolPustotiKonec);//строка без пустот
}

QTime DCClass::tmMinus(const QTime& tmVremya1, const QTime& tmVremya2 ){//Возращает tmVremya1-tmVremya2
/////////////////////////////////////////////////////
//---Р А С Ч Ё Т   Р А З Н И Ц Ы   В Р Е М Е Н И---//
/////////////////////////////////////////////////////
	int ntRaznica = tmVremya2.secsTo(tmVremya1);
	return QTime(ntRaznica/3600, (ntRaznica % 3600)/60, ntRaznica % 60);
}


QTime DCClass::tmPlus(const QTime& tmVremya1, const QTime& tmVremya2 ){//Возращает сумму tmVremya1+tmVremya2
/////////////////////////////////////////////////
//---Р А С Ч Ё Т   С У М М Ы   В Р Е М Е Н И---//
/////////////////////////////////////////////////
	return tmVremya1.addSecs(tmVremya2.hour()*3600+tmVremya2.minute()*60+tmVremya2.second());
}