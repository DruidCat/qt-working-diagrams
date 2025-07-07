﻿import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
    property color clrFona: "white"
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
            id: tphKnopkaPoisk
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaPoisk
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Item {
        id: tmKnopkaPoisk
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

		Rectangle {
            id: rctKrugBolshoi
            z: 1
            width: tmKnopkaPoisk.width/4*3
            height: width
            anchors.top: tmKnopkaPoisk.top
            anchors.left: tmKnopkaPoisk.left

            color: tphKnopkaPoisk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: width/2
        }
		Rectangle {
            id: rctKrugMali
            z: 4
            width: tmKnopkaPoisk.width/2
            height: width
            anchors.centerIn: rctKrugBolshoi

			color: clrFona
			radius: width/2
        }
		Rectangle {
            id: rctRuchkaOdin
            z: 2
            width: tmKnopkaPoisk.width/4
            height: width
            anchors.top: rctKrugMali.bottom
            anchors.left: rctKrugMali.right

            color: tphKnopkaPoisk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: width/2
		}
		Rectangle {
            id: rctRuchkaDva
            z: 3
            width: tmKnopkaPoisk.width/4
            height: width
            anchors.verticalCenter: rctRuchkaOdin.top
            anchors.horizontalCenter: rctRuchkaOdin.left

            color: tphKnopkaPoisk.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: width/2
        } 
    } 
}
