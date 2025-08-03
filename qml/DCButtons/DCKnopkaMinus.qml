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
    property bool border: true
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
        id: tphKnopkaMinus
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea {
        id: maKnopkaMinus
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle {
        id: rctKnopkaMinus
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaMinus.pressed ? Qt.darker(clrFona, 1.3) : clrFona
                //maKnopkaMinus.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
            else//Если деактивирована кнопка, то...
                Qt.darker(clrFona, 0.8)
        }
        radius: width/4

        Rectangle {
            id: rctCentor
            height: rctKnopkaMinus.width/4
            width: height*3
            anchors.centerIn: rctKnopkaMinus

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaMinus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                    //maKnopkaMinus.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrKnopki, 0.8)
            }
            radius: rctKnopkaMinus.width/4
        } 
	}
	Component.onCompleted: {
        if(root.border){
            if(root.enabled){//Если активирована кнопка, то...
                rctKnopkaMinus.border.color = tphKnopkaMinus.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
                //rctKnopkaMinus.border.color = maKnopkaMinus.containsMouse?Qt.darker(clrKnopki,1.3):clrKnopki
            }
            else//Если деактивирована кнопка, то...
                rctKnopkaMinus.border.color = Qt.darker(clrKnopki, 0.8)
            rctKnopkaMinus.border.width = rctKnopkaMinus.width/8/4;
		}
	} 
}
