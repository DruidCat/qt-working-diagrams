#include <QStandardPaths>
#include "dcfiledialog.h"

DCFileDialog::DCFileDialog(QStringList slsFileDialogMaska, const QString strDomPut, QObject* proditel)
    :QObject(proditel){//Конструктор.
////////////////////////////////
//---К О Н С Т Р У К Т О-Р----//
////////////////////////////////
    m_pdcclass = new DCClass();//Указатель на класс по работе с текстом.
    m_pdrPut = new QDir (strDomPut);//Путь дериктории, который необходимо отобразить.
    m_strFileDialogImya.clear();//Пустое имя.
    m_strFileDialogPut = m_strFileDialogPutDom = m_pdrPut->absolutePath();//Иннициализируем пути по умолчанию.
    m_slsFileDialogMaska = slsFileDialogMaska;//Задаём параметр маски отображения разширений файлов.
}
DCFileDialog::~DCFileDialog(){//Деструктор.
/////////////////////////////
//---Д Е С Т Р У К Т О Р---//
/////////////////////////////
    delete m_pdcclass;//удаляем указатель.
    m_pdcclass = nullptr;//Обнуляем указатель.
    delete m_pdrPut;//Удаляем указатель.
    m_pdrPut = nullptr;//Обнуляем указатель.
}
bool DCFileDialog::ustImyaPuti(QString strImyaPuti){//Устанавливаем фиксированные пути.
/////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т Ь   К   К А Т А Л О Г У---//
/////////////////////////////////////////////////////////////
    if (strImyaPuti == "dom"){//Если переменная дом, то...
        m_strFileDialogImya.clear();//ОБЯЗАТЕЛЬНО!!! Обнуляем строку с именем файла.
        m_pdrPut->setPath(m_strFileDialogPutDom);//Задаём домашний каталог.
        return true;//Истина.
    }
    else{//Если не переменная Дом, то...
        if(strImyaPuti == "sohranit"){//Если переменная Сохранить текущую деррикторию, то...
            m_strFileDialogImya.clear();//ОБЯЗАТЕЛЬНО!!! Обнуляем строку с именем файла.
            return true;//Истина.
        }
        else{//Если это не флаги были, то путь.
            m_pdrPut->setPath(strImyaPuti);//Задаём путь.
            return true;//Успех
        }
    }
    return false;//не успех.
}
void DCFileDialog::ustFileDialogPut(const QString strFileDialogPut){//Уст путь папки, которую нужно отобразить
/////////////////////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П А П К У   О Т О Б Р А Ж Е Н И Я---//
/////////////////////////////////////////////////////////////////

    if(m_strFileDialogPut != strFileDialogPut){//Если пути не одинаковые, то...
        m_strFileDialogPut = strFileDialogPut;//Сохраняем новый путь.
        m_pdrPut->setPath(m_strFileDialogPut);//Задаём новый каталог отображения.
    }
}
QString DCFileDialog::polFileDialogPut(){//Получить путь к каталогу.
/////////////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   П У Т Ь   К   К А Т А Л О Г У---//
/////////////////////////////////////////////////////////
    m_strFileDialogPut = m_pdrPut->absolutePath();//Получить Абсолютный путь к дерриктории.
    return m_strFileDialogPut;
}
bool DCFileDialog::ustSpisokJSON(QString strFileDialogPut){//Установить новый путь отображаемой папки или Файл
///////////////////////////////////////////////////
//---У С Т А Н О В И Т Ь   П У Т Ь   П А П К И---//
///////////////////////////////////////////////////
    if(!strFileDialogPut.isEmpty()){//Если путь не пустой, то...
        if(m_pdcclass->isFolder(strFileDialogPut)){//Если это [папка], то...
            strFileDialogPut = m_pdcclass->udalitPryamieSkobki(strFileDialogPut);//Удаляем скобки []
            m_pdrPut->cd(strFileDialogPut);//Устанавливаем путь
            return true;//Путь новый установлен.
        }
        else{//Если это файл, то...
            m_strFileDialogImya = strFileDialogPut;//Задаём имя файла.
        }
    }
    return false;//Путь не установлен новый.
}
QString DCFileDialog::polSpisokJSON(){//Метод создающий список каталогов и файлов конкретной дериктории.
/////////////////////////////////////////////////
//---П О Л У Ч И Т Ь   С П И С О К   J S O N---//
/////////////////////////////////////////////////
    if(!m_strFileDialogImya.isEmpty()){//Если Имя файла не постая строка, то...
        return m_strFileDialogImya;//Возвратим имя ФАЙЛА.
    }
    //В список папки, без символьных ссылок, без папок [.]
    QStringList slsPapki = m_pdrPut->entryList(QDir::Dirs | QDir::NoSymLinks | QDir::NoDot);
    QStringList slsFaili = m_pdrPut->entryList(m_slsFileDialogMaska, QDir::Files);//Задаём маску файлов
    QString strFileDialogJSON("");//Строка, собирающая JSON команду.
    quint64 ullKolichestvoPapok = slsPapki.size();//Количество папок.
    quint64 ullKolichestvoFailov = slsFaili.size();//Количество файлов.
    //При: [{"tip":"0","dannie":".."},{"tip":"1","dannie":"Doc"},{"tip":"2","dannie":"схема.pdf"}]
    //Где: 0 - назад в каталоге, 1 - папки, 2 - файл.pdf
    strFileDialogJSON = "[";//Начало массива объектов
    for (quint64 ullShag = 0; ullShag < ullKolichestvoPapok; ullShag++){//Цикл папок.
        if(!m_pdcclass->isHideFolder(slsPapki[ullShag])){//Если не скрытая папка, то..
            if(!m_pdcclass->isLabelFolder(slsPapki[ullShag])){//Если не ярлык папка, то..
                strFileDialogJSON = strFileDialogJSON + "{";//Открываем скобки.
                if(slsPapki[ullShag] == "..")//Если это папка назад "..", то...
                    strFileDialogJSON = strFileDialogJSON + "\"tip\":\"0\",";//Папка назад.
                else//Если нет, то папка
                    strFileDialogJSON = strFileDialogJSON + "\"tip\":\"1\",";//Папка
                strFileDialogJSON = strFileDialogJSON + "\"dannie\":\"["	+ slsPapki[ullShag] + "]\"";
                strFileDialogJSON = strFileDialogJSON + "}";//Конец списка объектов.
                if (ullShag == (ullKolichestvoPapok-1)){//Если это последняя папка, то...
                    if(!ullKolichestvoFailov)//Если файлов в данной папке нет, то запятую не ставим.
                        break;//Выходим из цикла.
                }
                strFileDialogJSON = strFileDialogJSON + ",";//ставим запятую.
            }
        }
    }
    for (quint64 ullShag = 0; ullShag < ullKolichestvoFailov ; ullShag++){//Цикл файлов.
        strFileDialogJSON = strFileDialogJSON + "{";//Открываем скобки.
        strFileDialogJSON = strFileDialogJSON + "\"tip\":\"2\",";//files.pdf
        strFileDialogJSON = strFileDialogJSON + "\"dannie\":\""	+ slsFaili[ullShag] + "\"";
        strFileDialogJSON = strFileDialogJSON + "}";//Конец списка объектов.
        if (ullShag == (ullKolichestvoFailov -1))//Если это последний файл, то...
            break;//Выходим из цикла.
        strFileDialogJSON = strFileDialogJSON + ",";//ставим запятую.
    }
    strFileDialogJSON = strFileDialogJSON + "]";//Конец массива объектов.
    return strFileDialogJSON;
}
