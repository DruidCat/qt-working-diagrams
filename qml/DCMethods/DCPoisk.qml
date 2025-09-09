import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
//Шаблон DCPoisk.qml - состоит из области, которая показывает искать в pdf документе.
Item {
    id: root
    //Свойства.
    property int  ntWidth: 2
    property int ntCoff: 8
    property alias radius: rctPoisk.radius//Радиус зоны отображения виджета поиска.
    property bool enabled: true;//true - активны кнопки вверх и вниз, false - не активны.
    property alias clrFona: rctPoisk.color//цвет фона
    property alias clrTexta: txtPoisk.color//цвет текста
    property color clrKnopki: "red"//цвет Кнопок
    property color clrBorder: "transparent"//цвет границы
    property string text: ""//элемент поиска
    property int sumPoisk: 0//суммарный результат поиска
    property int nomerPoisk: 0//номер поиска
    property bool blNomer: false//true - nomerPoisk обнуляю, false - namerPoisk обнулён.
    property alias bold: txtPoisk.font.bold
    property alias italic: txtPoisk.font.italic
    property alias textUdalit: txtPoisk//Передаём в виде свойства весь объект Text
    property real tapKnopkaZakrit: 1
    property real tapKnopkaVniz: 1
    property real tapKnopkaVverh: 1
    //Сигналы.
    signal clickedNext();//Сигнал на следующий элемент поиска
    signal clickedPrevious();//Сигнал на предыдущий элемент поиска.
    signal clickedZakrit();//Сигнал на отмену поиска.
    //Функции.
    onNomerPoiskChanged: {//Если номер поиска изменился, то...
        if(!blNomer){//Если это не обнуление nomerPoisk, то...
            if(root.nomerPoisk > root.sumPoisk){//Если номер поиска больше общего колличества совпадений, то...
                if(root.sumPoisk)//Если не 0, то...
                    root.nomerPoisk = 1
                else//Если ничего не найдено, то...
                    root.nomerPoisk = 0
            }
            else{
                if(root.nomerPoisk < 1){//Если меньше единицы, то...
                    if(root.sumPoisk)//Если не 0, то...
                        root.nomerPoisk = root.sumPoisk//Переходим в конец списка.
                    else//Если ничего не нашёл, то...
                        root.nomerPoisk = 0
                }
            }
        }
    }
    onTextChanged: {//Если новый текст Поиска, то...
        blNomer = true;//Начало обнуления
        root.nomerPoisk = 0;//Обнуляем, от предыдущего поиска.
        blNomer = false;//Окончание обнуления.
    }
    onSumPoiskChanged: {//Если что то найдено
        if(!root.nomerPoisk)//И номер поиска равен 0, то это первоначальный старт поиска.
            fnClickedVniz()//Функция обрабатывающая следующий поиск.
    }

	function fnClickedVniz() {//Функция обрабатывающая следующий поиск.
        root.nomerPoisk += 1;
		root.clickedNext();//Сигнал следующего поиска.
	}
	function fnClickedVverh() {//Функция обрабатывающая предыдущий поиск.
        root.nomerPoisk -= 1;
        root.clickedPrevious();//Сигнал предыдущего поиска.
	}
	function fnClickedZakrit() {//Функция закрытия виджета.
		root.clickedZakrit();//Запускаем сигнал Отмены поиска.
	}

    Rectangle {//Основной прямоугольник.
        id: rctPoisk
        anchors.fill: root
        color: "transparent"
        radius: root.ntCoff/2
		visible: {
			if(root.visible){//Если видимый виджет, то...
				focus = true;//Фокусируемся.
				forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
				return true;//Видимый
			}
			else{//Если невидимый виджет, то...
				focus = false;//Не фокусируемся.
				return false;//Невидимый
			}
		}	
		Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
            if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                    if(root.visible && knopkaVverh.enabled)//Если виджет поиска видимый, то...
                        fnClickedVverh()//Функция нажатия кнопки Предыдущего поиска
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
            else{
                if(event.key === Qt.Key_Escape){//Если нажат Escape, то...
                    if(root.visible && knopkaZakrit.enabled)//Если режим поиска видимый, то...
                        fnClickedZakrit();//Функция закрытия виджета.
                    event.accepted = true;//Завершаем обработку эвента.
                }
                else{
                    if(event.key === Qt.Key_F3){//Если нажата "F3", то.
                        if(root.visible && knopkaVniz.enabled)//Если режим поиска видимый, то...
                            fnClickedVniz();//Функция нажатия кнопки Следующего поиска
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
			//console.log(event.key);
		}
        DCKnopkaZakrit {//Кнопка Отмены поиска.
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.left:rctPoisk.left
            clrKnopki: root.clrKnopki
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaZakrit
            onClicked: fnClickedZakrit();//Функция закрытия виджета.
        }
        Rectangle {
            id: rctText
            anchors.top: rctPoisk.top
            anchors.bottom: rctPoisk.bottom
            anchors.left: knopkaZakrit.right
            anchors.right: knopkaVverh.left

            color: "transparent"
            border.color: root.clrBorder
            border.width: root.ntCoff/8
            radius: root.ntCoff/2
            clip: true//Обрезаем всё что больше этого прямоугольника.
            Text {
                id: txtPoisk
				anchors.horizontalCenter: rctText.horizontalCenter
				anchors.verticalCenter: rctText.verticalCenter
                color: root.clrTexta
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: root.text	+ " [" + root.nomerPoisk + "|" + root.sumPoisk + "]"
				onTextChanged: {//Если текст изменился, то...
					if(rctText.width > txtPoisk.width){//Если длина строки больше длины текста, то...
                    for(var ltShag=txtPoisk.font.pixelSize; ltShag<root.ntWidth*root.ntCoff; ltShag++){
							if(txtPoisk.width < rctText.width){//Если длина текста меньше динны строки
								txtPoisk.font.pixelSize = ltShag;//Увеличиваем размер шрифта
								if(txtPoisk.width > rctText.width){//Но, если переборщили
									txtPoisk.font.pixelSize--;//То уменьшаем размер шрифта и...
									return;//Выходим из увеличения шрифта.
								}
							}
						}
					}
					else{//Если длина строки меньше длины текста, то...
						for(let ltShag = txtPoisk.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
							if(txtPoisk.width > rctText.width)//Если текст дилиннее строки, то...
								txtPoisk.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
						}
					}
				}
			}
			onWidthChanged: {//Если длина строки измениасть, то...
				if(rctText.width > txtPoisk.width){//Если длина строки больше длины текста, то...
                for(var ltShag = txtPoisk.font.pixelSize;
												ltShag<root.ntWidth*root.ntCoff; ltShag++){
						if(txtPoisk.width < rctText.width){//Если длина текста меньше динны строки
							txtPoisk.font.pixelSize = ltShag;//Увеличиваем размер шрифта
							if(txtPoisk.width > rctText.width){//Но, если переборщили
								txtPoisk.font.pixelSize--;//То уменьшаем размер шрифта и...
								return;//Выходим из увеличения шрифта.
							}
						}
					}
				}
				else{//Если длина строки меньше длины текста, то...
                    for(let ltShag = txtPoisk.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
						if(txtPoisk.width > rctText.width)//Если текст дилиннее строки, то...
							txtPoisk.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
					}
				}
			}
        }
        DCKnopkaVverh{//Кнопка предыдущего поиска
            id: knopkaVverh
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.right: knopkaVniz.left
            clrKnopki: root.clrKnopki
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaVverh
            enabled: root.enabled//активная/неактивная кнопка.
            onClicked: fnClickedVverh();//Функция обрабатывающая предыдущий поиск.
        }
        DCKnopkaVniz{//Кнопка следующего поиска.
            id: knopkaVniz
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.right: rctPoisk.right
            clrKnopki: root.clrKnopki
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaVniz
            enabled: root.enabled//активная/неактивная кнопка.
            onClicked: fnClickedVniz();//Функция обрабатывающая следующий поиск.
        }
    }
}
