import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница отображающая Меню.
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
    property int ntLogoTMK: 16
    property bool pdfViewer: cppqml.blPdfViewer//true - включен собственный просмотрщик.
    property bool appRedaktor: cppqml.blAppRedaktor//true - включен Редактор приложения.
    property int untShrift: cppqml.untShrift//0-мал, 1-сред, 2-большой.
    property bool isMobile: true;//true - мобильная платформа.
    property real rlLoader: 1//Коэффициент загрузчика.
    property real rlProgress: 0//Прогресс загрузчика.
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    focus: true;//Чтоб работали горячие клавиши.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedInfo();//Сигнал нажатия кнопки Информация
    signal clickedLogi();//Сигнал нажатия кнопки Логи.
    signal clickedMentor();//Сигнал нажатия кнопки об Менторе.
	signal clickedHotKey();//Сигнал о нажатии кнопки Горячие Клавиши.
    signal clickedQt();//Сигнал нажатия кнопки Об Qt.
    signal clickedAnimaciya();//Сигнал нажития кнопки Анимация.
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
        anchors.fill: root
        onClicked: fnClickedEscape()//Функция нажатия кнопки Escape
    }
    onPdfViewerChanged: {//Если просмотрщик поменялся, то...
        cppqml.blPdfViewer = root.pdfViewer;//Отправляем в бизнес логику просмотрщик pdf документов.
    }
    onAppRedaktorChanged: {//Если Редактор изменился вкл/выкл, то...
        cppqml.blAppRedaktor = root.appRedaktor;//Отправляем в бизнес логику флаг редактора вкл/выкл.
    }
    onUntShriftChanged: {//Если размер Шрифта изменится, то...
        cppqml.untShrift = root.untShrift;//Отправляем в бизнес логику размер Шрифта.
    }

    function fnClickedEscape() {//Функция нажатия кнопки Escape
        root.focus = true;//Чтоб горячие клавиши работали.
        menuMenu.visible = false
    }
    function fnClickedInfo(){//Функция нажатия кнопки Информация
        cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
        root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
    }
    function fnKatalog(){//Функция создания каталога pdf документов. 
        signalZagolovok(qsTr("ПРОЦЕСС СОЗДАНИЯ КАТАЛОГА"));//Надпись в заголовке
        copyStart.visible = false;//Делаем невидимый запрос с Вопросом начать создание каталога.
        tmrLogo.running = true;//Запустить анимацию Логотипа.
        root.rlProgress = 0;//Обнуляем линию прогресса.
        root.rlLoader = 100/cppqml.polKatalogSummu();//Считаем коэффициент загрузчика, на который он увелич.
        cppqml.copyKatalogStart();//Начинаем создание каталога
    }
    Connections {//Соединяем сигнал из C++ с действием в QML, перерисовываем, в зависимости от Элемента.
        target: cppqml;//Цель объект класса С++ DCCppQml
        function onBlKatalogStatusChanged(){//Слот Если изменился статус создания каталога(Q_PROPERTY), то...
            if(!cppqml.blKatalogStatus){//Если статус false, то ...
                signalZagolovok(qsTr("МЕНЮ"));//Надпись в заголовке
                tmrLogo.running = false;//Останавливаем анимацию Логотипа.
            }
        }
        function onUntKatalogCopyChanged(){//Слот счётчика скопированных документов в каталоге.
            root.rlProgress += root.rlLoader;//Увеличиваем на root.ntLoader.
            if(ldrProgress.item)
                ldrProgress.item.progress = root.rlProgress;//Отправляем прогресс загрузки в DCProgress.
            if(ldrProgress.item)
                ldrProgress.item.text = cppqml.untKatalogCopy;//Выводим номер копируемого документа.
        }
    }
    function fnClickedVpered(){//Функция закрыти страницы.
        if(tmrLogo.running)//Если запущен процесс создания каталогов документов, то...
            copyStop.visible = true;//Задаём вопрос "Остановить создание каталога?"
        else{//Если нет, то...
            fnClickedEscape()//Функция нажатия кнопки Escape
            signalZagolovok(qsTr("МЕНЮ"));//Надпись в заголовке, чтоб при следующем открытии меню видеть заголовок
            root.clickedNazad();//Сигнал нажатия кнопки Назад.
        }
    }
    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 110; running: false; repeat: true
        property bool blLogoTMK: false
        onTriggered: {
            if(blLogoTMK){//Если true, то...
                lgTMK.ntCoff++;
                if(lgTMK.ntCoff >= root.ntLogoTMK)
                    blLogoTMK = false;
            }
            else{
                lgTMK.ntCoff--;
                if(lgTMK.ntCoff <= 1)
                    blLogoTMK = true;
            }
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                knopkaInfo.visible = false;//Невидимая кнопка информации.
                lgTMK.visible = true;//видимый логотип.
                ldrProgress.active = true;//Запускаем виджет загрузки
                flZona.visible = false;//невидимые кнопки меню.
                knopkaMenu.visible = false;//Делаем невидимым кнопку Меню.
            }
            else{//Если таймер выключен, то...
                knopkaInfo.visible = true;//Видимая кнопка информации.
                lgTMK.ntCoff = root.ntLogoTMK;//Задаём размер логотипа.
                lgTMK.visible = false;//Невидимый логотип.
                ldrProgress.active = false;//Отключаем прогресс.
                flZona.visible = true;//видимые кнопки меню.
                knopkaMenu.visible = true;//Делаем видимым кнопку Меню.
            }
        }
    }
	Item {
		id: tmZagolovok
        DCKnopkaVpered{
            id: knopkaVpered
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedVpered();//Закрываем окно Меню
		}
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedInfo();//Функция нажатия на кнопку Информации.
        }
        DCVopros{
            id: copyStart
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

            text: qsTr("Начать создание каталога?")
            visible: false//Невидимый виджет

            clrFona: "yellow"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"

            tapKnopkaZakrit: root.tapZagolovokLevi; tapKnopkaOk: root.tapZagolovokPravi
            onVisibleChanged: {//Защита от двойного срабатывания кнопок. Если изменился статус Видимости,то...
                if(visible){//Если видимый виджет, то...
                    knopkaInfo.visible = false;//Невидимая кнопка информации.
                    knopkaVpered.visible = false;//Конопка Закрыть Невидимая.
                    flZona.visible = false;//невидимые кнопки меню.
                    lgTMK.visible = true;//Видимый логотип.
                    knopkaMenu.visible = false;//Кнопка Меню не видимая.
                    root.signalToolbar("Начать процесс создения каталога документов?");//Вопрос.
                }
                else{//Если невидимый виджет, то...
                    knopkaInfo.visible = true;//Видимая кнопка информации.
                    knopkaVpered.visible = true;//Конопка Закрыть Видимая.
                    flZona.visible = true;//видимые кнопки меню.
                    lgTMK.visible = false;//Невидимый логотип.
                    knopkaMenu.visible = true;//Кнопка Меню видимая.
                    root.signalToolbar("");//Пустое сообщение.
                }
            }
            onClickedOk: {//Слот нажатия кнопки Ок
                fnKatalog();//Функция создания каталога pdf документов.
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены
                copyStart.visible = false;//Делаем невидимый запрос с Вопросом начать создание каталога.
            }
        }
        DCVopros{
            id: copyStop
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

            text: qsTr("Остановить создание каталога?")
            visible: false//Невидимый виджет

            clrFona: "red"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"

            tapKnopkaZakrit: root.tapZagolovokLevi; tapKnopkaOk: root.tapZagolovokPravi
            onVisibleChanged: {//Защита от двойного срабатывания кнопок. Если изменился статус Видимости,то...
                if(visible){//Если видимый виджет, то...
                    knopkaInfo.visible = false;//Невидимая кнопка информации.
                    knopkaVpered.visible = false;//Конопка Закрыть Невидимая.
                    ldrProgress.item.text = qsTr("Остановить процесс создания каталога документов?")
                }
                else{//Если невидимый виджет, то...
                    knopkaInfo.visible = true;//Видимая кнопка информации.
                    knopkaVpered.visible = true;//Конопка Закрыть Видимая.
                    if(ldrProgress.item)//Если загрузчик существует, то...
                        ldrProgress.item.text = ""//Удаляем сообщение в Загрузчике.
                }
            }
            onClickedOk: {//Слот нажатия кнопки Ок
                tmrLogo.running = false;//Останавливаем анимацию Логотипа.
                copyStop.visible = false;//Делаем невидимый запрос с Вопросом остановки создания каталога.
                fnClickedVpered();//Закрываем окно Меню ТОЛЬКО ПОСЛЕ tmrLogo.running = false
                cppqml.strDebug = qsTr("Принудительная остановка создания каталога документов.");
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены
                copyStop.visible = false;//Делаем невидимый запрос на удаление.
            }
        }
	}  
    Item {
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCLogoTMK {//Логотип до flZona, чтоб не перекрывать список.
            id: lgTMK
            ntCoff: root.ntLogoTMK
            anchors.centerIn: tmZona
            visible: false
            clrLogo: root.clrTexta; clrFona: root.clrFona
        }
        Flickable {//Рабочая Зона скроллинга
            id: flZona
            property int kolichestvoKnopok: 9
            anchors.fill: tmZona//Расстягиваемся по всей рабочей зоне
            contentWidth: tmZona.width//Ширина контента, который будет вложен равен ширине Рабочей Зоны
            contentHeight: (root.ntWidth*root.ntCoff+8+root.ntCoff)*kolichestvoKnopok//9 - количество кнопок.
            TapHandler {//Нажимаем не на Кнопки, а на пустую область.
                //ВАЖНО, срабатывает и при нажатии на кнопки!!! Сменяет фокус на root при нажатии на кнопки.
                onTapped: fnClickedEscape();//Функция нажатия кнопки Escape.
            }
            Rectangle {//Прямоугольник, в которм будут собраны все кнопки.
                id: rctZona
                width: tmZona.width; height: flZona.contentHeight
                color: "transparent"

                DCKnopkaOriginal {
                    id: knopkaPdfViewer
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: rctZona.top
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: root.pdfViewer ? qsTr("viewerPDF: вкл") : qsTr("viewerPDF: выкл")
                    opacityKnopki: 0.8
                    onClicked: root.pdfViewer ? root.pdfViewer = false : root.pdfViewer = true
                }
                DCKnopkaOriginal {
                    id: knopkaHotKey
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaPdfViewer.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("горячие клавиши")
                    opacityKnopki: 0.8
                    onClicked: root.clickedHotKey();//Сигнал нажатия кнопки Горячие клавиши.
                    Component.onCompleted:{//Когда отрисуется Кнопка, то...
                        if(root.isMobile){//Если мобильная платформа, то...
                            flZona.kolichestvoKnopok -= 1;//Удаляем -1 кнопку идущую на Горячие клавиши.
                            visible = false;//В мобильной платформе делаем эту кнопку невидимой.
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaFont
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: {
                        if(root.isMobile)//Если мобильная платформа, то...
                            return knopkaRedaktor.bottom
                        else//Если не мобильная платформа, то...
                            return knopkaHotKey.bottom
                    }
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
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
                    onClicked: {//Слот запускающий
                        //Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
                        if(pvShrift.visible)//Если видимый виджет, то...
                            pvShrift.visible = false//Делаем невидимым виджет
                        else{//Если невидимый виджет, то...
                            pvShrift.visible = true//Делаем видимым виджет
                            Qt.callLater(function () {//Делаем паузу на такт, иначе не сработает фокус.
                                pvShrift.karusel.forceActiveFocus()//фокус PathView, чтоб hotkey работали.
                            })
                        }
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaAnimaciya
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaFont.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("анимация")
                    opacityKnopki: 0.8
                    onClicked: root.clickedAnimaciya();//Сигнал нажатия кнопки Анимация.
                }
                DCKnopkaOriginal {
                    id: knopkaLogi
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaAnimaciya.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("логи")
                    opacityKnopki: 0.8
                    onClicked: root.clickedLogi();//Сигнал нажатия кнопки Логи.
                }
                DCKnopkaOriginal {
                    id: knopkaAvtor
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaLogi.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("о приложении")
                    opacityKnopki: 0.8
                    onClicked: root.clickedMentor();//Сигнал нажатия кнопки об приложении Ментор.
                }
                DCKnopkaOriginal {
                    id: knopkaQt
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaAvtor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("о Qt")
                    opacityKnopki: 0.8
                    onClicked: root.clickedQt();//Сигнал нажатия кнопки об Qt.
                }
                DCKnopkaOriginal {
                    id: knopkaRedaktor
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaQt.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: root.appRedaktor ? qsTr("редактор: вкл") : qsTr("редактор: выкл")
                    opacityKnopki: 0.8
                    onClicked: root.appRedaktor ? root.appRedaktor = false : root.appRedaktor = true
                }
                DCKnopkaOriginal {
                    id: knopkaKatalog
                    visible: {
                        if(root.isMobile)//Мобильное устройство
                            return false;//невидимая кнопка.
                        else//Если это ПК, то...
                            root.appRedaktor ? true : false;//Показываем/Не_показываем кнопку из-за Редактора.
                    }
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaRedaktor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
                    text: qsTr("создание каталога документов")
                    opacityKnopki: 0.8
                    onClicked: copyStart.visible = true;//Задаём вопрос: "Начать создание каталога?"
					Component.onCompleted: {
						if(root.isMobile)//Мобильное устройство
							flZona.kolichestvoKnopok -= 1;//Удаляем -1 кнопку идущую на Создание каталога.
					}
                }
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
            anchors.margins: root.ntCoff
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
            anchors.margins: root.ntCoff
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
        clip: true//Обрезаем загрузчик, который выходит за границы toolbar
        Loader {//Loader Прогресса загрузки pdf документа
            id: ldrProgress
            anchors.fill: tmToolbar
            source: "qrc:/qml/DCMethods/DCProgress.qml"//Указываем путь к отдельному QMl
            active: false//не активирован.
            onLoaded: {//Когда загрузчик загрузился, передаём свойства в него.
                ldrProgress.item.ntWidth = root.ntWidth; ldrProgress.item.ntCoff = root.ntCoff;
                ldrProgress.item.clrProgress = root.clrTexta; ldrProgress.item.clrTexta = "grey";
            }
        }
        DCKnopkaNastroiki {//Кнопка Меню.
            id: knopkaMenu
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.right: tmToolbar.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                menuMenu.visible ? menuMenu.visible = false : menuMenu.visible = true;//Изменяем видимость
            }
        }
	}
}
