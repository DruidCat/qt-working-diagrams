﻿import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"
    property real minDarker: 0.7//Миннимальная затемнённость кнопки, когда она не активная.
    property real maxDarker: 1.3//Максимальная затемнённость кнопки, когда она нажата.
    property bool enabled: true//true - активирована, false - деактивированна кнопка.
    property real tapHeight: ntWidth*ntCoff//Высота зоны нажатия пальцем или мышкой
    property real tapWidth: ntWidth*ntCoff//Ширина зоны нажатия пальцем или мышкой
    //Настройки.
    height: tapHeight
    width: tapWidth
    //Сигналы
    signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
        id: tphKnopkaPlan
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea {
        id: maKnopkaPlan
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle {
        id: rctKnopkaPlan
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaPlan.pressed ? Qt.darker(clrFona, root.maxDarker) : clrFona
                //maKnopkaPlan.containsMouse ? Qt.darker(clrFona, root.maxDarker) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, root.minDarker)
        }
        border.color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                //maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
            else//Если деактивирована кнопка, то...
                Qt.darker(clrKnopki, root.minDarker)
        }
        border.width: width/8/4
        radius: width/4

        Rectangle {
            id: rctStrelkaPalka
            width: rctKnopkaPlan.width/8
            height: rctKnopkaPlan.width
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            radius: rctKnopkaPlan.width/4

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
        }
        Rectangle {
            id: rctStrelkaKrest1
            width: rctKnopkaPlan.width/8*3
            height: rctKnopkaPlan.width/4
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            anchors.topMargin: rctKnopkaPlan.width/8
            radius: rctKnopkaPlan.width/4

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
        }
        Rectangle {
            id: rctStrelkaKrest2
            width: rctKnopkaPlan.width/8*5
            height: rctKnopkaPlan.width/8
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            anchors.topMargin: rctKnopkaPlan.width/4
            radius: rctKnopkaPlan.width/4

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaPlan.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
        }
    }
}
