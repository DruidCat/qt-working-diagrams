import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
//DCScale - ШАБЛОН ДЛЯ РАБОТЫ С ЧИСЛАМИ И ИХ УВЕЛИЧЕНИЕМ И УМЕНЬШЕНИЕМ КНОПКАМИ [+] И [-].
Item {
    id: root
    //Свойства.
    property alias scale: txtScale//Передаём в виде свойства весь объект TextInput
    property alias radius: rctScale.radius//Радиус рабочей зоны
    property color clrFona: "transparent"//цвет текста
	property color clrTexta: "orange"
    property alias bold: txtScale.font.bold
    property alias italic: txtScale.font.italic
    property int  ntWidth: 2
    property int ntCoff: 8
	property int value: 0
	property int from: 0//Задаём значение по умолчанию.
	property int to: 32767//Задаём значение по умолчанию.
	property int stepSize: 1
    property real tapKnopkaMinus: 1
    property real tapCentor: 3.6
    property real tapKnopkaPlus: 1
    //Настройки.
    height: ntWidth*ntCoff
    width:	height*(tapKnopkaMinus+tapCentor+tapKnopkaPlus)
    //Сигналы.
	signal valueModified();//Сигнал нажатия [-],[+],Enter с изменением значения. А значение по value получить.
    //Функции.
	//onValueModified: console.error(value)
	onValueChanged:{//Если значение номера пришло из вне или из нутри метода, то...
        if(value <= from){//Если число меньше или РАВНО минимального, то...
            value = from;//Приравниваем минимальному значению число.
            knopkaMinus.enabled = false;//Кнопка Минус не активная.
            knopkaPlus.enabled = true;//Кнопка Плюс активная.
        }
        else {
            if(value >= to){//Если число больше или РАВНО максимально, то...
                value = to;//Приравниваем максимальное число значению.
                knopkaPlus.enabled = false;//Кнопка Плюс не активная.
                knopkaMinus.enabled = true;//Кнопка Минус активная.
            }
            else{//Если значение не меньше и не больше заданного, то...
                knopkaMinus.enabled = true;//Кнопка Минус активная.
                knopkaPlus.enabled = true;//Кнопка Плюс активная.
            }
        }
        txtScale.text = value;//Это важная строка, она отображает Номер,когда он приходит из вне или внутри
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
	onStepSizeChanged: {
		if(stepSize < 1){
			stepSize = 1;
			console.error(qsTr("DCScale.qml::stepSize(int): значение меньше 1."));
		}
	}
	function fnClickedMinus(){//Функция нажатия кнопки минус.
        if(root.value > root.from){//Если нет равенства с минимальным значением, то..
            root.value = root.value - root.stepSize;//Уменьшаем.
            //А отображение value в txtScale.text произойдет в слоте onValueChanged
            root.valueModified();//Отправляем Сигнал, как в оригинальном  виджете Scale.
		}
	}
	function fnClickedPlus(){//Функция нажатия кнопки плюс.
        if(root.value < root.to){//Если нет равенства с максимальным значением, то.
            root.value = root.value + root.stepSize;//Увеличиваем.
            //А отображение value в txtScale.text произойдет в слоте onValueChanged
            root.valueModified();//Отправляем Сигнал, как в оригинальном  виджете Scale.
		}
	}
    Rectangle {
        id: rctScale
        anchors.fill: root
        color: root.clrFona
        DCKnopkaMinus{//Кнопка минус.
			id: knopkaMinus
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: rctScale.verticalCenter
			anchors.left:rctScale.left
            clrKnopki: root.clrTexta
			border: false
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaMinus
            onClicked: fnClickedMinus();//Функция нажатия Минус.
		}
		Rectangle {
			id: rctTextInput
            height: root.ntWidth*root.ntCoff
			anchors.verticalCenter: rctScale.verticalCenter
            anchors.left: knopkaMinus.right; anchors.right: knopkaPlus.left
            color: "transparent"
            border.color: root.clrTexta
            border.width: root.ntCoff/8
            clip: true//Обрезаем текст, который выходит за границы этогопрямоугольника.
            Text {//Область текста.
                id: txtScale
                anchors.left: rctTextInput.left; anchors.right: txtProcent.left
				anchors.verticalCenter: rctTextInput.verticalCenter
                color: root.clrTexta
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                text: root.value
				onTextChanged: {//Если текст меняет пользователь вручную или кнопками.
                    let ntValue = parseInt(txtScale.text);//Приравниваем значение.
                    if(ntValue > root.to){//Если пользователь вводит число больше заданного
                        if(root.value !== root.to){//Если нет равенства, то...
                            root.value = root.to;//Выставляем максимальное значение.
                            text = root.value;//В этом слоте,onValueChanged не срабатывает,приравнив
                            root.valueModified();//Отправляем Сигнал, как в оригинальном Scale.
						}
						else{
                            if(ntValue > root.to){
                                root.value = root.to;//Выставляем максимальное значение.
                                text = root.value;//В этом слоте,onValueChanged не срабатывает,прирав
							}
						}
					}
                    if(ntValue < root.from){//Если пользователь вводит число меньше заданного
                        if(root.value !== root.from){//Если нет равенства, то...
                            root.value = root.from;//Выставляем минимальное значение.
                            text = root.value;//В этом слоте,onValueChanged не срабатывает,приравнив
                            root.valueModified();//Отправляем Сигнал, как в оригинальном Scale.
						}
						else{
                            if(ntValue < root.from){
                                root.value = root.from;//Выставляем минимальное значение.
                                text = root.value;//В этом слоте,onValueChanged не срабатывает,прирав
							}
						}
					}
				}
			}
            Text {
                id: txtProcent
                anchors.verticalCenter: rctTextInput.verticalCenter
                anchors.right: rctTextInput.right
                color: root.clrTexta
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                text: "%"
            }
		}
        DCKnopkaPlus {//Кнопка плюс.
			id: knopkaPlus
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: rctScale.verticalCenter
            anchors.right: rctScale.right
            clrKnopki: root.clrTexta
			border: false
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaPlus
            onClicked: fnClickedPlus();//Функция нажатия Плюс.
		}
    }
}
