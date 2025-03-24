﻿import QtQuick //2.14
//import QtQuick.Window //2.14
//DCMenu - ШАБЛОН ВСПЛЫВАЮЩЕГО МЕНЮ НАСТРОЕК.
import "qrc:/js/DCFunkciiJS.js" as JSMenu

Item {
    id: root
    property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
    property string imyaMenu: ""
	signal clicked(int ntNomer, var strMenu)

    ListView {
		id: lsvMenu
        focus: {
           if(root.visible){//Если виджет видимый, то...
                forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
                return true;
           }
           else//Если виджет не видимый, то...
                return false;
        }
		Component {
			id: cmpMenu
			Rectangle {
				id: rctMenu
                width: lsvMenu.width
                height: root.ntWidth*root.ntCoff+root.ntCoff
                radius: (width/(root.ntWidth*root.ntCoff))/root.ntCoff
				border.width: 1
                border.color: Qt.darker(root.clrFona, 1.3)
                clip: true//Обрезаем лишний текст в прямоугольнике.
                color: maMenu.containsPress
                       ? Qt.darker(root.clrFona, 1.3) : root.clrFona
                Rectangle {
                    id: rctText
                    anchors.fill: rctMenu
                    anchors.margins: root.ntCoff/2
                    color: "transparent"
                }
				Text {
					id: txtText
                    color: maMenu.containsPress ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
                    anchors.left: rctText.left
                    anchors.verticalCenter: rctText.verticalCenter
                    text: modelData.menu
                    font.pixelSize: rctText.height-root.ntCoff
                }
                Component.onCompleted: {//Когда текст нарисовался, расчитываю его длину.
                    if(rctText.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(let ltShag=txtText.font.pixelSize; ltShag<rctText.height-root.ntCoff; ltShag++){
                            if(txtText.width < rctText.width){//Если длина текста меньше динны строки
                                txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(txtText.width > rctText.width){//Но, если переборщили
                                    txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(txtText.width > rctText.width)//Если текст дилиннее строки, то...
                                txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
				MouseArea {
					id: maMenu
					anchors.fill: rctMenu
					onClicked: {
                        root.clicked(modelData.nomer, modelData.menu)
					}
				}
				onWidthChanged: {//Если длина строки изменилась, то...
                    if(rctText.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(let ltShag=txtText.font.pixelSize; ltShag<rctText.height-root.ntCoff; ltShag++){
                            if(txtText.width < rctText.width){//Если длина текста меньше динны строки
								txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(txtText.width > rctText.width){//Но, если переборщили
									txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
									return;//Выходим из увеличения шрифта.
								}
							}
						}
					}
					else{//Если длина строки меньше длины текста, то...
						for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
                            if(txtText.width > rctText.width)//Если текст дилиннее строки, то...
								txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
						}
					}
				}
			}
		}
        anchors.fill: root
        anchors.topMargin:root.ntCoff
        anchors.bottomMargin:root.ntCoff
        anchors.leftMargin:root.width/2//Отступ отлевого края половина длины экрана.
        anchors.rightMargin:root.ntCoff/2//Отступ от правого края пол коэффициента
        opacity: 0.9//Прозрачность.
		interactive: false//Запретить листать.

		delegate: cmpMenu
	}
	Component.onCompleted: {//Слот, кода всё представление отрисовалось.
		if(imyaMenu == "spisok"){//Если это Список, то...
			lsvMenu.model = JSMenu.vrMenuSpisok;//Перегружаем модель ListView с новыми данными.
		}
		else{
			if(imyaMenu == "element"){//Если это Элемент, то...
				lsvMenu.model = JSMenu.vrMenuElement;//Перегружаем модель ListView с новыми данными.
			}
			else{
				if(imyaMenu == "dannie"){//Если это Данные, то...
					lsvMenu.model = JSMenu.vrMenuDannie;//Перегружаем модель ListView с новыми данными.
				}
                else{
                    if(imyaMenu == "filedialog"){
                        lsvMenu.model = JSMenu.vrMenuFileDialog;//Перегружаем модель ListView с новыми данными
                    }
                    else
                        lsvMenu.model = JSMenu.vrMenuVihod;//Перегружаем модель ListView с новыми данными.
                }
            }
		}
        root.height = lsvMenu.count*(ntWidth*ntCoff+ntCoff)+ntCoff;//Выставляем высоту под размер меню.
	}
}
