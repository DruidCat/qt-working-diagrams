import QtQuick //2.15

Item {
    id: root
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"

    width: ntWidth*ntCoff
    height: width

    signal clicked();

    Rectangle {
        id: rctKnopkaPlan
        anchors.fill: root

        color: maKnopkaPlan.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

        Rectangle {
            id: rctStrelkaPalka
            width: rctKnopkaPlan.width/8
            height: rctKnopkaPlan.width
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            radius: rctKnopkaPlan.width/4

            color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaKrest1
            width: rctKnopkaPlan.width/8*3
            height: rctKnopkaPlan.width/4
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            anchors.topMargin: rctKnopkaPlan.width/8
            radius: rctKnopkaPlan.width/4

            color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaKrest2
            width: rctKnopkaPlan.width/8*5
            height: rctKnopkaPlan.width/8
            anchors.top: rctKnopkaPlan.top
            anchors.horizontalCenter: rctKnopkaPlan.horizontalCenter
            anchors.topMargin: rctKnopkaPlan.width/4
            radius: rctKnopkaPlan.width/4

            color: maKnopkaPlan.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        MouseArea {
            id: maKnopkaPlan
            anchors.fill: rctKnopkaPlan
            onClicked: {
                root.clicked();
            }
        }
    }
}
