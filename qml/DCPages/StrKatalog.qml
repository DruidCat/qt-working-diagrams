import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница создающая каталог документов.
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
    property real rlLoader: 1//Коэффициент загрузчика.
    property real rlProgress: 0//Прогресс загрузчика.
    property int logoRazmer: 22//Размер Логотипа.
    property string logoImya: "mentor"//Имя логотипа в DCLogo
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
	focus: true//Обязательно, иначе на Андроид экранная клавиатура не открывается.
    //Сигналы.
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedInfo();//Сигнал  нажатия кнопки Инструкция.
    signal signalZagolovok(var strZagolovok);//Сигнал, когда передаём новую надпись в Заголовок.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    //Функции. 
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event => 
        if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
            if (event.key === Qt.Key_Left){//Если нажата клавиша стрелка влево, то...
                if(knopkaNazad.visible)//Если кнопка Назад видимая, то...
                    fnClickedNazad();//Функция нажатия кнопки Назад
                event.accepted = true;//Завершаем обработку эвента.
            }
        }
        else{
            if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
                event.accepted = true;//Завершаем обработку эвента.
            }
            else{
                if(event.key === Qt.Key_F1){//Если нажата кнопка F1, то...
                    if(knopkaInfo.visible)
                        fnClickedInfo();//Функция нажатия на кнопку Информация.
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
        }
        //cppqml.strDebug = event.key;
    } 
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: {
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
	function fnClickedEscape(){//Функция нажатия кнопки Escape.
        copyStart.visible = false;//Делаем невидимый Вопрос "начать создание каталога".
        menuSpisok.visible = false;//Делаем невидимым всплывающее меню. 
    }
    function fnClickedNazad() {//Функция нажатия кнопки Назад.
        if(tmrLogo.running)//Если запущен процесс создания каталогов документов, то...
            copyStop.visible = true;//Задаём вопрос "Остановить создание каталога?"
        else{//Если нет, то...
            txdZona.text = txdZona.strCopy = "";//Отображаем пустую строку в TextEdit модуле.
            fnClickedEscape()//Функция нажатия кнопки Escape
            signalZagolovok(qsTr("СОЗДАНИЕ КАТАЛОГА ДОКУМЕНТОВ"));//при следующем открытии видеть заголовок.
            root.clickedNazad();//Сигнал нажатия кнопки Назад.
        }
    }
	function fnClickedInfo() {//Функция нажатия Информации.
		cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
		fnClickedEscape();//Функция нажатия кнопки Escape.
		root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
	}
    function fnClickedKatalog(){//Функция создания каталога pdf документов.
        txdZona.text = txdZona.strCopy = "";//Отображаем пустую строку в TextEdit модуле.
        signalZagolovok(qsTr("ПРОЦЕСС СОЗДАНИЯ КАТАЛОГА"));//Надпись в заголовке
        copyStart.visible = false;//Делаем невидимый запрос с Вопросом начать создание каталога.
        tmrLogo.running = true;//Запустить анимацию Логотипа.
        root.rlProgress = 0;//Обнуляем линию прогресса.
        root.rlLoader = 100/cppqml.polKatalogSummu();//Считаем коэффициент загрузчика, на который он увелич.
        cppqml.copyKatalogStart();//Начинаем создание каталога
    }
    function appendDebug(ltDebug) {
        var lines = txdZona.strCopy.split("\n")
        lines.push(ltDebug)
        if (lines.length > 1000)
            lines = lines.slice(lines.length - 1000)
        txdZona.strCopy = lines.join("\n")
        txdZona.text = txdZona.strCopy
    }
    Connections {//Соединяем сигнал из C++ с действием в QML, перерисовываем, в зависимости от Элемента.
        target: cppqml;//Цель объект класса С++ DCCppQml
        function onBlKatalogStatusChanged(){//Слот Если изменился статус создания каталога(Q_PROPERTY), то...
            if(!cppqml.blKatalogStatus){//Если статус false, то ...
                signalZagolovok(qsTr("СОЗДАНИЕ КАТАЛОГА ДОКУМЕНТОВ"));//Надпись в заголовке
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
    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 110; running: false; repeat: true
        property bool blLogoTMK: false
        onTriggered: {
            if(blLogoTMK){//Если true, то...
                lgLogo.ntCoff++;
                if(lgLogo.ntCoff >= root.logoRazmer)
                    blLogoTMK = false;
            }
            else{
                lgLogo.ntCoff--;
                if(lgLogo.ntCoff <= 1)
                    blLogoTMK = true;
            }
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                lgLogo.visible = true;//видимый логотип.
                ldrProgress.active = true;//Запускаем виджет загрузки
                knopkaInfo.visible = false;//Невидимая кнопка информации.
                knopkaNastroiki.visible = false;//Невидимая кнопка настройки.
                knopkaStart.visible = false;//Невидимая кнопка Старт.
            }
            else{//Если таймер выключен, то...
                lgLogo.ntCoff = root.logoRazmer;//Задаём размер логотипа.
                lgLogo.visible = false;//Невидимый логотип.
                ldrProgress.active = false;//Отключаем прогресс.
                knopkaInfo.visible = true;//Видимая кнопка информации.
                knopkaNastroiki.visible = true;//Видимая кнопка настройки.
                knopkaStart.visible = true;//Видимая кнопка Старт.
                txdZona.textEdit.focus = true;//Чтоб работало событие клавишь Листания и всех остальных клавиш
            }
        }
    }
    Item {//Данные Заголовок
        id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад.
        }
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
			onClicked: fnClickedInfo();//Функция нажатия Информации. 
        } 
        DCVopros{
            id: copyStart
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.top: tmZagolovok.top; anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left; anchors.right: tmZagolovok.right

            text: qsTr("Начать создание каталога?")
            visible: false//Невидимый виджет

            clrFona: "yellow"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"

            tapKnopkaZakrit: root.tapZagolovokLevi; tapKnopkaOk: root.tapZagolovokPravi
            onVisibleChanged: {//Защита от двойного срабатывания кнопок. Если изменился статус Видимости,то...
                if(visible){//Если видимый виджет, то...
                    txdZona.text = txdZona.strCopy = "";//Отображаем пустую строку в TextEdit модуле.
                    knopkaInfo.visible = false;//Невидимая кнопка информации.
                    knopkaNazad.visible = false;//Конопка Закрыть Невидимая.
                    knopkaStart.enabled = false;//Деактивированная кнопка Старт.
                    knopkaDokumentov.enabled = false;//Деактивированная кнопка
                    knopkaZadatPut.enabled = false;//Деактивированная кнопка
                    lgLogo.visible = true;//Видимый логотип.
                    root.signalToolbar("Начать процесс создания каталога документов?");//Вопрос.
                }
                else{//Если невидимый виджет, то...
                    knopkaInfo.visible = true;//Видимая кнопка информации.
                    knopkaNazad.visible = true;//Конопка Закрыть Видимая.
                    knopkaStart.enabled = true;//Активированная кнопка Старт.
                    //knopkaDokumentov.enabled = true;//активированная кнопка
                    //knopkaZadatPut.enabled = true;//активированная кнопка
                    lgLogo.visible = false;//Невидимый логотип.
                    root.signalToolbar("");//Пустое сообщение.
                    txdZona.textEdit.focus = true;//Чтобы работало событие Листания и всех остальных клавиш
                }
            }
            onClickedOk: fnClickedKatalog();//Функция создания каталога pdf документов.
            onClickedOtmena: copyStart.visible = false;//Делаем невидимый Вопрос начать создание каталога.
        }
        DCVopros{
            id: copyStop
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.top: tmZagolovok.top; anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left; anchors.right: tmZagolovok.right

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
                    knopkaNazad.visible = false;//Конопка Закрыть Невидимая.
                    ldrProgress.item.text = qsTr("Остановить процесс создания каталога документов?")
                }
                else{//Если невидимый виджет, то...
                    knopkaInfo.visible = true;//Видимая кнопка информации.
                    knopkaNazad.visible = true;//Конопка Закрыть Видимая.
                    if(ldrProgress.item)//Если загрузчик существует, то...
                        ldrProgress.item.text = ""//Удаляем сообщение в Загрузчике.
                    txdZona.textEdit.focus = true;//Чтоб работало событие Листания и всех остальных клавиш
                }
            }
            onClickedOk: {//Слот нажатия кнопки Ок
                tmrLogo.running = false;//Останавливаем анимацию Логотипа.
                copyStop.visible = false;//Делаем невидимый запрос с Вопросом остановки создания каталога.
                cppqml.copyKatalogStop();//Останавливаем принудительно копирование каталога.
                cppqml.strDebug = qsTr("Принудительная остановка создания каталога документов.");
            }
            onClickedOtmena: copyStop.visible = false;//Делаем невидимый запрос на удаление.
        }
    }
    Item {//Данные Зона
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCLogo {//Логотип
            id: lgLogo
            anchors.centerIn: tmZona
            ntCoff: root.logoRazmer; logoImya: root.logoImya
            clrLogo: root.clrTexta; clrFona: root.clrFona
            visible: false
        }
        DCKnopkaOriginal {
            id: knopkaStart
            ntHeight: root.ntWidth; ntCoff: root.ntCoff
            anchors.top: tmZona.top
            anchors.left: tmZona.left; anchors.right: tmZona.right
            anchors.margins: root.ntCoff/2
            clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
            text: qsTr("Старт")
            opacityKnopki: 0.8
            onClicked: copyStart.visible = true;//Задаём вопрос: "Начать создание каталога?"
        }
        DCKnopkaOriginal {
            id: knopkaDokumentov
            ntHeight: root.ntWidth; ntCoff: root.ntCoff
            anchors.top: knopkaStart.bottom
            anchors.left: tmZona.left; anchors.right: tmZona.right
            anchors.margins: root.ntCoff/2
            clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
            text: qsTr("Открыть папку")
            enabled: false
            opacityKnopki: 0.8
            onClicked: {

            }
        }
        DCKnopkaOriginal {
            id: knopkaZadatPut
            ntHeight: root.ntWidth; ntCoff: root.ntCoff
            anchors.top: knopkaDokumentov.bottom
            anchors.left: tmZona.left; anchors.right: tmZona.right
            anchors.margins: root.ntCoff/2
            clrTexta: root.clrTexta; clrKnopki: root.clrMenuFon
            text: qsTr("Задать папку сохранения")
            enabled: false
            opacityKnopki: 0.8
            onClicked: {

            }
        }
        Rectangle {
            id: rctTextEdit
            anchors.top: knopkaZadatPut.bottom; anchors.bottom: tmZona.bottom
            anchors.left: tmZona.left; anchors.right: tmZona.right
            border.color: root.clrTexta; border.width: 3
            color: "transparent"
            clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
                id: txdZona
                //Свойства
                property string strCopy: ""
                //Настройки
                ntWidth: root.ntWidth; ntCoff: root.ntCoff
                readOnly: true//Запрещено редактировать текст
                scrollAuto: true//Автоматически скроллим текст вверх, если он занимает всю область видимости.
                textEdit.selectByMouse: false//Запрещаем выделять текст, то нужно для свайпа Android
                pixelSize: root.ntWidth/3*root.ntCoff//размер шрифта текста в три раза меньше.
                radius: root.ntCoff/4//Радиус возьмём из настроек элемента qml через property
                clrFona: "transparent"//Цвет фона рабочей области
                clrTexta: root.clrTexta//Цвет текста
            }
        }

        DCMenu {
            id: menuSpisok 
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
    Item {//Данные Тулбар
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
        DCKnopkaNastroiki {
            id: knopkaNastroiki
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.right: tmToolbar.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                menuSpisok.visible ? menuSpisok.visible = false : menuSpisok.visible = true;
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
                txdZona.textEdit.focus = true;//Чтобы работало событие Листания и всех остальных клавиш
            }
        }
    } 
    Connections {//Соединяем сигнал из C++ с действием в QML
        target: cppqml;//Цель объект класса С++ DCCppQml
        function onStrKatalogDocCopyChanged(){//Слот Если изменилось сообщение в (Q_PROPERTY), то...
            let ltKatalogDocCopy = cppqml.strKatalogDocCopy;//Считываем сообщение из переменной.
            if(ltKatalogDocCopy !== ""){//Если не пустая строка, то...
                txdZona.strCopy = txdZona.strCopy + ltKatalogDocCopy + "\n";//Пишем в переменную из Q_PROPERTY
                txdZona.text = txdZona.strCopy;//Отображаем собранную строку в TextEdit модуле.
            }
        }
    }
    Component.onCompleted: {//Именно в конце Item, Когда компонет прогрузится полностью...
        txdZona.textEdit.focus = true;//Чтобы работало событие Листания и всех остальных клавиш
    }
}
