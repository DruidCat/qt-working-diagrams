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
		DCKnopkaNastroiki {
			ntWidth: tmMenu.ntWidth
			ntCoff: tmMenu.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: tmMenu.clrTexta
			onClicked: {//Выход, чтоб удобней было настраивать. Потом удалю.
				Qt.quit();
			}
		}
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
		DCKnopkaOriginal {
			id: zonaKnopkaLog
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
		}
		DCKnopkaOriginal {
			id: zonaKnopkaObAvtore
			ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
			anchors.top: zonaKnopkaLog.bottom
			anchors.left: tmZona.left
			anchors.right: tmZona.right
			anchors.margins: tmMenu.ntCoff/2
			clrKnopki: "slategray"
			clrTexta: tmMenu.clrTexta
			text: "Об авторе"
			bold: true
			italic: true
		}
		DCKnopkaOriginal {
			id: zonaKnopkaSpisok
			ntHeight: tmMenu.ntWidth*tmMenu.ntCoff+8
			anchors.top: zonaKnopkaObAvtore.bottom
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
