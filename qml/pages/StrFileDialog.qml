import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/zones"//Импортируем зону файлового диалога.
//Страница с отображением каталога папок и файлов
Item {
    id: tmFileDialog
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
    property color clrFaila: "yellow"//Цвет файлов в проводнике.
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
	property alias radiusZona: rctZona.radius//Радиус Зоны рабочей
    property string strPutDom: ""//Иннициализируется в Component.onComplite домашней дерикторией.
    property bool blLogoTMK: false//Флаг, отвечает за изменение размера логотипа. Уменьшаем - false
    property int ntLogoTMK: 16

    anchors.fill: parent//Растянется по Родителю.
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedZakrit();//Сигнал нажатия кнопки Закрыть.
    signal clickedInfo();//Сигнал нажатич кнопки Инфо, где будет описание работы Файлового Диалога.
    signal signalZagolovok (var strZagolovok);//Сигнал излучающий имя каталога в Проводнике.
	signal signalToolbar (var strToolbar);//Сигнал излучающий в Toolbar в Проводнике.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        menuFileDialog.visible = false;//Делаем невидимым всплывающее меню.
    }
    focus: true//Не удалять, может Escape не работать.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmFileDialog
        onClicked: fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedNazad(){//Функция нажатия кнопки Назад или клика папки [..]
        if(cppqml.strFileDialogPut === tmFileDialog.strPutDom){//Если каталог совпадает с домашним, то...
            fnClickedZakrit();//Закрываем проводник.
        }
        else{//Противном случае...
            cppqml.strFileDialog = "[..]";//Назад в папке.
            fnClickedEscape();//Меню сворачиваем
            tmFileDialog.signalZagolovok(cppqml.strFileDialogPut);//Передаю имя папки назад [..].
        }
    }
    function fnClickedZakrit(){
        cppqml.strFileDialogPut = "dom";//Закрываем проводник и назначаем домашнюю деррикторию.
		tmFileDialog.signalZagolovok(qsTr("ПРОВОДНИК"));//Передаю имя папки назад [..].
        fnClickedEscape();//Меню сворачиваем
        tmFileDialog.clickedZakrit();//Излучаем сигнал закрытия проводника.
    }

    Item {//Данные Заголовок
        id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left:tmZagolovok.left
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            onClicked: {
                fnClickedNazad();//Функция клика Назад.
            }
        }
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            clrFona: tmFileDialog.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
    }
    Item {//Данные Зона
        id: tmZona
        Rectangle {
            id: rctZona
            anchors.fill: tmZona
            color: "transparent"
            border.width: tmElement.ntCoff/2//Бордюр при переименовании.
            clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            Timer {
                id: tmrLogoTMK
                interval: 111
                running: false
                repeat: true
                onTriggered: {
                    if(tmFileDialog.blLogoTMK){//Если true, то...
                        lgTMK.ntCoff++;
                        if(lgTMK.ntCoff >= tmFileDialog.ntLogoTMK)
                            tmFileDialog.blLogoTMK = false;
                    }
                    else{
                        lgTMK.ntCoff--;
                        if(lgTMK.ntCoff <= 1)
                            tmFileDialog.blLogoTMK = true;
                    }
               }
            }
            DCLogoTMK {//Логотип до ZonaFileDialog, чтоб не перекрывать список.
                id: lgTMK
                ntCoff: tmFileDialog.ntLogoTMK
                anchors.centerIn: parent
                clrLogo: tmFileDialog.clrTexta
                clrFona: tmFileDialog.clrFona
            }
            ZonaFileDialog {
                id: lsvZona
                ntWidth: tmFileDialog.ntWidth
                ntCoff: tmFileDialog.ntCoff
                anchors.fill: rctZona
                clrPapki: tmFileDialog.clrTexta//Цвет папок в проводнике.
                clrFaila: tmFileDialog.clrFaila//Цвет файлов в проводнике
                clrFona: "SlateGray"
                onClicked: function(ntTip, strFileDialog) {//Слот нажатия на один из Элементов Проводника.
                    if(!ntTip){//Если Тип = 0, это нажатие кнопки Назад
                        fnClickedNazad();//Функция клика назад.
                    }
                    else{
                        if(ntTip === 1){//Если это Папки, то...
                            fnClickedEscape();//Меню сворачиваем
                            cppqml.strFileDialog = strFileDialog;//Присваиваем имя папки выбранной.
                            tmFileDialog.signalZagolovok(cppqml.strFileDialogPut);//Передаю имя папки.`
                        }
                        else{
                            if(ntTip === 2){//Если это file из Маски, то...
                                tmFileDialog.signalZagolovok(qsTr("ИДЁТ КОПИРОВАНИЕ ДОКУМЕНТА"));//
                                tmFileDialog.signalToolbar(qsTr("Копирование."));//Сообщение в Toolbar.
                                knopkaNazad.visible= false//Делаем кнопку назад невидимой.
                                knopkaZakrit.visible = false//Делаем кнопку закрыть невидимой.
                                lsvZona.visible = false;//Делаем невидимую зону с Проводником.
                                knopkaNastroiki.visible = false//Делаем кнопку настройки невидимой.
                                knopkaInfo.visible = false//Делаем кнопку информации невидимой.
                                tmrLogoTMK.running = true;//Запускаем таймер анимации логотипа ТМК.
                                cppqml.strFileDialog = strFileDialog;//Присваиваем имя выбранного файла.
                                cppqml.strDannieDB = cppqml.strFileDialog;//Сохранить имя Документа,и Документ
                            }
                        }
                    }
                }
            }
            DCMenu {
                id: menuFileDialog
                visible: false//Невидимое меню.
                ntWidth: tmFileDialog.ntWidth
                ntCoff: tmFileDialog.ntCoff
                anchors.left: rctZona.left
                anchors.right: rctZona.right
                anchors.bottom: rctZona.bottom
                anchors.margins: tmFileDialog.ntCoff
                clrTexta: tmFileDialog.clrTexta
                clrFona: "SlateGray"
                imyaMenu: "filedialog"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
                onClicked: function(ntNomer, strMenu) {
                    menuFileDialog.visible = false;//Делаем невидимым меню.
                    if(ntNomer === 1){//Закрыть.
                        fnClickedZakrit();//Закрываем проводник.
                    }
                }
            }
        }
    }
    Item {//Данные Тулбар
        id: tmToolbar
        DCKnopkaNastroiki {
            id: knopkaNastroiki
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            clrFona: tmFileDialog.clrFona
            onClicked: {
                menuFileDialog.visible ? menuFileDialog.visible = false : menuFileDialog.visible = true;
            }
        }
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.right: tmToolbar.right
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            clrFona: tmFileDialog.clrFona
            onClicked: {
                fnClickedEscape();//Меню сворачиваем
                tmFileDialog.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
            }
        }
    }
    Component.onCompleted: {//Вызывается при завершении иннициализации компонента.
        tmFileDialog.strPutDom = cppqml.strFileDialogPut;//Запоминаем домашнюю деррикторию.
    }
    Connections {//Соединяем сигнал из C++ с действием в QML
        target: cppqml;//Цель объект класса С++ DCCppQml
        function onBlFileDialogCopyChanged(){//Слот Если изменился элемент списка в strSpisok (Q_PROPERTY), то
            tmrLogoTMK.running = false;//Останавливаем таймер анимации логотипа ТМК.
            lgTMK.ntCoff = tmFileDialog.ntLogoTMK;//По умолчанию размер логотипа ТМК.
            tmFileDialog.blLogoTMK = false;//Делаем флаг анимации логотипа ТМК на уменьш.
            knopkaNazad.visible= true//Делаем кнопку назад видимой.
            knopkaZakrit.visible = true//Делаем кнопку закрыть видимой.
            lsvZona.visible = true;//Делаем видимую зону с Проводником.
            knopkaNastroiki.visible = true//Делаем кнопку настройки видимой.
            knopkaInfo.visible = true//Делаем кнопку информации видимой.
            fnClickedZakrit();//ОБЯЗАТЕЛЬНО задаём дом дерикторию! Сворачиваем, закрываем.
        }
    }
}
