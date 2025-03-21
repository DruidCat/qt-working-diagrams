﻿import QtQuick //2.14
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
    property bool passTrue: true;//false - пароль неверный.
    property color clrTexta: "black"//цвет текста
    property color clrKnopki: "yellow"//цвет Кнопок
    property alias clrBorder: rctTextInput.border.color//цвет границы
    property alias blVisible: rctPassword.visible//Видимость объекта.
    property int  ntWidth: 2
    property int ntCoff: 8
    property string placeholderTextTrue: ""//Текст в строке, подсказывающий, что нужно вводить юзеру
    property string placeholderTextFalse: ""//Текст в строке,подсказывающий,что нужно вводить юзеру при ошибке
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
				anchors.centerIn: rctTextInput
                color: tmPassword.passTrue ? clrTexta : "#9c3a3a"//Заданный цвет текста или серо красный.
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
                        event.accepted = true;//Enter не использовался в сочетания клавишь с другими клавишами
					}
					if(event.key === Qt.Key_Escape){
						tmPassword.clickedOtmena();//Излучаем сигнал о том, что нажат Ecape
					}
					//console.log(event.key);
				}
				Text {//Текст, подсказывающий пользователю, что нужно вводить.
					id: txtTextInput
					anchors.centerIn: txnTextInput
                    text: tmPassword.passTrue ? tmPassword.placeholderTextTrue : placeholderTextFalse
                    font.pixelSize: tmPassword.ntWidth*tmPassword.ntCoff//размер шрифта текста.
                    horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
                    color: tmPassword.passTrue ? "#aaa" : "#9c3a3a"//Светло серый цвет или серо красный
					visible: !txnTextInput.text
					onVisibleChanged: {//Если изменилась видимость, то...
						if(text){//(Защита от пустого текста) Если не пустой текст, то...
							if(visible){//Если подсказка становится видимой, то...
								if(rctTextInput.width > txtTextInput.width){//Если длина строки > длины текста
									for(let ltShag = txtTextInput.font.pixelSize;
													ltShag < rctTextInput.height-tmPassword.ntCoff; ltShag++){
										if(txtTextInput.width < rctTextInput.width){//длина текста<динны строк
											txtTextInput.font.pixelSize = ltShag;//Увеличиваем размер шрифта
											if(txtTextInput.width > rctTextInput.width){//Но, если переборщили
												txtTextInput.font.pixelSize--;//То уменьшаем размер шрифта и..
												return;//Выходим из увеличения шрифта.
											}
										}
									}
								}
								else{//Если длина строки меньше длины текста, то...
									for(let ltShag = txtTextInput.font.pixelSize; ltShag > 0; ltShag--){
										if(txtTextInput.width > rctTextInput.width)//текст дилиннее строки,то.
											txtTextInput.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
									}
								}
							}
						}
					}	
				}
			}
			onWidthChanged: {//Если если изменилась ширина прямоугольника, то...
				if(txtTextInput.text){//(Защита от пустого текста) Если не пустой текст, то...
					if(txtTextInput.visible){//Если подсказка становится видимой, то...
						if(rctTextInput.width > txtTextInput.width){//Если длина строки > длины текста
							for(let ltShag = txtTextInput.font.pixelSize;
											ltShag < rctTextInput.height-tmPassword.ntCoff; ltShag++){
								if(txtTextInput.width < rctTextInput.width){//длина текста<динны строк
									txtTextInput.font.pixelSize = ltShag;//Увеличиваем размер шрифта
									if(txtTextInput.width > rctTextInput.width){//Но, если переборщили
										txtTextInput.font.pixelSize--;//То уменьшаем размер шрифта и..
										return;//Выходим из увеличения шрифта.
									}
								}
							}
						}
						else{//Если длина строки меньше длины текста, то...
							for(let ltShag = txtTextInput.font.pixelSize; ltShag > 0; ltShag--){
								if(txtTextInput.width > rctTextInput.width)//текст дилиннее строки,то.
									txtTextInput.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
							}
						}
					}
				}
				if(txnTextInput.text){//(Защита от пустого текста) Если не пустой текст, то...
					if(txnTextInput.visible){//Если Пароль становится видимой, то...
						if(rctTextInput.width > txnTextInput.width){//Если длина строки > длины текста
							for(let ltShag = txnTextInput.font.pixelSize;
											ltShag < rctTextInput.height-tmPassword.ntCoff; ltShag++){
								if(txnTextInput.width < rctTextInput.width){//длина текста<динны строк
									txnTextInput.font.pixelSize = ltShag;//Увеличиваем размер шрифта
									if(txnTextInput.width > rctTextInput.width){//Но, если переборщили
										txnTextInput.font.pixelSize--;//То уменьшаем размер шрифта и..
										return;//Выходим из увеличения шрифта.
									}
								}
							}
						}
						else{//Если длина строки меньше длины текста, то...
							for(let ltShag = txnTextInput.font.pixelSize; ltShag > 0; ltShag--){
								if(txnTextInput.width > rctTextInput.width)//текст дилиннее строки,то.
									txnTextInput.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
							}
						}
					}
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
	onPassTrueChanged: {//Если изменился флаг правильного пароля или нет, то...
		if(txtTextInput.text){//(Защита от пустого текста) Если не пустой текст, то...
			if(txtTextInput.visible){//Если подсказка становится видимой, то...
				if(rctTextInput.width > txtTextInput.width){//Если длина строки > длины текста
					for(let ltShag = txtTextInput.font.pixelSize;
									ltShag < rctTextInput.height-tmPassword.ntCoff; ltShag++){
						if(txtTextInput.width < rctTextInput.width){//длина текста<динны строк
							txtTextInput.font.pixelSize = ltShag;//Увеличиваем размер шрифта
							if(txtTextInput.width > rctTextInput.width){//Но, если переборщили
								txtTextInput.font.pixelSize--;//То уменьшаем размер шрифта и..
								return;//Выходим из увеличения шрифта.
							}
						}
					}
				}
				else{//Если длина строки меньше длины текста, то...
					for(let ltShag = txtTextInput.font.pixelSize; ltShag > 0; ltShag--){
						if(txtTextInput.width > rctTextInput.width)//текст дилиннее строки,то.
							txtTextInput.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
					}
				}
			}
		}
	}
	onPasswordChanged: {//Если вводится пароль, то...
		if(txnTextInput.text){//(Защита от пустого текста) Если не пустой текст, то...
			if(txnTextInput.visible){//Если Пароль становится видимой, то...
				if(rctTextInput.width > txnTextInput.width){//Если длина строки > длины текста
					for(let ltShag = txnTextInput.font.pixelSize;
									ltShag < rctTextInput.height-tmPassword.ntCoff; ltShag++){
						if(txnTextInput.width < rctTextInput.width){//длина текста<динны строк
							txnTextInput.font.pixelSize = ltShag;//Увеличиваем размер шрифта
							if(txnTextInput.width > rctTextInput.width){//Но, если переборщили
								txnTextInput.font.pixelSize--;//То уменьшаем размер шрифта и..
								return;//Выходим из увеличения шрифта.
							}
						}
					}
				}
				else{//Если длина строки меньше длины текста, то...
					for(let ltShag = txnTextInput.font.pixelSize; ltShag > 0; ltShag--){
						if(txnTextInput.width > rctTextInput.width)//текст дилиннее строки,то.
							txnTextInput.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
					}
				}
			}
		}
	}
}
