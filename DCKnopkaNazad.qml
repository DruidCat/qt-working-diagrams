import QtQuick 2.12
import QtQuick.Window 2.12

Item{
	id: tmKnopkaNazad
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrKnopki: "black"
	property color clrFona: "transparent"
	width: ntWidth*ntCoff
	height: width

	signal sKnopkaNazadCliked();

	Rectangle {
		id: rctKnopkaNazad
		anchors.fill: tmKnopkaNazad
		color: maKnopkaNazad.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		border.width: tmKnopkaNazad.width/8/4
		radius: tmKnopkaNazad.width/4

		Rectangle {
			id: rctStrelkaVerh
			visible: true
			color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			width: rctKnopkaNazad.width/4
			height: width
			radius: rctKnopkaNazad.width/4
			anchors.top: rctKnopkaNazad.top
			anchors.right: rctKnopkaNazad.right
			anchors.rightMargin: rctKnopkaNazad.width/8*2
			anchors.topMargin: rctKnopkaNazad.width/8
		}

		Rectangle {
			id: rctStrelkaNiz
			color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			width: rctKnopkaNazad.width/4
			height: width
			radius: rctKnopkaNazad.width/4
			anchors.bottom: rctKnopkaNazad.bottom
			anchors.right: rctKnopkaNazad.right
			anchors.rightMargin: rctKnopkaNazad.width/8*2
			anchors.bottomMargin: rctKnopkaNazad.width/8
		}

		Rectangle {
			id: rctStrelkaCentor
			color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			width: rctKnopkaNazad.width/4
			height: width
			radius: rctKnopkaNazad.width/4
			anchors.right: rctKnopkaNazad.horizontalCenter
			anchors.top: rctKnopkaNazad.top
			anchors.topMargin: rctKnopkaNazad.width/8*3
		}
	}

	MouseArea {
		id: maKnopkaNazad
		width: tmKnopkaNazad.width
		height:  width
		onClicked: {
			tmKnopkaNazad.sKnopkaNazadCliked();
		}
	}
}
