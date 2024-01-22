import QtQuick
import QtQuick.Window

Item {
	id: tmKnopkaInfo
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"

	width: ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle {
		id: rctKnopkaInfo
		anchors.fill: tmKnopkaInfo

		color: maKnopkaInfo.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		border.width: tmKnopkaInfo.width/8/4
		radius: tmKnopkaInfo.width/4

		Rectangle {
			id: rctBukvaTochka
			visible: true
			width: rctKnopkaInfo.width/4
			height: width
			anchors.top: rctKnopkaInfo.top
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter
			anchors.topMargin: rctKnopkaInfo.width/8

			color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaInfo.width/4
		}

		Rectangle {
			id: rctBukvaPalochka1
			width: rctKnopkaInfo.width/4
			height: rctKnopkaInfo.width/8
			anchors.top: rctKnopkaInfo.verticalCenter
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter

			color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		}

		Rectangle {
			id: rctBukvaPalochka2
			width: rctKnopkaInfo.width/4
			height: rctKnopkaInfo.width/4
			anchors.top: rctBukvaPalochka1.bottom
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter

			color: maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		}

		MouseArea {
			id: maKnopkaInfo
			width: tmKnopkaInfo.width
			height:  width
			onClicked: {
				tmKnopkaInfo.clicked();
			}
		}
	}
}

