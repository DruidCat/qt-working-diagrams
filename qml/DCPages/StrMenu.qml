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
    property bool pdfViewer: cppqml.blPdfViewer//true - включен собственный просмотрщик.
    property bool appRedaktor: cppqml.blAppRedaktor//true - включен Редактор приложения.
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
                    onClicked: root.clickedKatalog();//Открываем страницу создания каталога документов.
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
