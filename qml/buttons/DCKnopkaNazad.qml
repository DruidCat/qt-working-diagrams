import QtQuick 2.14
import QtQuick.Window 2.14

Item{
	id: tmKnopkaNazad
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"

	width: ntWidth*ntCoff
	height: width

	signal clicked();

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
			width: rctKnopkaNazad.width/4
			height: width
			anchors.top: rctKnopkaNazad.top
			anchors.right: rctKnopkaNazad.right
			anchors.rightMargin: rctKnopkaNazad.width/8*2
			anchors.topMargin: rctKnopkaNazad.width/8

			color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNazad.width/4
		}

		Rectangle {
			id: rctStrelkaNiz
			width: rctKnopkaNazad.width/4
			height: width
			anchors.bottom: rctKnopkaNazad.bottom
			anchors.right: rctKnopkaNazad.right
			anchors.rightMargin: rctKnopkaNazad.width/8*2
			anchors.bottomMargin: rctKnopkaNazad.width/8

			color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNazad.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaNazad.width/4
			height: width
			anchors.right: rctKnopkaNazad.horizontalCenter
			anchors.top: rctKnopkaNazad.top
			anchors.topMargin: rctKnopkaNazad.width/8*3

			color: maKnopkaNazad.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNazad.width/4
		}
	}

	MouseArea {
		id: maKnopkaNazad
		width: tmKnopkaNazad.width
		height:  width
		onClicked: {
			tmKnopkaNazad.clicked();
		}
	}
}
