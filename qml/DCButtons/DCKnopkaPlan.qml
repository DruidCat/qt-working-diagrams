import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
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
    //Сигналы
    signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaPlan
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaPlan
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
        id: rctKnopkaPlan
        anchors.fill: root

        color: tphKnopkaPlan.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaPlan.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

        Rectangle {
            id: rctStrelkaPalka
            width: rctKnopkaPlan.width/8
            height: rctKnopkaPlan.width
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            radius: rctKnopkaPlan.width/4

            color: tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaKrest1
            width: rctKnopkaPlan.width/8*3
            height: rctKnopkaPlan.width/4
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            anchors.topMargin: rctKnopkaPlan.width/8
            radius: rctKnopkaPlan.width/4

            color: tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaKrest2
            width: rctKnopkaPlan.width/8*5
            height: rctKnopkaPlan.width/8
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            anchors.topMargin: rctKnopkaPlan.width/4
            radius: rctKnopkaPlan.width/4

            color: tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
    }
}
