import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
	id: tmKnopkaOriginal
	property int ntHeight: 8
	property int ntCoff: 8
	property alias text: txtKnopkaOriginal.text
	property alias bold: txtKnopkaOriginal.font.bold
	property alias italic: txtKnopkaOriginal.font.italic
	property alias pixelSize: txtKnopkaOriginal.font.pixelSize
	property color clrKnopki: "transparent"
	property color clrTexta: "black"

	height: ntHeight*ntCoff
	//Длина кнопки расчитывается автоматически в слоте onCompleted в конце файла.

	signal clicked();

	Rectangle {
		id: rctKnopkaOriginal
		anchors.fill: tmKnopkaOriginal

		color: maKnopkaOriginal.containsPress ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		radius: height/2
		smooth: true//Сглаживание.
		border.color: Qt.darker(clrKnopki, 1.3)//Граница чуть темнее цвета кнопки
		border.width: 1//Толщина граници кнопки один пиксель
		clip: true//Всё, что будет внутри прямоугольника и будет выходить за границы обрезается.

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
			}
		}
	}
	Component.onCompleted: {//Слот обрабатывает данные, когда сомпонет полностью отрисовался.
		//Императивное присвоение значения, так как тут используется JS, нужно присваивать через знак "=".
		tmKnopkaOriginal.width = txtKnopkaOriginal.text.length*tmKnopkaOriginal.height;//Расчёт длины строки.
	}
}
