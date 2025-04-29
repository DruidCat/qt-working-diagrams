import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
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
            id: tphKnopkaInfo
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaInfo
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctKnopkaInfo
        anchors.fill: root

        color: tphKnopkaInfo.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaInfo.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

		Rectangle {
			id: rctBukvaTochka
			visible: true
			width: rctKnopkaInfo.width/4
			height: width
			anchors.top: rctKnopkaInfo.top
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter
			anchors.topMargin: rctKnopkaInfo.width/8

            color: tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaInfo.width/4
		}

		Rectangle {
			id: rctBukvaPalochka1
			width: rctKnopkaInfo.width/4
			height: rctKnopkaInfo.width/8
			anchors.top: rctKnopkaInfo.verticalCenter
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter

            color: tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }

		Rectangle {
			id: rctBukvaPalochka2
			width: rctKnopkaInfo.width/4
			height: rctKnopkaInfo.width/4
			anchors.top: rctBukvaPalochka1.bottom
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter

            color: tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
	}
}

