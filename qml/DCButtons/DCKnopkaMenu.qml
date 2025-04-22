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
	Rectangle{
		id: rctKnopkaMenu
        anchors.fill: root

		color: maKnopkaMenu.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona

		Rectangle{
			id: rctKnopkaVerh
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.top: rctKnopkaMenu.top
			anchors.left: rctKnopkaMenu.left

			color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaSeredina
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.verticalCenter: rctKnopkaMenu.verticalCenter
			anchors.left: rctKnopkaMenu.left

			color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaNiz
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.bottom: rctKnopkaMenu.bottom
			anchors.left: rctKnopkaMenu.left

			color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaMenu.width/4
        }
        MouseArea {
            id: maKnopkaMenu
            anchors.fill: rctKnopkaMenu
            onClicked: {
                root.clicked();
            }
        }
	}	
}
