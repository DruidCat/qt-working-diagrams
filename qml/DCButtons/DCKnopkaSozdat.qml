import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "black"
    property color clrFona: "white"
    property bool blKrug: true
    //Настройки.
	width: ntWidth*ntCoff
	height: width
    //Сигналы.
	signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaSozdat
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaSozdat
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle{
		id: rctKnopkaKrug
        anchors.fill: root

        color: tphKnopkaSozdat.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaSozdat.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.color: Qt.darker(clrKnopki, 1.3)//Граница кнопки чуть темнее
        border.width: 1//Ширина границы
        radius: blKrug ? width/2 : 1
		smooth: true//Сглаживание
	}

	Rectangle{
		id: rctKnopkaSeredina
        width: root.width/2
        height: root.width/8
        anchors.centerIn: root

        color: tphKnopkaSozdat.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaSozdat.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: root.width/4
	}

	Rectangle{
		id: rctKnopkaNiz
        width: root.width/8
        height: root.width/2
        anchors.centerIn: root

        color: tphKnopkaSozdat.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaSozdat.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        radius: root.width/4
	}	
}
