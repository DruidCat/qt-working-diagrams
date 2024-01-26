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
			Item {
				id: tmMenuZagolovok
				x: pgStrMenu.rctStrZagolovok.x
				y: pgStrMenu.rctStrZagolovok.y
				width: pgStrMenu.rctStrZagolovok.width
				height: pgStrMenu.rctStrZagolovok.height
				DCKnopkaNazad {
					ntWidth: pgStrMenu.ntWidth
					ntCoff: pgStrMenu.ntCoff
					anchors.verticalCenter: tmMenuZagolovok.verticalCenter
					anchors.left: tmMenuZagolovok.left
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrMenu.clrTexta
					onClicked: {
						stvStr.pop()//Назад страницу
					}
				}
				DCKnopkaNastroiki {
					ntWidth: pgStrMenu.ntWidth
					ntCoff: pgStrMenu.ntCoff
					anchors.verticalCenter: tmMenuZagolovok.verticalCenter
					anchors.right: tmMenuZagolovok.right
					anchors.margins: root.ntCoff/2
					clrKnopki: pgStrMenu.clrTexta
					onClicked: {//Выход, чтоб удобней было настраивать. Потом удалю.
						Qt.quit();
					}
				}
			}
			Item {
				id: tmMenuZona
				x: pgStrMenu.rctStrZona.x
				y: pgStrMenu.rctStrZona.y
				width: pgStrMenu.rctStrZona.width
				height: pgStrMenu.rctStrZona.height
				clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
				DCKnopkaOriginal {
					id: menuZonaKnopkaLog
					ntHeight: root.ntWidth*root.ntCoff+8
					anchors.top: tmMenuZona.top
					anchors.left: tmMenuZona.left
					anchors.right: tmMenuZona.right
					anchors.margins: root.ntCoff/2
					clrKnopki: "slategray"
					clrTexta: pgStrMenu.clrTexta
					text: "Логи"
					bold: true
					italic: true
				}
				DCKnopkaOriginal {
					id: menuZonaKnopkaObAvtore
					ntHeight: root.ntWidth*root.ntCoff+8
					anchors.top: menuZonaKnopkaLog.bottom
					anchors.left: tmMenuZona.left
					anchors.right: tmMenuZona.right
					anchors.margins: root.ntCoff/2
					clrKnopki: "slategray"
					clrTexta: pgStrMenu.clrTexta
					text: "Об авторе"
					bold: true
					italic: true
				}
				DCKnopkaOriginal {
					id: menuZonaKnopkaSpisok
					ntHeight: root.ntWidth*root.ntCoff+8
					anchors.top: menuZonaKnopkaObAvtore.bottom
					anchors.left: tmMenuZona.left
					anchors.right: tmMenuZona.right
					anchors.margins: root.ntCoff/2
					clrKnopki: "slategray"
					clrTexta: pgStrMenu.clrTexta
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
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.left: tmMenuZona.left
					anchors.right: tmMenuZona.right
					anchors.bottom: tmMenuZona.bottom
					anchors.margins: root.ntCoff
					clrTexta: pgStrMenu.clrTexta
					clrFona: "SlateGray"
					onSSpisok: function(strSpisok) {
						pvSpisok.visible = false;
						menuZonaKnopkaSpisok.text = strSpisok;
					}
				}
			}
			Item {
				id: tmMenuToolbar
				x: pgStrMenu.rctStrToolbar.x
				y: pgStrMenu.rctStrToolbar.y
				width: pgStrMenu.rctStrToolbar.width
				height: pgStrMenu.rctStrToolbar.height
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
						txdOpisanie.text = cppqml.strSpisokOpisanie;
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
			Item {
				id: tmOpisanieZagolovok
				x: pgStrOpisanie.rctStrZagolovok.x
				y: pgStrOpisanie.rctStrZagolovok.y
				width: pgStrOpisanie.rctStrZagolovok.width
				height: pgStrOpisanie.rctStrZagolovok.height
				DCKnopkaNazad {
					ntWidth: pgStrOpisanie.ntWidth
					ntCoff: pgStrOpisanie.ntCoff
					anchors.verticalCenter: tmOpisanieZagolovok.verticalCenter
					anchors.left: tmOpisanieZagolovok.left
					anchors.margins: ntCoff/2
					clrKnopki: pgStrOpisanie.clrTexta
					onClicked: {
						stvStr.pop()//Назад страницу
					}
				}
				DCKnopkaSozdat {
					ntWidth: pgStrOpisanie.ntWidth
					ntCoff: pgStrOpisanie.ntCoff
					anchors.verticalCenter: tmOpisanieZagolovok.verticalCenter
					anchors.right: tmOpisanieZagolovok.right
					anchors.margins: ntCoff/2
					clrKnopki: pgStrOpisanie.clrTexta
					clrFona: pgStrOpisanie.clrRabOblasti
					onClicked: {
						txdOpisanie.readOnly ? txdOpisanie.readOnly = false : txdOpisanie.readOnly = true;
					}
				}
			}
			Item {
				id: tmOpisanieZona
				x: pgStrOpisanie.rctStrZona.x
				y: pgStrOpisanie.rctStrZona.y
				width: pgStrOpisanie.rctStrZona.width
				height: pgStrOpisanie.rctStrZona.height
				clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
				DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
					id: txdOpisanie
					ntWidth: pgStrOpisanie.ntWidth
					ntCoff: pgStrOpisanie.ntCoff
					readOnly: true//Запрещено редактировать текст
					radius: pgStrOpisanie.rctStrZona.radius//Радиус берём из настроек элемента qml
					clrFona: pgStrOpisanie.clrRabOblasti//Цвет фона рабочей области
					clrTexta: pgStrOpisanie.clrTexta//Цвет текста
					clrBorder: pgStrOpisanie.clrTexta//Цвет бардюра при редактировании текста.
					italic: true//Текст курсивом.
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
				ntWidth: pgStrDannie.ntWidth
				ntCoff: pgStrDannie.ntCoff
				clrTexta: pgStrDannie.clrTexta
				clrFona: pgStrDannie.clrRabOblasti
				zagolovokX: pgStrDannie.rctStrZagolovok.x; zagolovokY: pgStrDannie.rctStrZagolovok.y
				zagolovokWidth: pgStrDannie.rctStrZagolovok.width; zagolovokHeight: pgStrDannie.rctStrZagolovok.height
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
