import QtQuick //2.15
//Шаблон DCProgress.qml - состоит из области, которая показывает прогресс какого либо процесса
Item {
    id: root
    //anchors.fill: parent
    visible: false//невидимый по умолчанию

    property alias radius: rctProgress.radius//Радиус зоны отображения виджета поиска.
    property alias clrFona: rctProgress.color//цвет фона
    property bool running: false//флаг который будет запускать таймер пролосы прогресса.

    Rectangle {//Основной прямоугольник.
        id: rctProgress
        width: 0
        height: root.height
        anchors.top: root.top
        anchors.left: root.left
        color: "transparent"
        radius: root.ntCoff/2
    }

    Timer {
        id: tmrProgress
        interval: 110; repeat: false; running: false;
        property int ntShag: 0
        onTriggered: {

        }
    }
}
