﻿import QtQuick 2.12
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

	property var vrUchastki: [
		{
			nomer: 1,
			uchastok: "Форомовка",
			opisanie: "Участок формовки и всё такое."

		},
		{
			nomer: 2,
			uchastok: "Сварк а",
			opisanie: "Участок сварки и всё такое."

		},
		{
			nomer: 3,
			uchastok: "Отделка",
			opisanie: "Участок отделки и всё такое."

		}
	]

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
				}
			}
			Item {
				id: tmGlavnayaZona
				x: pgStrGlavnaya.rctStrZona.x
				y: pgStrGlavnaya.rctStrZona.y
				width: pgStrGlavnaya.rctStrZona.width
				height: pgStrGlavnaya.rctStrZona.height
				ListView {
					id: lsvGlavnayaZona
					anchors.fill: tmGlavnayaZona
					anchors.margins: wndRoot.ntCoff
					model: vrUchastki
					spacing: wndRoot.ntCoff
					delegate: Rectangle {
						id: rctUchastki
						width: lsvGlavnayaZona.width
						height: wndRoot.ntWidth*wndRoot.ntCoff+wndRoot.ntCoff
						color: "grey"
						radius: (width/(wndRoot.ntWidth*wndRoot.ntCoff))/wndRoot.ntCoff
						Text {
							color: wndRoot.clrKnopok
							anchors.left: rctUchastki.left
							anchors.verticalCenter: rctUchastki.verticalCenter
							text: modelData.uchastok
						}

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

			DCStrelkaNazad {
				ntWidth: pgStrMenu.ntWidth
				ntCoff: pgStrMenu.ntCoff
				clrKnopki: wndRoot.clrKnopok
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
			clrTexta: wndRoot.clrKnopok
            clrRabOblasti: "indigo"

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
			clrTexta: wndRoot.clrKnopok
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
