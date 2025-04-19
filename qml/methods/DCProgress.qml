import QtQuick //2.15
//Шаблон DCProgress.qml - состоит из области, которая показывает прогресс какого либо процесса
Item {
    id: root
    property alias radius: rctProgress.radius//Радиус зоны отображения виджета поиска.
    property alias clrProgress: rctProgress.color//цвет фона
    property alias clrTexta: txtProgress.color//цвет фона
    property bool running: false//флаг который будет запускать таймер пролосы прогресса.
    property int progress: 0//Свойство прогресса от 0 до 100
    property alias text: txtProgress.text

    visible: running ? true : false//Видимость зависит от статуса запущеного таймера.

    onRunningChanged: {
        root.progress = 0;//Обнуляем счётчик.
    }

    Text {
        id: txtProgress
        anchors.fill: root
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "grey"
        text: ""
        z: 1
    }
    Rectangle {//Основной прямоугольник.
        id: rctProgress
        width: 0; height: root.height
        anchors.top: root.top; anchors.left: root.left
        color: "orange"; radius: 1
        z: 0
    }
    Timer {
        id: tmrProgress
        interval: 110; repeat: true;
        running: root.running ? true : false
        onTriggered: {//Срабатывает таймер.
            if(root.progress <= 100){//Если меньше 100%
                root.progress += 1;//+1
                rctProgress.width = root.progress * root.width/100;//Задаём длину прогресса.
            }
            else{//Если больше 100, то...
                rctProgress.width = 0;//Длину прогресса сбрасываем до 0
                root.running = false;//Отключаем таймер.
            }
        }
    }
}
