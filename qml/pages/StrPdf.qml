import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Pdf 5.15

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной. 
//Страница просмотра PDF документов.
Item {
	id: tmPdf
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
	property alias radiusZona: rctBorder.radius//Радиус Зоны рабочей
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            menuMenu.visible = false;//Делаем невидимым всплывающее меню.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmPdf
        onClicked: menuMenu.visible = false
    }

	Item {
		id: tmZagolovok
		DCKnopkaNazad {
			ntWidth: tmPdf.ntWidth
			ntCoff: tmPdf.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmPdf.ntCoff/2
			clrKnopki: tmPdf.clrTexta
			onClicked: {
                menuMenu.visible = false;//Делаем невидимым меню.
                tmPdf.clickedNazad();//Сигнал нажатия кнопки Назад.
			}
		}
		DCKnopkaPoisk{
            id: knopkaPoisk
            ntWidth: tmPdf.ntWidth
            ntCoff: tmPdf.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
            anchors.margins: tmPdf.ntCoff/2
            clrKnopki: tmPdf.clrTexta
            clrFona: tmPdf.clrFona
            onClicked: {//Слот сигнала clicked кнопки Поиск.
                //fnClickedPoisk();//Функция обрабатывающая кнопку Поиск.
            }
        }
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.	
		PdfDocument {//Класс, который возвращает данные о Pdf Документе.
			id: pdfDoc
		}
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
				pdfDoc.source = cppqml.strDannieUrl;
				spbPdfPage.to = pdfDoc.pageCount;//Задаём максимальное количество страниц в DCSpinBox
				cppqml.strDebug = pdfDoc.error
			}
		}
		PdfMultiPageView{
			id:pmpDoc
			anchors.fill: tmZona
			document: pdfDoc
			onCurrentPageChanged: {
				spbPdfPage.value = pmpDoc.currentPage + 1
			}
		}
		Rectangle {
			id: rctBorder
			anchors.fill: tmZona
			color: "transparent"
			border.color: tmPdf.clrTexta
			border.width: tmPdf.ntCoff/2//Бордюр при переименовании и удалении.
		}
        DCMenu {//Меню отображается в Рабочей Зоне приложения.
            id: menuMenu
            visible: false//Невидимое меню.
            ntWidth: tmPdf.ntWidth
            ntCoff: tmPdf.ntCoff
            anchors.left: tmZona.left
            anchors.right: tmZona.right
            anchors.bottom: tmZona.bottom
            anchors.margins: tmPdf.ntCoff
            clrTexta: tmPdf.clrTexta
            clrFona: "SlateGray"
            imyaMenu: "vihod"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
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
            ntWidth: tmPdf.ntWidth
            ntCoff: tmPdf.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            anchors.margins: tmPdf.ntCoff/2
            clrKnopki: tmPdf.clrTexta
            clrFona: tmPdf.clrFona
            onClicked: {//Слот сигнала нажатия на кнопку Меню.
                menuMenu.visible ? menuMenu.visible = false : menuMenu.visible = true;//Изменяем видимость
            }
        }
		DCSpinBox {
			id: spbPdfPage
			ntWidth: tmPdf.ntWidth
			ntCoff: tmPdf.ntCoff
			anchors.centerIn: tmToolbar
			visible: true
			clrTexta: tmPdf.clrTexta
			clrFona: tmPdf.clrFona 
			radius: tmPdf.ntCoff/2
			from: 1
			value: 1
			spinBox.cursorVisible: true;//Делаем курсор видимым обязательно.
			onClicked: function(ntValue){
				cppqml.strDebug = "StrPdf146 "+ntValue;
				pmpDoc.goToPage(ntValue-1);
			}
		}
	}
}
