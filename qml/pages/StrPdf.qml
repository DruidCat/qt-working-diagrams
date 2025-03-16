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
	property bool blPdfOpen: false;//true - когда pdf документ открывается.
    property bool blPdfPustoi: false;//true - когда пустой pdf документ открывается.
    property bool blPdfScale: false;//true - когда в pdf документе задали изменение масштаба.
    property bool blStartWidth: false//true - пришёл сигнал открывать документ с ссылкой на него или закрытие.
	property bool blStartHeight: false//true - пришёл сигнал открывать документ с ссылкой на него или закрытие
	property bool blError: false//true - ошибка, закрываем страницу.
	property bool blSizeApp: false//true - размер окна приложения изменился.
	property int ntStrValue: 0//Переменная, которая сохраняет значение страницы при переключении страниц на 0.
    property real pdfDocWidth: 0//Максимальная ширина страницы документа
    property real pdfDocHeight: 0//Максимальная высота страницы документа
    property bool blDocVert: true;//true - вертикальный документ, false - горизонтальный документ.
    property int  ntPdfPage: 0;//Номер страницы из БД.
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

        }
		if((event.key === 16777237)||(event.key === 16777239)){//Если нажата "Page Down",то.
            var ntStrDown = pmpDoc.currentPage + 1;
            if(ntStrDown < pdfDoc.pageCount)
                fnPdfGoToPage(ntStrDown);
			
        }
		if((event.key === 16777235)||(event.key === 16777238)){//Если нажата "Page Up", то.
            var ntStrUp = pmpDoc.currentPage - 1;//-1 страница
            if(ntStrUp >= 0)//Если больше 0, то листаем к началу документа.
                fnPdfGoToPage(ntStrUp);//На -1 страницу.
		}
		//cppqml.strDebug = event.key;
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmPdf
        //onClicked:
    }
	function fnTimerStart(){//Функция старта таймера.
		if(!tmrLogoTMK.running){//Если таймер еще не запускался, то...
            pmpDoc.visible = false;//Делаем невидимым pdf документ.
            pmpDoc.document = pdfDocPustoi;
            pmpDoc.document = pdfDoc;
            tmPdf.ntStrValue = spbPdfPage.value;//Сохраняем номер страницы.
            fnPdfGoToPage(-1);//Переключаемся на страницу -1 (0 нельзя), чтоб потом переключиться на нужную.
		}
		lgTMK.ntCoff = 11;//Задаём размер логотипа.
		tmrLogoTMK.running = true;//Таймер запустить.
	}
	function fnPdfOtkrit(){//Функция открытия Pdf документа.
        var strPdfUrl = cppqml.strDannieUrl;//Считываем путь+документ.pdf
        //console.error("93: Url: " + strPdfUrl);
        pdfDoc.source = strPdfUrl; 

        pdfDocHeight = pdfDoc.pagePointSize(ntPdfPage).height;//Высота страницы.
        pdfDocWidth = pdfDoc.pagePointSize(ntPdfPage).width;//Ширина страницы.
        if(pdfDocHeight >= pdfDocWidth)//Расчитываем, вертикальный или горизонтальный документ.
            blDocVert = true;
        else
            blDocVert = false;

        spbPdfPage.from = 1;//Задаём минимальное количество страниц в DCSpinBox
		spbPdfPage.to = pdfDoc.pageCount;//Задаём максимальное количество страниц в DCSpinBox	
    }
	function fnPdfDocStatus() {//Статус после открытия документа pdf.
		if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
            console.error("109:fnPdfDocStatus Error ");
            tmPdf.blPdfScale = false;//
            tmPdf.blError = true;//Ошибка.
            if(tmPdf.blPdfPustoi){//Если открывается пустой pdf документ.
                tmPdf.blPdfPustoi = false;//Сбрасываем флаг.
                tmPdf.clickedNazad();//Сигнал нажатия кнопки Назад.
            }
		}
		else{//Если не ошибка, то...
			tmPdf.blError = false;//Не Ошибка. Сбрасывает флаг при повторном открытии.
			if(pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился, то...
				tmPdf.blPdfOpen = true;//Документ открылся.	
                pssPassword.blVisible = false;//Документ открылся, невидимым поле ввода пароля делаем тут.
                console.error("122:fnPdfDocStatus Ready");
                if(tmPdf.blPdfPustoi){//Если открывается пустой pdf документ.
                    tmPdf.blPdfPustoi = false;//Сбрасываем флаг.
                    tmPdf.clickedNazad();//Сигнал нажатия кнопки Назад.
                }
			}
		}
	}

	function fnPdfPageStatus(){//Статус рендеринга страницы открываемой.
        if(pmpDoc.currentPageRenderingStatus === Image.Loading){//Статус рендеринга страницы ЗАГРУЗКА.
            console.error("133:Статус рендера страницы: "+ pmpDoc.currentPage +" Загрузка.");
		}

        if(pmpDoc.currentPageRenderingStatus === Image.Ready){//Статус рендеринга страницы ОТКРЫТ.
            console.error("137:Статус рендера страницы: "+ pmpDoc.currentPage +" Открыт.");
            if(tmPdf.blPdfOpen){//Если это рендер самой первой страницы после открытия pdf документа, то.
                console.error("139: RenderPage Ready. blPdfScale: " + tmPdf.blPdfScale);
                if(!tmPdf.blPdfScale){//Если стартового масштабирование не было, то...
                    tmPdf.blPdfScale = true;//Активируем флаг, что началось первичное масштабирование.
                    fnScale();//Выставляем масштаб в зависимости от формата pdf документа.
                }
                else{//Если первичное масштабирование произошло, то...
                    tmPdf.blPdfOpen = false;//сбрасываем флаг открытия документа.
                    tmPdf.blPdfScale = false;//Сбрасываем флаг масштабирование первичного.
                    if(tmPdf.ntPdfPage){//Если это не 0(1) страница (то она и так уже открылась), то goToPage
                        console.error("148:Timer tmrGoToPage start");
                        tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
                    }
                }
            }
            else{//Если это не первый рендер страницы, то...
            }
            pmpDoc.visible = true;//Делаем видимым документ.
        }
	}
	function fnPdfGoToPage(ntPage){//Функция обрабатывающая переход на новую страницу документа.
        console.error("154:fnPdfGoToPage Номер страницы: " + ntPage);
		pmpDoc.goToPage(ntPage);//Переключаемся на страницу
	}
	Timer {//Таймер необходим, чтоб pdf документ успел отрендериться, и можно было выставить страницу.
		id: tmrGoToPage
		interval: 333 
		running: false
		repeat:	false 
		onTriggered: {
            console.error("163:Timer tmrGoToPage stop");
            fnPdfGoToPage(ntPdfPage);//Выставляем страницу из БД.
			spbPdfPage.value = pmpDoc.currentPage + 1//DCSpinBox выставляем значение открытой стр.
		}
	}
	function fnPdfPokaz(){
		tmrLogoTMK.running = false;//выключаем таймер.
		if(tmPdf.blError){//Если был сигнал об ошибке, то...
			if(pssPassword.blVisible){//Если поле пароля видимо, значит, вводим пароль.
				knopkaPoisk.visible = false;//Делаем нивидимым кнопку поиска.
				spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
				pdfScale.visible = false;//Делаем невидимым DCScale
			}
			else{//Если не видимое, значит это какая то ошибка.
				cppqml.strDebug = qsTr("Ошибка открытия документа: ") + pdfDoc.error;
				fnNazad();//Выходим со страницы.
			}
		}
		else{//Если не было сигнала об ошибке, то...
            fnScale();//Выставляем масштаб по ширине или по высоте в зависимости от размера документа.
            if(tmPdf.blSizeApp){//Изменились размеры приложения.
                tmPdf.blSizeApp = false;//Обнуляем флаг.
                fnPdfGoToPage(tmPdf.ntStrValue - 1);//Выставляем страницу из БД.
                spbPdfPage.value = tmPdf.ntStrValue;//Эта строчка для Qt6 нужна. НЕ УДАЛЯТЬ!
                tmPdf.ntStrValue = 0;//Обнуляем.
            }
            else{
                fnPdfGoToPage(ntPdfPage);//Выставляем страницу из БД.
                spbPdfPage.value = pmpDoc.currentPage + 1//Эта строчка для Qt6. НЕ УДАЛЯТЬ!
            }
            pmpDoc.visible = true;//Делаем видимым pdf документ.
        }
	}
    function fnScale(){
        console.error("193:fnScale")
        var widthRect = tmZona.childrenRect.width;
        var heightRect = tmZona.childrenRect.height;
        if(blDocVert){//Если вертикальная страница, то...
            pmpDoc.scaleToPage(widthRect, heightRect);//масштаб по высоте страницы.
        }
        else{//Если горизонтальная страница, то...
            pmpDoc.scaleToWidth(widthRect, heightRect);//Масштаб по ширине страницы.
        }
        var ntScale = pmpDoc.renderScale*100;//Чтоб несколько раз не вызывать, так быстрее.
        pdfScale.from = ntScale;//Выставляем минимальное значение масштаба по уст. масштабу документа.
        pdfScale.value = ntScale;//И только после pdfScale.from выставляем значение масштаба в DCScale
    }

	function fnNazad(){//Функция Выхода со страницы, не путать с fnClickedNazad()
		//pmpDoc.visible = false;//Делаем невидимым pdf документ.
		tmPdf.blStartWidth = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
		tmPdf.blStartHeight = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
        //Обязательная пустой Url, он что то обнуляет, после запароленного файла. И не только.
        tmPdf.ntPdfPage = 0;//Открываем первую страницу в пустом файле.
        tmPdf.blPdfPustoi = true;//Открываем пустой pdf документ.
        pdfDoc.source = "qrc:///workingdata/000000000.dc";
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
                fnPdfOtkrit();
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
				pssPassword.blVisible = false;
				fnNazad();//Закрываем окно с pdf документом.
            }
			onBlVisibleChanged: {//Если видимость изменилась, то...
				if(pssPassword.blVisible){
					password = "";//Обнуляем вводимый пароль в TextInput.
                    spbPdfPage.spinBox.readOnly = true;//запрещаем редактировать для Android.
                    textInput.readOnly = false;//разрешаем редактировать.
				}
				else{
					password = "";//Обнуляем вводимый пароль в TextInput.
                    spbPdfPage.spinBox.readOnly = false;//разрешаем редактировать для Android.
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
					spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
					pdfScale.visible = false;//Делаем невидимым DCScale
				}
				else{//Если таймер выключен, то...
					knopkaPoisk.visible = true;//Делаем видимым кнопку поиска.
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
				fnPdfDocStatus();//Обработаем данное изменение статуса. 
			}
			onPasswordRequired: {//Если пришёл сигнал passwordRequire запроса пароля в pdf документе, то...
				pssPassword.blVisible = true;//Делаем видимым поле ввода пароля.
			}	
		}
        PdfDocument {//Класс, который возвращает данные о Pdf Документе.
            id: pdfDocPustoi
            source: "qrc:///workingdata/000000000.dc";
        }
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
				tmPdf.blStartWidth = true;//Стартуем, блокируем первое изменение размеров окна.
				tmPdf.blStartHeight = true;//Стартуем, блокируем первое изменение размеров окна.
                ntPdfPage = cppqml.strDannieStr;//Считываем из БД номер странцы документа.
                pmpDoc.document = pdfDocPustoi;//Переключаюсь на пустую сцену, чтоб обнулить прошлую сцену.
                pmpDoc.document = pdfDoc;//переключаемся на работую и обнулённую сцену.
                fnPdfOtkrit();//Функция открытия Pdf документа.
			}
		}
		PdfMultiPageView{
			id:pmpDoc
			anchors.fill: tmZona
			document: pdfDoc
            visible: false
			onCurrentPageChanged: {//Если страница документа изменилась, то...
				spbPdfPage.value = pmpDoc.currentPage + 1//В DCSpinBox выставляем значение открытой страницы.
			}
			onCurrentPageRenderingStatusChanged:{//Если рендер страницы изменился, то...
				fnPdfPageStatus();//Обрабатывает событие изменения статуса рендеринга страницы.
			}
			onVisibleChanged: {//Если Видимость изменилась, то...
				if(visible){//Если видимый документ, то...
					knopkaPoisk.visible = true;//Делаем видимым кнопку поиска.
					spbPdfPage.visible = true;//Делаем видимым DCSpinBox
					pdfScale.visible = true;//Делаем видимым DCScale
				}
				else{//Если невидимый документ, то...
					knopkaPoisk.visible = false;//Делаем нивидимым кнопку поиска.
					spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
					pdfScale.visible = false;//Делаем невидимым DCScale
				}
			}
		}
		/*
		PdfScrollablePageView{
			id: pspDoc
			anchors.fill: tmZona
			document: pdfDoc
			visible: false
			onCurrentPageChanged: {
				spbPdfPage.value = pmpDoc.currentPage + 1
			}
		}
		*/
		Rectangle {
			id: rctBorder
			anchors.fill: tmZona
			color: "transparent"
			border.color: tmPdf.clrTexta
			border.width: tmPdf.ntCoff/4//Бордюр при переименовании и удалении.
		}
	}
    Item {//Тулбар
		id: tmToolbar
        DCSpinBox {//@disable-check M300
			id: spbPdfPage
			ntWidth: tmPdf.ntWidth
			ntCoff: tmPdf.ntCoff
			visible: false 
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            anchors.margins: tmPdf.ntCoff/2
			clrTexta: tmPdf.clrTexta
			clrFona: tmPdf.clrFona 
			radius: tmPdf.ntCoff/2
			from: 1
			value: 1
			spinBox.cursorVisible: true;//Делаем курсор видимым обязательно.
			onValueModified:{//Если значение измениловь в DCSpinBox...
				fnPdfGoToPage(value-1)
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
                pmpDoc.renderScale = pdfScale.value/100;
			}	
		}
	}
}
