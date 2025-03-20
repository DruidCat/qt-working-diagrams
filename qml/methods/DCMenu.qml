import QtQuick //2.14
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
                Rectangle {
                    id: rctText
                    anchors.fill: rctMenu
                    anchors.margins: tmMenu.ntCoff/2
                    color: "transparent"
                }
				Text {
					id: txtText
                    color: maMenu.containsPress ? Qt.darker(tmMenu.clrTexta, 1.3) : tmMenu.clrTexta
                    anchors.left: rctText.left
                    anchors.verticalCenter: rctText.verticalCenter
                    text: modelData.menu
                    font.pixelSize: rctText.height-tmMenu.ntCoff
                }
                Component.onCompleted: {//Когда текст нарисовался, расчитываю его длину.
                    if(rctText.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(let ltShag=txtText.font.pixelSize; ltShag<rctText.height-tmMenu.ntCoff; ltShag++){
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
						tmMenu.clicked(modelData.nomer, modelData.menu)
					}
				}
				onWidthChanged: {//Если длина строки изменилась, то...
                    if(rctText.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(let ltShag=txtText.font.pixelSize; ltShag<rctText.height-tmMenu.ntCoff; ltShag++){
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
		anchors.fill: tmMenu
		anchors.topMargin:tmMenu.ntCoff
		anchors.bottomMargin:tmMenu.ntCoff
        anchors.leftMargin:tmMenu.width/2//Отступ отлевого края половина длины экрана.
        anchors.rightMargin:tmMenu.ntCoff/2//Отступ от правого края пол коэффициента
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
