import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item{
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
        id: tphKnopkaVverh
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea {
        id: maKnopkaVverh
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle {
		id: rctKnopkaVverh
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaVverh.pressed ? Qt.darker(clrFona, 1.3) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, 0.8)
        }
        /*
        color: {
            if(root.enabled)//Если активирована кнопка, то...
                maKnopkaVverh.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, 0.8)
        }
        */
        border.color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            else//Если деактивирована кнопка, то...
                Qt.darker(clrKnopki, 0.8)
        }
        /*
        border.color: {
            if(root.enabled)//Если активирована кнопка, то...
                maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
            else//Если деактивирована кнопка, то...
                Qt.darker(clrKnopki, 0.8)
        }
        */
        border.width: width/8/4
        radius: width/4

		Rectangle {
			id: rctStrelkaNizPravo
			visible: true
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.bottom
			anchors.right: rctKnopkaVverh.right
			anchors.bottomMargin: rctKnopkaVverh.width/8*2
			anchors.rightMargin: rctKnopkaVverh.width/8

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            */
            radius: rctKnopkaVverh.width/4
		}

		Rectangle {
			id: rctStrelkaNizLevo
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.bottom
			anchors.left: rctKnopkaVverh.left
			anchors.bottomMargin: rctKnopkaVverh.width/8*2
			anchors.leftMargin: rctKnopkaVverh.width/8

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            */
            radius: rctKnopkaVverh.width/4
		}

		Rectangle {
			id: rctStrelkaCentor
			width: rctKnopkaVverh.width/4
			height: width
			anchors.bottom: rctKnopkaVverh.verticalCenter
			anchors.left: rctKnopkaVverh.left
			anchors.leftMargin: rctKnopkaVverh.width/8*3

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVverh.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    maKnopkaVverh.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            */
            radius: rctKnopkaVverh.width/4
		} 
	}	
}
