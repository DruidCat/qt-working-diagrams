import QtQuick //2.15

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
	Rectangle {
		id: rctKnopkaVniz
        anchors.fill: root

		color: maKnopkaVniz.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
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

			color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
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

			color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVniz.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.verticalCenter
			anchors.left: rctKnopkaVniz.left
			anchors.leftMargin: rctKnopkaVniz.width/8*3

			color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVniz.width/4
		}
        MouseArea {
            id: maKnopkaVniz
            anchors.fill: rctKnopkaVniz
            onClicked: {
                root.clicked();
            }
        }
	}	
}
