import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
//Страница с отображением инструкций
Item {
    id: tmInstrukciya
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
	property color clrFona: "black"
	property alias zagolovokX: tmZagolovok.x
	property alias zagolovokY: tmZagolovok.y
	property alias zagolovokWidth: tmZagolovok.width
	property alias zagolovokHeight: tmZagolovok.height
	property alias zonaX: tmZona.x
	property alias zonaY: tmZona.y
	property alias zonaWidth: tmZona.width
	property alias zonaHeight: tmZona.height
	property alias toolbarX: tmToolbar.x
	property alias toolbarY: tmToolbar.y
	property alias toolbarWidth: tmToolbar.width
	property alias toolbarHeight: tmToolbar.height
	property alias radiusTextEdit: txdZona.radius
    property string strInstrukciya: "obavtore"
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            ntWidth: tmInstrukciya.ntWidth
            ntCoff: tmInstrukciya.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            anchors.margins: tmInstrukciya.ntCoff/2
            clrKnopki: tmInstrukciya.clrTexta
            onClicked: {
                tmInstrukciya.clickedNazad();
            }
        }
    }
    Item {//Данные Зона
		id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
		DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
            ntWidth: tmInstrukciya.ntWidth
            ntCoff: tmInstrukciya.ntCoff
			readOnly: true//Запрещено редактировать текст
            text: 	""//По умолчанию пустая строка.
            radius: tmInstrukciya.ntCoff/4//Радиус возьмём из настроек элемента qml через property
            clrFona: tmInstrukciya.clrFona//Цвет фона рабочей области
            clrTexta: tmInstrukciya.clrTexta//Цвет текста
            clrBorder: tmInstrukciya.clrTexta//Цвет бардюра при редактировании текста.
			italic: true//Текст курсивом.
		}
    }
    Item {//Данные Тулбар
		id: tmToolbar
    }
    Component.onCompleted: {//Когда страница отрисовалась, то...
        if (strInstrukciya === "obavtore"){//Если это анотация Об Авторе приложения, то...
            //Любые пробелы и табы в тексте отобразятся в приложении.
            txdZona.text = qsTr("Здравствуйте, данную программу написал в свободное от работы время Синебрюхов \
Сергей Владимирович. Идея данной программы возникла на работе, когда стало необходимо иметь под рукой полный \
набор документации здесь и сейчас и не было времени идти за ней к компьютеру. И было решено написать \
универсальное приложение для телефона и компьютера, где можно было создавать каталоги документов и в удобном \
виде просматривать их. От написания данного приложения было получено огромное удовольствие. Надеюсь оно вам \
так же понравилось, и принесло пользу.\n\
Лицензия: GPLv3\n\
Исходный код проекта: https://github.com/DruidCat/qt-working-diagrams\n\
Адресс электронной почты: druidcat@yandex.ru");
        }
        else{
            if(strInstrukciya === "fdinstrukciya"){//Если это Инструкция Проводника, то...
                //Любые пробелы и табы в тексте отобразятся в приложении.
                txdZona.text = qsTr("В Проводнике выбирайте PDF документы, которые хотите добавить в приложение. \
Навигация в проводнике возможна в пределах вашей дамашней дериктории. Если документы расположены в другой \
дериктории или на другом накопителе, то заранее переместите их в домашнюю дерикторию.\n\
Навигация:\n\
<\tВернуться в предыдущую папку.\n\
X\tЗакрыть ваш проводник.\n\
...\tМеню вашего проводника.\n\
i\tИнструкция по проводнику.\n\
[..]\tВернуться в предыдущую папку.\n\
[папка]\tКвадратными скобками обозначаются папки.\n\
док.pdf\tДокумент который можно добавить в приложение.");
            }
        }
    }
}
