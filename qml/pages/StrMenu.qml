import QtQuick //2.15
import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
//Страница отображающая Меню.

Item {
    id: root
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
    property bool pdfViewer: false//true - включен собственный просмотрщик.
    anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedLogi();//Сигнал нажатия кнопки Логи.
	signal clickedWorkingDiagrams();//Сигнал нажатия кнопки об Рабочих Схемах.
    signal clickedPlan();//Сигнал нажатия кнопки План.
    signal clickedQt();//Сигнал нажатия кнопки Об Qt.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            menuMenu.visible = false;//Делаем невидимым всплывающее меню.
        }
    }

    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: menuMenu.visible = false
    }

	Item {
		id: tmZagolovok
        DCKnopkaVpered{//@disable-check M300
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
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
                width: tmZona.width
                height: flZona.contentHeight
                color: "transparent"

                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaLogi
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: rctZona.top
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: qsTr("Логи")
                    bold: true
                    italic: true
                    onClicked: {
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedLogi();//Сигнал нажатия кнопки Логи.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaAvtor
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: knopkaLogi.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: qsTr("О приложении")
                    bold: true
                    italic: true
                    onClicked: {
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedWorkingDiagrams();//Сигнал нажатия кнопки об приложении Рабочие Схемы.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaSpisok
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: knopkaAvtor.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: qsTr("Участки")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        //Делаем список прокрутки видимым/невидимым при каждом нажатии кнопки.
                        pvSpisok.visible ? pvSpisok.visible = false : pvSpisok.visible = true;
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaPlan
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: knopkaSpisok.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: qsTr("План")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedPlan();//Сигнал нажатия кнопки План.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaQt
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: knopkaPlan.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: qsTr("О Qt")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.clickedQt();//Сигнал нажатия кнопки об Qt.
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaPdfViewer
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: knopkaQt.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: root.pdfViewer ? qsTr("PdfViewer: вкл.") : qsTr("PdfViewer: выкл.")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        menuMenu.visible = false;//Делаем невидимым меню.
                        root.pdfViewer ? root.pdfViewer = false : root.pdfViewer = true
                    }
                }
                DCKnopkaOriginal {//@disable-check M300
                    id: knopkaVihod
                    ntHeight: root.ntWidth*root.ntCoff+8
                    anchors.top: knopkaPdfViewer.bottom
                    anchors.left: rctZona.left
                    anchors.right: rctZona.right
                    anchors.margins: root.ntCoff/2
                    clrKnopki: "slategray"
                    clrTexta: root.clrTexta
                    text: qsTr("Выход")
                    bold: true
                    italic: true
                    onClicked: {//Слот запускающий
                        Qt.quit();//Закрыть приложение.
                    }
                }
            }
        }
        PathViewSpisok {//@disable-check M300
            id: pvSpisok
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.left: tmZona.left
            anchors.right: tmZona.right
            anchors.bottom: tmZona.bottom
            anchors.margins: root.ntCoff
            clrTexta: root.clrTexta
            clrFona: "SlateGray"
            onSSpisok: function(strSpisok) {
                pvSpisok.visible = false;
                knopkaSpisok.text = strSpisok;
            }
        }
        DCMenu {//@disable-check M300//Меню отображается в Рабочей Зоне приложения.
            id: menuMenu
            visible: false//Невидимое меню.
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.left: tmZona.left
            anchors.right: tmZona.right
            anchors.bottom: tmZona.bottom
            anchors.margins: root.ntCoff
            clrTexta: root.clrTexta
            clrFona: "SlateGray"
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
        DCKnopkaNastroiki {//@disable-check M300//Кнопка Меню.
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.right: tmToolbar.right
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                menuMenu.visible ? menuMenu.visible = false : menuMenu.visible = true;//Изменяем видимость
            }
        }
	}
}
