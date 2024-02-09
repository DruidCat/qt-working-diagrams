#ifndef DCDB_H
#define DCDB_H

#include <QObject>
#include <QtSql>
#include <QtDebug>
#include <QString>
#include <QSqlQueryModel>
#include <QSqlQuery>

class DCDB : public QObject{
    Q_OBJECT

public:
	DCDB( 	const QString strDriver, const QString strImyaDB, QString strImyaTablici,
            QObject* proditel = nullptr);
    DCDB( 	const QString strDriver, const QString strImyaDB, QObject* proditel = nullptr);
    DCDB( 	QObject* proditel = nullptr);
	bool 	checkStatus();//Открыть и закрыть Базу данных, для того чтобы проверить статус сети.
	bool 	CREATE(QStringList slsGrafi);//Создать таблицу.
	bool 	DROP();//Метод удаляющий таблицу в БД.
	bool 	INSERT(QStringList slsGrafi, QStringList slsKolonki);//Вставить данные.
	bool 	UPDATE(QStringList slsGrafi, QStringList slsKolonki);//Обновить данные.
	bool 	UPDATE(QString strGrafa, QStringList slsKolonki);//Переименовать данные.
	bool 	UPDATE(QString strGrafa, QString strGrafaParametri, QStringList slsKolonki);//Переименовать данны
	bool 	DELETE(QString strGrafa, QString strKolonka);//Удалить данные.
	QString SELECT(QString strGrafa, QString strKolonka, QString strChitaemayaGrafa);//Читаем данные из БД.
	quint64 SELECT(void);//Подсчёт количества строк в БД.
	quint64 SELECT(QString strGrafa, QString strKolonka);//Считаем совпадения в БД
	quint64 SELECT(QStringList slsGrafi, QStringList slsKolonki);//Считаем совпадения в БД
	quint64 SELECTPK(void);//Возвращаем максимальное число Primary Key в БД.
	QSqlQuery SELECT(bool blUdalitDB, QString strZapros, QString strOrderBy, int ntLimit, int ntSdvig);
	QSqlQuery LIKE(bool blUdalitDB, QStringList slsConcat, QString strLike, QString strZapros,
			QString strOrderBy, int ntLimit, int ntSdvig);//Запрос с поиском, ограничениями, сортировкой и лим
	QSqlQuery CLEAR();//Пустой запрос.

	void 	ustDriverDB(QString strDriver)	{m_strDriver = strDriver;}	//Установить драйвер БД.
	void 	ustImyaDB(QString strImyaDB)	{m_strImyaDB = strImyaDB;}	//Установить имя БД.
	QString polImyaDB()						{return m_strImyaDB;}		//Получить имя базы данных.
	void 	ustImyaTablici(QString  strImyaTablici);//Установить имя таблицы.
	QString polImyaTablici()				{return m_strImyaTablici;}	//Получить имя таблицы.
	void 	setHostName(QString strHostName){m_strHostName = strHostName;}//Установить IP.
	QString getHostName()					{return m_strHostName;}		//Получить IP.
	void 	setUserName(QString strUserName){m_strUserName = strUserName;}//Установить Имя Пользователя БД.
	QString getUserName()					{return m_strUserName;}		//Получить Имя Пользователя БД.
	void 	setPassword(QString strPassword){m_strPassword = strPassword;}//Установить пароль на БД.
	QString getPassword()					{return m_strPassword;}		//Получить пароль на БД.
	void 	setPort(uint untPort)			{m_untPort = untPort;}		//Установить порт для БД.
	uint 	getPort()						{return m_untPort;}			//Получить порт для БД.
	int 	size() 							{return m_ntKolGraf;} 		//Получить количество граф в БД.
	//---коды---//
	bool 	kodCREATE(QString strKodImyaTablic, int ntKodKolichestvo);//Создать таблицу кодов.

signals:
	void	signalDebug(QString strDebug);//Сигнал, отправляющий строчку отладки в логи
	void	signalInfo(QStringList strlInfo);//Сигнал, отправляющий строчку информации в логи
	void 	signalSqlSoedinenie(bool blStatus);//Сигнал соединения к postrgesql серверу.

private slots:
	void	qdebug(QString strDebug){emit signalDebug(strDebug);}//Слот излучающая строчку в Лог

private:
	QString m_strDriver;//Имя QSL драйвера.
	QString m_strImyaDB;//Имя базы данных, в которой будет хранится таблица
	QString m_strImyaTablici;//Имя таблици, в которой будут хранится данные
	QString m_strHostName;//IP адресс подключения к БД
	QString m_strPassword;//Пароль пользователя БД
	QString m_strUserName;//Имя пользователя подключающегося к БД
	uint m_untPort;//Порт подключения к БД
	QStringList m_slsGrafi;//Графы в таблице.
	int m_ntKolGraf;//Количество граф.
	QString m_strPrimaryKey;//Переменная хранящая имя PrimaryKey
	//---коды---//
	int m_ntKodKolichestvo;//Заданное количество кодов.
	QString m_strKodImyaTablic;//Общее имя таблиц кодов.
};

#endif // DCDB_H
/////////////////////////////
//---И Н С Т Р У К Ц И Я---//
/////////////////////////////
/*
 * Конструктор.		DCDB(	const QString strDriver, const QString strImyaDB, const QString strImyaTablici,
 * 							QWidget* proditel = nullptr);
 * 1) strDriver		- это SQL драйвер.										ПРИМЕР: "QPSQL" или "QSQLITE"
 * 2) strImyaFaila	- это имя Файла базы данных, включая его расширение.	ПРИМЕР: "компания.dc"
 * 3) strImyaTablici- это имя Таблицы, в которой будут хранится данный.		ПРИМЕР: "Работники"
 * ПРИМЕР:
 * DCDB* pdcdb = new DCDB("QPSQL", "компания.dc", "Работники");
 *
 * Создание нескольких таблиц с одинаковыми параметрами.. 
 * Конструктор.		DCDB(	const QString strDriver, const QString strImyaDB, QWidget* proditel=nullptr);
 * ПРИМЕР:
 * DCDB* pdcdb = new DCDB("QPSQL", "компания.dc");
 * pdcdb->ustImyaTablici("группа_01");
 * pdcdb->CREATE(QStringList()<<"#Код"<<"Группа"<<"Описание");
 * pdcdb->ustImyaTablici("группа_02");
 * pdcdb->CREATE(QStringList());//Повторный список граф отправлять не нужно!!!
 *
 * Установиь пароль. 		void setPasword(QString strPassword);
 * strPassword 		- это Пароль к подключаемой БД.
 * ПРИМЕР:
 * pdcdb->setPassword("12345");
 * ПРИМЕЧАНИЕ:
 * так же есть методы: setUserName(), setPort(), setHostName()
 * 
 * Создать таблицу. 		bool CREATE(QStringList slsGrafi);
 * slsGrafi		- это Графы таблицы.									ПРИМЕР: "Фамилия Имя Отчество"
 * ПРИМЕР:
 * pdcdb->CREATE(QStringList()<<"Фамилия"<<"Имя"<<"Отчество");
 * pdcdb->CREATE(QStringList()<<"#Номер"<<"Фамилия"<<"Имя"<<"Отчество");
 * ПРИМЕЧАНИЕ:
 * # - это маркер Первичного Ключа (Primary Key). Номер - это первичный ключ.
 *
 * Удалить таблицу. 		bool DROP();
 * ПРИМЕР:
 * pdcdb->DROP();
 *
 * Вставить данные.			bool INSERT(QStringList slsGrafi, QStringList slsKolonki);
 * ПРИМЕР:
 * pdcdb->INSERT(QStringList()<<"Фамилия"<<"Имя"<<"Отчество", QStringList()<<"Иванов"<<"Иван"<<"Иванович");
 * 
 * Обновить данные.			bool UPDATE(QStringList slsGrafi, QStringList slsKolonki);
 * ПРИМЕР:
 * pdcdb->UPDATE(QStringList()<<"Фамилия"<<"Имя"<<"Отчество", QStringList()<<"Иванов"<<"Сергей"<<"Сергеевич");
 *
 * Переименовать данные.	bool UPDATE(QString strGrafa, QStringList slsKolonki);
 * ПРИМЕР:
 * pdcdb->UPDATE("Фамилия", QStringList()<<"Иванов"<<"Сергеев");
 * 
 * Переименовать данные.	bool UPDATE(QString strGrafa, QString strGrafaParametri, QStringList slsKolonki);
 * ПРИМЕР:
 * pdcdb->UPDATE("Фамилия", "Параметры", QStringList()<<"Иванов"<<"Сергеев");//Изменяет Фамилию в "Параметры"
 *
 * Удалить данные.			bool DELETE(QString strGrafa, QString strKolonka);
 * ПРИМЕР:
 * pdcdb->DELETE("Фамилия", "Сергеев");
 *
 * Читаем данные из БД.		QString SELECT(QString strGrafa, QString strKolonka, QString strChitaemayaGrafa);
 * ПРИМЕР:
 * QString strImya = pdcdb->SELECT("Фамилия", "Иванов", "Имя");
 *
 * Количества строк в БД.	quint64 SELECT(void);
 * ПРИМЕР:
 * quint64 ullKolichestvo = pdcdb->SELECT();
 *
 * Считаем совпадения в БД.	quint64 SELECT(QString strGrafa, QString strKolonka);
 * ПРИМЕР:
 * quint64 ullKolichestvo = pdcdb->SELECT("Фамилия", "Иванов");
 *
 * Считаем совпадения в БД.	quint64 SELECT(QStringList slsGrafi, QStringList slsKolonki);
 * ПРИМЕР:
 * quint64 ullKolichestvo = pdcdb->SELECT(QStringList()<<"Фамилия"<<"Имя", QStringList()<<"Иванов"<<"Иван");
 *
 * Возвращаем максимальное число Primary Key в БД. quint64 SELECTPK(void);
 * ПРИМЕР:
 * quint64 ullKolichestvo = pdcdb->SELECTPK();
 *
 * Запрос на просмотр таблицы с параметрами, сортировкой и лимитом отображения.
 * QSqlQuery SELECT(bool blUdalitDB, QString strZapros, QString strOrderBy, int ntLimit, int ntSdvig);
 * ПРИМЕР:
	..........объявление............
	DCDB* m_pdbGruppi = nullptr;
	QSqlQueryModel* m_pqrmTablica = nullptr;
	QSortFilterProxyModel* m_psfpmTablica = nullptr;
 	..........конструктор............
	m_pdbGruppi = new DCDB("QPSQL", strConnImyaDB, "группы");//Таблица с данными.
	m_pdbGruppi->setHostName(strConnHost);//Адрес IP задаём.
	m_pdbGruppi->setPort(untConnPort);//Устанавливаем порт подключения к БД.
	m_pdbGruppi->setUserName(strConnLogin);//Пользователь.
	m_pdbGruppi->setPassword(strConnParol);//Устанавливаем пароль.
	m_pdbGruppi->CREATE(QStringList()<<"#Код"<<"Группа"<<"Описание");
	...........метод............
 	if(!m_psfpmTablica){//Если это первый запуск метода, то...
		m_pqrmTablica = new QSqlQueryModel(this);//Создаем модель
		m_psfpmTablica = new QSortFilterProxyModel(this);//Модель сортирующая таблицу
		m_psfpmTablica->setSourceModel(m_pqrmTablica);//Добавляем таблицу считаную из БД в сортировк
		ui->ptvwTablica->setModel(m_psfpmTablica);//Отображаем сортированную таблицу
		ui->ptvwTablica->show();//Показываем содержимое БД
	}
	m_pqrmTablica->setQuery(m_pdbGruppi->SELECT(false, "", "Группа", 100, 0));
	//false - не удалять соединение с БД.
	//"" - без запроса. А с запросом: "(\"Группа\" = 'РЕЗЕРВ')" - отобразятся только группы с РЕЗЕРВ.
	//"Группа" - сортировка по Графе Группа, если будет "" - то без сортировки.
	//100 - отображать данные порциями по 100 строк.
	//0 - отобразятся первые 100 строк, если будет 1, то отобразятся строки от 101 до 200.
	...........закрытие...........
	if(m_pqrmTablica)//Если указатель не нулевой, то...
		m_pqrmTablica->setQuery(m_pdbGruppi->SELECT(true, "", "", 0, 0));//Закрываем БД, делаем нулевой запрос
	delete m_pqrmTablica;
	m_pqrmTablica = nullptr;
	delete m_psfpmTablica;
	m_psfpmTablica = nullptr;

 * Запрос с поиском, параметрами, сортировкой и лимитом отображения.
 * QSqlQuery LIKE(bool blUdalitDB, QStringList slsConcat, QString strLike, QString strZapros,
 *                QString strOrderBy, int ntLimit, int ntSdvig);
 * ПРИМЕР:
 	..........объявление............
	DCDB* m_pdbGruppi = nullptr;
	QSqlQueryModel* m_pqrmPoisk = nullptr;
	QSortFilterProxyModel* m_psfpmPoisk = nullptr;
 	..........конструктор............
	m_pdbGruppi = new DCDB("QPSQL", strConnImyaDB, "группы");//Таблица с данными.
	m_pdbGruppi->setHostName(strConnHost);//Адрес IP задаём.
	m_pdbGruppi->setPort(untConnPort);//Устанавливаем порт подключения к БД.
	m_pdbGruppi->setUserName(strConnLogin);//Пользователь.
	m_pdbGruppi->setPassword(strConnParol);//Устанавливаем пароль.
	m_pdbGruppi->CREATE(QStringList()<<"#Код"<<"Группа"<<"Описание");
	...........метод............
 	if(!m_psfpmPoisk){//Если это первый запуск метода, то...
		m_pqrmPoisk = new QSqlQueryModel(this);//Создаем модель
		m_psfpmPoisk = new QSortFilterProxyModel(this);//Модель сортирующая таблицу
		m_psfpmPoisk->setSourceModel(m_pqrmTablica);//Добавляем таблицу считаную из БД в сортировк
		ui->ptvwTablica->setModel(m_psfpmTablica);//Отображаем сортированную таблицу
	}
	m_pqrmPoisk->setQuery(m_pdbGruppi->LIKE(false,QStringList()<<"Код"<<"Группа","РЕЗЕРВ","","Группа",100,0));
	ui->ptvwTablica->show();//Показываем содержимое БД
	//false - не удалять соединение с БД.
	//QStringList()<<"Код"<<"Группа" - искать в графах Код и Группа.
	//"РЕЗЕРВ" - это поисковой запрос, как раз то, что ищем. Запрос может быть не полным: "РЕЗЕ".
	//"" - без запроса. А с запросом: "(\"Группа\" = 'РЕЗЕРВ')" - отобразятся только группы с РЕЗЕРВ.
	//"Группа" - сортировка по Графе Группа, если будет "" - то без сортировки.
	//100 - отображать данные порциями по 100 строк.
	//0 - отобразятся первые 100 строк, если будет 1, то отобразятся строки от 101 до 200.
	...........закрытие...........
	if(m_pqrmPoisk)//Если указатель не нулевой, то...
		m_pqrmPoisk->setQuery(m_pdbGruppi->SELECT(true, QStringList(), "", "", "", 0, 0));//Закрываем БД.
	delete m_pqrmPoisk;
	m_pqrmPoisk = nullptr;
	delete m_psfpmPoisk;
	m_psfpmPoisk = nullptr;

 * Пустой запрос. 			QSqlQuery CLEAR();
 * ПРИМЕР:
 	if(m_pqrmTablica)//Если не нулевой указатель, то...
		m_pqrmTablica->setQuery(m_pdbPodgruppi->CLEAR());//Опустошаем таблицу.

 * Если функция выполнила поставленную задачу, то она возвращает:							true
 * Если произошла ошибка, или введены неправильные параметры в функцию, она возвращает: 	false
 * Так же при ошибке, функция излучает СИГНАЛ который содержит расшифровку ошибки:
 * ПРИМЕР: qdebug("расшифровка ошибки!);
 */
