import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
//Страница с отображением Участков Цеха для управления потолочным освещением.
Item {
    id: tmSvet
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
	property alias radiusZona: rctZona.radius
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            ntWidth: tmSvet.ntWidth
            ntCoff: tmSvet.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            anchors.margins: tmSvet.ntCoff/2
            clrKnopki: tmSvet.clrTexta
            onClicked: {
				tmSvet.clickedNazad();
            }
        }
    }
    Item {//Данные Зона
		id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
		}
    }
    Item {//Данные Тулбар
		id: tmToolbar
    }
}
