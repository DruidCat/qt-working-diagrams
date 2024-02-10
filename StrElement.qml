import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
	id: tmElement
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
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	Item {//Состав Заголовок
		id: tmZagolovok
		DCKnopkaNazad {
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.left: tmZagolovok.left
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {
				tmElement.clickedNazad();//Сигнал Назад.
			}
		}
		DCKnopkaSozdat {
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.right: tmZagolovok.right
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
			onClicked: {
			}
		}
	}
	Item {//Состава Зона
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
	}
	Item {//Состава Тулбар
		id: tmToolbar
		DCKnopkaInfo {
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {//Слот клика кнопки Инфо
				tmElement.clickedInfo();//Излучаем сигнал, что кнопка в блоке кода нажата.
			}
		}
	}
}
