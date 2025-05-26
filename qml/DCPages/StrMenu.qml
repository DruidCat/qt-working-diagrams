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
    property bool pdfViewer: cppqml.blPdfViewer//true - включен собственный просмотрщик.
    property bool appRedaktor: cppqml.blAppRedaktor//true - включен Редактор приложения.
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedLogi();//Сигнал нажатия кнопки Логи.
	signal clickedWorkingDiagrams();//Сигнал нажатия кнопки об Рабочих Схемах.
    signal clickedQt();//Сигнал нажатия кнопки Об Qt.
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

	Item {
		id: tmZagolovok
        DCKnopkaVpered{
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
			onClicked: {
                menuMenu.visible = false;//Делаем невидимым меню.
                root.clickedNazad();//Сигнал нажатия кнопки Назад.
			}
		}
	} 
    Item {
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
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
                    text: root.pdfViewer ? qsTr("PdfViewer: вкл") : qsTr("PdfViewer: выкл")
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
                    text: root.appRedaktor ? qsTr("Администратор: вкл") : qsTr("Администратор: выкл")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.appRedaktor ? root.appRedaktor = false : root.appRedaktor = true
                    }
                }
                DCKnopkaOriginal {
                    id: knopkaVihod
                    ntHeight: root.ntWidth; ntCoff: root.ntCoff
                    anchors.top: knopkaRedaktor.bottom
                    anchors.left: rctZona.left; anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"; clrTexta: root.clrTexta
                    text: qsTr("Выход")
                    bold: true; italic: true
                    onClicked: {//Слот запускающий
                        Qt.quit();//Закрыть приложение.
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
        DCKnopkaNastroiki {//Кнопка Меню.
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
