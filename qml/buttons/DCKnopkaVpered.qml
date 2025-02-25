import QtQuick 2.14
import QtQuick.Window 2.14

Item{
	id: tmKnopkaVpered
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"

	width: ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle {
		id: rctKnopkaVpered
		anchors.fill: tmKnopkaVpered

		color: maKnopkaVpered.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		border.width: tmKnopkaVpered.width/8/4
		radius: tmKnopkaVpered.width/4

		Rectangle {
			id: rctStrelkaVerh
			visible: true
			width: rctKnopkaVpered.width/4
			height: width
			anchors.top: rctKnopkaVpered.top
			anchors.left: rctKnopkaVpered.left
			anchors.leftMargin: rctKnopkaVpered.width/8*2
			anchors.topMargin: rctKnopkaVpered.width/8

			color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVpered.width/4
		}

		Rectangle {
			id: rctStrelkaNiz
			width: rctKnopkaVpered.width/4
			height: width
			anchors.bottom: rctKnopkaVpered.bottom
			anchors.left: rctKnopkaVpered.left
			anchors.leftMargin: rctKnopkaVpered.width/8*2
			anchors.bottomMargin: rctKnopkaVpered.width/8

			color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVpered.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVpered.width/4
			height: width
			anchors.left: rctKnopkaVpered.horizontalCenter
			anchors.top: rctKnopkaVpered.top
			anchors.topMargin: rctKnopkaVpered.width/8*3

			color: maKnopkaVpered.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVpered.width/4
		}
	}

	MouseArea {
		id: maKnopkaVpered
		width: tmKnopkaVpered.width
		height:  width
		onClicked: {
			tmKnopkaVpered.clicked();
		}
	}
}
