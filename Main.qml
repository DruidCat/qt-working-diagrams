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

	StackView {
		id: stvStr
		anchors.fill: parent
		//initialItem: pgStrSpisok
		initialItem: pgStrMenu

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

					onSSpisok: function(strSpisok) {
						//cppqml.strUchastokNazvanie = strSpisok;//Присваиваем к свойству Q_PROPERTY
						pgStrSostav.text = strSpisok;//Задаём заголовок на второй странице.
						stvStr.push(pgStrSostav);
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
					id: menuZonaKnopka
					ntHeight: root.ntWidth*root.ntCoff+8
					anchors.top: tmMenuZona.top
					anchors.left: tmMenuZona.left
					//anchors.right: tmMenuZona.right
					anchors.margins: root.ntCoff/2

					clrKnopki: "slategray"
					clrTexta: root.clrKnopok
					text: "Участки"
					bold: true
					italic: true
				}
				DCKnopkaOriginal {
					id: menuZonaKnopkaSpisok
					ntHeight: root.ntWidth*root.ntCoff+8
					anchors.top: menuZonaKnopka.bottom
					anchors.left: tmMenuZona.left
					anchors.right: tmMenuZona.right
					anchors.margins: root.ntCoff/2

					clrKnopki: "slategray"
					clrTexta: root.clrKnopok
					text: "Участки"
					bold: true
					italic: true

					onClicked: {//Слот запускающий 

					}
				}

				PathViewSpisok {
					id: lsvPVSpisok
					ntWidth: root.ntWidth
					ntCoff: root.ntCoff
					anchors.top: menuZonaKnopkaSpisok.bottom
					anchors.left: tmMenuZona.left
					anchors.right: tmMenuZona.right
					anchors.bottom: tmMenuZona.bottom

					clrTexta: root.clrKnopok
					clrFona: "SlateGray"
/*
					onSSpisok: function(strSpisok) {
						//cppqml.strUchastokNazvanie = strSpisok;//Присваиваем к свойству Q_PROPERTY
						pgStrSostav.text = strSpisok;//Задаём заголовок на второй странице.
						stvStr.push(pgStrSostav);
					}
*/
				}

			}
		}
		Stranica {//Страница Состава Списка
			id: pgStrSostav
			visible: false

			ntWidth: root.ntWidth
			ntCoff: root.ntCoff

			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: "indigo"

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
			Connections {//Соединяем сигнал из C++ с действием в QML
				target: cppqml//Цель объект класса С++ DCCppQml
				function onStrSpisokChanged() {//Функция сигнал, которая создалась в QML (on) для сигнала C++
					//pgStrSostav.text = cppqml.strSpisok//Пишем текст заголовка из Свойтва Q_PROPERTY
				}
			}
		}
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
