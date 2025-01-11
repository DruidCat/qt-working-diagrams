#ifndef DCDBDATA_H
#define DCDBDATA_H

#include <QObject>
#include <QtSql>
#include <QtDebug>
#include <QString>
#include <QDate>
#include <QTime>
#include <QFile>
#include <QDir>
#include <QByteArray>

class DCDBData : public QObject{
	Q_OBJECT

public:
	explicit DCDBData(const QString strImyaDB, const QString strImyaTablici, const qint64 llntRazmer,
            QObject* proditel = nullptr);//Конструктор.
    explicit DCDBData(const QString strImyaDB,const qint64 llntRazmer,QObject* proditel = nullptr);
	~DCDBData();//Деструктор.
	bool 	CREATE();//Метод создающий пустую таблицу в БД с выделенным местом под файл.
	bool 	DROP();//Метод удаляющий таблицу в БД.
	bool 	SELECT();//Метод проверяющий наличие таблицы в БД.
	bool	write(QString strPut);//Метод записи Файла в базу данных.
	bool	read(QString strPut);//Метод чтения файла из базы данных и запись его в Файл.
	QDateTime lastModified();//Возвращает данные по дате и времени записи файла в БД.
	qint64	getMaxSize(){ return m_llntRazmer/1024; }//Получить заданный максимальный размер файла в кБайтах
	QString baseName();//Возвращает имя записаного файла в БД.
	QString	suffix();//Возвращаем расшинение записанного файла в БД.

	void 	ustImyaTablici(QString  strImyaTablici)	{ m_strImyaTablici = strImyaTablici; }//Уст. имя таблицы
	QString polImyaDB()						{ return m_strImyaDB; }			//Получить имя базы данных
	QString polImyaTablici()				{ return m_strImyaTablici; }	//Получить имя таблицы
	void 	setHostName(QString strHostName){ m_strHostName = strHostName; }//Установить IP 
	QString getHostName()					{ return m_strHostName; }		//Получить IP
	void 	setUserName(QString strUserName){ m_strUserName = strUserName; }//Установить Имя Пользователя БД
	QString getUserName()					{ return m_strUserName; }		//Получить Имя Пользователя БД
	void 	setPassword(QString strPassword){ m_strPassword = strPassword; }//Установить пароль на БД
	QString getPassword()					{ return m_strPassword; }		//Получить пароль на БД
	void 	setPort(uint untPort)			{ m_untPort = untPort; }		//Установить порт для БД
	uint 	getPort()						{ return m_untPort; }			//Получить порт для БД

private:
	static const uint m_untKolichestvoGraf = 1024;////Количество граф с данными равно 1 килобайт(НЕ ИЗМЕНЯТЬ!)
	QString	m_strImyaDB;//Имя Базы данных, в котором будет лежать таблица с данными
	QString	m_strImyaTablici;//Имя таблици, в которой будут лежать данные
	qint64	m_llntRazmer;//Размер файла в байтах

	QString m_strHostName;//IP адресс подключения к БД
	QString m_strPassword;//Пароль пользователя БД
	QString m_strUserName;//Имя пользователя подключающегося к БД
	uint m_untPort;//Порт подключения к БД

signals:
	void	signalDebug(QString strDebug);//Сигнал, отправляющий строчку в логи
	void 	signalSqlSoedinenie(bool blStatus);//Сигнал соединения к postrgesql серверу.

private slots:
	void	qdebug(QString strDebug){emit signalDebug(strDebug);}//Слот излучающая строчку в Лог
};

#endif // DCDBDATA_H
/////////////////////////////
//---И Н С Т Р У К Ц И Я---//
/////////////////////////////
/*
 * explicit DCDBData(const QString strImyaDB, const QString strImyaTablici, const qint64 llntRazmer,
 * 		QObject* proditel = nullptr);
 *
 * 1) strImyaDB			- имя БД с данными SQL
 * 2) strImyaTablici	- имя таблици SQL, в которой будут хранится данные с данными.
 * 3) llntRazmer		- размер данных в килобайтах, которые будут хранится в БД.
 * ПРИМЕР:
 * DCDBData* pdcdbdata = new DCDBData("компания.dc", "логотип", 256);//Конструктор
 * pdcdbdata->CREATE();//создать таблицу и заполнить её техническими данными.
 *
 * bool DCDBData::write(QString strPut);//Метод записи Файла в базу данных.
 * ПРИМЕР:
 * pdcdbdata->write("C:\logo.png");
 *
 * bool DCDBData::read(QString strPut);//Метод чтения файла из базы данных и запись его в Файл.
 * ПРИМЕР:
 * pdcdbdata->read("D:\logo.png");
 *
 * QDateTime DCDBData::lastModified();//Возвращает данные по дате и времени записи файла в БД.
 * ПРИМЕР:
 * pdcdbdata->lastModified();
 *
 *	qint64 DCDBData::getMaxSize();//Получить заданный максимальный размер файла
 *	ПРИМЕР:
 *	pdcdbdata->getMaxSize();//Возвращает значение в килобайтах
 *	QString DCDBData::baseName();//Возвращает имя записаного файла в БД.
 *	ПРИМЕР:
 *	pdcdbdata->baseName();
 *
 *	QString	DCDBData::suffix();//Возвращаем расшинение записанного файла в БД.
 *	ПРИМЕР:
 *	pdcdbdata->suffix();
 *
 *	Можно на одном указателе создавать множество одинаковых таблиц с разными данными, например фото работников
 *  void DCDBData::ustImyaTablici(QString  strImyaTablici);//Установить имя таблицы.
 *  ПРИМЕР:
 *  DCDBData* pdbFoto = new DCDBData(strConnImyaDB, 128);
 *  pdbFoto->ustImyaTablici("foto_01");
 *  pdbFoto->CREATE();
 *  pdbFoto->write("C:\foto_01.jpg");
 *  pdbFoto->ustImyaTablici("foto_02");
 *  pdbFoto->CREATE();
 *  pdbFoto->write("C:\foto_02.jpg");
 *
 *  bool DCDBData::DROP();//Метод удаляющий таблицу в БД.
 *  ПРИМЕР:
 *  pdbFoto->ustImyaTablici("foto_01");//Установить имя таблицы.
 * 	pdbFoto->DROP();
*/
