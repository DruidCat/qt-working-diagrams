import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item{
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"
    property real tapHeight: ntWidth*ntCoff//Высота зоны нажатия пальцем или мышкой
    property real tapWidth: ntWidth*ntCoff//Ширина зоны нажатия пальцем или мышкой
    //Настройки.
	width: ntWidth*ntCoff
	height: width
    //Сигналы.
	signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaVverh
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaVverh
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctKnopkaVverh
        anchors.fill: root

        color: tphKnopkaVverh.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaVverh.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

		Rectangle {
			id: rctStrelkaNizPravo
			visible: true
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.bottom
			anchors.right: rctKnopkaVverh.right
			anchors.bottomMargin: rctKnopkaVverh.width/8*2
			anchors.rightMargin: rctKnopkaVverh.width/8

            color: tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVverh.width/4
		}

		Rectangle {
			id: rctStrelkaNizLevo
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.bottom
			anchors.left: rctKnopkaVverh.left
			anchors.bottomMargin: rctKnopkaVverh.width/8*2
			anchors.leftMargin: rctKnopkaVverh.width/8

            color: tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVverh.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.verticalCenter
			anchors.left: rctKnopkaVverh.left
			anchors.leftMargin: rctKnopkaVverh.width/8*3

            color: tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVverh.width/4
		} 
	}	
}
