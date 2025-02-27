import QtQuick 2.14
import QtQuick.Window 2.14
//DCTextInput - ШАБЛОН ДЛЯ РАБОТЫ СО СТРОКОЙ ТЕКСТА. (33 БУКВЫ, работает ESCAPE и ENTER)
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
    property alias placeholderText: txtTextInput.text//Текст в строке, подсказывающий, что нужно вводить юзеру
    property alias clrPlaceHolderText: txtTextInput.color//Цвет текста подсказки
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
            validator: RegExpValidator {//Чтоб не было SQL инъекции, запрещены символы ';*%_?\
                //regExp: /[0-9a-zA-Zа-яА-ЯёЁ ~`!@#№$^:&<>,./"(){}|=+-]+/
                //Если код начинается с ^ [^.....] то это запретить вводить и перечисляются символы.\\ - это \
                regExp: /[^';*%_\\?]+/
            }
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
				if((event.key === 16777220)||(event.key === 16777221)){//Код 16777220 и 16777221 - Enter
					tmTextInput.clickedEnter();//Излучаем сигнал о том, что нажат Enter.
					event.accepted = true;//Enter не использовался в качестве сочетания клавишь с другими клав
				}
				if(event.key === Qt.Key_Escape){
					tmTextInput.clickedEscape();//Излучаем сигнал о том, что нажат Ecape
				}
                if((event.key === 63)||(event.key === 39)||(event.key === 59)||(event.key === 42)
                   ||(event.key === 37)||(event.key === 95)||(event.key === 92)){
                    cppqml.strDebug = "Нельза использовать данные символы ? ' ; * % _ \\ ";
                }
                //console.log(event.key);
            }
            Text {//Текст, подсказывающий пользователю, что нужно вводить.
                id: txtTextInput
                anchors.fill: txnTextInput
                text: ""//По умолчанию нет надписи.
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#aaa"//Светло серый цвет по умолчанию.
                visible: !txnTextInput.text
            }
		}
    }
}
