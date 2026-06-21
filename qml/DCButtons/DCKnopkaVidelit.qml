import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrFona: "transparent"
    property real minDarker: 0.7//Миннимальная затемнённость кнопки, когда она не активная.
    property real maxDarker: 1.3//Максимальная затемнённость кнопки, когда она нажата.
    property bool enabled: true//true - активирована, false - деактивированна кнопка.
    property bool pressed: tphKnopkaVidelit.pressed//true - нажали false - не нажали
    //property bool pressed: maKnopkaVidelit.pressed//true - нажали false - не нажали
    property bool isVidelit: false//true - выделить, false - захватить.
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
        id: tphKnopkaVidelit
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea {
        id: maKnopkaVidelit
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle{
        id: rctKnopkaVidelit
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaVidelit.pressed ? Qt.darker(clrFona, root.maxDarker) : clrFona
                //maKnopkaVidelit.containsMouse ? Qt.darker(clrFona, root.maxDarker) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, root.minDarker)
        }
        Rectangle{
			id: rctKnopkaLevo
            visible: isVidelit ? false : true
            width: rctKnopkaVidelit.width/4
            height: rctKnopkaVidelit.width/4
            anchors.verticalCenter: rctKnopkaVidelit.verticalCenter
            anchors.left: rctKnopkaVidelit.left

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVidelit.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaVidelit.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
            radius: rctKnopkaVidelit.width/2//Круг
		}

		Rectangle{
			id: rctKnopkaSeredina
            width: rctKnopkaVidelit.width/4
            height: rctKnopkaVidelit.width/4
            anchors.centerIn: rctKnopkaVidelit

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVidelit.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaVidelit.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
            radius: rctKnopkaVidelit.width/2//Круг
		}

		Rectangle{
			id: rctKnopkaPravo
            visible: isVidelit ? false : true
            width: rctKnopkaVidelit.width/4
            height: rctKnopkaVidelit.width/4
            anchors.verticalCenter: rctKnopkaVidelit.verticalCenter
            anchors.right: rctKnopkaVidelit.right

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVidelit.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaVidelit.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
            radius: rctKnopkaVidelit.width/2//Круг
		}

        Rectangle{
            id: rctKnopkaVerh
            visible: isVidelit ? true : false
            width: rctKnopkaVidelit.width/4
            height: rctKnopkaVidelit.width/4
            anchors.horizontalCenter: rctKnopkaVidelit.horizontalCenter
            anchors.top: rctKnopkaVidelit.top

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVidelit.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaVidelit.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
            radius: rctKnopkaVidelit.width/2//Круг
        }
        Rectangle{
            id: rctKnopkaNiz
            visible: isVidelit ? true : false
            width: rctKnopkaVidelit.width/4
            height: rctKnopkaVidelit.width/4
            anchors.horizontalCenter: rctKnopkaVidelit.horizontalCenter
            anchors.bottom: rctKnopkaVidelit.bottom

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaVidelit.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                    //maKnopkaVidelit.containsMouse ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, root.minDarker)
            }
            radius: rctKnopkaVidelit.width/2//Круг
        } 
	}	
}
