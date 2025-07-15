import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница с отладочной информацией.
Item {
    id: root
    //Свойства.
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
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
	property alias radiusZona: txdZona.radius
	property string strDebug: ""//Глобальная переменная, в ней собирается строка со всеми Сообщениями.
    //Настройки.
	anchors.fill: parent//Растянется по Родителю.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    //Функции.
    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: ntWidth*ntCoff+ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                root.clickedNazad();
            }
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
            pixelSize: root.ntWidth/2*root.ntCoff//размер шрифта текста в два раза меньше.
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
	Connections {//Соединяем сигнал из C++ с действием в QML
		target: cppqml;//Цель объект класса С++ DCCppQml
		function onStrDebugChanged(){//Слот Если изменилось сообщение в strDebug (Q_PROPERTY), то...
			let ltDebug = cppqml.strDebug;//Считываем сообщение из переменной.
            if(ltDebug !== ""){//Если не пустая строка, которая затирает старое сообщение в Toolbar, то...
				strDebug = strDebug + ltDebug + "\n";//Пишем текст в переменную из Свойтва Q_PROPERTY
				txdZona.text = strDebug;//Отображаем собранную строку в TextEdit модуле.
			}
		}
	}
}
