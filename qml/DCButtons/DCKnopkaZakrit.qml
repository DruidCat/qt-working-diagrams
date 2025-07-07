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
            id: tphKnopkaZakrit
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaZakrit
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
        id: rctKnopkaZakrit
        anchors.fill: root

        color: tphKnopkaZakrit.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaZakrit.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: tphKnopkaZakrit.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //border.color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

        Rectangle {
            id: rctVerhPravo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.top: rctKnopkaZakrit.top
            anchors.right: rctKnopkaZakrit.right
            anchors.topMargin: rctKnopkaZakrit.width/8
            anchors.rightMargin: rctKnopkaZakrit.width/8

            color: tphKnopkaZakrit.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctVerhLevo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.top: rctKnopkaZakrit.top
            anchors.left: rctKnopkaZakrit.left
            anchors.topMargin: rctKnopkaZakrit.width/8
            anchors.leftMargin: rctKnopkaZakrit.width/8

            color: tphKnopkaZakrit.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctCentor
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.centerIn: rctKnopkaZakrit

            color: tphKnopkaZakrit.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctNizPravo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.bottom: rctKnopkaZakrit.bottom
            anchors.right: rctKnopkaZakrit.right
            anchors.bottomMargin: rctKnopkaZakrit.width/8
            anchors.rightMargin: rctKnopkaZakrit.width/8

            color: tphKnopkaZakrit.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctNizLevo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.bottom: rctKnopkaZakrit.bottom
            anchors.left: rctKnopkaZakrit.left
            anchors.bottomMargin: rctKnopkaZakrit.width/8
            anchors.leftMargin: rctKnopkaZakrit.width/8

            color: tphKnopkaZakrit.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        } 
    } 
}
