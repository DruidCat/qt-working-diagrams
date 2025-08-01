﻿import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
//Шаблон DCPoisk.qml - состоит из области, которая показывает искать в pdf документе.
Item {
    id: root
    //Свойства.
    property int  ntWidth: 2
    property int ntCoff: 8
    property alias radius: rctPoisk.radius//Радиус зоны отображения виджета поиска.
    property alias clrFona: rctPoisk.color//цвет фона
    property alias clrTexta: txtPoisk.color//цвет текста
    property color clrKnopki: "red"//цвет Кнопок
    property color clrBorder: "transparent"//цвет границы
    property string text: ""//элемент поиска
    property int sumPoisk: 0//суммарный результат поиска
    property int nomerPoisk: 0//номер поиска
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
	function fnClickedVniz() {//Функция обрабатывающая следующий поиск.
		root.clickedNext();//Сигнал следующего поиска.
	}
	function fnClickedVverh() {//Функция обрабатывающая предыдущий поиск.
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
			if((event.key === 16777220)||(event.key === 16777221)){//Код 16777220 и 16777221 - Enter
				fnClickedVniz();//функция следующего поиска.
				event.accepted = true;//Enter не использовался в сочетания клавишь с другими клавишами
			}
			if(event.key === Qt.Key_Escape){//Если нажат Escape, то...
				fnClickedZakrit();//Функция закрытия виджета.
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
            onClicked: fnClickedVniz();//Функция обрабатывающая следующий поиск.
        }
    }
}
