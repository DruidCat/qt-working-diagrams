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
            id: tphKnopkaOk
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaOk
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctOLevaVerh
        width: root.width/8
        height: root.height/2
        anchors.top: root.top
        anchors.left: root.left
        anchors.topMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctOLevaNiz
        width: root.width/8
        height: root.height/4
		anchors.top: rctOLevaVerh.bottom
        anchors.left: root.left

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctOVerh
        width: root.width/8
        height: root.height/8
        anchors.top: root.top
		anchors.left: rctOLevaVerh.right
        anchors.topMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctONiz
        width: root.width/8
        height: root.height/8
        anchors.bottom: root.bottom
		anchors.left: rctOLevaNiz.right
        anchors.bottomMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctOPravaVerh
        width: root.width/8
        height: root.height/2
        anchors.top: root.top
		anchors.left: rctOVerh.right
        anchors.topMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctOPravaNiz
        width: root.width/8
        height: root.height/4
		anchors.top: rctOPravaVerh.bottom
		anchors.left: rctOVerh.right

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }

	Rectangle {
		id: rctKVerh
        width: root.width/8
        height: root.height/4
        anchors.top: root.top
        anchors.right: root.right
        anchors.topMargin: root.height/8
        anchors.rightMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctKNiz
        width: root.width/8
        height: root.height/4
        anchors.bottom: root.bottom
        anchors.right: root.right
        anchors.bottomMargin: root.height/8
        anchors.rightMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctKCentr
        width: root.width/8
        height: root.height/4
        anchors.verticalCenter: root.verticalCenter
		anchors.right: rctKNiz.left
        anchors.topMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctKLevaVerh
        width: root.width/8
        height: root.height/2
        anchors.top: root.top
		anchors.right: rctKCentr.left
        anchors.topMargin: root.height/8

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
	Rectangle {
		id: rctKLevaNiz
        width: root.width/8
        height: root.height/4
		anchors.top: rctKLevaVerh.bottom
		anchors.right: rctKCentr.left

        color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
    }
}
