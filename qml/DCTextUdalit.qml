import QtQuick 2.14
import QtQuick.Window 2.14
import "qrc:/qml/buttons"//Импортируем кнопки
//Шаблон DCTextUdalit.qml - состоит из области, которая показывает текст удалённого документа.
Item {
    id: tmTextUdalit
    anchors.fill: parent
    property alias text: txtTextUdalit.text //Текст
    property alias blVisible: rctTextUdalit.visible//Видимость объекта.
    property alias textUdalit: txtTextUdalit//Передаём в виде свойства весь объект Text
    property alias radius: rctTextUdalit.radius//Радиус рабочей зоны
    property alias clrFona: rctTextUdalit.color //цвет фона
    property alias clrTexta: txtTextUdalit.color //цвет текста
    //property alias clrBorder: txtTextUdalit.color.border //цвет границы
    property alias bold: txtTextUdalit.font.bold
    property alias italic: txtTextUdalit.font.italic
    property int  ntWidth: 2
    property int ntCoff: 8

    Rectangle {
        id: rctTextUdalit
        anchors.fill: tmTextUdalit
        radius: tmTextUdalit.ntCoff/2
        visible: false
        DCKnopkaZakrit {
            id: knopkaUdalitOtmena
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
            anchors.verticalCenter: tmTextUdalit.verticalCenter
            anchors.left:tmZagolovok.left
            anchors.margins: tmTextUdalit.ntCoff/2
            clrKnopki: "red"
            onClicked: {
                //fnClickedUdalitOtmena();//Запускаем функцию Отмены удаления.
            }
        }
        Rectangle {
            id: rctText
            anchors.verticalCenter: tmTextUdalit.verticalCenter
            anchors.left:knopkaUdalitOtmena.right
            clip: true//Обрезаем текст, который выходит за границы этого прямоугольника.
            color: "black"
            border.width: tmDannie.ntCoff/4
            border.color: "red"
            radius: tmTextUdalit.ntCoff/2
            Text {
                id: txtTextUdalit
                anchors.fill: rctText
                color: "red"
                font.pixelSize: tmTextUdalit.ntWidth*tmTextUdalit.ntCoff//размер шрифта текста.
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                text: ""
            }
        }
        DCKnopkaOk{
            id: knopkaUdalitOk
            ntWidth: tmTextUdalit.ntWidth
            ntCoff: tmTextUdalit.ntCoff
            anchors.verticalCenter: tmTextUdalit.verticalCenter
            anchors.left: rctText.right
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: "red"
            clrFona: tmTextUdalit.clrFona
            onClicked: {
                //fnClickedUdalitOk();//Функция переименование данных.
            }
        }
    }
}
