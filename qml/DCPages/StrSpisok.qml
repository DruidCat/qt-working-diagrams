import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
import DCZones 1.0//Импортируем зону Данных.
//Страниц отображающая Список, первый, главный экран со Списком чего либо.
Item {
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "Orange"
	property color clrFona: "Black"
    property color clrMenuText: "Orange"
	property color clrMenuFon: "SlateGray"
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
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property bool appRedaktor: false//true - включить Редактор приложения.
    property bool blPereimenovatVibor: false//Выбрать элемент пеименования, если true
    property bool blPereimenovat: false//Запрос на переименование, если true
    property bool blUdalitVibor: false//Включить режим выбора удаляемого Списка, если true
    property bool blZagolovok: false//Переименовать Заголовок, если true
    property int logoRazmer: 22//Размер Логотипа.
    property string logoImya: "mentor"//Имя логотипа в DCLogo
    //Настройки.
    anchors.fill: parent//Растянется по Родителю.
    //focus: true//Обязательно, иначе на Андроид экранная клавиатура не открывается.
    Keys.priority: Keys.AfterItem//Чтобы корневой StrSpisok не перехватывал события раньше списка lsvZona
    //Сигналы.
	signal clickedMenu();//Сигнал нажатия кнопки Меню. 
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedSpisok(var strSpisok);//Сигнал когда нажат один из элементов Списка.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    signal signalZagolovok(var strZagolovok);//Сигнал, когда передаём новую надпись в Заголовок.
    //Функции. 
	Component.onCompleted: {//Когда страница загрузится...
		Qt.callLater(function () {//Делаем паузу на такт, иначе не сработает фокус.
            lsvSpisok.fnFocus();//Установить фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
		})
    }
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event => 
        if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
            if(event.key === Qt.Key_N){//Если нажата клавиша N, то...
                if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
                    fnClickedSozdat();//Функция создания Списка.
                event.accepted = true;//Завершаем обработку эвента.
            }
            else{
                if(event.key === Qt.Key_S){//Если нажат "S", то.
                    if(knopkaOk.visible)//Если кнопка Ок видимая, то...
                        fnClickedOk();//Функция нажатия кнопки Ok.
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
        }
        else{
            if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                if (event.key === Qt.Key_F){//Если нажата клавиша F, то...
                    if(knopkaMenu.visible)//Если кнопка Меню видимая, то...
                        fnClickedMenu();//Функция нажатия кнопки Меню
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
            else{
                if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                    if(event.key === Qt.Key_I){//Если нажата клавиша I, то...
                        if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
                            fnClickedSozdat();//Функция редактирования текста.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
                else{
                    if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
                        root.signalToolbar("");//Делаем пустую строку в Toolbar.
                        fnClickedEscape();//Функция нажатия кнопки Escape.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                    else{
                        if(event.key === Qt.Key_F1){//Если нажата кнопка F1, то...
                            if(knopkaInfo.visible)
                                fnClickedInfo();//Функция нажатия на кнопку Информация.
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                    }
                }
            }
        }
        //cppqml.strDebug = event.key;
    }
    MouseArea {//Если кликнуть на tmZagolovok, свернётся Меню. Объявлять в начале Item.
        anchors.fill: tmZagolovok
		enabled:{
			if(txnZagolovok.visible || txuUdalit.visible)//Если DCTextInput или DCUdalit видимы, то...
				return false//Деактивируем зону мышки Заголовка.
			else//Если не видима, то...
				return true//Активируем зону мышки Заголовка.
		}
        onClicked: {
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
	MouseArea {//Если кликнуть на tmToolbar, свернётся Меню. Объявлять в начале Item.
        anchors.fill: tmToolbar
        onClicked: {
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        lsvSpisok.fnFocus();//Установить фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuSpisok.visible = false;//Делаем невидимым всплывающее меню.
        root.blPereimenovat = false;//Запрещаем выбор переименовывания.
        root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        root.blUdalitVibor = false;//Запрещаем выбирать Список для удаления.
        txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
        root.blZagolovok = false;//Запрещаем изменять заголовок.
        lsvSpisok.enabled = true;//Делаем кликабельную Зону.
    }
    function fnClickedMenu(){//Функция нажатия кнопки Меню
        cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
        root.clickedMenu();//Сигнал Меню
    }
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedInfo(){//Функция нажатия кнопки Информация
        cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
        root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
    }
	function fnClickedOk(){//Функция сохранения/переименования элемента Списка.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        if(blZagolovok){//Если изменить имя заголовка, то...
            cppqml.strTitul = txnZagolovok.text;//Переименовываем Заголовок Списка.
            root.signalZagolovok(cppqml.strTitul);//Отображаем Заголовок
        }
        else{//В ином случае...
            if(root.blPereimenovat)//Если запрос на переименовывание.
                cppqml.renStrSpisokDB(cppqml.strSpisok, txnZagolovok.text)//Переименовываем элемент Списка
            else{//иначе...
                cppqml.strSpisokDB = txnZagolovok.text;//Сохранить название элемента списка, и только потом...
            }
        }
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnUdalit(strKod, strImya){//Функция запуска Запроса на Удаление выбранного Списка.
        root.blUdalitVibor = false;//Запрещено выбирать Список на удаление.
        txuUdalit.visible = true;//Делаем видимый запрос на удаление.
        txuUdalit.kod = strKod;//Код на удаление
        txuUdalit.text = strImya;//Имя на удаление
        lsvSpisok.enabled = false;//Делаем не кликабельную Зону.
        root.signalToolbar(qsTr("Удалить данный список?"));//Делаем предупреждение в Toolbar.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
        root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        root.blUdalitVibor = false;//Запрещено выбирать Список на удаление. НЕ УДАЛЯТЬ.
        menuSpisok.visible = false;//Делаем невидимым меню.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ СПИСКА");//Подсказка пользователю, что вводить нужно.
       	txnZagolovok.visible = true;//Режим создания элемента Списка ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
        lsvSpisok.enabled = false;//Делаем не кликабельную Зону.
        root.signalToolbar(qsTr("Создайте новый список."))
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        root.blPereimenovatVibor = true;//Разрешаем выбор элементов для переименовывания.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ СПИСКА");//Подсказка пользователю, что вводить нужно.
        root.signalToolbar(qsTr("Выберите список для его переименования."))
    }
    function fnMenuUdalit(){//Нажат пункт меню Удалить.
        root.blUdalitVibor = true;//Включаем режим выбора удаляемого Списка.
        root.signalToolbar(qsTr("Выберите список для его удаления."))
    }
    function fnMenuSort(){//Функция нажатия пункта меню Сортировать.
        cppqml.strDebug = "Данный функционал в стадии разработки.";//Сообщение в Toolbar.
    }
    function fnMenuZagolovok(){//Нажат пункт меню Изменить Заголовок.
        blZagolovok = true;//Изменить заголовок.
        menuSpisok.visible = false;//Делаем невидимым меню.
        txnZagolovok.ustText(cppqml.strTitul);//Добавляем в строку Заголовок, для понятного редактирования
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ЗАГОЛОВКА");//Подсказка пользователю,что вводить нужн
        txnZagolovok.visible = true;//Показ текстового редактора Заголовка ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
        lsvSpisok.enabled = false;//Делаем не кликабельную Зону.
        root.signalToolbar(qsTr("Измените имя заголовка списка."));
    }
    Item {//Спискок Заголовка
        id: tmZagolovok
        DCKnopkaMenu {
            id: knopkaMenu
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedMenu();//Функция нажатия кнопки Меню
		}
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
        }
        DCKnopkaInfo {
			id: knopkaInfo
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			visible: true
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedInfo();//Функция нажатия на кнопку Информации.
        }
        DCKnopkaOk {
            id: knopkaOk
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedOk();//Нажимаем на Ок(Сохранить/Переименовать)
		}
        DCTextUdalit {
            id: txuUdalit
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

            visible: false//Невидимый виджет

            clrFona: root.clrTexta//Если не задать цвет, будет видно текст под надписью
            clrTexta: root.clrFona
            clrKnopki: root.clrFona
            clrBorder: root.clrFona

            tapKnopkaZakrit: root.tapZagolovokLevi; tapKnopkaOk: root.tapZagolovokPravi
            onVisibleChanged: {//Защита от двойного срабатывания кнопок. Если изменился статус Видимости,то...
                if(visible){//Если видимый виджет, то...
                    knopkaMenu.visible = false;//Кнопка Меню Невидимая.
                    knopkaInfo.visible = false;//Конопка Информация Невидимая.
                }
                else{//Если невидимый виджет, то...
                    knopkaMenu.visible = true;//Кнопка Меню Видимая.
                    knopkaInfo.visible = true;//Конопка Информация Видимая.
                }
            }
            onClickedUdalit: function (strKod) {//Слот нажатия кнопки Удалить
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvSpisok.enabled = true;//Делаем кликабельную Зону.
                if(cppqml.delStrSpisok(strKod))//Запускаю метод удаление Списка из БД, Элементов и  Документов
                    root.signalToolbar(qsTr("Успешное удаление списка."));
                else
                    cppqml.strDebug = qsTr("Ошибка при удалении.");
                lsvSpisok.fnFocus();//Установить фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                lsvSpisok.fnFocus();//Установить фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvSpisok.enabled = true;//Делаем кликабельную Зону.
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
        }
		Item {
            id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaMenu.right
			anchors.right: knopkaInfo.left
            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2
			
            DCTextInput {
                id: txnZagolovok
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.fill: tmTextInput
				visible: false
				blSqlProtect: true//Активируем Sql защиту от ввода нежелательных символов для запроса Sql.
                clrTexta: root.clrTexta; clrFona: root.clrMenuFon
				radius: root.ntCoff/2
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                textInput.inputMethodHints: Qt.ImhUppercaseOnly//Буквы в виртуальной клавиатуре заглавные
                textInput.maximumLength: cppqml.untNastroikiMaxLength
                onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видим, то...
                        knopkaMenu.visible = false;//Кнопка Меню Невидимая.
                        knopkaInfo.visible = false;//Конопка Информация Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                    }
                    else{//Если DCTextInput не видим, то...
                        lsvSpisok.fnFocus();//Фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
                        knopkaMenu.visible = true;//Кнопка Меню видимая.
                        knopkaInfo.visible = true;//Конопка Информация Видимая.
                        txnZagolovok.text = "";//Текст обнуляем вводимый.
                    }
				}
                onClickedEnter: {//слот нажатия кнопки Enter.
                    if(knopkaOk.visible)
                        fnClickedOk();//Функция сохранения данных.
                }
			}
		}
    }
	Item {//Список Рабочей Зоны
        id: tmZona
        Rectangle {
            id: rctZona
			anchors.fill: tmZona
			color: "transparent"
            clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCLogo {//Логотип до ZonaSpisok, чтоб не перекрывать список.
                anchors.centerIn: parent
                ntCoff: root.logoRazmer; logoImya: root.logoImya
                clrLogo: root.clrTexta; clrFona: root.clrFona
            }
            DCListView {
                id: lsvSpisok
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.fill: rctZona
                //clrTexta: "#00CC99"//Интересный изумрудный цвет.
                clrTexta: root.clrTexta; clrFona: root.clrMenuFon
                zona: "spisok"
                onClicked: function(ntKod, strSpisok) {//Слот clicked нажатия на один из элементов Списка.
                    if(cppqml.blSpisokPervi){//Если это первый в Списке, то...
						if(root.appRedaktor)//Если включён Редактор приложения, то...
                        	fnClickedSozdat();//Функция обрабатывающая кнопку Создать.
						else
                    		cppqml.strDebug = qsTr("Режим редактора выключен.");
							
                    }
                    else{//Если не первый элемент, то...
                        if(root.blPereimenovatVibor){//Если разрешён выбор элементов для переименовывания.
                            root.blPereimenovatVibor = false;//Запрещаем выбор элемента для переименования
                            root.blPereimenovat = true;//Переименование (отмена)...(ок)
                            root.signalToolbar(qsTr("Переименуйте выбранный список."));
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            cppqml.strSpisok = strSpisok;//Присваиваем элемент списка к свойству Q_PROPERTY
                            txnZagolovok.ustText(strSpisok);//Добавляем в строку выбранный элемент Списка.
                            lsvSpisok.enabled = false;//Делаем не кликабельную Зону.
                        }
                        else {//Если не выбор Списка переименования, то ...
                            if(root.blUdalitVibor){//Если удалить, то...
                                fnUdalit(ntKod, strSpisok);//Функция удаления выбранного Списка.
                            }
                            else{//Если не выбор элемента на переименование, то перейти к Элементу...
                                cppqml.strDebug = "";
                                root.blPereimenovat = false;//Запрещаем переименование (отмена)...(ок)
                                root.blUdalitVibor = false;//Запрещено выбирать Список на удаление.
                                txuUdalit.visible = false;//Убираем запрос на удаление, если он есть.
                                txnZagolovok.visible = false;//Отключаем создание Элемента списка.
                                menuSpisok.visible = false;//Делаем невидимым меню.
                                cppqml.ullSpisokKod = ntKod;//Присваиваем Код списка к свойству Q_PROPERTY
                                cppqml.strSpisok = strSpisok;//Присваиваем элемент списка к свойству Q_PROPERTY
                                root.clickedSpisok(strSpisok);//Излучаем сигнал с именем элемента Списка.
                            }
                        }
                    }
				}
                onTap: {
                    root.signalToolbar("");//Делаем пустую строку в Toolbar.
                    fnClickedEscape();//Если нажали на пустое место.
                }
			}	
            DCMenu {
                id: menuSpisok
				visible: false//Невидимое меню. 
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: root.ntCoff
                pctFona: 0.90//Прозрачность фона меню.
                clrTexta: root.clrMenuText; clrFona: root.clrMenuFon
				imyaMenu: "spisok"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
				onClicked: function(ntNomer, strMenu) {
                    menuSpisok.visible = false;//Делаем невидимым меню.
                    if(ntNomer === 1){//Добавить.
                        fnMenuSozdat();//Функция обработки нажатия меню Добавить.
                    }
                    if(ntNomer === 2){//Переименовать.
                        fnMenuPereimenovat();//Функция нажатия пункта меню Переименовать.
					}
                    if(ntNomer === 3){//Удалить.
                        fnMenuUdalit();//Функция нажатия пункта меню Удалить.
                    }
                    if(ntNomer === 4){//Сортировать.
                        fnMenuSort();//Функция нажатия пункта меню Сортировать.
                    }
                    if(ntNomer === 5){//Изменить Заголовок.
                        fnMenuZagolovok();//Функция нажатия пункта меню Изменить Заголовок.
                    }
                    if(ntNomer === 6){//Выход
						Qt.quit();//Закрыть приложение.
					}
				}
            }
			Rectangle{//Это Рамка поверх логотипа и списков для переименования и удаления.
				id: rctBorder
				anchors.fill: rctZona
				color: "transparent"
				border.width: root.ntCoff/2//Бордюр при переименовании и удалении.
			}
		} 
    }
	onBlPereimenovatViborChanged: {//Слот сигнала изменения property blPereimenovatVibor (on...Changed)
        root.blPereimenovatVibor ? rctBorder.border.color=clrTexta : rctBorder.border.color="transparent";
        lsvSpisok.fnFocus();//Установить фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
    }
    onBlUdalitViborChanged: {//Слот сигнала изменения property blUdalitVibor(on...Changed)
        root.blUdalitVibor? rctBorder.border.color = "red" : rctBorder.border.color = "transparent";
        lsvSpisok.fnFocus();//Установить фокус на lsvZona в lsvSpisok, чтоб клавиши работали листания
    }
	Item {//Список Тулбара
        id: tmToolbar	
        DCKnopkaSozdat {
            id: knopkaSozdat
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
			visible: root.appRedaktor ? true : false//Настройка вкл/вык Редактор приложения.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {//Слот сигнала clicked кнопки Создать.
				txnZagolovok.visible ? fnClickedZakrit() : fnClickedSozdat()
            }
		}
        DCKnopkaNastroiki {
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
			visible: root.appRedaktor ? true : false//Настройка вкл/вык Редактор приложения.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                txnZagolovok.visible = false;//Отключаем создание Элемента списка.
                menuSpisok.visible ? menuSpisok.visible = false : menuSpisok.visible = true;
                root.blPereimenovat = false;//Запрещаем переименовывание (отмена)...(ок).
                root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
                root.blUdalitVibor = false;//Запрещено удалять.
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvSpisok.enabled = true;//Делаем кликабельную Зону.
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
		}
    }
}
