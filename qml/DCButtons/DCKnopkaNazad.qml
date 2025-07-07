import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item{
    id: root
    //Свойства
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
            id: tphKnopkaNazad
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaNazad
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctKnopkaNazad
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: tphKnopkaNazad.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaNazad.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaNazad.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: width/8/4
        radius: width/4

		Rectangle {
			id: rctStrelkaVerh
			visible: true
			width: rctKnopkaNazad.width/4
			height: width
			anchors.top: rctKnopkaNazad.top
			anchors.right: rctKnopkaNazad.right
			anchors.rightMargin: rctKnopkaNazad.width/8*2
			anchors.topMargin: rctKnopkaNazad.width/8

            color: tphKnopkaNazad.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNazad.width/4
		}

		Rectangle {
			id: rctStrelkaNiz
			width: rctKnopkaNazad.width/4
			height: width
			anchors.bottom: rctKnopkaNazad.bottom
			anchors.right: rctKnopkaNazad.right
			anchors.rightMargin: rctKnopkaNazad.width/8*2
			anchors.bottomMargin: rctKnopkaNazad.width/8

            color: tphKnopkaNazad.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNazad.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaNazad.width/4
			height: width
			anchors.right: rctKnopkaNazad.horizontalCenter
			anchors.top: rctKnopkaNazad.top
			anchors.topMargin: rctKnopkaNazad.width/8*3

            color: tphKnopkaNazad.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNazad.width/4
		} 
	}	
}
