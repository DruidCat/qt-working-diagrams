import QtQuick //2.14
//import QtQuick.Window //2.14
import "qrc:/qml/buttons"//Импортируем кнопки
//Шаблон DCPoisk.qml - состоит из области, которая показывает искать в pdf документе.
Item {
    id: tmPoisk
    property int  ntWidth: 2
    property int ntCoff: 8
    property alias radius: rctPoisk.radius//Радиус зоны отображения виджета поиска.
    property alias clrFona: rctPoisk.color//цвет фона
    property alias clrTexta: txtPoisk.color//цвет текста
    property color clrKnopki: "red"//цвет Кнопок
    property alias clrBorder: rctText.border.color//цвет границы
    property alias blVisible: rctPoisk.visible//Видимость объекта.
    property string kod: ""//Код элемента поиска
    property string text: "" //элемент поиска
    property alias bold: txtPoisk.font.bold
    property alias italic: txtPoisk.font.italic
    property alias textUdalit: txtPoisk//Передаём в виде свойства весь объект Text
    signal clickedNext(var strKod);//Сигнал на следующий элемент поиска
    signal clickedPrevious(var strKod);//Сигнал на предыдущий элемент поиска.
    signal clickedZakrit();//Сигнал на отмену поиска.

    Rectangle {//Основной прямоугольник.
        id: rctPoisk
        anchors.fill: tmPoisk
        color: "transparent"
        radius: tmPoisk.ntCoff/2
        visible: false
        DCKnopkaZakrit {//@disable-check M300//Кнопка Отмены поиска.
            id: knopkaZakrit
            ntWidth: tmPoisk.ntWidth
            ntCoff: tmPoisk.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.left:rctPoisk.left
            anchors.margins: tmPoisk.ntCoff/2
            clrKnopki: tmPoisk.clrKnopki
            onClicked: {
                tmPoisk.clickedZakrit();//Запускаем сигнал Отмены поиска.
            }
        }
        Rectangle {
            id: rctText
            anchors.top: rctPoisk.top
            anchors.bottom: rctPoisk.bottom
            anchors.left: knopkaZakrit.right
            anchors.right: knopkaVverh.left
            anchors.leftMargin: tmPoisk.ntCoff/2
            anchors.rightMargin: tmPoisk.ntCoff/2

            color: "transparent"
            border.color: "transparent"
            border.width: tmPoisk.ntCoff/8
            radius: tmPoisk.ntCoff/2
            clip: true//Обрезаем всё что больше этого прямоугольника.
            Text {
                id: txtPoisk
				anchors.horizontalCenter: rctText.horizontalCenter
				anchors.verticalCenter: rctText.verticalCenter
                color: tmPoisk.clrTexta
                font.pixelSize: tmPoisk.ntWidth*tmPoisk.ntCoff//размер шрифта текста.
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: tmPoisk.text
				onTextChanged: {//Если текст изменился, то...
					if(rctText.width > txtPoisk.width){//Если длина строки больше длины текста, то...
					for(let ltShag=txtPoisk.font.pixelSize; ltShag<tmPoisk.ntWidth*tmPoisk.ntCoff; ltShag++){
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
				for(let ltShag=txtPoisk.font.pixelSize;
												ltShag<tmPoisk.ntWidth*tmPoisk.ntCoff; ltShag++){
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
		DCKnopkaVverh{//@disable-check M300//Кнопка предыдущего поиска
            id: knopkaVverh
            ntWidth: tmPoisk.ntWidth
            ntCoff: tmPoisk.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.right: knopkaVniz.left
            anchors.margins: tmPoisk.ntCoff/2
            clrKnopki: tmPoisk.clrKnopki
            onClicked: {
                tmPoisk.clickedPrevious(tmPoisk.kod);//Сигнал предыдущего поиска.
            }
        }
        DCKnopkaVniz{//@disable-check M300//Кнопка следующего поиска.
            id: knopkaVniz
            ntWidth: tmPoisk.ntWidth
            ntCoff: tmPoisk.ntCoff
            anchors.verticalCenter: rctPoisk.verticalCenter
            anchors.right: rctPoisk.right
            anchors.margins: tmPoisk.ntCoff/2
            clrKnopki: tmPoisk.clrKnopki
            onClicked: {
                tmPoisk.clickedNext(tmPoisk.kod);//Сигнал следующего поиска.
            }
        }
    }
}
