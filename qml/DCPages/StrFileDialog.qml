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
    property color clrTexta: "Orange"
    property color clrFaila: "Yellow"//Цвет файлов в проводнике.
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
	property alias radiusZona: rctZona.radius//Радиус Зоны рабочей
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property string strPutDom: ""//Иннициализируется в Component.onComplite домашней дерикторией.
    property bool blPlan: false//true - проводник открыт для Плана. false - проводник открыт для Данных.
    property int logoRazmer: 22//Размер Логотипа.
    property string logoImya: "mentor"//Имя логотипа в DCLogo
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
                fnClickedEscape();//Функция нажатия кнопки Escape.
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
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        menuFileDialog.visible = false;//Делаем невидимым всплывающее меню.
    }
	function fnClickedInfo() {//Функция нажатия на Информацию
		fnClickedEscape();//Меню сворачиваем
		root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
	}
    function fnCopyStop(){//Останавливаем анимацию копирования.
        tmrLogoTMK.running = false;//Останавливаем таймер анимации логотипа ТМК.
        lgLogo.ntCoff = root.logoRazmer;//По умолчанию размер логотипа ТМК.
        knopkaNazad.visible= true//Делаем кнопку назад видимой.
        knopkaZakrit.visible = true//Делаем кнопку закрыть видимой.
        lsvZona.visible = true;//Делаем видимую зону с Проводником.
        knopkaNastroiki.visible = true//Делаем кнопку настройки видимой.
        knopkaInfo.visible = true//Делаем кнопку информации видимой.
        fnClickedZakrit();//ОБЯЗАТЕЛЬНО задаём дерикторию! Сворачиваем, закрываем.
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
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад.
        }
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
			onClicked: fnClickedInfo();//Функция нажатия на Информацию 
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
            }
            DCLogo {
                id: lgLogo
                anchors.centerIn: parent
                ntCoff: root.logoRazmer; logoImya: root.logoImya
                clrLogo: root.clrTexta; clrFona: root.clrFona
            }
            ZonaFileDialog {
                id: lsvZona
                ntWidth: root.ntWidth
                ntCoff: root.ntCoff
                anchors.fill: rctZona
                clrPapki: root.clrTexta//Цвет папок в проводнике.
                clrFaila: root.clrFaila//Цвет файлов в проводнике
                clrFona: root.clrMenuFon
                onClicked: function(ntTip, strFileDialog) {//Слот нажатия на один из Элементов Проводника.
                    if(!ntTip){//Если Тип = 0, это нажатие кнопки Назад
                        fnClickedNazad();//Функция нажатия кнопки Назад.
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
                pctFona: 0.90//Прозрачность фона меню.
                clrTexta: root.clrMenuText; clrFona: root.clrMenuFon
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
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
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
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
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
