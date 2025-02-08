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
        if (strInstrukciya === "oprilojenii"){//Если это анотация Об приложении Рабочие Схемы, то...
            //Любые пробелы и табы в тексте отобразятся в приложении.
			txdZona.text = qsTr("
				<html>
					<body>
<p><center>.<img src = \"images/ru.WorkingDiagrams.png\"></center></p>
<p><center>Приложение: <b>РАБОЧИЕ СХЕМЫ.</b></center></p>
<p><center>Версия: <b>v0.33</b></center></p>
<p><center>Сайт: <a href=\"https://tmk-group.ru\">tmk-group.ru</a></center></p>
<p><center>Приложение скомпилированно с <b>Qt версии 5.15.16</b></centers></p>
<p><center>Лицензия: <b>GPLv3</b></centers></p>
<p><center>Git URL: <a href=\"https://github.com/DruidCat/qt-working-diagrams\">\
github.com/DruidCat/qt-working-diagrams</a></center></p>
<p><center>Адресс электронной почты: <a href=\"druidcat@yandex.ru\">druidcat@yandex.ru</a></center></p>
<p><center>&copy;2025. Разработчик <b>Синебрюхов Серегей Владимирович</b></center></p>
<p>Здравствуйте, данную программу написал в свободное от работы время \
Синебрюхов Сергей Владимирович. Идея данной программы возникла на работе, когда стало необходимо иметь под \
рукой полный набор документации здесь и сейчас и не было времени идти за ней к компьютеру. И было решено \
написать универсальное приложение для телефона и компьютера, где можно было создавать каталоги документов и \
в удобном виде просматривать их. От написания данного приложения было получено огромное удовольствие. \
Надеюсь оно вам так же понравилось, и принесло пользу.</p>
					</body>
				</html>");
        }
        else{
            if(strInstrukciya === "fdinstrukciya"){//Если это Инструкция Проводника, то...

                txdZona.text = qsTr("
					<html>
						<body>
<p>В Проводнике выбирайте PDF документы, которые хотите добавить в приложение.</p>
<p>Навигация в проводнике возможна в пределах вашей дамашней дериктории. Если документы расположены в другой \
дериктории или на другом накопителе, то заранее переместите их в домашнюю дерикторию.</p>
<p>Навигация:</p>
<p><pre>&lt;	Вернуться в предыдущую папку.</pre></p>
<p><pre>Х	Закрыть ваш проводник.</pre></p>
<p><pre>...	Меню вашего проводника.</pre></p>
<p><pre>i	Инструкция по проводнику.</pre></p>
<p><pre>[..]	Вернуться в предыдущую папку.</pre></p>
<p><pre>[папка]	Квадратными скобками обозначаются папки.</pre></p>
<p><pre>док.pdf	Документ который можно добавить в приложение.</pre></p>
						</body>
					</html>");
            }
			else{
				if(strInstrukciya === "oqt"){
				txdZona.text = qsTr("
					<html>
						<body>
<p><center><img src = \"images/Qt_logo_2016.png\"></center></p>
<p>This program uses Qt version 5.15.16.</p>
<p>Qt is a C++ toolkit for cross-platform application development.</p>
<p>Qt provides single-source portability across all major desktop operating systems. It is also available \
for embedded Linux and other embedded and mobile operating systems.</p>
<p>Qt is available under multiple licensing options designed to accommodate the needs of our various \
users.</p>
<p>Qt licensed under our commercial license agreement is appropriate for development of \
proprietary/commercial software where you do not want to share any source code with third parties or \
otherwise cannot comply with the terms of GNU (L)GPL.</p>
<p>Qt licensed under GNU (L)GPL is appropriate for the development of Qt applications provided you can \
comply with the terms and conditions of the respective licenses.</p>
<p>Please see <a href=\"http://qt.io/licensing/\">qt.io/licensing</a> for an overview of Qt licensing.</p>
<p>Copyright (C) 2023 The Qt Company Ltd and other contributors.</p>
<p>Qt and the Qt logo are trademarks of The Qt Company Ltd.</p>
<p>Qt is The Qt Company Ltd product developed as an open source project. \
See <a href=\"http://qt.io\">qt.io</a> for more information.</p>
						</body>
					</html>
			   ");
				}
			}
        }
    }
}
//Любые пробелы и табы в тексте отобразятся в приложении.
//<html>Корневой элемент, содержащий весь контент страницы.</html>
//<body>Элемент, содержащий видимый контент страницы.</body>
//<h1>Заголовок первого уровня, используется для заголовка страницы.</h>
//<p>Абзац текста, используется для отображения блоков текста.</p>
//<b>Жирный текст</b>
//<i>Курсивный текст</i>
//<u>Подчеркнуть текст</u>
//<center>По центру текст</center>
//<pre>В данной записи сохранятся все tab и пробелы, как задумал разработчик.</pre>
//<a href=\"http://ya.ru\">Яндекс</a> - форма записи ссылок.
//<p><img src = \"images/Qt_logo_2016.png\"></p> - Вставка изображения
//<p><center>.<img src = \"images/Qt_logo_2016.png\"></center></p> - Изображение по центру (поставь точку).
//&lt; - это символ <
//&gt; - это символ >
