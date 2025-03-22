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
    property bool blLogoTMK: false;//true - логотип на увеличение.
    property bool blOpen: false;//true - когда pdf документ открывается.
    property bool blSize: false;//true - когда pdf документ изменяет размер при масштабе приложения.
    property bool blPustoi: false;//true - когда пустой pdf документ открывается.
    property bool blScale: false;//true - когда в pdf документе масштабирование произошло.
    property bool blError: false//true - взведён флаг в Статусе документа, чтоб не взводить таймер ошибки.
    property bool blPassword: false;//true - когда в pdf документе запрашиваем пароль.
    property bool blStartWidth: false//true - пришёл сигнал открывать документ с ссылкой на него или закрытие.
	property bool blStartHeight: false//true - пришёл сигнал открывать документ с ссылкой на него или закрытие
    //Расчитываемые при открытии pdf документа.
    property bool blDocVert: true;//true - вертикальный документ, false - горизонтальный документ.
    property int  ntPdfPage: 0;//Номер страницы из БД.
    anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

	onWidthChanged:{//Первое изменение при открытии окна и последнее изменения при закрытии окна.
		if(tmPdf.blStartWidth)//Окно открылось, не обрабатываем сигнал об изменении..
			tmPdf.blStartWidth = false;//Взводим флаг на оброботку размера.
		else
            fnTimerAppSize();//Запускаем таймер.
	}
	onHeightChanged:{//Первое изменение при открытии окна и последнее изменения при закрытии окна.
		if(tmPdf.blStartHeight)//Окно открылось, не обрабатываем сигнал об изменении..
			tmPdf.blStartHeight = false;//Взводим флаг на оброботку размера.
		else
            fnTimerAppSize();//Запускаем таймер.
	}
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
			if(txnZagolovok.visible)//Если строка ввода запроса на поиск видима, то...
				fnClickedZakrit();//Закрываем эту строку
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
	function fnPdfOtkrit(){//Функция открытия Pdf документа.
        tmrLogo.running = true;//включаем таймер, и тем самым не показываем документ и кнопки.
        var strPdfUrl = cppqml.strDannieUrl;//Считываем путь+документ.pdf
        console.error("80: Url: " + strPdfUrl);
        pdfDoc.source = strPdfUrl;
        //Расчитываем, вертикальный или горизонтальный документ.
        if(pdfDoc.pagePointSize(ntPdfPage).height >= pdfDoc.pagePointSize(ntPdfPage).width)
            blDocVert = true;
        else
            blDocVert = false;
        spbPdfPage.from = 1;//Задаём минимальное количество страниц в DCSpinBox
		spbPdfPage.to = pdfDoc.pageCount;//Задаём максимальное количество страниц в DCSpinBox	
    }
    function fnPdfDocStatus() {//Статус после открытия документа pdf.
		console.error("91:fnPdfDocStatus: " + pdfDoc.status);
        if(tmPdf.blPustoi){//Если открывается пустой pdf документ. Именно тут вызываем. ЭТО ВАЖНО!
            tmPdf.blStartWidth = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
            tmPdf.blStartHeight = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
            if(!tmPdf.blError){//Если не был взведён флаг, то...
                tmPdf.blError = true;//Взводим флаг для Статуса ошибки, чтоб таймер ошибки не взводился.
				console.error("97:fnPdfDocStatus: перехожу к Данным сворачия проигрыватель.");
                tmPdf.clickedNazad();//Сигнал нажатия кнопки Назад.
            }
        }
        else{//Если это не пустой документ, обрабатываем статусы.
            if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
                console.error("103:fnPdfDocStatus Error. ");
                if(!tmPdf.blError)//Если не был взведён флаг, то...
                    tmrError.running = true;//Запускаю таймер с обработчиком ошибки. ТАЙМЕР КРИТИЧЕСКИ ВАЖЕН.
            }
            else{//Если не ошибка, то...
                if(pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился, то...
					if(tmPdf.blPustoi){//Если открылся пустой документ, то...
                    	tmPdf.blOpen = false;//Документ не нужно в прерывании обрабатывать.
						tmPdf.blPustoi = false;//сбрасываем флаг.
					}
					else//Если это рабочий документ, то...
                    	tmPdf.blOpen = true;//Документ открылся.
                    cppqml.strDebug = "";//Документ открыт, в тулбар не должно быть никаких надписей.
                    pssPassword.blVisible = false;//Документ открылся, невидимым поле ввода пароля делаем тут.
                    console.error("117:fnPdfDocStatus Ready");
                }
            }
        }
    }
	function fnPdfPageStatus(){//Статус рендеринга страницы открываемой.
        if(pmpDoc.currentPageRenderingStatus === Image.Loading){//Статус рендеринга страницы ЗАГРУЗКА.
            console.error("124:Статус рендера страницы: "+ pmpDoc.currentPage +" Загрузка.");
		}
        if(pmpDoc.currentPageRenderingStatus === Image.Ready){//Статус рендеринга страницы ОТКРЫТ.
            console.error("127:Статус рендера страницы: "+ pmpDoc.currentPage +" Открыт.");
            if(tmPdf.blOpen){//Если это рендер страницы после открытия документа, то.
                console.error("129:RenderPage Ready. blScale: " + tmPdf.blScale);
                if(!tmPdf.blScale){//Если стартового масштабирование не было, то...
                    tmPdf.blScale = true;//Активируем флаг, что началось первичное масштабирование.
                    console.error("132:Timer tmrScale start");
                    tmrScale.running = true;//запускаем таймер, перед переходом на страницу
                }
                else{//Если первичное масштабирование произошло, то...
                    tmPdf.blOpen = false;//сбрасываем флаг открытия документа.
                    tmPdf.blScale = false;//Сбрасываем флаг масштабирование первичного.
                    console.error("138:Timer tmrGoToPage start");
                    tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
                }
            }
        }
	}
	function fnPdfGoToPage(ntPage){//Функция обрабатывающая переход на новую страницу документа.
        console.error("145:fnPdfGoToPage Номер страницы: " + ntPage);
        pmpDoc.goToLocation(ntPage, Qt.point(0, 0), pmpDoc.renderScale);//Переходим на страницу.
		tmPdf.blSize = false;//Готов к изменению размера приложения.
        tmrLogo.running = false;//отключаем таймер, и тем самым показываем документ и кнопки.
        tmPdf.blLogoTMK = false;//Делаем флаг анимации логотипа ТМК на уменьшение.
        lgTMK.ntCoff = ntLogoTMK;//Задаём размер логотипа.
    }
    function fnTimerAppSize(){//Функция старта таймера при изменении размеров приложения пользователем.
		if(!tmPdf.blSize){//Принимаю размеры приложения, пока не запустится обработкик показа документа.
			if(!tmrAppSize.running){//Если таймер еще не запускался, то...
				console.error("155:fnTimerAppSize. running");
				tmPdf.ntPdfPage = spbPdfPage.value - 1;//Сохраняем номер страницы.
				tmrLogo.running = true;//Запуск основного таймера.
				console.error("158:fnTimerAppSize. pdfDocPustoi");
				pmpDoc.document = pdfDocPustoi;
			}
			tmrAppSize.running = true;//Таймер запустить.
		}
    }
    function fnAppSize(){//Функция показывает документ после изменения размера приложения.
		tmPdf.blOpen = true;//Только тут задаю этот флаг отрисовки документа.
		tmPdf.blSize = true;//Открываем документ, игнорируя изменения размера приложения.
        tmPdf.blScale = false;//Масштабирования еще не было.
        tmrAppSize.running = false;//выключаем таймер.
        console.error("169:fnAppSize. pdfDoc");
        pmpDoc.document = pdfDoc;//Выставляем рабочую сцену.
        if(!ntPdfPage){//Если 0 страница, то рендер будет мгновенный, поэтому...
			tmPdf.blScale = true;//масштабировать не нужно, сразу на страницу.
            fnScale(false);//Выставляем масштаб по ширине или по высоте в зависимости от размера документа.
        }
    }
    function fnScale(blScaleSize){//Функция первоначального масштабирования в зависимости от формата pdf документа.
        console.error("177:fnScale: " + blScaleSize);
		if(blScaleSize){//Если выбрано масштабирование ручное от пользователя, то...
			tmrLogo.running = true;//Замускаем таймер анимации логотипа
			pmpDoc.renderScale = pdfScale.value/100;//Выставляем масштаб из виджета
			tmrGoToPage.running = true;//Запускаем таймер перехода на страницу после масштабирования.
		}
		else{//Если масштабирование автоматическое, то...
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
    }
    function fnNazad(){//Функция Выхода со страницы, не путать с fnClickedNazad()
        tmPdf.blStartWidth = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
        tmPdf.blStartHeight = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
        //Обязательная пустой Url, он что то обнуляет, после запароленного файла. И не только.
        tmPdf.blPustoi = true;//Открываем пустой pdf документ, чтоб не проходить все стадии в прерывании стр.
        console.error("197:fnNazad. pdfDoc.source = qrc:///000000000.dc");
        pdfDoc.source = "qrc:///workingdata/000000000.dc";
    }
    Timer {//Таймер необходим, чтоб pdf документ успел отрендериться, и можно было масштабировать документ.
        id: tmrScale
        interval: 333
        running: false
        repeat:	false
        onTriggered: {
            console.error("206:Timer tmrScale stop");
            fnScale(false);//Выставляем масштаб в зависимости от формата pdf документа.
        }
    }
	Timer {//Таймер необходим, чтоб pdf документ успел отрендериться, и можно было выставить страницу.
		id: tmrGoToPage
        interval: 333
		running: false
		repeat:	false 
        onTriggered: {
            console.error("216:Timer tmrGoToPage stop");
            fnPdfGoToPage(ntPdfPage);//Выставляем страницу из БД.
			spbPdfPage.value = pmpDoc.currentPage + 1//DCSpinBox выставляем значение открытой стр.
		}
	}
    Timer {//Таймер необходим, чтоб пока пользователь изменяет размер окна приложения,не обрабатывался масштаб
        id: tmrAppSize
        interval: 333
        running: false
        repeat: false
        onTriggered: {
            fnAppSize();//Показываем pdf документ.
        }
    }
    Timer {//Таймер необходим, чтоб чтоб после аварии закрыть страницу.
        id: tmrError
        interval: 111
        running: false
        repeat:	false
        onTriggered: {
            console.error("236:Timer tmrError stop");
            if(tmPdf.blPassword){//Если был запрос на пароль, то...
                tmPdf.blPassword = false;//Сбрасываем флаг.
                if(!pssPassword.passTrue)//Если пароль введён неверно, то...
                    cppqml.strDebug = qsTr("Введён неверный пароль.");
            }
            else{//Если не было запроса на пароль, то это ошибка обычная...
                cppqml.strDebug = qsTr("Ошибка открытия документа: ") + pdfDoc.error;
                tmPdf.blStartWidth = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
                tmPdf.blStartHeight = true;//При закрытии окна этим флагом нивелируем обработку сигнала.
                tmrLogo.running = false;//Останавливаем таймер главной анимации.
                tmPdf.clickedNazad();//Закрываем страницу.
            }
        }
    }
    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 111
        running: false
        repeat: true
        onTriggered: {
            if(tmPdf.blLogoTMK){//Если true, то...
                lgTMK.ntCoff++;
                if(lgTMK.ntCoff >= tmPdf.ntLogoTMK)
                    tmPdf.blLogoTMK = false;
            }
            else{
                lgTMK.ntCoff--;
                if(lgTMK.ntCoff <= 1)
                    tmPdf.blLogoTMK = true;
            }
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                knopkaPoisk.visible = true;//Делаем нивидимым кнопку поиска.
                spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
                pdfScale.visible = false;//Делаем невидимым DCScale
                pmpDoc.visible = false;//Делаем отображение сцены невидимой.
            }
            else{//Если таймер выключен, то...
                knopkaPoisk.visible = true;//Делаем видимым кнопку поиска.
                spbPdfPage.visible = true;//Делаем видимым DCSpinBox
                pdfScale.visible = true;//Делаем видимым DCScale
                pmpDoc.visible = true;//Делаем отображение сцены видимой.
            }
        }
    } 
	function fnClickedPoisk(){//Функция обрабатывающая кнопку Поиск.
        txnZagolovok.placeholderText = qsTr("ПОИСК");//Подсказка пользователю,что вводить нужно
        txnZagolovok.visible = true;//Режим запроса на поиск ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
		console.error("Открываем запрос на поиск");
	}
	function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
		txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
		console.error("Закрыть");
	}
	function fnClickedOk(){//Функция отправить запрос на поиск
		pskPoisk.text = txnZagolovok.text;//текст присваиваем.
		pskPoisk.blVisible = true;//Делаем видимым режим поиска
		txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
	}
	Item {
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
			id: knopkaNazad
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
		DCKnopkaZakrit {//@disable-check M300
            id: knopkaZakrit
            ntWidth: tmPdf.ntWidth
            ntCoff: tmPdf.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            anchors.margins: tmPdf.ntCoff/2
            clrKnopki: tmPdf.clrTexta
            clrFona: tmPdf.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaNazad.right
			anchors.right: knopkaPoisk.left
			anchors.topMargin: tmPdf.ntCoff/4
			anchors.bottomMargin: tmPdf.ntCoff/4
			anchors.leftMargin: tmPdf.ntCoff/2
			anchors.rightMargin: tmPdf.ntCoff/2
            DCTextInput {//@disable-check M300
				id: txnZagolovok
				ntWidth: tmPdf.ntWidth
				ntCoff: tmPdf.ntCoff
				anchors.fill: tmTextInput
				visible: false
                textInput.readOnly: true;//Запрещено редактировать.
                clrTexta: tmPdf.clrTexta
				clrFona: "SlateGray"
				radius: tmPdf.ntCoff/2
				blSqlProtect: false//Отключаем защиту от Sql инъекций, вводить можно любой текст.
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                textInput.maximumLength: cppqml.untNastroikiMaxLength
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
						textInput.readOnly = false;//Можно редактировать.
                        knopkaNazad.visible = false;//Кнопка назад Невидимая.
                        knopkaPoisk.visible = false;//Конопка Поиск Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                        textInput.cursorVisible = true;//Делаем курсор видимым обязательно.
                        textInput.focus = true;//Фокусируемся для Android экранной клавиатуры.
                        textInput.forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
					}
                    else{//Если DCTextInput не видим, то...
						textInput.readOnly = true;//Запрещено редактировать.
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
						if(!pskPoisk.blVisible){//Если не открыли Режим поиска, то...
							console.error("Режим поиск невидимый");
							knopkaNazad.visible = true;//Кнопка назад видимая.
							knopkaPoisk.visible = true;//Конопка Поиск Видимая.
							knopkaPoisk.focus = true;//Фокус на кнопке Информация, чтоб не работал Enter.
                        	txnZagolovok.text = "";//Текст обнуляем вводимый.
						}
					}
				}
				onClickedEnter: {//слот нажатия кнопки Enter.
					fnClickedOk();//Функция отправить запрос на поиск
				}
			}
		}	
		DCKnopkaOk{//@disable-check M300
			id: knopkaOk
			ntWidth: tmPdf.ntWidth
			ntCoff: tmPdf.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmPdf.ntCoff/2
			clrKnopki: tmPdf.clrTexta
			clrFona: tmPdf.clrFona
			onClicked: {
				fnClickedOk();//Функция отправить запрос на поиск
			}
		}	
		DCPoisk {//@disable-check M300
            id: pskPoisk
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

            clrFona: "black"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "yellow"
            clrKnopki: "yellow"
            clrBorder: "orange"
            onClickedNext: function (strKod) {//Слот нажатия кнопки Следующего поиска

			}
			onClickedPrevious: function (strKod) {//Слот нажатия кнопки Предыдущего поиска

            }
            onClickedZakrit: {//Слот нажатия кнопки Отмены режима поиска. 
                pskPoisk.blVisible = false;//Делаем невидимый режим Поиска, и только после этого...
				txnZagolovok.textInput.readOnly = true;//Запрещено редактировать.
                knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                knopkaOk.visible = false;//Кнопка Ок Невидимая.
				knopkaNazad.visible = true;//Кнопка назад видимая.
				knopkaPoisk.visible = true;//Конопка Поиск Видимая.
				knopkaPoisk.focus = true;//Фокус на кнопке поиск, чтоб не работал Enter.
                txnZagolovok.text = "";//Текст обнуляем вводимый.
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
                fnClickedPoisk();//Функция обрабатывающая кнопку Поиск.
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
            placeholderTextTrue: qsTr("ВВЕДИТЕ ПАРОЛЬ ДОКУМЕНТА")
            placeholderTextFalse: qsTr("НЕВЕРНЫЙ ПАРОЛЬ ДОКУМЕНТА")
            onClickedOk: function (strPassword)  {//Слот нажатия кнопки Ок
				pdfDoc.password = strPassword;//Передаём пароль в документ.
                pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                pssPassword.passTrue = false;//Делаем крассным, если пароль верный, никто не увидит.
                fnPdfOtkrit();
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                pssPassword.blVisible = false;//Делаем невидимым виджет
                pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                fnNazad();//Закрываем окно с pdf документом.
            }
			onBlVisibleChanged: {//Если видимость изменилась, то...
				if(pssPassword.blVisible){
                    spbPdfPage.spinBox.readOnly = true;//запрещаем редактировать для Android.
                    textInput.readOnly = false;//разрешаем редактировать.
				}
				else{
                    spbPdfPage.spinBox.readOnly = false;//разрешаем редактировать для Android.
                    textInput.readOnly = true;//запрещаем редактировать.
				}
			}
        }
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.	

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
                console.error("379: Запрашиваю пароль.")
                tmPdf.blPassword = true;//Запрашиваю пароль.
				pssPassword.blVisible = true;//Делаем видимым поле ввода пароля.
			}	
		}
        PdfDocument {//Класс, который возвращает данные о Pdf Документе.
            id: pdfDocPustoi
            //source: "qrc:///workingdata/000000000.dc";
        }
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
                //Первоначальная иннициализация флагов.
				tmPdf.blStartHeight = true;//Стартуем, блокируем первое изменение размеров окна.
				tmPdf.blStartWidth = true;//Стартуем, блокируем первое изменение размеров окна.

                pssPassword.passTrue = true;//Пароль верный, текс стандартный, надпись стандартная.
                tmPdf.blOpen = false;//pdf документ ещё не открыт.
				tmPdf.blSize = false;//Готов к изменению размера приложения.
                tmPdf.blScale = false;//в pdf документе не задали изменение масштаба.

                tmPdf.blLogoTMK = false;//логотип на уменьшение.
                tmPdf.blPustoi = false;//пустой pdf документ ещё не открыт.
                tmPdf.blError = false;//флаг не взведён в Статусе пустого документа.
                tmPdf.blPassword = false;//pdf документ не запрашиваем пароль.

                tmPdf.ntPdfPage = cppqml.strDannieStr;//Считываем из БД номер странцы документа.

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
				fnScale(true);//Масштабируем документ по значению value этого виджета.
			}	
		}
	}
}
