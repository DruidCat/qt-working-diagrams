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

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctLeva3
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8*3
            anchors.top: tmKnopkaPovorotPo.top
            anchors.left: tmKnopkaPovorotPo.left
            anchors.topMargin: tmKnopkaPovorotPo.height/8*2
            anchors.leftMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctPrava3
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8*3
            anchors.top: tmKnopkaPovorotPo.top
            anchors.right: tmKnopkaPovorotPo.right
            anchors.topMargin: tmKnopkaPovorotPo.height/8*2

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctONiz
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/8
            anchors.bottom: tmKnopkaPovorotPo.bottom
            anchors.left: rctOLevaNiz.right
            anchors.bottomMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctOPravaVerh
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/2
            anchors.top: tmKnopkaPovorotPo.top
            anchors.left: rctOVerh.right
            anchors.topMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctOPravaNiz
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/4
            anchors.top: rctOPravaVerh.bottom
            anchors.left: rctOVerh.right

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }

        Rectangle {
            id: rctKVerh
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/4
            anchors.top: tmKnopkaPovorotPo.top
            anchors.right: tmKnopkaPovorotPo.right
            anchors.topMargin: tmKnopkaPovorotPo.height/8
            anchors.rightMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKNiz
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/4
            anchors.bottom: tmKnopkaPovorotPo.bottom
            anchors.right: tmKnopkaPovorotPo.right
            anchors.bottomMargin: tmKnopkaPovorotPo.height/8
            anchors.rightMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKCentr
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/4
            anchors.verticalCenter: tmKnopkaPovorotPo.verticalCenter
            anchors.right: rctKNiz.left
            anchors.topMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKLevaVerh
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/2
            anchors.top: tmKnopkaPovorotPo.top
            anchors.right: rctKCentr.left
            anchors.topMargin: tmKnopkaPovorotPo.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKLevaNiz
            width: tmKnopkaPovorotPo.width/8
            height: tmKnopkaPovorotPo.height/4
            anchors.top: rctKLevaVerh.bottom
            anchors.right: rctKCentr.left

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
    }
}
