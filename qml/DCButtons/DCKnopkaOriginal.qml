import QtQuick //2.15
//import QtQuick.Handlers//Не требуется в Qt 6.2+

Item {
    id: root
    //Свойства.
	property int ntHeight: 16
	property alias text: txtKnopkaOriginal.text
	property alias bold: txtKnopkaOriginal.font.bold
	property alias italic: txtKnopkaOriginal.font.italic
	property alias pixelSize: txtKnopkaOriginal.font.pixelSize
	property color clrKnopki: "transparent"
	property color clrTexta: "black"
    //Настройки.
	height: ntHeight
	//Длина кнопки расчитывается автоматически в слоте onCompleted в конце файла.
    //Сигналы.
	signal clicked();
    //Функции.
    //Для Авроры комментируем TapHandler, расскомментируем MouseArea и наоборот.
    TapHandler {//Обработка нажатия, замена MouseArea с Qt5.10
            id: tphKnopkaOriginal
            onTapped: root.clicked()
    }
    /*
    MouseArea {
        id: maKnopkaOriginal
        anchors.fill: root
        onClicked: root.clicked()
    }
    */
    Rectangle {
		id: rctKnopkaOriginal
        anchors.fill: root

        color: tphKnopkaOriginal.pressed ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        //color: maKnopkaOriginal.containsPress ? Qt.darker(clrKnopki, 1.3) : clrKnopki
        radius: height/4
		smooth: true//Сглаживание.
		border.color: Qt.darker(clrKnopki, 1.3)//Граница чуть темнее цвета кнопки
        border.width: 1//Толщина граници кнопки один пиксель
		clip: true//Всё, что будет внутри прямоугольника и будет выходить за границы обрезается.

		Text {
			id: txtKnopkaOriginal
			anchors.centerIn: rctKnopkaOriginal

            color: tphKnopkaOriginal.pressed ? Qt.darker(clrTexta, 1.3) : clrTexta
            //color: maKnopkaOriginal.containsPress ? Qt.darker(clrTexta, 1.3) : clrTexta
            text: "Кнопка"
			//Размер шрифта расчитывается в слоте onCompleted
			font.pixelSize: ((rctKnopkaOriginal.width/txtKnopkaOriginal.text.length>=rctKnopkaOriginal.height)
				 ? rctKnopkaOriginal.height : rctKnopkaOriginal.width/txtKnopkaOriginal.text.length)-8
			font.bold: false//Не жирный текст
			font.italic: false//Не курсивный текст
		}	
	}
	Component.onCompleted: {//Слот обрабатывает данные, когда сомпонет полностью отрисовался.
		//Императивное присвоение значения, так как тут используется JS, нужно присваивать через знак "=".
        root.width = txtKnopkaOriginal.text.length*root.ntHeight;//Расчёт длины строки.
	}
}
