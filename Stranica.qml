import QtQuick
import QtQuick.Window
import QtQuick.Controls

Page {
	id: pgStr
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrFona: "transparent"
	property color clrTexta: "grey"
	property color clrRabOblasti: "lightblue"
	property alias text:  txtStrZagolovok.text
	property alias rctStrZagolovok: rctStrZagolovok
	property alias rctStrZona: rctStrZona
	property alias rctStrToolbar: rctStrToolbar

	Item{
		id: tmStr
		anchors.fill: parent

		Rectangle{
			id: rctStr
			anchors.fill: tmStr
			color: clrFona

			Rectangle {
				id: rctStrZagolovok
				width: rctStr.width
				height: ntWidth*ntCoff+ntCoff
				color: clrRabOblasti
				anchors.top: rctStr.top
				anchors.left: rctStr.left
				anchors.right: rctStr.right
                anchors.margins: ntCoff
				radius: (width/(ntWidth*ntCoff))/ntCoff

				Item {//Этот элемент невидимой кнопки, чтоб от неё отпозиционировался текст.
                    id: tmKnopkaCleva
					height: rctStrZagolovok.height
					width: height
					anchors.top: rctStrZagolovok.top
                    anchors.left: rctStrZagolovok.left
                    anchors.bottom: rctStrZagolovok.bottom
				}

				Rectangle {
					id: rctStrZagolovokText
                    width: rctStrZagolovok.width-2*tmKnopkaCleva.width
                    height: rctStrZagolovok.height-pgStr.ntCoff
					color: "transparent"

                    anchors.left: tmKnopkaCleva.right
                    anchors.verticalCenter: rctStrZagolovok.verticalCenter

					Text {
						id: txtStrZagolovok
						anchors.centerIn: rctStrZagolovokText
						color: pgStr.clrTexta

						text: ""
                        font.bold: true
						font.pixelSize: (rctStrZagolovokText.width/text.length>=rctStrZagolovokText.height)
										? rctStrZagolovokText.height : rctStrZagolovokText.width/text.length
					}
				}

                Item {//Этот элемент невидимой кнопки, чтоб от неё отпозиционировался текст.
                    id: tmKnopkaCprava
                    height: rctStrZagolovok.height
                    width: height
                    anchors.top: rctStrZagolovok.top
                    anchors.left: rctStrZagolovokText.right
                    anchors.right: rctStrZagolovok.right
                    anchors.bottom: rctStrZagolovok.bottom
                }
			}
			Rectangle {
				id: rctStrZona
				width: rctStr.width
				//height: Тут бы по уму минимально возможное значение высоты сделать, чтоб всё отображалось
				anchors.top: rctStrZagolovok.bottom
				anchors.left: rctStr.left
				anchors.right: rctStr.right
				anchors.bottom: rctStrToolbar.top
				anchors.margins: ntCoff

				radius: (width/(ntWidth*ntCoff))/ntCoff
				color: clrRabOblasti
			}
			Rectangle {
				id: rctStrToolbar
				width: rctStr.width
				height: pgStr.ntWidth*pgStr.ntCoff+pgStr.ntCoff

				anchors.top: anchors.rctStrZona
				anchors.left: rctStr.left
				anchors.right: rctStr.right
				anchors.bottom: rctStr.bottom
				anchors.margins: pgStr.ntCoff

				color: clrRabOblasti
				border.color: Qt.darker(clrRabOblasti, 1.3)
				border.width: pgStr.ntCoff/4
			}
		}
	}
}
