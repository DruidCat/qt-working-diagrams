import QtQuick //2.15
import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//StrMenu.qml - Страница отображающая Меню.
Item {
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "Orange"
	property color clrFona: "Black"
    property color clrMenuText: "Orange"
	property color clrMenuFon: "SlateGray"
	property alias zagolovokX: tmZagolovok.x
	property alias zagolovokY: tmZagolovok.y
	property alias zagolovokWidth: tmZagolovok.width
	property alias zagolovokHeight: tmZagolovok.height
	property alias zonaX: tmZona.x
	property alias zonaY: tmZona.y
	property alias zonaWidth: tmZona.width
	property alias zonaHeight: tmZona.height
	property alias toolbarX: tmToolbar.x
	property alias toolbarY: tmToolbar.y
	property alias toolbarWidth: tmToolbar.width
	property alias toolbarHeight: tmToolbar.height
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property bool pdfMentor: cppqml.blPdfMentor//true - включен собственный просмотрщик.
    property bool appRedaktor: cppqml.blAppRedaktor//true - включен Редактор приложения.
    property bool isAdmin: false;//НЕ ИЗМЕНЯТЬ ЭТОТ ФЛАГ.
    property int untShrift: cppqml.untShrift//0-мал, 1-сред, 2-большой.
    property bool isMobile: true;//true - мобильная платформа.
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    focus: true;//Чтоб работали горячие клавиши.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedInfo();//Сигнал нажатия кнопки Информация
    signal clickedHotKey();//Сигнал о нажатии кнопки Горячие Клавиши.
    signal clickedAnimaciya();//Сигнал нажития кнопки Анимация.
    signal clickedLogi();//Сигнал нажатия кнопки Логи.
    signal clickedMentor();//Сигнал нажатия кнопки об Менторе.
    signal clickedQt();//Сигнал нажатия кнопки Об Qt.
    signal clickedKatalog();//Сигнал нажатия кнопки Создание каталога документов.
    signal signalZagolovok(var strZagolovok);//Сигнал, когда передаём новую надпись в Заголовок.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    //Функции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
            if (event.key === Qt.Key_Right){//Если нажата клавиша стрелка вправо, то...
                if(knopkaVpered.visible)//Если кнопка Вперёд видимая, то...
                    fnClickedVpered();//Функция нажатия кнопки Вперёд
                event.accepted = true;//Завершаем обработку эвента.
            }
        }
        else{
            if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
                pvShrift.visible = false;//Невидимый выбор шрифта
                fnClickedEscape()//Функция нажатия кнопки Escape
            }
            else{//Если не Escape, то...
                if(event.key === Qt.Key_F1){//Если нажата кнопка F1, то...
                    if(knopkaInfo.visible)
                        fnClickedInfo();//Функция нажатия на кнопку Информация.
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmZagolovok
        onClicked: fnClickedEscape()//Функция нажатия кнопки Escape
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmToolbar
        onClicked: fnClickedEscape()//Функция нажатия кнопки Escape
    }
    onPdfMentorChanged: {//Если просмотрщик поменялся, то...
        cppqml.blPdfMentor = root.pdfMentor;//Отправляем в бизнес логику просмотрщик pdf документов.
    }
    onAppRedaktorChanged: {//Если Редактор изменился вкл/выкл, то...
        cppqml.blAppRedaktor = root.appRedaktor;//Отправляем в бизнес логику флаг редактора вкл/выкл.
    }
    onUntShriftChanged: {//Если размер Шрифта изменится, то...
        cppqml.untShrift = root.untShrift;//Отправляем в бизнес логику размер Шрифта.
    }
    function fnClickedEscape() {//Функция нажатия кнопки Escape
        if(pvShrift.visible)//Если видимый выбор шрифта, то...
            pvShrift.visible = false;//Делаем невидимым выбор шрифта.
        root.focus = true;//Чтоб горячие клавиши работали.
        menuMenu.visible = false
    }
    function fnClickedInfo(){//Функция нажатия кнопки Информация
        cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
        root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
    }
    function fnClickedVpered(){//Функция закрыти страницы.
        fnClickedEscape()//Функция нажатия кнопки Escape
        signalZagolovok(qsTr("МЕНЮ"));//Надпись в заголовке, чтоб при следующем открытии меню видеть заголовок
        root.clickedNazad();//Сигнал нажатия кнопки Назад.
    } 
	Item {
		id: tmZagolovok
        DCKnopkaVpered{
            id: knopkaVpered
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedVpered();//Закрываем окно Меню
		}
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedInfo();//Функция нажатия на кнопку Информации.
        } 
	}  
    Item {
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно. 
        Flickable {//Рабочая Зона скроллинга
            id: flZona
            property int kolichestvoKnopok: rctZona.children.length//Количество детей прямоуголиника rctZona
            anchors.fill: tmZona//Расстягиваемся по всей рабочей зоне
            contentWidth: tmZona.width//Ширина контента, который будет вложен равен ширине Рабочей Зоны
            contentHeight: (knopkaQt.height+root.ntWidth)*kolichestvoKnopok//9 - количество кнопок.
            TapHandler {//Нажимаем не на Кнопки, а на пустую область.
                //ВАЖНО, срабатывает и при нажатии на кнопки!!! Сменяет фокус на root при нажатии на кнопки.
                onPressedChanged: {//Если изменён статус зажатия кнопки, то...
                    if(pressed && !pvShrift.pressed)//Если нажата область и не нажато на pvShrift, то...
                        fnClickedEscape();//Функция нажатия кнопки Escape.
                }
            }
            Rectangle {//Прямоугольник, в которм будут собраны все кнопки.
                id: rctZona
                width: tmZona.width; height: flZona.contentHeight
                color: "transparent"

                DCKnopkaOriginal {
                    id: knopkaMentorPDF
                    visible: root.isAdmin ? true : false;//Показать/не показать в зависимости от Админа.
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: rctZona.top
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: root.pdfMentor ? qsTr("менторPDF: вкл") : qsTr("менторPDF: выкл")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed)//Если нажата кнопка и не нажато на pvShrift, то...
                            root.pdfMentor ? root.pdfMentor = false : root.pdfMentor = true
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaHotKey
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: root.isAdmin ? knopkaMentorPDF.bottom : rctZona.top
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("горячие клавиши")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            fnClickedEscape()//Закрываем выбор шрифта и меню открытое.
                            root.clickedHotKey();//Сигнал нажатия кнопки Горячие клавиши.
                        }
                    }
                    Component.onCompleted:{//Когда отрисуется Кнопка, то...
                        if(root.isMobile){//Если мобильная платформа, то...
                            flZona.kolichestvoKnopok -= 1;//Удаляем -1 кнопку идущую на Горячие клавиши.
                            visible = false;//В мобильной платформе делаем эту кнопку невидимой.
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaShrift
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: {
                        if(root.isMobile)//Если мобильная платформа, то...
                            return knopkaMentorPDF.bottom
                        else//Если не мобильная платформа, то...
                            return knopkaHotKey.bottom
                    }
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: {
                        let ltShrift = qsTr("шрифт ");//
                        if(root.untShrift === 0)
                            ltShrift = ltShrift + qsTr("маленький")
                        else
                            if(root.untShrift === 1)
                                ltShrift = ltShrift + qsTr("средний")
                            else
                                ltShrift = ltShrift + qsTr("большой")
                        pvShrift.currentIndex = root.untShrift
                        return ltShrift;
                    }
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        //Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            if(pvShrift.visible)//Если видимый виджет, то...
                                pvShrift.visible = false//Делаем невидимым виджет
                            else{//Если невидимый виджет, то...
                                Qt.callLater(function(){//пауза, иначе не сработает фокус и pvShrift. ВАЖНО!!!
                                    pvShrift.visible = true//Делаем видимым виджет
                                    pvShrift.karusel.forceActiveFocus()//фокус PathView, чтоб hotkey работали.
                                })
                            }
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaAnimaciya
                    visible: root.isAdmin ? true : false;//показать/не показать в зависимости от Админа.
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaShrift.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right 
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("анимация")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            fnClickedEscape()//Закрываем выбор шрифта и меню открытое.
                            root.clickedAnimaciya();//Сигнал нажатия кнопки Анимация.
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaJurnal
                    visible: root.isAdmin ? true : false;//показать/не показать в зависимости от Админа.
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaAnimaciya.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("журнал")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            fnClickedEscape()//Закрываем выбор шрифта и меню открытое.
                            root.clickedLogi();//Сигнал нажатия кнопки Логи.
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaAvtor
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: root.isAdmin ? knopkaJurnal.bottom : knopkaShrift.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("о приложении")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            fnClickedEscape()//Закрываем выбор шрифта и меню открытое.
                            root.clickedMentor();//Сигнал нажатия кнопки об приложении Ментор.
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaQt
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaAvtor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("о Qt")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            fnClickedEscape()//Закрываем выбор шрифта и меню открытое.
                            root.clickedQt();//Сигнал нажатия кнопки об Qt.
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaRedaktor
                    visible: root.isAdmin ? true : false//Показываем/не показываем в зависимости от Админа.
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaQt.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: root.appRedaktor ? qsTr("редактор: вкл") : qsTr("редактор: выкл")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed)//Если нажата кнопка и не нажато на pvShrift, то...
                            root.appRedaktor ? root.appRedaktor = false : root.appRedaktor = true
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaKatalog
                    visible: {
                        if(root.isAdmin){//Если Администратор, то...
                            if(root.isMobile)//Мобильное устройство
                                return false;//невидимая кнопка.
                            else//Если это ПК, то...
                                root.appRedaktor ? true : false;//Показываем/Не_показываем кнопку из-за Редактора.
                        }
                        else//Если рабочий, то...
                            return false;
                    }
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaRedaktor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.topMargin: root.ntWidth
                    anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("создание каталога документов")
                    opacityKnopki: 0.8
                    onPressedChanged: {//Если изменилось состояние Нажать, то...
                        if (pressed && !pvShrift.pressed){//Если нажата кнопка и не нажато на pvShrift, то...
                            fnClickedEscape()//Закрываем выбор шрифта и меню открытое.
                            root.clickedKatalog();//Открываем страницу создания каталога документов.
                        }
                    }
                    Component.onCompleted: {
						if(root.isMobile)//Мобильное устройство
							flZona.kolichestvoKnopok -= 1;//Удаляем -1 кнопку идущую на Создание каталога.
					}
                }
            }
            DCScrollbar {//Скроллбар
                id: scbScrollbar
                //Настройки
                flick: flZona//Передаём объект Flickable
                anchors.right: rctZona.right
                anchors.top: rctZona.top
                anchors.bottom: rctZona.bottom
                clrPolzunokOff: Qt.lighter(root.clrMenuFon, 1.3)//Цвет ползунка, когда он не активен.
                clrPolzunokOn: root.clrTexta//оранжевый при наведении
                width: root.ntWidth * root.ntCoff
                radius: 1//Небольшой радиус
            }
        }
        ListModel {//Модель с шриштами
            id: modelShrift
            ListElement { spisok: qsTr("маленький") }
            ListElement { spisok: qsTr("средний") }
            ListElement { spisok: qsTr("большой") }
        }
        DCPathView {
            id: pvShrift
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.left: tmZona.left; anchors.right: tmZona.right; anchors.bottom: tmZona.bottom
            anchors.leftMargin: scbScrollbar.width; anchors.rightMargin: scbScrollbar.width
            clrFona: root.clrFona; clrTexta: root.clrMenuText; clrMenuFon: root.clrMenuFon
            modelData: modelShrift
            onClicked: function(strShrift) {
                pvShrift.visible = false;
                root.untShrift = pvShrift.currentIndex;//Приравниваем значение к переменной.
            }
        }
        DCMenu {//Меню отображается в Рабочей Зоне приложения.
            id: menuMenu
            visible: false//Невидимое меню.
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.left: tmZona.left; anchors.right: tmZona.right; anchors.bottom: tmZona.bottom
            anchors.bottomMargin: root.ntWidth; anchors.rightMargin: scbScrollbar.width
            pctFona: 0.90//Прозрачность фона меню.
            clrTexta: root.clrMenuText; clrFona: root.clrMenuFon 
            imyaMenu: "vihod"//Глянь в DCMenu все варианты меню в слоте окончательной отрисовки.
            onClicked: function(ntNomer, strMenu) {//Слот сигнала клика по пункту меню.
                if(ntNomer === 1){//Выход
                    Qt.quit();//Закрыть приложение.
                }
            }
        }
	}
    Item {//Тулбар
		id: tmToolbar
        DCKnopkaNastroiki {//Кнопка Меню.
            id: knopkaMenu
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.right: tmToolbar.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                if(menuMenu.visible)//Если меню видимое, то...
                    menuMenu.visible = false;//То делаем меню невидимым.
                else {//Если меню невидимое, то...
                    pvShrift.visible = false;//Делаем невидимым выбор размера Шрифта
                    menuMenu.visible = true;//Изменяем видимость
                }
            }
        }
	}
}
