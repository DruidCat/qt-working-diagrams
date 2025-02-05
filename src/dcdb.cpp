#include "dcdb.h"

DCDB::DCDB(const QString strDriver, const QString strImyaDB, QString strImyaTablici, QObject* proditel)
    : QObject(proditel){
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
	ustDriverDB(strDriver);//Проверяем имя драйвера.
	ustImyaDB(strImyaDB);//Проверяем имя БД.
	m_strImyaTablici = strImyaTablici;//
	m_strHostName = "127.0.0.1";//Поумолчанию локальное расположение сервера с БД PostgreSQL
	m_untPort = 5432;//Порт поумолчанию в PostgreSQL
	m_strUserName = "postgres";//Пользователь по умолчанию в созданной БД PostgreSQL.
	m_strPassword.clear();//Поумолчанию нет пароля.
	m_slsGrafi.clear();//количество граф.
	m_strPrimaryKey.clear();//
	/////коды/////
	m_ntKodKolichestvo = 0;//
	m_strKodImyaTablic.clear();//
}
DCDB::DCDB(const QString strDriver, const QString strImyaDB, QObject* proditel)
    : QObject(proditel){
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
	ustDriverDB(strDriver);//Проверяем имя драйвера.
	ustImyaDB(strImyaDB);//Проверяем имя БД.
	m_strImyaTablici = "";//
	m_strHostName = "127.0.0.1";//Поумолчанию локальное расположение сервера с БД PostgreSQL
	m_untPort = 5432;//Порт поумолчанию в PostgreSQL
	m_strUserName = "postgres";//Пользователь по умолчанию в созданной БД PostgreSQL.
	m_strPassword.clear();//Поумолчанию нет пароля.
	m_slsGrafi.clear();//
	m_ntKolGraf = 0;//количество граф.
	m_strPrimaryKey.clear();//
	/////коды/////
	m_ntKodKolichestvo = 0;//
	m_strKodImyaTablic.clear();//
}
DCDB::DCDB(QObject* proditel) : QObject(proditel){//Конструктор для QVector, без параметров.
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////
	m_strDriver = "";//Имя SQL драйвера. Необходимо определить методом.
	m_strImyaDB = "";//Имя базы данных. Необходимо определить методом.
	m_strImyaTablici = "";//Имя таблицы в БД.
	m_strHostName = "127.0.0.1";//Поумолчанию локальное расположение сервера с БД PostgreSQL
	m_untPort = 5432;//Порт поумолчанию в PostgreSQL
	m_strUserName = "postgres";//Пользователь по умолчанию в созданной БД PostgreSQL.
	m_strPassword.clear();//Поумолчанию нет пароля.
	m_slsGrafi.clear();//
	m_ntKolGraf = 0;//количество граф.
	m_strPrimaryKey.clear();//
	/////коды/////
	m_ntKodKolichestvo = 0;//
	m_strKodImyaTablic.clear();//
}
bool DCDB::checkStatus(){//Открыть и закрыть Базу данных, для того чтобы проверить статус сети. 
/////////////////////////////////////////
//---П Р О В Е Р И Т Ь   С Т А Т У С---//
/////////////////////////////////////////
	bool blFlagOshibki(true);//Успех функции
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 001 в DCDB::checkStatus(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 002 в DCDB::checkStatus(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	static uint untCheckStatus(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver,
				QString("dbCheckStatus%1").arg(++untCheckStatus));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 000 в DCDB::checkStatus(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagOshibki = false;//Ошибка.
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
		else//если БД открылась, то...
			emit signalSqlSoedinenie(true);//сигнал о том, что БД открылась.
	}
	QSqlDatabase::removeDatabase(QString("dbCheckStatus%1").arg(untCheckStatus));//Закрываем открытую БД
	return blFlagOshibki;
}
bool DCDB::CREATE(QStringList slsGrafi){//Создать таблицу.
///////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У---//
///////////////////////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 015 в DCDB::CREATE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 016 в DCDB::CREATE(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	//Важен порядок if, для того, чтоб работала конструкция CREATE(QStringList());
	if(!slsGrafi.isEmpty()){//Если не пустой списток, то...
		m_slsGrafi = slsGrafi;//Графы в таблице.
		m_ntKolGraf = slsGrafi.size();//Количество граф.
	}
	if(m_slsGrafi.isEmpty()){//Если пустые графы, то...
		qdebug(tr("Ошибка 014 в DCDB::CREATE(): В Базе данных ")+m_strImyaDB+tr(" не заданы графы таблицы."));
		return false;//Ошибка.
	}
	if(m_strImyaTablici.isEmpty()){//Если имя таблицы пустое место, то...
		qdebug(tr("Ошибка 012 в DCDB::CREATE(): В Базе данных ")+m_strImyaDB+tr(" имя таблицы не заданно."));
		return false;//Ошибка.
	}
	QString strPervayaGrafa(m_slsGrafi[0]);//Строка именно тут, для того чтоб не вызвать CREATE() постоянно.
	if(strPervayaGrafa[0] == '#')//Если первый символ #(ПЕРВИЧНЫЙ КЛЮЧ), то...
		m_strPrimaryKey = strPervayaGrafa.remove(0, 1);//Удаляем первый символ # и присваиваем
	bool blFlagOshibki(true);//Успех функции
	static uint untCREATE(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbCREATE%1").arg(++untCREATE));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 010 в DCDB::CREATE(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagOshibki = false;//Ошибка.
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			///////////////////////////////////////////
			/////П Р О В Е Р И Т Ь   Т А Б Л И Ц У/////
			///////////////////////////////////////////
			if(!sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\";")){//Если нет ТАБЛИЦЫ с заданным именем
				QHash<QString,int> hshGrafi;//Хэшь, в котором будут храниться одинаковые графы
				foreach (const QString & pstrGrafi, m_slsGrafi)//Перебираем все графы из списка
					hshGrafi[pstrGrafi]++;//Подсчет одинаковых столбиков
				QHash<QString, int>::iterator it = hshGrafi.begin();//Создаём итератор хеша столбиков
				for (;it != hshGrafi.end(); ++it){//Перечисление столбиков в хеше
					if (it.value() > 1){//Если итератор в хеше больше одного, то...
						qdebug(tr("Ошибка 011 в DCDB::CREATE(): В базе данных ") + m_strImyaDB
								+ tr(" при создании таблицы: ") +  m_strImyaTablici + tr(", заданно ")
								+ QString::number(it.value()) + tr(" графы: ") + it.key() + "!");
						blFlagOshibki = false;//Ошибка, заданны одинаковые Графы
					}
				}
				if(blFlagOshibki){//Если нет одинаковых графф, то...
					QString strSqlGrafi("");//Переменная, которая будет хранить строчку запрос sql
					QString strSqlPK("");//Переменная будет хранить запрос на первичный ключ, если он есть.
					//Цикл создания строчки запроса на создание столбиков в таблице
					for(int ntStep = 0; ntStep < m_slsGrafi.size(); ntStep++){
			    		if(ntStep)//Если это не нулевой элемент, то...
			    			strSqlGrafi += ", \""+m_slsGrafi[ntStep]+"\" VARCHAR";//Добавляем запрос 
						else{//Если это нулевой элемент, т.е. первый, то...
							QString strSqlType(" VARCHAR");//Переменная хранящая тип переменных в БД 
							if(!m_strPrimaryKey.isEmpty()){//Если Первичный ключь не пустая строчка, то...
								if(m_strDriver == "QPSQL"){//Если это PostgreSQL, то...
									strSqlType = " SERIAL";//Присваиваем переменной данный тип
									strSqlPK=", PRIMARY KEY(\""+m_strPrimaryKey+"\")";//Запрос на Первич. Ключ
								}
								else{//В противном случае...
									strSqlType = " INTEGER PRIMARY KEY";//Присваиваем переменной данный тип
								}
							}
							strSqlGrafi = strPervayaGrafa + strSqlType;//Добавляем запрос
						}
					}
					if(blFlagOshibki){//Если не было ошибки, то...
						strSqlGrafi += strSqlPK;//Добавляем запрос на первичный ключ, если он есть.
						///////////////////////////////////////
						/////С О З Д А Т Ь   Т А Б Л И Ц У/////
						///////////////////////////////////////
						if(!sqlQuery.exec("CREATE TABLE \""+m_strImyaTablici+"\" (" + strSqlGrafi + ");")){
							qdebug(tr("Ошибка в 013 DCDB::CREATE(): В базе данных: ") + m_strImyaDB
									+ tr(" не смог создать таблицу: ") + m_strImyaTablici 
									+ tr(" по причине: ") + sqlQuery.lastError().text());
							blFlagOshibki = false;//Ошибка
			    		}
					}
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbCREATE%1").arg(untCREATE));//Закрываем открытую БД
	return blFlagOshibki;
}
bool DCDB::CREATE(){//Создать таблицу, при условии что был передан список Граф в CREATE(QStringList).
///////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У---//
///////////////////////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 165 в DCDB::CREATE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 166 в DCDB::CREATE(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	if(m_slsGrafi.isEmpty()){//Если пустые графы, то...
		qdebug(tr("Ошибка 164 в DCDB::CREATE(): В Базе данных ")+m_strImyaDB+tr(" не заданы графы таблицы."));
		return false;//Ошибка.
	}
	if(m_strImyaTablici.isEmpty()){//Если имя таблицы пустое место, то...
		qdebug(tr("Ошибка 162 в DCDB::CREATE(): В Базе данных ")+m_strImyaDB+tr(" имя таблицы не заданно."));
		return false;//Ошибка.
	}
	QString strPervayaGrafa(m_slsGrafi[0]);//Строка именно тут.
	if(strPervayaGrafa[0] == '#')//Если первый символ #(ПЕРВИЧНЫЙ КЛЮЧ), то...
		m_strPrimaryKey = strPervayaGrafa.remove(0, 1);//Удаляем первый символ # и присваиваем
	bool blFlagOshibki(true);//Успех функции
	static uint untCREATE(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbCREATE%1").arg(++untCREATE));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 160 в DCDB::CREATE(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagOshibki = false;//Ошибка.
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			///////////////////////////////////////////
			/////П Р О В Е Р И Т Ь   Т А Б Л И Ц У/////
			///////////////////////////////////////////
			if(!sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\";")){//Если нет ТАБЛИЦЫ с заданным именем
				QHash<QString,int> hshGrafi;//Хэшь, в котором будут храниться одинаковые графы
				foreach (const QString & pstrGrafi, m_slsGrafi)//Перебираем все графы из списка
					hshGrafi[pstrGrafi]++;//Подсчет одинаковых столбиков
				QHash<QString, int>::iterator it = hshGrafi.begin();//Создаём итератор хеша столбиков
				for (;it != hshGrafi.end(); ++it){//Перечисление столбиков в хеше
					if (it.value() > 1){//Если итератор в хеше больше одного, то...
						qdebug(tr("Ошибка 161 в DCDB::CREATE(): В базе данных ") + m_strImyaDB
								+ tr(" при создании таблицы: ") +  m_strImyaTablici + tr(", заданно ")
								+ QString::number(it.value()) + tr(" графы: ") + it.key() + "!");
						blFlagOshibki = false;//Ошибка, заданны одинаковые Графы
					}
				}
				if(blFlagOshibki){//Если нет одинаковых графф, то...
					QString strSqlGrafi("");//Переменная, которая будет хранить строчку запрос sql
					QString strSqlPK("");//Переменная будет хранить запрос на первичный ключ, если он есть.
					//Цикл создания строчки запроса на создание столбиков в таблице
					for(int ntStep = 0; ntStep < m_slsGrafi.size(); ntStep++){
			    		if(ntStep)//Если это не нулевой элемент, то...
			    			strSqlGrafi += ", \""+m_slsGrafi[ntStep]+"\" VARCHAR";//Добавляем запрос 
						else{//Если это нулевой элемент, т.е. первый, то...
							QString strSqlType(" VARCHAR");//Переменная хранящая тип переменных в БД 
							if(!m_strPrimaryKey.isEmpty()){//Если Первичный ключь не пустая строчка, то...
								if(m_strDriver == "QPSQL"){//Если это PostgreSQL, то...
									strSqlType = " SERIAL";//Присваиваем переменной данный тип
									strSqlPK=", PRIMARY KEY(\""+m_strPrimaryKey+"\")";//Запрос на Первич. Ключ
								}
								else{//В противном случае...
									strSqlType = " INTEGER PRIMARY KEY";//Присваиваем переменной данный тип
								}
							}
							strSqlGrafi = strPervayaGrafa + strSqlType;//Добавляем запрос
						}
					}
					if(blFlagOshibki){//Если не было ошибки, то...
						strSqlGrafi += strSqlPK;//Добавляем запрос на первичный ключ, если он есть.
						///////////////////////////////////////
						/////С О З Д А Т Ь   Т А Б Л И Ц У/////
						///////////////////////////////////////
						if(!sqlQuery.exec("CREATE TABLE \""+m_strImyaTablici+"\" (" + strSqlGrafi + ");")){
							qdebug(tr("Ошибка в 163 DCDB::CREATE(): В базе данных: ") + m_strImyaDB
									+ tr(" не смог создать таблицу: ") + m_strImyaTablici 
									+ tr(" по причине: ") + sqlQuery.lastError().text());
							blFlagOshibki = false;//Ошибка
			    		}
					}
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbCREATE%1").arg(untCREATE));//Закрываем открытую БД
	return blFlagOshibki;
}
bool DCDB::DROP(){//Метод удаляющий таблицу в БД.
/////////////////
//---D R O P---//
/////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 122 в DCDB::DROP(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 123 в DCDB::DROP(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untDrop(0);
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbDROP%1").arg(++untDrop));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			signalSqlSoedinenie(false);//Сигнал соединения к postrgesql серверу.
			qdebug(tr("Ошибка 120 в DCDB::DROP(): База данных ") + m_strImyaDB
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagZakritiya = false;//Ошибка открытия базы данных
		}
        else{//В ином случае...
			signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\";")){//Если есть ТАБЛИЦА с заданным именем
				///////////////////////////////////////////////////
				/////У Д А Л Я Е М   Т А Б Л И Ц У   И З   Б Д/////
				///////////////////////////////////////////////////
				if(!sqlQuery.exec("DROP TABLE "+m_strImyaTablici+";")){//Если не запустилось удаление таблицы
					qdebug(tr("Ошибка 121 в DCDB::DROP(): В базе данных: ")+m_strImyaDB+tr(", в таблице: ")
							+ m_strImyaTablici + tr(" по причине: ") + sqlQuery.lastError().text());
					blFlagZakritiya = false;//Ошибка!
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbDROP%1").arg(untDrop));//Закрываем открытую БД
	return blFlagZakritiya;//Возвращаем состояние!
}
bool DCDB::INSERT(QStringList slsGrafi, QStringList slsKolonki){//Вставить данные
/////////////////////
//---I N S E R T---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
        qdebug(tr("Ошибка 024 в DCDB::INSERT(): Имя драйвера SQL не указано."));
        qDebug()<<tr("Ошибка 024 в DCDB::INSERT(): Имя драйвера SQL не указано.");
        return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
            qdebug(tr("Ошибка 025 в DCDB::INSERT(): Имя базы данных SQL не указано."));
            qDebug()<<tr("Ошибка 025 в DCDB::INSERT(): Имя базы данных SQL не указано.");
            return false;//Возвращаем ошибку.
		}
	}
	bool blFlagZakritiya(true);//Флаг ошибки
	static uint untINSERT(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbINSERT%1").arg(++untINSERT));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 020 в DCDB::INSERT(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
            qDebug()<<tr("Ошибка 020 в DCDB::INSERT(): База данных ") + m_strImyaDB
                    + tr(" не открылась по причине: ") + sqlDB.lastError().text();

			blFlagZakritiya = false;
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			uint untGrafi = slsGrafi.size();//Считаем количество граф
			uint untKolonki = slsKolonki.size();//Считаем колличество значений Колонок
			QString	strSqlGrafi("");//Строчка в которой соберется запрос по Графам
			QString	strSqlKolonki("");//В строчке в соберется запрос по Данным колонок
			if (untGrafi != untKolonki){//Если нет равенства граф таблиц и их значений, то...
                qdebug(tr("Ошибка 021 в DCDB::INSERT(): В базе данных ")+m_strImyaDB+tr(" с именем таблици: ")
                        +m_strImyaTablici+tr(" задано разное колличество Граф: ")+QString::number(untGrafi)
                        +tr(" и Колонок: ")+QString::number(untKolonki)+"!");
                qDebug()<<tr("Ошибка 021 в DCDB::INSERT(): В базе данных ")+m_strImyaDB+tr(" с именем таблици: ")
                        +m_strImyaTablici+tr(" задано разное колличество Граф: ")+QString::number(untGrafi)
                        +tr(" и Колонок: ")+QString::number(untKolonki)+"!";
				blFlagZakritiya = false;//Ошибка
			}
			else{
				//Цикл создания строчки запроса на создание граф в таблице
				for(uint untStep = 0; untStep < untGrafi; untStep++){
			    	if(untStep){//Если это не нулевой элемент, то...
			    		strSqlGrafi += ", ";
			    		strSqlKolonki += ", ";
			    	}
                    strSqlGrafi +="\"" + slsGrafi[untStep] + "\"";//Добавляем имя граф
                    strSqlKolonki += ("'" + slsKolonki[untStep] + "'");//Добавм значения колонок
				}
			}
			///////////////////////////////////////
			/////В С Т А В И Т Ь   Д А Н Н Ы Е/////
			///////////////////////////////////////
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			//Подгатавливаем запрос для БД
		    if (!sqlQuery.exec("INSERT INTO \""+m_strImyaTablici+"\" (" + strSqlGrafi + ") VALUES("
					+ strSqlKolonki + ");")){//Если подготовленный запрос к БД не запустился, то...
		        qdebug(tr("Ошибка 023 в DCDB::INSERT(): В базе данных: ") + m_strImyaDB
						+ tr(" не смог вставить данные: ") + strSqlKolonki + tr(", в таблицу: ")
						+ m_strImyaTablici + " по причине: " + sqlQuery.lastError().text() +"!");
                qDebug()<<tr("Ошибка 023 в DCDB::INSERT(): В базе данных: ") + m_strImyaDB
                        + tr(" не смог вставить данные: ") + strSqlKolonki + tr(", в таблицу: ")
                        + m_strImyaTablici + " по причине: " + sqlQuery.lastError().text() +"!";
		        blFlagZakritiya = false;//Ошибка
		    }
		}
	}
	QSqlDatabase::removeDatabase(QString("dbINSERT%1").arg(untINSERT));//Закрываем открытую БД
	return blFlagZakritiya;
}
bool DCDB::UPDATE(QStringList slsGrafi, QStringList slsKolonki){//Обновить данные
/////////////////////
//---U P D A T E---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 034 в DCDB::UPDATE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 035 в DCDB::UPDATE(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untUPDATE_1(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbUPDATE_1%1").arg(++untUPDATE_1));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 030 в DCDB::UPDATE(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			blFlagZakritiya = false;//Ошибка
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			uint untGrafi = slsGrafi.size();//Считаем количество граф
			uint untKolonki = slsKolonki.size();//Считаем колличество значений Колонок
			if((untKolonki < 2) || (untGrafi < 2)){
		        qdebug(tr("Ошибка 031 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
						+ tr(", при обновлении данных в таблице: ") + m_strImyaTablici
						+ tr(" количество граф: ") + QString::number(untGrafi)
						+ tr(" или колонок: ") + QString::number(untKolonki) + tr(" меньше двух!"));
				blFlagZakritiya = false;//Ошибка
			}
			else{
				if(!(untGrafi == untKolonki)){//Если количество граф не равно количеству колонок, то...
			        qdebug(tr("Ошибка 032 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
							+ tr(", при обновлении данных в таблице: ") + m_strImyaTablici
							+ tr(" количество граф: ") + QString::number(untGrafi)
							+ tr(" не равно колличеству колонок: ") + QString::number(untKolonki));
					blFlagZakritiya = false;//Ошибка
				}
				else{
					//Цикл создания строчки запроса на обновление данных в таблице
					QString strSqlUpdate = "";//будет хранится запрос на обновление
					for(uint untStep = 1; untStep < untGrafi; untStep++){
		    			if(!(untStep == 1))//Если это не первый элемент, то...
		    				strSqlUpdate += ", ";
                        strSqlUpdate += "\""	+ slsGrafi[untStep] + "\" = '"
                                                + slsKolonki[untStep] + "'";//Запрос
					}
					///////////////////////////////////////
					/////О Б Н О В И Т Ь   Д А Н Н Ы Е/////
					///////////////////////////////////////
					QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
					if (!sqlQuery.exec("UPDATE \"" + m_strImyaTablici + "\" SET " + strSqlUpdate +
                               " WHERE \"" + slsGrafi[0] + "\" = '" + slsKolonki[0] + "';")){//не запустился
						qdebug(tr("Ошибка 033 в DCDB::UPDATE(): В базе данных: ")
								+ m_strImyaDB + tr(" таблицы: ") + m_strImyaTablici
								+ tr(", не смог записать данные: ") + strSqlUpdate
							   	+ tr(" в базу данных по причине: ") + sqlQuery.lastError().text());
						blFlagZakritiya = false;//Ошибка
					}
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbUPDATE_1%1").arg(untUPDATE_1));//Закрываем открытую БД
	return blFlagZakritiya;
}
bool DCDB::UPDATE(QString strGrafa, QStringList slsKolonki){//Переименовать данные
/////////////////////
//---U P D A T E---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 045 в DCDB::UPDATE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 046 в DCDB::UPDATE(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untUPDATE_2(0);//Счётчик запросов на открытие и закрытие базы данных
	if(m_strPrimaryKey.isEmpty()){//Если первичный ключ отсутствует, то...
        qdebug(tr("Ошибка 041 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
				+ tr(", при переименовании данных в таблице: ") + m_strImyaTablici
				+ tr(" отсутствует Первичный Ключ!"));
        blFlagZakritiya = false;//Ошибка
	}
    else{//В ином случае...
        QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbUPDATE_2%1").arg(++untUPDATE_2));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 040 в DCDB::UPDATE(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
    		blFlagZakritiya = false;//Ошибка
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			uint untKolonki = slsKolonki.size();//Считаем колличество значений Колонок
			if(untKolonki != 2){//Если колонок не две, то ...
		        qdebug(tr("Ошибка 042 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
						+ tr(", при переименовании данных в таблице: ") + m_strImyaTablici
						+ tr(" количество колонок: ") + QString::number(untKolonki) + tr(" не равно двум!"));
		        blFlagZakritiya = false;//Ошибка
			}
            else{//в ином случае...
				/////////////////////////////////////////////////
				/////П Е Р Е И М Е Н О В А Т Ь   Д А Н Н Ы Е/////
				/////////////////////////////////////////////////
                QSqlQueryModel* pqrmModel = new QSqlQueryModel(this);
	    		pqrmModel->setQuery(QSqlQuery(("SELECT * FROM \""+ m_strImyaTablici + "\" WHERE \""
						+ strGrafa + "\" = '" +slsKolonki[0]+ "';"), sqlDB));
 				if(pqrmModel->lastError().isValid()){//Если есть ошибка в запросе, то...
					qdebug(tr("Ошибка 044 в DCDB::UPDATE(): В базе данных: ")+m_strImyaDB+tr(", в таблице: ")
                            + m_strImyaTablici + tr(" ошибка по причине: ") + pqrmModel->lastError().text());
					blFlagZakritiya = false;//Ошибка
				}
                else{//в ином случае...
                    QString strPKey("");//Хранит значение Primary Key
					QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
                    if(!pqrmModel->rowCount()){//Если счётчик 0, то это ошибка запроса
                        qdebug(tr("Ошибка 047 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
                               + tr(", в таблице: ") + m_strImyaTablici
                               + tr(" ошибка неверного запроса: ") + pqrmModel->query().lastQuery());
                        blFlagZakritiya = false;//Ошибка
                    }
                    else{//в ином случае...
                        for(int ntShag = 0; ntShag < pqrmModel->rowCount(); ntShag++){//Цикл
                            strPKey = pqrmModel->record(ntShag).value(m_strPrimaryKey).toString();
                            //если запрос не запустился, то...
                            if (!sqlQuery.exec("UPDATE \""+m_strImyaTablici+"\" SET \""+strGrafa+"\" = '"
                                    + slsKolonki[1]+"' WHERE \""+m_strPrimaryKey+"\" = '"+strPKey+"';")){
                                qdebug(tr("Ошибка 043 в DCDB::UPDATE(): В базе данных: ")
                                        + m_strImyaDB + tr(" таблицы: ") + m_strImyaTablici
                                        + tr(", не смог переименовать данные c ")
                                        + slsKolonki[0] + tr(" на ") + slsKolonki[1]
                                        + tr(" в графе ") + strGrafa + tr(" по причине: ")
                                        + sqlQuery.lastError().text());
                                blFlagZakritiya = false;//Ошибка
                            }
                        }
                    }
    			}
				delete pqrmModel;//Обязательно удалить указатель, иначе утечка памяти будет.
				pqrmModel = nullptr;//Обнуляем указатель.
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbUPDATE_2%1").arg(untUPDATE_2));//Закрываем открытую БД
	return blFlagZakritiya;
}

bool DCDB::UPDATE(QString strGrafa, QString strGrafaParametri, QStringList slsKolonki){//Переименовать данны
/////////////////////
//---U P D A T E---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 117 в DCDB::UPDATE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 118 в DCDB::UPDATE(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untUPDATE_3(0);//Счётчик запросов на открытие и закрытие базы данных
	if(m_strPrimaryKey.isEmpty()){//Если первичный ключ отсутствует, то...
        qdebug(tr("Ошибка 111 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
				+ tr(", при переименовании данных в таблице: ") + m_strImyaTablici
				+ tr(" отсутствует Первичный Ключ!"));
        blFlagZakritiya = false;//Ошибка
	}
    else{//В ином случае...
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbUPDATE_3%1").arg(++untUPDATE_3));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 110 в DCDB::UPDATE(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
    		blFlagZakritiya = false;//Ошибка
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			uint untKolonki = slsKolonki.size();//Считаем колличество значений Колонок
			if(untKolonki != 2){//Если колонок не две, то ...
		        qdebug(tr("Ошибка 112 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
						+ tr(", при переименовании данных в таблице: ") + m_strImyaTablici
						+ tr(" количество колонок: ") + QString::number(untKolonki) + tr(" не равно двум!"));
		        blFlagZakritiya = false;//Ошибка
			}
            else{//в ином случае...
				/////////////////////////////////////////////////////////////////////////////////
				/////П О И С К   М А К С И М А Л Ь Н О Г О   П Е Р В И Ч Н О Г О   К Л Ю Ч А/////
				/////////////////////////////////////////////////////////////////////////////////
				quint64 ullSchetchik(0);//Счётчик, в котором будет хранится результат работы функции
				if(m_strDriver == "QPSQL"){
					QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
					//Подгатавливаем запрос для БД
					if(sqlQuery.exec("SELECT LAST_VALUE FROM \""+m_strImyaTablici+"_"+m_strPrimaryKey
								+ "_seq\";")){
						while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
							ullSchetchik = sqlQuery.value(0).toULongLong();//Считываем значение счётчика.
							break;//выходим из цикла
						}
					}
					else{
						qdebug(tr("Ошибка 113 в DCDB::UPDATE(): В базе данных: ")+m_strImyaDB
								+ tr(", в таблице: ") + m_strImyaTablici + tr(" ошибка по причине: ")
								+ sqlQuery.lastError().text());
						blFlagZakritiya = false;//Ошибка
					}
				}
                else{//В ином случае...
	    			QSqlQueryModel* pqrmModel = new QSqlQueryModel(this);
	    			pqrmModel->setQuery(QSqlQuery(("SELECT * FROM \""+ m_strImyaTablici + "\";"), sqlDB));
 					if(pqrmModel->lastError().isValid()){//Если есть ошибка в запросе, то...
						qdebug(tr("Ошибка 114 в DCDB::UPDATE(): В базе данных: ")+m_strImyaDB
								+ tr(", в таблице: ") + m_strImyaTablici + tr(" ошибка по причине: ")
								+ pqrmModel->lastError().text());
						blFlagZakritiya = false;//Ошибка
					}
                    else{//в ином случае...
						quint64 ullKolichestvoStrok=pqrmModel->rowCount();//Присваиваем кол-во строк в модели.
						quint64 ullPKey(0);//Хранит значение Primary Key
						quint64 ullMaxPKey(0);//Хранит максимальное значение Primary Key
						for(quint64 ullShag = 0; ullShag < ullKolichestvoStrok; ullShag++){//Цикл
							ullPKey = pqrmModel->record(ullShag).value(m_strPrimaryKey).toULongLong();
							if(ullPKey > ullMaxPKey)
								ullMaxPKey = ullPKey;
						}
						ullSchetchik = ullMaxPKey;//Передаю переменной максимальное число в Primary Key
	    			}
					delete pqrmModel;//Обязательно удаляю указатель, чтобы не было утечки памяти.
					pqrmModel = nullptr;//Обязательно обнулить указатель динамический.
				}
				if(blFlagZakritiya){//Если не было ошибок, то...
					/////////////////////////////////////////////////////
					/////П О Р Я Д К О В Ы Е   Н О М Е Р А   Г Р А Ф/////
					/////////////////////////////////////////////////////
					int ntKolonka(0);//Порядковый номер первой графы в таблице
					int ntKolonkaParametri(0);//Порядковый номер второй графы с параметрами в талблице.
					QStringList slsPrimaryKey;//Будет содержать первич.ключи, в которых переписываем параметры
					QStringList slsParametri;//Список изменённых параметров.
					for(int ntShag = 0; ntShag < m_slsGrafi.size(); ntShag++){
						if(strGrafa == m_slsGrafi[ntShag])
							ntKolonka = ntShag;
						else{
							if(strGrafaParametri == m_slsGrafi[ntShag])
								ntKolonkaParametri = ntShag;
						}
					}
					//////////////////////////////////////////////////////////////////////
					///// П О И С К   П Е Р Е И М Е Н О В Ы М А Е М Ы Х   Д А Н Н Ы Х/////
					//////////////////////////////////////////////////////////////////////
					QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
					for(quint64 ullShag = 1; ullShag <= ullSchetchik; ullShag++){
						QString strChitaemSQL("");
						QString strChitaemSQLParametri("");
						QStringList slsChitaemSQLParametri;//Список прочтённых параметров.
						if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\" WHERE \""+m_strPrimaryKey
									+"\" = '"+QString::number(ullShag)+"'")){//Перебираем всю таблицу по ключу
							while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
								strChitaemSQL = sqlQuery.value(ntKolonka).toString();
								strChitaemSQLParametri = sqlQuery.value(ntKolonkaParametri).toString();
								break;//выходим из цикла
							}
						}
						else{
							qdebug(tr("Ошибка 115 в DCDB::UPDATE(): В базе данных: ") + m_strImyaDB
									+ tr(", в таблице: ") + m_strImyaTablici + tr(" ошибка по причине: ")
									+ sqlQuery.lastError().text());
							blFlagZakritiya = false;//Ошибка
							break;//Выходим из цикла.
						}
						if(strChitaemSQL == slsKolonki[0]){//Если считаный параметр равен заданному, то...
							///////////////////////////////////////////////////////////
							/////П Е Р Е И М Е Н О В Ы В А Е М   П А Р А М Е Т Р Ы/////
							///////////////////////////////////////////////////////////
							QString strParametri("");//Переменная, которая будет хранить изменённые парам.
							slsChitaemSQLParametri = strChitaemSQLParametri.split(",");//Список создаём.
							for(int ntShag = 0; ntShag < slsChitaemSQLParametri.size(); ++ntShag){
								if(ntShag)//Если не ноль, то...
									strParametri +=",";//прибавляем запятую.
								if(slsChitaemSQLParametri[ntShag] == slsKolonki[0])
									strParametri += slsKolonki[1];//Переименовываем строчку.
								else
									strParametri += slsChitaemSQLParametri[ntShag];//Записываем без изменений
							}
							slsPrimaryKey << QString::number(ullShag);//Записываем первичный ключ.	
							slsParametri << strParametri;//Записываем изменённые параметры.
						}
					}
					if(blFlagZakritiya){//Если не было ошибок, то...
						/////////////////////////////////////////////////////////////////
						/////П Е Р Е И М Е Н О В А Т Ь   Д А Н Н Ы Е   Т А Б Л И Ц Ы/////
						/////////////////////////////////////////////////////////////////
 						for(int ntShag = 0; ntShag < slsPrimaryKey.size(); ntShag++){//Цикл
							if (!sqlQuery.exec("UPDATE \""+m_strImyaTablici+"\" SET \""+strGrafa+"\" = '"
									+slsKolonki[1]+"' , \""+strGrafaParametri+"\" = '"+slsParametri[ntShag]
									+"' WHERE \""+m_strPrimaryKey+"\" = '"+slsPrimaryKey[ntShag]+"';")){
								qdebug(tr("Ошибка 116 в DCDB::UPDATE(): В базе данных: ")
										+ m_strImyaDB + tr(" таблицы: ") + m_strImyaTablici
										+ tr(", не смог переименовать данные c ")
										+ slsKolonki[0] + tr(" на ") + slsKolonki[1]
										+ tr(" в графе ") + strGrafa + tr(" по причине: ")
										+ sqlQuery.lastError().text());
								blFlagZakritiya = false;//Ошибка
								break;//Выходим из цикла.
							}
						}
					}
				}
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbUPDATE_3%1").arg(untUPDATE_3));//Закрываем открытую БД
	return blFlagZakritiya;
}
bool DCDB::DELETE(QString strGrafa, QString strKolonka){//Удалить данные
/////////////////////
//---D E L E T E---//
/////////////////////
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 054 в DCDB::DELETE(): Имя драйвера SQL не указано."));
		return false;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 055 в DCDB::DELETE(): Имя базы данных SQL не указано."));
			return false;//Возвращаем ошибку.
		}
	}
	bool blFlagZakritiya(true);//если ошибка в функции, закрываем БД.
	static uint untDELETE(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB = QSqlDatabase::addDatabase(m_strDriver, QString("dbDELETE%1").arg(++untDELETE));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 050 в DCDB::DELETE(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
    		blFlagZakritiya = false;//Ошибка
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			/////////////////////////////////////
			/////У Д А Л И Т Ь   Д А Н Н Ы Е/////
			/////////////////////////////////////
			if (!sqlQuery.exec("DELETE FROM \""+m_strImyaTablici+"\" WHERE \""+strGrafa
						+"\" = '"+strKolonka+"';")){
				qdebug(tr("Ошибка 053 в DCDB::DELETE(): В базе данных: ") + m_strImyaDB
						+ tr(" таблицы: ") + m_strImyaTablici + tr(", не смог удалить в графе ")
						+ strGrafa + tr(" колонку с ") + strKolonka + tr(" по причине: ")
						+ sqlQuery.lastError().text());
				blFlagZakritiya = false;//Ошибка
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbDELETE%1").arg(untDELETE));//Закрываем открытую БД
	return blFlagZakritiya;
}
QString DCDB::SELECT(QString strGrafa, QString strKolonka, QString strChitaemayaGrafa){//Читаем данные из БД.
/////////////////////
//---S E L E C T---//
/////////////////////
	QString strChitaemSQL("");	
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 064 в DCDB::SELECT(): Имя драйвера SQL не указано."));
		return strChitaemSQL;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 065 в DCDB::SELECT(): Имя базы данных SQL не указано."));
			return strChitaemSQL;//Возвращаем ошибку.
		}
	}
	static uint untSELECT_1(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbSELECT_1%1").arg(++untSELECT_1));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 060 в DCDB::SELECT(): база данных: ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
		else{
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			int ntKolonka(0);
			for(int ntShag = 0; ntShag < m_slsGrafi.size(); ntShag++){
				if(strChitaemayaGrafa == m_slsGrafi[ntShag]){
					ntKolonka = ntShag;
					break;
				}
			}
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
			//Подгатавливаем запрос для БД
			if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\" WHERE \""+strGrafa+"\" = '"+strKolonka
					+"'")){
				while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
					strChitaemSQL = sqlQuery.value(ntKolonka).toString();
					break;//выходим из цикла
				}
			}
			else{
				qdebug(tr("Ошибка 063 в DCDB::SELECT(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
						+ m_strImyaTablici + tr(" ошибка по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbSELECT_1%1").arg(untSELECT_1));//Закрываем открытую БД
	return strChitaemSQL;
}
quint64 DCDB::SELECT(void){//Подсчёт количества строк в БД.
/////////////////////
//---S E L E C T---//
/////////////////////
	quint64 ullSchetchik(0);//Счетчик, в котором будет хранится результат работы функции
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 074 в DCDB::SELECT(): Имя драйвера SQL не указано."));
		return ullSchetchik;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 075 в DCDB::SELECT(): Имя базы данных SQL не указано."));
			return ullSchetchik;//Возвращаем ошибку.
		}
	}
	static uint untSELECT_2(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbSELECT_2%1").arg(++untSELECT_2));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 070 в DCDB::SELECT(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
    		QSqlQueryModel* pqrmModel = new QSqlQueryModel(this);
	    	pqrmModel->setQuery(QSqlQuery(("SELECT * FROM \""+m_strImyaTablici+"\";"), sqlDB));
 			if(pqrmModel->lastError().isValid()){//Если есть ошибка, то...
				qdebug(tr("Ошибка 073 в DCDB::SELECT(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
						+ m_strImyaTablici + tr(" ошибка по причине: ") + pqrmModel->lastError().text());
			}
            else{//в ином случае...
				///////////////////////////////
				//---С У М М А   С Т Р О К---//
				///////////////////////////////
				ullSchetchik = pqrmModel->rowCount();//Присваиваем количество строк в модели 
    		}
			delete pqrmModel;//Обязательно удалить указатель, иначе утечка памяти будет.
			pqrmModel = nullptr;//Обнуляем указатель.
		}
	}
	QSqlDatabase::removeDatabase(QString("dbSELECT_2%1").arg(untSELECT_2));//Закрываем открытую БД	
	return ullSchetchik;
}
quint64 DCDB::SELECT(QString strGrafa, QString strKolonka){//Считаем совпадения в БД
/////////////////////
//---S E L E C T---//
/////////////////////
	quint64 ullSchetchik(0);//Счетчик, в котором будет хранится результат работы функции
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 084 в DCDB::SELECT(): Имя драйвера SQL не указано."));
		return ullSchetchik;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 085 в DCDB::SELECT(): Имя базы данных SQL не указано."));
			return ullSchetchik;//Возвращаем ошибку.
		}
	}
	static uint untSELECT_3(0);//Счётчик запросов на открытие и закрытие базы данных
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbSELECT_3%1").arg(++untSELECT_3));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 080 в DCDB::SELECT(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			//Создаём запрос на поиск совпадений в заданной таблицы БД
			if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\" WHERE \""+strGrafa+"\" = '"
					+strKolonka+"';")){
				while(sqlQuery.next())//Проверяем заданную таблицу на наличие совпадений
					ullSchetchik++;//Суммируем совпадения
			}
			else{
				qdebug(tr("Ошибка 083 в DCDB::SELECT(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
						+ m_strImyaTablici + tr(" ошибка по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbSELECT_3%1").arg(untSELECT_3));//Закрываем открытую БД
	return ullSchetchik;
}
quint64 DCDB::SELECT(QStringList slsGrafi, QStringList slsKolonki){//Считаем совпадения в БД
/////////////////////
//---S E L E C T---//
/////////////////////
	quint64 ullSchetchik(0);//Счетчик, в котором будет хранится результат работы функции
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 094 в DCDB::SELECT(): Имя драйвера SQL не указано."));
		return ullSchetchik;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 095 в DCDB::SELECT(): Имя базы данных SQL не указано."));
			return ullSchetchik;//Возвращаем ошибку.
		}
	}
	static uint untSELECT_4(0);//Счётчик запросов на открытие и закрытие базы данных
	uint untGrafi = slsGrafi.size();//Считаем количество значений Граф
	uint untKolonki = slsKolonki.size();//Считаем количество значений Колонок	
	if(untGrafi == untKolonki){//Если есть равенство граф и колонок, то... 
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbSELECT_4%1").arg(++untSELECT_4));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 090 в DCDB::SELECT(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QString	strSqlZapros("");//Строчка в которой соберется запрос
			for(uint untStep = 0; untStep < untGrafi; untStep++){
		    	if(untStep)//Если это не нулевой элемент, то...
		    		strSqlZapros += " AND ";
		    	strSqlZapros +=	"\"" + slsGrafi[untStep] + "\" = '" +  slsKolonki[untStep] + "'";
			}
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			//Создаём запрос на поиск совпадений в заданной таблицы БД
			if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\" WHERE "+strSqlZapros+";")){
				while(sqlQuery.next())//Проверяем заданную таблицу на наличие совпадений
					ullSchetchik++;//Суммируем совпадения
			}
			else{
				qdebug(tr("Ошибка 093 в DCDB::SELECT(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
						+ m_strImyaTablici + tr(" ошибка по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	else{
		qdebug(tr("Ошибка 091 в DCDB::SELECT(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
				+ m_strImyaTablici + tr(" количество Граф: ") + QString::number(untGrafi)
				+ tr(" не равно количеству Колонок: ") + QString::number(untKolonki));
	}
	QSqlDatabase::removeDatabase(QString("dbSELECT_4%1").arg(untSELECT_4));//Закрываем открытую БД
	return ullSchetchik;
}
quint64 DCDB::SELECTPK(void){//Возвращаем максимальное число Primary Key в БД.
/////////////////////
//---S E L E C T---//
/////////////////////
	quint64 ullSchetchik(0);//Счётчик, в котором будет хранится результат работы функции
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 105 в DCDB::SELECTPK(): Имя драйвера SQL не указано."));
		return ullSchetchik;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 106 в DCDB::SELECTPK(): Имя базы данных SQL не указано."));
			return ullSchetchik;//Возвращаем ошибку.
		}
	}
	static uint untSELECTPK(0);//Счётчик запросов на открытие и закрытие базы данных
	if(m_strPrimaryKey.isEmpty()){//Если нет первичного ключа, то...
		qdebug(tr("Ошибка 101 в DCDB::SELECTPK(): База данных ") + m_strImyaDB + tr("в таблице: ")
				+ m_strImyaTablici + tr(" отсутствует Primary Key!"));
	}
	else{//Если первичный ключ есть, то...
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbSELECTPK%1").arg(++untSELECTPK));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 100 в DCDB::SELECTPK(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			if(m_strDriver == "QPSQL"){
				QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса к БД
				//Подгатавливаем запрос для БД
				if(sqlQuery.exec("SELECT LAST_VALUE FROM \""+m_strImyaTablici+"_"+m_strPrimaryKey
							+ "_seq\";")){
					while(sqlQuery.next()){//Производим поиск по БД с заданными выше параметрами
						ullSchetchik = sqlQuery.value(0).toULongLong();//Считываем значение счётчика.
						break;//выходим из цикла
					}
				}
				else{
					qdebug(tr("Ошибка 103 в DCDB::SELECTPK(): В базе данных: ")+m_strImyaDB
							+ tr(", в таблице: ") + m_strImyaTablici + tr(" ошибка по причине: ")
							+ sqlQuery.lastError().text());
				}
			}
            else{//В ином случае...
	    		QSqlQueryModel* pqrmModel = new QSqlQueryModel(this);
	    		pqrmModel->setQuery(QSqlQuery(("SELECT * FROM \""+ m_strImyaTablici + "\";"), sqlDB));
 				if(pqrmModel->lastError().isValid()){//Если есть ошибка в запросе, то...
					qdebug(tr("Ошибка 104 в DCDB::SELECTPK(): В базе данных: ")+m_strImyaDB
							+ tr(", в таблице: ") + m_strImyaTablici + tr(" ошибка по причине: ")
							+ pqrmModel->lastError().text());
				}
                else{//в ином случае...
					quint64 ullKolichestvoStrok=pqrmModel->rowCount();//Присваиваем количество строк в модели 
					quint64 ullPKey(0);//Хранит значение Primary Key
					quint64 ullMaxPKey(0);//Хранит максимальное значение Primary Key
					for(quint64 ullShag = 0; ullShag < ullKolichestvoStrok; ullShag++){//Цикл
						ullPKey = pqrmModel->record(ullShag).value(m_strPrimaryKey).toULongLong();
						if(ullPKey > ullMaxPKey)
							ullMaxPKey = ullPKey;
					}
					ullSchetchik = ullMaxPKey;//Передаю переменной максимальное число в Primary Key
    			}
				delete pqrmModel;//Обязательно удаляю указатель, чтобы не было утечки памяти.
				pqrmModel = nullptr;//Обязательно обнулить указатель динамический.
			}
		}
	}
	QSqlDatabase::removeDatabase(QString("dbSELECTPK%1").arg(untSELECTPK));//Закрываем открытую БД
	return ullSchetchik;
}
QSqlQuery DCDB::SELECT(bool blUdalitDB, QString strZapros, QString strOrderBy, int ntLimit, int ntSdvig){
/////////////////////
//---S E L E C T---//
/////////////////////
	QSqlQuery sqrZapros;//Пустой запрос для возврата во время ошибки.
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 132 в DCDB::SELECT(): Имя драйвера SQL не указано."));
		return sqrZapros;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 133 в DCDB::SELECT(): Имя базы данных SQL не указано."));
			return sqrZapros;//Возвращаем ошибку.
		}
	}
	int ntSELECT_6(0);//Номер имени таблицы.
	static QStringList slsTablici;//Список Таблиц.
	bool blFlag(true);//добалять в список НАДО!
	int ntTablici = slsTablici.size();//Количество таблиц в списке.
	/////////////////////
	/////З А П Р О С/////
	/////////////////////
	if(blUdalitDB){//Если удалить подсоединение к БД, то...
		for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Цикл перебора имени таблиц в списке.
			if(slsTablici[ntShag] == m_strImyaTablici){//Если есть совпадение из списка, то...
				QSqlDatabase::removeDatabase(QString("dbSELECT_6%1").arg(ntShag));//Закр. открытую БД
				slsTablici[ntShag] = "";//Удаляем таблицу из списка.
				return sqrZapros;//Возращаем пустой запрос.
			}
		}
		return sqrZapros;//Возращаем пустой запрос.
	}
	else{//Если не нужно удалять подсоединение к БД, то...
		/////////////////////////////////////
		/////С Б О Р Щ И К   М У С О Р А/////
		/////////////////////////////////////
		bool blMusor(true);//Мусор, пустые строчки.
		for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Сборщик мусора
			if(slsTablici[ntShag] != ""){//Если не пустая строчка.
				blMusor = false;//Не мусор.
				break;//Выходим из цикла.
			}
		}
		if(blMusor){//Если список состоит из мусора, то...
			slsTablici.clear();//Очищаем список от мусора полностью.
			ntTablici = 0;//Таблиц нет.
		}
		if(!ntTablici){//Если нет ни одной таблицы в списке, то...
			slsTablici<<m_strImyaTablici;//Добавляем имя таблицы в список.
			blFlag = false;//добавлять в список не надо.
		}
		else{
			for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Цикл перебора имени таблиц в списке.
				if(slsTablici[ntShag] == m_strImyaTablici){//Если есть совпадение из списка, то...
					ntSELECT_6 = ntShag;//Номер имени таблицы.
					QSqlDatabase::removeDatabase(QString("dbSELECT_6%1").arg(ntSELECT_6));//Закр. открытую БД
					blFlag = false;//Добавлять в список не надо.
				}
			}
		}
		if(blFlag){//Если нужно добавить в список, то...
			bool blDobavit(true);//Добавлять имя таблицы в список.
			for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Цикл перебора имени таблиц в списке.
				if(slsTablici[ntShag] == ""){//Если есть совпадение "", то...
					slsTablici[ntShag] = m_strImyaTablici;//Добавляем имя таблици в пустую строчку.
					ntSELECT_6 = ntShag;//Приравниваем номер таблицы в списке.
					blDobavit = false;//Не добавлять больше имя таблицы в список.
					break;//Выходим из цикла.
				}
			}
			if(blDobavit){//Если добавить имя таблицы в список, то...
				slsTablici<<m_strImyaTablici;//Добавляем имя таблицы в список.
				ntSELECT_6 = ntTablici;//Номер имени таблицы.
			}
		}
	}
	QString strZaprosDB("");//Запрос ограничения.
	QString strOrderByDB("");//Запрос сортировки.
	QString strLimit("");//Запрос ограничения показа.
	if(!strZapros.isEmpty())//Если запрос не пустая строчка, то...
		strZaprosDB += " WHERE "+strZapros;//Добавляем запрос ограничения.
	if(!strOrderBy.isEmpty())
		strOrderByDB += " ORDER BY \""+strOrderBy+"\" ";//Запрос на сортировку.
	if(ntLimit)//Если не ноль ограничение, то...
		strLimit += " LIMIT " + QString::number(ntLimit) + " OFFSET " + QString::number(ntLimit*ntSdvig);
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbSELECT_6%1").arg(ntSELECT_6));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 130 в DCDB::SELECT(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqrQuery(sqlDB);//Создаем объект запроса
			//Создаём запрос на поиск совпадений в заданной таблицы БД
			if(sqrQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\""+strZaprosDB+strOrderByDB+strLimit+";"))
                return sqrQuery;//Возращаем запрос.
			else{
				qdebug(tr("Ошибка 131 в DCDB::SELECT(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
						+ m_strImyaTablici + tr(" ошибка по причине: ") + sqrQuery.lastError().text());
			}
		}
	}
	return sqrZapros;//Возращаем пустой запрос.
}
QSqlQuery DCDB::LIKE(bool blUdalitDB, QStringList slsConcat, QString strLike, QString strZapros,
		QString strOrderBy, int ntLimit, int ntSdvig){//Запрос с поиском, ограничениями, сортировкой и лимитом
/////////////////
//---L I K E---//
/////////////////
	QSqlQuery sqrZapros;//Пустой запрос для возврата во время ошибки.
	if(m_strDriver.isEmpty()){//Если пустая строка, то ошибка.
		qdebug(tr("Ошибка 143 в DCDB::LIKE(): Имя драйвера SQL не указано."));
		return sqrZapros;//Возвращаем ошибку.
	}
	else{
		if(m_strImyaDB.isEmpty()){//Если имя БД пустое, то...
			qdebug(tr("Ошибка 144 в DCDB::LIKE(): Имя базы данных SQL не указано."));
			return sqrZapros;//Возвращаем ошибку.
		}
	}
	int ntLIKE_1(0);//Номер имени таблицы.
	static QStringList slsTablici;//Список Таблиц.
	bool blFlag(true);//добалять в список НАДО!
	int ntTablici = slsTablici.size();//Количество таблиц в списке.
	/////////////////////
	/////З А П Р О С/////
	/////////////////////
	if(blUdalitDB){//Если удалить подсоединение к БД, то...
		for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Цикл перебора имени таблиц в списке.
			if(slsTablici[ntShag] == m_strImyaTablici){//Если есть совпадение из списка, то...
				QSqlDatabase::removeDatabase(QString("dbLIKE_1%1").arg(ntShag));//Закр. открытую БД
				slsTablici[ntShag] = "";//Удаляем таблицу из списка.
				return sqrZapros;//Возращаем пустой запрос.
			}
		}
		return sqrZapros;//Возращаем пустой запрос.
	}
	else{//Если не нужно удалять подсоединение к БД, то...
		/////////////////////////////////////
		/////С Б О Р Щ И К   М У С О Р А/////
		/////////////////////////////////////
		bool blMusor(true);//Мусор, пустые строчки.
		for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Сборщик мусора
			if(slsTablici[ntShag] != ""){//Если не пустая строчка.
				blMusor = false;//Не мусор.
				break;//Выходим из цикла.
			}
		}
		if(blMusor){//Если список состоит из мусора, то...
			slsTablici.clear();//Очищаем список от мусора полностью.
			ntTablici = 0;//Таблиц нет.
		}
		if(!ntTablici){//Если нет ни одной таблицы в списке, то...
			slsTablici<<m_strImyaTablici;//Добавляем имя таблицы в список.
			blFlag = false;//добавлять в список не надо.
		}
		else{
			for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Цикл перебора имени таблиц в списке.
				if(slsTablici[ntShag] == m_strImyaTablici){//Если есть совпадение из списка, то...
					ntLIKE_1 = ntShag;//Номер имени таблицы.
					QSqlDatabase::removeDatabase(QString("dbLIKE_1%1").arg(ntLIKE_1));//Закрываем открытую БД
					blFlag = false;//Добавлять в список не надо.
				}
			}
		}
		if(blFlag){//Если нужно добавить в список, то...
			bool blDobavit(true);//Добавлять имя таблицы в список.
			for(int ntShag = 0; ntShag<ntTablici; ++ntShag){//Цикл перебора имени таблиц в списке.
				if(slsTablici[ntShag] == ""){//Если есть совпадение "", то...
					slsTablici[ntShag] = m_strImyaTablici;//Добавляем имя таблици в пустую строчку.
					ntLIKE_1 = ntShag;//Приравниваем номер таблицы в списке.
					blDobavit = false;//Не добавлять больше имя таблицы в список.
					break;//Выходим из цикла.
				}
			}
			if(blDobavit){//Если добавить имя таблицы в список, то...
				slsTablici<<m_strImyaTablici;//Добавляем имя таблицы в список.
				ntLIKE_1 = ntTablici;//Номер имени таблицы.
			}
		}
	}
	QString strConcatDB("");//Границы поиска.
	QString strLikeDB("");//Поисковый запрос.
	QString strZaprosDB("");//Запрос ограничения.
	QString strOrderByDB("");//Запрос сортировки.
	QString strLimit("");//Запрос ограничения показа.
	if(!slsConcat.isEmpty()){
		strConcatDB += " CONCAT(";
		for(int ntShag = 0; ntShag<slsConcat.size();++ntShag){
			if(ntShag)
				strConcatDB += ",";
			strConcatDB += " \""+slsConcat[ntShag]+"\"";
		}
		strConcatDB += ") ";
	}
	if(!strLike.isEmpty())
		strLikeDB += " LIKE '%"+strLike+"%' ";
	else{
		qdebug(tr("Ошибка 142 в DCDB::LIKE(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
				+ m_strImyaTablici + tr(" ошибка по причине отсутствия запроса на поиск!"));
		return sqrZapros;//Пустой запрос отправляю, так как ошибка.
	}
	if(!strZapros.isEmpty())//Если запрос не пустая строчка, то...
		strZaprosDB += " AND ("+strZapros+") ";//Добавляем запрос ограничения.
	if(!strOrderBy.isEmpty())
		strOrderByDB += " ORDER BY \""+strOrderBy+"\" ";//Запрос на сортировку.
	if(ntLimit)//Если не ноль ограничение, то...
		strLimit += " LIMIT " + QString::number(ntLimit) + " OFFSET " + QString::number(ntLimit*ntSdvig);
	{
		QSqlDatabase sqlDB=QSqlDatabase::addDatabase(m_strDriver, QString("dbLIKE_1%1").arg(ntLIKE_1));
		sqlDB.setDatabaseName(m_strImyaDB);
		sqlDB.setHostName(m_strHostName);
		sqlDB.setPort(m_untPort);
		if(!sqlDB.open(m_strUserName, m_strPassword)){//Если база не открылась, то...
			qdebug(tr("Ошибка 140 в DCDB::LIKE(): База данных ") + m_strImyaDB 
					+ tr(" не открылась по причине: ") + sqlDB.lastError().text());
			emit signalSqlSoedinenie(false);//Сигнал отсутствия соединения к postgresql серверу.
		}
        else{//В ином случае...
			emit signalSqlSoedinenie(true);//Сигнал соединения к postrgesql серверу.
			QSqlQuery sqlQuery(sqlDB);//Создаем объект запроса
			//Создаём запрос на поиск совпадений в заданной таблицы БД
			if(sqlQuery.exec("SELECT * FROM \""+m_strImyaTablici+"\" WHERE "+strConcatDB+strLikeDB+strZaprosDB
						+strOrderByDB+strLimit+";"))
				return sqlQuery;//Возращаем запрос.
			else{
				qdebug(tr("Ошибка 141 в DCDB::LIKE(): В базе данных: ") + m_strImyaDB + tr(", в таблице: ")
						+ m_strImyaTablici + tr(" ошибка по причине: ") + sqlQuery.lastError().text());
			}
		}
	}
	return sqrZapros;//Возращаем пустой запрос.
}
QSqlQuery DCDB::CLEAR(){//Пустой запрос.
///////////////////
//---C L E A R---//
///////////////////
	QSqlQuery sqrZapros;//Пустой запрос для возврата во время ошибки.
	return sqrZapros;//Возвращаем пустой запрос.
}
void DCDB::ustDriverDB(QString strDriver){//Установить драйвер БД.
///////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   И М Я   Д Р А Й В Е Р А---//
///////////////////////////////////////////////////////
	static QString sstrDriver;//Статическая переменная запоминающая имя драйвера.
	if((strDriver == "QSQLITE")||(strDriver == "QPSQL")){//Если имя драйвера совпадает, то...
		if(sstrDriver.isEmpty())//Если статическая переменная пустая, то...
			sstrDriver = strDriver;//Инициализируем статическую переменную единственно правильным значением.
		if(sstrDriver !=strDriver)//Если значение не равно статическому, то это попытка изменить Драйвер QSL.
			qdebug(tr("Ошибка 171 в DCDB::ustDriverDB(): Нельзя повторно менять драйвер SQL."));//Ошибка.
		else//Если равны значения, значит это первичная иннициализация драйвера SQL.
			m_strDriver = strDriver;//Присваиваем заданное значение.
	}
	else{//Если не совпадает, то...
		qDebug()<<tr("Ошибка 170 в DCDB::ustDriverDB(): Заданное имя драйвера SQL неизвестно.");//Конструктор
		if(sstrDriver.isEmpty())//Если статическая переменная пустая, то...
			m_strDriver = "";//Это значит впервые задаём имя Драйвера и оно не верное, поэтому "".
	}
}
void DCDB::ustImyaDB(QString strImyaDB){//Установить имя БД.
///////////////////////////////////////////
//---У С Т А Н О В И Т Ь   И М Я   Б Д---//
///////////////////////////////////////////
	bool blPusto = true;//Пусто..
	static QString sstrImyaDB;//Статическая переменная запоминающая имя БД.
	if(!strImyaDB.isEmpty()){//Если строчка не пустая а содежжит символы, то...
		QByteArray btrImyaDB = strImyaDB.toLocal8Bit();//переводим строчку в QByteArray
        for(int ntShag = 0; ntShag < btrImyaDB.size(); ntShag++){//Перебераем по символам строчку.
            if(btrImyaDB[ntShag] != ' '){//Если это не пробел, то...
				blPusto = false;//Строка не пустая.
				break;//То строчка не пустая. Выходим из цикла.
			}
		}
	}
	if(blPusto){//Если строчка состоит из одних пробелов, то...
		qDebug()<<tr("Ошибка 180 в DCDB::ustImyaDB(): Имя базы данных заданно пустым.");//В Конструкторе вызов
		if(sstrImyaDB.isEmpty())//Если статическая переменная пустая, то..
			m_strImyaDB = "";//Значит задаётся имя БД впервые и оно не верное, поэтому "".
	}
	else{//Если не пустая строчка, то...
		if(sstrImyaDB.isEmpty())//Если статическая переменная пустая, то...
			sstrImyaDB = strImyaDB;//Инициализируем статическую переменную единственно правильным значением.
		if(sstrImyaDB !=strImyaDB)//Если значение не равно статическому, то это попытка изменить Имя БД.
			qdebug(tr("Ошибка 181 в DCDB::ustImyaDB(): Нельзя повторно менять имя БД."));//Ошибка.
		else//Если равны значения, значит это первичная иннициализация имени БД SQL.
			m_strImyaDB = strImyaDB;
	}
}
void DCDB::ustImyaTablici(QString  strImyaTablici){//Установить имя таблицы.
/////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   И М Я   Т А Б Л И Ц И---//
/////////////////////////////////////////////////////
	if(m_strImyaTablici != strImyaTablici){//Если нет равенства таблиц, то...
		if(strImyaTablici == ""){//Если пустое имя таблицы, то...
			qdebug(tr("Ошибка 151 в DCDB::ustImyaTablici() В базе данных: ") + m_strImyaDB  
					+ tr(" ошибка по причине пустого имени таблицы"));
		}
		else{//Если нет, то...
			SELECT(true, "", "", 0, 0);//Закрываем БД, делаем нулевой запрос.
			LIKE(true, QStringList(), "", "", "", 0, 0);//Закрываем БД, делаем нулевой запрос.
			m_strImyaTablici = strImyaTablici;
		}
	}
}
bool DCDB::kodCREATE(QString strKodImyaTablic, int ntKodKolichestvo){//Создать таблицу кодов.
///////////////////////////////////////////////////
//---С О З Д А Т Ь   Т А Б Л И Ц У   К О Д О В---//
///////////////////////////////////////////////////
	m_ntKodKolichestvo = ntKodKolichestvo;
	m_strKodImyaTablic = strKodImyaTablic;
	ustImyaTablici(m_strKodImyaTablic + "_1000");
	if(CREATE(QStringList()<<"#Номер"<<"Код"<<"Параметры")){
		if(SELECTPK() < 2){//Если нет записи ни одной в таблице, то...
			QString strParametri("");//Строчка с 1000 нулями.
			for(int ntParametri = 0; ntParametri<100; ++ntParametri){//Цикл создания строчки параметров.
				if(ntParametri)//Если не 0, то...
					strParametri += ",";//Добавляем запятую.
				strParametri += "0";//Во всех случаях добавляем 0.
			}
			//TODO узнать целое число, чтоб узанть, сколько строк создавать в таблице.
			ustImyaTablici(m_strKodImyaTablic + "_1000000");
			if(CREATE(QStringList()<<"#Номер"<<"Код"<<"Параметры")){
				ustImyaTablici(m_strKodImyaTablic + "_1000000000");
				if(CREATE(QStringList()<<"#Номер"<<"Код"<<"Параметры")){
					
				}
			}
		}
	}
	return false;//Ошибка
}
