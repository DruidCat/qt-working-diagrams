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
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			border.width: tmDannie.ntCoff/2//Бордюр при переименовании.
			clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.

			DCMenu {
				id: menuDannie
				visible: false//Невидимое меню. 
				ntWidth: tmDannie.ntWidth
				ntCoff: tmDannie.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: tmDannie.ntCoff
				clrTexta: tmDannie.clrTexta
				clrFona: "SlateGray"
				imyaMenu: "dannie"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
				onClicked: function(ntNomer, strMenu) {
					menuDannie.visible = false;//Делаем невидимым меню.
					if(ntNomer == 2){//Переименовать.
						//blPereimenovat = true;
					}
					if(ntNomer == 4){//Выход
						Qt.quit();//Закрыть приложение.
					}
				}
			}
		}
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
		DCKnopkaNastroiki {
			ntWidth: tmDannie.ntWidth
			ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: tmDannie.ntCoff/2
			clrKnopki: tmDannie.clrTexta
			clrFona: tmDannie.clrFona
			onClicked: {
				//blPereimenovat = false;//Запрещено переименовывать.
				menuDannie.visible ? menuDannie.visible = false : menuDannie.visible = true;	
				//txnZagolovok.visible = false;//Отключаем создание Элемента списка.
			}
		}
    }
}
