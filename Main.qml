import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

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
						cppqml.slotTest();
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
						console.log(strUchastok);
                        cppqml.setStrUchastokNazvanie(strUchastok);
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

            text: cppqml.strUchastokNazvanie

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
