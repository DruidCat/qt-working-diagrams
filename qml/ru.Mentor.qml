import QtQuick //2.15
import QtQuick.Controls //2.15 //StackView

import DCPages 1.0//Импортируем Страницы программы.

ApplicationWindow {
	id: root
    //Свойства. 
    property color clrKnopok: "#ee732d"//Корпаративный оранжевый
    property color clrFona: "#5a6673"//Серый цвет более мягкий, подходящий под оранжевый корпаративный
    property color clrFaila: "yellow"
    property color clrStranic: "black"
    property color clrMenuText: "#F0F0F0"//Светло серый контрастен к оранжевому.
    property int logoRazmer: 22//Размер Логотита в приложении.
    property string logoImya: "tmk-ts-bw-1"//Имя логотипа в DCLogo
    property bool pdfViewer: true//false - Отключить pdf просмоторщик.
    property bool appRedaktor: true//false - Отключить Редактор приложения.
    property int shrift: 2;//1 - маленький, 2 - средний, 3 - большой
    property int ntWidth: 2*shrift
    property int ntCoff: 8
    property bool isMobile: {//Переменная определяющая, мобильная это платформа или нет. true - мобильная.
        if((Qt.platform.os === "android") || (Qt.platform.os === "ios"))//Если мобильная платформа, то...
			return true;//Это мобильная платформа.
		else//Эсли не мобильная, то...
			return false;//Это не мобильная платформа.
	}
    property string modeFileDialog: ""//plan, filedialog, polkatalog, ustkatalog
    //Настройки.
    visible: true
	color: "grey"
    title: qsTr("Ментор от druidcat@yandex.ru")
    x: isMobile ? 0 : cppqml.untX//Считываем из реестра X (в бизнес-логике)
    y: isMobile ? 0 : cppqml.untY//Считываем из реестра Y (в бизнес-логике)
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
    //Функции
    function ensureOnScreen() {//Функция не дающая окну оказаться вне видимой области экрана
        if (isMobile) return//Если мобильное устройство, выходим из функции.
        // Может быть undefined до показа окна/привязки к монитору
        var scr = root.screen
        var a = null

        if (scr && scr.availableGeometry && scr.availableGeometry.width !== undefined) {
            a = scr.availableGeometry
        } else if (scr && scr.geometry && scr.geometry.width !== undefined) {
            a = scr.geometry// fallback #1
        } else {
            a = { x: 0, y: 0,
                  width: Screen.desktopAvailableWidth,
                  height: Screen.desktopAvailableHeight }//fallback #2 — первичный экран (без учёта панелей)
        }
        if (!a || a.width === undefined || a.height === undefined) {// Если всё ещё нет валидной геометрии, то
            Qt.callLater(ensureOnScreen)//Через паузу попробуем позже
            return
        }
        var maxX = a.x + Math.max(0, a.width  - width)
        var maxY = a.y + Math.max(0, a.height - height)
        var nx = Math.min(Math.max(x, a.x), maxX)
        var ny = Math.min(Math.max(y, a.y), maxY)
        if (nx !== x) x = nx
        if (ny !== y) y = ny
    }
    onWidthChanged: {//Если Ширина поменялась, то...
        if(!isMobile){//Если не мобильная платформа, то...
            cppqml.untWidth = width;//Отправляем в бизнес логику ширину окна, для обработки.
        }
    }
    onHeightChanged: {//Если Высота поменялась, то...
        if(!isMobile){//Если не мобильная платформа, то...
            cppqml.untHeight = height;//Отправляем в бизнес логику высоту окна, для обработки.
        }
    }
    onXChanged: {//Если X координата изменилась, то...
        if (!isMobile)//Если не мобильное устройство, то...
            cppqml.untX = x;//Сохранение X координаты в бизнес-логику
    }
    onYChanged: {//Если Y координата изменилась, то...
        if (!isMobile)//Если не мобильное устройство, то...
            cppqml.untY = y;//Сохранение Y координаты в бизнес-логику
    }
    onVisibleChanged: {//Вызывать кламп после показа окна
        if(visible && !isMobile) Qt.callLater(ensureOnScreen)//Если видимое окно и не мобильное устройство
    }
    onScreenChanged: {//При смене экрана (перетаскивание между мониторами)
        if(!isMobile) Qt.callLater(ensureOnScreen)
    }
    Component.onCompleted: {//После создания окна
        if(!isMobile) Qt.callLater(ensureOnScreen)//Немного отложим, чтобы гарантированно применились размеры
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
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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

                onClickedNazad: stvStr.pop()//Назад страницу
                onClickedInfo: stvStr.push(pgStrInstrukciyaMenu)//Переходим на страницу Инструкции Меню
                onClickedHotKey: stvStr.push(pgStrHotKey)//Переходим на страницу горячих клавиш.
                onClickedAnimaciya: stvStr.push(pgStrAnimaciya);//Переходим на страницу Анимация.
                onClickedLogi: stvStr.push(pgStrLogi)//Переходим на страницу Логи.
                onClickedMentor: stvStr.push(pgStrMentor)//Переходим на страницу об Менторе.
                onClickedQt: stvStr.push(pgStrQt)//Переходим на страницу об Qt.
                onClickedKatalog: stvStr.push(pgStrKatalog)//Переходим на страницу Создать каталог документов
                onPdfViewerChanged: {//Если флаг настройки pdf Проигрывателя изменился, то...
                    root.pdfViewer = pdfViewer;//Приравниваем флаг настройки.
                }
				onAppRedaktorChanged: {//Если флаг настройки включения Редактора изменился, то...
                    root.appRedaktor = appRedaktor;//Приравниваем флаг настройки.
                }
                onUntShriftChanged: {//Если изменился шрифт в настройках, то...
                    root.shrift = (untShrift + 1)
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
                root.shrift = (tmMenu.untShrift + 1);//Задаём размер шрифта в приложении.
            }
        }
        Stranica {//Горячие Клавиши.
        ///////////////////////////////////
        ///Г О Р Я Ч И Е   К Л А В И Ш И///
        ///////////////////////////////////
            id: pgStrHotKey
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ГОРЯЧИЕ КЛАВИШИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                id: tmHotKey
                strInstrukciya: "hotkey"
                ntWidth: pgStrHotKey.ntWidth; ntCoff: pgStrHotKey.ntCoff
                clrTexta: pgStrHotKey.clrTexta; clrFona: pgStrHotKey.clrRabOblasti
                clrPolzunka: pgStrHotKey.clrFona
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

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
        Stranica {//Анимация
        /////////////////////
        ///А Н И М А Ц И Я///
        /////////////////////
            id: pgStrAnimaciya
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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

                onClickedNazad: stvStr.pop()//Назад страницу
                onClickedInfo: stvStr.push(pgStrInstrukciyaAnimacii);//Переключаемся на Инструкцию Анимации.
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrAnimaciya.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
            }
        }
        Stranica {//Логи
        /////////////
        ///Л О Г И///
        /////////////
            id: pgStrLogi
			visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ЛОГИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrDebug {
                id: tmLogi
                ntWidth: pgStrLogi.ntWidth; ntCoff: pgStrLogi.ntCoff
                clrTexta: pgStrLogi.clrTexta; clrFona: pgStrLogi.clrRabOblasti
                zagolovokX: pgStrLogi.rctStrZagolovok.x; zagolovokY: pgStrLogi.rctStrZagolovok.y
                zagolovokWidth: pgStrLogi.rctStrZagolovok.width
                zagolovokHeight: pgStrLogi.rctStrZagolovok.height
                zonaX: pgStrLogi.rctStrZona.x; zonaY: pgStrLogi.rctStrZona.y
                toolbarX: pgStrLogi.rctStrToolbar.x; toolbarY: pgStrLogi.rctStrToolbar.y
                toolbarWidth: pgStrLogi.rctStrToolbar.width
                toolbarHeight: pgStrLogi.rctStrToolbar.height
                radiusZona: pgStrLogi.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrLogi.zagolovokLevi; tapZagolovokPravi: pgStrLogi.zagolovokPravi
                tapToolbarLevi: pgStrLogi.toolbarLevi; tapToolbarPravi: pgStrLogi.toolbarPravi
                zonaWidth: pgStrLogi.rctStrZona.width; zonaHeight: pgStrLogi.rctStrZona.height

                onClickedNazad: stvStr.pop()//Назад страницу
			}
        }
        Stranica {//Ментор
        /////////////////////////////
        ///О   П Р И Л О Ж Е Н И И///
        /////////////////////////////
            id: pgStrMentor
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("О ПРИЛОЖЕНИИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                id: tmMentor
                strInstrukciya: "oprilojenii"
                ntWidth: pgStrMentor.ntWidth; ntCoff: pgStrMentor.ntCoff
                clrTexta: pgStrMentor.clrTexta; clrFona: pgStrMentor.clrRabOblasti
                clrPolzunka: pgStrMentor.clrFona
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

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
        Stranica {//Qt
        /////////////
        ///О   Q T///
        /////////////
            id: pgStrQt
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("О Qt")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                id: tmQt
                strInstrukciya: "oqt"
                ntWidth: pgStrQt.ntWidth; ntCoff: pgStrQt.ntCoff
                clrTexta: pgStrQt.clrTexta; clrFona: pgStrQt.clrRabOblasti
                clrPolzunka: pgStrQt.clrFona
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

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
        Stranica {//Создание Каталога
        ///////////////////////////////////////
        ///С О З Д А Н И Е   К А Т А Л О Г А///
        ///////////////////////////////////////
            id: pgStrKatalog
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("СОЗДАНИЕ КАТАЛОГА ДОКУМЕНТОВ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrKatalog {
                ntWidth: pgStrKatalog.ntWidth; ntCoff: pgStrKatalog.ntCoff
                clrTexta: pgStrKatalog.clrTexta; clrFona: pgStrKatalog.clrRabOblasti
                clrMenuText: root.clrMenuText; clrMenuFon: pgStrKatalog.clrFona
                zagolovokX: pgStrKatalog.rctStrZagolovok.x; zagolovokY: pgStrKatalog.rctStrZagolovok.y
                zagolovokWidth: pgStrKatalog.rctStrZagolovok.width
                zagolovokHeight: pgStrKatalog.rctStrZagolovok.height
                zonaX: pgStrKatalog.rctStrZona.x; zonaY: pgStrKatalog.rctStrZona.y
                zonaWidth: pgStrKatalog.rctStrZona.width; zonaHeight: pgStrKatalog.rctStrZona.height
                toolbarX: pgStrKatalog.rctStrToolbar.x; toolbarY: pgStrKatalog.rctStrToolbar.y
                toolbarWidth: pgStrKatalog.rctStrToolbar.width
                toolbarHeight: pgStrKatalog.rctStrToolbar.height
                tapZagolovokLevi: pgStrKatalog.zagolovokLevi
                tapZagolovokPravi: pgStrKatalog.zagolovokPravi
                tapToolbarLevi: pgStrKatalog.toolbarLevi; tapToolbarPravi: pgStrKatalog.toolbarPravi
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

                onClickedNazad: stvStr.pop()//Назад страницу
                onClickedInfo: stvStr.push(pgStrInstrukciyaKataloga);//Переключаемся на Инструкцию Каталога.
                onClickedPolKatalog: {//Слот нажатия кнопки открытия папки в которой создался каталог док..
                    root.modeFileDialog = "polkatalog";//Открываем проводник папки где создан каталог докумен.
                    pgStrFileDialog.textZagolovok = cppqml.strKatalogPut;//Путь в заголовке
                    pgStrFileDialog.textToolbar = qsTr("Выберите документ для просмотра.")
                    cppqml.strFileDialogPut = cppqml.strKatalogPut;//ВАЖНО!Обнов.каталог Проводника сохр путём
                    tmFileDialog.failVibor = true;//Проводник выбирает файлы.
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
                onClickedUstKatalog: {//Задаём папку, в которой будет создаваться Каталог.
                    root.modeFileDialog = "ustkatalog";//Открываем проводник,зададим папку сохранения Каталога
                    pgStrFileDialog.textZagolovok = cppqml.strKatalogPut;//Путь в заголовке
                    pgStrFileDialog.textToolbar = qsTr("<- Выберите папку сохранения и нажмите Ок.")
                    cppqml.strFileDialogPut = cppqml.strKatalogPut;//ВАЖНО!Обнов.каталог Проводника сохр путём
                    tmFileDialog.failVibor = false;//Проводник выбирает папки.
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
                onSignalZagolovok: function(strZagolovok) {//Слот сигнала signalZagolovok с новым Заголовком.
                    pgStrKatalog.textZagolovok = strZagolovok;//Выставляем изменённый Заголовок.
                }
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrKatalog.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
            }
        }
		Stranica {//Страница со Списком
		/////////////////
		///С П И С О К///
		/////////////////
			id: pgStrSpisok
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

                onClickedMenu: stvStr.push(pgStrMenu)//Перейти на страницу Меню
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
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

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
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrFaila: root.clrFaila
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
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

				onClickedNazad: {//Слот нажатия кнопки Назад.
					cppqml.ullElementKod = 0;//НЕ УДАЛЯТЬ! На странице Элемент код не выбран и равен 0.
					stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
					stvStr.pop()//Назад страницу
				}
                onClickedSozdat: {//Слот нажатия кнопки Создать.
                    root.modeFileDialog = "filedialog";//Открываем проводник для Данных.
                    pgStrFileDialog.textZagolovok = pgStrDannie.textZagolovok;//Заголовок Данных.
                    pgStrFileDialog.textToolbar = qsTr("Выберите PDF документ для добавления.")
                    cppqml.strFileDialogPut = "start";//ВАЖНО!!! Обновляем каталог Проводника 
                    tmFileDialog.failVibor = true;//Проводник выбирает файлы.
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
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

				onClickedNazad: {
					cppqml.ullDannieKod = 0;//НЕ УДАЛЯТЬ! На странице Данные код не выбран и равен 0.
                    if(root.modeFileDialog === "polkatalog")//Если режим открытия Каталога и документов, то...
                        cppqml.strFileDialogPut = "sohranit";//ВАЖНО!!! Сохраняем положение в дереве папок.
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
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok
            clrFaila: root.clrFaila; clrRabOblasti: root.clrStranic
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrFileDialog{//Блок Файлового Диалога, чтоб разгрузить Main.qml
                id: tmFileDialog
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
                modeFileDialog: root.modeFileDialog//Выбор режима открытия проводника для Плана или Данных.
                pdfViewer: root.pdfViewer
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

                onClickedZakrit: {//Если нажата кнопка Назад или Закрыть, то...
                    if(root.modeFileDialog === "plan"){//Если открывался План, то...
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
                    else{
                        if(root.modeFileDialog === "filedialog")//Если открывались Данные, то...
                            stvStr.strOpisanie = "element";//Показываем описание Элемента списка.
                    }
                    stvStr.pop()//Назад страницу
                }
                onClickedOk: {//Если нажата кнопка Ок, то...
                    if(root.modeFileDialog === "ustkatalog")//Если это установить путь к папке с каталгами, то
                        cppqml.strKatalogPut = cppqml.strFileDialogPut;//Запоминаем новый путь.
                    stvStr.pop()//Назад страницу
                }
                onClickedFail: function (strImyaFaila){//Если кликнули по документу.
                    if(root.pdfViewer){//Если выбран в настройках собственный просмотрщик, то...
                        pgStrPdf.textZagolovok = strImyaFaila;//Делаем заголовок с именем Документа.
                        pgStrPdf.textToolbar = "";//Очищаем
                        cppqml.strKatalogUrl = strImyaFaila;//Создаём путь+файл и отправляем в pgStrPdf
                        stvStr.push(pgStrPdf);//Переходим на страницу отображения Pdf документа.
                    }
                    else//Если на сторонний просмотщик pdf документов, то...
                        Qt.openUrlExternally(cppqml.polKatalogUrl(strImyaFaila));//Открываем в стороннем app.
                }
                onSignalZagolovok: function(strZagolovok){//Слот имени Заголовка.
                    pgStrFileDialog.textZagolovok = strZagolovok;//Изменяем заголовок.
                }
				onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrFileDialog.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
                onClickedInfo: {
                    stvStr.push(pgStrInstrukciyaFB);//Переключаемся на страницу Инструкция проводника.
                }
            }
        }
		Stranica {//Страница Описания
		/////////////////////
		///О П И С А Н И Е///
		/////////////////////
			id: pgStrOpisanie
			visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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
                clrPolzunka: pgStrOpisanie.clrFona
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

                onClickedNazad: stvStr.pop()//Назад страницу
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
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
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
                logoRazmer: root.logoRazmer; logoImya: root.logoImya

                onClickedNazad: stvStr.pop()//Назад страницу
                onClickedSozdat: {//Слот нажатия кнопки Создать.
                    root.modeFileDialog = "plan";//Открываем проводник для План.
                    pgStrFileDialog.textZagolovok = stvStr.infoElement//Заголовок Проводника.
                    pgStrFileDialog.textToolbar = qsTr("Выберите PDF документ для добавления.")
                    cppqml.strFileDialogPut = "start";//ВАЖНО!!! Обновляем каталог Проводника
                    tmFileDialog.failVibor = true;//Проводник выбирает файлы.
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
            }
        }
        Stranica {//Инструкция Меню.
        ///////////////////////////////////
        ///И Н С Т Р У К Ц И Я   М Е Н Ю///
        ///////////////////////////////////
            id: pgStrInstrukciyaMenu
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ОПИСАНИЕ НАСТРОЕК МЕНЮ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                strInstrukciya: "menu"
                ntWidth: pgStrInstrukciyaMenu.ntWidth; ntCoff: pgStrInstrukciyaMenu.ntCoff
                clrTexta: pgStrInstrukciyaMenu.clrTexta; clrFona: pgStrInstrukciyaMenu.clrRabOblasti
                clrPolzunka: pgStrInstrukciyaMenu.clrFona
                zagolovokX: pgStrInstrukciyaMenu.rctStrZagolovok.x;
                zagolovokY: pgStrInstrukciyaMenu.rctStrZagolovok.y
                zagolovokWidth: pgStrInstrukciyaMenu.rctStrZagolovok.width
                zagolovokHeight: pgStrInstrukciyaMenu.rctStrZagolovok.height
                zonaX: pgStrInstrukciyaMenu.rctStrZona.x; zonaY: pgStrInstrukciyaMenu.rctStrZona.y
                zonaWidth: pgStrInstrukciyaMenu.rctStrZona.width;
                zonaHeight: pgStrInstrukciyaMenu.rctStrZona.height
                toolbarX: pgStrInstrukciyaMenu.rctStrToolbar.x;
                toolbarY: pgStrInstrukciyaMenu.rctStrToolbar.y
                toolbarWidth: pgStrInstrukciyaMenu.rctStrToolbar.width
                toolbarHeight: pgStrInstrukciyaMenu.rctStrToolbar.height
                radiusZona: pgStrInstrukciyaMenu.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrInstrukciyaMenu.zagolovokLevi
                tapZagolovokPravi: pgStrInstrukciyaMenu.zagolovokPravi
                tapToolbarLevi: pgStrInstrukciyaMenu.toolbarLevi
                tapToolbarPravi: pgStrInstrukciyaMenu.toolbarPravi

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
        Stranica {//Инструкция Анимации.
        ///////////////////////////////////////////
        ///И Н С Т Р У К Ц И Я   А Н И М А Ц И И///
        ///////////////////////////////////////////
            id: pgStrInstrukciyaAnimacii
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ИНСТРУКЦИЯ ПО АНИМАЦИИ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                strInstrukciya: "animaciya"
                ntWidth: pgStrInstrukciyaAnimacii.ntWidth; ntCoff: pgStrInstrukciyaAnimacii.ntCoff
                clrTexta: pgStrInstrukciyaAnimacii.clrTexta; clrFona: pgStrInstrukciyaAnimacii.clrRabOblasti
                clrPolzunka: pgStrInstrukciyaAnimacii.clrFona
                zagolovokX: pgStrInstrukciyaAnimacii.rctStrZagolovok.x;
                zagolovokY: pgStrInstrukciyaAnimacii.rctStrZagolovok.y
                zagolovokWidth: pgStrInstrukciyaAnimacii.rctStrZagolovok.width
                zagolovokHeight: pgStrInstrukciyaAnimacii.rctStrZagolovok.height
                zonaX: pgStrInstrukciyaAnimacii.rctStrZona.x; zonaY: pgStrInstrukciyaAnimacii.rctStrZona.y
                zonaWidth: pgStrInstrukciyaAnimacii.rctStrZona.width;
                zonaHeight: pgStrInstrukciyaAnimacii.rctStrZona.height
                toolbarX: pgStrInstrukciyaAnimacii.rctStrToolbar.x;
                toolbarY: pgStrInstrukciyaAnimacii.rctStrToolbar.y
                toolbarWidth: pgStrInstrukciyaAnimacii.rctStrToolbar.width
                toolbarHeight: pgStrInstrukciyaAnimacii.rctStrToolbar.height
                radiusZona: pgStrInstrukciyaAnimacii.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrInstrukciyaAnimacii.zagolovokLevi
                tapZagolovokPravi: pgStrInstrukciyaAnimacii.zagolovokPravi
                tapToolbarLevi: pgStrInstrukciyaAnimacii.toolbarLevi
                tapToolbarPravi: pgStrInstrukciyaAnimacii.toolbarPravi

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
        Stranica {//Описание Создания каталога.
        ///////////////////////////////////////////
        ///И Н С Т Р У К Ц И Я   К А Т А Л О Г А///
        ///////////////////////////////////////////
            id: pgStrInstrukciyaKataloga
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ИНСТРУКЦИЯ ПО СОЗДАНИЮ КАТАЛОГА ДОКУМЕНТОВ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                strInstrukciya: "katalog"
                ntWidth: pgStrInstrukciyaKataloga.ntWidth; ntCoff: pgStrInstrukciyaKataloga.ntCoff
                clrTexta: pgStrInstrukciyaKataloga.clrTexta; clrFona: pgStrInstrukciyaKataloga.clrRabOblasti
                clrPolzunka: pgStrInstrukciyaKataloga.clrFona
                zagolovokX: pgStrInstrukciyaKataloga.rctStrZagolovok.x;
                zagolovokY: pgStrInstrukciyaKataloga.rctStrZagolovok.y
                zagolovokWidth: pgStrInstrukciyaKataloga.rctStrZagolovok.width
                zagolovokHeight: pgStrInstrukciyaKataloga.rctStrZagolovok.height
                zonaX: pgStrInstrukciyaKataloga.rctStrZona.x; zonaY: pgStrInstrukciyaKataloga.rctStrZona.y
                zonaWidth: pgStrInstrukciyaKataloga.rctStrZona.width;
                zonaHeight: pgStrInstrukciyaKataloga.rctStrZona.height
                toolbarX: pgStrInstrukciyaKataloga.rctStrToolbar.x
                toolbarY: pgStrInstrukciyaKataloga.rctStrToolbar.y
                toolbarWidth: pgStrInstrukciyaKataloga.rctStrToolbar.width
                toolbarHeight: pgStrInstrukciyaKataloga.rctStrToolbar.height
                radiusZona: pgStrInstrukciyaKataloga.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrInstrukciyaKataloga.zagolovokLevi
                tapZagolovokPravi: pgStrInstrukciyaKataloga.zagolovokPravi
                tapToolbarLevi: pgStrInstrukciyaKataloga.toolbarLevi
                tapToolbarPravi: pgStrInstrukciyaKataloga.toolbarPravi

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
        Stranica {//Описание Проводника.
        ///////////////////////////////////////////////
        ///И Н С Т Р У К Ц И Я   П Р О В О Д Н И К А///
        ///////////////////////////////////////////////
            id: pgStrInstrukciyaFB
            visible: false
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            clrFona: root.clrFona; clrTexta: root.clrKnopok; clrRabOblasti: root.clrStranic
            textZagolovok: qsTr("ИНСТРУКЦИЯ ПО ПРОВОДНИКУ")
            zagolovokLevi: 1.3; zagolovokPravi: 1.3; toolbarLevi: 1.3; toolbarPravi: 1.3
            StrInstrukciya {
                strInstrukciya: "fdinstrukciya"
                ntWidth: pgStrInstrukciyaFB.ntWidth; ntCoff: pgStrInstrukciyaFB.ntCoff
                clrTexta: pgStrInstrukciyaFB.clrTexta; clrFona: pgStrInstrukciyaFB.clrRabOblasti
                clrPolzunka: pgStrInstrukciyaFB.clrFona
                zagolovokX: pgStrInstrukciyaFB.rctStrZagolovok.x;
                zagolovokY: pgStrInstrukciyaFB.rctStrZagolovok.y
                zagolovokWidth: pgStrInstrukciyaFB.rctStrZagolovok.width
                zagolovokHeight: pgStrInstrukciyaFB.rctStrZagolovok.height
                zonaX: pgStrInstrukciyaFB.rctStrZona.x; zonaY: pgStrInstrukciyaFB.rctStrZona.y
                zonaWidth: pgStrInstrukciyaFB.rctStrZona.width;
                zonaHeight: pgStrInstrukciyaFB.rctStrZona.height
                toolbarX: pgStrInstrukciyaFB.rctStrToolbar.x; toolbarY: pgStrInstrukciyaFB.rctStrToolbar.y
                toolbarWidth: pgStrInstrukciyaFB.rctStrToolbar.width
                toolbarHeight: pgStrInstrukciyaFB.rctStrToolbar.height
                radiusZona: pgStrInstrukciyaFB.rctStrZona.radius//Радиус берём из настроек элемента qml
                tapZagolovokLevi: pgStrInstrukciyaFB.zagolovokLevi
                tapZagolovokPravi: pgStrInstrukciyaFB.zagolovokPravi
                tapToolbarLevi: pgStrInstrukciyaFB.toolbarLevi
                tapToolbarPravi: pgStrInstrukciyaFB.toolbarPravi

                onClickedNazad: stvStr.pop()//Назад страницу
            }
        }
	}  
}
