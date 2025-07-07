import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item{
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"
	property bool border: true
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
            id: tphKnopkaPlus
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaPlus
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
        id: rctKnopkaPlus
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: tphKnopkaPlus.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaPlus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: width/4

        Rectangle {
            id: rctCentorV
            height: rctKnopkaPlus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaPlus

            color: tphKnopkaPlus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaPlus.width/4
        }
		Rectangle {
            id: rctCentorG
            width: rctKnopkaPlus.width/4
            height: width*3
            anchors.centerIn: rctKnopkaPlus

            color: tphKnopkaPlus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaPlus.width/4
        } 
	}
	Component.onCompleted: {
        if(root.border){
            rctKnopkaPlus.border.color = tphKnopkaPlus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //rctKnopkaPlus.border.color = maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            rctKnopkaPlus.border.width = rctKnopkaPlus.width/8/4;
		}
    }
}
