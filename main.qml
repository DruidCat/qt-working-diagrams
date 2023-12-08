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
		initialItem: dcStrGlavnaya

		DCStrStrelkaNazad {//Меню
			id: pgStrMenu
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "indigo"

			text: "МЕНЮ"

			onSStrelkaNazadCliked: {
				stvStr.pop()//Назад страницу
			}
		}

		DCStrMenu {//Главная страница
			id: dcStrGlavnaya
			visible: true

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "black"

			text: "ТМК"

            DCLogoTMK {
                id: dcLogoTMK
                ntCoff: 12

                anchors.centerIn: parent
            }

			onSKnopkaMenuCliked: {//Если пришёл сигнал из компонента о нажатии кнопки меню, то...
				stvStr.push(pgStrMenu)
			}
		}

		DCStrStrelkaNazad {//Вторая страница
			id: pgStrVtoraya
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "purple"

			onSStrelkaNazadCliked: {
				stvStr.pop()
			}
		}

		DCStrStrelkaNazad {//Третья страница
			id: pgStrTretiya
			visible: false

			ntWidth: wndRoot.ntWidth
			ntCoff: wndRoot.ntCoff

			clrFona: wndRoot.clrFona
			clrKnopok: wndRoot.clrKnopok
			clrRabOblasti: "lightblue"

			onSStrelkaNazadCliked: {
				stvStr.pop()
			}
		}
	}
}
