import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
	id: root
    width: 380
    height: 640
	visible: true
	color: "grey"
	title: qsTr("Электрические схемы предприятия.")

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

		//---С П И С О К---//
		Stranica {//Страница со Списком
			id: pgStrSpisok
			visible: true

			property color clrStranici: "black"
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff

			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: clrStranici

			text: "ТМК"

			Item {
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

					clrKnopki: clrKnopok
					clrFona: pgStrSpisok.clrStranici

					onClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
						stvStr.push(pgStrMenu)
					}
				}
				DCKnopkaZakrit {
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.verticalCenter: tmSpisokZagolovok.verticalCenter
					anchors.right: tmSpisokZagolovok.right
					anchors.margins: root.ntCoff/2

					clrKnopki: root.clrKnopok
					clrFona: pgStrSpisok.clrStranici

					onClicked: {
						//cppqml.slotTest();
						//console.log(cppqml.strSpisok)
						Qt.quit();
					}
				}
			}
			Item {
				id: tmSpisokZona
				x: pgStrSpisok.rctStrZona.x
				y: pgStrSpisok.rctStrZona.y
				width: pgStrSpisok.rctStrZona.width
				height: pgStrSpisok.rctStrZona.height

				ZonaSpisok {
					id: lsvZonaSpisok
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.fill: tmSpisokZona

					clrTexta: root.clrKnopok
					clrFona: "SlateGray"

					onSSpisok: function(ntNomer, strSpisok) {//Слот нажатия на один из элементов Списка.
						cppqml.untSpisokNomer = ntNomer;//Присваиваем номер списка к свойству Q_PROPERTY
						pgStrSostav.text = strSpisok;//Задаём заголовок на второй странице.
						stvStr.push(pgStrSostav);//Переключаемся на страницу Состава.
					}
				}
				DCLogoTMK {//Логотип
					ntCoff: 16
					anchors.centerIn: parent

					clrLogo: root.clrKnopok
					clrFona: pgStrSpisok.clrStranici
				}
			}
		}
		//---М Е Н Ю---//
		Stranica {//Меню
			id: pgStrMenu
			visible: false
			property color clrStranici: "darkslategray"

			ntWidth: root.ntWidth
			ntCoff: root.ntCoff

			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: clrStranici

			text: "МЕНЮ"

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

					clrKnopki: root.clrKnopok

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

					clrKnopki: root.clrKnopok
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

				DCKnopkaOriginal {
					id: menuZonaKnopkaObAvtore
					ntHeight: root.ntWidth*root.ntCoff+8
					anchors.top: tmMenuZona.top
					anchors.left: tmMenuZona.left
					//anchors.right: tmMenuZona.right
					anchors.margins: root.ntCoff/2

					clrKnopki: "slategray"
					clrTexta: root.clrKnopok
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
					clrTexta: root.clrKnopok
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

					clrTexta: root.clrKnopok
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

				DCKnopkaInfo {
					ntWidth: pgStrMenu.ntWidth
					ntCoff: pgStrMenu.ntCoff
					anchors.verticalCenter: tmMenuToolbar.verticalCenter
					anchors.right: tmMenuToolbar.right
					anchors.margins: root.ntCoff/2

					clrKnopki: root.clrKnopok
					onClicked: {//Выход, чтоб удобней было настраивать. Потом удалю.
						Qt.quit();
					}
				}
			}
		}
		//---С О С Т А В---//
		Stranica {//Страница Состава Списка
			id: pgStrSostav
			visible: false

			ntWidth: root.ntWidth
			ntCoff: root.ntCoff

			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: root.clrStranic

			DCKnopkaNazad {
				ntWidth: pgStrSostav.ntWidth
				ntCoff: pgStrSostav.ntCoff
				x: pgStrSostav.rctStrZagolovok.x+ntCoff/2
				y: pgStrSostav.rctStrZagolovok.y+ntCoff/2

				clrKnopki: root.clrKnopok

				onClicked: {
					stvStr.pop()//Назад страницу
				}
			}
			Item {//Состава Зона
				id: tmSostavZona
				x: pgStrSostav.rctStrZona.x
				y: pgStrSostav.rctStrZona.y
				width: pgStrSostav.rctStrZona.width
				height: pgStrSostav.rctStrZona.height
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

					clrKnopki: root.clrKnopok
					onClicked: {//Выход, чтоб удобней было настраивать. Потом удалю.
						txtOpisanie.text = cppqml.strSpisokOpisanie;
						stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
					}
				}
			}

			Connections {//Соединяем сигнал из C++ с действием в QML
				target: cppqml//Цель объект класса С++ DCCppQml
				function onStrSpisokChanged() {//Функция сигнал, которая создалась в QML (on) для сигнала C++
					//pgStrSostav.text = cppqml.strSpisok//Пишем текст заголовка из Свойтва Q_PROPERTY
				}
			}
		}
		//---О П И С А Н И Е---//
		Stranica {
			id: pgStrOpisanie
			visible: false
		
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff

			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: root.clrStranic

			text: "Описание"

			DCKnopkaNazad {
				ntWidth: pgStrOpisanie.ntWidth
				ntCoff: pgStrOpisanie.ntCoff
				x: pgStrOpisanie.rctStrZagolovok.x+ntCoff/2
				y: pgStrOpisanie.rctStrZagolovok.y+ntCoff/2

				clrKnopki: clrKnopok

				onClicked: {
					stvStr.pop()//Назад страницу
				}
			}
			Item {
				id: tmOpisanieZona
				x: pgStrOpisanie.rctStrZona.x
				y: pgStrOpisanie.rctStrZona.y
				width: pgStrOpisanie.rctStrZona.width
				height: pgStrOpisanie.rctStrZona.height
				Text {//текс выводящий описание в рабочую зону страницы.
					id: txtOpisanie
					anchors.fill: tmOpisanieZona

					color: clrKnopok
					text: ""
					font.pixelSize: root.ntWidth*root.ntCoff
				}
			}
		}
		//---Д А Н Н Ы Е---//
		Stranica {//Страница с Данными
			id: pgStrDannie
			visible: false

			ntWidth: root.ntWidth
			ntCoff: root.ntCoff

			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "MidnightBlue"

			DCKnopkaNazad {
				ntWidth: pgStrDannie.ntWidth
				ntCoff: pgStrDannie.ntCoff
				x: pgStrDannie.rctStrZagolovok.x+ntCoff/2
				y: pgStrDannie.rctStrZagolovok.y+ntCoff/2

				clrKnopki: clrKnopok

				onClicked: {
					stvStr.pop()//Назад страницу
				}
			}
		}
	}
}
