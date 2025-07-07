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
    height: tapHeight
    width: tapWidth
    //Сигналы.
    signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaVniz
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaVniz
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctKnopkaVniz
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: tphKnopkaVniz.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaVniz.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaVniz.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: width/8/4
        radius: width/4

		Rectangle {
			id: rctStrelkaVerhPravo
			visible: true
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.top
			anchors.right: rctKnopkaVniz.right
			anchors.topMargin: rctKnopkaVniz.width/8*2
			anchors.rightMargin: rctKnopkaVniz.width/8

            color: tphKnopkaVniz.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVniz.width/4
		}

		Rectangle {
			id: rctStrelkaVerhLevo
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.top
			anchors.left: rctKnopkaVniz.left
			anchors.topMargin: rctKnopkaVniz.width/8*2
			anchors.leftMargin: rctKnopkaVniz.width/8

            color: tphKnopkaVniz.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVniz.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.verticalCenter
			anchors.left: rctKnopkaVniz.left
			anchors.leftMargin: rctKnopkaVniz.width/8*3

            color: tphKnopkaVniz.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVniz.width/4
		} 
	}	
}
