import QtQuick
import QtQuick.Window

Item {
    id: tmKnopkaPoisk
    property color clrKnopki: "black"
    property color clrFona: "white"
    property int ntWidth: 8
    property int ntCoff: 8

    width: ntWidth*ntCoff
    height: width

    signal sKnopkaPoiskClicked();

    Rectangle{
        id: rctKnopkaPoisk
        anchors.fill: tmKnopkaPoisk
        color: clrFona
        Rectangle{
            id: rctKrugBolshoi
            z: 1
            width: rctKnopkaPoisk.width/4*3
            height: width
            color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            anchors.top: rctKnopkaPoisk.top
            anchors.left: rctKnopkaPoisk.left
            radius: width/2
        }

        Rectangle{
            id: rctKrugMali
            z: 4
            width: rctKnopkaPoisk.width/2
            height: width
            color: clrFona
            anchors.centerIn: rctKrugBolshoi
            radius: width/2
        }

        Rectangle{
            id: rctRuchkaOdin
            z: 2
            width: rctKnopkaPoisk.width/4
            height: width
            color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            anchors.top: rctKrugMali.bottom
            anchors.left: rctKrugMali.right
            radius: width/2
        }
        Rectangle{
            id: rctRuchkaDva
            z: 3
            width: rctKnopkaPoisk.width/4
            height: width
            color: maKnopkaPoisk.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            anchors.verticalCenter: rctRuchkaOdin.top
            anchors.horizontalCenter: rctRuchkaOdin.left
            radius: width/2
        }
    }

    MouseArea {
        id: maKnopkaPoisk
        width: tmKnopkaPoisk.width
        height:  width
        onClicked: {
            tmKnopkaPoisk.sKnopkaPoiskClicked();
        }
    }
}
