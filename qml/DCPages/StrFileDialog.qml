import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
import DCZones 1.0//Импортируем зону Данных.
//Страница с отображением каталога папок и файлов
Item {
    id: root
    //Свойства.
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
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property string strPutDom: ""//Иннициализируется в Component.onComplite домашней дерикторией.
    property int ntLogoTMK: 16
	property bool blPlan: false//true - проводник открыт для Плана. false - проводник открыт для Данных.
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    focus: true//Не удалять, может Escape не работать.
    //Сигналы.
    signal clickedZakrit();//Сигнал нажатия кнопки Закрыть или Назад.
    signal clickedInfo();//Сигнал нажатич кнопки Инфо, где будет описание работы Файлового Диалога.
    signal signalZagolovok (var strZagolovok);//Сигнал излучающий имя каталога в Проводнике.
	signal signalToolbar (var strToolbar);//Сигнал излучающий в Toolbar в Проводнике.
    //Функции.
	onBlPlanChanged: {//Если переменная изменилась, то...
		cppqml.blFileDialogPlan = root.blPlan;//В бизнес логику настройки копирования Плана или Данных.
	}
    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        menuFileDialog.visible = false;//Делаем невидимым всплывающее меню.
    }
    function fnCopyStop(){//Останавливаем анимацию копирования.
        tmrLogoTMK.running = false;//Останавливаем таймер анимации логотипа ТМК.
        lgTMK.ntCoff = root.ntLogoTMK;//По умолчанию размер логотипа ТМК.
        knopkaNazad.visible= true//Делаем кнопку назад видимой.
        knopkaZakrit.visible = true//Делаем кнопку закрыть видимой.
        lsvZona.visible = true;//Делаем видимую зону с Проводником.
        knopkaNastroiki.visible = true//Делаем кнопку настройки видимой.
        knopkaInfo.visible = true//Делаем кнопку информации видимой.
        fnClickedZakrit();//ОБЯЗАТЕЛЬНО задаём дерикторию! Сворачиваем, закрываем.
    }
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedNazad(){//Функция нажатия кнопки Назад или клика папки [..]
        if(cppqml.strFileDialogPut === root.strPutDom){//Если каталог совпадает с домашним, то...
            fnClickedZakrit();//Закрываем проводник.
        }
        else{//Противном случае...
            cppqml.strFileDialog = "[..]";//Назад в папке.
            fnClickedEscape();//Меню сворачиваем
            root.signalZagolovok(cppqml.strFileDialogPut);//Передаю имя папки назад [..].
        }
    }
    function fnClickedZakrit(){
        //cppqml.strFileDialogPut = "dom";//Закрываем проводник и назначаем домашнюю деррикторию.
        cppqml.strFileDialogPut = "sohranit";//Закрываем проводник и назначаем текущую деррикторию.
        fnClickedEscape();//Меню сворачиваем
        root.clickedZakrit();//Излучаем сигнал закрытия проводника.
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
            tapHeight: ntWidth*ntCoff+ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                fnClickedNazad();//Функция клика Назад.
            }
        }
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: ntWidth*ntCoff+ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                fnClickedEscape();//Меню сворачиваем
                root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
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
                property bool blLogoTMK: false//Флаг, отвечает за изменение размера логотипа. Уменьшаем-false
                interval: 111
                running: false
                repeat: true
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
            }
            DCLogoTMK {
                id: lgTMK
                ntCoff: root.ntLogoTMK
                anchors.centerIn: parent
                clrLogo: root.clrTexta
                clrFona: root.clrFona
            }
            ZonaFileDialog {
                id: lsvZona
                ntWidth: root.ntWidth
                ntCoff: root.ntCoff
                anchors.fill: rctZona
                clrPapki: root.clrTexta//Цвет папок в проводнике.
                clrFaila: root.clrFaila//Цвет файлов в проводнике
                clrFona: "SlateGray"
                onClicked: function(ntTip, strFileDialog) {//Слот нажатия на один из Элементов Проводника.
                    if(!ntTip){//Если Тип = 0, это нажатие кнопки Назад
                        fnClickedNazad();//Функция клика назад.
                    }
                    else{
                        if(ntTip === 1){//Если это Папки, то...
                            fnClickedEscape();//Меню сворачиваем
                            cppqml.strFileDialog = strFileDialog;//Присваиваем имя папки выбранной.
                            root.signalZagolovok(cppqml.strFileDialogPut);//Передаю путь Папки  в заголовок.`
                        }
                        else{
                            if(ntTip === 2){//Если это file из Маски, то...
                                root.signalZagolovok(qsTr("ИДЁТ КОПИРОВАНИЕ ДОКУМЕНТА"));//
                                root.signalToolbar(qsTr("Копирование."));//Сообщение в Toolbar.
                                knopkaNazad.visible= false//Делаем кнопку назад невидимой.
                                knopkaZakrit.visible = false//Делаем кнопку закрыть невидимой.
                                lsvZona.visible = false;//Делаем невидимую зону с Проводником.
                                knopkaNastroiki.visible = false//Делаем кнопку настройки невидимой.
                                knopkaInfo.visible = false//Делаем кнопку информации невидимой.
                                tmrLogoTMK.running = true;//Запускаем таймер анимации логотипа ТМК.
                                cppqml.strFileDialog = strFileDialog;//Присваиваем имя выбранного файла.
                                if(root.blPlan){//Если выбран режим сохранения документа Плана, то...
                                    if(!cppqml.copyPlan(strFileDialog)){//Если ошибка Копирования файла Плана.
                                        fnCopyStop();//Останавливаем анимацию копирования, закрываем проводник
                                    }
								}
								else{//Если выбран режим сохранения документа Данных, то...
                                    cppqml.strDannieDB = cppqml.strFileDialog;//Сохранить имя Док. и Документ
								}
                            }
                        }
                    }
                }
                onTap: fnClickedEscape();//Если нажали на пустое место.
            }
            DCMenu {
                id: menuFileDialog
                visible: false//Невидимое меню.
                ntWidth: root.ntWidth
                ntCoff: root.ntCoff
                anchors.left: rctZona.left
                anchors.right: rctZona.right
                anchors.bottom: rctZona.bottom
                anchors.margins: root.ntCoff
                clrTexta: root.clrTexta
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
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: ntWidth*ntCoff+ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
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
            tapHeight: ntWidth*ntCoff+ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                menuFileDialog.visible ? menuFileDialog.visible = false : menuFileDialog.visible = true;
            }
        } 
    }
    Component.onCompleted: {//Вызывается при завершении иннициализации компонента.
        root.strPutDom = cppqml.strFileDialogPut;//Запоминаем домашнюю деррикторию.
    }
    Connections {//Соединяем сигнал из C++ с действием в QML
        target: cppqml;//Цель объект класса С++ DCCppQml
        function onBlFileDialogCopyChanged(){//Слот Если изменился флаг копирования (Q_PROPERTY), то
            fnCopyStop();//Останавливаем анимацию копирования.
        }
    }
}
