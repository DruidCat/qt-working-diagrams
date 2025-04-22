import QtQuick //2.15

Item{
    id: root
    //Свойства.
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrTexta: "yellow"
	property alias text: txtKnopkaKruglaya.text
	property alias bold: txtKnopkaKruglaya.font.bold
	property alias italic: txtKnopkaKruglaya.font.italic
	property alias pixelSize: txtKnopkaKruglaya.font.pixelSize
    //Настройки.
	width:  ntWidth*ntCoff
	height: width
    //Сигналы.
	signal clicked();
    //Функции.
	Rectangle{
		id: rctKnopkaKruglaya
		color: maKnopkaKruglaya.containsPress ?  Qt.darker(clrKnopki, 1.3) : clrKnopki
        anchors.fill: root

		radius: width/2//Радиус половина ширины, это круг
		border.color: Qt.darker(clrKnopki, 1.3)//Граница круга темнее
		border.width: 1//Толщина границы круга 1
		smooth: true//сглаживание круглой кнопки
		clip: true//Всё, что внутри треугольника и выходит за его границы обрезается.

		Text{
			id: txtKnopkaKruglaya
			color: maKnopkaKruglaya.containsPress ? Qt.darker(clrTexta, 1.3) : clrTexta
			anchors.centerIn: rctKnopkaKruglaya

			text: "Кнопка"
			font.bold: false//Не жирный текст
			font.italic: false//Не курсивный текст
			font.pixelSize: rctKnopkaKruglaya.width/text.length//Расчёт размера шрифта
		}

		MouseArea{
			id: maKnopkaKruglaya
			anchors.fill: rctKnopkaKruglaya
			onClicked: {
                root.clicked();
			}
		}
	}
}
