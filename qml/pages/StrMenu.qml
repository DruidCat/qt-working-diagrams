import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
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
	signal clickedAvtor();//Сигнал нажатия кнопки Автор.
    signal clickedPlan();//Сигнал нажатия кнопки План.
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
		DCKnopkaNazad {
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
		DCKnopkaOriginal {
			id: knopkaLogi
			ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
			anchors.top: tmZona.top
			anchors.left: tmZona.left
			anchors.right: tmZona.right
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: "slategray"
			clrTexta: tmMenu.clrTexta
			text: "Логи"
			bold: true
			italic: true
			onClicked: {
                menuMenu.visible = false;//Делаем невидимым меню.
                tmMenu.clickedLogi();//Сигнал нажатия кнопки Логи.
			}
		}
		DCKnopkaOriginal {
			id: knopkaAvtor
			ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
			anchors.top: knopkaLogi.bottom
			anchors.left: tmZona.left
			anchors.right: tmZona.right
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: "slategray"
			clrTexta: tmMenu.clrTexta
			text: "Об авторе"
			bold: true
			italic: true
			onClicked: {
                menuMenu.visible = false;//Делаем невидимым меню.
                tmMenu.clickedAvtor();//Сигнал нажатия кнопки об Авторе.
			}
		}
		DCKnopkaOriginal {
			id: knopkaSpisok
			ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
			anchors.top: knopkaAvtor.bottom
			anchors.left: tmZona.left
			anchors.right: tmZona.right
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: "slategray"
			clrTexta: tmMenu.clrTexta
			text: "Участки"
			bold: true
			italic: true
			onClicked: {//Слот запускающий 
                menuMenu.visible = false;//Делаем невидимым меню.
                //Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
				pvSpisok.visible ? pvSpisok.visible = false : pvSpisok.visible = true;
			}
		}
		DCKnopkaOriginal {
            id: knopkaPlan
			ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
			anchors.top: knopkaSpisok.bottom
			anchors.left: tmZona.left
			anchors.right: tmZona.right
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: "slategray"
			clrTexta: tmMenu.clrTexta
            text: "План"
			bold: true
			italic: true
			onClicked: {//Слот запускающий 
                menuMenu.visible = false;//Делаем невидимым меню.
                tmMenu.clickedPlan();//Сигнал нажатия кнопки План.
			}
		}
		PathViewSpisok {
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
        DCMenu {//Меню отображается в Рабочей Зоне приложения.
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
            imyaMenu: "vihod"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
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
        DCKnopkaNastroiki {//Кнопка Меню.
            ntWidth: tmMenu.ntWidth
            ntCoff: tmMenu.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            anchors.margins: tmMenu.ntCoff/2
            clrKnopki: tmMenu.clrTexta
            clrFona: tmMenu.clrFona
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                menuMenu.visible ? menuMenu.visible = false : menuMenu.visible = true;//Изменяем видимость
            }
        }
	}
}
