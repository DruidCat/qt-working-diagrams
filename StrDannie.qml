import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
    id: tmDannie
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
    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
            onClicked: {
				tmDannie.clickedNazad();
            }
        }
        DCKnopkaSozdat {
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
			clrFona: tmDannie.clrFona
            onClicked: {
				tmDannie.clickedSozdat();
            }
        }
    }
    Item {//Данные Зона
		id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
    }
    Item {//Данные Тулбар
		id: tmToolbar
        DCKnopkaInfo {
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
			clrFona: tmDannie.clrFona
            onClicked: {
				tmDannie.clickedInfo();
            }
        }
    }
}
