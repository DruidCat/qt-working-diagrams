import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

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
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaPlus
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
            onTapped: root.clicked()
    }
    Rectangle {
        id: rctKnopkaPlus
        anchors.fill: root

        color: tphKnopkaPlus.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaPlus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: root.width/4

        Rectangle {
            id: rctCentorV
            height: rctKnopkaPlus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaPlus

            color: tphKnopkaPlus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaPlus.width/4
        }
		Rectangle {
            id: rctCentorG
            width: rctKnopkaPlus.width/4
            height: width*3
            anchors.centerIn: rctKnopkaPlus

            color: tphKnopkaPlus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaPlus.width/4
        }
        /*
        //Для Авроры комментируем TapHandler, расскомментируем MouseArea.
        MouseArea {
            id: maKnopkaPlus
            anchors.fill: rctKnopkaPlus
            onClicked: {
                root.clicked();
            }
        }
        */
	}
	Component.onCompleted: {
        if(root.border){
            rctKnopkaPlus.border.color = tphKnopkaPlus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //rctKnopkaPlus.border.color = maKnopkaPlus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            rctKnopkaPlus.border.width = root.width/8/4;
		}
    }
}
