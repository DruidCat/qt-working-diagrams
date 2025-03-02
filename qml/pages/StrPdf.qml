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
    property int ntLogoTMK: 16
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            menuMenu.visible = false;//Делаем невидимым всплывающее меню.
        }
		if(event.key === 16777237){//Если нажата "Стрека вниз"

		}
		if(event.key === 16777235){//Если нажата "Стрека вверх"

		}
		if((event.key === 16777237)||(event.key === 16777239)){//Если нажата "Page Down",то.
			var ntStr = pmpDoc.currentPage + 1;
			if(ntStr < pdfDoc.pageCount)
				pmpDoc.goToPage(ntStr);
			
        }
		if((event.key === 16777235)||(event.key === 16777238)){//Если нажата "Page Up", то.
			var ntStr = pmpDoc.currentPage - 1;//-1 страница
			if(ntStr >= 0)//Если больше 0, то листаем к началу документа.
				pmpDoc.goToPage(ntStr);//На -1 страницу.
		}
		//cppqml.strDebug = event.key;
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
				pmpDoc.visible = false;//Делаем невидимым pdf документ.
				spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
				pdfScale.visible = false;//Делаем невидимым DCScale
				cppqml.strDannieStr = pmpDoc.currentPage;//Записываем в БД номер открытой страницы.
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
		Timer {//Таймер необходим, чтоб pdf документ успел отрендериться, и можно было выставить страницу.
			id: tmrLogoTMK
			interval: 111
			running: false
			repeat: true
			onTriggered: {
				lgTMK.ntCoff++;
				if(lgTMK.ntCoff >= tmPdf.ntLogoTMK){
					running = false;//выключаем таймер.
					//cppqml.strDebug = cppqml.strDannieStr;
					pmpDoc.goToPage(cppqml.strDannieStr);//Выставляем страницу из БД.
					spbPdfPage.value = pmpDoc.currentPage + 1//Эта строчка для Qt6 нужна. НЕ УДАЛЯТЬ!
					var imW = tmZona.childrenRect.width;
					var imH = tmZona.childrenRect.height;
					console.error (imW + " " + imH)
					//TODO отцентровать документ по длине высоте окна. Это важно!
					var scale = pmpDoc.renderScale;
					console.error(scale);
					//pmpDoc.scaleToWidth(690, 778);
					//pmpDoc.resetScale();//Не в ошибку.
					pmpDoc.renderScale = pdfScale.value/100;//Отображаем в заданом value/100  масштабе
					spbPdfPage.visible = true;//Делаем видимым DCSpinBox
					pdfScale.visible = true;//Делаем видимым DCScale
					pmpDoc.visible = true;//Делаем видимым pdf документ.
				}
			}
		}
		DCLogoTMK {//Логотип до ZonaFileDialog, чтоб не перекрывать список.
			id: lgTMK
			ntCoff: tmPdf.ntLogoTMK
			anchors.centerIn: tmZona
			clrLogo: tmPdf.clrTexta
			clrFona: tmPdf.clrFona
		}
		PdfDocument {//Класс, который возвращает данные о Pdf Документе.
			id: pdfDoc
		}
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
				pdfDoc.source = cppqml.strDannieUrl;
				spbPdfPage.from = 1;//Задаём минимальное количество страниц в DCSpinBox
				spbPdfPage.to = pdfDoc.pageCount;//Задаём максимальное количество страниц в DCSpinBox
				lgTMK.ntCoff = 11;//Задаём размер логотипа.
				tmrLogoTMK.running = true;//включаем таймер.
				//cppqml.strDebug = pdfDoc.error
			}
		}
		PdfMultiPageView{
			id:pmpDoc
			anchors.fill: tmZona
			document: pdfDoc
			visible: false
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
			visible: false 
			clrTexta: tmPdf.clrTexta
			clrFona: tmPdf.clrFona 
			radius: tmPdf.ntCoff/2
			from: 1
			value: 1
			spinBox.cursorVisible: true;//Делаем курсор видимым обязательно.
			onValueModified:{//Если значение измениловь в DCSpinBox...
				pmpDoc.goToPage(value-1)
			}
		}
		DCScale{
			id: pdfScale
			ntWidth: tmPdf.ntWidth
			ntCoff: tmPdf.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			visible: true
			clrTexta: tmPdf.clrTexta
			clrFona: tmPdf.clrFona 
			radius: tmPdf.ntCoff/2
			from: 25
			to: 200
			value: 100
			step: 25
			scale.cursorVisible: true;//Делаем курсор видимым обязательно.
			onValueModified:{//Если значение измениловь в DCScale...
				pmpDoc.renderScale = value/100;//Масштаб 1 - это оригинальный масштаб, 0.5 - это на 50% меньше
			}
		}
	}
}
