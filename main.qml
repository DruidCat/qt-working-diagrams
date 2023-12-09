import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
	id: wndRoot
    width: 380
    height: 640
	visible: true
	color: "lightblue"
	title: qsTr("Моя Лаборатория Qml")
	function fncFonCvet(){
		wndRoot.color = Qt.rgba(Math.random(), Math.random(), Math.random());
	}

    property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopok: "orange"
	property color clrFona: "grey"

	StackView {
		id: stvStr
		anchors.fill: parent
		initialItem: pgStrGlavnaya

		DCStr {//Главная страница
			id: pgStrGlavnaya
			visible: true

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "black"

			text: "ТМК"

			DCKnopkaMenu {
				ntWidth: pgStrGlavnaya.ntWidth
				ntCoff: pgStrGlavnaya.ntCoff
				clrKnopki: clrKnopok
				x: pgStrGlavnaya.rctStrZagolovok.x+ntCoff/2
				y: pgStrGlavnaya.rctStrZagolovok.y+ntCoff/2

				onSKnopkaMenuClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
					stvStr.push(pgStrMenu)
				}
			}

			DCLogoTMK {//Логотип
				ntCoff: 16
				clrLogo: wndRoot.clrKnopok
				anchors.centerIn: parent
			}
		}

		DCStr {//Меню
			id: pgStrMenu
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "indigo"

			text: "МЕНЮ"

			DCStrelkaNazad {
				ntWidth: pgStrMenu.ntWidth
				ntCoff: pgStrMenu.ntCoff
				clrKnopki: clrKnopok
				x: pgStrMenu.rctStrZagolovok.x+ntCoff/2
				y: pgStrMenu.rctStrZagolovok.y+ntCoff/2

				onSStrelkaNazadCliked: {
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
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "SlateGray"

			DCStrelkaNazad {
				ntWidth: pgStrVtoraya.ntWidth
				ntCoff: pgStrVtoraya.ntCoff
				clrKnopki: clrKnopok
				x: pgStrVtoraya.rctStrZagolovok.x+ntCoff/2
				y: pgStrVtoraya.rctStrZagolovok.y+ntCoff/2

				onSStrelkaNazadCliked: {
					stvStr.pop()//Назад страницу
				}
			}
		}

		DCStr {//Третья страница
			id: pgStrTretiya
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "MidnightBlue"

			DCStrelkaNazad {
				ntWidth: pgStrTretiya.ntWidth
				ntCoff: pgStrTretiya.ntCoff
				clrKnopki: clrKnopok
				x: pgStrTretiya.rctStrZagolovok.x+ntCoff/2
				y: pgStrTretiya.rctStrZagolovok.y+ntCoff/2

				onSStrelkaNazadCliked: {
					stvStr.pop()//Назад страницу
				}
			}
		}
	}
}
