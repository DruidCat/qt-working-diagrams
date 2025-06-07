import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница отображающая Меню.
Item {
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
	property color clrFona: "black"
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
    property int ntLogoTMK: 16
    property bool pdfViewer: cppqml.blPdfViewer//true - включен собственный просмотрщик.
    property bool appRedaktor: cppqml.blAppRedaktor//true - включен Редактор приложения.
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedLogi();//Сигнал нажатия кнопки Логи.
	signal clickedWorkingDiagrams();//Сигнал нажатия кнопки об Рабочих Схемах.
    signal clickedQt();//Сигнал нажатия кнопки Об Qt.
    signal signalZagolovok(var strZagolovok);//Сигнал, когда передаём новую надпись в Заголовок.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    //Функции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            menuMenu.visible = false;//Делаем невидимым всплывающее меню.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: menuMenu.visible = false
    }
    onPdfViewerChanged: {//Если просмотрщик поменялся, то...
        cppqml.blPdfViewer = root.pdfViewer;//Отправляем в бизнес логику просмотрщик pdf документов.
    }
    onAppRedaktorChanged: {//Если Редактор изменился вкл/выкл, то...
        cppqml.blAppRedaktor = root.appRedaktor;//Отправляем в бизнес логику флаг редактора вкл/выкл.
    }
    function fnKatalog(){//Функция создания каталога pdf документов.
        console.error(cppqml.polKatalogSummu());//
        copyStart.visible = true;//Задаём вопрос: "Начать создание каталога?"
    }
    function fnZakrit(){//Функция закрыти страницы.
        menuMenu.visible = false;//Делаем невидимым меню.
        signalZagolovok(qsTr("МЕНЮ"));//Надпись в заголовке, чтоб при следующем открытии меню видеть заголовок
        root.clickedNazad();//Сигнал нажатия кнопки Назад.
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
                lgTMK.visible = true;//видимый логотип.
                ldrProgress.active = true;//Запускаем виджет загрузки
                flZona.visible = false;//невидимые кнопки меню.
                knopkaMenu.visible = false;//Делаем невидимым кнопку Меню.
            }
            else{//Если таймер выключен, то...
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
            id: knopkaZakrit
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
			onClicked: {
                if(tmrLogo.running){//Если запущен процесс создания каталогов документов, то...
                    copyStop.visible = true;//Задаём вопрос "Остановить создание каталога?"
                }
                else{//Если нет, то...
                    fnZakrit();//Закрываем окно Меню
                }
			}
		}
        DCVopros{
            id: copyStart
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

            text: qsTr("Начать создание каталога?")
            visible: false//Невидимый виджет

            clrFona: "yellow"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"
            onVisibleChanged: {//Защита от двойного срабатывания кнопок. Если изменился статус Видимости,то...
                if(visible){//Если видимый виджет, то...
                    knopkaZakrit.visible = false;//Конопка Закрыть Невидимая.
                    flZona.visible = false;//невидимые кнопки меню.
                    lgTMK.visible = true;//Видимый логотип.
                    knopkaMenu.visible = false;//Кнопка Меню не видимая.
                    root.signalToolbar("Начать процесс создения каталога документов?");//Вопрос.
                }
                else{//Если невидимый виджет, то...
                    knopkaZakrit.visible = true;//Конопка Закрыть Видимая.
                    flZona.visible = true;//видимые кнопки меню.
                    lgTMK.visible = false;//Невидимый логотип.
                    knopkaMenu.visible = true;//Кнопка Меню видимая.
                    root.signalToolbar("");//Пустое сообщение.
                }
            }
            onClickedOk: {//Слот нажатия кнопки Ок
                signalZagolovok(qsTr("ПРОЦЕСС СОЗДАНИЯ КАТАЛОГА"));//Надпись в заголовке
                copyStart.visible = false;//Делаем невидимый запрос с Вопросом начать создание каталога.
                tmrLogo.running = true;//Запустить анимацию Логотипа.
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

            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

            text: qsTr("Остановить создание каталога?")
            visible: false//Невидимый виджет

            clrFona: "red"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"
            onVisibleChanged: {//Защита от двойного срабатывания кнопок. Если изменился статус Видимости,то...
                if(visible){//Если видимый виджет, то...
                    knopkaZakrit.visible = false;//Конопка Закрыть Невидимая.
                    ldrProgress.item.text = qsTr("Остановить процесс создания каталога документов?")
                }
                else{//Если невидимый виджет, то...
                    knopkaZakrit.visible = true;//Конопка Закрыть Видимая.
                    if(ldrProgress.item)//Если загрузчик существует, то...
                        ldrProgress.item.text = ""//Удаляем сообщение в Загрузчике.
                }
            }
            onClickedOk: {//Слот нажатия кнопки Ок
                tmrLogo.running = false;//Останавливаем анимацию Логотипа.
                copyStop.visible = false;//Делаем невидимый запрос с Вопросом остановки создания каталога.
                fnZakrit();//Закрываем окно Меню
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
            anchors.fill: tmZona//Расстягиваемся по всей рабочей зоне
            contentWidth: tmZona.width//Ширина контента, который будет вложен равен ширине Рабочей Зоны
            contentHeight: (root.ntWidth*root.ntCoff+8+root.ntCoff)*6//6 - количество кнопок.

            Rectangle {//Прямоугольник, в которм будут собраны все кнопки.
                id: rctZona
                width: tmZona.width; height: flZona.contentHeight
                color: "transparent"

                DCKnopkaOriginal {
                    id: knopkaLogi
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: rctZona.top
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: qsTr("Логи")
                    bold: true; italic: true
                    onClicked: {
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedLogi();//Сигнал нажатия кнопки Логи.
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaAvtor
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaLogi.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: qsTr("О приложении")
                    bold: true; italic: true
                    onClicked: {
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedWorkingDiagrams();//Сигнал нажатия кнопки об приложении Рабочие Схемы.
                    }
                }
                /*
                DCKnopkaOriginal {
                    id: knopkaSpisok
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaAvtor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: qsTr("Участки")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        //Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
                        pvSpisok.visible ? pvSpisok.visible = false : pvSpisok.visible = true;
                    }
                }
                */
                DCKnopkaOriginal {
                    id: knopkaQt
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaAvtor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: qsTr("О Qt")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedQt();//Сигнал нажатия кнопки об Qt.
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaPdfViewer
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaQt.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: root.pdfViewer ? qsTr("ViewerPDF: вкл") : qsTr("ViewerPDF: выкл")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.pdfViewer ? root.pdfViewer = false : root.pdfViewer = true
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaRedaktor
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaPdfViewer.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: root.appRedaktor ? qsTr("Редактор: вкл") : qsTr("Редактор: выкл")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.appRedaktor ? root.appRedaktor = false : root.appRedaktor = true
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaKatalog
                    visible: {
                        if((Qt.platform.os === "android") || (Qt.platform.os === "ios"))//Мобильное устройство
                            return false;//невидимая кнопка.
                        else//Если это ПК, то...
                            root.appRedaktor ? true : false;//Показываем/Не_показываем кнопку из-за Редактора.
                    }
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaRedaktor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: qsTr("Создание каталога документов")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        fnKatalog();//Функция создания каталога pdf документов.
                    }
                }
            }
        }
        /*
        PathViewSpisok {
            id: pvSpisok
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.left: tmZona.left; anchors.right: tmZona.right; anchors.bottom: tmZona.bottom
            anchors.margins: root.ntCoff
            clrTexta: root.clrTexta; clrFona: "SlateGray"
            onSSpisok: function(strSpisok) {
                pvSpisok.visible = false;
                knopkaSpisok.text = strSpisok;
            }
        }
        */
        DCMenu {//Меню отображается в Рабочей Зоне приложения.
            id: menuMenu
            visible: false//Невидимое меню.
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.left: tmZona.left; anchors.right: tmZona.right; anchors.bottom: tmZona.bottom
            anchors.margins: root.ntCoff
            clrTexta: root.clrTexta; clrFona: "SlateGray"
            imyaMenu: "vihod"//Глянь в DCMenu все варианты меню в слоте окончательной отрисовки.
            onClicked: function(ntNomer, strMenu) {//Слот сигнала клика по пункту меню.
                menuMenu.visible = false;//Делаем невидимым меню.
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
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                menuMenu.visible ? menuMenu.visible = false : menuMenu.visible = true;//Изменяем видимость
            }
        }
	}
}
