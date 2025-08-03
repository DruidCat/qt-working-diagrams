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
        id: tphKnopkaMenu
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea {
        id: maKnopkaMenu
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle{
		id: rctKnopkaMenu
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaMenu.pressed ? Qt.darker(clrFona, 1.3) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, 0.8)
        }
        /*
        color: {
            if(root.enabled)//Если активирована кнопка, то...
                maKnopkaMenu.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, 0.8)
        }
        */
		Rectangle{
			id: rctKnopkaVerh
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.top: rctKnopkaMenu.top
			anchors.left: rctKnopkaMenu.left

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaMenu.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            */
            radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaSeredina
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.verticalCenter: rctKnopkaMenu.verticalCenter
			anchors.left: rctKnopkaMenu.left

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaMenu.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            */
            radius: rctKnopkaMenu.width/4
		}

		Rectangle{
			id: rctKnopkaNiz
			width: rctKnopkaMenu.width
			height: rctKnopkaMenu.width/4
			anchors.bottom: rctKnopkaMenu.bottom
			anchors.left: rctKnopkaMenu.left

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaMenu.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    maKnopkaMenu.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            */
            radius: rctKnopkaMenu.width/4
        } 
	}	
}
