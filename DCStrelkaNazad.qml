import QtQuick 2.12
import QtQuick.Window 2.12

Item{
	id: tmStrelkaNazad
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrKnopki: "black"
	property color clrFona: "transparent"
	width: ntWidth*ntCoff
	height: width

	signal sStrelkaNazadCliked();

	Rectangle {
		id: rctStrelkaNazad
		anchors.fill: tmStrelkaNazad
		color: maStrelkaNazad.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maStrelkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		border.width: tmStrelkaNazad.width/8/4
		radius: tmStrelkaNazad.width/4

		Rectangle {
			id: rctStrelkaVerh
			visible: true
			color: maStrelkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			width: rctStrelkaNazad.width/4
			height: width
			radius: rctStrelkaNazad.width/4
			anchors.top: rctStrelkaNazad.top
			anchors.right: rctStrelkaNazad.right
			anchors.rightMargin: rctStrelkaNazad.width/8*2
			anchors.topMargin: rctStrelkaNazad.width/8
		}

		Rectangle {
			id: rctStrelkaNiz
			color: maStrelkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			width: rctStrelkaNazad.width/4
			height: width
			radius: rctStrelkaNazad.width/4
			anchors.bottom: rctStrelkaNazad.bottom
			anchors.right: rctStrelkaNazad.right
			anchors.rightMargin: rctStrelkaNazad.width/8*2
			anchors.bottomMargin: rctStrelkaNazad.width/8
		}

		Rectangle {
			id: rctStrelkaCentor
			color: maStrelkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			width: rctStrelkaNazad.width/4
			height: width
			radius: rctStrelkaNazad.width/4
			anchors.right: rctStrelkaNazad.horizontalCenter
			anchors.top: rctStrelkaNazad.top
			anchors.topMargin: rctStrelkaNazad.width/8*3
		}
	}

	MouseArea {
		id: maStrelkaNazad
		width: tmStrelkaNazad.width
		height:  width
		onClicked: {
			tmStrelkaNazad.sStrelkaNazadCliked();
		}
	}
}
