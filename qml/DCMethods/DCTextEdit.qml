import QtQuick //2.15
//DCTextEdit - ШАБЛОН РАБОТЫ С ТЕКСТОМ НА СТРАНИЦЕ (ЛИСТАТЬ, РЕДАКТИРОВАТЬ, ВЫДЕЛЯТЬ).
Item {
    id: root
    //Свойства.
    property alias text: txdTextEdit.text //Текст
    property alias readOnly: txdTextEdit.readOnly//читать Только текст. (false - можно изменять)
    property bool scrollAuto: false;//true-текст скроллится автоматически вверх, если выходит за рамки экрана.
	property alias textEdit: txdTextEdit//Передаём в виде свойства весь объект TextEdit
    property alias radius: rctTextEdit.radius//Радиус рабочей зоны
    property alias clrFona: rctTextEdit.color//цвет фона текста
    property alias clrTexta: txdTextEdit.color//цвет текста
    property color clrPolzunka: "Grey";//Цвет ползунка, когда он не активный.
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
        Flickable {//Перелистывание
            id: flcListat
            boundsBehavior: Flickable.StopAtBounds//чтобы не было «подпрыгиваний» из‑за овершута
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
                width:  flcListat.width-tmScrollBar.width//Передаём ширину из зоны прокрутки-scrolBar
                height: Math.max(paintedHeight, flcListat.height)//Высота растёт вместе с текстом
                //textFormat: TextEdit.AutoText//Формат текста АВТОМАТИЧЕСКИ определяется.Предпочтителен HTML4
                color: "black"//цвет текста
                text: ""
                font.pixelSize: root.pixelSize//размер шрифта текста.
                wrapMode: TextEdit.Wrap//Текст в конце строки переносим на новую строку.
                readOnly: true//Запрещено редактировать.
                focus: {
                    if(root.readOnly){//Если режим чтения, то...
                        flcListat.focus = true;//Чтоб курсор активный был, и горячие клавиши работали.
                        return false;
                    }
                    else//Если режим редактирования текста, то...
                        return true;//Чтоб виртуальная клавиатура появлялась на Android.
                }
                selectByMouse: true//пользователь может использовать мышь/палец для выделения текста.
                onCursorRectangleChanged: {
                    if (!root.readOnly)
                        flcListat.fnEnsureVisible(cursorRectangle)//ensureVisible только в режиме редактирован
                }
                onPaintedHeightChanged: {//Авто‑скролл после перерасчёта высоты текста
                    if (root.scrollAuto && root.readOnly) {
                        // держим курсор в конце, чтобы даже если ensureVisible где-то сработает — это низ
                        cursorPosition = length
                        flcListat.contentY = Math.max(0, flcListat.contentHeight - flcListat.height)
                    }
                }
            }
        }
        // Наш кастомный вертикальный скроллбар
        Item {
            id: tmScrollBar
            //Свойства
            property color clrTrack: "#40000000"//Полупрозрачный трек
            property color clrPolzunokOff: root.clrPolzunka//Цвет ползунка, когда он не активен.
            property color clrPolzunokOn: root.clrTexta//оранжевый при наведении
            readonly property int minVisotaPolzunka: 22//Минимальная высота Позунка
            //Настройки
            anchors.right: flcListat.right
            anchors.top: flcListat.top
            anchors.bottom: flcListat.bottom
            width: 11//Ширина Трека
            //Гистерезис, чтобы ползунок не мигал на границе равенства
            visible: (flcListat.contentHeight - flcListat.height) > 1//Показываем только когда есть что скрол.
            Rectangle {//Трек
                id: rctTrack
                anchors.fill: tmScrollBar
                color: tmScrollBar.clrTrack
                z: 0//Первым создаётся Трек, по верх него всё накладываться будет.
                MouseArea {//Клик по треку — прыжок к позиции
                    anchors.fill: rctTrack
                    acceptedButtons: Qt.LeftButton
                    onPressed: (mouse) => {
                        const ch = flcListat.contentHeight
                        const vh = flcListat.height
                        const maxY = tmScrollBar.height - rctPolzunok.height
                        if (ch <= vh || maxY <= 0)
                            return
                        const target = Math.max(0, Math.min(mouse.y - rctPolzunok.height/2, maxY))
                        flcListat.contentY = target / maxY * (ch - vh)
                    }
                }
            }
            Rectangle {//Ползунок
                id: rctPolzunok
                x: 0
                width: tmScrollBar.width
                color: (maPolzunka.containsMouse || maPolzunka.pressed) ? tmScrollBar.clrPolzunokOn
                                                                        : tmScrollBar.clrPolzunokOff
                z: 1//Поверх трека накладывается ползунок.
                height: {//Высота ползунка пропорциональна видимой части
                    const ch = flcListat.contentHeight
                    const vh = flcListat.height
                    if (ch <= 0) return tmScrollBar.minVisotaPolzunka
                    const ratio = Math.min(1, vh / ch)
                    return Math.max(tmScrollBar.minVisotaPolzunka, tmScrollBar.height * ratio)
                }
                y: {//Позиция ползунка синхронизируется со скроллом
                    const ch = flcListat.contentHeight
                    const vh = flcListat.height
                    const maxY = tmScrollBar.height - height
                    if (ch <= vh || maxY <= 0)
                        return 0
                    return flcListat.contentY / (ch - vh) * maxY
                }
                MouseArea {//Претаскивание ползунка мышью
                    id: maPolzunka
                    anchors.fill: rctPolzunok
                    hoverEnabled: true
                    cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    drag.target: parent
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: tmScrollBar.height - parent.height

                    onPositionChanged: if (pressed) {
                        const ch = flcListat.contentHeight
                        const vh = flcListat.height
                        const maxY = tmScrollBar.height - parent.height
                        if (ch > vh && maxY > 0)
                            flcListat.contentY = parent.y / maxY * (ch - vh)
                    }
                }
            }
        }
        Rectangle {
            id: rctBorder
            anchors.fill: parent
            color: "transparent"
            radius: rctTextEdit.radius
            border.color: root.readOnly ? "transparent" : root.clrBorder
            border.width: root.ntCoff/2
            z: 2//Поверх Трека и Ползунка, чтоб ползунок не наезжал на Границу.
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
