import QtQuick //2.15
import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
//Страница с отображением Плана цеха.
Item {
    id: root
    //Свойства
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
    property bool appRedaktor: false//true - включить Редактор приложения.
    //Настройки
	anchors.fill: parent//Растянется по Родителю.
    //Сигналы
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedSozdat();//Сигнал нажатия кнопки Создать

    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            onClicked: {
                root.clickedNazad();
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
        DCKnopkaSozdat {//@disable-check M300
            id: knopkaSozdat
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            visible: root.appRedaktor ? true : false//Настройка вкл/вык Редактор приложения.
            onClicked: {
                root.clickedSozdat();//Сигнал нажатия кнопки Создать
            }
        }
    }
}
