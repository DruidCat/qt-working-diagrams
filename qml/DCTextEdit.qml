import QtQuick 2.14
import QtQuick.Window 2.14
//DCTextEdit - ШАБЛОН РАБОТЫ С ТЕКСТОМ НА СТРАНИЦЕ (ЛИСТАТЬ, РЕДАКТИРОВАТЬ, ВЫДЕЛЯТЬ).
Item {
    id: tmTextEdit
    property alias text: txdTextEdit.text //Текст
    property alias readOnly: txdTextEdit.readOnly//читать Только текст. (false - можно изменять)
	property alias textEdit: txdTextEdit//Передаём в виде свойства весь объект TextEdit
    property alias radius: rctTextEdit.radius//Радиус рабочей зоны
    property alias clrFona: rctTextEdit.color //цвет фона текста
    property alias clrTexta: txdTextEdit.color //цвет текста
    property color clrBorder: "transparent"//Цвет границы области текста.
    property alias bold: txdTextEdit.font.bold//Жирный текст.
    property alias italic: txdTextEdit.font.italic//Наклонный текст.
    property int  ntWidth: 2
    property int ntCoff: 8
    anchors.fill: parent//Растягиваем область по родителю.

    function fnCvetGranici(){//Функция выставляющая цвет границы в зависимости от параметра readOnly.
        if(tmTextEdit.readOnly)//Если толькоЧтение истина, то...
            rctTextEdit.border.color = "transparent";//То граница прозрачная.
        else//Если режим редактирования, то...
            rctTextEdit.border.color = clrBorder;//То выставляем цвет из настройки property
    }

    onReadOnlyChanged: {//Слот изменения property readOnly, автоматический создаётся от сигнала (on...Changed)
        fnCvetGranici();//Функция выставляющая цвет границы в зависимости от параметра readOnly.
	}

    Rectangle {
        id: rctTextEdit
        anchors.fill: tmTextEdit
		color: "transparent"//Цвет фона прозрачный.
		border.color: tmTextEdit.clrBorder
		border.width: tmTextEdit.ntCoff/2
        Flickable {//Перелистывание
            id: flcListat
            anchors.fill: rctTextEdit
            anchors.margins: tmTextEdit.ntCoff//Отступ, чтоб текст не налазил на бардюр.
            contentWidth: txdTextEdit.paintedWidth//Общая длина листания = длине всего текста
            contentHeight: txdTextEdit.paintedHeight//Общая высота листания = высоте всего текста
            interactive: true//Перелистывание активировать.
            clip: true//Обрезаем всё, что выходит за границы этого элемента.
            function fnEnsureVisible(r){//Функция расчитывающая видимость, она из Qt документации
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }
            TextEdit {//Область текста.
                id: txdTextEdit
                width: flcListat.width//Передаём ширину из зоны прокрутки, нельзя через якорь.
                height: flcListat.height//Передаём высоту из зоны прокрутки, нельзя через якорь.
                color: "black"//цвет текста
                text: ""
                font.pixelSize: tmTextEdit.ntWidth*tmTextEdit.ntCoff//размер шрифта текста.
                wrapMode: TextEdit.Wrap//Текст в конце строки переносим на новую строку.
                readOnly: true
                focus: true//Фокус на TextEdit
                selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
                onCursorRectangleChanged: flcListat.fnEnsureVisible(cursorRectangle)
            }
        }
    }

    Component.onCompleted: {//Вызывается при завершении иннициализации компонента, выставляется цвет границы.
        fnCvetGranici();//Функция выставляющая цвет границы в зависимости от параметра readOnly.
    }
}
