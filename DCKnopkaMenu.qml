import QtQuick 2.12
import QtQuick.Window 2.12

Item{
	id: tmKnopkaMenu
	property color clrKnopki: "black"
	property color clrFona: "transparent"
	property int ntWidth: 8
	property int ntCoff: 8

	width: ntWidth*ntCoff
	height: width

	signal sKnopkaMenuClicked();

	Rectangle{
		id: rctKnopkaMenu
		anchors.fill: tmKnopkaMenu
		color: maKnopkaMenu.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona

		Rectangle{
			id: rctKnopkaVerh
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			anchors.top: rctKnopkaMenu.top
			anchors.left: rctKnopkaMenu.left
			radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaSeredina
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			anchors.verticalCenter: rctKnopkaMenu.verticalCenter
			anchors.left: rctKnopkaMenu.left
			radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaNiz
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			color: maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			anchors.bottom: rctKnopkaMenu.bottom
			anchors.left: rctKnopkaMenu.left
			radius: rctKnopkaMenu.width/4
		}
	}

	MouseArea {
		id: maKnopkaMenu
		width: tmKnopkaMenu.width
		height:  width
		onClicked: {
			tmKnopkaMenu.sKnopkaMenuClicked();
		}
	}
}
