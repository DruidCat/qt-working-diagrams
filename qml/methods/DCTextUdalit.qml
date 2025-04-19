import QtQuick //2.15
import "qrc:/qml/buttons"//Импортируем кнопки
//Шаблон DCTextUdalit.qml - состоит из области, которая показывает текст удалённого документа.
Item {
    id: root
    property int  ntWidth: 2
    property int ntCoff: 8
    property alias radius: rctTextUdalit.radius//Радиус зоны отображения удаляемого документа.
    property alias clrFona: rctTextUdalit.color//цвет фона
    property alias clrTexta: txtTextUdalit.color//цвет текста
    property color clrKnopki: "red"//цвет Кнопок
    property alias clrBorder: rctText.border.color//цвет границы
    property string kod: ""//Код удаляемого элемента
    property string text: "" //Имя элемента на удаление
    property alias bold: txtTextUdalit.font.bold
    property alias italic: txtTextUdalit.font.italic
    property alias textUdalit: txtTextUdalit//Передаём в виде свойства весь объект Text
    signal clickedUdalit(var strKod);//Сигнал на удаление вместе с кодом удаляемого эдемента.
    signal clickedOtmena();//Сигнал на отмену удаления.
    function fnClickedZakrit(){//Функция Закрытия виджета.
        root.clickedOtmena();//Запускаем сигнал Отмены удаления.
    }
    Rectangle {//Основной прямоугольник.
        id: rctTextUdalit
        anchors.fill: root
        color: "transparent"
        radius: root.ntCoff/2
        visible: {
            if(root.visible){//Если виджет видимый, то...
                focus = true;//Фокусируемся на виджете
                forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
                return true;//Видимый виджет
            }
            else{//Если виджет видимый, то...
                focus =  false;//Не фокусируемся на виджете.
                return false;//невидимый виджет
            }
        }
        Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
            if(event.key === Qt.Key_Escape){//Если нажат Escape, то...
                fnClickedZakrit();//Функция закрытия виджета.
            }
            //console.log(event.key);
        }
        DCKnopkaZakrit {//@disable-check M300//Кнопка Отмены удаления.
            id: knopkaOtmena
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctTextUdalit.verticalCenter
            anchors.left:rctTextUdalit.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrKnopki
            onClicked: {
                fnClickedZakrit();//Функция Закрытия виджета.
            }
        }
        Rectangle {
            id: rctText
            anchors.top: rctTextUdalit.top
            anchors.bottom: rctTextUdalit.bottom
            anchors.left: knopkaOtmena.right
            anchors.right: knopkaOk.left
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            color: "transparent"
            border.color: "transparent"
            border.width: root.ntCoff/8
            radius: root.ntCoff/2
            clip: true//Обрезаем всё что больше этого прямоугольника.
            Text {
                id: txtTextUdalit
				anchors.horizontalCenter: rctText.horizontalCenter
				anchors.verticalCenter: rctText.verticalCenter
                color: root.clrTexta
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("УДАЛИТЬ:")+root.text+"?"
				onTextChanged: {//Если текст изменился, то...
					if(rctText.width > txtTextUdalit.width){//Если длина строки больше длины текста, то...
                        for(let ltShag=txtTextUdalit.font.pixelSize;
                                                ltShag<root.ntWidth*root.ntCoff; ltShag++){
							if(txtTextUdalit.width < rctText.width){//Если длина текста меньше динны строки
								txtTextUdalit.font.pixelSize = ltShag;//Увеличиваем размер шрифта
								if(txtTextUdalit.width > rctText.width){//Но, если переборщили
									txtTextUdalit.font.pixelSize--;//То уменьшаем размер шрифта и...
									return;//Выходим из увеличения шрифта.
								}
							}
						}
					}
					else{//Если длина строки меньше длины текста, то...
						for(let ltShag = txtTextUdalit.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
							if(txtTextUdalit.width > rctText.width)//Если текст дилиннее строки, то...
								txtTextUdalit.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
						}
					}
				}
			}
			onWidthChanged: {//Если длина строки измениасть, то...
				if(rctText.width > txtTextUdalit.width){//Если длина строки больше длины текста, то...
				for(let ltShag=txtTextUdalit.font.pixelSize;
                                                ltShag<root.ntWidth*root.ntCoff; ltShag++){
						if(txtTextUdalit.width < rctText.width){//Если длина текста меньше динны строки
							txtTextUdalit.font.pixelSize = ltShag;//Увеличиваем размер шрифта
							if(txtTextUdalit.width > rctText.width){//Но, если переборщили
								txtTextUdalit.font.pixelSize--;//То уменьшаем размер шрифта и...
								return;//Выходим из увеличения шрифта.
							}
						}
					}
				}
				else{//Если длина строки меньше длины текста, то...
					for(let ltShag = txtTextUdalit.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
						if(txtTextUdalit.width > rctText.width)//Если текст дилиннее строки, то...
							txtTextUdalit.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
					}
				}
			}
        }
        DCKnopkaOk{//@disable-check M300//Кнопка подтверждения удаления.
            id: knopkaOk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctTextUdalit.verticalCenter
            anchors.right: rctTextUdalit.right
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrKnopki
            onClicked: {
                root.clickedUdalit(root.kod);//Сигнал удаления с кодом удаляемого Элемента.
            }
        }
    }
}
