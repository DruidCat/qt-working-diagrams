import QtQuick //2.15

Item{
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrKnopki: "grey"
    property real minDarker: 0.7//Миннимальная затемнённость кнопки, когда она не активная.
    property real maxDarker: 1.3//Максимальная затемнённость кнопки, когда она нажата.
    property bool enabled: true//true - активирована, false - деактивированна кнопка.
    property bool pressed: tphCopy.pressed//true - нажали false - не нажали
    property real tapHeight: ntWidth*ntCoff//Высота зоны нажатия пальцем или мышкой
    property real tapWidth: ntWidth*ntCoff//Ширина зоны нажатия пальцем или мышкой
    //Настройки.
    height: tapHeight
    width: tapWidth
    //Сигналы.
    signal clicked();
    //Функции.
    function fnTsvetLinii() {//Цвет линий с учётом состояния кнопки.
        if(root.enabled)//Если активирована кнопка, то...
            return tphCopy.pressed ? Qt.darker(clrKnopki, root.maxDarker) : clrKnopki
        return Qt.darker(clrKnopki, root.minDarker)//Кнопка деактивирована.
    }
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
        id: tphCopy
        enabled: root.enabled
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    Item {
        id: tmCopy
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root
        //Задний лист (контур, верхний правый). Передний лист перекрывает его снизу слева.
        Rectangle {//Задний лист: верхняя грань, ряд 0, столбцы 2-6.
            width: tmCopy.width*5/8
            height: tmCopy.height/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.leftMargin: tmCopy.width*2/8
            color: root.fnTsvetLinii()
        }
        Rectangle {//Задний лист: левая грань, столбец 2, ряды 1-2.
            width: tmCopy.width/8
            height: tmCopy.height*2/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height/8
            anchors.leftMargin: tmCopy.width*2/8
            color: root.fnTsvetLinii()
        }
        Rectangle {//Задний лист: правая грань, столбец 6, ряды 1-4.
            width: tmCopy.width/8
            height: tmCopy.height*4/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height/8
            anchors.leftMargin: tmCopy.width*6/8
            color: root.fnTsvetLinii()
        }
        Rectangle {//Задний лист: нижняя грань, ряд 4, столбцы 5-6.
            width: tmCopy.width*2/8
            height: tmCopy.height/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height*4/8
            anchors.leftMargin: tmCopy.width*5/8
            color: root.fnTsvetLinii()
        }
        //Передний лист (полный контур 5x5, нижний левый).
        Rectangle {//Передний лист: верхняя грань, ряд 3, столбцы 0-4.
            width: tmCopy.width*5/8
            height: tmCopy.height/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height*3/8
            color: root.fnTsvetLinii()
        }
        Rectangle {//Передний лист: левая грань, столбец 0, ряды 4-6.
            width: tmCopy.width/8
            height: tmCopy.height*3/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height*4/8
            color: root.fnTsvetLinii()
        }
        Rectangle {//Передний лист: правая грань, столбец 4, ряды 4-6.
            width: tmCopy.width/8
            height: tmCopy.height*3/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height*4/8
            anchors.leftMargin: tmCopy.width*4/8
            color: root.fnTsvetLinii()
        }
        Rectangle {//Передний лист: нижняя грань, ряд 7, столбцы 0-4.
            width: tmCopy.width*5/8
            height: tmCopy.height/8
            anchors.top: tmCopy.top
            anchors.left: tmCopy.left
            anchors.topMargin: tmCopy.height*7/8
            color: root.fnTsvetLinii()
        }
    }
}
