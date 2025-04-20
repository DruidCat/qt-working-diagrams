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
        id: rctKnopkaMap
        anchors.fill: root

        color: maKnopkaMap.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        border.color: maKnopkaMap.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: root.width/8/4
        radius: root.width/4

        Rectangle {
            id: rctStrelkaPalka
            width: rctKnopkaMap.width/8
            height: rctKnopkaMap.width
            anchors.top: rctKnopkaMap.top
            anchors.horizontalCenter: rctKnopkaMap.horizontalCenter
            radius: rctKnopkaMap.width/4

            color: maKnopkaMap.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaKrest1
            width: rctKnopkaMap.width/8*3
            height: rctKnopkaMap.width/4
            anchors.top: rctKnopkaMap.top
            anchors.horizontalCenter: rctKnopkaMap.horizontalCenter
            anchors.topMargin: rctKnopkaMap.width/8
            radius: rctKnopkaMap.width/4

            color: maKnopkaMap.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        Rectangle {
            id: rctStrelkaKrest2
            width: rctKnopkaMap.width/8*5
            height: rctKnopkaMap.width/8
            anchors.top: rctKnopkaMap.top
            anchors.horizontalCenter: rctKnopkaMap.horizontalCenter
            anchors.topMargin: rctKnopkaMap.width/4
            radius: rctKnopkaMap.width/4

            color: maKnopkaMap.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        }
        MouseArea {
            id: maKnopkaMap
            anchors.fill: rctKnopkaMap
            onClicked: {
                root.clicked();
            }
        }
    }
}
