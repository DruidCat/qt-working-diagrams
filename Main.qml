import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
	id: wndRoot
    width: 380
    height: 640
	visible: true
	color: "grey"
	title: qsTr("Электрические схемы предприятия.")

    property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopok: "orange"
	property color clrFona: "grey"

	function fcPolUchastokNazvanie() {
		return cppqml.getUchastokNazvanie();
	}

	StackView {
		id: stvStr
		anchors.fill: parent
		initialItem: pgStrGlavnaya

		DCStr {//Главная страница
			id: pgStrGlavnaya
			visible: true

			property color clrStranici: "black"
			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrTexta: wndRoot.clrKnopok
			clrRabOblasti: clrStranici

			text: "ТМК"

			Item {
				id: tmGlavnayaZagolovok
				x: pgStrGlavnaya.rctStrZagolovok.x
				y: pgStrGlavnaya.rctStrZagolovok.y
				width: pgStrGlavnaya.rctStrZagolovok.width
				height: pgStrGlavnaya.rctStrZagolovok.height

				DCKnopkaMenu {
					ntWidth: pgStrGlavnaya.ntWidth
					ntCoff: pgStrGlavnaya.ntCoff
					clrKnopki: clrKnopok
					clrFona: pgStrGlavnaya.clrStranici

					anchors.verticalCenter: tmGlavnayaZagolovok.verticalCenter
					anchors.left: tmGlavnayaZagolovok.left
					anchors.margins: wndRoot.ntCoff/2
					onSKnopkaMenuClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
						stvStr.push(pgStrMenu)
					}
				}

				DCKnopkaPoisk {
					ntWidth: wndRoot.ntWidth
					ntCoff: wndRoot.ntCoff
					clrKnopki: wndRoot.clrKnopok
					clrFona: pgStrGlavnaya.clrStranici
					anchors.verticalCenter: tmGlavnayaZagolovok.verticalCenter
					anchors.right: tmGlavnayaZagolovok.right
					anchors.margins: wndRoot.ntCoff/2
					onSKnopkaPoiskClicked: {
						//cppqml.slotTest();
						console.log(cppqml.strUchastokNazvanie)
						Qt.quit();
					}
				}
			}
			Item {
				id: tmGlavnayaZona
				x: pgStrGlavnaya.rctStrZona.x
				y: pgStrGlavnaya.rctStrZona.y
				width: pgStrGlavnaya.rctStrZona.width
				height: pgStrGlavnaya.rctStrZona.height

				DCZonaGlavnaya {
					id: lsvZonaGlavnaya
					ntWidth: wndRoot.ntWidth
					ntCoff: wndRoot.ntCoff
					clrTexta: wndRoot.clrKnopok
					clrFona: "SlateGray"
					anchors.fill: tmGlavnayaZona
					onSUchastki: function(strUchastok) {
						//cppqml.strUchastokNazvanie = strUchastok;//Присваиваем к свойству Q_PROPERTY
						pgStrVtoraya.text = strUchastok;//Задаём заголовок на второй странице.
						stvStr.push(pgStrVtoraya);
					}
				}

				DCLogoTMK {//Логотип
					ntCoff: 16
					clrLogo: wndRoot.clrKnopok
					clrFona: pgStrGlavnaya.clrStranici
					anchors.centerIn: parent
				}
			}
		}

		DCStr {//Меню
			id: pgStrMenu
			visible: false
			property color clrStranici: "darkslategray"

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrTexta: wndRoot.clrKnopok
			clrRabOblasti: clrStranici

			text: "МЕНЮ"

			DCKnopkaNazad {
				ntWidth: pgStrMenu.ntWidth
				ntCoff: pgStrMenu.ntCoff
				clrKnopki: wndRoot.clrKnopok
				x: pgStrMenu.rctStrZagolovok.x+ntCoff/2
				y: pgStrMenu.rctStrZagolovok.y+ntCoff/2

				onSKnopkaNazadCliked: {
					stvStr.pop()//Назад страницу
				}
			}
		}

		DCStr {//Вторая страница
			id: pgStrVtoraya
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrTexta: wndRoot.clrKnopok
            clrRabOblasti: "indigo"

			DCKnopkaNazad {
				ntWidth: pgStrVtoraya.ntWidth
				ntCoff: pgStrVtoraya.ntCoff
				clrKnopki: clrKnopok
				x: pgStrVtoraya.rctStrZagolovok.x+ntCoff/2
                y: pgStrVtoraya.rctStrZagolovok.y+ntCoff/2

				onSKnopkaNazadCliked: {
					stvStr.pop()//Назад страницу
				}
			}

			Connections {//Соединяем сигнал из C++ с действием в QML
				target: cppqml//Цель объект класса С++ DCCppQml
				function onStrUchastokNazvanieChanged() {//Функция сигнал, которая создалась в QML (on) для сигнала C++
					//pgStrVtoraya.text = cppqml.strUchastokNazvanie//Пишем текст заголовка из Свойтва Q_PROPERTY
				}
			}
		}

		DCStr {//Третья страница
			id: pgStrTretiya
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrTexta: wndRoot.clrKnopok
			clrRabOblasti: "MidnightBlue"

			DCKnopkaNazad {
				ntWidth: pgStrTretiya.ntWidth
				ntCoff: pgStrTretiya.ntCoff
				clrKnopki: clrKnopok
				x: pgStrTretiya.rctStrZagolovok.x+ntCoff/2
				y: pgStrTretiya.rctStrZagolovok.y+ntCoff/2

				onSKnopkaNazadCliked: {
					stvStr.pop()//Назад страницу
				}
			}
		}
	}
}
