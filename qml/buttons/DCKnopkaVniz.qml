import QtQuick //2.14
//import QtQuick.Window //2.14

Item{
	id: tmKnopkaVniz
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"

	width: ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle {
		id: rctKnopkaVniz
		anchors.fill: tmKnopkaVniz

		color: maKnopkaVniz.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		border.color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		border.width: tmKnopkaVniz.width/8/4
		radius: tmKnopkaVniz.width/4

		Rectangle {
			id: rctStrelkaVerhPravo
			visible: true
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.top
			anchors.right: rctKnopkaVniz.right
			anchors.topMargin: rctKnopkaVniz.width/8*2
			anchors.rightMargin: rctKnopkaVniz.width/8

			color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVniz.width/4
		}

		Rectangle {
			id: rctStrelkaVerhLevo
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.top
			anchors.left: rctKnopkaVniz.left
			anchors.topMargin: rctKnopkaVniz.width/8*2
			anchors.leftMargin: rctKnopkaVniz.width/8

			color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVniz.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVniz.width/4
			height: width
			anchors.top: rctKnopkaVniz.verticalCenter
			anchors.left: rctKnopkaVniz.left
			anchors.leftMargin: rctKnopkaVniz.width/8*3

			color: maKnopkaVniz.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaVniz.width/4
		}
	}

	MouseArea {
		id: maKnopkaVniz
        anchors.fill: rctKnopkaVniz
        onClicked: {
            tmKnopkaVniz.clicked();
		}
	}
}
