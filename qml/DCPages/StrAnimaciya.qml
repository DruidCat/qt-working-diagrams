import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница с отладочной информацией.
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
    property int ntStart: ntWidth*ntCoff
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    //Сигналы.
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedInfo();//Сигнал  нажатия кнопки Инструкция.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    //Функции.
    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuSpisok.visible = false;//Делаем невидимым всплывающее меню. 
    }
    focus: true//Обязательно, иначе на Андроид экранная клавиатура не открывается.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
            event.accepted = true;//Завершаем обработку эвента.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: {
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        root.signalToolbar("");//Делаем пустую строку в Toolbar. 
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedOk(){//Нажимаем на Ок
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        txtZona.text = txnZagolovok.text;//Сначала задаём введёный текс.
        txtZona.visible = true;//Потом делаем видимым текст.
        txtAnimaciya.text = txnZagolovok.text;//Сначала задаём введёный текс.
        fnClickedEscape();//Функция нажатия кнопки Escape.
        fnMenuStart();//Запускаем обратный отсчёт.
    }
    function fnMenuStart(){//Функция обработки нажатия меню Старт.
        tmrStart.running = true;
    }
    function fnClickedSozdat(){//Функция обработки нажатия меню Добавить.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        menuSpisok.visible = false;//Делаем невидимым меню.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ТЕКС АНИМАЦИИ");//Подсказка пользователю,что вводить нужн
        txnZagolovok.visible = true;//Режим добавления текста Анимации ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
        root.signalToolbar(qsTr("Введите текст анимации.")) 
        txtZona.visible = false;//Невидимый текст.
        txtZona.text = "";//Пустой текст.
        txtAnimaciya.visible = false;//Невидимый текст.
        txtAnimaciya.text = "";//Пустой текст.
    }
    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 110; running: false; repeat: true
        property int ntShag: Math.trunc((txtZona.font.pixelSize - root.ntWidth*root.ntCoff)/root.ntLogoTMK)
        onTriggered: {
            lgTMK.ntCoff++;
            txtAnimaciya.font.pixelSize += ntShag;
            if(lgTMK.ntCoff >= root.ntLogoTMK)
                running = false
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                txtZona.visible = false;//Делаем невидимым текст, по которому расчитывали размер шрифта.
                txtAnimaciya.font.pixelSize = root.ntWidth*root.ntCoff;//Устанавливаем стартовый размер шрифта
                txtAnimaciya.visible = true;//Анимацию видно.
                lgTMK.ntCoff = 1;//Задаём размер логотипа.
            }
            else{//Если таймер выключен, то...
                signalToolbar("");//Очищаем тулбар.
            }
        }
    }
    Timer {//таймер старта анимации логотипа.
        id: tmrStart
        interval: 1000; running: false; repeat: true
        property int ntSec: 3;//Секунды обратного отсчёта.
        onTriggered: {//Если таймер сработал, то...
            ntSec--;//-1 сек.
            if(ntSec === 0)//Если 0, то...
                running = false;//Отключаем таймер.
            else//Если не 0, то...
                signalToolbar(ntSec);//Отображаем обратный отсчёт.
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                signalToolbar(ntSec);//Отображаем первую цифру обратного отсчёта.
            }
            else{//Если таймер выключен, то...
                ntSec = 3;//Задаём обратный отсчёт.
                signalToolbar(qsTr("Старт!"));//Оповещаем.
                tmrLogo.running = true;//Запускаем таймер изменения размеров логотипа и текста.
            }
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
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            onClicked: {
                txtZona.visible = false;//Невидимый текст.
                txtZona.text = "";//Пустой текст.
                txtAnimaciya.visible = false;//Невидимый текст.
                txtAnimaciya.text = "";//Пустой текст.
                fnClickedZakrit();//Сворачиваем все меню.
                root.clickedNazad();
            }
        }
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
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
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
                root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
            }
        }
        DCKnopkaOk {
            id: knopkaOk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            onClicked: {//Нажимаем Ок.
                fnClickedOk();//Нажимаем на Ок
            }
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
                clrTexta: root.clrTexta
                clrFona: "SlateGray"
                radius: root.ntCoff/2
                textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                textInput.maximumLength: cppqml.untNastroikiMaxLength
                onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(visible){//Если DCTextInput видим, то...
                        knopkaNazad.visible = false;//Кнопка Назад Невидимая.
                        knopkaInfo.visible = false;//Конопка Информация Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                    }
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
                        knopkaNazad.visible = true;//Кнопка Назад видимая.
                        knopkaInfo.visible = true;//Конопка Информация Видимая.
                        txnZagolovok.text = "";//Текст обнуляем вводимый.
                        knopkaInfo.focus = true;//Фокус на кнопке Информация, чтоб не работал Enter.
                    }
                }
                onClickedEnter: {//Если нажата Enter, то такое же действие, как и при нажатии кнопки Ок.
                    fnClickedOk();//Нажимаем Ок.
                }
            }
        }
    }
    Item {//Данные Зона
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        /*
        DCLogoTMK {//Логотип до flZona, чтоб не перекрывать список.
            id: lgTMK
            ntCoff: root.ntLogoTMK
            anchors.centerIn: tmZona
            visible: true
            clrLogo: root.clrTexta; clrFona: root.clrFona
        }
        */
        Image {
            id: lgTMK
            property int ntCoff: 16
            source: "qrc:/images/ts-rus-color.svg"
            sourceSize: Qt.size(88, 119)
            width: ntCoff*11
            height: ntCoff*14.875
            anchors.centerIn: tmZona
            //Это свойство важно для качественного рендеринга SVG. Мы указываем исходный размер изображения.
            fillMode: Image.PreserveAspectFit//Сохраняем пропорции
        }
        Rectangle {
            id: rctZona
            anchors.fill: tmZona
            color: "transparent"
            Text {
                id: txtZona
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                color: root.clrTexta

                font.capitalization: Font.AllUppercase//Текст ЗАГЛАВНЫМИ буквами.
                horizontalAlignment: Text.AlignHCenter//Выровнять текст по центру по горизонтали
                verticalAlignment: Text.AlignVCenter//Выровнять текст по центру по вертикали

                visible: false;//Невидимый.
                text: ""
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
                anchors.top: rctZona.top
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                color: root.clrTexta
                font.capitalization: Font.AllUppercase//Текст ЗАГЛАВНЫМИ буквами.
                horizontalAlignment: Text.AlignHCenter//Выровнять текст по центру по горизонтали
                verticalAlignment: Text.AlignVCenter//Выровнять текст по центру по вертикали

                visible: false;//Невидимый.
                text: ""
            }
            Image {
                id: tmkLogo
                anchors.bottom: rctZona.bottom
                anchors.right: rctZona.right
                anchors.bottomMargin: root.ntCoff
                anchors.rightMargin: root.ntCoff

                sourceSize: Qt.size(88, 119)
                fillMode: Image.PreserveAspectFit// Сохраняем пропорции
                source: "qrc:/images/ts-rus-orange-1.svg"
            }
        }
        DCMenu {
            id: menuSpisok
            visible: false//Невидимое меню.
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.left: rctZona.left
            anchors.right: rctZona.right
            anchors.bottom: rctZona.bottom
            anchors.margins: root.ntCoff
            clrTexta: root.clrTexta
            clrFona: "SlateGray"
            imyaMenu: "animaciya"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
            onClicked: function(ntNomer, strMenu) {
                menuSpisok.visible = false;//Делаем невидимым меню.
                if(ntNomer === 1){//Добавить.
                    fnClickedSozdat();//Функция обработки нажатия меню Добавить.
                }
                if(ntNomer === 2){//Старт.
                    fnMenuStart();//Функция обработки нажатия меню Старт.
                }
                if(ntNomer === 3){//Выход
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
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
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
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            onClicked: {
                txnZagolovok.visible = false;//Отключаем ввод текста анимации.
                menuSpisok.visible ? menuSpisok.visible = false : menuSpisok.visible = true;
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
        }
    }
}
