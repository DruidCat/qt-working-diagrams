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
    Item {
        id: tmKnopkaPovorotPo
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        Rectangle {
            id: rctVerh3
            width: tmKnopkaPovorotPo.width/8*3
            height: tmKnopkaPovorotPo.height/8
            anchors.top: tmKnopkaPovorotPo.top
            anchors.left: tmKnopkaPovorotPo.left
            anchors.leftMargin: tmKnopkaPovorotPo.height/8*3
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctLeva3
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8*3
            anchors.top: tmKnopkaPovorotPo.top
            anchors.left: tmKnopkaPovorotPo.left
            anchors.topMargin: tmKnopkaPovorotPo.height/4
            anchors.leftMargin: tmKnopkaPovorotPo.height/8
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctPrava3
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8*3
            anchors.top: tmKnopkaPovorotPo.top
            anchors.right: tmKnopkaPovorotPo.right
            anchors.topMargin: tmKnopkaPovorotPo.height/4
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctVerhLeva
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8
            anchors.top: tmKnopkaPovorotPo.top
            anchors.left: tmKnopkaPovorotPo.left
            anchors.topMargin: tmKnopkaPovorotPo.height/8
            anchors.leftMargin: tmKnopkaPovorotPo.height/4
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctVerhPrava
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8
            anchors.top: tmKnopkaPovorotPo.top
            anchors.right: tmKnopkaPovorotPo.right
            anchors.topMargin: tmKnopkaPovorotPo.height/8
            anchors.rightMargin: tmKnopkaPovorotPo.height/8
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctNizLeva
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8
            anchors.bottom: tmKnopkaPovorotPo.bottom
            anchors.left: tmKnopkaPovorotPo.left
            anchors.bottomMargin: tmKnopkaPovorotPo.height/4
            anchors.leftMargin: tmKnopkaPovorotPo.height/4
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }

        Rectangle {
            id: rctNizPrava
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8
            anchors.bottom: tmKnopkaPovorotPo.bottom
            anchors.right: tmKnopkaPovorotPo.right
            anchors.bottomMargin: tmKnopkaPovorotPo.height/4
            anchors.rightMargin: tmKnopkaPovorotPo.height/8
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaVert
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8*3
            anchors.bottom: tmKnopkaPovorotPo.bottom
            anchors.left: tmKnopkaPovorotPo.left
            anchors.bottomMargin: tmKnopkaPovorotPo.height/8
            anchors.leftMargin: tmKnopkaPovorotPo.height/8*3
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaGor
            width: tmKnopkaPovorotPo.width/8*3
            height: tmKnopkaPovorotPo.height/8
            anchors.bottom: tmKnopkaPovorotPo.bottom
            anchors.left: tmKnopkaPovorotPo.left
            anchors.bottomMargin: tmKnopkaPovorotPo.height/8
            anchors.leftMargin: tmKnopkaPovorotPo.height/8
            radius: tmKnopkaPovorotPo.width/4

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
    }
}
