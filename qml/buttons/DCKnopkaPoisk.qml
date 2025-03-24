import QtQuick //2.14
//import QtQuick.Window //2.14

Item {
    id: tmKnopkaPoisk
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
    property color clrFona: "white"

    width: ntWidth*ntCoff
    height: width

	signal clicked();

	Rectangle {
        id: rctKnopkaPoisk
        anchors.fill: tmKnopkaPoisk

        color: clrFona

		Rectangle {
            id: rctKrugBolshoi
            z: 1
            width: rctKnopkaPoisk.width/4*3
            height: width
            anchors.top: rctKnopkaPoisk.top
            anchors.left: rctKnopkaPoisk.left

			color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: width/2
        }
		Rectangle {
            id: rctKrugMali
            z: 4
            width: rctKnopkaPoisk.width/2
            height: width
            anchors.centerIn: rctKrugBolshoi

			color: clrFona
			radius: width/2
        }
		Rectangle {
            id: rctRuchkaOdin
            z: 2
            width: rctKnopkaPoisk.width/4
            height: width
            anchors.top: rctKrugMali.bottom
            anchors.left: rctKrugMali.right

			color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: width/2
		}
		Rectangle {
            id: rctRuchkaDva
            z: 3
            width: rctKnopkaPoisk.width/4
            height: width
            anchors.verticalCenter: rctRuchkaOdin.top
            anchors.horizontalCenter: rctRuchkaOdin.left

			color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
			radius: width/2
        }
        MouseArea {
            id: maKnopkaPoisk
            anchors.fill: rctKnopkaPoisk
            onClicked: {
                tmKnopkaPoisk.clicked();
            }
        }
    } 
}
