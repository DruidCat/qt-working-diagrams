﻿import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Page{
	id: pgStrMenu
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrFona: "grey"
	property color clrKnopok: "grey"
	property color clrRabOblasti: "lightblue"

	signal sKnopkaMenuCliked();//Сигнал нажатия кнопки Меню.

	Item{
		id: tmStr
		anchors.fill: parent

		Rectangle{
			id: rctStr
			anchors.fill: tmStr
			color: clrFona

			Rectangle {
				id: rctStrZagolovok
                width: ntWidth
                height: ntWidth*ntCoff+ntCoff
                color: clrRabOblasti
				anchors.top: rctStr.top
				anchors.left: rctStr.left
				anchors.right: rctStr.right
                anchors.margins: ntCoff
                radius: (width/(ntWidth*ntCoff))/ntCoff

				DCKnopkaMenu {
					id: dcKnopkaMenu
                    ntWidth: pgStrMenu.ntWidth
                    ntCoff: pgStrMenu.ntCoff
                    clrKnopki: pgStrMenu.clrKnopok
					anchors.verticalCenter: rctStrZagolovok.verticalCenter
					anchors.left: rctStrZagolovok.left
                    anchors.leftMargin: pgStrMenu.ntCoff/2

					onSKnopkaMenuClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
						pgStrMenu.sKnopkaMenuCliked();//Отправляем сигнил из компонента, что она нажата.
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
