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
            id: tphKnopkaVpered
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaVpered
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctKnopkaVpered
        anchors.fill: root

        color: tphKnopkaVpered.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaVpered.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaVpered.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

		Rectangle {
			id: rctStrelkaVerh
			visible: true
			width: rctKnopkaVpered.width/4
			height: width
			anchors.top: rctKnopkaVpered.top
			anchors.left: rctKnopkaVpered.left
			anchors.leftMargin: rctKnopkaVpered.width/8*2
			anchors.topMargin: rctKnopkaVpered.width/8

            color: tphKnopkaVpered.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVpered.width/4
		}

		Rectangle {
			id: rctStrelkaNiz
			width: rctKnopkaVpered.width/4
			height: width
			anchors.bottom: rctKnopkaVpered.bottom
			anchors.left: rctKnopkaVpered.left
			anchors.leftMargin: rctKnopkaVpered.width/8*2
			anchors.bottomMargin: rctKnopkaVpered.width/8

            color: tphKnopkaVpered.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVpered.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVpered.width/4
			height: width
			anchors.left: rctKnopkaVpered.horizontalCenter
			anchors.top: rctKnopkaVpered.top
			anchors.topMargin: rctKnopkaVpered.width/8*3

            color: tphKnopkaVpered.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaVpered.width/4
		} 
	}	
}
