// DCSidebar.qml
import QtQuick //2.15
import QtQuick.Controls
import QtQuick.Pdf
import DCButtons 1.0
import DCMethods 1.0//Импортируем методы написанные мной.

Drawer {
    id: root
    //Настройки
    property var pmpDoc//PdfMultiPageView (pmpDoc)
    property var pdfDoc//PdfDocument (pdfDoc)
    property bool isMobile: true//true - мобильное устройство
    property int ntWidth: 1
    property int ntCoff: 8
    property color clrTexta: "Orange"
    property color clrFona: "Black"
    property color clrMenuFon: "SlateGray"
    property color clrPoisk: "Yellow"
    property alias currentIndex: tbSidebar.currentIndex
    property alias posterIndex: grvPoster.currentIndex
    //Настройки
    edge: Qt.LeftEdge
    modal: false
    dim: false
    closePolicy: Drawer.CloseOnEscape//Закрываем боковую панель только при нажати Escape, другие политики выкл
    clip: true//Обрезать всё лишнее.
    width: root.isMobile
           ? (parent ? parent.width : 0)
           : ((parent ? parent.width : 0) / 3)//Если мобила, то ширина на весь экран,если нет,то 1/3
    height: root.pmpDoc ? root.pmpDoc.height : (parent ? parent.height : 0)//Высота по высоте pdf сцены
    y: root.ntWidth * root.ntCoff + 3 * root.ntCoff//координату по Y брал из расчёта Stranica.qml
    //Функции
    onPdfDocChanged: {//Если будет замена на пустой pdf файл, для обнуления открытого файла, то...
        grvPoster.model = null//Обнуляем отображение постеров, чтоб не обратится к несуществующему постеру.
        trvZakladki.isEmpty = true//Пусто
    }
    Rectangle {//Прямоугольник узкой полоски интерфейса слева
        id: rctBorder
        anchors.top: root.top
        anchors.left: root.left
        width: root.ntCoff
        height: parent.height
        color: root.clrMenuFon
    }
    Rectangle {//Прямоугольник Вкладок
        id: rctTabbar
        anchors.top: root.top
        anchors.left: rctBorder.right
        width: ((root.ntWidth-1)*root.ntCoff<20)?20:(root.ntWidth-1)*root.ntCoff//От слишком маленького шрифта
        height: root.height
        color: root.clrTexta
    }
    Rectangle {//Прямоугольник всей оставшейся боковой панели.
        id: rctSidebar
        anchors.top: root.top
        anchors.left: rctTabbar.right
        width: root.width - rctBorder.width - rctTabbar.width
        height: root.height
        color: "transparent"
    }
    TabBar {//Вкладки
        id: tbSidebar
        anchors.left: rctTabbar.right
        anchors.bottom: rctTabbar.bottom
        height: rctTabbar.width
        width: rctTabbar.height
        //y: rctTabbar.height
        //x: rctBorder.width+rctTabbar.width
        rotation: -90//Поворачиваем на 90 градусов против часовой стрелки боковую панель
        transformOrigin: Item.BottomLeft//Точка поворота боковой панели нижний левый угол.
        currentIndex: 1//Закладки видимые по умолчанию.
        DCTabButton {
            text: qsTr("Найдено")
            width:  (rctTabbar.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4//делим на кол-во кнопок
            height: rctTabbar.width
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blFontAuto: true//Включаем автоподгонку размера шрифта.
            onPressed: tbSidebar.currentIndex = 0//Меняем индекс сразу при нажатии
        }
        DCTabButton {
            text: qsTr("Закладки")
            width:  (rctTabbar.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4
            height: rctTabbar.width
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blFontAuto: true//Включаем автоподгонку размера шрифта.
            onPressed: tbSidebar.currentIndex = 1//Меняем индекс сразу при нажатии
        }
        DCTabButton {
            text: qsTr("Страницы")
            width:  (rctTabbar.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4
            height: rctTabbar.width
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blFontAuto: true//Включаем автоподгонку размера шрифта.
            onPressed: tbSidebar.currentIndex = 2//Меняем индекс сразу при нажатии
        }
    }
    Rectangle {//Вкладка "Найдено"
        id: rctNaideno
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        width: rctSidebar.width
        height: rctSidebar.height
        color: root.clrFona
        visible: currentIndex === 0//Если истина, то видимая вкладка.
        Text {
            id: txtNaideno
            anchors.horizontalCenter: rctNaideno.horizontalCenter
            anchors.verticalCenter: rctNaideno.verticalCenter
            color: root.clrMenuFon
            font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.pmpDoc.searchModel.count ? "" : qsTr("Не найдено")
        }
        ListView {
            id: lsvNaideno
            anchors.fill: rctNaideno
            implicitHeight: rctNaideno.height
            model: root.pmpDoc ? root.pmpDoc.searchModel : null//Если есть поисковая модель, то добавляем её
            currentIndex: root.pmpDoc ? root.pmpDoc.searchModel.currentResult : -1
            ScrollBar.vertical: ScrollBar { }
            delegate: ItemDelegate {
                id: tmdResult
                required property int index//Номер совпадения
                required property int page//Страница, на котором совпадение есть.
                required property var location//Страница, на котором совпадение есть.
                width: lsvNaideno.width
                background: Rectangle {
                    color: (tmdResult.ListView.isCurrentItem
                            //? "#2979FF"//Синий на выделение по клику
                            ? root.clrMenuFon
                            : ((tmdResult.index % 2)
                                ? root.clrFona
                                : Qt.tint(root.clrFona, Qt.rgba(1, 1, 1, 0.22))))
                }
                contentItem: Label {
                    text: qsTr(" Страница ") + (tmdResult.page + 1) + " [" + (tmdResult.index + 1) + "]"
                    color: root.clrPoisk
                    font.pixelSize: root.ntWidth * root.ntCoff - root.ntCoff//Размер шрифта
                }
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (root.pmpDoc) root.pmpDoc.searchModel.currentResult = tmdResult.index//Задаём № поиска
                    if (root.isMobile) root.close()//Если мобила, то закрываем боковую панель
                }
                Component.onCompleted: {//Если создался элемент делегата, то...
                    if (index === 0 && root.pmpDoc){//Если index поиска первый (0), то...
                        root.pmpDoc.searchModel.currentResult = -1//Сбрасываем результат прошлого поиска.
                        tmrCurrentResult.running = true//Запускаем таймер,чтоб нет прерывания в прерывании
                    }
                }
                Timer {//Таймер необходим, чтобы выйти из прерывания и подсветить первый элемент.
                    id: tmrCurrentResult
                    interval: 3; running: false; repeat: false
                    onTriggered: if (root.pmpDoc) root.pmpDoc.searchModel.currentResult = 0//Переход на первый
                }
            }
        }
        Rectangle {//Оконтовка поверх информации.
            anchors.fill: rctNaideno
            color: "transparent"
            border.color: root.clrTexta
            border.width: root.ntCoff/4//Бордюр
        }
    }
    Rectangle {//Вкладка "Закладки"
        id: rctZakladki
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        width: rctSidebar.width
        height: rctSidebar.height
        color: root.clrFona
        border.color: root.clrTexta
        border.width: root.ntCoff/4
        visible: currentIndex === 1//Если истина, то видимая вкладка.
        Text {
            id: txtZakladki
            anchors.horizontalCenter: rctZakladki.horizontalCenter
            anchors.verticalCenter: rctZakladki.verticalCenter
            color: root.clrMenuFon
            font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:  trvZakladki.isEmpty ? qsTr("Закладки отсутствуют") : ""
        }
        TreeView {
            id: trvZakladki
            //Свойства
            property bool isEmpty: true//Есть закладки? true - пусто
            //Настройки
            implicitHeight: rctZakladki.height
            implicitWidth: rctZakladki.width
            columnWidthProvider: function() { return width }
            ScrollBar.vertical: ScrollBar { }
            delegate: TreeViewDelegate {
                id: tvdZakladka
                //Свойства
                required property int page//Страница закладки
                required property point location//Координата закладки
                required property string title//Текст закладки
                property bool isPressed: false//Флаг, который запоминает нажатие по вкладке
                //Настройки
                //leftPadding: 11//Отступ слева
                text: title//Отображение текста вкладки.
                background: Rectangle {//Задний фон вкладки
                    color: isPressed ? root.clrMenuFon : Qt.tint(root.clrFona, Qt.rgba(1, 1, 1, 0.33))
                }
                contentItem: Text {
                    text: tvdZakladka.text
                    color: root.clrTexta
                    //font.pixelSize: root.ntCoff*(root.ntWidth-1)
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                //Функции
                onPressedChanged: isPressed = pressed//Если нажали на вкладку, то взводим флаг.
                onClicked: {
                    if (root.pmpDoc) root.pmpDoc.goToLocation(page, location, root.pmpDoc.renderScale)//На Стр
                    if (root.isMobile) root.close()//Если мобила, то закрываем боковую панель
                }
                Component.onCompleted: {//Если создался элемент делегата, то...
                    trvZakladki.isEmpty = false//Есть закладки.
                }
            }
            model: PdfBookmarkModel {
                document: root.pdfDoc
            }
        }
        Rectangle {//Оконтовка поверх информации.
            anchors.fill: rctZakladki
            color: "transparent"
            border.color: root.clrTexta
            border.width: root.ntCoff/4
        }
    }
    Rectangle {//Вкладка "Страницы"
        id: rctPoster
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        width: rctSidebar.width
        height: rctSidebar.height
        color: root.clrFona
        border.color: root.clrTexta
        border.width: root.ntCoff/4//Бордюр
        visible: currentIndex === 2//Если истина, то видимая вкладка.
        onVisibleChanged: {//Если Видимость Страниц изменилась, то...
            if(visible){//Если видимая страница, то...
                if(!grvPoster.model){//Если модель нулевая, то...
                    if(root.pdfDoc && root.pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился
                        grvPoster.model = root.pdfDoc.pageModel//Загружаем документ в модель.
                        tmrCurrentIndex.running = true//Запускаем таймер ререхода к нужному постеру.
                    }
                }
            }
        }
        Timer {//Таймер необходим, чтоб успела загружится модель Минниатюр,перестраховка от падения приложения
            id: tmrCurrentIndex
            interval: 11; running: false; repeat: false
            onTriggered: {
                const cnStranica = root.pmpDoc.currentPage//Страница, на которую нужно перескочить.
                if(grvPoster.count > cnStranica)//ЗАЩИТА. Если счётчик больше количества страниц, то...
                    grvPoster.currentIndex = cnStranica//Подсвечиваем открытую страницу.
                else
                    console.error("254: DCSidebar, попытка перехода на постер, который ещё не создался.")
            }
        }

        GridView {
            id: grvPoster
            implicitWidth: rctPoster.width
            implicitHeight: rctPoster.height
            model: null//Модель нулевая, пока пользователь её не загрузит
            ScrollBar.vertical: ScrollBar { id: scbVertical }
            cellWidth: width/2 - scbVertical.width/2//Расчёт длины одного постера
            cellHeight: cellWidth + 10
            delegate: Item {
                id: tmPoster
                required property int index
                required property string label
                required property size pointSize
                width: grvPoster.cellWidth
                height: grvPoster.cellHeight
                Rectangle {
                    id: rctList
                    width: rctImage.width
                    height: rctImage.height
                    x: (tmPoster.width - rctList.width)/2
                    y: (tmPoster.height - rctList.height - txtNomerStranici.height)/2
                    border.color: tmPoster.GridView.isCurrentItem ? root.clrTexta : "transparent"
                    border.width: root.ntCoff/2
                    PdfPageImage {
                        id: rctImage
                        document: root.pdfDoc
                        currentFrame: index
                        asynchronous: true//Асинхронное создание минниатюр
                        cache: false//менее агрессивный кеш, чтобы не держать много памяти на миниатюрах
                        fillMode: Image.PreserveAspectFit
                        property bool landscape: pointSize.width > pointSize.height
                        width: landscape ? grvPoster.cellWidth - 6
                                         : height * pointSize.width / pointSize.height
                        height: landscape ? width * pointSize.height / pointSize.width
                                          : grvPoster.cellHeight - 14
                        sourceSize.width: rctImage.width
                        sourceSize.height: rctImage.height
                    }
                }
                Text {
                    id: txtNomerStranici
                    anchors.bottom: tmPoster.bottom
                    anchors.horizontalCenter: tmPoster.horizontalCenter
                    color: tmPoster.GridView.isCurrentItem ? root.clrTexta : root.clrPoisk
                    text: label
                    font.pixelSize: root.ntWidth * root.ntCoff - root.ntCoff//Размер шрифта
                }
                TapHandler {
                    onTapped: {
                        grvPoster.currentIndex = index//Передаём выбранный индекс, для подсветки текста.
                        if(root.pmpDoc) root.pmpDoc.goToPage(index)//Переходим на страницу.
                        if(root.isMobile) root.close()//Если мобила, то закрываем боковую панель
                    }
                }
            }
        }
        Rectangle {//Оконтовка поверх информации.
            anchors.fill: rctPoster
            color: "transparent"
            border.color: root.clrTexta
            border.width: root.ntCoff/4
        }
    }
}
