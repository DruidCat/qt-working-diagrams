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
    property real tapHeight: ntWidth*ntCoff//Высота зоны нажатия пальцем или мышкой
    property real tapWidth: ntWidth*ntCoff//Ширина зоны нажатия пальцем или мышкой
    //Настройки.
    width: ntWidth*ntCoff
    height: width
    //Сигналы.
    signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaMinus
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaMinus
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
        id: rctKnopkaMinus
        anchors.fill: root

        color: tphKnopkaMinus.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaMinus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: root.width/4

        Rectangle {
            id: rctCentor
            height: rctKnopkaMinus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaMinus

            color: tphKnopkaMinus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaMinus.width/4
        } 
	}
	Component.onCompleted: {
        if(root.border){
            rctKnopkaMinus.border.color = tphKnopkaMinus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //rctKnopkaMinus.border.color = maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki,1.3) : clrKnopki
            rctKnopkaMinus.border.width = root.width/8/4;
		}
	} 
}
