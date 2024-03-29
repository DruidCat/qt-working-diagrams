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
	signal clickedEnter();//Сигнал нажатия Enter
	signal clickedEscape();//Сигнал нажатия Escape

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
			//font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
			maximumLength: 33//Максимальная длина ввода текста.
			readOnly: false//Можно редактировать. 
			focus: true//Фокус на TextInput
			selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
			//cursorPosition: text.length;//Курсор в конец текста
			cursorVisible: true//Курсор сделать видимым
			Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
				if(event.key === 16777220){//Код 16777220 - Enter
					tmTextInput.clickedEnter();//Излучаем сигнал о том, что нажат Enter.
					event.accepted = true;//Enter не использовался в качестве сочетания клавишь с другими клав
				}
				if(event.key === Qt.Key_Escape){
					tmTextInput.clickedEscape();//Излучаем сигнал о том, что нажат Ecape
				}
			}
		}
    }
}
