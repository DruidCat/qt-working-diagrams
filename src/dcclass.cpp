﻿#include "dcclass.h"
#include <QtDebug>

DCClass::DCClass(QObject* proditel) : QObject(proditel){
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
}
bool DCClass::isEmpty(QString strTekst){//в строчке пусто, один или множество пробелов, то возвращается true. 
/////////////////////////////////////
//---П У С Т А Я   С Т Р О К А ?---//
/////////////////////////////////////
	if(strTekst.isEmpty())//Если строчка пустая, то...
		return true;//Строчка пустая.
	else{//Если строчка не пустая а содежжит символы, то...
        QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
        for(int ntShag = 0; ntShag < btrTekst.size(); ntShag++){
            if(btrTekst[ntShag] != ' ')//Если это не пробел, то...
				return false;//То строчка не пустая.
		}	
	}
    return true;//Строчка пустая.
}
bool DCClass::isFolder(QString strTekst){//Если это [папка], то истина.
/////////////////////////////
//---Э Т О   П А П К А ?---//
/////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
	int ntTekst = btrTekst.size();//Размер текста.
    if(!strTekst.isEmpty()){//Если cтрока не пустая, то...
		if(ntTekst > 2){//Если больше двух [x], если меньше, то это файл...
        	if ((btrTekst[0] == '[')&&(btrTekst[ntTekst-1] == ']'))//Если это [ и ], то..
				return true;
		}
	}
	return false;
}
bool DCClass::isLabelFolder(QString strTekst){//Если это папка.lnk, то истина.
/////////////////////////////////////////
//---Э Т О   П А П К А   Я Р Л Ы К ?---//
/////////////////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
	int ntTekst = btrTekst.size();//Размер текста.
    if(!strTekst.isEmpty()){//Если cтрока не пустая, то...
		if(ntTekst > 4){//Если больше 4, то может быть x.lnk, если меньше, то папка обычная...
        	if (btrTekst[ntTekst-4] == '.'){//это может быть .lnk , то..
				if(((btrTekst[ntTekst-3]=='L')||(btrTekst[ntTekst-3]=='l'))
						&&((btrTekst[ntTekst-2]=='N')||(btrTekst[ntTekst-2]=='n'))
						&&((btrTekst[ntTekst-1]=='K')||(btrTekst[ntTekst-1]=='k'))){//Если это lnk, то...
					return true;
				}
			}
		}
	}
	return false;
}
bool DCClass::isHideFolder(QString strTekst){//Если папка скрытая, то истина.
/////////////////////////////////////////////
//---Э Т О   С К Р Ы Т А Я   П А П К А ?---//
/////////////////////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
    if(!strTekst.isEmpty()){//Если cтрока не пустая, то...
        if ((strTekst != ".")&&(strTekst != ".."))//Если это не . и не .., то..
            if(btrTekst[0] == '.')//Если имя папки начинается с '.', то...
                return true;//Это скрытая папка.
    }
    return false;//Не скрытая папка.
}
QString DCClass::baseName(QString strTekst){//Вернуть имя файла без его разширения.
///////////////////////////////
//---Б А З О В О Е   И М Я---//
///////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
    int ntTekst = btrTekst.size();//Количество символов в тексте.
	int ntTochka = 0;//Какой символ точка по счёту
    for(int ntShag = ntTekst-1; ntShag > 0; ntShag--){//Цикл подсчёта точки расширения. 
        if(btrTekst[ntShag] == '.'){//Если это пустота, то...
            ntTochka = ntShag;//Приравниваем к счетчику
			break;//Выходим из цикла.
		}
	}
	if(!ntTochka)//Если нет разширения в файле, то...
		return strTekst;//Возвращаем строку без изменений.
	
	QByteArray btrStroka;//Соберём строку без разширения
	for(int ntShag = 0; ntShag < ntTochka; ntShag++)//Цикл сборки строки без разширения
		btrStroka = btrStroka + btrTekst[ntShag];//Собираем строку
	return QString(btrStroka);//Возвращаем строку без разширения.
}
QString DCClass::udalitPustotu(QString strTekst){//Удаляет пробелы вначале и в конце текста.
/////////////////////////////////////
//---У Д А Л И Т   П У С Т О Т У---//
/////////////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
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
        for(int untShag = ntTekst-1; untShag > 0; untShag--){//Цикл поиска пустот в конце текста.
			if((btrTekst[untShag] == ' ')||(btrTekst[untShag] == '\n'))//Если это пустота, то...
                ntKolPustotiKonec++;//Считаю пустоты в конце текста.
			else//Если это не пустота, то...
				break;//Выходим из цикла, так как подсчитали количество пустот в конце текста.	
		}
	}
	//Собираем строку символов без пробелов с начала и конца.
	QByteArray btrStroka;//Массив символов, в котором соберём строку без пробелов с начала и конца.
    for(int ntShag = ntKolPustotiNachalo; ntShag < ntTekst-ntKolPustotiKonec; ntShag++){
        btrStroka = btrStroka + btrTekst[ntShag];
    }
	return QString(btrStroka);//Передаём QString строку.
}
QString DCClass::udalitProbeli(QString strTekst){//Удаляем два и более пробела между словами.
///////////////////////////////////////////////////////////////////////////////////
//---У Д А Л И Т   П Р О Б Е Л Ы   2   И Л И   Б О Л Е Е   М Е Ж Д У   С Л О В---//
///////////////////////////////////////////////////////////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
	QByteArray btrStroka;//Строка, в которой соберётся предложение.
	uint untTekst = btrTekst.size();//Количество символов в тексте.
	uint untKolProbelov(0);//Количество пробелов между словами.
	for(uint untShag = 0; untShag<untTekst; untShag++){//Цикл перебора на поиск множества пробелов между слов
        if(btrTekst[untShag] == ' ')//Если это пустота, то...
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
QString DCClass::udalitPryamieSkobki(QString strTekst){//Удаляет прямые скобки [] вначале и в конце текста.
///////////////////////////////////////////////////
//---У Д А Л И Т Ь   П Р Я М Ы Е   С К О Б К И---//
///////////////////////////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
    int ntTekst = btrTekst.size();//Количество символов в тексте.
    if(ntTekst < 3)//Если папка с [] меньше трёх символов, то это [] без имени.
        return "DCClass Error.";
    QByteArray btrStroka;//Массив символов, в котором соберём строку без [] с начала и конца.
    for(int ntShag = 1; ntShag < ntTekst-1; ntShag++){//Цикл сбора слова без [ в начале и ] в конце.
        btrStroka = btrStroka + btrTekst[ntShag];
    }
    return QString(btrStroka);//Передаём QString строку.
}
QString DCClass::json_encode(QString strTekst){//Преобразует все кавычки(' ") в формат (\' \") и \ на \\_
/////////////////////////////////////////////////////////////
//---П Р Е О Б Р А З У Е М   Р А З Н Ы Е   К А В Ы Ч К И---//
/////////////////////////////////////////////////////////////
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
	QByteArray btrStroka;//Строка, в которой соберётся предложение.
	uint untTekst = btrTekst.size();//Количество символов в тексте.
	for(uint untShag = 0; untShag<untTekst; untShag++){//Цикл перебора на поиск всех видов кавычек
		if(btrTekst[untShag] != '\\'){//Если это НЕ обратная косая черта.
			if((btrTekst[untShag] == '\"')||(btrTekst[untShag] == '\''))//Если "'
				btrStroka = btrStroka + "\\";//Добавляем якорь перед кавычками.
			btrStroka = btrStroka + btrTekst[untShag];//Собираем строку.
		}
		else//Если это обратная косая черта, то...
			btrStroka = btrStroka + "\\\\";//Заменяем на \\\\ так экранируется данный символ для JSON.parse().
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
QString DCClass::sql_encode(QString strTekst){//Преобразует символы sql инъекций
/////////////////////////////////////////////////////////////////////////
//---П Р Е О Б Р А З У Е М   С И М В О Л Ы   S Q L   И Н Ъ Е К Ц И Й---//
/////////////////////////////////////////////////////////////////////////
    //%_? - Эти символы не заменяются. Которые могут участвовать в sql инъекции. Но они не критичные.
    QByteArray btrTekst = strTekst.toUtf8();//переводим строчку в QByteArray
    QByteArray btrStroka;//Строка, в которой соберётся текст.
    uint untTekst = btrTekst.size();//Количество символов в тексте.
    for(uint untShag = 0; untShag<untTekst; untShag++){//Цикл перебора на поиск всех символов sql инъекций.
        if(btrTekst[untShag] == '\'')//Если (')
            btrStroka = btrStroka + "\"";//Добавляем экран перед кавычкой.
        else{
            if(btrTekst[untShag] == '\\')// Если \, то земеняем на /
                btrStroka = btrStroka + "/";//
            else{
                if(btrTekst[untShag] == '*')// Если *, то земеняем на x
                    btrStroka = btrStroka + "x";//
                else{
                    if(btrTekst[untShag] == ';')// Если ;, то земеняем на :
                        btrStroka = btrStroka + ":";//
                    else {
                        btrStroka = btrStroka + btrTekst[untShag];//Собираем строку.
                    }
                }
            }
        }
    }
    return QString(btrStroka);//Переводим набор символов в строку и возвращаем её.
}
