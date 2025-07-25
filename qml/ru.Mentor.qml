import QtQuick //2.15
import QtQuick.Controls //2.15 //StackView

import DCPages 1.0//Импортируем Страницы программы.

ApplicationWindow {
	id: root
    //Свойства.
    property int ntWidth: 4
    property int ntCoff: 8
    property color clrKnopok: "#ee732d"//Корпаративный оранжевый
    property color clrFona: "#5a6673"//Серый цвет более мягкий, подходящий под оранжевый корпаративный
    property color clrFaila: "yellow"
    property color clrStranic: "black"
    property color clrMenuText: "#F0F0F0"//Светло серый контрастен к оранжевому.
    property bool pdfViewer: true//false - Отключить pdf просмоторщик.
    property bool appRedaktor: true//false - Отключить Редактор приложения.
	property bool isMobile: {//Переменная определяющая, мобильная это платформа или нет. true - мобильная.
        if((Qt.platform.os === "android") || (Qt.platform.os === "ios"))//Если мобильная платформа, то...
			return true;//Это мобильная платформа.
		else//Эсли не мобильная, то...
			return false;//Это не мобильная платформа.
	}
	property bool planFileDialog: false//Проводник false - открыт для Данных. true - открыт для Плана.
    //Настройки.
    visible: true
	color: "grey"
    title: qsTr("Ментор от druidcat@yandex.ru")
    width: {
        var vrWidth = Screen.desktopAvailableWidth;//Расчитываем доступную ширину экрана
        if(isMobile)//Если мобильная платформа, то...
            return vrWidth;//Масимально возможная ширина.
        else
            return cppqml.untWidth;//Считываем из реестра ширину окна.
    }
    height: {
        var vrHeight = Screen.desktopAvailableHeight//Расчитываем доступную высоту экрана
        if(isMobile)//Если мобильная платформа, то...
            return vrHeight;//Масимально возможная ширина.
        else
            return cppqml.untHeight;//Считываем из реестра высоту окна.
    }
    minimumWidth: {//Минимальная ширина не для мобильных платформ.
        if(!isMobile)//Если не мобильная платформа, то...
            return ntWidth*ntCoff*12.4;//Расчёт по виджету DCSpinBox и DCScale.
    }
    minimumHeight: {//Минимальная высота не для мобильных платформ.
        if(!isMobile)//Если не мобильная платформа, то...
            return 330;
    }
    onWidthChanged: {//Если Ширина поменялась, то...
        if(!isMobile)//Если не мобильная платформа, то...
            cppqml.untWidth = width;//Отправляем в бизнес логику ширину окна, для обработки.
    }
    onHeightChanged: {//Если Высота поменялась, то...
        if(!isMobile)//Если не мобильная платформа, то...
            cppqml.untHeight = height;//Отправляем в бизнес логику высоту окна, для обработки.
    }

	StackView {
		id: stvStr
		property string strOpisanie: "titul"
        property string infoElement: ""//Запоминает элемент, на котором нажата кнопка Информации.
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrMenu {
				id: tmMenu
				ntWidth: pgStrMenu.ntWidth; ntCoff: pgStrMenu.ntCoff
				clrTexta: pgStrMenu.clrTexta; clrFona: pgStrMenu.clrRabOblasti
				clrMenuText: root.clrMenuText; clrMenuFon: pgStrMenu.clrFona
				zagolovokX: pgStrMenu.rctStrZagolovok.x; zagolovokY: pgStrMenu.rctStrZagolovok.y
				zagolovokWidth: pgStrMenu.rctStrZagolovok.width
				zagolovokHeight: pgStrMenu.rctStrZagolovok.height
				zonaX: pgStrMenu.rctStrZona.x; zonaY: pgStrMenu.rctStrZona.y 
				zonaWidth: pgStrMenu.rctStrZona.width; zonaHeight: pgStrMenu.rctStrZona.height
				toolbarX: pgStrMenu.rctStrToolbar.x; toolbarY: pgStrMenu.rctStrToolbar.y
                toolbarWidth: pgStrMenu.rctStrToolbar.width
                toolbarHeight: pgStrMenu.rctStrToolbar.height
                tapZagolovokLevi: pgStrMenu.zagolovokLevi; tapZagolovokPravi: pgStrMenu.zagolovokPravi
                tapToolbarLevi: pgStrMenu.toolbarLevi; tapToolbarPravi: pgStrMenu.toolbarPravi
				isMobile: root.isMobile
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
				onClickedLogi: {
					stvStr.push(pgStrDebug)//Переходим на страницу Логи.
				}
                onClickedMentor: {
                    stvStr.push(pgStrMentor)//Переходим на страницу об Менторе.
				}
				onClickedHotKey: {
					stvStr.push(pgStrHotKey)//Переходим на страницу горячих клавиш.
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
                onClickedAnimaciya: {
                    stvStr.push(pgStrAnimaciya);//Переходим на страницу Анимация.
                }
                onSignalZagolovok: function(strZagolovok) {//Слот сигнала signalZagolovok с новым Заголовком.
                    pgStrMenu.textZagolovok = strZagolovok;//Выставляем изменённый Заголовок.
                }
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrMenu.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
			}
            Component.onCompleted: {//После отрисовки страницы...
                root.pdfViewer = tmMenu.pdfViewer;//Приравниваем флаг настройки. ВАЖНО.
                root.appRedaktor = tmMenu.appRedaktor;//Приравниваем флаг настройки.
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrDebug {
				id: tmDebug
				ntWidth: pgStrDebug.ntWidth; ntCoff: pgStrDebug.ntCoff
				clrTexta: pgStrDebug.clrTexta; clrFona: pgStrDebug.clrRabOblasti
				zagolovokX: pgStrDebug.rctStrZagolovok.x; zagolovokY: pgStrDebug.rctStrZagolovok.y
				zagolovokWidth: pgStrDebug.rctStrZagolovok.width
				zagolovokHeight: pgStrDebug.rctStrZagolovok.height
				zonaX: pgStrDebug.rctStrZona.x; zonaY: pgStrDebug.rctStrZona.y 
				toolbarX: pgStrDebug.rctStrToolbar.x; toolbarY: pgStrDebug.rctStrToolbar.y
                toolbarWidth: pgStrDebug.rctStrToolbar.width
                toolbarHeight: pgStrDebug.rctStrToolbar.height
                radiusZona: pgStrDebug.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrDebug.zagolovokLevi; tapZagolovokPravi: pgStrDebug.zagolovokPravi
                tapToolbarLevi: pgStrDebug.toolbarLevi; tapToolbarPravi: pgStrDebug.toolbarPravi
                zonaWidth: pgStrDebug.rctStrZona.width; zonaHeight: pgStrDebug.rctStrZona.height
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
        Stranica {//Ментор
		/////////////////////////////
		///О   П Р И Л О Ж Е Н И И///
		/////////////////////////////
            id: pgStrMentor
			visible: false
            ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
            textZagolovok: qsTr("О ПРИЛОЖЕНИИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                id: tmMentor
                strInstrukciya: "oprilojenii"
                ntWidth: pgStrMentor.ntWidth; ntCoff: pgStrMentor.ntCoff
                clrTexta: pgStrMentor.clrTexta; clrFona: pgStrMentor.clrRabOblasti
                zagolovokX: pgStrMentor.rctStrZagolovok.x;
                zagolovokY: pgStrMentor.rctStrZagolovok.y
                zagolovokWidth: pgStrMentor.rctStrZagolovok.width
                zagolovokHeight: pgStrMentor.rctStrZagolovok.height
                zonaX: pgStrMentor.rctStrZona.x; zonaY: pgStrMentor.rctStrZona.y
                zonaWidth: pgStrMentor.rctStrZona.width;
                zonaHeight: pgStrMentor.rctStrZona.height
                toolbarX: pgStrMentor.rctStrToolbar.x; toolbarY: pgStrMentor.rctStrToolbar.y
                toolbarWidth: pgStrMentor.rctStrToolbar.width
                toolbarHeight: pgStrMentor.rctStrToolbar.height
                radiusZona: pgStrMentor.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrMentor.zagolovokLevi
                tapZagolovokPravi: pgStrMentor.zagolovokPravi
                tapToolbarLevi: pgStrMentor.toolbarLevi
                tapToolbarPravi: pgStrMentor.toolbarPravi
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
		Stranica {//Горячие Клавиши.
		///////////////////////////////////
		///Г О Р Я Ч И Е   К Л А В И Ш И///
		///////////////////////////////////
			id: pgStrHotKey
			visible: false
            ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
            textZagolovok: qsTr("ГОРЯЧИЕ КЛАВИШИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
				id: tmHotKey
                strInstrukciya: "hotkey"
                ntWidth: pgStrHotKey.ntWidth; ntCoff: pgStrHotKey.ntCoff
				clrTexta: pgStrHotKey.clrTexta; clrFona: pgStrHotKey.clrRabOblasti
				zagolovokX: pgStrHotKey.rctStrZagolovok.x; zagolovokY: pgStrHotKey.rctStrZagolovok.y
				zagolovokWidth: pgStrHotKey.rctStrZagolovok.width
				zagolovokHeight: pgStrHotKey.rctStrZagolovok.height
				zonaX: pgStrHotKey.rctStrZona.x; zonaY: pgStrHotKey.rctStrZona.y
				zonaWidth: pgStrHotKey.rctStrZona.width; zonaHeight: pgStrHotKey.rctStrZona.height
				toolbarX: pgStrHotKey.rctStrToolbar.x; toolbarY: pgStrHotKey.rctStrToolbar.y
                toolbarWidth: pgStrHotKey.rctStrToolbar.width
                toolbarHeight: pgStrHotKey.rctStrToolbar.height
				radiusZona: pgStrHotKey.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrHotKey.zagolovokLevi; tapZagolovokPravi: pgStrHotKey.zagolovokPravi
                tapToolbarLevi: pgStrHotKey.toolbarLevi; tapToolbarPravi: pgStrHotKey.toolbarPravi
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
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
                toolbarWidth: pgStrQt.rctStrToolbar.width
                toolbarHeight: pgStrQt.rctStrToolbar.height
				radiusZona: pgStrQt.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrQt.zagolovokLevi; tapZagolovokPravi: pgStrQt.zagolovokPravi
                tapToolbarLevi: pgStrQt.toolbarLevi; tapToolbarPravi: pgStrQt.toolbarPravi
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		} 
        Stranica {//Анимация
        /////////////////////
        ///А Н И М А Ц И Я///
        /////////////////////
            id: pgStrAnimaciya
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            clrFona: root.clrFona
            clrTexta: root.clrKnopok
            clrRabOblasti: "black"
            textZagolovok: qsTr("АНИМАЦИЯ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrAnimaciya {
                id: tmAnimaciya
                ntWidth: pgStrAnimaciya.ntWidth; ntCoff: pgStrAnimaciya.ntCoff
                clrTexta: pgStrAnimaciya.clrTexta; clrFona: pgStrAnimaciya.clrRabOblasti
				clrMenuText: root.clrMenuText; clrMenuFon: pgStrAnimaciya.clrFona
                zagolovokX: pgStrAnimaciya.rctStrZagolovok.x; zagolovokY: pgStrAnimaciya.rctStrZagolovok.y
                zagolovokWidth: pgStrAnimaciya.rctStrZagolovok.width
                zagolovokHeight: pgStrAnimaciya.rctStrZagolovok.height
                zonaX: pgStrAnimaciya.rctStrZona.x; zonaY: pgStrAnimaciya.rctStrZona.y
                zonaWidth: pgStrAnimaciya.rctStrZona.width; zonaHeight: pgStrAnimaciya.rctStrZona.height
                toolbarX: pgStrAnimaciya.rctStrToolbar.x; toolbarY: pgStrAnimaciya.rctStrToolbar.y
                toolbarWidth: pgStrAnimaciya.rctStrToolbar.width
                toolbarHeight: pgStrAnimaciya.rctStrToolbar.height
                tapZagolovokLevi: pgStrAnimaciya.zagolovokLevi
                tapZagolovokPravi: pgStrAnimaciya.zagolovokPravi
                tapToolbarLevi: pgStrAnimaciya.toolbarLevi; tapToolbarPravi: pgStrAnimaciya.toolbarPravi
                onClickedNazad: {
                    stvStr.pop()//Назад страницу
                }
                onClickedInfo: {
                    stvStr.push(pgStrAnimaciyaInstrukciya);//Переключаемся на страницу Инструкция Анимации.
                }
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrAnimaciya.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
            }
        }
        Stranica {//Инструкция Анимации.
        ///////////////////////////////////////////
        ///И Н С Т Р У К Ц И Я   А Н И М А Ц И И///
        ///////////////////////////////////////////
            id: pgStrAnimaciyaInstrukciya
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            clrFona: root.clrFona
            clrTexta: root.clrKnopok
            clrRabOblasti: "black"
            textZagolovok: qsTr("ИНСТРУКЦИЯ ПО АНИМАЦИИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                id: tmAnimaciyaInstrukciya
                strInstrukciya: "animaciya"
                ntWidth: pgStrAnimaciyaInstrukciya.ntWidth; ntCoff: pgStrAnimaciyaInstrukciya.ntCoff
                clrTexta: pgStrAnimaciyaInstrukciya.clrTexta; clrFona: pgStrAnimaciyaInstrukciya.clrRabOblasti
                zagolovokX: pgStrAnimaciyaInstrukciya.rctStrZagolovok.x;
                zagolovokY: pgStrAnimaciyaInstrukciya.rctStrZagolovok.y
                zagolovokWidth: pgStrAnimaciyaInstrukciya.rctStrZagolovok.width
                zagolovokHeight: pgStrAnimaciyaInstrukciya.rctStrZagolovok.height
                zonaX: pgStrAnimaciyaInstrukciya.rctStrZona.x; zonaY: pgStrAnimaciyaInstrukciya.rctStrZona.y
                zonaWidth: pgStrAnimaciyaInstrukciya.rctStrZona.width;
                zonaHeight: pgStrAnimaciyaInstrukciya.rctStrZona.height
                toolbarX: pgStrAnimaciyaInstrukciya.rctStrToolbar.x;
                toolbarY: pgStrAnimaciyaInstrukciya.rctStrToolbar.y
                toolbarWidth: pgStrAnimaciyaInstrukciya.rctStrToolbar.width
                toolbarHeight: pgStrAnimaciyaInstrukciya.rctStrToolbar.height
                radiusZona: pgStrAnimaciyaInstrukciya.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrAnimaciyaInstrukciya.zagolovokLevi
                tapZagolovokPravi: pgStrAnimaciyaInstrukciya.zagolovokPravi
                tapToolbarLevi: pgStrAnimaciyaInstrukciya.toolbarLevi
                tapToolbarPravi: pgStrAnimaciyaInstrukciya.toolbarPravi
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrSpisok {
                id: tmSpisok
                ntWidth: pgStrSpisok.ntWidth; ntCoff: pgStrSpisok.ntCoff
                clrTexta: pgStrSpisok.clrTexta; clrFona: pgStrSpisok.clrRabOblasti
                clrMenuText: root.clrMenuText; clrMenuFon: pgStrSpisok.clrFona
				zagolovokX: pgStrSpisok.rctStrZagolovok.x; zagolovokY: pgStrSpisok.rctStrZagolovok.y
				zagolovokWidth: pgStrSpisok.rctStrZagolovok.width
				zagolovokHeight: pgStrSpisok.rctStrZagolovok.height
				zonaX: pgStrSpisok.rctStrZona.x; zonaY: pgStrSpisok.rctStrZona.y
				zonaWidth: pgStrSpisok.rctStrZona.width; zonaHeight: pgStrSpisok.rctStrZona.height
				toolbarX: pgStrSpisok.rctStrToolbar.x; toolbarY: pgStrSpisok.rctStrToolbar.y
                toolbarWidth: pgStrSpisok.rctStrToolbar.width
                toolbarHeight: pgStrSpisok.rctStrToolbar.height
				radiusZona: pgStrSpisok.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrSpisok.zagolovokLevi; tapZagolovokPravi: pgStrSpisok.zagolovokPravi
                tapToolbarLevi: pgStrSpisok.toolbarLevi; tapToolbarPravi: pgStrSpisok.toolbarPravi
                appRedaktor: root.appRedaktor
				onClickedMenu: {//Слот нажатия кнопки Меню.
					stvStr.push(pgStrMenu)//Перейти на страницу Меню
				}
                onClickedInfo: {
                    tmOpisanie.textTextEdit = cppqml.strTitulOpisanie;//Отправляем текст из бизнес логики.
                    pgStrOpisanie.textZagolovok = pgStrSpisok.textZagolovok;//Заголовок Списка.
                    stvStr.infoElement = pgStrSpisok.textZagolovok;//Запоминаем Заголовок.
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
                    pgStrSpisok.textZagolovok = strZagolovok;//Выставляем изменённый Заголовок.
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrElement {
				id: tmElement
				ntWidth: pgStrElement.ntWidth; ntCoff: pgStrElement.ntCoff
				clrTexta: pgStrElement.clrTexta; clrFona: pgStrElement.clrRabOblasti
                clrMenuText: root.clrMenuText; clrMenuFon: pgStrElement.clrFona
                zagolovokX: pgStrElement.rctStrZagolovok.x; zagolovokY: pgStrElement.rctStrZagolovok.y
				zagolovokWidth: pgStrElement.rctStrZagolovok.width
				zagolovokHeight: pgStrElement.rctStrZagolovok.height
				zonaX: pgStrElement.rctStrZona.x; zonaY: pgStrElement.rctStrZona.y
				zonaWidth: pgStrElement.rctStrZona.width; zonaHeight: pgStrElement.rctStrZona.height
				toolbarX: pgStrElement.rctStrToolbar.x; toolbarY: pgStrElement.rctStrToolbar.y
                toolbarWidth: pgStrElement.rctStrToolbar.width
				toolbarHeight: pgStrElement.rctStrToolbar.height
				radiusZona: pgStrElement.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrElement.zagolovokLevi; tapZagolovokPravi: pgStrElement.zagolovokPravi
                tapToolbarLevi: pgStrElement.toolbarLevi; tapToolbarPravi: pgStrElement.toolbarPravi
                appRedaktor: root.appRedaktor
				onClickedNazad: {//Слот нажатия кнопки Назад.
					cppqml.ullSpisokKod = 0;//НЕ УДАЛЯТЬ! На странице Список код не выбран и равен 0.
					stvStr.strOpisanie = "titul";//Показываем описание Титульной страницы.
					stvStr.pop()//Назад страницу
				}
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strSpisokOpisanie;//Отправляем текст в бизнес логику.
                    pgStrOpisanie.textZagolovok = pgStrElement.textZagolovok;//Заголовок Элемента.
                    stvStr.infoElement = pgStrElement.textZagolovok;//Запоминаем Заголовок.
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrDannie {//Блок управления Данными, чтоб разгрузить Main.qml
				ntWidth: pgStrDannie.ntWidth; ntCoff: pgStrDannie.ntCoff
				clrTexta: pgStrDannie.clrTexta; clrFona: pgStrDannie.clrRabOblasti
				clrFaila: pgStrDannie.clrFaila
				clrMenuText: root.clrMenuText; clrMenuFon: pgStrDannie.clrFona
                zagolovokX: pgStrDannie.rctStrZagolovok.x; zagolovokY: pgStrDannie.rctStrZagolovok.y
				zagolovokWidth: pgStrDannie.rctStrZagolovok.width;
				zagolovokHeight: pgStrDannie.rctStrZagolovok.height
				zonaX: pgStrDannie.rctStrZona.x; zonaY: pgStrDannie.rctStrZona.y
				zonaWidth: pgStrDannie.rctStrZona.width; zonaHeight: pgStrDannie.rctStrZona.height
				toolbarX: pgStrDannie.rctStrToolbar.x; toolbarY: pgStrDannie.rctStrToolbar.y
                toolbarWidth: pgStrDannie.rctStrToolbar.width
                toolbarHeight: pgStrDannie.rctStrToolbar.height
				radiusZona: pgStrDannie.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrDannie.zagolovokLevi; tapZagolovokPravi: pgStrDannie.zagolovokPravi
                tapToolbarLevi: pgStrDannie.toolbarLevi; tapToolbarPravi: pgStrDannie.toolbarPravi
                pdfViewer: root.pdfViewer; appRedaktor: root.appRedaktor
				onClickedNazad: {//Слот нажатия кнопки Назад.
					cppqml.ullElementKod = 0;//НЕ УДАЛЯТЬ! На странице Элемент код не выбран и равен 0.
					stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
					stvStr.pop()//Назад страницу
				}
                onClickedSozdat: {//Слот нажатия кнопки Создать.
					root.planFileDialog = false;//Открываем проводник для Данных.
                    pgStrFileDialog.textZagolovok = pgStrDannie.textZagolovok;//Заголовок Данных.
                    pgStrFileDialog.textToolbar = qsTr("Выберите PDF документ для добавления.")
                    cppqml.strFileDialogPut = "start";//ВАЖНО!!! Обновляем каталог Проводника
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strElementOpisanie;//Отправляем текст в бизнес логику.
                    pgStrOpisanie.textZagolovok = pgStrDannie.textZagolovok;//Заголовок Данных.
                    stvStr.infoElement = pgStrDannie.textZagolovok;//Запоминаем Заголовок.
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
            zagolovokLevi: 1.3; zagolovokPravi: 3.7; toolbarLevi: 4.1; toolbarPravi: 5
            StrPdf {
				id: tmPdf
				ntWidth: pgStrPdf.ntWidth; ntCoff: pgStrPdf.ntCoff
				clrTexta: pgStrPdf.clrTexta; clrFona: pgStrPdf.clrRabOblasti; clrMenuFon: pgStrPdf.clrFona
				zagolovokX: pgStrPdf.rctStrZagolovok.x; zagolovokY: pgStrPdf.rctStrZagolovok.y
				zagolovokWidth: pgStrPdf.rctStrZagolovok.width
				zagolovokHeight: pgStrPdf.rctStrZagolovok.height
				zonaX: pgStrPdf.rctStrZona.x; zonaY: pgStrPdf.rctStrZona.y
				zonaWidth: pgStrPdf.rctStrZona.width; zonaHeight: pgStrPdf.rctStrZona.height
				toolbarX: pgStrPdf.rctStrToolbar.x; toolbarY: pgStrPdf.rctStrToolbar.y
                toolbarWidth: pgStrPdf.rctStrToolbar.width
                toolbarHeight: pgStrPdf.rctStrToolbar.height
                tapZagolovokLevi: 1.3; tapZagolovokPravi: 1.3
                tapToolbarLevi: 1; tapToolbarPravi: 1.1
                pdfViewer: root.pdfViewer
				onClickedNazad: {
					cppqml.ullDannieKod = 0;//НЕ УДАЛЯТЬ! На странице Данные код не выбран и равен 0.
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrFileDialog{//Блок Файлового Диалога, чтоб разгрузить Main.qml
                ntWidth: pgStrFileDialog.ntWidth; ntCoff: pgStrFileDialog.ntCoff
                clrTexta: pgStrFileDialog.clrTexta; clrFona: pgStrFileDialog.clrRabOblasti
				clrFaila: pgStrFileDialog.clrFaila
				clrMenuText: root.clrMenuText; clrMenuFon: pgStrFileDialog.clrFona
                zagolovokX: pgStrFileDialog.rctStrZagolovok.x; zagolovokY: pgStrFileDialog.rctStrZagolovok.y
                zagolovokWidth: pgStrFileDialog.rctStrZagolovok.width;
                zagolovokHeight: pgStrFileDialog.rctStrZagolovok.height
                zonaX: pgStrFileDialog.rctStrZona.x; zonaY: pgStrFileDialog.rctStrZona.y
                zonaWidth: pgStrFileDialog.rctStrZona.width; zonaHeight: pgStrFileDialog.rctStrZona.height
                toolbarX: pgStrFileDialog.rctStrToolbar.x; toolbarY: pgStrFileDialog.rctStrToolbar.y
                toolbarWidth: pgStrFileDialog.rctStrToolbar.width
				toolbarHeight: pgStrFileDialog.rctStrToolbar.height
				radiusZona: pgStrFileDialog.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrFileDialog.zagolovokLevi;
                tapZagolovokPravi: pgStrFileDialog.zagolovokPravi
                tapToolbarLevi: pgStrFileDialog.toolbarLevi; tapToolbarPravi: pgStrFileDialog.toolbarPravi
				blPlan: root.planFileDialog//Выбор режима открытия проводника для Плана или Данных.
                onClickedZakrit: {//Если нажата кнопка Назад или Закрыть, то...
                    if(root.planFileDialog){//Если открывался План, то...
                        let ltPdfUrl;//Переменная хранящая путь pdf файла.
                        if(cppqml.blPlanPervi)//Если план еще не задан, то...
                            ltPdfUrl = "qrc:///workingdata/plan.pdf";//То открываем инструкцию пользователя.
                        else//Если план уже был задан, то...
                            ltPdfUrl = cppqml.polPutImyaPlan();//Путь и имя файла Плана.
                        //Механизм открытия инструкции с внешним просмотрщиком документов.
                        if(root.pdfViewer)//Если выбран в настройках собственный просмотрщик, то...
                            tmPlan.ustSource(ltPdfUrl);//Открываем во встроеном просмоторщике pdf документов.
                        else{//Если на сторонний просмотщик pdf документов, то...
                            tmPlan.ustSource("qrc:///workingdata/plan.pdf");//Открываем во встроеном просмотор
                            if(!cppqml.blPlanPervi)//Если план еще не задан, то...
                                Qt.openUrlExternally(ltPdfUrl);//Открываем pdf в стороннем app.
                        }
                    }
                    else//Если открывались Данные, то...
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
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
                toolbarWidth: pgStrFDInstrukciya.rctStrToolbar.width
                toolbarHeight: pgStrFDInstrukciya.rctStrToolbar.height
                radiusZona: pgStrFDInstrukciya.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrFDInstrukciya.zagolovokLevi
                tapZagolovokPravi: pgStrFDInstrukciya.zagolovokPravi
                tapToolbarLevi: pgStrFDInstrukciya.toolbarLevi
                tapToolbarPravi: pgStrFDInstrukciya.toolbarPravi
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
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            onVisibleChanged: {
                if(visible){
                    if(root.appRedaktor)//Если Редактор приложения включен, то...
                        textToolbar = qsTr("Для изменения описания нажмите иконку (+).");
                }
            }
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
                tapZagolovokLevi: pgStrOpisanie.zagolovokLevi; tapZagolovokPravi: pgStrOpisanie.zagolovokPravi
                tapToolbarLevi: pgStrOpisanie.toolbarLevi; tapToolbarPravi: pgStrOpisanie.toolbarPravi
				strOpisanie: stvStr.strOpisanie//Передаём флаг Отображения конкретного Описания.
                appRedaktor: root.appRedaktor; isMobile: root.isMobile
                onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
                onClickedPlan: {//Слот нажатия Плана.
					let ltPdfUrl;//Переменная хранящая путь pdf файла.
                    if(cppqml.blPlanPervi)//Если план еще не задан, то...
                    	ltPdfUrl = "qrc:///workingdata/plan.pdf";//То открываем инструкцию пользователя.
                    else//Если план уже был задан, то...
                        ltPdfUrl = cppqml.polPutImyaPlan();//Путь и имя файла Плана.
                    //Механизм открытия инструкции с внешним просмотрщиком документов.
                    if(root.pdfViewer)//Если выбран в настройках собственный просмотрщик, то...
                        tmPlan.ustSource(ltPdfUrl);//Открываем во встроеном просмоторщике pdf документов.
                    else{//Если на сторонний просмотщик pdf документов, то...
                        tmPlan.ustSource("qrc:///workingdata/plan.pdf");//Открываем во встроеном просмоторщике
                        if(!cppqml.blPlanPervi)//Если план еще не задан, то...
                            Qt.openUrlExternally(ltPdfUrl);//Открываем pdf в стороннем app.
                    }
                    stvStr.push(pgStrPlan)//Переходим на страницу Плана.
                }
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrOpisanie.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
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
            zagolovokLevi: 1.3; zagolovokPravi: 2.6; toolbarLevi: 1.3; toolbarPravi: 4.5
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
                toolbarWidth: pgStrPlan.rctStrToolbar.width
                toolbarHeight: pgStrPlan.rctStrToolbar.height
                tapZagolovokLevi: 1.3; tapZagolovokPravi: 1.3
                tapToolbarLevi: 1.3; tapToolbarPravi: 1.3
                pdfViewer: root.pdfViewer; appRedaktor: root.appRedaktor
                onClickedNazad: {
                    stvStr.pop()//Назад страницу
                }
                onClickedSozdat: {//Слот нажатия кнопки Создать.
					root.planFileDialog = true;//Открываем проводник для План.
                    pgStrFileDialog.textZagolovok = stvStr.infoElement//Заголовок Проводника.
                    pgStrFileDialog.textToolbar = qsTr("Выберите PDF документ для добавления.")
                    cppqml.strFileDialogPut = "start";//ВАЖНО!!! Обновляем каталог Проводника
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
            }
        }
	}  
}
