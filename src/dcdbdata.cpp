#include "dcdbdata.h"

DCDBData::DCDBData(const QString strDriver, const QString strImyaDB, const QString strImyaTablici,
		const qint64 llntRazmer, QObject* proditel) : QObject(proditel){//Конструктор.
////////////////////////////////
//---К О Н С Т Р У К Т О-Р----//
////////////////////////////////
	ustDriverDB(strDriver);//Имя SQL драйвера.
	m_strImyaDB = strImyaDB;
	m_strImyaTablici = strImyaTablici;
	m_llntRazmer = llntRazmer * 1024;//Переводим в байты (тестно связан с параметром m_untKolichestvoGraf)
}
DCDBData::DCDBData(const QString strImyaDB, const QString strImyaTablici, const qint64 llntRazmer,
        QObject* proditel) : QObject(proditel){//Конструктор.
////////////////////////////////
//---К О Н С Т Р У К Т О-Р----//
////////////////////////////////
	m_strDriver = "";//Имя SQL драйвера. Необходимо определить методом.
	m_strImyaDB = strImyaDB;
	m_strImyaTablici = strImyaTablici;
	m_llntRazmer = llntRazmer * 1024;//Переводим в байты (тестно связан с параметром m_untKolichestvoGraf)
}
DCDBData::DCDBData(const QString strImyaDB, const qint64 llntRazmer, QObject* proditel) : QObject(proditel){
////////////////////////////////
//---К О Н С Т Р У К Т О-Р----//
////////////////////////////////
	m_strDriver = "";//Имя SQL драйвера. Необходимо определить методом.
	m_strImyaDB = strImyaDB;
	m_strImyaTablici.clear();//Пустая строчка.
	m_llntRazmer = llntRazmer * 1024;//Переводим в байты (тестно связан с параметром m_untKolichestvoGraf)
}
DCDBData::~DCDBData(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////

}
bool DCDBData::CREATE(){//Метод создающий пустую таблицу в БД с выделенным местом под файл.
/////////////////////////////////////////////////////
//---С О З Д А Т Ь   П У С Т У Ю   Т А Б Л И Ц У---//
/////////////////////////////////////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 015 в DCDBData::CREATE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	if(m_strImyaTablici.isEmpty()){//Если имя таблицы не задано, то...
		qdebug(tr("Ошибка 014 в DCDBData::CREATE(): База данных ") + m_strImyaDB
				+ tr(" не задано имя таблицы через метод ustImyaTablici(QString strImyaTablici)"));
		return false;
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untCREATE(0);
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbdataCREATE%1").arg(++untCREATE));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 010 в DCDBData::CREATE(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagZakritiya = false;
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			///////////////////////////////////////////
			/////П Р О В Е Р И Т Ь   Т А Б Л И Ц У/////
			///////////////////////////////////////////
			if(!sqlQuery.exec("SELECT * FROM "+m_strImyaTablici+";")){//Если нет ТАБЛИЦЫ с заданным именем,то
				///////////////////////////////////////
				/////С О З Д А Т Ь   Т А Б Л И Ц У/////
				///////////////////////////////////////
				QString strZapros("");
				for(uint untShag = 0; untShag < m_untKolichestvoGraf; untShag++)
					strZapros += (", \"Данные_" + QString::number(untShag) + "\" INTEGER"); 
			   	if (!sqlQuery.exec("CREATE TABLE "+m_strImyaTablici
						+" (\"Номер\" INTEGER UNIQUE, \"Размер\" INTEGER "+strZapros+");")){//не запустился,то
					qdebug(tr("Ошибка 013 в DCDBData::DCDBData(): В базе данных: ") + m_strImyaDB
							+ tr(" не смог создать таблицу: ") + m_strImyaTablici + tr(" по причине: ")
							+ sqlQuery.lastError().text());
					blFlagZakritiya = false;//Ошибка
			   	}
				else{
					///////////////////////////////////////
					/////В С Т А В И Т Ь   Д А Н Н Ы Е/////
					///////////////////////////////////////
					//+1  на нулевой номер с колличеством строк с данными
					uint untKolichestvoStrok = (m_llntRazmer/1024)+1;
				    if (!sqlQuery.exec("INSERT INTO "+m_strImyaTablici+" (\"Номер\", \"Размер\") VALUES(0, "
							+ QString::number(untKolichestvoStrok) + ");")){//Если запрос не запустился, то...
						qdebug(tr("Ошибка 011 в DCDBData::DCDBData(): В базе данных: ") + m_strImyaDB
								+ tr(" не смог вставить данные в таблицу: ")
								+ m_strImyaTablici + tr(" по причине: ") + sqlQuery.lastError().text());
						blFlagZakritiya = false;//Ошибка
					}
					else{
						QString strGrafi("");
						QString strDannie("");
						for(uint untShag = 0; untShag < m_untKolichestvoGraf; untShag++){
							strGrafi += ", \"Данные_" + QString::number(untShag) + "\"";
							strDannie += ", 0";
						}
						for(uint untShag = 1; untShag < untKolichestvoStrok; untShag++){
				    		if (!sqlQuery.exec("INSERT INTO " + m_strImyaTablici + " (\"Номер\"" + strGrafi
									+") VALUES("+QString::number(untShag)+strDannie + ");")){//не запустился
								qdebug(tr("Ошибка 012 в DCDBData::DCDBData(): В базе данных: ") + m_strImyaDB
										+ tr(" не смог вставить данные в таблицу: ") + m_strImyaTablici
										+ tr(" по причине: ") + sqlQuery.lastError().text());
								blFlagZakritiya = false;//Ошибка
							}
						}
					}
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataCREATE%1").arg(untCREATE));//Закрываем открытую БД
	return blFlagZakritiya;//Возращаем результат.
}

bool DCDBData::DROP(){//Метод удаляющий таблицу в БД.
/////////////////
//---D R O P---//
/////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 072 в DCDBData::DROP(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untDrop(0);
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbdataDROP%1").arg(++untDrop));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 070 в DCDBData::DROP(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagZakritiya = false;//Ошибка открытия базы данных
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\";")){//Если есть ТАБЛИЦА с заданным именем
				///////////////////////////////////////////////////
				/////У Д А Л Я Е М   Т А Б Л И Ц У   И З   Б Д/////
				///////////////////////////////////////////////////
				if(!sqlQuery.exec("DROP TABLE "+m_strImyaTablici+";")){//Если не запустилось удаление таблицы
					qdebug(tr("Ошибка 071 в DCDBData::DROP(): В базе данных: ") + m_strImyaDB
							+ tr(", в таблице: ") + m_strImyaTablici + tr(" по причине: ")
							+ sqlQuery.lastError().text());
					blFlagZakritiya = false;//Ошибка!
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataDROP%1").arg(untDrop));//Закрываем открытую БД
	return blFlagZakritiya;//Возвращаем состояние!
}

bool DCDBData::SELECT(){//Метод проверяющий наличие таблицы в БД.
/////////////////////
//---S E L E C T---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 081 в DCDBData::SELECT(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untSelect(0);
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbdataSELECT%1").arg(++untSelect));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 080 в DCDBData::SELECT(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagZakritiya = false;
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			///////////////////////////////////////////
			/////П Р О В Е Р И Т Ь   Т А Б Л И Ц У/////
			///////////////////////////////////////////
			if(!sqlQuery.exec("SELECT * FROM "+m_strImyaTablici+";"))//Если нет ТАБЛИЦЫ с заданным именем,то
				blFlagZakritiya = false;//Нет таблицы
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataSELECT%1").arg(untSelect));//Закрываем открытую БД
	return blFlagZakritiya;//Возращаем результат.
}

bool DCDBData::write(QString strPut){//Метод записи Файла в базу данных.
///////////////////
//---W R I T E---//
///////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 025 в DCDBData::write(QString): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untWrite(0);
	qint64 llntCRC(0);//Контрольна сумма.
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbdataWrite%1").arg(++untWrite));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 020 в DCDBData::write(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
    		blFlagZakritiya = false;//Ошибка 
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			///////////////////////////////////////////////////////
			/////П Р О В Е Р К А   В Е Л И Ч И Н Ы   Ф А Й Л А/////
			///////////////////////////////////////////////////////
			QFileInfo flnFile(strPut);//Хочу получить информацию по файлу из указанного пути
			qint64 llntRazmerFaila = flnFile.size();
			if(m_llntRazmer < llntRazmerFaila){//сравниваем заданный максимальный размер с записываемым
				qdebug(tr("Ошибка 021 в DCDBData::write(), превышена заданная максимальная величина файла: ")
						+ QString::number(m_llntRazmer) + tr("байт, записываемым в БД файлом: ")
					   	+ QString::number(llntRazmerFaila) + tr("байт!"));
				blFlagZakritiya = false;
			}
			else{
				/////////////////////////////////////////////////////////
				/////О Т К Р Ы В А Е М   Ф А Й Л   Н А   Ч Т Е Н И Е/////
				////////////////////////////////////////////////////////
				QFile flFile(strPut);//Создаём объект лежащий strPut 
				if(!flFile.open(QIODevice::ReadOnly)){//Открываем файл на чтение, если не открылся, то...
					qdebug(tr("Ошибка 022 в DCDBData::write(), Ошибка открытия файла: ") + strPut);
					blFlagZakritiya = false;
				}
				else{
					///////////////////////////////////////
					/////И З М Е Н И Т Ь   Д А Н Н Ы Е/////
					///////////////////////////////////////
					QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
					char chrMassivDannih[m_untKolichestvoGraf];//Массив символов
					uint untNomerDannih(1);//Переменная, хранящ порядковый номер записываемого блока данных
					uint untRazmerBloka(0);//Переменная, хранящая размер блока данных
					int ntASCII(0);//Переменная, которая будет переводить в из char в int	
					QString strBlokDannih("");//Строчка, в которой будет собираться блок данных
					while(!flFile.atEnd()){//Если считывание данных из файла не окончилось, то...
						//считаем размер блока данных
						untRazmerBloka = flFile.read(chrMassivDannih, sizeof(chrMassivDannih));
						strBlokDannih.clear();//Очищаем переменную
						//Переводим массив символов в строчку
						for(uint untShag = 0; untShag < untRazmerBloka; untShag++){
							ntASCII = chrMassivDannih[untShag];//Перевод символа в число!
							llntCRC += ntASCII;//Считаем сумму.
							strBlokDannih += (", \"Данные_" + QString::number(untShag) + "\" = '");
							strBlokDannih += (QString::number(ntASCII) + "'");//Составляем блок с данными
						}
						if (!sqlQuery.exec("UPDATE " + m_strImyaTablici + " SET \"Размер\" = '"
								+ QString::number(untRazmerBloka) + "'" + strBlokDannih
								+ " WHERE \"Номер\" = '"+QString::number(untNomerDannih)+"';")){
							qdebug(tr("Ошибка 023 в DCDBData::write(): В базе данных: ") + m_strImyaDB
								   	+ tr(" таблицы: ") + m_strImyaTablici
									+ tr(", не смог записать блок данных в БД по причине: ")
									+ sqlQuery.lastError().text());
							blFlagZakritiya = false;//Ошибка
							break;//выходи из цикла записи данных в БД
						}
						untNomerDannih++;//Увеличиваем счетчик на +1
					}
					if(blFlagZakritiya){//Если не было ошибок при записи, то...
						/////////////////////////////////////////////////////
						/////З А П Р О С   Н У Л Е В О Й   С Т Р О Ч К И/////
						/////////////////////////////////////////////////////
						int ntASCII(0);//В этой переменной будет переводиться символы в число
						QString strImyaFaila = flnFile.baseName();//Узнаём имя файла, без разширения.
						QByteArray btrImyaFaila = strImyaFaila.toLocal8Bit();//переводим строчку в QByteArray
						int ntRazmerImeniFaila = btrImyaFaila.size();//Узнаём размер имени файла
						QString strSuffix = flnFile.completeSuffix();//Узнаём Полное разширение файла
						QByteArray btrSuffix = strSuffix.toLocal8Bit();//переводим строчку в QByteArray
						int ntRazmerSuffixa = btrSuffix.size();//Узнаём размер суффикса
						QString strZapros = " \"Данные_7\" = '"+QString::number(ntRazmerImeniFaila)+"',"
							+ " \"Данные_8\" = '"+QString::number(ntRazmerSuffixa)+"',";
						for(int ntShag = 0; ntShag < ntRazmerImeniFaila; ntShag++){
							ntASCII = btrImyaFaila[ntShag];//Сторчка преобразования символа в число
							strZapros += (" \"Данные_" + QString::number(ntShag+9) + "\" = '"
									+ QString::number(ntASCII) + "',");
						}
						for (int ntShag = 0; ntShag < ntRazmerSuffixa; ntShag++){
							ntASCII = btrSuffix[ntShag];//строчка преобразования символа в число
							strZapros += (" \"Данные_"+QString::number(ntShag+9+ntRazmerImeniFaila)+"\" = '"
								+ QString::number(ntASCII))+"'";//Собираем запрос на расширение файла
							if(!(ntShag == (ntRazmerSuffixa-1)))//Проверка на установку запятой
								strZapros += ",";//Ставим запятую в запросе
						}
						//Подгатавливаем запрос для БД на обновление нулевой строчки
						sqlQuery.prepare("UPDATE " + m_strImyaTablici
								+ " SET \"Размер\" = '"+QString::number(untNomerDannih-1)+"', "
								+ " \"Данные_0\" = '"+QString::number(QDate::currentDate().year())+"', "
								+ " \"Данные_1\" = '"+QString::number(QDate::currentDate().month())+"', "
								+ " \"Данные_2\" = '"+QString::number(QDate::currentDate().day())+"', "
								+ " \"Данные_3\" = '"+QString::number(QTime::currentTime().hour())+"', "
								+ " \"Данные_4\" = '"+QString::number(QTime::currentTime().minute())+"', "
								+ " \"Данные_5\" = '"+QString::number(QTime::currentTime().second())+"', "
								+ " \"Данные_6\" = '"+QString::number(llntCRC)+"', "
								+ strZapros + " WHERE \"Номер\" = '0';");
						if (!sqlQuery.exec()){//Если запрос к БД не запустился, то...
							qdebug(tr("Ошибка 024 в DCDBData::write(): В базе данных: ") + m_strImyaDB
								   	+ tr(" таблицы: ") + m_strImyaTablici
								   	+ tr(", не смог записать нулевой блок данных по причине: ")
									+ sqlQuery.lastError().text());
							blFlagZakritiya = false;//Ошибка
						}
					}
				}
				flFile.close();//Закрываем файл на чтение
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataWrite%1").arg(untWrite));//Закрываем открытую БД
	return blFlagZakritiya;//Возвращаем состояние! 
}

bool DCDBData::read(QString strPut){//Метод чтения файла из базы данных и запись его в Файл.
/////////////////
//---R E A D---//
/////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 035 в DCDBData::read(QString): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untRead(0);
	qint64 llntCRC(0);//Контрольная сумма.
	qint64 llntCRCDB(0);//Контрольная сумма считанная из БД.
	QFile flFile(strPut);//Создаём объект лежащий в strPut 
	if(flFile.exists())//Если файла в папке есть, то...
		flFile.remove();//Удаляем файл для перезаписи его.
	if(!flFile.open(QIODevice::WriteOnly)){//Открываем файл на запись, если не открылся, то...
		qdebug(tr("Ошибка 031 в DCDBData::read(), Ошибка открытия файла: ") + strPut 
				+ tr(" для записи в него данных из БД."));
		blFlagZakritiya = false;//Ошибка
 	}
	else{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbdataRead%1").arg(++untRead));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 030 в DCDBData::read(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagZakritiya = false;//Ошибка открытия базы данных
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			/////////////////////////////////////////////////////////////
			/////С Ч И Т Ы В А Е М   К О Л И Ч Е С Т В О   С Т Р О К/////
			/////////////////////////////////////////////////////////////
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			uint untKolichestvoStrok(0);//Количество строк данных Файла
			if(sqlQuery.exec("SELECT * FROM "+m_strImyaTablici+" WHERE \"Номер\" = '0';")){//запущен, то...
				while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
					untKolichestvoStrok = sqlQuery.value(1).toInt();//Считаваем количество строк из БД
					llntCRCDB = sqlQuery.value(8).toInt();//Считаваем контрольную сумму из БД
					break;//выходим из цикла
				}
			}
			else{
				qdebug(tr("Ошибка 032 в DCDBData::read(): В базе данных: ")+m_strImyaDB+tr(", в таблице: ")
						+ m_strImyaTablici + tr(" по причине: ") + sqlQuery.lastError().text());
				blFlagZakritiya = false;//Ошибка!
			}
			if(blFlagZakritiya){//Если не было ошибки, то...
				/////////////////////////////////////////////////////
				/////С Ч И Т Ы В А Е М   Д А Н Н Ы Е   Ф А Й Л А/////
				/////////////////////////////////////////////////////			
				char chrMassivDannih[m_untKolichestvoGraf];//Накопительный Массив символов
				uint untRazmerBloka(0);//Размер блока данных, прочитаный из БД
				int ntASCII(0);//В этой переменной будет хранится число, переводимое в символ.
				for(uint untShagStroki = 1; untShagStroki <= untKolichestvoStrok; untShagStroki++){
					if(sqlQuery.exec("SELECT * FROM " + m_strImyaTablici
							+ " WHERE \"Номер\" = '"+QString::number(untShagStroki)+"';")){//запущен, то...
						while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
							untRazmerBloka= sqlQuery.value(1).toInt();//Считываем Размер блока данных из БД
							for(uint untShagGraf = 0; untShagGraf < untRazmerBloka; untShagGraf++){
								//Основная строчка преобразования из числа в символ и запись в массив символов
								ntASCII = sqlQuery.value(untShagGraf+2).toInt();//Считываем число из БД.
								chrMassivDannih[untShagGraf] = ntASCII;//Переводим число в символ.
								llntCRC += ntASCII;//Считаем контрольную сумму.
							}
   							flFile.write(chrMassivDannih, untRazmerBloka);//Записываем блок данных в файл.
							break;//выходим из цикла
						}
					}
					else{//В противном случае
						qdebug(tr("Ошибка 033 в DCDBData::read(): В базе данных: ")
								+ m_strImyaDB + tr(", в таблице: ")
								+ m_strImyaTablici + tr(" по причине: ") + sqlQuery.lastError().text());
						blFlagZakritiya = false;
						break;
					}
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataRead%1").arg(untRead));//Закрываем открытую БД
	flFile.close();//Закрываем файл на запись
	if(llntCRC != llntCRCDB){//Если контрольная сумма считанная и заданная не равны, то...
		if(flFile.exists())//Если файла в папке есть, то...
			flFile.remove();//Удаляем файл из-за не совпадения контрольной суммы. 
		qdebug(tr("Ошибка 034 в DCDBData::read(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
				+ m_strImyaTablici + tr(" по причине не совпедения контрольной суммы файла!"));
		blFlagZakritiya = false;//Ошибка.
	}
	return blFlagZakritiya;//Возвращаем состояние!
}

QDateTime DCDBData::lastModified(){//Возвращает данные по дате и времени записи файла в БД.
///////////////////////////////////
//---L A S T   M O D I F I E D---//
///////////////////////////////////
	static uint untModified(0);
	QDate odata(0, 0, 0);//Создаём объект даты
	QTime otime(0, 0, 0);//Создаём объект времени
	QDateTime odatetime(odata, otime);//Создаём объект даты и времени
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 042 в DCDBData::lastModified(): Имя драйвера SQL не указано."));
		return odatetime;//Возвращаем нулевое время и дату.
	}
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver,
				QString("dbdataModified%1").arg(++untModified));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 040 в DCDBData::lastModified(): База данных ") +m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			return odatetime;
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			/////////////////////////////////////////////////////////////////
			/////П О Л У Ч А Е М   И Н Ф О Р М А Ц И Ю   П О   Ф А Й Л У/////
			/////////////////////////////////////////////////////////////////
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			if(sqlQuery.exec("SELECT * FROM "+m_strImyaTablici+" WHERE \"Номер\" = '0';")){//Если запущен, то
				while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
					odata.setDate(	sqlQuery.value(2).toInt(),
									sqlQuery.value(3).toInt(),
									sqlQuery.value(4).toInt());//Считываем дату
					otime.setHMS(	sqlQuery.value(5).toInt(),
									sqlQuery.value(6).toInt(),
									sqlQuery.value(7).toInt());//Считываем время
				}
			}
			else{
				qdebug(tr("Ошибка 041 в DCDBData::lastModified(): В базе данных: ") + m_strImyaDB 
						+ tr(", в таблице: ") + m_strImyaTablici
						+ tr(" по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataModified%1").arg(untModified));//Закрываем открытую БД
	odatetime.setDate(odata);//Присваеваем считанную дату.
	odatetime.setTime(otime);//Присваеваем считанное время.
	return odatetime;
}

QString DCDBData::baseName(){//Возвращает имя записаного файла в БД.
///////////////////////////
//---B A S E   N A M E---//
///////////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 052 в DCDBData::baseName(): Имя драйвера SQL не указано."));
		return "";//Возвращаем ошибку.
	}
	QByteArray btrImyaFaila;//Создаю байтовый массив, в котором будет хранится имя фаила
	static uint untBase(0);
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbdataBase%1").arg(++untBase));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 050 в DCDBData::baseName(): База данных: ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			///////////////////////////////////////////////////////////
			/////С Ч И Т Ы В А Е М   Н У Л Е В У Ю   С Т Р О Ч К У/////
			///////////////////////////////////////////////////////////
			char chrSimvolImeniFaila;//Символ имени фаила 
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			if(sqlQuery.exec("SELECT * FROM "+m_strImyaTablici+" WHERE \"Номер\" = '0'")){//Если запущен, то..
				while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
					for(int ntShag = 0; ntShag < sqlQuery.value(9).toInt(); ntShag++){
						chrSimvolImeniFaila = sqlQuery.value(ntShag+11).toInt();
						btrImyaFaila.append(chrSimvolImeniFaila);//Добавляем байты в массив с именем фаила
					}
					break;//выходим из цикла
				}
			}
			else{
				qdebug(tr("Ошибка 051 в DCDBData::baseName() В базе данных: ")+m_strImyaDB+tr(", в таблице: ")
						+ m_strImyaTablici + tr(" по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataBase%1").arg(untBase));//Закрываем открытую БД
	QString strImyaFaila(btrImyaFaila);//Строчка, содержащая Имя файла.
	return strImyaFaila;
}

QString	DCDBData::suffix(){//Возвращаем расшинение записанного файла в БД.
/////////////////////
//---S U F F I X---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 062 в DCDBData::suffix(): Имя драйвера SQL не указано."));
		return "";//Возвращаем ошибку.
	}
	QByteArray btrSuffix("");//Массив байтов, в котором будет хранится разширение файла
	static uint untSuffix(0);
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbdataSuffix%1").arg(++untSuffix));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 060 в DCDBData::suffix(): База данных: ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
		}
		else{//В противном случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			///////////////////////////////////////////////////////////
			/////С Ч И Т Ы В А Е М   Н У Л Е В У Ю   С Т Р О Ч К У/////
			///////////////////////////////////////////////////////////
			char chrSimvolSuffixa;//Символ расширения расширении.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			//Подгатавливаем запрос для БД
			if(sqlQuery.exec("SELECT * FROM "+m_strImyaTablici+" WHERE \"Номер\" = '0'")){//Если запущен, то..
				while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
					int ntRazmerImeniFaila = sqlQuery.value(9).toInt();
					for(int ntShag = 0; ntShag < sqlQuery.value(10).toInt(); ntShag++){
						chrSimvolSuffixa = sqlQuery.value(ntShag+11+ntRazmerImeniFaila).toInt();
						btrSuffix.append(chrSimvolSuffixa);
					}
					break;//выходим из цикла
				}
			}
			else{
				qdebug(tr("Ошибка 061 в DCDBData::suffix(): В базе данных: ")+m_strImyaDB+tr(", в таблице: ")
						+ m_strImyaTablici + tr(" по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbdataSuffix%1").arg(untSuffix));//Закрываем открытую БД
	QString strSuffix(btrSuffix);//Строчка, содержащая расшерение.
	return strSuffix;
}
void DCDBData::ustDriverDB(QString strDriver){//Установить драйвер БД.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   И М Я   Д Р А Й В Е Р А---//
///////////////////////////////////////////////////////
	static QString sstrDriver;//Статическая переменная запоминающая имя драйвера.
	if((strDriver == "QSQLITE")||(strDriver == "QPSQL")){//Если имя драйвера совпадает, то...
		if(sstrDriver.isEmpty())//Если статическая переменная пустая, то...
			sstrDriver = strDriver;//Инициализируем статическую переменную единственно правильным значением.
		if(sstrDriver !=strDriver)//Если значение не равно статическому, то это попытка изменить Драйвер QSL.
			qdebug(tr("Ошибка 091 в DCDBData::ustDriverDB(): Нельзя повторно менять драйвер SQL."));//Ошибка.
		else//Если равны значения, значит это первичная иннициализация драйвера SQL.
			m_strDriver = strDriver;//Присваиваем заданное значение.
	}
	else{//Если не совпадает, то...
		qdebug(tr("Ошибка 090 в DCDBData::ustDriverDB(): Заданное имя драйвера SQL неизвестно."));//Конструк
		if(sstrDriver.isEmpty())//Если статическая переменная пустая, то...
			m_strDriver = "";//Это значит впервые задаём имя Драйвера и оно не верное, поэтому "".
	}
}
