﻿import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "black"
    property color clrFona: "white"
    property bool blKrug: true
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
            id: tphKnopkaSozdat
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaSozdat
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Item {
        id: tmKnopkaSozdat
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        Rectangle{
            id: rctKnopkaKrug
            anchors.fill: tmKnopkaSozdat

            color: tphKnopkaSozdat.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaSozdat.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            border.color: Qt.darker(clrKnopki, 1.3)//Граница кнопки чуть темнее
            border.width: 1//Ширина границы
            radius: blKrug ? width/2 : 1
            smooth: true//Сглаживание
        }
        Rectangle{
            id: rctKnopkaSeredina
            width: tmKnopkaSozdat.width/2
            height: tmKnopkaSozdat.width/8
            anchors.centerIn: tmKnopkaSozdat

            color: tphKnopkaSozdat.pressed ? Qt.darker(clrFona, 1.3) : clrFona
            //color: maKnopkaSozdat.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
            radius: tmKnopkaSozdat.width/4
        }
        Rectangle{
            id: rctKnopkaNiz
            width: tmKnopkaSozdat.width/8
            height: tmKnopkaSozdat.width/2
            anchors.centerIn: tmKnopkaSozdat

            color: tphKnopkaSozdat.pressed ? Qt.darker(clrFona, 1.3) : clrFona
            //color: maKnopkaSozdat.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
            radius: tmKnopkaSozdat.width/4
        }
    }
}
