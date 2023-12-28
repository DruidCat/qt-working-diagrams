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

bool Odin::dbStart() {//Иннициализируем БД, и записываем в нёё данные, если она пустая.
///////////////////////////////////////////
//---З А П И С Ы В А Е М   Д А Н Н Ы Е---//
///////////////////////////////////////////
    if(!m_pdbOdin->SELECT()){//Если нет ни одной записи в таблице, то...
        if(m_pdbOdin->INSERT(QStringList()<<"Номер"<<"Название"<<"Описание"<<"Список",
                              QStringList()<<"1"<<"Формовка"<<"Описание участка формовки."<<"")){
            if(m_pdbOdin->INSERT(QStringList()<<"Номер"<<"Название"<<"Описание"<<"Список",
                                  QStringList()<<"2"<<"Сварка"<<"Описание участка сварки."<<"")){
                if(!m_pdbOdin->INSERT(QStringList()<<"Номер"<<"Название"<<"Описание"<<"Список",
                                       QStringList()<<"3"<<"Отделка"<<"Описание участка отделки."<<"")){
                    return false;//Выход, ошибка.
                }
            }
            else//В противном случае...
                return false;//Выход, ошибка.
        }
        else//Если БД не отрылась, то...
            return false;//Выход, ошибка.
    }
    return true;//Выход, успех!
}

QString Odin::polOdin(int ntNomer) {//Получить данные по номеру
///////////////////////////////////////////
//---П О Л У Ч И Т Ь   Н А З В А Н И Е---//
///////////////////////////////////////////
    QString strNazvanie = m_pdbOdin->SELECT("Номер", QString::number(ntNomer), "Название");
    return strNazvanie;
}
