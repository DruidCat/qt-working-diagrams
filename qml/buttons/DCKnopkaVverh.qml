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
		id: rctKnopkaVverh
        anchors.fill: root

		color: maKnopkaVverh.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
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

			color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
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

			color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVverh.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.verticalCenter
			anchors.left: rctKnopkaVverh.left
			anchors.leftMargin: rctKnopkaVverh.width/8*3

			color: maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVverh.width/4
		}
        MouseArea {
            id: maKnopkaVverh
            anchors.fill: rctKnopkaVverh
            onClicked: {
                root.clicked();
            }
        }
	}	
}
