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
    property int currentResult: -1//номер поиска
    property bool blNomer: false//true - nomerPoisk обнуляю, false - namerPoisk обнулён.
    property alias bold: txtPoisk.font.bold
    property alias italic: txtPoisk.font.italic
    property alias textUdalit: txtPoisk//Передаём в виде свойства весь объект Text
    property real tapKnopkaZakrit: 1
    property real tapKnopkaVniz: 1
    property real tapKnopkaVverh: 1
    property bool isOpenedSidebar: false//true - открыта боковая панель
    //Настройки
    focus: true
    //Сигналы.
    signal clickedNext();//Сигнал на следующий элемент поиска
    signal clickedPrevious();//Сигнал на предыдущий элемент поиска.
    signal clickedVverh();//Сигнал нажатия клавиши вверх.
    signal clickedVniz();//Сигнал нажатия клавиши вниз
    signal clickedVlevo();//Сигнал нажатия клавиши влево
    signal clickedVpravo();//Сигнал нажатия клавиши вправо
    signal clickedZakrit();//Сигнал на отмену поиска.
    signal clickedSidebar();//Сигнал о нажатии на кнопку боковой панели.
    signal clickedSidebarZakladki();//Сигнал - Открываем боковую панель с Закладками.
    signal clickedSidebarPoster();//Сигнал - Открываем боковую панель с Миниатюрами страниц
    signal clickedSidebarNaideno();//Сигнал - Открываем боковую панель с Найдено
    //Функции.
    function fnFocus() {//Функция для фокусировки ListView
        rctPoisk.forceActiveFocus();//Чтоб работали кнопки листания поиска.
    }
    onTextChanged: {//Если новый текст Поиска, то...
        root.blNomer = true;//Начало обнуления
        root.blNomer = false;//Окончание обнуления.
    }
    onIsOpenedSidebarChanged: {//Если статус флага открыта/закрыта боковая панель изменился, то...
        knopkaSidebar.opened = root.isOpenedSidebar;//Передаём сигнал кнопке, для отображения нужной позиции.
    }

	function fnClickedVniz() {//Функция обрабатывающая следующий поиск.
		root.clickedNext();//Сигнал следующего поиска.
	}
	function fnClickedVverh() {//Функция обрабатывающая предыдущий поиск.
        root.clickedPrevious();//Сигнал предыдущего поиска.
	}
    function fnClickedKeyVniz() {//Функция обрабатывающая клавишу вниз
        root.clickedVniz();//Сигнал нажатия клавиши вниз
    }
    function fnClickedKeyVverh() {//Функция обрабатывающая клавишу вверх.
        root.clickedVverh();//Сигнал нажатия клавиши вверх
    }
    function fnClickedKeyVlevo() {//Функция обрабатывающая клавишу вниз
        root.clickedVlevo();//Сигнал нажатия клавиши влева
    }
    function fnClickedKeyVpavo() {//Функция обрабатывающая клавишу вверх.
        root.clickedVpravo();//Сигнал нажатия клавиши вправо
    }
	function fnClickedZakrit() {//Функция закрытия виджета.
		root.clickedZakrit();//Запускаем сигнал Отмены поиска.
        root.blNomer = true;//Начало обнуления
        root.currentResult = -1;//Обнуляем, от предыдущего поиска. Обнуление при повтороном таком же запросе.
        root.blNomer = false;//Окончание обнуления.
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
            if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
                if(event.key === Qt.Key_B){//Если нажата клавиша "B", то...
                    root.clickedSidebarZakladki();//Сигнал - Открываем боковую панель с Закладками.
                    event.accepted = true;//Завершаем обработку эвента.
                }
                else{
                    if(event.key === Qt.Key_T){//Если нажата клавиша "T", то...
                        root.clickedSidebarPoster();//Сигнал - Открываем боковую панель с Миниатюрами страниц
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
            else{
                if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                    if (event.key === Qt.Key_F){//Если нажата клавиша F, то...
                        root.clickedSidebarNaideno();//Сигнал - Открываем боковую панель во вкладке Найдено.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
                else{
                    if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                        if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                            if(root.visible && knopkaVverh.enabled)//Если виджет поиска видимый, то...
                                fnClickedVverh()//Функция нажатия кнопки Предыдущего поиска
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                    }
                    else{
                        if(event.key === Qt.Key_Escape){//Если нажат Escape, то...
                            fnClickedZakrit();//Функция закрытия виджета.
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                        else{
                            if((event.key===Qt.Key_F3)
                                                    ||(event.key===Qt.Key_Enter)
                                                    ||(event.key===Qt.Key_Return)){//F3
                                fnClickedVniz();//Функция нажатия кнопки Следующего поиска
                                event.accepted = true;//Завершаем обработку эвента.
                            }
                            else{
                                if(event.key === Qt.Key_Down){//нажата "Стрелка вниз",то
                                    fnClickedKeyVniz();//Функция нажатия клавиши вниз
                                    event.accepted = true;//Завершаем обработку эвента.
                                }
                                else{
                                    if(event.key === Qt.Key_Up){//нажата "Стрелка вверх"
                                        fnClickedKeyVverh();//Функция нажатия клавиши вверх
                                        event.accepted = true;//Завершаем обработку эвента.
                                    }
                                    else{
                                        if(event.key === Qt.Key_Left){//Если нажата стрелка влево,то.
                                            fnClickedKeyVlevo()//нажатия клавиши влево
                                            event.accepted = true;//Завершаем обработку эвента.
                                        }
                                        else{
                                            if(event.key === Qt.Key_Right){//Если нажата стрелка вправо, то.
                                                fnClickedKeyVpravo()//нажатия клавиши вправо
                                                event.accepted = true;//Завершаем обработку эвента.
                                            }
                                        }
                                    }
                                }
                            }
                        }
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
        DCKnopkaSidebar{//Кнопка Открытия/Закрытия боковой панели.
            id: knopkaSidebar
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.left:knopkaZakrit.right
            clrKnopki: root.clrKnopki
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaZakrit
            onClicked: root.clickedSidebar();//Сигнал о нажатии на кнопку боковой панели.
        }
        Rectangle {
            id: rctText
            anchors.top: rctPoisk.top
            anchors.bottom: rctPoisk.bottom
            anchors.left: knopkaSidebar.right
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
                text: root.text	+ " [" + (root.currentResult + 1) + "|" + root.sumPoisk + "]"
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
