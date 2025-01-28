import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//СТРАНИЦА - шаблон страницы программы с Заголовком, Зоной и Тулбаром.
Page {
	id: pgStr
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrFona: "transparent"
	property color clrTexta: "grey"
	property color clrRabOblasti: "lightblue"
	property alias textZagolovok:  txtStrZagolovok.text
	property alias textToolbar: txtStrToolbar.text
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
				anchors.top: rctStr.top
				anchors.left: rctStr.left
				anchors.right: rctStr.right
                anchors.margins: ntCoff
				color: clrRabOblasti
				radius: (width/(ntWidth*ntCoff))/ntCoff
				Item {//Этот элемент невидимой кнопки, чтоб от неё отпозиционировался текст.
                    id: tmZagolovokKnopkaCleva
					height: rctStrZagolovok.height
					width: height
					anchors.top: rctStrZagolovok.top
                    anchors.left: rctStrZagolovok.left
                    anchors.bottom: rctStrZagolovok.bottom
				}
				Rectangle {
                    id: rctStrZagolovokText
                    width: rctStrZagolovok.width-2*tmZagolovokKnopkaCleva.width
                    height: rctStrZagolovok.height-pgStr.ntCoff
                    anchors.left: tmZagolovokKnopkaCleva.right
                    anchors.verticalCenter: rctStrZagolovok.verticalCenter
					color: "transparent"
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
                    id: tmZagolovokKnopkaCprava
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
				anchors.left: rctStr.left
				anchors.right: rctStr.right
				anchors.bottom: rctStr.bottom
				anchors.margins: pgStr.ntCoff
				color: clrRabOblasti
				border.color: Qt.darker(clrRabOblasti, 1.3)
				border.width: pgStr.ntCoff/4
				Item {//Этот элемент невидимой кнопки, чтоб от неё отпозиционировался текст.
                    id: tmToolbarKnopkaCleva
					height: rctStrToolbar.height
					width: height
					anchors.top: rctStrToolbar.top
                    anchors.left: rctStrToolbar.left
                    anchors.bottom: rctStrToolbar.bottom
				}
				Rectangle {
                    id: rctStrToolbarText
                    width: rctStrToolbar.width-2*tmToolbarKnopkaCleva.width
                    height: rctStrToolbar.height-pgStr.ntCoff
                    anchors.left: tmToolbarKnopkaCleva.right
                    anchors.verticalCenter: rctStrToolbar.verticalCenter
					color: "transparent"
					Text {
                        id: txtStrToolbar
						anchors.centerIn: rctStrToolbarText
						color: pgStr.clrTexta
						text: ""
						font.pixelSize: (rctStrToolbarText.width/text.length>=rctStrToolbarText.height)
										? rctStrToolbarText.height : rctStrToolbarText.width/text.length
					}
				}
                Item {//Этот элемент невидимой кнопки, чтоб от неё отпозиционировался текст.
                    id: tmToolbarKnopkaCprava
                    height: rctStrToolbar.height
                    width: height
                    anchors.top: rctStrToolbar.top
                    anchors.left: rctStrToolbarText.right
                    anchors.right: rctStrToolbar.right
                    anchors.bottom: rctStrToolbar.bottom
                }
				Connections {//Соединяем сигнал из C++ с действием в QML
					target: cppqml;//Цель объект класса С++ DCCppQml
					function onStrDebugChanged(){//Функция сигнал,которая создалась в QML(on) для сигнала C++
						txtStrToolbar.text = cppqml.strDebug;//Пишем текст в Тулбар из Свойтва Q_PROPERTY
					}
				}
			}
		}
	}
}
