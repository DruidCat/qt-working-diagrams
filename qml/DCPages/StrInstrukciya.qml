﻿import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница с отображением инструкций
Item {
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "Orange"
	property color clrFona: "Black"
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
	property alias radiusZona: txdZona.radius
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property string strInstrukciya: "obavtore"
    //Настройки.
	anchors.fill: parent//Растянется по Родителю.
    focus: true;//Чтоб работали горячие клавиши.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    //Функуции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
            if (event.key === Qt.Key_Left){//Если нажата клавиша стрелка влево, то...
                if(knopkaNazad.visible)//Если кнопка Назад видимая, то...
                    fnClickedNazad();//Функция нажатия кнопки Назад
                event.accepted = true;//Завершаем обработку эвента.
            }
        }
    }
    function fnClickedNazad() {//Функция нажатия кнопки Назад
        root.clickedNazad();
    }
    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад.
        }
    }
    Item {//Данные Зона
		id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			readOnly: true//Запрещено редактировать текст
            textEdit.selectByMouse: false//Запрещаем выделять текст, то нужно для свайпа Android
			textEdit.textFormat: TextEdit.AutoText//Формат АВТОМАТИЧЕСКИ определяется. Предпочтителен HTML4
            pixelSize: root.ntWidth/2*root.ntCoff//размер шрифта текста в два раза меньше.
            text: 	""//По умолчанию пустая строка.
            radius: root.ntCoff/4//Радиус возьмём из настроек элемента qml через property
            clrFona: root.clrFona//Цвет фона рабочей области
            clrTexta: root.clrTexta//Цвет текста
            clrBorder: root.clrTexta//Цвет бардюра при редактировании текста.
			italic: true//Текст курсивом.
		}
    }
    Item {//Данные Тулбар
		id: tmToolbar
    }
    Component.onCompleted: {//Когда страница отрисовалась, то...
        if (strInstrukciya === "oprilojenii"){//Если это анотация Об приложении Ментор, то...
            //Любые пробелы и табы в тексте отобразятся в приложении.
			txdZona.text = qsTr("
				<html>
					<body>
<p><center><font color=\"black\">.<img src = \"/images/ts-rus-color.svg\">.</font></center></p>
<p><center>Приложение: <b>Ментор</b></center></p>
<p><center>Версия: <b>v0.33</b></center></p>
<p><center>Сайт: <a href=\"https://tmk-group.ru\">tmk-group.ru</a></center></p>
<p><center>Приложение скомпилированно с <b>Qt версии 6.8.2</b></centers></p>
<p><center>Лицензия: <b>GPLv3</b></centers></p>
<p><center>Git URL: <a href=\"https://github.com/DruidCat/qt-working-diagrams\">\
github.com/DruidCat/qt-working-diagrams</a></center></p>
<p><center>Адресс электронной почты: <a href=\"druidcat@yandex.ru\">druidcat@yandex.ru</a></center></p>
<p><center>&copy;2025. Разработчик <b>Синебрюхов Сергей Владимирович</b></center></p>
<p><center><b>Хорошая идея может отличаться от плохой всего одним словом: Удобно!</b></center></p>
<p>Здравствуйте! Идея создания приложения пришла мне на работе, когда возникла нехватка рабочего персонала \
на других участках. И встала острая необходимость иметь под рукой полный набор документации на всё \
оборудование здесь и сейчас. Мной было принято решение разработать универсальное приложение для смартфона и \
персонального компьютера, где можно будет создавать каталоги документов и в удобном виде просматривать их. \
Что позволило сократить адаптацию на новых участках работы и более эффективно выполнять свои должностные \
обязанности.</p>
<p>От разработки и создания данного приложения мной было получено огромное удовольствие. Надеюсь оно вам \
понравится, и принесёт пользу.</p>
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
<p><b>ФУНКЦИОНАЛ:</b></p>
<p><b>(&lt;)</b> - Вернуться в предыдущую папку.</p>
<p><b>(Х)</b> - Закрыть ваш проводник.</p>
<p><b>:</b> - Меню вашего проводника.</p>
<p><b>(i)</b> - Инструкция по проводнику.</p>
<p><b>[..]</b> - Вернуться в предыдущую папку.</p>
<p><b>[папка]</b> - Квадратными скобками обозначаются папки.</p>
<p><b>док.pdf</b> - Документ который можно добавить в приложение.</p>
						</body>
					</html>");
            }
			else{
				if(strInstrukciya === "oqt"){
				txdZona.text = qsTr("
					<html>
						<body>
<p><center><img src = \"/images/Qt_logo_2016.png\"></center></p>
<p>This program uses Qt version 6.8.2.</p>
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
<p>Copyright (C) 2025 The Qt Company Ltd and other contributors.</p>
<p>Qt and the Qt logo are trademarks of The Qt Company Ltd.</p>
<p>Qt is The Qt Company Ltd product developed as an open source project. \
See <a href=\"http://qt.io\">qt.io</a> for more information.</p>
						</body>
                    </html>");
				}
                else{
                    if(strInstrukciya === "animaciya"){
                        txdZona.text = qsTr("
                            <html>
                                <body>
<p>Данная страница необходима для создания анимированных заставок обучающих роликов.</p>
<p>Введёный вами текск будет увеличиваться вместе с логотипом компании. Данную анимацию можно снять \
приложением захвата экрана, например ShareX. И добавить на этапе монтажа в обучающий ролик.</p>
<p><b>ФУНКЦИОНАЛ:</b></p>
<p><b>(&lt;)</b> Вернуться в Меню программы Ментор.</p>
<p><b>(i)</b> Инструкция по анимации.</p>
<p><b>(+)</b> Добавить текст, который будет увеличиваться с логотипом.</p>
<p><b>ГОРЯЧИЕ КЛАВИШИ:</b></p>
<p><b>[Ctrl N]</b> или <b>[Shift I]</b> - Режим добавления текста анимации.</p>
<p><b>[Ctrl S]</b> или <b>[Enter]</b> - Сохранить текст анимации.</p>
<p><b>[Пробел]</b> - Старт анимации.</p>
<p><b>[Escape]</b> - Отмена действия.</p>
<p><b>: МЕНЮ.</b></p>
<p><b>[Добавить]</b> - Добавить текс, который будет увеличиваться с логотипом.</p>
<p><b>[Старт]</b> - Старт анимации.</p>
<p><b>[Без рамки]</b> - Без рамки.</p>
<p><b>[Рамка 16:9]</b> - Показ рамки для съёмки видео в пропорции экрана 16:9.</p>
<p><b>[Закрыть]</b> - Закрыть приложение Ментор.</p>
                                </body>
                            </html>");
                    }
					else{
						if(strInstrukciya === "hotkey"){
							txdZona.text = qsTr("
								<html>
									<body>
    <p><b>МЕНТОР:</b></p>
    <p><b>[F1]</b> - Описание.</p>
    <p><b>[Alt F]</b> - Настройки.</p>
    <p><b>[Alt Стрелка влево]</b> - Нажитие кнопки влево.</p>
    <p><b>[Alt Стрелка вправо]</b> - Нажитие кнопки вправо.</p>
    <p><b>[Стрелка вверх]</b> или <b>[K]</b> - Листание списка вверх.</p>
    <p><b>[Стрелка вниз]</b> или <b>[J]</b> - Листание списка вниз.</p>
    <p><b>[Ctrl N]</b> или <b>[Shift I]</b> - Создать новый элемент.</p>
    <p><b>[Ctrl S]</b> или <b>[Enter]</b> - Сохранить изменения в элементе.</p>
    <p><b>[Escape]</b> - Отмена действия.</p>
    <p><b>ПРОСМОТРЩИК ДОКУМЕНТОВ:</b></p>
	<p><b>[PgUp]</b> - Страница вверх.</p>
	<p><b>[PgDn]</b> - Страница вниз.</p>
	<p><b>[Ctrl +]</b> - Масштаб увеличить.</p>
	<p><b>[Ctrl -]</b> - Масштаб уменьшить.</p>
	<p><b>[Ctrl F]</b> - Включить режим поиска.</p>
    <p><b>[Ctrl S]</b> или <b>[Enter]</b> - Начать поиск.</p>
    <p><b>[Escape]</b> - Отмена поиска.</p>
	<p><b>[F3]</b> - Поиск следующий.</p>
	<p><b>[Shift F3]</b> - Поиск предыдущий.</p>
	<p><b>[Shift Ctrl +]</b> - Поворот документа по часовой стрелки.</p>
	<p><b>[Shift Ctrl -]</b> - Поворот документа против часовой стрелки.</p>
    <p><b>ОПИСАНИЕ:</b></p>
    <p><b>[Ctrl F]</b> - Навигатор.</p>
    <p><b>[Ctrl N]</b> или <b>[Shift I]</b> - Режим редактирования текста.</p>
    <p><b>[Ctrl S]</b> - Сохранить изменения текста.</p>
    <p><b>[Стрелка вверх]</b> или <b>[K]</b> - Листание текста вверх.</p>
    <p><b>[Стрелка вниз]</b> или <b>[J]</b> - Листание текста вниз.</p>
	<p><b>АНИМАЦИЯ:</b></p>
    <p><b>[F1]</b> - Инструкция.</p>
    <p><b>[Ctrl N]</b> или <b>[Shift I]</b> - Режим добавления текста анимации.</p>
    <p><b>[Ctrl S]</b> или <b>[Enter]</b> - Сохранить текст анимации.</p>
    <p><b>[Пробел]</b> - Старт анимации.</p>
    <p><b>[Escape]</b> - Отмена действия.</p>
                                    </body>
								</html>");
						}
					}
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
