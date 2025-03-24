import QtQuick //2.14
//import QtQuick.Window //2.14
//DCTextEdit - ШАБЛОН РАБОТЫ С ТЕКСТОМ НА СТРАНИЦЕ (ЛИСТАТЬ, РЕДАКТИРОВАТЬ, ВЫДЕЛЯТЬ).
Item {
    id: root
    property alias text: txdTextEdit.text //Текст
    property alias readOnly: txdTextEdit.readOnly//читать Только текст. (false - можно изменять)
	property alias textEdit: txdTextEdit//Передаём в виде свойства весь объект TextEdit
    property alias radius: rctTextEdit.radius//Радиус рабочей зоны
    property alias clrFona: rctTextEdit.color //цвет фона текста
    property alias clrTexta: txdTextEdit.color //цвет текста
    property color clrBorder: "transparent"//Цвет границы области текста.
    property alias bold: txdTextEdit.font.bold//Жирный текст.
    property alias italic: txdTextEdit.font.italic//Наклонный текст.
    property real pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
    property int  ntWidth: 2
    property int ntCoff: 8
    anchors.fill: parent
    //TODO Чета этот код не работает, нужно его логировать. Видимо из-за fnEnsureVisible
    //width: Screen.desktopAvailableWidth//ВАЖНО, экранная клавиатура работает корректно с размером приложения.
    height: Screen.desktopAvailableHeight//ВАЖНО,экранная клавиатура работает корректно с размером приложени

    Rectangle {
        id: rctTextEdit
        anchors.fill: root
		color: "transparent"//Цвет фона прозрачный.
        border.color: root.clrBorder
        border.width: root.ntCoff/2
        Flickable {//Перелистывание
            id: flcListat
            anchors.fill: rctTextEdit
            anchors.margins: root.ntCoff//Отступ, чтоб текст не налазил на бардюр.
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
				textFormat: TextEdit.AutoText//Формат текста АВТОМАТИЧЕСКИ определяется. Предпочтителен HTML4.
                color: "black"//цвет текста
                text: ""
                font.pixelSize: root.pixelSize//размер шрифта текста.
                wrapMode: TextEdit.Wrap//Текст в конце строки переносим на новую строку.
                readOnly: true
                focus: {
                    if(root.readOnly){//Если запрещено редактировать, то...
                        rctTextEdit.border.color = "transparent";//То граница прозрачная.
                        return false;//разфокусируемся.
                    }
                    else{//Если разрешено редактировать, то...
                        rctTextEdit.border.color = clrBorder;//То выставляем цвет из настройки property
                        return true;//фокусируемся.
                    }
                }
                selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
                onCursorRectangleChanged: flcListat.fnEnsureVisible(cursorRectangle)
            }
        }
    }
}
//Любые пробелы и табы в тексте отобразятся в приложении.
//<html>Корневой элемент, содержащий весь контент страницы.</html>
//<body>Элемент, содержащий видимый контент страницы.</body>
//<h1>Заголовок первого уровня, используется для заголовка страницы.</h>
//<p>Абзац текста, используется для отображения блоков текста.</p>
//<b>Жирный текст</b>
//<i>Курсивный текст</i>
//<u>Подчеркнуть текст</u>
//<center>По центру текст</center>
//<pre>В данной записи сохранятся все tab и пробелы, как задумал разработчик.</pre>
//<a href=\"http://ya.ru\">Яндекс</a> - форма записи ссылок.
//&lt; - это символ <
//&gt; - это символ >
