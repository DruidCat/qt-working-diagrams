import QtQuick
import QtQuick.Window

Item {
    id: tmTextInput
    property alias text: txnTextInput.text //Текст
	property alias textInput: txnTextInput//Передаём в виде свойства весь объект TextInput
    property alias radius: rctTextInput.radius//Радиус рабочей зоны
    property alias clrFona: rctTextInput.color //цвет текста
    property alias clrTexta: txnTextInput.color //цвет текста
    property alias bold: txnTextInput.font.bold
    property alias italic: txnTextInput.font.italic
    property int  ntWidth: 2
    property int ntCoff: 8
    anchors.fill: parent

    Rectangle {
        id: rctTextInput
		anchors.fill: tmTextInput
		color: "transparent"//Текст фона прозрачный.
		clip: true//Обрезаем текст, который выходит за границы этогопрямоугольника.
		TextInput {//Область текста.
			id: txnTextInput
			anchors.left: rctTextInput.left
			anchors.right: rctTextInput.right
			anchors.verticalCenter: rctTextInput.verticalCenter
			color: "black"//цвет текста
			horizontalAlignment: TextInput.AlignHCenter
			verticalAlignment: TextInput.AlignVCenter
			text: ""
			font.pixelSize: tmTextInput.ntWidth*tmTextInput.ntCoff//размер шрифта текста.
			readOnly: false//Можно редактировать. 
			focus: true//Фокус на TextInput
			selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
		}
    }
}
