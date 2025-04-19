import QtQuick //2.15
//Шаблон DCProgress.qml - состоит из области, которая показывает прогресс какого либо процесса
Item {
    id: root
    property alias radius: rctProgress.radius//Радиус зоны отображения виджета поиска.
    property alias clrProgress: rctProgress.color//цвет фона
    property bool running: false//флаг который будет запускать таймер пролосы прогресса.

    visible: running ? true : false//Видимость зависит от статуса запущеного таймера.

    Rectangle {//Основной прямоугольник.
        id: rctProgress
        width: 0
        height: root.height
        anchors.top: root.top
        anchors.left: root.left
        color: "orange"
        radius: root.ntCoff/2
    }

    Timer {
        id: tmrProgress
        interval: 1100; repeat: true;
        running: root.running ? true : false
        property int ntShag: 0
        onTriggered: {
            if(ntShag < 100){
                ntShag += 1;
                rctProgress.width = ntShag * root.width / 100
            }
            else
                root.running = false;
        }
    }
}
