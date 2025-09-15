import QtQuick //2.15
//Виджет анимации загрузки.
Item{
    id: root
    //Свойства.
    property int ntHeight: 2
    property int ntCoff: 8
    property color clrWidget: "grey"//Цвет виджета
    property color clrFona: "transparent"//Цвет фона
    property bool running: false//true - включить анимацию. false - выключить анимацию.
    //Настройки.
    height: ntHeight*ntCoff
    width: ntHeight*ntCoff*2//Длина в два раза больше чем высота.
    //Функции. 
    Rectangle {
        id: rctLoad
        property int ntHeight: root.width/3//Делим длину на три квадрата
        property int ntShag: ntHeight-root.ntHeight*2//Делаем промежуток между квадратами.
        anchors.fill: root
        color: root.clrFona
        radius: 11//Закруглённость

        Rectangle {
            id: rctSLeva
            height: rctLoad.ntHeight
            width: height
            anchors.verticalCenter: rctLoad.verticalCenter
            anchors.left: rctLoad.left
            color: "transparent"
            Rectangle {
                id: krugSLeva
                height: tmrLoad.ntShag
                width: height
                anchors.centerIn: rctSLeva
                color: root.clrWidget
                radius: 50//Круг
            }
        }
        Rectangle {
            id: rctCentor
            height: rctLoad.ntHeight
            width: height
            anchors.verticalCenter: rctLoad.verticalCenter
            anchors.left: rctSLeva.right
            color: "transparent"
            Rectangle {
                id: krugCentor
                height: tmrLoad.ntShag
                width: height
                anchors.centerIn: rctCentor
                color: root.clrWidget
                radius: 50//Круг
            }
        }
        Rectangle {
            id: rctSPrava
            height: rctLoad.ntHeight
            width: height
            anchors.verticalCenter: rctLoad.verticalCenter
            anchors.left: rctCentor.right
            color: "transparent"
            Rectangle {
                id: krugSPrava
                height: tmrLoad.ntShag
                width: height
                anchors.centerIn: rctSPrava
                color: root.clrWidget
                radius: 50//Круг
            }
        }
        Timer {//таймер анимации Загрузки.
            id: tmrLoad
            //Свойства
            property int ntShagMax: rctLoad.ntShag;//Максимальный размер круга.
            property int ntInterval: root.ntHeight*92/ntShagMax//Интервал, за который изменится один шаг.
            property int ntShag: rctLoad.ntShag;//Считается размер круга.
            property bool isPlus: false//true - плюсуется рразмер. false - минусуется
            //Настройки
            interval: ntInterval; running: root.running; repeat: true
            //Функции
            onTriggered: {//Если таймер сработал, то...
                if(isPlus){//Если true, то...
                    ntShag++;
                    if(ntShag >= ntShagMax)
                        isPlus = false;
                }
                else{
                    ntShag--;
                    if(ntShag <= 1)
                        isPlus = true;
                }
            }
        }
	}
}
