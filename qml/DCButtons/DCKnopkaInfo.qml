import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"
    property bool enabled: true//true - активирована, false - деактивированна кнопка.
    property real tapHeight: ntWidth*ntCoff//Высота зоны нажатия пальцем или мышкой
    property real tapWidth: ntWidth*ntCoff//Ширина зоны нажатия пальцем или мышкой
    //Настройки.
    height: tapHeight
    width: tapWidth
    //Сигналы.
	signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
        id: tphKnopkaInfo
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea {
        id: maKnopkaInfo
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle {
		id: rctKnopkaInfo
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaInfo.pressed ? Qt.darker(clrFona, 1.3) : clrFona
                //maKnopkaInfo.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, 0.8)
        }
        border.color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                //maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            else//Если деактивирована кнопка, то...
                Qt.darker(clrKnopki, 0.8)
        }
        border.width: root.width/8/4
        radius: root.width/4

		Rectangle {
			id: rctBukvaTochka
			visible: true
			width: rctKnopkaInfo.width/4
			height: width
			anchors.top: rctKnopkaInfo.top
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter
            anchors.topMargin: rctKnopkaInfo.width/8

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                    //maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            radius: rctKnopkaInfo.width/4
		}

		Rectangle {
			id: rctBukvaPalochka1
			width: rctKnopkaInfo.width/4
			height: rctKnopkaInfo.width/8
			anchors.top: rctKnopkaInfo.verticalCenter
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                    //maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
        }

		Rectangle {
			id: rctBukvaPalochka2
			width: rctKnopkaInfo.width/4
			height: rctKnopkaInfo.width/4
			anchors.top: rctBukvaPalochka1.bottom
			anchors.horizontalCenter: rctKnopkaInfo.horizontalCenter

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaInfo.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                    //maKnopkaInfo.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
        }
	}
}

