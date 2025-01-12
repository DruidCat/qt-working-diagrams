import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Item{
    id: tmKnopkaZakrit
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"

    width: ntWidth*ntCoff
    height: width

    signal clicked();

    Rectangle {
        id: rctKnopkaZakrit
        anchors.fill: tmKnopkaZakrit

        border.color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: tmKnopkaZakrit.width/8/4

        color: maKnopkaZakrit.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: tmKnopkaZakrit.width/4

        Rectangle {
            id: rctVerhPravo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.top: rctKnopkaZakrit.top
            anchors.right: rctKnopkaZakrit.right
            anchors.topMargin: rctKnopkaZakrit.width/8
            anchors.rightMargin: rctKnopkaZakrit.width/8

            color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctVerhLevo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.top: rctKnopkaZakrit.top
            anchors.left: rctKnopkaZakrit.left
            anchors.topMargin: rctKnopkaZakrit.width/8
            anchors.leftMargin: rctKnopkaZakrit.width/8

            color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctCentor
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.centerIn: rctKnopkaZakrit

            color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }
        Rectangle {
            id: rctNizPravo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.bottom: rctKnopkaZakrit.bottom
            anchors.right: rctKnopkaZakrit.right
            anchors.bottomMargin: rctKnopkaZakrit.width/8
            anchors.rightMargin: rctKnopkaZakrit.width/8

            color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }

        Rectangle {
            id: rctNizLevo
            width: rctKnopkaZakrit.width/4
            height: width
            anchors.bottom: rctKnopkaZakrit.bottom
            anchors.left: rctKnopkaZakrit.left
            anchors.bottomMargin: rctKnopkaZakrit.width/8
            anchors.leftMargin: rctKnopkaZakrit.width/8

            color: maKnopkaZakrit.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaZakrit.width/4
        }

    }
    MouseArea {
        id: maKnopkaZakrit
        width: tmKnopkaZakrit.width
        height: width
        onClicked: {
            tmKnopkaZakrit.clicked();
        }
    }
}
