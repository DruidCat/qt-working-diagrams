import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
	id: tmKnopkaNastroiki
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"

	width: ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle{
		id: rctKnopkaNastroiki
		anchors.fill: tmKnopkaNastroiki
		color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona

		Rectangle{
			id: rctKnopkaLevo
			width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.verticalCenter: rctKnopkaNastroiki.verticalCenter
			anchors.left: rctKnopkaNastroiki.left

			color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNastroiki.width/2//Круг
		}

		Rectangle{
			id: rctKnopkaSeredina
			width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.centerIn: rctKnopkaNastroiki

			color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNastroiki.width/2//Круг
		}

		Rectangle{
			id: rctKnopkaPravo
			width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.verticalCenter: rctKnopkaNastroiki.verticalCenter
			anchors.right: rctKnopkaNastroiki.right

			color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNastroiki.width/2//Круг
		}
	}

	MouseArea {
		id: maKnopkaNastroiki
		width: tmKnopkaNastroiki.width
		height:  width
		onClicked: {
			tmKnopkaNastroiki.clicked();
		}
	}
}
