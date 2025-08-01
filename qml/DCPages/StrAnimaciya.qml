import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница с отладочной информацией.
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
    property int ntLogoTMK: 32
    property int startSec: 3
    property bool blStop: true//true - анимация не запущена.
    property bool borderOff: true//Без рамки.
    property bool border16_9: false//Рамка 16х9
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
	focus: true//Обязательно, иначе на Андроид экранная клавиатура не открывается.
    //Сигналы.
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedInfo();//Сигнал  нажатия кнопки Инструкция.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    //Функции. 
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event => 
		if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
            if(event.key === Qt.Key_N){//Если нажата клавиша N, то...
                if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
                    fnClickedSozdat();//Функция создания Списка.
                event.accepted = true;//Завершаем обработку эвента.
            }
            else{
                if(event.key === Qt.Key_S){//Если нажат "S", то.
                    if(knopkaOk.visible)//Если кнопка Ок видимая, то...
                        fnClickedOk();//Функция нажатия кнопки Ok.
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
        }
        else{
            if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                if (event.key === Qt.Key_Left){//Если нажата клавиша стрелка влево, то...
                    if(knopkaNazad.visible)//Если кнопка Назад видимая, то...
                        fnClickedNazad();//Функция нажатия кнопки Назад
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
            else{
                if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                    if(event.key === Qt.Key_I){//Если нажата клавиша I, то...
                        if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
                            fnClickedSozdat();//Функция редактирования текста.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
                else{//
                    if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
                        root.signalToolbar("");//Делаем пустую строку в Toolbar.
                        fnClickedEscape();//Функция нажатия кнопки Escape.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                    else{
                        if(event.key === Qt.Key_Space){//Если нажата на странице кнопка Пробел, то...
                            fnMenuStart();//Функция обработки нажатия меню Старт.
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
        txtAnimaciya.opacity = 1;//Непрозрачный текст.
        imgTMK.opacity = 1;//Непрозрачный логотип.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuSpisok.visible = false;//Делаем невидимым всплывающее меню. 
    }
    function fnClickedNazad() {//Функция нажатия кнопки Назад.
        txtZona.visible = false;//Невидимый текст.
        txtZona.text = "";//Пустой текст.
        txtAnimaciya.visible = false;//Невидимый текст.
        txtAnimaciya.text = "";//Пустой текст.
        fnClickedZakrit();//Сворачиваем все меню.
        root.clickedNazad();
    }
	function fnClickedInfo() {//Функция нажатия Информации.
		cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
		fnClickedEscape();//Функция нажатия кнопки Escape.
		root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
	}
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        root.signalToolbar("");//Делаем пустую строку в Toolbar. 
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedOk(){//Нажимаем на Ок
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        txtZona.opacity = 1;//Полная не прозрачность предварительного текста.
        txtZona.text = txnZagolovok.text;//Сначала задаём введёный текс.
        txtZona.visible = true;//Потом делаем видимым текст.
        txtAnimaciya.text = txnZagolovok.text;//Сначала задаём введёный текс.
        fnClickedEscape();//Функция нажатия кнопки Escape.
        fnMenuStart();//Запускаем обратный отсчёт.
    }
    function fnMenuStart(){//Функция обработки нажатия меню Старт.
        if(root.blStop){//Если анимация не запущена, то...
            root.blStop = false;//Деактивируем флаг.
            tmrStart.running = true;//Запускаем анимацию
        }
    }
    function fnMenuFormatOff(){//Функция отключение границ формата.
        rctBorder.border.color = "transparent"//Прозрачный цвет рамки
        rctBorder.width = tmZona.width;
        rctBorder.height = tmZona.height;
    }
    function fnMenuFormat16_9(){//Функция включение границ формата 16:9.
        let ltProporciya = 16/9;//Пропорция.
        rctBorder.border.color = root.clrTexta;//свет рамки.
        if(tmZona.width > tmZona.height){//Горизонтальное расположение экрана.
            //Вычисляем ширину как минимум из ширины внешнего прямоугольника и высоты * ltProporciya
            rctBorder.width = Math.min(tmZona.width, tmZona.height*ltProporciya)
            //Высота вычисляется на основе ширины, чтобы сохранить соотношение сторон
            rctBorder.height = rctBorder.width/ltProporciya
        }
        else{//Вертикальное расположение экрана.
            //Вычисляем высоту как минимум из высоту внешнего прямоугольника и ширину * ltProporciya
            rctBorder.height = Math.min(tmZona.height, tmZona.width*ltProporciya)
            //Ширина вычисляется на основе высоты, чтобы сохранить соотношение сторон
            rctBorder.width = rctBorder.height/ltProporciya
        }
    }
    function fnClickedSozdat(){//Функция обработки нажатия меню Добавить.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        menuSpisok.visible = false;//Делаем невидимым меню.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ТЕКСТ АНИМАЦИИ");//Подсказка пользователю,что вводить нужн
        txnZagolovok.visible = true;//Режим добавления текста Анимации ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
        root.signalToolbar(qsTr("Введите текст анимации.")) 
        txtZona.visible = false;//Невидимый текст.
        txtZona.text = "";//Пустой текст.
        txtAnimaciya.visible = false;//Невидимый текст.
        txtAnimaciya.text = "";//Пустой текст.
    }
    Timer {//таймер старта анимации логотипа.
        id: tmrStart
        interval: 1000; running: false; repeat: true
        property int ntSec: root.startSec;//Секунды обратного отсчёта.
        onTriggered: {//Если таймер сработал, то...
            ntSec--;//-1 сек.
            if(ntSec === 0)//Если 0, то...
                running = false;//Отключаем таймер.
            else//Если не 0, то...
                signalToolbar(ntSec);//Отображаем обратный отсчёт.
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                if(txtZona.opacity){//Если не прозрачный предворительный текст, то...
                    pctZona.start();//Запускаем прозрачность на первый тик таймера.
                    pctImage.start();//Запускаем таймер прозрачности логотипа
                }
                else{//Если прозрачный текст, то...
                    if(txtAnimaciya.opacity){//Если текст Анимированный не прозрачный, то...
                        pctAnimaciya.start();//Запускаем прозрачность на первый тик таймера.
                        pctImage.start();//Запускаем таймер прозрачности логотипа
                    }
                }
                signalToolbar(ntSec);//Отображаем первую цифру обратного отсчёта.
            }
            else{//Если таймер выключен, то...
                ntSec = root.startSec;//Задаём обратный отсчёт.
                signalToolbar(qsTr("Старт анимации."));//Оповещаем.
                tmrLogo.running = true;//Запускаем таймер изменения размеров логотипа и текста.
            }
        }
    }
    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 33; running: false; repeat: true
        //Math.trunc - только целое число возвращает после татематической операции, дробная отсекается.
        property int ntShag: txtZona.font.pixelSize/root.ntLogoTMK
        onTriggered: {
            imgTMK.ntCoff++;//Увелициваем Логотип.
            txtAnimaciya.font.pixelSize += ntShag;//Увеличиваем текст.
            if(imgTMK.ntCoff >= root.ntLogoTMK)//Если Логотип достиг максимально заданного размера, то...
                running = false//Отключаем таймер.
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                txtZona.visible = false;//Делаем невидимым текст, по которому расчитывали размер шрифта.
                txtAnimaciya.visible = true;//Анимацию видно.
                if(tmrLogo.ntShag)//Если коэффициент не ноль, то...
                    txtAnimaciya.font.pixelSize = 1;//Устанавливаем стартовый размер шрифта минимальный.
                else{//Если ноль, то...
                    signalToolbar(qsTr("Слишком длинный текст."));//
                    txtAnimaciya.font.pixelSize = txtZona.font.pixelSize;//Расчётный для красоты, без анимации
                }
                imgTMK.ntCoff = 1;//Задаём размер логотипа.
                txtAnimaciya.opacity = 1;//Полная не прозрачность текста.
                imgTMK.opacity = 1;//Полная не прозрачность логотипа.
            }
            else{//Если таймер выключен, то...
                tmrPause.running = true;//Запускаем таймер, чтоб успели прочитать.
                if(tmrLogo.ntShag)//Если коэффициент не ноль, то...
                    signalToolbar("");//Очищаем тулбар.
            }
        }
    }
    Timer {
        id: tmrPause
        interval: 1000; running: false; repeat: false
        onTriggered: {
            pctAnimaciya.start();//Запускаем таймер прозрачности текста
            pctImage.start();//Запускаем таймер прозрачности логотипа
            tmrOpacity.start();//Запускаем таймер ожидания окончания анимации прозрачности.
        }
    }
    Timer {
        id: tmrOpacity
        property int msecOpacity: 1000
        interval: msecOpacity; running: false; repeat: false
        onTriggered: {
            root.blStop = true;//Окончание анимации, взводим флаг.
            root.signalToolbar(qsTr("Стоп анимации."));//Сообщение в Toolbar.
        }
    }

    Item {//Данные Заголовок
        id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад.
        }
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
			onClicked: fnClickedInfo();//Функция нажатия Информации. 
        }
        DCKnopkaOk {
            id: knopkaOk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedOk();//Нажимаем на Ок
        }
        Item {
            id: tmTextInput
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: knopkaNazad.right
            anchors.right: knopkaInfo.left
            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            DCTextInput {
                id: txnZagolovok
                ntWidth: root.ntWidth
                ntCoff: root.ntCoff
                anchors.fill: tmTextInput
                visible: false
                clrTexta: root.clrTexta; clrFona: root.clrMenuFon
                radius: root.ntCoff/2
                //textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                //textInput.inputMethodHints: Qt.ImhUppercaseOnly//Буквы в виртуальной клавиатуре заглавные
                textInput.maximumLength: cppqml.untNastroikiMaxLength
                onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(visible){//Если DCTextInput видим, то...
                        knopkaNazad.visible = false;//Кнопка Назад Невидимая.
                        knopkaInfo.visible = false;//Конопка Информация Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                        txnZagolovok.forceActiveFocus();//Делаем придудительный фокус, чтоб вирт клав работала
                    }
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
                        knopkaNazad.visible = true;//Кнопка Назад видимая.
                        knopkaInfo.visible = true;//Конопка Информация Видимая.
                        txnZagolovok.text = "";//Текст обнуляем вводимый.
                        root.focus = true;//Фокус на основной странице, чтоб горячие клавиши работали.
                    }
                }
                onClickedEnter: {//Если нажата Enter, то такое же действие, как и при нажатии кнопки Ок.
					if(knopkaOk.visible)//Если кнопка Ок видимая, то...
                    	fnClickedOk();//Нажимаем Ок.
                }
            }
        }
    }
    Item {//Данные Зона
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        onWidthChanged: {//Если изменена ширина окна, то...
            if(root.border16_9){//Если выбрана рамка 16х9, то...
                fnMenuFormat16_9();//Перерасчитываем рамку 16:9 размера окна.
            }
        }
        onHeightChanged: {//Если изменена высота окна, то...
            if(root.border16_9){//Если выбрана рамка 16х9, то...
                fnMenuFormat16_9();//Перерасчитываем рамку 16:9 размера окна.
            }
        }
        Image {
            id: imgTMK
            property int ntCoff: root.ntLogoTMK
            source: "qrc:/images/ts-rus-color.svg"
            sourceSize: Qt.size(176, 238)
            width: ntCoff*5.5
            height: ntCoff*7.4375
            anchors.centerIn: tmZona
            anchors.verticalCenterOffset: height/4
            //Это свойство важно для качественного рендеринга SVG. Мы указываем исходный размер изображения.
            fillMode: Image.PreserveAspectFit//Сохраняем пропорции
            opacity: 1
            NumberAnimation on opacity {//Анимация прозрачности от 1 до 0 за 1000мс, не запущенная.
                id: pctImage
                from: 1.0; to: 0.0
                duration: tmrOpacity.msecOpacity; running: false
            }
        }
        Rectangle {//Прямоугольник формата записываемого видео. Выставляет границы.
            id: rctBorder
            anchors.centerIn: tmZona
            width: tmZona.width
            height: tmZona.height
            color: "transparent"
            border.width: 5
        }

        Rectangle {
            id: rctZona
            anchors.left: rctBorder.left
            anchors.right: rctBorder.right
            anchors.top: rctBorder.top
            anchors.bottom: rctBorder.verticalCenter
            color: "transparent"
            Text {
                id: txtZona
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                anchors.verticalCenter: rctZona.verticalCenter
                color: root.clrTexta

                horizontalAlignment: Text.AlignHCenter//Выровнять текст по центру по горизонтали
                verticalAlignment: Text.AlignVCenter//Выровнять текст по центру по вертикали

                visible: false;//Невидимый.
                text: ""
                opacity: 1
                NumberAnimation on opacity {//Анимация прозрачности от 1 до 0 за 1000мс, не запущенная.
                    id: pctZona
                    from: 1.0; to: 0.0
                    duration: 1000; running: false
                }
                onVisibleChanged: {//Если изменилась видимость, то...
                    if(text){//(Защита от пустого текста) Если не пустой текст, то...
                        if(visible){//Если становится видимым текс, то...
                            if(rctZona.width > txtZona.width){//Если длина строки > длины текста,то
                                for(var ltShag = txtZona.font.pixelSize;
                                                ltShag < rctZona.height-root.ntCoff; ltShag++){
                                    if(txtZona.width < rctZona.width){//длина текста < динны строки
                                        txtZona.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                        if(txtZona.width > rctZona.width){//Но, если переборщили
                                            txtZona.font.pixelSize--;//То уменьшаем размер шрифта и...
                                            return;//Выходим из увеличения шрифта.
                                        }
                                    }
                                }
                            }
                            else{//Если длина строки меньше длины текста, то...
                                for(let ltShag = txtZona.font.pixelSize; ltShag > 0; ltShag--){//Цикл --
                                    if(txtZona.width > rctZona.width)//Если текст дилиннее строки,то
                                        txtZona.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                                }
                            }
                        }
                    }
                }
            }
            onWidthChanged: {//Если изменился размер, то...
                if(txtZona.text){//(Защита от пустого текста) Если не пустой текст, то...
                    if(rctZona.width > txtZona.width){//Если длина строки > длины текста,то
                        for(var ltShag = txtZona.font.pixelSize;
                                        ltShag < rctZona.height-root.ntCoff; ltShag++){
                            if(txtZona.width < rctZona.width){//длина текста < динны строки
                                txtZona.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(txtZona.width > rctZona.width){//Но, если переборщили
                                    txtZona.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = txtZona.font.pixelSize; ltShag > 0; ltShag--){//Цикл --
                            if(txtZona.width > rctZona.width)//Если текст дилиннее строки,то
                                txtZona.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                    txtAnimaciya.font.pixelSize = txtZona.font.pixelSize;//изменяется размера изменяется шрифт
                }
            }
            Text {
                id: txtAnimaciya
                anchors.left: rctZona.left
                anchors.right: rctZona.right
                anchors.verticalCenter: rctZona.verticalCenter
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                color: root.clrTexta

                horizontalAlignment: Text.AlignHCenter//Выровнять текст по центру по горизонтали
                verticalAlignment: Text.AlignVCenter//Выровнять текст по центру по вертикали

                opacity: 1//Полностью не прозрачный текст.
                NumberAnimation on opacity {//Анимация прозрачности от 1 до 0 за 1000мс, не запущенная.
                    id: pctAnimaciya
                    from: 1.0; to: 0.0
                    duration: tmrOpacity.msecOpacity; running: false
                }

                visible: false;//Невидимый.
                text: ""
            }
        }
        DCMenu {
            id: menuSpisok
            visible: false//Невидимое меню.
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.left: tmZona.left
            anchors.right: tmZona.right
            anchors.bottom: tmZona.bottom
            anchors.margins: root.ntCoff
            pctFona: 0.90//Прозрачность фона меню.
            clrTexta: root.clrMenuText; clrFona: root.clrMenuFon
            imyaMenu: "animaciya"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
            onClicked: function(ntNomer, strMenu) {
                menuSpisok.visible = false;//Делаем невидимым меню.
                if(ntNomer === 1){//Добавить.
                    fnClickedSozdat();//Функция обработки нажатия меню Добавить.
                }
                if(ntNomer === 2){//Старт.
                    fnMenuStart();//Функция обработки нажатия меню Старт.
                }
                if(ntNomer === 3){//Без рамки.
                    root.border16_9 = false;
                    root.borderOff = true;
                    fnMenuFormatOff();//Функция отключение границ формата.
                }
                if(ntNomer === 4){//Рамка 16:9
                    root.borderOff = false;
                    root.border16_9 = true;
                    fnMenuFormat16_9();//Функция включение границ формата 16:9.
                }
                if(ntNomer === 5){//Выход
                    Qt.quit();//Закрыть приложение.
                }
            }
        }
    }
    Item {//Данные Тулбар
        id: tmToolbar
        DCKnopkaSozdat {
            id: knopkaSozdat
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {//Слот сигнала clicked кнопки Создать.
                txnZagolovok.visible ? fnClickedZakrit() : fnClickedSozdat()
            }
        }
        DCKnopkaNastroiki {
            id: knopkaNastroiki
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.right: tmToolbar.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                txnZagolovok.visible = false;//Отключаем ввод текста анимации.
                menuSpisok.visible ? menuSpisok.visible = false : menuSpisok.visible = true;
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
                root.forceActiveFocus();//Придудительный фокус на root, чтоб тут же работало собыние клавишь.
            }
        }
    } 
    Component.onCompleted: {//Именно в конце Item, Когда компонет прогрузится полностью...
        root.forceActiveFocus();//Делаем придудительный фокус на root, чтоб тут же работало собыние клавишь.
    }
}
