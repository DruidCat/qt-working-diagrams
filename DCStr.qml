import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
//TODO Сделать так, чтоб при уменьшении экрана или большого текста, размер шрифта уменьшался.
//TODO Сделать так, чтоб текст не накладывался на Иконки.
//TODO Нарисовать иконку поиска.
//TODO Выделить область под иконку в заголовке
//TODO Создать свойство для рабочей области
Page {
	id: pgStr
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrFona: "grey"
	property color clrKnopok: "grey"
	property color clrRabOblasti: "lightblue"
	property alias text:  txtStrZagolovok.text
	property alias rctStrZagolovok: rctStrZagolovok

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
					id: tmKnopka
					height: rctStrZagolovok.height
					width: height
					anchors.top: rctStrZagolovok.top
					anchors.left: rctStrZagolovok.left
				}

				Rectangle {
					id: rctStrZagolovokText
					width: rctStrZagolovok.width-2*rctStrZagolovok.height
					height: rctStrZagolovok.height
					color: "transparent"

					anchors.left: tmKnopka.right
					anchors.top: rctStrZagolovok.top

					Text {
						id: txtStrZagolovok
						anchors.centerIn: rctStrZagolovokText
						color: pgStr.clrKnopok

						font.pixelSize: rctStrZagolovok.height-pgStr.ntCoff
						font.bold: true

						text: ""
					}
				}
			}

			Rectangle {
				id: rctStrZona
				width: rctStr.width
				//height: Тут бы по уму минимально возможное значение высоты сделать, чтоб всё отображалось
				color: clrRabOblasti
				anchors.top: rctStrZagolovok.bottom
				anchors.left: rctStr.left
				anchors.right: rctStr.right
				anchors.bottom: rctStr.bottom
				anchors.margins: ntCoff
				radius: (width/(ntWidth*ntCoff))/ntCoff
			}
		}
	}

}
