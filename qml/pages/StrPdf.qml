import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14
import QtQuick.Pdf //5.15

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
    property int ntLogoTMK: 16
	property bool blStartWidth: false//true - пришёл сигнал открывать документ с ссылкой на него или закрытие.
	property bool blStartHeight: false//true - пришёл сигнал открывать документ с ссылкой на него или закрытие
	property bool blError: false//true - ошибка, закрываем страницу.
	property bool blScale: false//true - включили изменение масштаба.
	property bool blSizeApp: false//true - размер окна приложения изменился.
	property int ntStrValue: 0//Переменная, которая сохраняет значение страницы при переключении страниц на 0.
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

	onWidthChanged:{//Первое изменение при открытии окна и последнее изменения при закрытии окна.
		if(tmPdf.blStartWidth)//Окно открылось, не обрабатываем сигнал об изменении..
			tmPdf.blStartWidth = false;//Взводим флаг на оброботку размера.
		else{
			tmPdf.blSizeApp = true;//Размер окна изменился.
			fnTimerStart();//Запускаем таймер.
		}
	}
	onHeightChanged:{//Первое изменение при открытии окна и последнее изменения при закрытии окна.
		if(tmPdf.blStartHeight)//Окно открылось, не обрабатываем сигнал об изменении..
			tmPdf.blStartHeight = false;//Взводим флаг на оброботку размера.
		else{
			tmPdf.blSizeApp = true;//Размер окна изменился.
			fnTimerStart();//Запускаем таймер.	
		}
	}
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            menuMenu.visible = false;//Делаем невидимым всплывающее меню.
        }
		if(event.key === 16777237){//Если нажата "Стрека вниз"

		}
		if(event.key === 16777235){//Если нажата "Стрека вверх"

		}
		if((event.key === 16777237)||(event.key === 16777239)){//Если нажата "Page Down",то.
            var ntStrDown = pmpDoc.currentPage + 1;
            if(ntStrDown < pdfDoc.pageCount)
                pmpDoc.goToPage(ntStrDown);
			
        }
		if((event.key === 16777235)||(event.key === 16777238)){//Если нажата "Page Up", то.
            var ntStrUp = pmpDoc.currentPage - 1;//-1 страница
            if(ntStrUp >= 0)//Если больше 0, то листаем к началу документа.
                pmpDoc.goToPage(ntStrUp);//На -1 страницу.
		}
		//cppqml.strDebug = event.key;
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmPdf
        onClicked: menuMenu.visible = false
    }
	function fnTimerStart(){//Функция старта таймера.
		if(!tmrLogoTMK.running){//Если таймер еще не запускался, то...
			pmpDoc.visible = false;//Делаем невидимым pdf документ.
			tmPdf.ntStrValue = spbPdfPage.value;//Сохраняем номер страницы.
			pmpDoc.goToPage(-1);//Переключаемся на страницу -1 (0 нельзя), чтоб потом переключиться на нужную.
		}
		lgTMK.ntCoff = 11;//Задаём размер логотипа.
		tmrLogoTMK.running = true;//Таймер запустить.
		console.error("Таймер взводится.");
	}
	function fnPdfOtkrit(){//Функция открытия Pdf документа.
        console.error(cppqml.strDannieUrl);
		pdfDoc.source = cppqml.strDannieUrl;
		spbPdfPage.from = 1;//Задаём минимальное количество страниц в DCSpinBox
		spbPdfPage.to = pdfDoc.pageCount;//Задаём максимальное количество страниц в DCSpinBox	
		fnTimerStart();//Запускаем таймер.
	}
	function fnPdfPokaz(){
		tmrLogoTMK.running = false;//выключаем таймер.
		if(tmPdf.blError){//Если был сигнал об ошибке, то...
			if(pssPassword.blVisible){//Если поле пароля видимо, значит, вводим пароль.
				knopkaPoisk.visible = false;//Делаем нивидимым кнопку поиска.
				knopkaMenu.visible = false;//Делаем невидимым кнопку меню.
				spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
				pdfScale.visible = false;//Делаем невидимым DCScale
			}
			else{//Если не видимое, значит это какая то ошибка.
				cppqml.strDebug = qsTr("Ошибка открытия документа: ") + pdfDoc.error;
				fnNazad();//Выходим со страницы.
			}
		}
		else{//Если не было сигнала об ошибке, то...
			if(tmPdf.blSizeApp){//Изменились размеры приложения.
				tmPdf.blSizeApp = false;//Обнуляем флаг.
				pmpDoc.goToPage(tmPdf.ntStrValue - 1);//Выставляем страницу из БД.
				spbPdfPage.value = tmPdf.ntStrValue;//Эта строчка для Qt6 нужна. НЕ УДАЛЯТЬ!
				tmPdf.ntStrValue = 0;//Обнуляем.
				console.error("148: Timer Size");
			}
			else{
				if(tmPdf.blScale){//Если выбран режим масштабирования, то...
					tmPdf.blScale = false;//Обнуляем флаг.
					//pmpDoc.goToPage(tmPdf.ntStrValue - 1);//Выставляем страницу из БД.
					//spbPdfPage.value = tmPdf.ntStrValue;//Эта строчка для Qt6 нужна. НЕ УДАЛЯТЬ!
					tmPdf.ntStrValue = 0;//Обнуляем.
					console.error("155: Timer Scale");
				}
				else{
					pmpDoc.resetScale();//Выставляет масштаб 1 к 1, при открытии документа.
					pdfScale.value = pmpDoc.renderScale*100;//выставляем значение в DCScale
					pmpDoc.goToPage(cppqml.strDannieStr);//Выставляем страницу из БД.
					spbPdfPage.value = pmpDoc.currentPage + 1//Эта строчка для Qt6. НЕ УДАЛЯТЬ!
					console.error("155: Timer Показ страницы");
                    //pmpDoc.scaleToWidth(tmZona.childrenRect.width, tmZona.childrenRect.height)
					//TODO отцентровать документ по длине высоте окна. Это важно!
					//console.error(pdfDoc.pagePointSize(cppqml.strDannieStr));//Размер Страницы
					//var imW = tmZona.childrenRect.width;
					//var imH = tmZona.childrenRect.height;
					//console.error (imW + " " + imH)
					//cppqml.strDebug = cppqml.strDannieStr;
				}
			}
		}
		pmpDoc.visible = true;//Делаем видимым pdf документ.
	}
	function fnNazad(){//Функция Выхода со страницы, не путать с fnClickedNazad()
		pmpDoc.visible = false;//Делаем невидимым pdf документ.
		menuMenu.visible = false;//Делаем невидимым меню.
		tmPdf.blStartWidth = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
		tmPdf.blStartHeight = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
        pdfDoc.source = "file:///";//Обязательная пустой Url, он что то обнуляет, после запароленного файла.
		tmPdf.clickedNazad();//Сигнал нажатия кнопки Назад.
	}
	Item {
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
			ntWidth: tmPdf.ntWidth
			ntCoff: tmPdf.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmPdf.ntCoff/2
			clrKnopki: tmPdf.clrTexta
			onClicked: {
				cppqml.strDannieStr = pmpDoc.currentPage;//Записываем в БД номер открытой страницы.
        		fnNazad();//Выходим со страницы.        
			}
		}
        DCKnopkaPoisk{//@disable-check M300
            id: knopkaPoisk
            ntWidth: tmPdf.ntWidth
            ntCoff: tmPdf.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
            anchors.margins: tmPdf.ntCoff/2
            clrKnopki: tmPdf.clrTexta
            clrFona: tmPdf.clrFona
            onClicked: {//Слот сигнала clicked кнопки Поиск.
				pssPassword.blVisible = true;
                //fnClickedPoisk();//Функция обрабатывающая кнопку Поиск.
            }
        }
        DCPassword{//@disable-check M300
            id: pssPassword
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            anchors.topMargin: tmPdf.ntCoff/4
            anchors.bottomMargin: tmPdf.ntCoff/4
            anchors.leftMargin: tmPdf.ntCoff/2
            anchors.rightMargin: tmPdf.ntCoff/2

            ntWidth: tmPdf.ntWidth
            ntCoff: tmPdf.ntCoff

            textInput.readOnly: true//запрещаем редактировать.

            clrFona: "black"
            clrFonaPass: "orange"
            clrTexta: "black"
            clrKnopki: "yellow"
            clrBorder: "yellow"
			placeholderText: qsTr("ВВЕДИТЕ ПАРОЛЬ ДОКУМЕНТА")
            onClickedOk: function (strPassword)  {//Слот нажатия кнопки Ок
				pdfDoc.password = strPassword;//Передаём пароль в документ.
				pssPassword.blVisible = false;//И только потом делаем невидимым поле ввода.
				fnPdfOtkrit();
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
				pssPassword.blVisible = false;
				fnNazad();//Закрываем окно с pdf документом.
            }
			onBlVisibleChanged: {//Если видимость изменилась, то...
				if(pssPassword.blVisible){
					password = "";//Обнуляем вводимый пароль в TextInput.
					textInput.readOnly = false;//разрешаем редактировать.
				}
				else{
					password = "";//Обнуляем вводимый пароль в TextInput.
					textInput.readOnly = true;//запрещаем редактировать.
				}
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
					fnPdfPokaz();//Показываем pdf документ.	
				}
			}
			onRunningChanged: {//Если running поменялся, то...
				if(running){//Если запустился таймер, то...
					knopkaPoisk.visible = false;//Делаем нивидимым кнопку поиска.
					knopkaMenu.visible = false;//Делаем невидимым кнопку меню.
					spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
					pdfScale.visible = false;//Делаем невидимым DCScale
				}
				else{//Если таймер выключен, то...
					knopkaPoisk.visible = true;//Делаем видимым кнопку поиска.
					knopkaMenu.visible = true;//Делаем видимым кнопку меню.
					spbPdfPage.visible = true;//Делаем видимым DCSpinBox
					pdfScale.visible = true;//Делаем видимым DCScale
				}
			}
		}
        DCLogoTMK {//@disable-check M300//Логотип до ZonaFileDialog, чтоб не перекрывать список.
			id: lgTMK
			ntCoff: tmPdf.ntLogoTMK
			anchors.centerIn: tmZona
			clrLogo: tmPdf.clrTexta
			clrFona: tmPdf.clrFona
		}
		PdfDocument {//Класс, который возвращает данные о Pdf Документе.
			id: pdfDoc
			onStatusChanged:{//Если статус status изменился, то...
				if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
					tmPdf.blError = true;//Ошибка.	
				}
				else//Если не ошибка, то...
					tmPdf.blError = false;//Не Ошибка. Сбрасывает флаг при повторном открытии.
			}
			onPasswordRequired: {//Если пришёл сигнал passwordRequire запроса пароля в pdf документе, то...
				pssPassword.blVisible = true;//Делаем видимым поле ввода пароля.
			}	
		}
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
				tmPdf.blStartWidth = true;//Стартуем, блокируем первое изменение размеров окна.
				tmPdf.blStartHeight = true;//Стартуем, блокируем первое изменение размеров окна.
				fnPdfOtkrit();//Функция открытия Pdf документа.	
			}
		}
		PdfMultiPageView{//PdfScrollablePageView
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
			border.width: tmPdf.ntCoff/4//Бордюр при переименовании и удалении.
		}
        DCMenu {//@disable-check M300//Меню отображается в Рабочей Зоне приложения.
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
        DCKnopkaNastroiki {//@disable-check M300//Кнопка Меню.
			id: knopkaMenu
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
        DCSpinBox {//@disable-check M300
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
        DCScale{//@disable-check M300
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
			stepSize: 25
			scale.cursorVisible: true;//Делаем курсор видимым обязательно.
			onValueModified:{//Если значение измениловь в DCScale...
				console.error("299: pdfScale");
				//tmPdf.blScale = true;//Масштаб изменился.
				//fnTimerStart();//Запускаем таймер.
				pmpDoc.renderScale = value/100;//Масштаб 1 - это оригинальный масштаб, 0.5 - это на 50% меньше
			}
		}
	}
}
