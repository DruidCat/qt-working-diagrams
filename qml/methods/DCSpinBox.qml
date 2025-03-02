﻿import QtQuick 2.14
import QtQuick.Window 2.14
import "qrc:/qml/buttons"//Импортируем кнопки
//DCSpinBox - ШАБЛОН ДЛЯ РАБОТЫ С ЧИСЛАМИ И ИХ УВЕЛИЧЕНИЕМ И УМЕНЬШЕНИЕМ КНОПКАМИ [+] И [-].
Item {
    id: tmSpinBox
	height: ntWidth*ntCoff
	width:	height*6
	property alias spinBox: txnSpinBox//Передаём в виде свойства весь объект TextInput
    property alias radius: rctSpinBox.radius//Радиус рабочей зоны
    property color clrFona: "transparent"//цвет текста
	property color clrTexta: "orange"
    property alias bold: txnSpinBox.font.bold
    property alias italic: txnSpinBox.font.italic
    property int  ntWidth: 2
    property int ntCoff: 8
	property int value: 0
	property int from: 0//Задаём значение по умолчанию.
	property int to: 32767//Задаём значение по умолчанию.
	signal valueModified();//Сигнал нажатия [-],[+],Enter с изменением значения. А значение по value получить.
	//onValueModified: console.error(value)
	onValueChanged:{//Если значение номера пришло из вне или из нутри метода, то...
		if(value < from){
			value = from;
		}
		if(value > to){
			value = to;
		}
		txnSpinBox.text = value;//Это важная строка, она отображает Номер,когда он приходит из вне или внутри
	}
	onFromChanged:{//Защита от неверного ввода max и min значения, которое роняет приложение.
		if(from < 0){//С отрицательными числами DCSpinBox не работает.
			from = 0;//Задаём значение по умолчанию.
			console.error(qsTr("DCSpinBox.qml::from(int): from - задано отрицательное значение."));
			if(to < 0){//Если при этом to отрицательное число, то...
				to = 32767;//Задаём значение по умолчанию.
				console.error(qsTr("DCSpinBox.qml::from(int): to - задано отрицательное значение."));
			}
		}
		else{//Если это не отрицательное значение, то...
			if(from > to){
				from = 0;//Задаём значение по умолчанию.
				to = 32767;//Задаём значение по умолчанию.
				console.error(qsTr("DCSpinBox.qml::from(int): from > to."));
			}
		}
	}
	onToChanged:{//Защита от неверного ввода max и min значения, которое роняет приложение.
		if(to < 0){//С отрицательными числами DCSpinBox не работает.
			to = 32767;//Задаём значение по умолчанию.
			console.error(qsTr("DCSpinBox.qml::to(int): to - задано отрицательное значение."));
			if(from < 0){//Если при этом from отрицательное число, то...
				from = 0;//Задаём значение по умолчанию.
				console.error(qsTr("DCSpinBox.qml::to(int): from - задано отрицательное значение."));
			}
		}
		else{//Если это не отрицательное значение, то...
			if(to < from){
				from = 0;//Задаём значение по умолчанию.
				to = 32767;//Задаём значение по умолчанию.
				console.error(qsTr("DCSpinBox.qml::to(int): to < from."));
			}
		}
	}
	function fnClickedEscape (){//Функция нажатия Escape.
		txnSpinBox.text = tmSpinBox.value;//Отображаем последнее значение.
	}
	function fnClickedEnter(){//Функция нажатия Enter/
		if(txnSpinBox.text){//Если не пустая строка, то...
			tmSpinBox.value = txnSpinBox.text;//Приравниваем обязательно.
			tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном  виджете SpinBox.
		}
		else//Если пустая строка, пользователь удалил число, то...
			fnClickedEscape();//Функция нажатия Escape, запонить пустое значение последним значением.
	}
	function fnClickedMinus(){//Функция нажатия кнопки минус.
		if(txnSpinBox.text){//Если не пустая строка, то...
			if(tmSpinBox.value != txnSpinBox.text){//Если нет равенства, значит число вручную ввели.
				tmSpinBox.value = txnSpinBox.text;//Приравниваем, чтоб не застрять в этом неравенстве.
				tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном  виджете SpinBox.
			}
			else{//Если есть равенство, значит изменение идёт через + или -
				if(tmSpinBox.value != tmSpinBox.from){//Если нет равенства с минимальным значением, то..
					tmSpinBox.value = tmSpinBox.value - 1;//Уменьшаем.
					//А отображение value в txnSpinBox.text произойдет в слоте onValueChanged
					tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном  виджете SpinBox.
				}
			}
		}
		else{//Если пустая строка, то...
			fnClickedEscape();//Эмулируем нажатия Escape. Выставляем прежнее значение.
		}	
	}
	function fnClickedPlus(){//Функция нажатиякнопки плюс.
		if(txnSpinBox.text){//Если не пустая строка, то...
			if(tmSpinBox.value != txnSpinBox.text){//Если нет равенства, значит число вручную ввели.
				tmSpinBox.value = txnSpinBox.text;//Приравниваем, чтоб не застрять в этом неравенстве.
				tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном  виджете SpinBox.
			}
			else{//Если есть равенство, значит изменение идёт через + или -
				if(tmSpinBox.value != tmSpinBox.to){//Если нет равенства с максимальным значением, то.
					tmSpinBox.value = tmSpinBox.value + 1;//Увеличиваем.
					//А отображение value в txnSpinBox.text произойдет в слоте onValueChanged
					tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном  виджете SpinBox.
				}
			}
		}
		else{//Если пустая строка, то...
			fnClickedEscape();//Эмулируем нажатия Escape. Выставляем прежнее значение.
		}
	}
    Rectangle {
        id: rctSpinBox
		anchors.centerIn: tmSpinBox
		anchors.fill: tmSpinBox
		color: tmSpinBox.clrFona 

		DCKnopkaMinus{//Кнопка минус.
			id: knopkaMinus
			ntWidth: tmSpinBox.ntWidth
			ntCoff: tmSpinBox.ntCoff
			anchors.verticalCenter: rctSpinBox.verticalCenter
			anchors.left:rctSpinBox.left
			anchors.margins: tmSpinBox.ntCoff/2
			clrKnopki: tmSpinBox.clrTexta
			onClicked: {
				fnClickedMinus();//Функция нажатия Минус.
			}
		}
		Rectangle {
			id: rctTextInput
			height: tmSpinBox.ntWidth*tmSpinBox.ntCoff
			width: height*3
			anchors.verticalCenter: rctSpinBox.verticalCenter
			anchors.left: knopkaMinus.right
			anchors.margins: tmSpinBox.ntCoff/2
			color: "transparent"
			clip: true//Обрезаем текст, который выходит за границы этогопрямоугольника.
			TextInput {//Область текста.
				id: txnSpinBox
				anchors.left: rctTextInput.left
				anchors.right: rctTextInput.right
				anchors.verticalCenter: rctTextInput.verticalCenter
				color: tmSpinBox.clrTexta
				horizontalAlignment: TextInput.AlignHCenter
				verticalAlignment: TextInput.AlignVCenter
				//TODO Qt6 интерфейс. Закоментировать не нужный.
				/*
				validator: RegularExpressionValidator {//Чтоб не было букв.
					regularExpression: /[0-9]+/
				}
				*/
				//TODO Qt5 Интерфейс. Закоментировать не нужный.
				
				validator: RegExpValidator {//Чтоб не было букв.
					regExp: /[0-9]+/
				}

				text: tmSpinBox.value
				font.pixelSize: tmSpinBox.ntWidth*tmSpinBox.ntCoff//размер шрифта текста.
				readOnly: false//Можно редактировать. 
				focus: true//Фокус на TextInput
				selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
				//cursorPosition: text.length;//Курсор в конец текста
				cursorVisible: true//Курсор сделать видимым
				Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
					if((event.key === 16777220)||(event.key === 16777221)){//Код 16777220 и 16777221 - Enter
						fnClickedEnter();//Функция нажатия Enter.
						event.accepted = true;//Enter не использовался в сочетании клавишь с другими клавишами
					}
					if(event.key === Qt.Key_Escape){
						fnClickedEscape();//функция нажатия Escape
					}
					//console.error(event.key);
				}
				onFocusChanged: {//Если фокус изменился...
					if(!text){//Если пустая строчка, то...
						if(!focus){//Если фокус пропал, то...
							fnClickedEscape();//То выставляем последнее значение.
						}
					}
				}
				onTextChanged: {//Если текст меняет пользователь вручную или кнопками.
					var ntValue = txnSpinBox.text;//Приравниваем значение.
					if(text){//Если не пустая строка, эта важная строка, чтоб можно было вводить число.
						if(ntValue > tmSpinBox.to){//Если пользователь вводит число больше заданного
							if(tmSpinBox.value != tmSpinBox.to){//Если нет равенства, то...
								tmSpinBox.value = tmSpinBox.to;//Выставляем максимальное значение.
								text = tmSpinBox.value;//В этом слоте,onValueChanged не срабатывает,приравнив
								tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном SpinBox.
							}
							else{
								if(ntValue > tmSpinBox.to){
									tmSpinBox.value = tmSpinBox.to;//Выставляем максимальное значение.
									text = tmSpinBox.value;//В этом слоте,onValueChanged не срабатывает,прирав
								}
							}
						}
						if(ntValue < tmSpinBox.from){//Если пользователь вводит число меньше заданного
							if(tmSpinBox.value != tmSpinBox.from){//Если нет равенства, то...
								tmSpinBox.value = tmSpinBox.from;//Выставляем минимальное значение.
								text = tmSpinBox.value;//В этом слоте,onValueChanged не срабатывает,приравнив
								tmSpinBox.valueModified();//Отправляем Сигнал, как в оригинальном SpinBox.
							}
							else{
								if(ntValue < tmSpinBox.from){
									tmSpinBox.value = tmSpinBox.from;//Выставляем минимальное значение.
									text = tmSpinBox.value;//В этом слоте,onValueChanged не срабатывает,прирав
								}
							}
						}
					}
				}
			}
		}
        DCKnopkaPlus {//Кнопка плюс.
			id: knopkaPlus
			ntWidth: tmSpinBox.ntWidth
			ntCoff: tmSpinBox.ntCoff
			anchors.verticalCenter: rctSpinBox.verticalCenter
			anchors.right:rctSpinBox.right
			anchors.margins: tmSpinBox.ntCoff/2
			clrKnopki: tmSpinBox.clrTexta
			onClicked: {
				fnClickedPlus();//Функция нажатия Плюс.
			}
		}
    }
}
