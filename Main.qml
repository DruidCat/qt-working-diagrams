import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
	id: root
    width: 380
    height: 640
	visible: true
	color: "grey"
	title: qsTr("Список от druidcat@yandex.ru.")

    property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopok: "orange"
	property color clrFona: "grey"
	property color clrStranic: "black"

	StackView {
		id: stvStr
		anchors.fill: parent
		initialItem: pgStrSpisok
		//initialItem: pgStrMenu
		//initialItem: pgStrDannie
		Stranica {//Меню
		/////////////
		///М Е Н Ю///
		/////////////
			id: pgStrMenu
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			//clrRabOblasti: "darkslategray"
			clrRabOblasti: "MidnightBlue"
			textZagolovok: "МЕНЮ"
			StrMenu {
				id: tmMenu
				ntWidth: pgStrMenu.ntWidth; ntCoff: pgStrMenu.ntCoff
				clrTexta: pgStrMenu.clrTexta; clrFona: pgStrMenu.clrRabOblasti
				zagolovokX: pgStrMenu.rctStrZagolovok.x; zagolovokY: pgStrMenu.rctStrZagolovok.y
				zagolovokWidth: pgStrMenu.rctStrZagolovok.width
				zagolovokHeight: pgStrMenu.rctStrZagolovok.height
				zonaX: pgStrMenu.rctStrZona.x; zonaY: pgStrMenu.rctStrZona.y
				zonaWidth: pgStrMenu.rctStrZona.width; zonaHeight: pgStrMenu.rctStrZona.height
				toolbarX: pgStrMenu.rctStrToolbar.x; toolbarY: pgStrMenu.rctStrToolbar.y
				toolbarWidth: pgStrMenu.rctStrToolbar.width; toolbarHeight: pgStrMenu.rctStrToolbar.height
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
		Stranica {//Страница со Списком
		/////////////////
		///С П И С О К///
		/////////////////
			id: pgStrSpisok
			visible: true
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
			textZagolovok: "ТМК"
			Item {//Спискок Заголовка
				id: tmSpisokZagolovok
				x: pgStrSpisok.rctStrZagolovok.x
				y: pgStrSpisok.rctStrZagolovok.y
				width: pgStrSpisok.rctStrZagolovok.width
				height: pgStrSpisok.rctStrZagolovok.height
				DCKnopkaMenu {
					ntWidth: pgStrSpisok.ntWidth
					ntCoff: pgStrSpisok.ntCoff
					anchors.verticalCenter: tmSpisokZagolovok.verticalCenter
					anchors.left: tmSpisokZagolovok.left
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrSpisok.clrTexta
					clrFona: pgStrSpisok.clrRabOblasti
					onClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
						stvStr.push(pgStrMenu)
					}
				}
				DCKnopkaSozdat {
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.verticalCenter: tmSpisokZagolovok.verticalCenter
					anchors.right: tmSpisokZagolovok.right
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrSpisok.clrTexta
					clrFona: pgStrSpisok.clrRabOblasti
					onClicked: {
					}
				}
			}
			Item {//Список Рабочей Зоны
				id: tmSpisokZona
				x: pgStrSpisok.rctStrZona.x
				y: pgStrSpisok.rctStrZona.y
				width: pgStrSpisok.rctStrZona.width
				height: pgStrSpisok.rctStrZona.height
				clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
				ZonaSpisok {
					id: lsvZonaSpisok
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.fill: tmSpisokZona
					clrTexta: pgStrSpisok.clrTexta
					clrFona: "SlateGray"
					onSSpisok: function(ntNomer, strSpisok) {//Слот нажатия на один из элементов Списка.
						cppqml.untSpisokNomer = ntNomer;//Присваиваем номер списка к свойству Q_PROPERTY
						pgStrSostav.textZagolovok = strSpisok;//Задаём заголовок на второй странице.
						stvStr.push(pgStrSostav);//Переключаемся на страницу Состава.
						//stvStr.push(pgStrDannie);
					}
				}
				DCLogoTMK {//Логотип
					ntCoff: 16
					anchors.centerIn: parent
					clrLogo: pgStrSpisok.clrTexta
					clrFona: pgStrSpisok.clrRabOblasti
				}
			}
			
			Item {//Список Тулбара
				id: tmSpisokToolbar
				x: pgStrSpisok.rctStrToolbar.x
				y: pgStrSpisok.rctStrToolbar.y
				width: pgStrSpisok.rctStrToolbar.width
				height: pgStrSpisok.rctStrToolbar.height
				DCKnopkaZakrit {
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.verticalCenter: tmSpisokToolbar.verticalCenter
					anchors.left: tmSpisokToolbar.left
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrSpisok.clrTexta
					clrFona: pgStrSpisok.clrRabOblasti
					onClicked: {
						Qt.quit();
					}
				}
				DCKnopkaInfo {
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.verticalCenter: tmSpisokToolbar.verticalCenter
					anchors.right: tmSpisokToolbar.right
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrSpisok.clrTexta
					clrFona: pgStrSpisok.clrRabOblasti
					onClicked: {
					}
				}
			}
		}
		Stranica {//Страница Состава Списка
		/////////////////
		///С О С Т А В///
		/////////////////
			id: pgStrSostav
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: root.clrStranic
			Item {//Состав Заголовок
				id: tmSostavZagolovok
				x: pgStrSostav.rctStrZagolovok.x
				y: pgStrSostav.rctStrZagolovok.y
				width: pgStrSostav.rctStrZagolovok.width
				height: pgStrSostav.rctStrZagolovok.height
				DCKnopkaNazad {
					ntWidth: pgStrSostav.ntWidth
					ntCoff: pgStrSostav.ntCoff
					anchors.left: tmSostavZagolovok.left
					anchors.verticalCenter: tmSostavZagolovok.verticalCenter
					anchors.margins: ntCoff/2
					clrKnopki: pgStrSostav.clrTexta
					onClicked: {
						stvStr.pop()//Назад страницу
					}
				}
				DCKnopkaSozdat {
					ntWidth: pgStrSostav.ntWidth
					ntCoff: pgStrSostav.ntCoff
					anchors.right: tmSostavZagolovok.right
					anchors.verticalCenter: tmSostavZagolovok.verticalCenter
					anchors.margins: ntCoff/2
					clrKnopki: pgStrSostav.clrTexta
					clrFona: pgStrSostav.clrRabOblasti
					onClicked: {
					}
				}
			}
			Item {//Состава Зона
				id: tmSostavZona
				x: pgStrSostav.rctStrZona.x
				y: pgStrSostav.rctStrZona.y
				width: pgStrSostav.rctStrZona.width
				height: pgStrSostav.rctStrZona.height
				clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
			}
			Item {//Состава Тулбар
				id: tmSostavToolbar
				x: pgStrSostav.rctStrToolbar.x
				y: pgStrSostav.rctStrToolbar.y
				width: pgStrSostav.rctStrToolbar.width
				height: pgStrSostav.rctStrToolbar.height
				DCKnopkaInfo {
					ntWidth: pgStrSostav.ntWidth
					ntCoff: pgStrSostav.ntCoff
					anchors.verticalCenter: tmSostavToolbar.verticalCenter
					anchors.right: tmSostavToolbar.right
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrSostav.clrTexta
					onClicked: {//Выход, чтоб удобней было настраивать. Потом удалю.
						tmOpisanie.textTextEdit = cppqml.strSpisokOpisanie;
						stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
					}
				}
			}
		}
		Stranica {//Страница Описания
		/////////////////////
		///О П И С А Н И Е///
		/////////////////////
			id: pgStrOpisanie
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: root.clrStranic
			textZagolovok: "Описание"
			StrOpisanie {
				id: tmOpisanie
				ntWidth: pgStrOpisanie.ntWidth; ntCoff: pgStrOpisanie.ntCoff
				clrTexta: pgStrOpisanie.clrTexta; clrFona: pgStrOpisanie.clrRabOblasti
				zagolovokX: pgStrOpisanie.rctStrZagolovok.x; zagolovokY: pgStrOpisanie.rctStrZagolovok.y
				zagolovokWidth: pgStrOpisanie.rctStrZagolovok.width
				zagolovokHeight: pgStrOpisanie.rctStrZagolovok.height
				zonaX: pgStrOpisanie.rctStrZona.x; zonaY: pgStrOpisanie.rctStrZona.y
				zonaWidth: pgStrOpisanie.rctStrZona.width; zonaHeight: pgStrOpisanie.rctStrZona.height
				toolbarX: pgStrOpisanie.rctStrToolbar.x; toolbarY: pgStrOpisanie.rctStrToolbar.y
				toolbarWidth: pgStrOpisanie.rctStrToolbar.width
				toolbarHeight: pgStrOpisanie.rctStrToolbar.height
				radiusTextEdit: pgStrOpisanie.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
				onClickedSozdat: {

				}
			}
		}
		Stranica {//Страница с Данными
		/////////////////
		///Д А Н Н Ы Е///
		/////////////////
			id: pgStrDannie
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: root.clrStranic
			StrDannie {//Блок управления Данными, чтоб разгрузить Main.qml
				ntWidth: pgStrDannie.ntWidth; ntCoff: pgStrDannie.ntCoff
				clrTexta: pgStrDannie.clrTexta; clrFona: pgStrDannie.clrRabOblasti
				zagolovokX: pgStrDannie.rctStrZagolovok.x; zagolovokY: pgStrDannie.rctStrZagolovok.y
				zagolovokWidth: pgStrDannie.rctStrZagolovok.width;
				zagolovokHeight: pgStrDannie.rctStrZagolovok.height
				zonaX: pgStrDannie.rctStrZona.x; zonaY: pgStrDannie.rctStrZona.y
				zonaWidth: pgStrDannie.rctStrZona.width; zonaHeight: pgStrDannie.rctStrZona.height
				toolbarX: pgStrDannie.rctStrToolbar.x; toolbarY: pgStrDannie.rctStrToolbar.y
				toolbarWidth: pgStrDannie.rctStrToolbar.width; toolbarHeight: pgStrDannie.rctStrToolbar.height
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
			}
		}
	}
}
