import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"
    property bool blVert: false//true - вертикально точки расположены.
    //Настройки.
	width: ntWidth*ntCoff
	height: width
    //Сигналы.
	signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaNastroiki
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaNastroiki
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle{
		id: rctKnopkaNastroiki
        anchors.fill: root

        color: tphKnopkaNastroiki.pressed ? Qt.darker(clrFona, 1.3) : clrFona
        //color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
        Rectangle{
			id: rctKnopkaLevo
            visible: blVert ? false : true
            width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.verticalCenter: rctKnopkaNastroiki.verticalCenter
			anchors.left: rctKnopkaNastroiki.left

            color: tphKnopkaNastroiki.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
		}

		Rectangle{
			id: rctKnopkaSeredina
			width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.centerIn: rctKnopkaNastroiki

            color: tphKnopkaNastroiki.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
		}

		Rectangle{
			id: rctKnopkaPravo
            visible: blVert ? false : true
            width: rctKnopkaNastroiki.width/4
			height: rctKnopkaNastroiki.width/4
			anchors.verticalCenter: rctKnopkaNastroiki.verticalCenter
			anchors.right: rctKnopkaNastroiki.right

            color: tphKnopkaNastroiki.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
		}

        Rectangle{
            id: rctKnopkaVerh
            visible: blVert ? true : false
            width: rctKnopkaNastroiki.width/4
            height: rctKnopkaNastroiki.width/4
            anchors.horizontalCenter: rctKnopkaNastroiki.horizontalCenter
            anchors.top: rctKnopkaNastroiki.top

            color: tphKnopkaNastroiki.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
        }
        Rectangle{
            id: rctKnopkaNiz
            visible: blVert ? true : false
            width: rctKnopkaNastroiki.width/4
            height: rctKnopkaNastroiki.width/4
            anchors.horizontalCenter: rctKnopkaNastroiki.horizontalCenter
            anchors.bottom: rctKnopkaNastroiki.bottom

            color: tphKnopkaNastroiki.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            //color: maKnopkaNastroiki.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            radius: rctKnopkaNastroiki.width/2//Круг
        } 
	}	
}
