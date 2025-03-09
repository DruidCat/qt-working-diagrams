import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
//Страница с отладочной информацией.
Item {
    id: tmDebug
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
	property alias radiusZona: txdZona.radius
	property string strDebug: ""//Глобальная переменная, в ней собирается строка со всеми Сообщениями.
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
            ntWidth: tmDebug.ntWidth
            ntCoff: tmDebug.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            anchors.margins: tmDebug.ntCoff/2
            clrKnopki: tmDebug.clrTexta
            onClicked: {
				tmDebug.clickedNazad();
            }
        }
    }
    Item {//Данные Зона
		id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCTextEdit {//@disable-check M300//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
			ntWidth: tmDebug.ntWidth
			ntCoff: tmDebug.ntCoff
			readOnly: true//Запрещено редактировать текст
			radius: tmDebug.ntCoff/4//Радиус возьмём из настроек элемента qml через property
			clrFona: tmDebug.clrFona//Цвет фона рабочей области
			clrTexta: tmDebug.clrTexta//Цвет текста
			clrBorder: tmDebug.clrTexta//Цвет бардюра при редактировании текста.
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
