import QtQuick //2.15

Item{
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property color clrFona: "transparent"
	property bool border: true
    //Настройки.
    width: ntWidth*ntCoff
    height: width
    //Сигналы.
    signal clicked();
    //Функции.
    Rectangle {
        id: rctKnopkaMinus
        anchors.fill: root

        color: maKnopkaMinus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: root.width/4

        Rectangle {
            id: rctCentor
            height: rctKnopkaMinus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaMinus

            color: maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaMinus.width/4
        }
        MouseArea {
            id: maKnopkaMinus
            anchors.fill: rctKnopkaMinus
            onClicked: {
                root.clicked();
            }
        }
	}
	Component.onCompleted: {
        if(root.border){
			rctKnopkaMinus.border.color = maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            rctKnopkaMinus.border.width = root.width/8/4;
		}
	} 
}
