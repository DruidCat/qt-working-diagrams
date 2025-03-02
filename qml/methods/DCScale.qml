import QtQuick 2.14
import QtQuick.Window 2.14
import "qrc:/qml/buttons"//Импортируем кнопки
//DCScale - ШАБЛОН ДЛЯ РАБОТЫ С ЧИСЛАМИ И ИХ УВЕЛИЧЕНИЕМ И УМЕНЬШЕНИЕМ КНОПКАМИ [+] И [-].
Item {
    id: tmScale
	height: ntWidth*ntCoff
	width:	height*7
	property alias scale: txnScale//Передаём в виде свойства весь объект TextInput
    property alias radius: rctScale.radius//Радиус рабочей зоны
    property color clrFona: "transparent"//цвет текста
	property color clrTexta: "orange"
    property alias bold: txnScale.font.bold
    property alias italic: txnScale.font.italic
    property int  ntWidth: 2
    property int ntCoff: 8
	property int value: 0
	property int from: 0//Задаём значение по умолчанию.
	property int to: 32767//Задаём значение по умолчанию.
	property int step: 1
	signal valueModified();//Сигнал нажатия [-],[+],Enter с изменением значения. А значение по value получить.
	//onValueModified: console.error(value)
	onValueChanged:{//Если значение номера пришло из вне или из нутри метода, то...
		if(value < from){
			value = from;
		}
		if(value > to){
			value = to;
		}
		txnScale.text = value;//Это важная строка, она отображает Номер,когда он приходит из вне или внутри
	}
	onFromChanged:{//Защита от неверного ввода max и min значения, которое роняет приложение.
		if(from < 0){//С отрицательными числами DCScale не работает.
			from = 0;//Задаём значение по умолчанию.
			console.error(qsTr("DCScale.qml::from(int): from - задано отрицательное значение."));
			if(to < 0){//Если при этом to отрицательное число, то...
				to = 32767;//Задаём значение по умолчанию.
				console.error(qsTr("DCScale.qml::from(int): to - задано отрицательное значение."));
			}
		}
		else{//Если это не отрицательное значение, то...
			if(from > to){
				from = 0;//Задаём значение по умолчанию.
				to = 32767;//Задаём значение по умолчанию.
				console.error(qsTr("DCScale.qml::from(int): from > to."));
			}
		}
	}
	onToChanged:{//Защита от неверного ввода max и min значения, которое роняет приложение.
		if(to < 0){//С отрицательными числами DCScale не работает.
			to = 32767;//Задаём значение по умолчанию.
			console.error(qsTr("DCScale.qml::to(int): to - задано отрицательное значение."));
			if(from < 0){//Если при этом from отрицательное число, то...
				from = 0;//Задаём значение по умолчанию.
				console.error(qsTr("DCScale.qml::to(int): from - задано отрицательное значение."));
			}
		}
		else{//Если это не отрицательное значение, то...
			if(to < from){
				from = 0;//Задаём значение по умолчанию.
				to = 32767;//Задаём значение по умолчанию.
				console.error(qsTr("DCScale.qml::to(int): to < from."));
			}
		}
	}
	function fnClickedMinus(){//Функция нажатия кнопки минус.
		if(tmScale.value > tmScale.from){//Если нет равенства с минимальным значением, то..
			tmScale.value = tmScale.value - tmScale.step;//Уменьшаем.
			//А отображение value в txnScale.text произойдет в слоте onValueChanged
			tmScale.valueModified();//Отправляем Сигнал, как в оригинальном  виджете Scale.
		}
	}
	function fnClickedPlus(){//Функция нажатия кнопки плюс.
		if(tmScale.value < tmScale.to){//Если нет равенства с максимальным значением, то.
			tmScale.value = tmScale.value + tmScale.step;//Увеличиваем.
			//А отображение value в txnScale.text произойдет в слоте onValueChanged
			tmScale.valueModified();//Отправляем Сигнал, как в оригинальном  виджете Scale.
		}
	}
    Rectangle {
        id: rctScale
		anchors.centerIn: tmScale
		anchors.fill: tmScale
		color: tmScale.clrFona 

		DCKnopkaMinus{//Кнопка минус.
			id: knopkaMinus
			ntWidth: tmScale.ntWidth
			ntCoff: tmScale.ntCoff
			anchors.verticalCenter: rctScale.verticalCenter
			anchors.left:rctScale.left
			anchors.margins: tmScale.ntCoff/2
			clrKnopki: tmScale.clrTexta
			border: false
			onClicked: {
				fnClickedMinus();//Функция нажатия Минус.
			}
		}
		Rectangle {
			id: rctTextInput
			height: tmScale.ntWidth*tmScale.ntCoff
			width: height*4
			anchors.verticalCenter: rctScale.verticalCenter
			anchors.left: knopkaMinus.right
			anchors.margins: tmScale.ntCoff/2
			color: "transparent"
			border.color: tmScale.clrTexta
			border.width: tmScale.ntCoff/8
			clip: true//Обрезаем текст, который выходит за границы этогопрямоугольника.
			Text {
				anchors.verticalCenter: rctTextInput.verticalCenter
				anchors.right: rctTextInput.right
				anchors.margins: tmScale.ntCoff/4
				color: tmScale.clrTexta
				font.pixelSize: tmScale.ntWidth*tmScale.ntCoff//размер шрифта текста.
				text: "%"
			}
			TextInput {//Область текста.
				id: txnScale
				anchors.left: rctTextInput.left
				anchors.right: rctTextInput.right
				anchors.verticalCenter: rctTextInput.verticalCenter
				color: tmScale.clrTexta
				horizontalAlignment: TextInput.AlignHCenter
				verticalAlignment: TextInput.AlignVCenter

				font.pixelSize: tmScale.ntWidth*tmScale.ntCoff//размер шрифта текста.
				readOnly: true//Нельзя редактировать. 
				text: tmScale.value
				Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
					//console.error(event.key);
				}
				onTextChanged: {//Если текст меняет пользователь вручную или кнопками.
					var ntValue = txnScale.text;//Приравниваем значение.
					if(ntValue > tmScale.to){//Если пользователь вводит число больше заданного
						if(tmScale.value != tmScale.to){//Если нет равенства, то...
							tmScale.value = tmScale.to;//Выставляем максимальное значение.
							text = tmScale.value;//В этом слоте,onValueChanged не срабатывает,приравнив
							tmScale.valueModified();//Отправляем Сигнал, как в оригинальном Scale.
						}
						else{
							if(ntValue > tmScale.to){
								tmScale.value = tmScale.to;//Выставляем максимальное значение.
								text = tmScale.value;//В этом слоте,onValueChanged не срабатывает,прирав
							}
						}
					}
					if(ntValue < tmScale.from){//Если пользователь вводит число меньше заданного
						if(tmScale.value != tmScale.from){//Если нет равенства, то...
							tmScale.value = tmScale.from;//Выставляем минимальное значение.
							text = tmScale.value;//В этом слоте,onValueChanged не срабатывает,приравнив
							tmScale.valueModified();//Отправляем Сигнал, как в оригинальном Scale.
						}
						else{
							if(ntValue < tmScale.from){
								tmScale.value = tmScale.from;//Выставляем минимальное значение.
								text = tmScale.value;//В этом слоте,onValueChanged не срабатывает,прирав
							}
						}
					}
				}
			}
		}
        DCKnopkaPlus {//Кнопка плюс.
			id: knopkaPlus
			ntWidth: tmScale.ntWidth
			ntCoff: tmScale.ntCoff
			anchors.verticalCenter: rctScale.verticalCenter
			anchors.right:rctScale.right
			anchors.margins: tmScale.ntCoff/2
			clrKnopki: tmScale.clrTexta
			border: false
			onClicked: {
				fnClickedPlus();//Функция нажатия Плюс.
			}
		}
    }
}
