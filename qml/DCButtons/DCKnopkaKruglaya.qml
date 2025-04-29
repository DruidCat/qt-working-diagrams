import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

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
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaKruglaya
            onTapped: root.clicked()
    }
    /*
    MouseArea{
        id: maKnopkaKruglaya
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle{
		id: rctKnopkaKruglaya
        anchors.fill: root

        color: tphKnopkaKruglaya.pressed ?  Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaKruglaya.containsPress ?  Qt.darker(clrKnopki, 1.3) : clrKnopki
        border.width: 1//Толщина границы круга 1
        radius: width/2//Радиус половина ширины, это круг
        smooth: true//сглаживание круглой кнопки
		clip: true//Всё, что внутри треугольника и выходит за его границы обрезается.

		Text{
			id: txtKnopkaKruglaya
            anchors.centerIn: rctKnopkaKruglaya

            color: tphKnopkaKruglaya.pressed ? Qt.darker(clrTexta, 1.3) : clrTexta
            //color: maKnopkaKruglaya.containsPress ? Qt.darker(clrTexta, 1.3) : clrTexta

			text: "Кнопка"
			font.bold: false//Не жирный текст
			font.italic: false//Не курсивный текст
			font.pixelSize: rctKnopkaKruglaya.width/text.length//Расчёт размера шрифта
		}	
	}
}
