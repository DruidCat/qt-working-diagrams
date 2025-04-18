﻿import QtQuick //2.15

Item{
    id: tmKnopkaPlus
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"
	property bool border: true

    width: ntWidth*ntCoff
    height: width

    signal clicked();

    Rectangle {
        id: rctKnopkaPlus
        anchors.fill: tmKnopkaPlus

        color: maKnopkaPlus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: tmKnopkaPlus.width/4

        Rectangle {
            id: rctCentorV
            height: rctKnopkaPlus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaPlus

            color: maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaPlus.width/4
        }
		Rectangle {
            id: rctCentorG
            width: rctKnopkaPlus.width/4
            height: width*3
            anchors.centerIn: rctKnopkaPlus

            color: maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaPlus.width/4
        }
        MouseArea {
            id: maKnopkaPlus
            anchors.fill: rctKnopkaPlus
            onClicked: {
                tmKnopkaPlus.clicked();
            }
        }
	}
	Component.onCompleted: {
		if(tmKnopkaPlus.border){
			rctKnopkaPlus.border.color = maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        	rctKnopkaPlus.border.width = tmKnopkaPlus.width/8/4;
		}
	} 
}
