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
	signal clickedElement(var strElement);//Сигнал когда нажат один из Элементов.

	function fnClickedOk(){//Функция сохранения данных.
		cppqml.strElementDB = txnZagolovok.text;//Сохранить название Элемента списка, и только потом..
		txnZagolovok.visible = false;//Сначала записываем, потом обнуляем.
	}
	Item {//Элементы Заголовок
		id: tmZagolovok
		DCKnopkaNazad {
			id: knopkaNazad
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.left: tmZagolovok.left
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {
				txnZagolovok.visible = false;
				tmElement.clickedNazad();//Сигнал Назад.
			}
		}
		DCKnopkaSozdat {
			id: knopkaSozdat
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.right: tmZagolovok.right
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
			onClicked: {
				txnZagolovok.visible = true;
			}
		}
		DCKnopkaOk{
			id: knopkaOk
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
			onClicked: {
				fnClickedOk();//Функция сохранения данных.
			}
		}
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaNazad.right
			anchors.right: knopkaSozdat.left
			anchors.topMargin: tmElement.ntCoff/4
			anchors.bottomMargin: tmElement.ntCoff/4
			anchors.leftMargin: tmElement.ntCoff/2
			anchors.rightMargin: tmElement.ntCoff/2
			DCTextInput {
				id: txnZagolovok
				ntWidth: tmElement.ntWidth
				ntCoff: tmElement.ntCoff
				anchors.fill: tmTextInput
				visible: false
				clrTexta: tmElement.clrTexta
				clrFona: "SlateGray"
				radius: tmElement.ntCoff/2
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
				textInput.maximumLength: 33
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
					txnZagolovok.visible ? knopkaOk.visible = true : knopkaOk.visible = false; 
					txnZagolovok.visible ? knopkaSozdat.visible = false : knopkaSozdat.visible = true; 
					if(txnZagolovok.visible == false){//Если DCTextInput не видим, то...
						txnZagolovok.text = "";//Текст обнуляем вводимый.
						knopkaSozdat.focus = true;//Фокус на кнопке Создать, чтоб не работал Enter.
					}
					else{//Если DCTextInput видимый, то...
						textInput.cursorVisible = true;//Делаем курсор видимым обязательно.
						textInput.forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
					}
				}
				onClickedEnter: {//слот нажатия кнопки Enter.
					fnClickedOk();//Функция сохранения данных.
				}
				onClickedEscape: {
					txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
				}
			}
		}
	}
	Item {//Список Рабочей Зоны
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
		ZonaElement {
			id: lsvZona
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.fill: tmZona
			clrTexta: tmElement.clrTexta
			clrFona: "SlateGray"
			onClicked: function(ntKod, strElement) {//Слот нажатия на один из элементов Списка.
				if(cppqml.blElementPervi){//Если это первый элемент, то...
					txnZagolovok.visible = true;//Включаем создание Элемента.
				}
				else{//Если не первый элемент, то...
					txnZagolovok.visible = false;//Отключаем создание Элемента.
					cppqml.ullElementKod = ntKod;//Присваиваем Код Элемента к свойству Q_PROPERTY
					cppqml.strElement = strElement;//Присваиваем элемент списка к свойству Q_PROPERTY
					tmElement.clickedElement(strElement);//Излучаем сигнал с именем Элемента.
				}
			}
		}
		DCLogoTMK {//Логотип
			ntCoff: 16
			anchors.centerIn: parent
			clrLogo: tmElement.clrTexta
			clrFona: tmElement.clrFona
		}
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
				txnZagolovok.visible = false;//Отключаем создание Элемента списка.
				tmElement.clickedInfo();//Излучаем сигнал, что кнопка в блоке кода нажата.
			}
		}
		DCKnopkaNastroiki {
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
			onClicked: {

			}
		}
	}
}
