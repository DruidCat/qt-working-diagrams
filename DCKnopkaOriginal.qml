import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
	id: tmKnopkaOriginal
	property int ntHeight: 8
	property int ntWidth: ntHeight*6
	property int ntCoff: 8
	property alias text: txtKnopkaOriginal.text
	property alias bold: txtKnopkaOriginal.font.bold
	property alias italic: txtKnopkaOriginal.font.italic
	property alias pixelSize: txtKnopkaOriginal.font.pixelSize
	property color clrKnopki: "transparent"
	property color clrTexta: "black"

	height: ntHeight*ntCoff
	width: ntWidth*ntCoff

	signal clicked();

	Rectangle {
		id: rctKnopkaOriginal
		color: maKnopkaOriginal.containsPress ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		radius: height/2
		smooth: true//Сглаживание.
		border.color: Qt.darker(clrKnopki, 1.3)//Окантовка чуть темнее цвета кнопки
		border.width: 1//Толщина окантовки один пиксель
		clip: true//Всё, что будет внутри прямоугольника и будет выходить за границы обрезается.

		anchors.fill: tmKnopkaOriginal

		Text {
			id: txtKnopkaOriginal
			anchors.centerIn: rctKnopkaOriginal
			color: maKnopkaOriginal.containsPress ? Qt.darker(clrTexta, 1.3) : clrTexta

			text: "Кнопка"
			font.pixelSize:  (rctKnopkaOriginal.width/text.length>=rctKnopkaOriginal.height)
							 ? rctKnopkaOriginal.height : rctKnopkaOriginal.width/text.length
			font.bold: false//Не жирный текст
			font.italic: false//Не курсивный текст
		}
		MouseArea {
			id: maKnopkaOriginal
			anchors.fill: rctKnopkaOriginal

			onClicked: {
				tmKnopkaOriginal.clicked();
				//console.debug(txtKnopkaOriginal.font.pixelSize)
			}
		}
	}
}
