import QtQuick 2.14
import QtQuick.Window 2.14
import "qrc:/qml/buttons"//Импортируем кнопки
//Шаблон DCTextUdalit.qml - состоит из области, которая показывает текст удалённого документа.
Item {
    id: tmTextUdalit
    property int  ntWidth: 2
    property int ntCoff: 8
    property alias radius: rctTextUdalit.radius//Радиус зоны отображения удаляемого документа.
    property alias clrFona: rctTextUdalit.color//цвет фона
    property alias clrTexta: txtTextUdalit.color//цвет текста
    property color clrKnopki: "red"//цвет Кнопок
    property alias clrBorder: rctText.border.color//цвет границы
    property alias blVisible: rctTextUdalit.visible//Видимость объекта.
    property string kod: ""//Код удаляемого элемента
    property string text: "" //Имя элемента на удаление
    property alias bold: txtTextUdalit.font.bold
    property alias italic: txtTextUdalit.font.italic
    property alias textUdalit: txtTextUdalit//Передаём в виде свойства весь объект Text
    signal clickedUdalit(var strKod);//Сигнал на удаление вместе с кодом удаляемого эдемента.
    signal clickedOtmena();//Сигнал на отмену удаления.

    Rectangle {//Основной прямоугольник.
        id: rctTextUdalit
        anchors.fill: tmTextUdalit
        color: "transparent"
        visible: false
        DCKnopkaZakrit {//Кнопка Отмены удаления.
            id: knopkaUdalitOtmena
            ntWidth: tmTextUdalit.ntWidth
            ntCoff: tmTextUdalit.ntCoff
            anchors.verticalCenter: rctTextUdalit.verticalCenter
            anchors.left:rctTextUdalit.left
            anchors.margins: tmTextUdalit.ntCoff/2
            clrKnopki: tmTextUdalit.clrKnopki
            onClicked: {
                tmTextUdalit.clickedOtmena();//Запускаем сигнал Отмены удаления.
            }
        }
        Rectangle {
            id: rctText
            anchors.top: rctTextUdalit.top
            anchors.bottom: rctTextUdalit.bottom
            anchors.left: knopkaUdalitOtmena.right
            anchors.right: knopkaUdalitOk.left
            anchors.leftMargin: tmTextUdalit.ntCoff/2
            anchors.rightMargin: tmTextUdalit.ntCoff/2

            color: "transparent"
            border.color: "transparent"
            border.width: tmTextUdalit.ntCoff/8
            radius: tmTextUdalit.ntCoff/2
            clip: true//Обрезаем всё что больше этого прямоугольника.
            Text {
                id: txtTextUdalit
                anchors.fill: rctText
                color: tmTextUdalit.clrTexta
                font.pixelSize: tmTextUdalit.ntWidth*tmTextUdalit.ntCoff//размер шрифта текста.
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("УДАЛИТЬ: ")+tmTextUdalit.text+"?"
            }
        }
        DCKnopkaOk{//Кнопка подтверждения удаления.
            id: knopkaUdalitOk
            ntWidth: tmTextUdalit.ntWidth
            ntCoff: tmTextUdalit.ntCoff
            anchors.verticalCenter: rctTextUdalit.verticalCenter
            anchors.right: rctTextUdalit.right
            anchors.margins: tmTextUdalit.ntCoff/2
            clrKnopki: tmTextUdalit.clrKnopki
            onClicked: {
                tmTextUdalit.clickedUdalit(tmTextUdalit.kod);//Сигнал удаления с кодом удаляемого Элемента.
            }
        }
    }
}
