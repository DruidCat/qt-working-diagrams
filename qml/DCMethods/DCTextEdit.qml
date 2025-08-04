import QtQuick //2.15
import QtQuick.Controls//ScrollBar
//DCTextEdit - ШАБЛОН РАБОТЫ С ТЕКСТОМ НА СТРАНИЦЕ (ЛИСТАТЬ, РЕДАКТИРОВАТЬ, ВЫДЕЛЯТЬ).
Item {
    id: root
    //Свойства.
    property alias text: txdTextEdit.text //Текст
    property alias readOnly: txdTextEdit.readOnly//читать Только текст. (false - можно изменять)
    property bool scrollAuto: false;//true-текст скроллится автоматически вверх, если выходит за рамки экрана.
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
    //Настройки.
    anchors.fill: parent
    //TODO Чета этот код не работает, нужно его логировать. Видимо из-за fnEnsureVisible
    //width: Screen.desktopAvailableWidth//ВАЖНО, экранная клавиатура работает корректно с размером приложения.
    height: Screen.desktopAvailableHeight//ВАЖНО,экранная клавиатура работает корректно с размером приложени
    //Функции.
    Rectangle {
        id: rctTextEdit
        anchors.fill: root
		color: "transparent"//Цвет фона прозрачный.
        border.color: root.readOnly ? "transparent" : root.clrBorder
        border.width: root.ntCoff/2
        Flickable {//Перелистывание
            id: flcListat
            anchors.fill: rctTextEdit
            anchors.margins: root.ntCoff//Отступ, чтоб текст не налазил на бардюр.
            contentWidth: txdTextEdit.width//ширина вьюпорта
            contentHeight: txdTextEdit.paintedHeight//Общая высота листания = высоте всего текста
            interactive: true//Перелистывание активировать.
            clip: true//Обрезаем всё, что выходит за границы этого элемента.
            focus: true//чтоб обработчик клавиатуры работал
            Keys.onPressed: (event) => {//Обработчик клавиатуры.
                if(event.key === Qt.Key_Up || event.key === Qt.Key_K){
                    const cnShag = root.pixelSize * 1.2;//одна строка
                    contentY = Math.max(0, contentY - cnShag);
                    event.accepted = true;
                }
                else{
                    if(event.key === Qt.Key_Down || event.key === Qt.Key_J){
                        const cnShag = root.pixelSize * 1.2;//одна строка
                        contentY = Math.min(contentHeight - height, contentY + cnShag);
                        event.accepted = true;
                    }
                    else{
                        if(event.key === Qt.Key_PageUp){
                            const cnShag = height;//одна страница
                            contentY = Math.max(0, contentY - cnShag);
                            event.accepted = true;
                        }
                        else{
                            if(event.key === Qt.Key_PageDown){
                                const cnShag = height;//одна страница
                                contentY = Math.min(contentHeight - height, contentY + cnShag);
                                event.accepted = true;
                            }
                        }
                    }
                }
            }
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
                width:  flcListat.width//Передаём ширину из зоны прокрутки, нельзя через якорь.
                height: Math.max(paintedHeight, flcListat.height)//Высота растёт вместе с текстом
                //textFormat: TextEdit.AutoText//Формат текста АВТОМАТИЧЕСКИ определяется.Предпочтителен HTML4
                color: "black"//цвет текста
                text: ""
                font.pixelSize: root.pixelSize//размер шрифта текста.
                wrapMode: TextEdit.Wrap//Текст в конце строки переносим на новую строку.
                readOnly: true//Запрещено редактировать.
                focus: root.readOnly ? true : true//Чтоб курсор активный был, и горячие клавиши работали.
                selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
                onCursorRectangleChanged: flcListat.fnEnsureVisible(cursorRectangle)
                onTextChanged: {//Если текст изменяется, то...
                    if(root.scrollAuto){//Если настроен авто скролл текста, то...
                        Qt.callLater(function () {//Делаем паузу на такт, иначе не работает этот код.
                            if (root.readOnly) {//Если режим чтения активизирован, то...
                                if (flcListat.contentHeight > flcListat.height)//Если есть что скроллить, то..
                                    flcListat.contentY = flcListat.contentHeight - flcListat.height;//Скроллим
                                else//Если нечего скролить, то...
                                    flcListat.contentY = 0;//фиксируемся у начала
                            }
                        })
                    }
                }
            }
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
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
