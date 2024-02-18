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
	property alias radiusZona: rctZona.radius//Радиус Зоны рабочей
	property bool blPereimenovat: false//Переименовать, если true
	anchors.fill: parent//Растянется по Родителю.
	signal clickedMenu();//Сигнал нажатия кнопки Меню. 
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedSpisok(var strSpisok);//Сигнал когда нажат один из элементов Списка.

	function fnClickedOk(){//Функция сохранения/переименования элемента Списка.
		if(blPereimenovat){//Если Переименовываем, то...
			cppqml.renStrSpisokDB(cppqml.strSpisok, txnZagolovok.text);//Переименовываем элемент Списка.
		}
		else{//иначе...
			cppqml.strSpisokDB = txnZagolovok.text;//Сохранить название элемента списка, и только потом...
		}
		blPereimenovat = false;//Запрещено переименовывать.
		menuSpisok.visible = false;//Делаем невидимым меню.
		txnZagolovok.visible = false;//Сначала записываем или переименовываем, и только потом обнуляем.		
	}
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
				blPereimenovat = false;//Запрещено переименовывать.
				menuSpisok.visible = false;//Делаем невидимым меню.
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
				blPereimenovat = false;//Запрещено переименовывать.
				menuSpisok.visible = false;//Делаем невидимым меню.
				txnZagolovok.visible = true;//Режим создания элемента Списка.
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
			onClicked: {//Нажимаем Ок.
				fnClickedOk();//Нажимаем на Ок(Сохранить/Переименовать), чтоб не изменять в нескольких местах.
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
						knopkaSozdat.focus = true;//Фокус на кнопке Создать, чтоб не работал Enter.
					}
					else{
						textInput.cursorVisible = true;//Делаем курсор видимым обязательно.
						textInput.forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
					}
				}
				onClickedEnter: {//Если нажата Enter, то такое же действие, как и при нажатии кнопки Ок.
					fnClickedOk();//Нажимаем Ок(Сохранить/Переименовать), чтоб не менять в нескольких местах.
				}
				onClickedEscape: {
					txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
					blPereimenovat = false;//Запрещено переименовывать.
				}
			}
		}
	}
	onBlPereimenovatChanged: {//Сигнал изменения property blPereimenovat 
   		tmSpisok.blPereimenovat ? rctZona.border.color = clrTexta : rctZona.border.color = "transparent";
	}
	Item {//Список Рабочей Зоны
		id: tmZona
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			border.width: tmSpisok.ntCoff/2//Бордюр при переименовании.
			clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
			ZonaSpisok {
				id: lsvZonaSpisok
				ntWidth: tmSpisok.ntWidth
				ntCoff: tmSpisok.ntCoff
				anchors.fill: rctZona
				clrTexta: tmSpisok.clrTexta
				clrFona: "SlateGray"
				onClicked: function(ntKod, strSpisok) {//Слот нажатия на один из элементов Списка.
					if(blPereimenovat){
						txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
						cppqml.strSpisok = strSpisok;//Присваиваем элемент списка к свойству Q_PROPERTY
						txnZagolovok.text = strSpisok;//Добавляем в строку выбранный элемент Списка.
					}
					else{
						blPereimenovat = false;//Запрещено переименовывать.
						txnZagolovok.visible = false;//Отключаем создание Элемента списка.
						menuSpisok.visible = false;//Делаем невидимым меню.
						cppqml.ullSpisokKod = ntKod;//Присваиваем Код списка к свойству Q_PROPERTY
						cppqml.strSpisok = strSpisok;//Присваиваем элемент списка к свойству Q_PROPERTY
						tmSpisok.clickedSpisok(strSpisok);//Излучаем сигнал с именем элемента Списка.
					}
				}
			}
			DCLogoTMK {//Логотип
				ntCoff: 16
				anchors.centerIn: parent
				clrLogo: tmSpisok.clrTexta
				clrFona: tmSpisok.clrFona
			}
			DCMenu {
				id: menuSpisok
				visible: false//Невидимое меню. 
				ntWidth: tmSpisok.ntWidth
				ntCoff: tmSpisok.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: tmSpisok.ntCoff
				clrTexta: tmSpisok.clrTexta
				clrFona: "SlateGray"
				imyaMenu: "spisok"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
				onClicked: function(ntNomer, strMenu) {
					menuSpisok.visible = false;//Делаем невидимым меню.
					if(ntNomer == 2){//Переименовать.
						blPereimenovat = true;
					}
					if(ntNomer == 4){//Выход
						Qt.quit();//Закрыть приложение.
					}
				}
			}
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
				blPereimenovat = false;//Запрещено переименовывать.
				menuSpisok.visible = false;//Делаем невидимым меню.
				txnZagolovok.visible = false;//Отключаем создание Элемента списка.
				tmSpisok.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
			}
		}
		DCKnopkaNastroiki {
			ntWidth: tmSpisok.ntWidth
			ntCoff: tmSpisok.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: tmSpisok.ntCoff/2
			clrKnopki: tmSpisok.clrTexta
			clrFona: tmSpisok.clrFona
			onClicked: {
				blPereimenovat = false;//Запрещено переименовывать.
				menuSpisok.visible ? menuSpisok.visible = false : menuSpisok.visible = true;	
				txnZagolovok.visible = false;//Отключаем создание Элемента списка.
			}
		}
	}
}
