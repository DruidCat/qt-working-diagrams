// DCSidebar.qml
import QtQuick //2.15
import QtQuick.Controls
import QtQuick.Pdf
import DCButtons 1.0//Импортируем кнопки написанные мной.
import DCMethods 1.0//Импортируем методы написанные мной.
import QtQml.Models//Для DelegateModel

Drawer {
    id: root
    //Свойства
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
    property int minSidebarWidth: 200//Минимум ширины боковой панели
    property int maxSidebarWidth: parent ? parent.width * 0.8 : 640//Максимум ширины боковой панели
    property int sidebarWidth: root.isMobile//Если мобила, ширина на весь экран, если нет,то данные из Реестра
                               ? (parent ? parent.width : 0)
                               : Math.max(minSidebarWidth, (parent ? cppqml.untSidebarWidth : 330))
    //Настройки
    edge: Qt.LeftEdge
    modal: false
    dim: false
    closePolicy: Drawer.CloseOnEscape//Закрываем боковую панель только при нажати Escape, другие политики выкл
    clip: true//Обрезать всё лишнее.
    width: sidebarWidth//ВАЖНО! ширина боковой панели зависит только от sidebarWidth.
    height: root.pmpDoc ? root.pmpDoc.height : (parent ? parent.height : 0)//Высота по высоте pdf сцены
    y: root.ntWidth * root.ntCoff + 3 * root.ntCoff//координату по Y брал из расчёта Stranica.qml
    interactive: true//false -  панель не реагирует на свайпы.
    //Сигналы
    signal clickedPoisk()//Сигнал запуска режима поиска.
    signal clickedInfo();//Сигнал нажатия кнопки Информация
    //Функции
    onPdfDocChanged: {//Если будет замена на пустой pdf файл, для обнуления открытого файла, то...
        grvPoster.model = null//Обнуляем отображение постеров, чтоб не обратится к несуществующему постеру.
    }
    function fnNaidenoEnter(){//Функция выбора результата поиска в боковой панели для перехода к нему.
        if(root.pmpDoc.searchModel.count)//Если счётчик поиска не 0, то...
            root.pmpDoc.searchModel.currentResult = lsvNaideno.currentIndex//Переходим к определён результату.
    }
    function fnNaidenoIndex(index){//Функция подсвечивания результата поиска в боковой панели.
        lsvNaideno.currentIndex = index//Подсвечиваем в списке.
    }
    function fnNaidenoNext(){//Функция перехода к следующему результату в списке.
        if(lsvNaideno.currentIndex !== (root.pmpDoc.searchModel.count - 1))//Если не максимальный индекс, то..
            lsvNaideno.currentIndex += 1//То увеличиваем на 1
    }
    function fnNaidenoPrevious(){//Функция перехода к предыдущему результату в списке.
        if(lsvNaideno.currentIndex > 0)//Если больше или 0, то...
            lsvNaideno.currentIndex -= 1//То уменьшаем на 1
    }
    function fnNaidenoOpen(){//Функция открытия и фокусировки Найдено
        dcSidebar.currentIndex = 0//Переключаемся на вкладку Найдено
        lsvNaideno.focus = true//Фокус на Найдено
        tbbNaideno.focus = false//Убираем фокус, чтоб подсветку бордюра вкладки убрать.
        lblZagolovok.text = tbbNaideno.text//Переименовываем заголовок на Найдено
    }
    function fnZakladkiOpen(){//Функция открытия и фокусировки Закладках
        dcSidebar.currentIndex = 1//Переключаемся на вкладку Закладки
        trvZakladki.focus = true//Фокус на Закладках
        tbbZakladki.focus = false//Убираем фокус, чтоб подсветку бордюра вкладки убрать.
        lblZagolovok.text = tbbZakladki.text//Переименовываем заголовок на Закладки
    }
    function fnPosterOpen(){//Функция открытия и фокусировки Страницы
        dcSidebar.currentIndex = 2//Переключаемся на вкладку Миниатюр
        grvPoster.focus = true//Фокус на страницах
        tbbPoster.focus = false//Убираем фокус, чтоб подсветку бордюра вкладки убрать.
        lblZagolovok.text = tbbPoster.text//Переименовываем заголовок на Страницы
    }
    function fnClickedInfo(){//Функция нажатия кнопки Информация.
        if(knopkaInfo.enabled){//Если кнопка активна, то...
            root.close();//Метод обрабатывающий кнопку Закрыть Боковую панель.
            root.clickedInfo();//сигнал нажатия кнопки Информация.
        }
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
    Rectangle {//Прямоугольник заголовка, для информации и кнопки закрыть.
        id: rctZagolovok
        anchors.top: root.top
        anchors.left: rctTabbar.right
        width: root.width - rctBorder.width - rctTabbar.width - rctRuchka.width
        height: root.ntCoff*(root.ntWidth-1)+root.ntCoff
        color: root.clrFona
        border.color: root.clrTexta
        border.width: root.ntCoff/4
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: (root.ntWidth-1)
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctZagolovok.verticalCenter
            anchors.left: rctZagolovok.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: (root.ntWidth-1)*root.ntCoff+root.ntCoff
            tapWidth: tapHeight
            onClicked: fnClickedInfo();//Функция нажатия кнопки Информация.
        }
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: (root.ntWidth-1)
            ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: rctZagolovok.verticalCenter
            anchors.right: rctZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: (root.ntWidth-1)*root.ntCoff+root.ntCoff
            tapWidth: tapHeight
            onClicked: root.close();//Метод обрабатывающий кнопку Закрыть.
        }
        Label {//Текст вписанный в границы, отображает имя заголовка.
            id: lblZagolovok
            anchors.top: rctZagolovok.top
            anchors.left: knopkaInfo.right
            anchors.right: knopkaZakrit.left
            height: rctZagolovok.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: root.clrTexta
            //font.capitalization: Font.AllUppercase//СЛОВА ЗАГЛАВНЫМИ БУКВАМИ
            font.bold: true//Жирный текст.
            font.pixelSize: root.ntCoff*(root.ntWidth-1)
            elide: Text.ElideRight//Обрезаем текст по правой стороне точками (...)
            Component.onCompleted: text = tbbZakladki.text//Переименовываем заголовок на Закладки
        }
    }
    Rectangle {//Прямоугольник всей оставшейся боковой панели.
        id: rctSidebar
        anchors.top: rctZagolovok.bottom
        anchors.left: rctTabbar.right
        width: root.width - rctBorder.width - rctTabbar.width - rctRuchka.width
        height: root.height-rctZagolovok.height
        color: "transparent"
    }
    Rectangle {//Прямоугольник ручки, за которую можно тянуть размер боковой панели, для изменения её размеров
        id: rctRuchka
        anchors.top: root.top
        anchors.left: rctSidebar.right
        width: (root.ntWidth < 3) ? 3 : root.ntWidth//В зависимости от параметра, изменяется толщина ручки.
        height: root.height
        color: Qt.darker(root.clrTexta, 1.3)
        border.color: root.clrTexta
        border.width: (root.ntWidth < 5) ? 1 : root.ntCoff/4//Чтоб была видна оконтовка ручки.
        MouseArea {
            id: maRuchka
            //Свойства
            property bool isDrag: false//Свойство перетаскивания. true - началось перетаскивание.
            property real lastX//Переменная хранящаа предыдущее положение мыши
            //Настройки
            anchors.fill: parent
            hoverEnabled: true//При наведении изменение
            cursorShape: Qt.SizeHorCursor//Курсор в виде изменения горизонтального размера.
            //Функции
            onPressed: (mouse) => {//Если нажали на ручку
                if (root.isMobile) return//Если мобильное устройство, то выходим
                root.interactive = false;//Отключаем свайп Drawer. ВАЖНО!
                isDrag = true//Взводим флаг при нажатии на ручку, идёт изменение размеров.
                lastX = mouse.x//Запоминаем первоначальное положение боковой панели по координатам мыши.
                mouse.accepted = true//Завершаем обработку эвента.
            }
            onReleased: {//Если отпустили кнопку мышки
                root.interactive = true;//Включаем свайп Drawer. ВАЖНО!
                cppqml.untSidebarWidth = root.sidebarWidth//Записываем в реестр ширину боковой панели.
                isDrag = false//При отпускании мыши Окончание перетаскивания
            }
            onCanceled: {
                root.interactive = true;//Включаем свайп Drawer. ВАЖНО!
                cppqml.untSidebarWidth = root.sidebarWidth//Записываем в реестр ширину боковой панели.
                isDrag = false//Окончание перетаскивания
            }
            onPositionChanged: (mouse) => {//Если позиция меняется, то...
                if (!isDrag || root.isMobile) return//Если не перетаскиваем ручку или мобильное устройство,вых
                const dX = mouse.x - lastX//Дельта Х относительно предыдущей точки Х
                lastX = mouse.x//Запоминаем положение мыши по Х.
                if (dX === 0) return//Если дельта не изменилась, ничего не делаем
                let ltWidth = root.sidebarWidth + dX//Новые размеры ширины боковой панели.
                ltWidth = Math.max(root.minSidebarWidth, Math.min(root.maxSidebarWidth, ltWidth))//Проверка
                root.sidebarWidth = ltWidth//Изменяем ширину боковой панели на новую ширину
            }
        }
    }
    TabBar {//Вкладки
        id: tbSidebar
        anchors.left: rctTabbar.right
        anchors.bottom: rctTabbar.bottom
        height: rctTabbar.width
        width: rctTabbar.height
        rotation: -90//Поворачиваем на 90 градусов против часовой стрелки боковую панель
        transformOrigin: Item.BottomLeft//Точка поворота боковой панели нижний левый угол.
        currentIndex: 1//Закладки видимые по умолчанию.
        Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event
            if((event.key===Qt.Key_Enter)||(event.key===Qt.Key_Return)||(event.key===Qt.Key_Space)){
                if(tbbNaideno.focus) fnNaidenoOpen()//Функция открытия и фокусировки Найдено
                else if(tbbZakladki.focus) fnZakladkiOpen()//Функция открытия и фокусировки Закладках
                else if(tbbPoster.focus) fnPosterOpen()//Функция открытия и фокусировки Страницы
                event.accepted = true;//Завер обработку эвента
            }
            else{
                if(event.key === Qt.Key_Down){//нажата "Стрелка вниз",то
                    tbSidebar.currentIndex = Math.max(0, tbSidebar.currentIndex -= 1)
                    event.accepted = true;//Завершаем обработку эвента.
                }
                else{
                    if(event.key === Qt.Key_Up){//нажата "Стрелка вверх"
                        tbSidebar.currentIndex = Math.min(2, tbSidebar.currentIndex += 1)
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
        }
        DCTabButton {
            id: tbbNaideno
            text: qsTr("Найдено")
            width: (rctTabbar.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4//делим на кол-во кнопок
            height: rctTabbar.width
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blFontAuto: true//Включаем автоподгонку размера шрифта.
            onPressed: fnNaidenoOpen()//Функция открытия и фокусировки Найдено
            onFocusChanged: {//Если фокус вкладки изменился, то...
                if(focus) dcSidebar.currentIndex = 0//Переключаемся на вкладку Найдено.
                borderFocus = focus//Не подсвечиваем/подсвечиваем бордюр вкладки.
            }
            Component.onCompleted: borderFocus = false//После загрузки бордюр не активный
        }
        DCTabButton {
            id: tbbZakladki
            text: qsTr("Закладки")
            width: (rctTabbar.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4
            height: rctTabbar.width
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blFontAuto: true//Включаем автоподгонку размера шрифта.
            onPressed: fnZakladkiOpen()//Функция открытия и фокусировки Закладках
            onFocusChanged: {//Если фокус вкладки изменился, то...
                if(focus) dcSidebar.currentIndex = 1//Переключаемся на вкладку Закладки
                borderFocus = focus//Не подсвечиваем/подсвечиваем бордюр вкладки.
            }
            Component.onCompleted: borderFocus = false//После загрузки бордюр не активный
        }
        DCTabButton {
            id: tbbPoster
            text: qsTr("Страницы")
            width: (rctTabbar.height - root.ntCoff/2)/tbSidebar.count + root.ntCoff/4
            height: rctTabbar.width
            hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
            clrTexta: root.clrTexta
            clrFona: root.clrFona
            clrHover: root.clrMenuFon
            ntCoff: root.ntCoff//Для автоподгонки шрифта во вкладке
            blFontAuto: true//Включаем автоподгонку размера шрифта.
            onPressed: fnPosterOpen()//Функция открытия и фокусировки Страницы
            onFocusChanged: {//Если фокус вкладки изменился, то...
                if(focus) dcSidebar.currentIndex = 2//Переключаемся на вкладку Миниатюр
                borderFocus = focus//Не подсвечиваем/подсвечиваем бордюр вкладки.
            }
            Component.onCompleted: borderFocus = false//После загрузки бордюр не активный
        }
    }
    Rectangle {//Вкладка "Найдено"
        id: rctNaideno
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        width: rctSidebar.width
        height: rctSidebar.height
        color: root.clrFona
        clip: true//Обязательно обрезать всё, что не помещается в этот прямоугольник.
        visible: currentIndex === 0//Если истина, то видимая вкладка.
        Text {
            id: txtNaideno
            anchors.left: rctNaideno.left
            anchors.right: rctNaideno.right
            anchors.verticalCenter: rctNaideno.verticalCenter
            color: root.clrMenuFon
            font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.pmpDoc.searchModel.count ? "" : qsTr("Не найдено")
            elide: Text.ElideRight//Обрезаем текст по правой стороне точками (...)
        }
        ListView {
            id: lsvNaideno
            anchors.fill: rctNaideno
            implicitHeight: rctNaideno.height
            model: root.pmpDoc ? root.pmpDoc.searchModel : null//Если есть поисковая модель, то добавляем её
            currentIndex: root.pmpDoc ? root.pmpDoc.searchModel.currentResult : -1
            ScrollBar.vertical: ScrollBar { }
            KeyNavigation.tab: tbbNaideno//Tab -> кнопка "Найдено"
            Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event
                if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
                    if(event.key === Qt.Key_B){//Если нажата клавиша B
                        fnZakladkiOpen()//Функция открытия боковой панели на Закладке.
                        event.accepted = true;//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_T){//Если нажата клавиша T
                            fnPosterOpen()//Открытие боковой панели на Миниатюрах.
                            event.accepted = true;//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F){//Если нажата клавиша F
                        root.clickedPoisk()//Сигнал нажатия на кнопку поиск.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
                else if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                    if (event.key === Qt.Key_F){//Если нажата клавиша F, то...
                        dcSidebar.close()//Закрываем боковую панель
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                } else if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                    if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                        if(root.pmpDoc.searchModel.count)//Если не 0, то...
                            root.pmpDoc.searchModel.currentResult -= 1//Предыдущий результат
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                } else {
                    if((event.key===Qt.Key_Enter)||(event.key===Qt.Key_Return)||(event.key===Qt.Key_Space)){
                        if(root.pmpDoc//Указатель не null
                            && lsvNaideno.model//модель не null
                            && lsvNaideno.focus//Фокус на Найдено
                            && root.pmpDoc.searchModel.count)//Счётчик поиска не 0
                                root.pmpDoc.searchModel.currentResult = lsvNaideno.currentIndex
                        event.accepted = true;//Завер обработку эвента
                    } else if(event.key === Qt.Key_F3){//Если нажата кнопка F3,то..
                        if(root.pmpDoc.searchModel.count)//Если не 0, то...
                            root.pmpDoc.searchModel.currentResult += 1//Следующий результат
                        event.accepted = true;//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F1){//Если нажата клавиша F1
                        fnClickedInfo();//Функция нажатия клавиши Информация.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
            delegate: ItemDelegate {
                id: tmdResult
                required property int index//Номер совпадения
                required property int page//Страница, на котором совпадение есть.
                required property var location//Страница, на котором совпадение есть.
                width: lsvNaideno.width
                background: Rectangle {
                    color: (tmdResult.ListView.isCurrentItem
                            ? (lsvNaideno.focus ? root.clrMenuFon : Qt.darker(root.clrMenuFon, 1.1))
                            : ((tmdResult.index % 2) ? root.clrFona
                                                     : Qt.tint(root.clrFona, Qt.rgba(1, 1, 1, 0.22))))
                }
                contentItem: Label {
                    text: " " + (tmdResult.index + 1) + ". " + qsTr("Страница ") + (tmdResult.page + 1)
                    color: root.clrPoisk
                    font.pixelSize: (root.ntWidth<=2) ? root.ntCoff*(root.ntWidth-1)//Защита от нулевой разниц
                                                      : root.ntCoff*(root.ntWidth-2)
                    //font.pixelSize: root.ntWidth * root.ntCoff - root.ntCoff//Размер шрифта
                }
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (root.pmpDoc){//Если указатель не null. то...
                        lsvNaideno.focus = true//Фокус на Найдено
                        root.pmpDoc.searchModel.currentResult = tmdResult.index//Задаём № поиска
                    }
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
                    onTriggered: {//Когда таймер отработает, то...
                        if (root.pmpDoc){//Если не null, то...
                            lsvNaideno.focus = true//Фокус на Найдено
                            root.pmpDoc.searchModel.currentResult = 0//Переход на первый
                        }
                    }
                }
            }
        }
    }
    Rectangle {//Вкладка "Закладки"
        id: rctZakladki
        //Свойства
        readonly property int heightScrollBar: 16//Высота горизонтал скроллбара, который нарисуем снизу панели
        //Настройки
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        width: rctSidebar.width
        height: rctSidebar.height
        color: root.clrFona
        clip: true//обрезаем всё, что выходит за прямоугольник
        visible: currentIndex === 1//показываем, только когда выбрана вкладка "Закладки"
        //Функции
        Text {//Сообщение "Нет закладок", если модель пуста
            id:txtZakladki
            anchors.left: rctZakladki.left
            anchors.right: rctZakladki.right
            anchors.verticalCenter: rctZakladki.verticalCenter
            color: root.clrMenuFon
            font.pixelSize: root.ntWidth * root.ntCoff//размер шрифта текста.
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight//Обрезаем текст по правой стороне точками (...)
            text: qsTr("Нет закладок")//Нет закладок
        }
        TreeView {
            id: trvZakladki
            //Свойства
            property int currentIndex: -1//Хранит индекс той закладки, который мы выбрали, кликнув на неё.
            property bool isIndikator: false//true - индикатор треугольник нажат хоть один раз.
            property real horizontalOffset: 0//Гориз. сдвиг всех строк меняется при движении гориз. ScrollBar.
            property real maxHorizontalOffset: 0//Маx"хвост"по X среди всех строк который вылез за правый край
            //Настройки
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: rctZakladki.heightScrollBar//Для полоски под горизонтальный ScrollBar
            //Функции
            columnWidthProvider: function(column) { return width }//Ширин единственного столбца=ширинаTreeView
            ScrollBar.vertical: ScrollBar { }//Вертикальный ScrollBar TreeView по умолчанию
            KeyNavigation.tab: tbbZakladki//Tab -> кнопка "Закладки"
            Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event
                if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
                    if(event.key === Qt.Key_B){//Если нажата клавиша B
                        dcSidebar.close()//Закрываем боковую панель
                        event.accepted = true//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_T){//Если нажата клавиша T
                        fnPosterOpen()//Открытие боковой панели на Миниатюрах.
                        event.accepted = true//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F){//Если нажата клавиша F
                        fnNaidenoOpen()//Функция открытия и фокусировки Найдено
                        root.clickedPoisk()//Сигнал нажатия на кнопку поиск.
                        event.accepted = true//Завершаем обработку эвента.
                    }
                } else if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                    if (event.key === Qt.Key_F){//Если нажата клавиша F, то...
                        fnNaidenoOpen()//Функция открытия боковой панели на Найдено.
                        event.accepted = true//Завершаем обработку эвента.
                    }
                } else if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                    if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                        if(root.pmpDoc.searchModel.count)//Если не 0, то...
                            root.pmpDoc.searchModel.currentResult -= 1//Предыдущий результат
                        event.accepted = true//Завершаем обработку эвента.
                    }
                } else {
                    if((event.key===Qt.Key_Enter)||(event.key===Qt.Key_Return)||(event.key===Qt.Key_Space)){
                        if(!isIndikator)//Если индикатор треугольник не был нажат, то...
                            if(trvZakladki.focus) fnGoToZakladka(currentIndex)//Переходим на страницу
                        event.accepted = true//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F3){//Если нажата кнопка F3,то..
                        if(root.pmpDoc.searchModel.count)//Если не 0, то...
                            root.pmpDoc.searchModel.currentResult += 1//Следующий результат
                        event.accepted = true//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_Up){//нажата "Стрелка вверх",то
                        if(!isIndikator)//Если индикатор треугольник не был нажат, то...
                            currentIndex = Math.max(0, currentIndex - 1)
                        event.accepted = true//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_Down){//нажата "Стрелка вниз"
                        if(!isIndikator)//Если индикатор треугольник не был нажат, то...
                            currentIndex = Math.min(pdfBookmarkModel.rowCount()-1, currentIndex + 1)
                        event.accepted = true//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F1){//Если нажата клавиша F1
                        fnClickedInfo();//Функция нажатия клавиши Информация.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
            function fnGoToZakladka(index){//Переход к закладке по индексу (используется клавишами/мышью)
                if (index < 0) return//Если индекс меньше нуля, выходим из функции.
                const modelIndex = pdfBookmarkModel.index(index, 0)//Получаем модель закладки по индексу.
                if (!modelIndex.valid) return//Если модель не действительна, выходим из функции.
                const page = pdfBookmarkModel.data(modelIndex, PdfBookmarkModel.Page)//Получаем Страницу
                const location = pdfBookmarkModel.data(modelIndex, PdfBookmarkModel.Location)//Координаты
                root.pmpDoc.goToLocation(page, location, root.pmpDoc.renderScale)//Переходим на страницу
            }
            onCurrentIndexChanged: {//При смене currentIndex скроллим TreeView, чтобы выбранная строка видна
                if(currentIndex >= 0 && currentIndex < pdfBookmarkModel.rowCount()){//Если индекс в габаритах
                    const modelIndex = pdfBookmarkModel.index(currentIndex, 0)//Получаем модель конкр.закладки
                    if (modelIndex.valid)//Если эта модель существует и она действительная
                        positionViewAtIndex(modelIndex, TreeView.Contain)//Делаем ВИДИМОЙ вкладку. Скроллим.
                }
            }
            delegate: TreeViewDelegate {//Делегат закладки, отдна строка в TreeView
                id: tvdZakladka
                //Свойства
                required property int page//Приходит из PdfBookmarkModel номер страницы
                required property point location//Приходит из PdfBookmarkModel координата закладки
                required property string title//Приходит из PdfBookmarkModel имя закладки
                required property int index //Приходит из PdfBookmarkModel индекс закладки
                readonly property int pixelShrift: (root.ntWidth<=2)
                                                    ? root.ntCoff*(root.ntWidth-1)
                                                    : root.ntCoff*(root.ntWidth-2)//Размер шрифта строки
                //Настройки
                implicitHeight: pixelShrift + root.ntCoff * 1.2//Высота строки—чуть больше шрифта (есть запас)
                text: title//Текст, который TreeViewDelegate ожидает показывать
                background: Rectangle {//Подложка строки (подсветка текущей/чётные-нечётные)
                    color: trvZakladki.currentIndex === tvdZakladka.index//Если индекс равен currentIndex
                           ? (trvZakladki.focus ? root.clrMenuFon//Если фокус на закладке, то цвет
                                                : Qt.darker(root.clrMenuFon, 1.3))//Если нет, то цвет темнее
                           : (tvdZakladka.row % 2 === 0 ? root.clrFona
                                                        : Qt.tint(root.clrFona, Qt.rgba(1, 1, 1, 0.11)))
                }
                contentItem: Item {//Всё содержимое строки (индикатор + текст) внутри contentItem
                    id: rowContent
                    //Свойства
                    readonly property real visibleWidth: width//Видимая ширина TreeView для одной колонки
                    readonly property real depthIndent: (tvdZakladka.depth ?? 0) * 16//Отступ лесенкой по глуб
                    readonly property real baseIndent: 4//Небольшой отступ слева, текст не прилипал к рамке
                    readonly property real leftIndent: baseIndent + depthIndent//Общий левый отступ
                    //Настройки
                    anchors.fill: parent
                    clip: true//обрезаем, чтобы текст не вылезал за правый край визуально
                    //Функции
                    function fnMaxOffset(){//Функция, которая обновляет глобальный maxHorizontalOffset
                        //fullWidth — как вы определяете полную ширину строки;
                        //visibleWidth — сколько реально видно по X;
                        //over = fullWidth - visibleWidth — сколько нужно ещё «прокрутить» вправо.
                        //Сейчас эти три величины считаются и используются для настройки maxHorizontalOffset и
                        //соответственно, поведения горизонтального ScrollBar.
                        //Полная логич.ширина строки=левый отступ(лесенка)+ширина содержимого(индикатор+текст)
                        const fullWidth = rowContent.leftIndent + tmContent.width
                        const visibleWidth = rowContent.visibleWidth//Видимая ширина строки (экран)
                        const over = fullWidth - visibleWidth//"Хвост"строки,который не помещается в видим обл
                        if (over > trvZakladki.maxHorizontalOffset)//Если этот "хвост" больше, чем то,что было
                            trvZakladki.maxHorizontalOffset = over//обновляем максимум
                    }
                    Item {//Весь контент строки, который мы будем сдвигать по X
                        id: tmContent
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        //lineContent.x = левый отступ - глобальный горизонтальный сдвиг
                        //при horizontalOffset=0 строка стоит на "естественном" месте (с лесенкой)
                        //при horizontalOffset>0 строка уезжает влево, открывая правый хвост текста
                        x: rowContent.leftIndent - trvZakladki.horizontalOffset
                        Item {//Индикатор разворота ▾ / ▸ слева от текста
                            id: tmIndicator
                            width: 22
                            height: parent.height
                            anchors.left: parent.left
                            visible: tvdZakladka.hasChildren
                            //Функции
                            Text {
                                anchors.centerIn: parent
                                text: tvdZakladka.expanded ? "\u25BE" : "\u25B8" // ▾ / ▸
                                color: root.clrTexta
                                font.pixelSize: tvdZakladka.pixelShrift
                            }
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: (mouse) => {
                                    if (!tvdZakladka.hasChildren) return//Если нет вложеных закладок, выходим.
                                    trvZakladki.focus = true//Фокус на Закладках
                                    if(trvZakladki.currentIndex !== tvdZakladka.index)//Если это другая вкладк
                                        trvZakladki.currentIndex = -1
                                    trvZakladki.toggleExpanded(tvdZakladka.index)//Разворач/сворачиваем заклад
                                    trvZakladki.isIndikator = true//Взводим флаг, отключаем горячие клавиши.
                                    mouse.accepted = true
                                }
                            }
                        }
                        Text {//Текст закладки
                            id: lblZakladka
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: tmIndicator.right
                            text: tvdZakladka.text
                            color: root.clrTexta
                            wrapMode: Text.NoWrap//Не переносим по словам, именно в одну строку
                            font.pixelSize: tvdZakladka.pixelShrift
                            verticalAlignment: Text.AlignVCenter
                        }
                        width: tmIndicator.width + lblZakladka.paintedWidth//Логич.ширина содержимого строки
                    }
                    Component.onCompleted: fnMaxOffset()//Когда делегат только создался — учитываем его вклад
                    onWidthChanged: fnMaxOffset()//При изменении ширины строки — обновляем вклад
                }
                indicator: null// Полностью отключаем встроенный индикатор TreeViewDelegate. Свой написал.
                onClicked: {//Клик по строке — перейти к закладке и, на мобильных, закрыть боковую панель
                    trvZakladki.currentIndex = tvdZakladka.index//Сохраняем индекс, который мы выбрали
                    if (root.pmpDoc) root.pmpDoc.goToLocation(page, location, root.pmpDoc.renderScale)//На Стр
                    if (root.isMobile) root.close()//Если мобила, то закрываем боковую панель
                }
            }
            model: PdfBookmarkModel {//Модель закладок PDF
                id: pdfBookmarkModel
                document: root.pdfDoc
                onModelReset: {//Если модель сбрасывается, или нажатие на Индикатор
                    trvZakladki.horizontalOffset = 0//Сбрасываем горизонтальный скролл
                    trvZakladki.maxHorizontalOffset = 0//Сбрасываем максимум при смене документа
                    hzScrollBar.position = 0//Позицию скроллбара
                    if (pdfBookmarkModel.rowCount() > 0){//Если закладки есть, то...
                        txtZakladki.text = "";//Удаляем сообщение "Нет закладок".
                        trvZakladki.currentIndex = 0//Подсвечиваем первую Зак
                    }
                    else trvZakladki.currentIndex = -1//Сбрасываем индекс, если нет ни одной закладки.
                }
            }
        }
        ScrollBar {//Горизонтальный ScrollBar внизу
            id: hzScrollBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: rctZakladki.heightScrollBar
            orientation: Qt.Horizontal
            //Показываем полосу, только если есть реальный "хвост" больше 2 пикселей
            policy: trvZakladki.maxHorizontalOffset > 2 ? ScrollBar.AsNeeded
                                                        : ScrollBar.AlwaysOff
            //Доля видимой части: чем больше maxHorizontalOffset, тем меньше size, тем "короче" ползунок
            size: trvZakladki.maxHorizontalOffset > 0
                  ? trvZakladki.width / (trvZakladki.width + trvZakladki.maxHorizontalOffset)
                  : 1.0
            onPositionChanged: {//При перемещ ползунка меняем horizontalOffset
                if (trvZakladki.maxHorizontalOffset > 0)
                    trvZakladki.horizontalOffset = trvZakladki.maxHorizontalOffset * position
                else trvZakladki.horizontalOffset = 0
            }
        }
    }
    Rectangle {//Вкладка "Страницы"
        id: rctPoster
        anchors.top: rctSidebar.top
        anchors.left: rctSidebar.left
        width: rctSidebar.width
        height: rctSidebar.height
        color: root.clrFona
        clip: true//Обязательно обрезать всё, что не помещается в этот прямоугольник.
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
            KeyNavigation.tab: tbbPoster//Tab -> кнопка "Страницы"
            Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event
                if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
                    if(event.key === Qt.Key_B){//Если нажата клавиша B
                        fnZakladkiOpen()//Открытие боковой панели на Закладки.
                        event.accepted = true;//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_T){//Если нажата клавиша T
                        dcSidebar.close()//Закрываем боковую панель
                        event.accepted = true;//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F){//Если нажата клавиша F
                        fnNaidenoOpen()//Функция открытия и фокусировки Найдено
                        root.clickedPoisk()//Сигнал нажатия на кнопку поиск.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                } else if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                    if (event.key === Qt.Key_F){//Если нажата клавиша F, то...
                        fnNaidenoOpen()//Функция открытия боковой панели на Найдено.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                } else if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                    if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                        if(root.pmpDoc.searchModel.count)//Если не 0, то...
                            root.pmpDoc.searchModel.currentResult -= 1//Предыдущий результат
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                } else{
                    if((event.key===Qt.Key_Enter)||(event.key===Qt.Key_Return)||(event.key===Qt.Key_Space)){
                        if(root.pmpDoc && grvPoster.model && grvPoster.focus)
                            root.pmpDoc.goToPage(currentIndex)
                        event.accepted = true;//Завер обработку эвента
                    } else if(event.key === Qt.Key_F3){//Если нажата кнопка F3,то..
                        if(root.pmpDoc.searchModel.count)//Если не 0, то...
                            root.pmpDoc.searchModel.currentResult += 1//Следующий результат
                        event.accepted = true;//Завершаем обработку эвента.
                    } else if(event.key === Qt.Key_F1){//Если нажата клавиша F1
                        fnClickedInfo();//Функция нажатия клавиши Информация.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
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
                    border.color: tmPoster.GridView.isCurrentItem ? (grvPoster.focus ? root.clrTexta
                                : Qt.darker(root.clrTexta, 1.3)) : "transparent"
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
                        grvPoster.focus = true//Фокус на страницах
                        grvPoster.currentIndex = index//Передаём выбранный индекс, для подсветки текста.
                        if(root.pmpDoc) root.pmpDoc.goToPage(index)//Переходим на страницу.
                        if(root.isMobile) root.close()//Если мобила, то закрываем боковую панель
                    }
                }
            }
        }
    }

    Rectangle {//Оконтовка поверх всех прямоугольников
        anchors.top: root.top
        anchors.right: rctSidebar.right
        height: root.height
        width: rctSidebar.width
        color: "transparent"
        border.color: root.clrTexta
        border.width: root.ntCoff/4
    }
}
