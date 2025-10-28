// DCSidebar.qml
import QtQuick //2.15
import QtQuick.Controls
import QtQuick.Pdf
import DCButtons 1.0

Drawer {
    id: root
    //Настройки
    // Внешние ссылки
    property var pmpDoc//PdfMultiPageView (pmpDoc)
    property var pdfDoc//PdfDocument (pdfDoc)
    // Тема и размеры
    property bool isMobile: true//true - мобильное устройство
    property int ntWidth: 1
    property int ntCoff: 8
    property color clrTexta: "Orange"
    property color clrFona: "Black"
    property color clrMenuFon: "SlateGray"
    property color clrPoisk: "Yellow"
    // Публичное API
    property alias currentIndex: tbSidebar.currentIndex
    property alias posterIndex: grvPoster.currentIndex

    edge: Qt.LeftEdge
    modal: false
    dim: false
    closePolicy: Drawer.CloseOnEscape//Закрываем боковую панель только при нажати Escape, другие политики выкл
    clip: true//Образать всё лишнее.
    width: root.isMobile
           ? (parent ? parent.width : 0)
           : ((parent ? parent.width : 0) / 3)//Если мобила, то ширина на весь экран,если нет,то 1/3
    height: root.pmpDoc ? root.pmpDoc.height : (parent ? parent.height : 0)//Высота по высоте pdf сцены
    y: root.ntWidth * root.ntCoff + 3 * root.ntCoff//координату по Y брал из расчёта Stranica.qml
    Rectangle {//Прямоугольник узкой полоски интерфейса слева
        id: rctBorder
        anchors.top: root.top
        anchors.left: root.left
        width: root.ntCoff
        height: parent.height
        color: "transparent"
        //color: root.clrMenuFon
    }
    Rectangle {//Прямоугольник всей оставшейся боковой панели.
        id: rctSidebar
        anchors.top: root.top
        anchors.left: rctBorder.right
        width: root.width - root.ntCoff
        height: root.height
        color: "transparent"
    }
    TabBar {//Вкладки
        id: tbSidebar
        //anchors.top: root.top
        //anchors.right: rctBorder.right
        anchors.left: rctBorder.right
        anchors.bottom: rctSidebar.bottom
        height: ((root.ntWidth-1)*root.ntCoff < 22) ? 22
              : ((root.ntWidth-1)*root.ntCoff > 30) ? 30
              : ((root.ntWidth-1)*root.ntCoff)
        //x: -width//Смещаем х влево в минусовые координаты, для того,чтоб потом повернуть от точки поворота
        //y: rctSidebar.height//Смещаем х влево в минусовые координаты, для того,чтоб потом повернуть от точки поворота
        rotation: -90//Поворачиваем на 90 градусов против часовой стрелки боковую панель
        //transformOrigin: Item.TopRight//Точка поворота боковой панели верхний правый угол.
        transformOrigin: Item.BottomLeft//Точка поворота боковой панели верхний правый угол.
        currentIndex: {//Закладки выбраны по умолчанию
            rctZakladki.visible = true
            return 1
        }
        onCurrentIndexChanged: {//Если индекс tbSidebar меняется, то делаем видимыми содержимое вкладок.
            rctNaideno.visible = (currentIndex === 0)
            rctZakladki.visible = (currentIndex === 1)
            rctPoster.visible = (currentIndex === 2)
        }
        DCTabButton {
            text: qsTr("Найдено")
            width:  (root.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4//делим на кол-во кнопок
            height: tbSidebar.height
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blAutoFont: false//Отключаем автоподгонку размера шрифта.
            onPressed: tbSidebar.currentIndex = 0//Меняем индекс сразу при нажатии
        }
        DCTabButton {
            text: qsTr("Закладки")
            width:  (root.height - root.ntCoff/2) / tbSidebar.count + root.ntCoff/4
            height: tbSidebar.height
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blAutoFont: false//Отключаем автоподгонку размера шрифта.
            onPressed: tbSidebar.currentIndex = 1//Меняем индекс сразу при нажатии
        }
        DCTabButton {
            text: qsTr("Страницы")
            width:  (root.height - root.ntCoff/2) / tbSidebar.count + root.ntCoff/4
            height: tbSidebar.height
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blAutoFont: false//Отключаем автоподгонку размера шрифта.
            onPressed: tbSidebar.currentIndex = 2//Меняем индекс сразу при нажатии
        }
    }
    Rectangle {//Вкладка "Найдено"
        id: rctNaideno
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        anchors.leftMargin: tbSidebar.height
        width: rctSidebar.width - tbSidebar.height
        height: rctSidebar.height
        color: root.clrFona
        visible: false

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
        anchors.leftMargin: tbSidebar.height
        width: rctSidebar.width - tbSidebar.height
        height: rctSidebar.height
        border.color: root.clrTexta
        border.width: root.ntCoff/4
        visible: false
        TreeView {
            id: trvZakladki
            implicitHeight: rctZakladki.height
            implicitWidth: rctZakladki.width
            columnWidthProvider: function() { return width }
            ScrollBar.vertical: ScrollBar { }
            delegate: TreeViewDelegate {
                required property int page
                required property point location
                onClicked: {
                    if (root.pmpDoc) root.pmpDoc.goToLocation(page, location, root.pmpDoc.renderScale)//На Стр
                    if (root.isMobile) root.close()//Если мобила, то закрываем боковую панель
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
        anchors.leftMargin: tbSidebar.height
        width: rctSidebar.width - tbSidebar.height
        height: rctSidebar.height
        color: root.clrFona
        border.color: root.clrTexta
        border.width: root.ntCoff/4//Бордюр
        visible: false
        GridView {
            id: grvPoster
            implicitWidth: rctPoster.width
            implicitHeight: rctPoster.height
            model: root.pdfDoc ? root.pdfDoc.pageModel : null
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
                        asynchronous: true
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
