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
        id: tmKnopkaOk
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        Rectangle {
            id: rctOLevaVerh
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/2
            anchors.top: tmKnopkaOk.top
            anchors.left: tmKnopkaOk.left
            anchors.topMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctOLevaNiz
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/4
            anchors.top: rctOLevaVerh.bottom
            anchors.left: tmKnopkaOk.left

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctOVerh
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/8
            anchors.top: tmKnopkaOk.top
            anchors.left: rctOLevaVerh.right
            anchors.topMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctONiz
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/8
            anchors.bottom: tmKnopkaOk.bottom
            anchors.left: rctOLevaNiz.right
            anchors.bottomMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctOPravaVerh
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/2
            anchors.top: tmKnopkaOk.top
            anchors.left: rctOVerh.right
            anchors.topMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctOPravaNiz
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/4
            anchors.top: rctOPravaVerh.bottom
            anchors.left: rctOVerh.right

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }

        Rectangle {
            id: rctKVerh
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/4
            anchors.top: tmKnopkaOk.top
            anchors.right: tmKnopkaOk.right
            anchors.topMargin: tmKnopkaOk.height/8
            anchors.rightMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKNiz
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/4
            anchors.bottom: tmKnopkaOk.bottom
            anchors.right: tmKnopkaOk.right
            anchors.bottomMargin: tmKnopkaOk.height/8
            anchors.rightMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKCentr
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/4
            anchors.verticalCenter: tmKnopkaOk.verticalCenter
            anchors.right: rctKNiz.left
            anchors.topMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKLevaVerh
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/2
            anchors.top: tmKnopkaOk.top
            anchors.right: rctKCentr.left
            anchors.topMargin: tmKnopkaOk.height/8

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctKLevaNiz
            width: tmKnopkaOk.width/8
            height: tmKnopkaOk.height/4
            anchors.top: rctKLevaVerh.bottom
            anchors.right: rctKCentr.left

            color: tphKnopkaOk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaOk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
    }
}
