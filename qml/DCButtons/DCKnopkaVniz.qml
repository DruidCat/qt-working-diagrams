import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item{
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"
    //Настройки.
	width: ntWidth*ntCoff
	height: width
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
        anchors.fill: root

        color: tphKnopkaVniz.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaVniz.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaVniz.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

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
