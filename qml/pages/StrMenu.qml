﻿import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
//Страница отображающая Меню.
Item {
	id: tmMenu
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
	property color clrFona: "black"
	property alias zagolovokX: tmZagolovok.x
	property alias zagolovokY: tmZagolovok.y
	property alias zagolovokWidth: tmZagolovok.width
	property alias zagolovokHeight: tmZagolovok.height
	property alias zonaX: tmZona.x
	property alias zonaY: tmZona.y
	property alias zonaWidth: tmZona.width
	property alias zonaHeight: tmZona.height
	property alias toolbarX: tmToolbar.x
	property alias toolbarY: tmToolbar.y
	property alias toolbarWidth: tmToolbar.width
	property alias toolbarHeight: tmToolbar.height
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedLogi();//Сигнал нажатия кнопки Логи.
	signal clickedWorkingDiagrams();//Сигнал нажатия кнопки об Рабочих Схемах.
    signal clickedPlan();//Сигнал нажатия кнопки План.
    signal clickedQt();//Сигнал нажатия кнопки Об Qt.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            menuMenu.visible = false;//Делаем невидимым всплывающее меню.
        }
    }

    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmMenu
        onClicked: menuMenu.visible = false
    }

	Item {
		id: tmZagolovok
        DCKnopkaVpered{//@disable-check M300
			ntWidth: tmMenu.ntWidth
			ntCoff: tmMenu.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: tmMenu.clrTexta
			onClicked: {
                menuMenu.visible = false;//Делаем невидимым меню.
                tmMenu.clickedNazad();//Сигнал нажатия кнопки Назад.
			}
		}
	} 
    Item {
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        Flickable {//Рабочая Зона скроллинга
            id: flZona
            anchors.fill: tmZona//Расстягиваемся по всей рабочей зоне
            contentWidth: tmZona.width//Ширина контента, который будет вложен равен ширине Рабочей Зоны
            contentHeight: (tmMenu.ntWidth*tmMenu.ntCoff+8+tmMenu.ntCoff)*6//6 - количество кнопок.

            Rectangle {//Прямоугольник, в которм будут собраны все кнопки.
                id: rctZona
                width: tmZona.width
                height: flZona.contentHeight
                color: "transparent"

                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaLogi
                    ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
                    anchors.top: rctZona.top
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: tmMenu.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: tmMenu.clrTexta
                    text: qsTr("Логи")
                    bold: true
                    italic: true
                    onClicked: {
                        menuMenu.visible = false;//Делаем невидимым меню.
                        tmMenu.clickedLogi();//Сигнал нажатия кнопки Логи.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaAvtor
                    ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
                    anchors.top: knopkaLogi.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: tmMenu.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: tmMenu.clrTexta
                    text: qsTr("О приложении")
                    bold: true
                    italic: true
                    onClicked: {
                        menuMenu.visible = false;//Делаем невидимым меню.
                        tmMenu.clickedWorkingDiagrams();//Сигнал нажатия кнопки об приложении Рабочие Схемы.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaSpisok
                    ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
                    anchors.top: knopkaAvtor.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: tmMenu.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: tmMenu.clrTexta
                    text: qsTr("Участки")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        //Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
                        pvSpisok.visible ? pvSpisok.visible = false : pvSpisok.visible = true;
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaPlan
                    ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
                    anchors.top: knopkaSpisok.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: tmMenu.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: tmMenu.clrTexta
                    text: qsTr("План")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        tmMenu.clickedPlan();//Сигнал нажатия кнопки План.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaQt
                    ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
                    anchors.top: knopkaPlan.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: tmMenu.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: tmMenu.clrTexta
                    text: qsTr("О Qt")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        tmMenu.clickedQt();//Сигнал нажатия кнопки об Qt.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaVihod
                    ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
                    anchors.top: knopkaQt.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: tmMenu.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: tmMenu.clrTexta
                    text: qsTr("Выход")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        Qt.quit();//Закрыть приложение.
                    }
                }
            }
        }
        PathViewSpisok {//@disable-check M300
            id: pvSpisok
            visible: false
            ntWidth: tmMenu.ntWidth
            ntCoff: tmMenu.ntCoff
            anchors.left: tmZona.left
            anchors.right: tmZona.right
            anchors.bottom: tmZona.bottom
            anchors.margins: tmMenu.ntCoff
            clrTexta: tmMenu.clrTexta
            clrFona: "SlateGray"
            onSSpisok: function(strSpisok) {
                pvSpisok.visible = false;
                knopkaSpisok.text = strSpisok;
            }
        }
        DCMenu {//@disable-check M300//Меню отображается в Рабочей Зоне приложения.
            id: menuMenu
            visible: false//Невидимое меню.
            ntWidth: tmMenu.ntWidth
            ntCoff: tmMenu.ntCoff
            anchors.left: tmZona.left
            anchors.right: tmZona.right
            anchors.bottom: tmZona.bottom
            anchors.margins: tmMenu.ntCoff
            clrTexta: tmMenu.clrTexta
            clrFona: "SlateGray"
            imyaMenu: "vihod"//Глянь в DCMenu все варианты меню в слоте окончательной отрисовки.
            onClicked: function(ntNomer, strMenu) {//Слот сигнала клика по пункту меню.
                menuMenu.visible = false;//Делаем невидимым меню.
                if(ntNomer === 1){//Выход
                    Qt.quit();//Закрыть приложение.
                }
            }
        }
	}
    Item {//Тулбар
		id: tmToolbar
        DCKnopkaNastroiki {//@disable-check M300//Кнопка Меню.
            ntWidth: tmMenu.ntWidth
            ntCoff: tmMenu.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.right: tmToolbar.right
            anchors.margins: tmMenu.ntCoff/2
            clrKnopki: tmMenu.clrTexta
            clrFona: tmMenu.clrFona
            blVert: true//Вертикольное исполнение
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                menuMenu.visible ? menuMenu.visible = false : menuMenu.visible = true;//Изменяем видимость
            }
        }
	}
}
