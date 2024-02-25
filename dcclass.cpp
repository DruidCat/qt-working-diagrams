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
		for(uint untShag = 0; untShag < btrTekst.size(); untShag++){
			if(btrTekst[untShag] != ' ')//Если это не пробел, то...
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
	uint untTekst = btrTekst.size();//Количество символов в тексте.
	uint untKolPustotiNachalo(0);//Количество пустых символов в начале текста.
	uint untKolPustotiKonec(0);//Количество пустых символов в конце текста.
	for(int untShag = 0; untShag < untTekst; untShag++){//Цикл подсчёта пустот в начале текста.
		if((btrTekst[untShag] == ' ')||(btrTekst[untShag] == '\n'))//Если это пустота, то...
			untKolPustotiNachalo++;//+1
		else//Если это не пустота, то...
			break;//Если не было пустоты в первом символе, заканчиваю работу цикла 
	}
	if(untTekst == untKolPustotiNachalo)//Если это одни пустоты, то...
		return "";//Возвращаем пустую строчку
	else{//Если там есть символы, то...
		for(int untShag = untTekst-1; untShag > 0; untShag--){//Цикл поиска пустот в конце текста.
			if((btrTekst[untShag] == ' ')||(btrTekst[untShag] == '\n'))//Если это пустота, то...
				untKolPustotiKonec++;//Считаю пустоты в конце текста.
			else//Если это не пустота, то...
				break;//Выходим из цикла, так как подсчитали количество пустот в конце текста.	
		}
	}
	//Собираем строку символов без пробелов с начала и конца.
	QByteArray btrStroka;//Массив символов, в котором соберём строку без пробелов с начала и конца.
	for(int untShag = untKolPustotiNachalo; untShag < untTekst-untKolPustotiKonec; untShag++)
		btrStroka = btrStroka + btrTekst[untShag];	
	return QString(btrStroka);//Передаём QString строку.
}
QString DCClass::udalitProbeli(QString strTekst){//Удаляем два и более пробела между словами.
///////////////////////////////////////////////////////////////////////////////////
//---У Д А Л И Т   П Р О Б Е Л Ы   2   И Л И   Б О Л Е Е   М Е Ж Д У   С Л О В---//
///////////////////////////////////////////////////////////////////////////////////
	QByteArray btrTekst = strTekst.toLocal8Bit();//переводим строчку в QByteArray
	QByteArray btrStroka;//Строка, в которой соберётся предложение.
	uint untTekst = btrTekst.size();//Количество символов в тексте.
	uint untKolProbelov(0);//Количество пробелов между словами.
	for(uint untShag = 0; untShag<untTekst; untShag++){//Цикл перебора на поиск множества пробелов между слов
		if((btrTekst[untShag] == ' '))//Если это пустота, то...
			untKolProbelov++;//+1//Считаем количество пробелов
		if(untKolProbelov > 1){//Если пробелов больше одного, то...
			if(btrTekst[untShag] != ' '){//Если это не пробел, то...
				btrStroka = btrStroka + btrTekst[untShag];//Собираем строку.
				untKolProbelov = 0;//Обнуляем счётчик пробелов...
			}
		}
		else{//Иначе собираем строку с симвалами и одним пробелом.
			btrStroka = btrStroka + btrTekst[untShag];//Собираем строку.
			if(btrTekst[untShag] != ' ')//Если это не пробел, то...
				untKolProbelov = 0;//Обнуляем количество пробелов.
		}
	}
	return QString(btrStroka);//Переводим набор символов в строку и возвращаем её.
}
QString DCClass::json_encode(QString strTekst){//Преобразует все кавычки(' ") в формат (\' \")
/////////////////////////////////////////////////////////////
//---П Р Е О Б Р А З У Е М   Р А З Н Ы Е   К А В Ы Ч К И---//
/////////////////////////////////////////////////////////////
	QByteArray btrTekst = strTekst.toLocal8Bit();//переводим строчку в QByteArray
	QByteArray btrStroka;//Строка, в которой соберётся предложение.
	uint untTekst = btrTekst.size();//Количество символов в тексте.
	for(uint untShag = 0; untShag<untTekst; untShag++){//Цикл перебора на поиск всех видов кавычек
		if(btrTekst[untShag] != '\\'){//Если это НЕ обратная косая черта.
			if((btrTekst[untShag] == '\"')||(btrTekst[untShag] == '\''))//Если "'
				btrStroka = btrStroka + "\\";//Добавляем якорь перед кавычками.
			btrStroka = btrStroka + btrTekst[untShag];//Собираем строку.
		}
		else//Если это обратная косая черта, то...
			btrStroka = btrStroka + "/";//Заменяем на /.
	}
	return QString(btrStroka);//Переводим набор символов в строку и возвращаем её.
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
