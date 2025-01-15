﻿#include "dcfiledialog.h"


DCFileDialog::DCFileDialog(QObject* proditel) : QObject(proditel){//Конструктор.
////////////////////////////////
//---К О Н С Т Р У К Т О-Р----//
////////////////////////////////
    m_pdrPut = new QDir (QDir::home());//Путь дериктории, который необходимо отобразить.
    m_blFileDialogPervi = true;//Первый запуск проводника - это истина.
}

DCFileDialog::~DCFileDialog(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////
    delete m_pdrPut;//Удаляем указатель.
    m_pdrPut = nullptr;//Обнуляем указатель.
}

bool DCFileDialog::ustFileDialogPut(QString strFileDialogPut){//Установить новый путь отображаемой папки.
///////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т Ь   П А П К И---//
///////////////////////////////////////////////////
    if(!strFileDialogPut.isEmpty()){//Если путь не пустой, то...
        qDebug()<<"Каталог: "<< strFileDialogPut;
        m_pdrPut->cd(strFileDialogPut);
        qDebug()<<&m_pdrPut;
        return true;//Путь новый установлен.
    }
    return false;//Путь не установлен новый.
}

QString DCFileDialog::polSpisokJSON(){//Метод создающий список каталогов и файлов конкретной дериктории.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   J S O N---//
/////////////////////////////////////////////////
    QStringList slsMaska = QStringList() << "*";

    QStringList slsPapki = m_pdrPut->entryList(QDir::Dirs);
    QStringList slsFaili = m_pdrPut->entryList(slsMaska, QDir::Files);
    qDebug() << "Папки: " << slsPapki;
    qDebug() << "Файлы: " << slsFaili;
    QString strFileDialogJSON("");//Строка, собирающая JSON команду.
    quint64 ullKolichestvoPapok = slsPapki.size();//Количество папок.
    quint64 ullKolichestvoFailov = slsFaili.size();//Количество файлов.
    //Пример: [{"tip":"0","filedialog":".."},{"tip":"1","filedialog":"Doc"},{"tip":"2","filedialog":"схема.pdf"}]
    //Где: 0 - назад в каталоге, 1 - папки, 2 - файл.pdf
    strFileDialogJSON = "[";//Начало массива объектов
    for (quint64 ullShag = 0; ullShag < ullKolichestvoPapok; ullShag++){//Цикл папок.
        if(slsPapki[ullShag] != "."){//Если это не ".", то...
            strFileDialogJSON = strFileDialogJSON + "{";//Открываем скобки.
            if(slsPapki[ullShag] == "..")//Если это папка назад "..", то...
                strFileDialogJSON = strFileDialogJSON + "\"tip\":\"0\",";//Папка назад.
            else//Если нет, то папка
                strFileDialogJSON = strFileDialogJSON + "\"tip\":\"1\",";//Папка
            //strFileDialogJSON = strFileDialogJSON + "\"filedialog\":\"["	+ slsPapki[ullShag] + "]\"";
            strFileDialogJSON = strFileDialogJSON + "\"filedialog\":\""	+ slsPapki[ullShag] + "\"";
            strFileDialogJSON = strFileDialogJSON + "}";//Конец списка объектов.
            if (ullShag == (ullKolichestvoPapok-1)){//Если это последняя папка, то...
                if(!ullKolichestvoFailov)//Если файлов в данной папке нет, то запятую не ставим.
                    break;//Выходим из цикла.
            }
            strFileDialogJSON = strFileDialogJSON + ",";//ставим запятую.
        }
    }
    for (quint64 ullShag = 0; ullShag < ullKolichestvoFailov ; ullShag++){//Цикл файлов.
        strFileDialogJSON = strFileDialogJSON + "{";//Открываем скобки.
        strFileDialogJSON = strFileDialogJSON + "\"tip\":\"2\",";//files.pdf
        strFileDialogJSON = strFileDialogJSON + "\"filedialog\":\""	+ slsFaili[ullShag] + "\"";
        strFileDialogJSON = strFileDialogJSON + "}";//Конец списка объектов.
        if (ullShag == (ullKolichestvoFailov -1))//Если это последний файл, то...
            break;//Выходим из цикла.
        strFileDialogJSON = strFileDialogJSON + ",";//ставим запятую.
    }
    strFileDialogJSON = strFileDialogJSON + "]";//Конец массива объектов.
    return strFileDialogJSON;
}
