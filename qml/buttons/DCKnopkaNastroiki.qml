import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

Item {
	id: tmKnopkaNastroiki
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"
    property bool blVert: false//true - вертикально точки расположены.

	width: ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle{
		id: rctKnopkaNastroiki
		anchors.fill: tmKnopkaNastroiki
		color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona

		Rectangle{
			id: rctKnopkaLevo
            visible: blVert ? false : true
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
            visible: blVert ? false : true
            width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.verticalCenter: rctKnopkaNastroiki.verticalCenter
			anchors.right: rctKnopkaNastroiki.right

			color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: rctKnopkaNastroiki.width/2//Круг
		}

        Rectangle{
            id: rctKnopkaVerh
            visible: blVert ? true : false
            width: rctKnopkaNastroiki.width/4
            height: rctKnopkaNastroiki.width/4
            anchors.horizontalCenter: rctKnopkaNastroiki.horizontalCenter
            anchors.top: rctKnopkaNastroiki.top

            color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
        }
        Rectangle{
            id: rctKnopkaNiz
            visible: blVert ? true : false
            width: rctKnopkaNastroiki.width/4
            height: rctKnopkaNastroiki.width/4
            anchors.horizontalCenter: rctKnopkaNastroiki.horizontalCenter
            anchors.bottom: rctKnopkaNastroiki.bottom

            color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
        }
        MouseArea {
            id: maKnopkaNastroiki
            anchors.fill: rctKnopkaNastroiki
            onClicked: {
                tmKnopkaNastroiki.clicked();
            }
        }
	}	
}
