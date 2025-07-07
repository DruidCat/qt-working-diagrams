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
            id: tphKnopkaMenu
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaMenu
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle{
		id: rctKnopkaMenu
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: tphKnopkaMenu.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaMenu.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona

		Rectangle{
			id: rctKnopkaVerh
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.top: rctKnopkaMenu.top
			anchors.left: rctKnopkaMenu.left

            color: tphKnopkaMenu.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaSeredina
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.verticalCenter: rctKnopkaMenu.verticalCenter
			anchors.left: rctKnopkaMenu.left

            color: tphKnopkaMenu.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaNiz
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.bottom: rctKnopkaMenu.bottom
			anchors.left: rctKnopkaMenu.left

            color: tphKnopkaMenu.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaMenu.width/4
        } 
	}	
}
