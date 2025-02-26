import QtQuick 2.14
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
	property int number: 0
	property int numberMin: -32767
	property int numberMax: 32767
	signal clicked(var ntNomer);//Сигнал нажатия кнопок [-],[+],Escape, Enter с передачей номера.

	onNumberChanged:{//Если значение номера пришло из вне или из нутри метода, то...
		if(number < numberMin){
			number = numberMin;
		}
		if(number > numberMax){
			number = numberMax;
		}
		txnSpinBox.text = number;//Это важная строка, она отображает Номер,когда он приходит из вне или внутри
	}
	function fnClickedEscape (){//Функция нажатия Escape.
		txnSpinBox.text = tmSpinBox.number;//Отображаем последнее значение.
	}
	function fnClickedEnter(){//Функция нажатия Enter/
		tmSpinBox.number = txnSpinBox.text;//Приравниваем обязательно.
		tmSpinBox.clicked(txnSpinBox.text);//Отправляем сигнал со значением.
	}
	function fnClickedMinus(){//Функция нажатия кнопки минус.
		if(txnSpinBox.text){//Если не пустая строка, то...
			if(tmSpinBox.number != txnSpinBox.text){//Если нет равенства, значит число вручную ввели.
				tmSpinBox.number = txnSpinBox.text;//Приравниваем, чтоб не застрять в этом неравенстве.
				tmSpinBox.clicked(tmSpinBox.number);//Вернём сигнал с номером SpinBox
			}
			else{//Если есть равенство, значит изменение идёт через + или -
				if(tmSpinBox.number != tmSpinBox.numberMin){//Если нет равенства с минимальным значением, то..
					tmSpinBox.number = tmSpinBox.number - 1;//Уменьшаем.
					//О отображение number в txnSpinBox.text произойдет в слоте onNumberChanged
					tmSpinBox.clicked(tmSpinBox.number);//Вернём сигнал с номером SpinBox
				}
			}
		}
		else{//Если пустая строка, то...
			fnClickedEscape();//Эмулируем нажатия Escape. Выставляем прежнее значение.
		}	
	}
	function fnClickedPlus(){//Функция нажатиякнопки плюс.
		if(txnSpinBox.text){//Если не пустая строка, то...
			if(tmSpinBox.number != txnSpinBox.text){//Если нет равенства, значит число вручную ввели.
				tmSpinBox.number = txnSpinBox.text;//Приравниваем, чтоб не застрять в этом неравенстве.
				tmSpinBox.clicked(tmSpinBox.number);//Вернём сигнал с номером SpinBox
			}
			else{//Если есть равенство, значит изменение идёт через + или -
				if(tmSpinBox.number != tmSpinBox.numberMax){//Если нет равенства с максимальным значением, то.
					tmSpinBox.number = tmSpinBox.number + 1;//Увеличиваем.
					//О отображение number в txnSpinBox.text произойдет в слоте onNumberChanged
					tmSpinBox.clicked(tmSpinBox.number);//Вернём сигнал с номером SpinBox
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
				validator: RegExpValidator {//Чтоб не было букв.
					regExp: /[0-9]+/
				}
				text: tmSpinBox.number
				font.pixelSize: tmSpinBox.ntWidth*tmSpinBox.ntCoff//размер шрифта текста.
				readOnly: false//Можно редактировать. 
				focus: true//Фокус на TextInput
				selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
				//cursorPosition: text.length;//Курсор в конец текста
				cursorVisible: true//Курсор сделать видимым
				Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
					if(event.key === 16777220){//Код 16777220 - Enter
						fnClickedEnter();//Функция нажатия Enter.
						event.accepted = true;//Enter не использовался в сочетании клавишь с другими клавишами
					}
					if(event.key === Qt.Key_Escape){
						fnClickedEscape();//функция нажатия Escape
					}
					//console.log(event.key);
				}
				onFocusChanged: {//Если фокус изменился...
					if(!text){//Если пустая строчка, то...
						if(!focus){//Если фокус пропал, то...
							fnClickedEscape();//То выставляем последнее значение.
						}
					}
				}
				onTextChanged: {//Если текст меняет пользователь вручную или кнопками.
					var ntNumber = txnSpinBox.text;//Приравниваем значение.
					if(text){//Если не пустая строка, эта важная строка, чтоб можно было вводить число.
						if(ntNumber > tmSpinBox.numberMax){//Если пользователь вводит число больше заданного
							if(tmSpinBox.number != tmSpinBox.numberMax){//Если нет равенства, то...
								tmSpinBox.number = tmSpinBox.numberMax;//Выставляем максимальное значение.
								//О отображение number в txnSpinBox.text произойдет в слоте onNumberChanged
								clicked(tmSpinBox.number);//Отправляем сигнал с максимальным номером.
							}
							else{
								if(ntNumber > tmSpinBox.numberMax){
									tmSpinBox.number = tmSpinBox.numberMax;//Выставляем максимальное значение.
									//Отображение number в txnSpinBox.text произойдет в слоте onNumberChanged
								}
							}
						}
						if(ntNumber < tmSpinBox.numberMin){//Если пользователь вводит число меньше заданного
							if(tmSpinBox.number != tmSpinBox.numberMin){//Если нет равенства, то...
								tmSpinBox.number = tmSpinBox.numberMin;//Выставляем минимальное значение.
								//Отображение number в txnSpinBox.text произойдет в слоте onNumberChanged
								clicked(tmSpinBox.number);//Отправляем сигнал с минимальным номером.
							}
							else{
								if(ntNumber < tmSpinBox.numberMin){
									tmSpinBox.number = tmSpinBox.numberMin;//Выставляем минимальное значение.
									//Отображение number в txnSpinBox.text произойдет в слоте onNumberChanged
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
