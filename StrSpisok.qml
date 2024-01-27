import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
    id: tmSpisok
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
	signal clickedMenu();//Сигнал нажатия кнопки Меню. 
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedSpisok(var strSpisok);//Сигнал когда нажат один из элементов Списка.
	Item {//Спискок Заголовка
		id: tmZagolovok
		DCKnopkaMenu {
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
				tmSpisok.clickedMenu();//Сигнал Меню
			}
		}
		DCKnopkaSozdat {
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
			}
		}
	}
	Item {//Список Рабочей Зоны
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
		ZonaSpisok {
			id: lsvZonaSpisok
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.fill: tmZona
			clrTexta: tmSpisok.clrTexta
			clrFona: "SlateGray"
			onClickedSpisok: function(ntNomer, strSpisok) {//Слот нажатия на один из элементов Списка.
				cppqml.untSpisokNomer = ntNomer;//Присваиваем номер списка к свойству Q_PROPERTY
				tmSpisok.clickedSpisok(strSpisok);//Излучаем сигнал с именем элемента Списка.
			}
		}
		DCLogoTMK {//Логотип
			ntCoff: 16
			anchors.centerIn: parent
			clrLogo: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
		}
	}
	Item {//Список Тулбара
		id: tmToolbar
		DCKnopkaZakrit {
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
				Qt.quit();
			}
		}
		DCKnopkaInfo {
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
			}
		}
	}
}
