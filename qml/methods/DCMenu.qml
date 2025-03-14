﻿import QtQuick //2.14
//import QtQuick.Window //2.14
//DCMenu - ШАБЛОН ВСПЛЫВАЮЩЕГО МЕНЮ НАСТРОЕК.
import "qrc:/js/DCFunkciiJS.js" as JSMenu

Item {
	id: tmMenu
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
    property string imyaMenu: ""
	signal clicked(int ntNomer, var strMenu)

    ListView {
		id: lsvMenu
		Component {
			id: cmpMenu
			Rectangle {
				id: rctMenu
				width: lsvMenu.width
				height: tmMenu.ntWidth*tmMenu.ntCoff+tmMenu.ntCoff
				radius: (width/(tmMenu.ntWidth*tmMenu.ntCoff))/tmMenu.ntCoff
				border.width: 1
				border.color: Qt.darker(tmMenu.clrFona, 1.3)
                clip: true//Обрезаем лишний текст в прямоугольнике.
                color: maMenu.containsPress
					   ? Qt.darker(tmMenu.clrFona, 1.3) : tmMenu.clrFona
				Text {
					id: txtText
					color: maMenu.containsPress
						   ? Qt.darker(tmMenu.clrTexta, 1.3) : tmMenu.clrTexta
					anchors.horizontalCenter: rctMenu.horizontalCenter
					anchors.verticalCenter: rctMenu.verticalCenter
					text: modelData.menu
                    font.pixelSize: rctMenu.height-tmMenu.ntCoff
				}
				MouseArea {
					id: maMenu
					anchors.fill: rctMenu
					onClicked: {
						tmMenu.clicked(modelData.nomer, modelData.menu)
					}
				}
				onWidthChanged: {//Если длина строки изменилась, то...
					if(rctMenu.width > txtText.width){//Если длина строки больше длины текста, то...
						for(let ltShag=txtText.font.pixelSize; ltShag<rctMenu.height-tmMenu.ntCoff; ltShag++){
							if(txtText.width < rctMenu.width){//Если длина текста меньше динны строки
								txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
								if(txtText.width > rctMenu.width){//Но, если переборщили
									txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
									return;//Выходим из увеличения шрифта.
								}
							}
						}
					}
					else{//Если длина строки меньше длины текста, то...
						for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
							if(txtText.width > rctMenu.width)//Если текст дилиннее строки, то...
								txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
						}
					}
				}
			}
		}
		anchors.fill: tmMenu
		anchors.topMargin:tmMenu.ntCoff
		anchors.bottomMargin:tmMenu.ntCoff
		anchors.leftMargin:tmMenu.ntCoff/2
		anchors.rightMargin:tmMenu.width/2
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
		tmMenu.height = lsvMenu.count*(ntWidth*ntCoff+ntCoff)+ntCoff;//Выставляем высоту под размер меню.
	}
}
