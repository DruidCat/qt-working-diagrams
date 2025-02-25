import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

Item{
    id: tmKnopkaMinus
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"

    width: ntWidth*ntCoff
    height: width

    signal clicked();

    Rectangle {
        id: rctKnopkaMinus
        anchors.fill: tmKnopkaMinus

        border.color: maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: tmKnopkaMinus.width/8/4

        color: maKnopkaMinus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: tmKnopkaMinus.width/4

        Rectangle {
            id: rctCentor
            height: rctKnopkaMinus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaMinus

            color: maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaMinus.width/4
        }
	}
    MouseArea {
        id: maKnopkaMinus
        width: tmKnopkaMinus.width
        height: width
        onClicked: {
            tmKnopkaMinus.clicked();
        }
    }
}
