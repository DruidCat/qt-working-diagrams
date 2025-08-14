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
    property color clrFona: "Transparent"//цвет фона текста
    property color clrTexta: "Orange"//цвет текста
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
    //Сигналы
    signal pressed();
    //Функции. 
    Rectangle {
        id: rctTextEdit
        anchors.fill: root
        color: root.clrFona//Цвет фона.
        Flickable {//Перелистывание
            id: flcListat
            //Настройки
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
            function fnEnsureVisible(cursor){//Функция расчитывающая видимость текста, следующая за курсором.
                if(contentX >= cursor.x)
                    contentX = cursor.x;
                else{
                    if(contentX+width <= cursor.x + cursor.width)
                        contentX = cursor.x+cursor.width-width;
                }
                if(contentY >= cursor.y)
                    contentY = cursor.y;
                else{
                    if(contentY+height <= cursor.y+cursor.height)
                        contentY = cursor.y+cursor.height-height;
                }
            }
            TextEdit {//Область текста.
                id: txdTextEdit
                //Настройки
                width:  flcListat.width - tmScrollBar.width//Передаём ширину из зоны прокрутки - ScrollBar
                height: Math.max(paintedHeight, flcListat.height)//Высота растёт вместе с текстом
                //textFormat: TextEdit.AutoText//Формат текста АВТОМАТИЧЕСКИ определяется.Предпочтителен HTML4
                color: root.clrTexta
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
                //Функции.
                TapHandler {//Нажимаем на область TextEdit
                    onTapped: root.pressed();//Если нажали, то запускаем сигнал вне виджета.
                }
                onCursorRectangleChanged: {//Если позиция курсора измениласть, то..
                    if (!root.readOnly)//Если активирован режим редактирования, то...
                        flcListat.fnEnsureVisible(cursorRectangle)//За курсором листается текст.
                }
                onPaintedHeightChanged: {//Если высота отрисованного текста изменилась, то...
                    if (root.scrollAuto && root.readOnly) {//Если автоскрол и чтение только, то...
                        //Активируем автоскролл, держим курсор в конце — это низ.
                        cursorPosition = length
                        flcListat.contentY = Math.max(0, flcListat.contentHeight - flcListat.height)
                    }
                }
            }
        }
        Item {//Самодельный вертикальный скроллбар
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
                    acceptedButtons: Qt.LeftButton//Обрабатываем только левую клавишу мыши.
                    onPressed: (mouse) => {//Если было нажатие мышкой на треке, то...
                        const kontentVisota = flcListat.contentHeight//Высота всего текста
                        const flickVisota = flcListat.height//Высота боласти пролистывания flickable
                        const maxY = tmScrollBar.height - rctPolzunok.height
                        if (kontentVisota <= flickVisota || maxY <= 0)//Если текста меньше выстоты листания,то
                            return//Ничего не делаем
                        const target = Math.max(0, Math.min(mouse.y - rctPolzunok.height/2, maxY))
                        flcListat.contentY = target / maxY * (kontentVisota - flickVisota)
                    }
                }
            }
            Rectangle {//Ползунок
                id: rctPolzunok
                color: (maPolzunka.containsMouse || maPolzunka.pressed) ? tmScrollBar.clrPolzunokOn
                                                                        : tmScrollBar.clrPolzunokOff
                width: tmScrollBar.width//Ширина ползунка такая же, как и у всего scrollbar
                height: {//Высота ползунка пропорциональна видимой части
                    const kontentVisota = flcListat.contentHeight//Высота всего текста
                    const flickVisota = flcListat.height//Высота боласти пролистывания flickable
                    if (kontentVisota <= 0)//Если высота всего текста меньше или равно нулю, то...
                        return tmScrollBar.minVisotaPolzunka//высота полунка минимально заданная.
                    const ratio = Math.min(1, flickVisota / kontentVisota)
                    return Math.max(tmScrollBar.minVisotaPolzunka, tmScrollBar.height * ratio)//Расчёт высоты
                }
                x: 0//верхний левый угол прямогугольника в координате x = 0.
                y: {//Позиция ползунка синхронизируется со скроллом
                    const kontentVisota = flcListat.contentHeight//Высота всего текста
                    const flickVisota = flcListat.height//Высота боласти пролистывания flickable
                    const maxY = tmScrollBar.height - rctPolzunok.height
                    if (kontentVisota <= flickVisota || maxY <= 0)//Если высота текста меньше зоны листания,то
                        return 0//То верхний левый угол ползунка растоложить на y = 0
                    return flcListat.contentY / (kontentVisota - flickVisota) * maxY
                }
                z: 1//Поверх трека накладывается ползунок.
                MouseArea {//Претаскивание ползунка мышью
                    id: maPolzunka
                    anchors.fill: rctPolzunok
                    hoverEnabled: true
                    cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor//При нажатии анимация руки
                    drag.target: rctPolzunok//Перетаскиваем ползунок
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: tmScrollBar.height - rctPolzunok.height

                    onPositionChanged: {//Если позиция изменилась
                        if (pressed) {//Если мышка нажата, то...
                            const kontentVisota = flcListat.contentHeight//Высота всего текста
                            const flickVisota = flcListat.height//Высота боласти пролистывания flickable
                            const maxY = tmScrollBar.height - rctPolzunok.height
                            if (kontentVisota > flickVisota && maxY > 0)
                                flcListat.contentY = rctPolzunok.y / maxY * (kontentVisota - flickVisota)
                        }
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
