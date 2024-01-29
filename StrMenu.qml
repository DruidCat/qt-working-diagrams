import QtQuick
import QtQuick.Window
import QtQuick.Controls

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
				tmMenu.clickedAvtor();//Сигнал нажатия кнопки об Авторе.
			}
		}
		DCKnopkaOriginal {
			id: zonaKnopkaSpisok
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
				//Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
				pvSpisok.visible ? pvSpisok.visible = false : pvSpisok.visible = true;
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
				zonaKnopkaSpisok.text = strSpisok;
			}
		}
	}
	Item {
		id: tmToolbar
	}
}
