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
			id: knopkaMenu
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
				txnZagolovok.visible = false;//Отключаем создание Элемента списка.
				tmSpisok.clickedMenu();//Сигнал Меню
			}
		}
		DCKnopkaSozdat {
			id: knopkaSozdat
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			visible: true
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
				txnZagolovok.visible = true;
			}
		}
		DCKnopkaOk{
			id: knopkaOk
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
				cppqml.strSpisokDB = txnZagolovok.text;//Сохранить название элемента списка, и только потом...
				txnZagolovok.visible = false;//Сначала записываем, потом обнуляем.
			}
		}
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaMenu.right
			anchors.right: knopkaSozdat.left
			anchors.topMargin: tmElement.ntCoff/4
			anchors.bottomMargin: tmElement.ntCoff/4
			anchors.leftMargin: tmElement.ntCoff/2
			anchors.rightMargin: tmElement.ntCoff/2
			DCTextInput {
				id: txnZagolovok
				ntWidth: tmSpisok.ntWidth
				ntCoff: tmSpisok.ntCoff
				anchors.fill: tmTextInput
				visible: false
				clrTexta: tmSpisok.clrTexta
				clrFona: "SlateGray"
				radius: tmSpisok.ntCoff/2
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
				textInput.maximumLength: 33
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
					txnZagolovok.visible ? knopkaOk.visible = true : knopkaOk.visible = false; 
					txnZagolovok.visible ? knopkaSozdat.visible = false : knopkaSozdat.visible = true; 
					if(txnZagolovok.visible == false){//Если DCTextInput не видим, то...
						txnZagolovok.text = "";//Текст обнуляем вводимый.
					}
				}
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
			onClicked: function(ntKod, strSpisok) {//Слот нажатия на один из элементов Списка.
				txnZagolovok.visible = false;//Отключаем создание Элемента списка.
				cppqml.ullSpisokKod = ntKod;//Присваиваем Код списка к свойству Q_PROPERTY
				cppqml.strSpisok = strSpisok;//Присваиваем элемент списка к свойству Q_PROPERTY
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
		DCKnopkaInfo {
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
				txnZagolovok.visible = false;//Делаем невидимым ввод текста.
			}
		}
	}
}
