#include "odin.h"

Odin::Odin(QString strImyaBD, QString strLoginBD, QString strParolBD, QObject* parent) : QObject{parent}{
///////////////////////////////
//---К О Н С Т Р У К Т О Р---//
///////////////////////////////

    //Настройки соединения к БД Настроек.
    m_strImyaBD = strImyaBD;//Имя локальной базы данных.
    m_strLoginBD = strLoginBD;//Логин локальной базы данных.
    m_strParolBD = strParolBD;//Пароль локальной базы данных.

    m_pdbOdin = new DCDB("QSQLITE", m_strImyaBD, "один");//Таблица с данными по Подключ.
    m_pdbOdin->setUserName(m_strLoginBD);//Пользователь.
    m_pdbOdin->setPassword(m_strParolBD);//Устанавливаем пароль.
    m_pdbOdin->CREATE(QStringList()<<"#Код"<<"Номер"<<"Название"<<"Описание"<<"Список");
}

Odin::~Odin(){//Деструктор
//////////////////////////////
//--- Д Е С Т Р У К Т О Р---//
//////////////////////////////
    delete m_pdbOdin;//Удаляем указатель на БД Один
    m_pdbOdin = nullptr;//Обнуляем указатель.
}
