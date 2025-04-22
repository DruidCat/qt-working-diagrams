import QtQuick //2.15
import QtQuick.Controls //2.15 //StackView

import DCPages 1.0//Импортируем Страницы программы.

ApplicationWindow {
	id: root
    width: {
        var vrWidth = Screen.desktopAvailableWidth;//Расчитываем доступную ширину экрана
        if((Qt.platform.os === "android") || (Qt.platform.os === "ios"))//Если мобильная платформа, то...
            return vrWidth;//Масимально возможная ширина.
        else{
            return vrWidth/2;//Половина ширины экрана.
        }
    }
    height: {
        var vrHeight = Screen.desktopAvailableHeight//Расчитываем доступную высоту экрана
        if((Qt.platform.os === "android") || (Qt.platform.os === "ios"))//Если мобильная платформа, то...
            return vrHeight;//Масимально возможная ширина.
        else{
            return (vrHeight/4)*3;//Половина высоты экрана.
        }
    }
    //minimumWidth: 480
    //minimumHeight: 640

    visible: true
	color: "grey"
    title: qsTr("Ментор от druidcat@yandex.ru")
    property int ntWidth: 4
	property int ntCoff: 8
	property color clrKnopok: "orange"
	property color clrFona: "grey"
    property color clrFaila: "yellow"
	property color clrStranic: "black"
    property bool pdfViewer: true//false - Отключить pdf просмоторщик.
    property bool appRedaktor: true//false - Отключить Редактор приложения.

	StackView {
		id: stvStr
		property string strOpisanie: "titul"
		anchors.fill: parent
        initialItem: pgStrSpisok

		Stranica {//Меню
		/////////////
		///М Е Н Ю///
		/////////////
			id: pgStrMenu
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: "black"
            textZagolovok: qsTr("МЕНЮ")
			StrMenu {
				id: tmMenu
				ntWidth: pgStrMenu.ntWidth; ntCoff: pgStrMenu.ntCoff
				clrTexta: pgStrMenu.clrTexta; clrFona: pgStrMenu.clrRabOblasti
				zagolovokX: pgStrMenu.rctStrZagolovok.x; zagolovokY: pgStrMenu.rctStrZagolovok.y
				zagolovokWidth: pgStrMenu.rctStrZagolovok.width
				zagolovokHeight: pgStrMenu.rctStrZagolovok.height
				zonaX: pgStrMenu.rctStrZona.x; zonaY: pgStrMenu.rctStrZona.y
				zonaWidth: pgStrMenu.rctStrZona.width; zonaHeight: pgStrMenu.rctStrZona.height
				toolbarX: pgStrMenu.rctStrToolbar.x; toolbarY: pgStrMenu.rctStrToolbar.y
				toolbarWidth: pgStrMenu.rctStrToolbar.width; toolbarHeight: pgStrMenu.rctStrToolbar.height
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
				onClickedLogi: {
					stvStr.push(pgStrDebug)//Переходим на страницу Логи.
				}
				onClickedWorkingDiagrams: {
					stvStr.push(pgStrWorkingDiagrams)//Переходим на страницу об Рабочих Схемах.
				}
				onClickedQt: {
					stvStr.push(pgStrQt)//Переходим на страницу об Qt.
                } 
                onPdfViewerChanged: {//Если флаг настройки pdf Проигрывателя изменился, то...
                    root.pdfViewer = pdfViewer;//Приравниваем флаг настройки.
                }
				onAppRedaktorChanged: {//Если флаг настройки включения Редактора изменился, то...
                    root.appRedaktor = appRedaktor;//Приравниваем флаг настройки.
                }
			}
		}
		Stranica {//Debug
		///////////////
		///D E B U G///
		///////////////
			id: pgStrDebug
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "MidnightBlue"
            textZagolovok: qsTr("ЛОГИ")
			StrDebug {
				id: tmDebug
				ntWidth: pgStrDebug.ntWidth; ntCoff: pgStrDebug.ntCoff
				clrTexta: pgStrDebug.clrTexta; clrFona: pgStrDebug.clrRabOblasti
				zagolovokX: pgStrDebug.rctStrZagolovok.x; zagolovokY: pgStrDebug.rctStrZagolovok.y
				zagolovokWidth: pgStrDebug.rctStrZagolovok.width
				zagolovokHeight: pgStrDebug.rctStrZagolovok.height
				zonaX: pgStrDebug.rctStrZona.x; zonaY: pgStrDebug.rctStrZona.y
				zonaWidth: pgStrDebug.rctStrZona.width; zonaHeight: pgStrDebug.rctStrZona.height
				toolbarX: pgStrDebug.rctStrToolbar.x; toolbarY: pgStrDebug.rctStrToolbar.y
				toolbarWidth: pgStrDebug.rctStrToolbar.width; toolbarHeight: pgStrDebug.rctStrToolbar.height
				radiusZona: pgStrDebug.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
        Stranica {//Ментор
		/////////////////////////////
		///О   П Р И Л О Ж Е Н И И///
		/////////////////////////////
			id: pgStrWorkingDiagrams
			visible: false
            ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
            textZagolovok: qsTr("О ПРИЛОЖЕНИИ")
            StrInstrukciya {
				id: tmWorkingDiagrams
                strInstrukciya: "oprilojenii"
                ntWidth: pgStrWorkingDiagrams.ntWidth; ntCoff: pgStrWorkingDiagrams.ntCoff
				clrTexta: pgStrWorkingDiagrams.clrTexta; clrFona: pgStrWorkingDiagrams.clrRabOblasti
				zagolovokX: pgStrWorkingDiagrams.rctStrZagolovok.x;
				zagolovokY: pgStrWorkingDiagrams.rctStrZagolovok.y
				zagolovokWidth: pgStrWorkingDiagrams.rctStrZagolovok.width
				zagolovokHeight: pgStrWorkingDiagrams.rctStrZagolovok.height
				zonaX: pgStrWorkingDiagrams.rctStrZona.x; zonaY: pgStrWorkingDiagrams.rctStrZona.y
				zonaWidth: pgStrWorkingDiagrams.rctStrZona.width;
				zonaHeight: pgStrWorkingDiagrams.rctStrZona.height
				toolbarX: pgStrWorkingDiagrams.rctStrToolbar.x; toolbarY: pgStrWorkingDiagrams.rctStrToolbar.y
				toolbarWidth: pgStrWorkingDiagrams.rctStrToolbar.width;
				toolbarHeight: pgStrWorkingDiagrams.rctStrToolbar.height
				radiusZona: pgStrWorkingDiagrams.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
		Stranica {//Qt
		/////////////
		///О   Q T///
		/////////////
			id: pgStrQt
			visible: false
            ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
            textZagolovok: qsTr("О Qt")
            StrInstrukciya {
				id: tmQt
                strInstrukciya: "oqt"
                ntWidth: pgStrQt.ntWidth; ntCoff: pgStrQt.ntCoff
				clrTexta: pgStrQt.clrTexta; clrFona: pgStrQt.clrRabOblasti
				zagolovokX: pgStrQt.rctStrZagolovok.x; zagolovokY: pgStrQt.rctStrZagolovok.y
				zagolovokWidth: pgStrQt.rctStrZagolovok.width
				zagolovokHeight: pgStrQt.rctStrZagolovok.height
				zonaX: pgStrQt.rctStrZona.x; zonaY: pgStrQt.rctStrZona.y
				zonaWidth: pgStrQt.rctStrZona.width; zonaHeight: pgStrQt.rctStrZona.height
				toolbarX: pgStrQt.rctStrToolbar.x; toolbarY: pgStrQt.rctStrToolbar.y
				toolbarWidth: pgStrQt.rctStrToolbar.width; toolbarHeight: pgStrQt.rctStrToolbar.height
				radiusZona: pgStrQt.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		} 
		Stranica {//Страница со Списком
		/////////////////
		///С П И С О К///
		/////////////////
			id: pgStrSpisok
            visible: false
            ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
            textZagolovok: cppqml.strTitul
            StrSpisok {
                id: tmSpisok
                ntWidth: pgStrSpisok.ntWidth; ntCoff: pgStrSpisok.ntCoff
				clrTexta: pgStrSpisok.clrTexta; clrFona: pgStrSpisok.clrRabOblasti
				zagolovokX: pgStrSpisok.rctStrZagolovok.x; zagolovokY: pgStrSpisok.rctStrZagolovok.y
				zagolovokWidth: pgStrSpisok.rctStrZagolovok.width
				zagolovokHeight: pgStrSpisok.rctStrZagolovok.height
				zonaX: pgStrSpisok.rctStrZona.x; zonaY: pgStrSpisok.rctStrZona.y
				zonaWidth: pgStrSpisok.rctStrZona.width; zonaHeight: pgStrSpisok.rctStrZona.height
				toolbarX: pgStrSpisok.rctStrToolbar.x; toolbarY: pgStrSpisok.rctStrToolbar.y
				toolbarWidth: pgStrSpisok.rctStrToolbar.width; toolbarHeight: pgStrSpisok.rctStrToolbar.height
				radiusZona: pgStrSpisok.rctStrZona.radius//Радиус берём из настроек элемента qml
                appRedaktor: root.appRedaktor
				onClickedMenu: {//Слот нажатия кнопки Меню.
					stvStr.push(pgStrMenu)//Перейти на страницу Меню
				}
                onClickedInfo: {
                    tmOpisanie.textTextEdit = cppqml.strTitulOpisanie;//Отправляем текст из бизнес логики.
					if(root.appRedaktor){//Если Редактор приложения включен, то...
                    	pgStrOpisanie.textToolbar = pgStrSpisok.textZagolovok
                        		+ qsTr(". Для изменения описания нажмите иконку (+).")
					}
                    stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
				onClickedSpisok: function(strSpisok) {
					stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
					pgStrElement.textZagolovok = strSpisok;//Задаём заголовок на странице Элементов.
					stvStr.push(pgStrElement);//Переключаемся на страницу Элементов.
				}
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrSpisok.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
                onSignalZagolovok: function(strZagolovok) {//Слот сигнала signalZagolovok с новым Заголовком.
                    pgStrSpisok.textZagolovok = cppqml.strTitul;//Выставляем изменённый Заголовок.
                }
			}
		}
		Stranica {//Страница Элементы Списка
		/////////////////////
		///Э Л Е М Е Н Т Ы///
		/////////////////////
			id: pgStrElement
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: root.clrStranic
			StrElement {
				id: tmElement
				ntWidth: pgStrElement.ntWidth; ntCoff: pgStrElement.ntCoff
				clrTexta: pgStrElement.clrTexta; clrFona: pgStrElement.clrRabOblasti
				zagolovokX: pgStrElement.rctStrZagolovok.x; zagolovokY: pgStrElement.rctStrZagolovok.y
				zagolovokWidth: pgStrElement.rctStrZagolovok.width
				zagolovokHeight: pgStrElement.rctStrZagolovok.height
				zonaX: pgStrElement.rctStrZona.x; zonaY: pgStrElement.rctStrZona.y
				zonaWidth: pgStrElement.rctStrZona.width; zonaHeight: pgStrElement.rctStrZona.height
				toolbarX: pgStrElement.rctStrToolbar.x; toolbarY: pgStrElement.rctStrToolbar.y
				toolbarWidth: pgStrElement.rctStrToolbar.width
				toolbarHeight: pgStrElement.rctStrToolbar.height
				radiusZona: pgStrElement.rctStrZona.radius//Радиус берём из настроек элемента qml
                appRedaktor: root.appRedaktor
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.strOpisanie = "titul";//Показываем описание Титульной страницы.
					stvStr.pop()//Назад страницу
				}
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strSpisokOpisanie;//Отправляем текст в бизнес логику.
					if(root.appRedaktor){//Если Редактор приложения включен, то...
                    	pgStrOpisanie.textToolbar = pgStrElement.textZagolovok
                            	+ qsTr(". Для изменения описания нажмите иконку (+).")
					}
                    stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
                onClickedElement: function(strElement) {//Слот сигнала нажатия на Элемент, вернув имя Элемента
					stvStr.strOpisanie = "element";//Показываем описание Элемента.
					pgStrDannie.textZagolovok = strElement;//Задаём заголовок на странице Данных.
					stvStr.push(pgStrDannie);//Переключаемся на страницу Данных..
				}
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrElement.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
			}
		}
		Stranica {//Страница с Данными
		/////////////////
		///Д А Н Н Ы Е///
		/////////////////
			id: pgStrDannie
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrFaila: root.clrFaila
			clrRabOblasti: root.clrStranic
			StrDannie {//Блок управления Данными, чтоб разгрузить Main.qml
				ntWidth: pgStrDannie.ntWidth; ntCoff: pgStrDannie.ntCoff
				clrTexta: pgStrDannie.clrTexta; clrFona: pgStrDannie.clrRabOblasti
                clrFaila: pgStrDannie.clrFaila
				zagolovokX: pgStrDannie.rctStrZagolovok.x; zagolovokY: pgStrDannie.rctStrZagolovok.y
				zagolovokWidth: pgStrDannie.rctStrZagolovok.width;
				zagolovokHeight: pgStrDannie.rctStrZagolovok.height
				zonaX: pgStrDannie.rctStrZona.x; zonaY: pgStrDannie.rctStrZona.y
				zonaWidth: pgStrDannie.rctStrZona.width; zonaHeight: pgStrDannie.rctStrZona.height
				toolbarX: pgStrDannie.rctStrToolbar.x; toolbarY: pgStrDannie.rctStrToolbar.y
				toolbarWidth: pgStrDannie.rctStrToolbar.width; toolbarHeight: pgStrDannie.rctStrToolbar.height
				radiusZona: pgStrDannie.rctStrZona.radius//Радиус берём из настроек элемента qml
                pdfViewer: root.pdfViewer; appRedaktor: root.appRedaktor
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
					stvStr.pop()//Назад страницу
				}
                onClickedSozdat: {//Слот нажатия кнопки Создать.
                    pgStrFileDialog.textToolbar = qsTr("Выберите PDF документ для добавления.")
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strElementOpisanie;//Отправляем текст в бизнес логику.
					if(root.appRedaktor){//Если Редактор приложения включен, то...
						pgStrOpisanie.textToolbar = pgStrDannie.textZagolovok
                            + qsTr(". Для изменения описания нажмите иконку (+).");
					}
                    stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
                onSignalZagolovok: function(strZagolovok){//Слот имени Заголовка.
                    pgStrDannie.textZagolovok = strZagolovok;//Изменяем заголовок.
                }
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrDannie.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
				onClickedDannie: function(strDannie){//Слот сигнала нажатия на Данные в списке.
					pgStrPdf.textZagolovok = strDannie;//Делаем заголовок с именем Данных.
					stvStr.push(pgStrPdf);//Переходим на страницу отображения Pdf документа.
				}
			}
		}
		Stranica {//Просмотр PDF документов.
		///////////
		///P D F///
		///////////
			id: pgStrPdf
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: "black"
            textZagolovok: qsTr("PDF")
			StrPdf{
				id: tmPdf
				ntWidth: pgStrPdf.ntWidth; ntCoff: pgStrPdf.ntCoff
				clrTexta: pgStrPdf.clrTexta; clrFona: pgStrPdf.clrRabOblasti
				zagolovokX: pgStrPdf.rctStrZagolovok.x; zagolovokY: pgStrPdf.rctStrZagolovok.y
				zagolovokWidth: pgStrPdf.rctStrZagolovok.width
				zagolovokHeight: pgStrPdf.rctStrZagolovok.height
				zonaX: pgStrPdf.rctStrZona.x; zonaY: pgStrPdf.rctStrZona.y
				zonaWidth: pgStrPdf.rctStrZona.width; zonaHeight: pgStrPdf.rctStrZona.height
				toolbarX: pgStrPdf.rctStrToolbar.x; toolbarY: pgStrPdf.rctStrToolbar.y
				toolbarWidth: pgStrPdf.rctStrToolbar.width; toolbarHeight: pgStrPdf.rctStrToolbar.height
                pdfViewer: root.pdfViewer
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
        Stranica {//Страница Файловым Диалогом
        ///////////////////////////////////
        ///Ф А Й Л О В Ы Й   Д И А Л О Г///
        ///////////////////////////////////
            id: pgStrFileDialog
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            clrFona: root.clrFona
            clrTexta: root.clrKnopok
            clrFaila: root.clrFaila
            clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ПРОВОДНИК")
            StrFileDialog{//Блок Файлового Диалога, чтоб разгрузить Main.qml
                ntWidth: pgStrFileDialog.ntWidth; ntCoff: pgStrFileDialog.ntCoff
                clrTexta: pgStrFileDialog.clrTexta; clrFona: pgStrFileDialog.clrRabOblasti
                clrFaila: pgStrFileDialog.clrFaila;
                zagolovokX: pgStrFileDialog.rctStrZagolovok.x; zagolovokY: pgStrFileDialog.rctStrZagolovok.y
                zagolovokWidth: pgStrFileDialog.rctStrZagolovok.width;
                zagolovokHeight: pgStrFileDialog.rctStrZagolovok.height
                zonaX: pgStrFileDialog.rctStrZona.x; zonaY: pgStrFileDialog.rctStrZona.y
                zonaWidth: pgStrFileDialog.rctStrZona.width; zonaHeight: pgStrFileDialog.rctStrZona.height
                toolbarX: pgStrFileDialog.rctStrToolbar.x; toolbarY: pgStrFileDialog.rctStrToolbar.y
                toolbarWidth: pgStrFileDialog.rctStrToolbar.width;
                toolbarHeight: pgStrFileDialog.rctStrToolbar.height
				radiusZona: pgStrFileDialog.rctStrZona.radius//Радиус берём из настроек элемента qml
                onClickedNazad: {//Слот нажатия кнопки Назад.
                    stvStr.strOpisanie = "element";//Показываем описание Элемента списка.
                    stvStr.pop()//Назад страницу
                }
                onClickedZakrit: {
                    stvStr.strOpisanie = "element";//Показываем описание Элемента списка.
                    stvStr.pop()//Назад страницу
                }
                onSignalZagolovok: function(strZagolovok){//Слот имени Заголовка.
                    pgStrFileDialog.textZagolovok = strZagolovok;//Изменяем заголовок.
                }
				onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrFileDialog.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
                onClickedInfo: {
                    stvStr.push(pgStrFDInstrukciya);//Переключаемся на страницу Инструкция проводника.
                }
            }
        }
        Stranica {//Описание Проводника.
        ///////////////////////////////////////////////
        ///И Н С Т Р У К Ц И Я   П Р О В О Д Н И К А///
        ///////////////////////////////////////////////
            id: pgStrFDInstrukciya
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            clrFona: root.clrFona
            clrTexta: root.clrKnopok
            clrRabOblasti: "black"
            textZagolovok: qsTr("ИНСТРУКЦИЯ ПО ПРОВОДНИКУ")
            StrInstrukciya {
                id: tmFDInstrukciya
                strInstrukciya: "fdinstrukciya"
                ntWidth: pgStrFDInstrukciya.ntWidth; ntCoff: pgStrFDInstrukciya.ntCoff
                clrTexta: pgStrFDInstrukciya.clrTexta; clrFona: pgStrFDInstrukciya.clrRabOblasti
                zagolovokX: pgStrFDInstrukciya.rctStrZagolovok.x;
                zagolovokY: pgStrFDInstrukciya.rctStrZagolovok.y
                zagolovokWidth: pgStrFDInstrukciya.rctStrZagolovok.width
                zagolovokHeight: pgStrFDInstrukciya.rctStrZagolovok.height
                zonaX: pgStrFDInstrukciya.rctStrZona.x; zonaY: pgStrFDInstrukciya.rctStrZona.y
                zonaWidth: pgStrFDInstrukciya.rctStrZona.width;
                zonaHeight: pgStrFDInstrukciya.rctStrZona.height
                toolbarX: pgStrFDInstrukciya.rctStrToolbar.x; toolbarY: pgStrFDInstrukciya.rctStrToolbar.y
                toolbarWidth: pgStrFDInstrukciya.rctStrToolbar.width;
                toolbarHeight: pgStrFDInstrukciya.rctStrToolbar.height
                radiusZona: pgStrFDInstrukciya.rctStrZona.radius//Радиус берём из настроек элемента qml
                onClickedNazad: {
                    stvStr.pop()//Назад страницу
                }
            }
        }
		Stranica {//Страница Описания
		/////////////////////
		///О П И С А Н И Е///
		/////////////////////
			id: pgStrOpisanie
			visible: false
            ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ОПИСАНИЕ")
            StrOpisanie {
				id: tmOpisanie
				ntWidth: pgStrOpisanie.ntWidth; ntCoff: pgStrOpisanie.ntCoff
				clrTexta: pgStrOpisanie.clrTexta; clrFona: pgStrOpisanie.clrRabOblasti
				zagolovokX: pgStrOpisanie.rctStrZagolovok.x; zagolovokY: pgStrOpisanie.rctStrZagolovok.y
				zagolovokWidth: pgStrOpisanie.rctStrZagolovok.width
				zagolovokHeight: pgStrOpisanie.rctStrZagolovok.height
				zonaX: pgStrOpisanie.rctStrZona.x; zonaY: pgStrOpisanie.rctStrZona.y
				zonaWidth: pgStrOpisanie.rctStrZona.width; zonaHeight: pgStrOpisanie.rctStrZona.height
				toolbarX: pgStrOpisanie.rctStrToolbar.x; toolbarY: pgStrOpisanie.rctStrToolbar.y
				toolbarWidth: pgStrOpisanie.rctStrToolbar.width
				toolbarHeight: pgStrOpisanie.rctStrToolbar.height
				radiusZona: pgStrOpisanie.rctStrZona.radius//Радиус берём из настроек элемента qml
				strOpisanie: stvStr.strOpisanie//Передаём флаг Отображения конкретного Описания.
                appRedaktor: root.appRedaktor
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
                onClickedPlan: {//Слот нажатия Плана.
                    tmPlan.source = "qrc:///workingdata/plan.pdf"
                    stvStr.push(pgStrPlan)//Переходим на страницу Плана.
                }
			}
		}
        Stranica {//План
        /////////////
        ///П Л А Н///
        /////////////
            id: pgStrPlan
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            clrFona: root.clrFona
            clrTexta: root.clrKnopok
            clrRabOblasti: "black"
            textZagolovok: qsTr("ПЛАН")
            StrPlan {
                id: tmPlan
                ntWidth: pgStrPlan.ntWidth; ntCoff: pgStrPlan.ntCoff
                clrTexta: pgStrPlan.clrTexta; clrFona: pgStrPlan.clrRabOblasti
                zagolovokX: pgStrPlan.rctStrZagolovok.x; zagolovokY: pgStrPlan.rctStrZagolovok.y
                zagolovokWidth: pgStrPlan.rctStrZagolovok.width
                zagolovokHeight: pgStrPlan.rctStrZagolovok.height
                zonaX: pgStrPlan.rctStrZona.x; zonaY: pgStrPlan.rctStrZona.y
                zonaWidth: pgStrPlan.rctStrZona.width; zonaHeight: pgStrPlan.rctStrZona.height
                toolbarX: pgStrPlan.rctStrToolbar.x; toolbarY: pgStrPlan.rctStrToolbar.y
                toolbarWidth: pgStrPlan.rctStrToolbar.width; toolbarHeight: pgStrPlan.rctStrToolbar.height
                pdfViewer: root.pdfViewer; appRedaktor: root.appRedaktor
                onClickedNazad: {
                    stvStr.pop()//Назад страницу
                }
                onClickedSozdat: {//Слот нажатия кнопки Создать.
                    pgStrFileDialog.textToolbar = qsTr("Выберите PDF документ для добавления.")
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
            }
        }
	} 
}
