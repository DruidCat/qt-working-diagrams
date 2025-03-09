import QtQuick //2.14
//import QtQuick.Window //2.14
import "qrc:/qml/buttons"//Импортируем кнопки
//DCPassword - ШАБЛОН ДЛЯ РАБОТЫ С ВВОДОМ ПАРОЛЕЙ.
Item {
    id: tmPassword
    property alias password: txnTextInput.text //Текст
	property alias textInput: txnTextInput//Передаём в виде свойства весь объект TextInput
    property alias radius: rctTextInput.radius//Радиус рабочей зоны
    property alias clrFona: rctPassword.color //цвет текста
    property alias clrFonaPass: rctTextInput.color //цвет текста
    property alias clrTexta: txnTextInput.color //цвет текста
    property color clrKnopki: "yellow"//цвет Кнопок
    property alias clrBorder: rctTextInput.border.color//цвет границы
    property alias blVisible: rctPassword.visible//Видимость объекта.
    property int  ntWidth: 2
    property int ntCoff: 8
    property alias placeholderText: txtTextInput.text//Текст в строке, подсказывающий, что нужно вводить юзеру
    property alias clrPlaceHolderText: txtTextInput.color//Цвет текста подсказки
	signal clickedOk(var strPassword);//Сигнал нажатия Enter
	signal clickedOtmena();//Сигнал нажатия Escape

	Rectangle {
		id: rctPassword
		anchors.fill: tmPassword
        color: "transparent"
        radius: tmPassword.ntCoff/2
        visible: false
        DCKnopkaZakrit {//@disable-check M300//Кнопка Отмены удаления.
            id: knopkaOtmena
            ntWidth: tmPassword.ntWidth
            ntCoff: tmPassword.ntCoff
            anchors.verticalCenter: rctPassword.verticalCenter
            anchors.left:rctPassword.left
            anchors.margins: tmPassword.ntCoff/2
            clrKnopki: tmPassword.clrKnopki
            onClicked: {
                tmPassword.clickedOtmena();//Запускаем сигнал Отмены удаления.
            }
        }
		Rectangle {
			id: rctTextInput
			anchors.top: rctPassword.top
            anchors.bottom: rctPassword.bottom
            anchors.left: knopkaOtmena.right
            anchors.right: knopkaOk.left
            anchors.leftMargin: tmPassword.ntCoff/2
            anchors.rightMargin: tmPassword.ntCoff/2

			color: "transparent"//Текст фона прозрачный.
			border.color: "transparent"
            border.width: tmPassword.ntCoff/8
            radius: tmPassword.ntCoff/2
			clip: true//Обрезаем текст, который выходит за границы этого прямоугольника.
			TextInput {//Область текста.
				id: txnTextInput
				anchors.left: rctTextInput.left
				anchors.right: rctTextInput.right
				anchors.verticalCenter: rctTextInput.verticalCenter
				color: "black"//цвет текста
				horizontalAlignment: TextInput.AlignHCenter
				verticalAlignment: TextInput.AlignVCenter
				echoMode: TextInput.Password
				text: ""
				font.pixelSize: tmPassword.ntWidth*tmPassword.ntCoff//размер шрифта текста.
				maximumLength: 32//Максимальная длина пароля pdf документа. Но не меньше 6 символов.
				readOnly: false//Можно редактировать. 
				focus: true//Фокус на TextInput
				selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
				//cursorPosition: text.length;//Курсор в конец текста
				cursorVisible: true//Курсор сделать видимым
				Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
					if((event.key === 16777220)||(event.key === 16777221)){//Код 16777220 и 16777221 - Enter
						tmPassword.clickedOk(txnTextInput.text);//Излучаем сигнал о том, что нажат Enter.
						event.accepted = true;//Enter не использовался в качестве сочетания клавишь с другими клав
					}
					if(event.key === Qt.Key_Escape){
						tmPassword.clickedOtmena();//Излучаем сигнал о том, что нажат Ecape
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
        DCKnopkaOk{//@disable-check M300//Кнопка подтверждения пароля.
            id: knopkaOk
            ntWidth: tmPassword.ntWidth
            ntCoff: tmPassword.ntCoff
            anchors.verticalCenter: rctPassword.verticalCenter
            anchors.right: rctPassword.right
            anchors.margins: tmPassword.ntCoff/2
            clrKnopki: tmPassword.clrKnopki
            onClicked: {
				var password = txnTextInput.text;
				txnTextInput.text = "";
                tmPassword.clickedOk(password);//Сигнал подтверждения Пароля.
            }
        }
	}
}
