import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item{
    id: root
    //Свойства.
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrKnopki: "grey"
	property color clrTexta: "yellow"
    property bool enabled: true//true - активирована, false - деактивированна кнопка.
    property alias text: txtKnopkaKruglaya.text
	property alias bold: txtKnopkaKruglaya.font.bold
	property alias italic: txtKnopkaKruglaya.font.italic
	property alias pixelSize: txtKnopkaKruglaya.font.pixelSize
    property real tapHeight: ntWidth*ntCoff//Высота зоны нажатия пальцем или мышкой
    property real tapWidth: ntWidth*ntCoff//Ширина зоны нажатия пальцем или мышкой
    //Настройки.
    height: tapHeight
    width: tapWidth
    //Сигналы.
	signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
        id: tphKnopkaKruglaya
        onTapped: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    /*
    MouseArea{
        id: maKnopkaKruglaya
        anchors.fill: root
        onClicked: {
            if(root.enabled)//Если активирована кнопка, то...
                root.clicked();//Обрабатываем клик.
        }
    }
    */
    Rectangle{
		id: rctKnopkaKruglaya
        height: root.ntWidth*root.ntCoff
        width: height
        anchors.centerIn: root

        color: {
            if(root.enabled)//Если активирована кнопка, то...
                tphKnopkaKruglaya.pressed ?  Qt.darker(clrKnopki, 1.3) : clrKnopki
            else//Если деактивирована кнопка, то...
                Qt.darker(clrKnopki, 0.8)
        }
        /*
        color: {
            if(root.enabled)//Если активирована кнопка, то...
                 maKnopkaKruglaya.containsPress ?  Qt.darker(clrKnopki, 1.3) : clrKnopki
            else//Если деактивирована кнопка, то...
                Qt.darker(clrKnopki, 0.8)
        }
        */
        border.width: 1//Толщина границы круга 1
        radius: width/2//Радиус половина ширины, это круг
        smooth: true//сглаживание круглой кнопки
		clip: true//Всё, что внутри треугольника и выходит за его границы обрезается.

		Text{
			id: txtKnopkaKruglaya
            anchors.centerIn: rctKnopkaKruglaya

            color: {
                if(root.enabled)//Если активирована кнопка, то...
                    tphKnopkaKruglaya.pressed ? Qt.darker(clrTexta, 1.3) : clrTexta
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrTexta, 0.8)
            }
            /*
            color: {
                if(root.enabled)//Если активирована кнопка, то...
                     maKnopkaKruglaya.containsPress ? Qt.darker(clrTexta, 1.3) : clrTexta
                else//Если деактивирована кнопка, то...
                    Qt.darker(clrTexta, 0.8)
            }
            */
			text: "Кнопка"
			font.bold: false//Не жирный текст
			font.italic: false//Не курсивный текст
			font.pixelSize: rctKnopkaKruglaya.width/text.length//Расчёт размера шрифта
		}	
	}
}
