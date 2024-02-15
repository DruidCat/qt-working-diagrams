import QtQuick
import QtQuick.Window

import "qrc:/js/DCFunkciiJS.js" as JSMenu

Item {
	id: tmMenu
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
	signal clicked(int ntNomer, var strMenu)
	height:3*(ntWidth*ntCoff+ntCoff)+ntCoff
	ListView {
		id: lsvMenu
		Component {
			id: cmpMenu
			Rectangle {
				id: rctMenu
				width: lsvMenu.width
				height: tmMenu.ntWidth*tmMenu.ntCoff+tmMenu.ntCoff
				radius: (width/(tmMenu.ntWidth*tmMenu.ntCoff))/tmMenu.ntCoff
				border.width: 1
				border.color: Qt.darker(tmMenu.clrFona, 1.3)
				color: maMenu.containsPress
					   ? Qt.darker(tmMenu.clrFona, 1.3) : tmMenu.clrFona
				Text {
					color: maMenu.containsPress
						   ? Qt.darker(tmMenu.clrTexta, 1.3) : tmMenu.clrTexta
					anchors.horizontalCenter: rctMenu.horizontalCenter
					anchors.verticalCenter: rctMenu.verticalCenter
					text: modelData.menu
					font.pixelSize: (rctMenu.width/text.length>=rctMenu.height)
					? rctMenu.height-tmMenu.ntCoff
					: rctMenu.width/text.length-tmMenu.ntCoff
				}
				MouseArea {
					id: maMenu
					anchors.fill: rctMenu
					onClicked: {
						tmMenu.clicked(modelData.nomer, modelData.menu)
					}
				}
			}
		}
		anchors.fill: tmMenu
		anchors.topMargin:tmMenu.ntCoff
		anchors.bottomMargin:tmMenu.ntCoff
		anchors.leftMargin:tmMenu.ntCoff/2
		anchors.rightMargin:tmMenu.width/2
		opacity: 0.7//Прозрачность.
		interactive: false//Запретить листать.
		model: JSMenu.vrMenuSpisok
		delegate: cmpMenu
	}
}
