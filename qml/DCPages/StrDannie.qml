import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
import DCZones 1.0//Импортируем зону Данных.
//Страница с Данными, где отображаются сами документы в виде списка.
Item {
    id: root
    //Свойства
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
	property color clrFona: "black"
    property color clrFaila: "yellow"
    property color clrMenuText: "orange"
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
    property bool pdfViewer: false//true - включить собственный pdf просмотрщик.
    property bool appRedaktor: false//true - включить Редактор приложения.
    property bool blPereimenovatVibor: false//Выбрать элемент для переименования, если true
    property bool blPereimenovat: false//Запрос на переименование, если true
    property bool blUdalitVibor: false//Включить режим выбора удаляемого документа, если true
	property string strDannieRen: "";//Переменная хранит имя Документа, который нужно переименовать
    //Настройки
    anchors.fill: parent//Растянется по Родителю.
    focus: true//Не удалять, может Escape не работать.
    //Сигналы
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedDannie(var strDannie);//Сигнал когда нажат один из элементов Данных.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    signal signalZagolovok (var strZagolovok);//Сигнал излучающий имя каталога в Проводнике.
    //Функции
    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuDannie.visible = false;//Делаем невидимым всплывающее меню.
        root.blPereimenovat = false;//Запрещаем выбор переименовывания.
        root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        root.blUdalitVibor = false;//Запрещаем выбирать документ для удаления.
        txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
        lsvZona.enabled = true;//Делаем кликабельную Зону.
    }
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
            event.accepted = true;//Завершаем обработку эвента.
        }
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
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedOk(){//Функция переименования Данных.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        if(root.blPereimenovat)//Если запрос на переименовывание.
            cppqml.renStrDannieDB(strDannieRen, txnZagolovok.text);//Переименовываем имя Документа.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnUdalit(strKod, strImya){//Функция запуска Запроса на Удаление выбранного документа.
        root.blUdalitVibor = false;//Запрещено выбирать элементы на удаление.
        txuUdalit.visible = true;//Делаем видимый запрос на удаление.
        txuUdalit.kod = strKod;//Код на удаление
        txuUdalit.text = strImya;//Имя на удаление
        lsvZona.enabled = false;//Делаем не кликабельную Зону.
        root.signalToolbar(qsTr("Удалить данный документ?"));//Делаем предупреждение в Toolbar.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
        root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        root.blUdalitVibor = false;//Запрещено выбирать документ на удаление. НЕ УДАЛЯТЬ.
        menuDannie.visible = false;//Делаем невидимым меню.
        txnZagolovok.visible = false;//Отключаем переименование Докумена.
        lsvZona.enabled = true;//Делаем кликабельную Зону.
        root.clickedSozdat();//Излучаем сигнал, что нужно запустить Файловый Диалог.
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        root.blPereimenovatVibor = true;//Разрешаем выбор элементов для переименовывания.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ДОКУМЕНТА");//Подсказка пользователю,что вводить нужн
        root.signalToolbar(qsTr("Выберите документ для его переименования."))
    }
    function fnMenuUdalit(){//Нажат пункт меню Удалить.
        root.blUdalitVibor = true;//Включаем режим выбора удаляемого файла
        root.signalToolbar(qsTr("Выберите документ для его удаления."))
    }
    function fnMenuSort(){//Функция нажатия пункта меню Сортировать.
        cppqml.strDebug = "Данный функционал в стадии разработки.";//Сообщение в Toolbar.
    }
    Item {//Данные Заголовок
		id: tmZagolovok

        DCKnopkaNazad {
			id: knopkaNazad
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.	
                root.clickedNazad();
            }
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
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
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
            onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
                root.clickedInfo();
            }
        } 
        DCKnopkaOk{
            id: knopkaOk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                fnClickedOk();//Функция переименование данных.
            }
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
                    knopkaNazad.visible = false;//Кнопка Назад Невидимая.
                    knopkaInfo.visible = false;//Конопка Информация Невидимая.
                }
                else{//Если невидимый виджет, то...
                    knopkaNazad.visible = true;//Кнопка Назад Видимая.
                    knopkaInfo.visible = true;//Конопка Информация Видимая.
                }
            }
            onClickedUdalit: function (strKod) {//Слот нажатия кнопки Удалить
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvZona.enabled = true;//Делаем кликабельную Зону.
                if(cppqml.delStrDannie(strKod))//Запускаю метод удаление записи из БД и самого Документа.
                    root.signalToolbar(qsTr("Успешное удаление документа"));
                else
                    cppqml.strDebug = qsTr("Ошибка при удалении.");
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvZona.enabled = true;//Делаем кликабельную Зону.
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
        }
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaNazad.right
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
                clrTexta: root.clrTexta
				clrFona: "SlateGray"
				radius: root.ntCoff/2
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                textInput.inputMethodHints: Qt.ImhUppercaseOnly//Буквы в виртуальной клавиатуре заглавные
                textInput.maximumLength: cppqml.untNastroikiMaxLength
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
                        knopkaNazad.visible = false;//Кнопка назад Невидимая.
                        knopkaInfo.visible = false;//Конопка Информация Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
					}
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
                        knopkaNazad.visible = true;//Кнопка назад видимая.
                        knopkaInfo.visible = true;//Конопка Информация Видимая.
                        txnZagolovok.text = "";//Текст обнуляем вводимый.
                        knopkaInfo.focus = true;//Фокус на кнопке Информация, чтоб не работал Enter.
					}
				}
				onClickedEnter: {//слот нажатия кнопки Enter.
					fnClickedOk();//Функция сохранения данных.
				}
			}
		}
    } 
    Item {//Данные Зона
		id: tmZona
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCLogoTMK {
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: tmElement.clrTexta
                clrFona: tmElement.clrFona
            }
            ZonaDannie {
				id: lsvZona
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.fill: rctZona
                clrTexta: root.clrFaila//Цвет файлов
				clrFona: "SlateGray"
                onClicked: function(ntKod, strDannie) {//Слот нажатия на один из Документов списка.
					if(cppqml.blDanniePervi){//Если это первый Документ, то...
						if(root.appRedaktor)//Если включён Редактор приложения, то...
                        	fnClickedSozdat();//Функция при нажатии кнопки Создать(Проводник).
						else
                    		cppqml.strDebug = qsTr("Режим редактора выключен.");
					}
					else{//Если не первый элемент, то...
                        if(root.blPereimenovatVibor) {//Если разрешён выбор элементов для переименовывания
                            root.blPereimenovatVibor = false;//Запрещаем выбор элемента для переименования
                            root.blPereimenovat = true;//Переименование (отмена)...(ок)
                            root.signalToolbar(qsTr("Переименуйте выбранный документ."));
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            strDannieRen = strDannie;//Присваиваем переменной имя Документа.
                            txnZagolovok.ustText(strDannie);//Добавляем в строку выбранный Документ.
                            lsvZona.enabled = false;//Делаем не кликабельную Зону.
                        }
                        else {//Если не выбор элементов переименования, то ...
                            if(root.blUdalitVibor){//Если удалить, то...
                                fnUdalit(ntKod, strDannie);
                            }
                            else{//Если не выбор элемента на удаление, то открыть файл к просмотру...
                                cppqml.strDebug = "";
                                root.blPereimenovat = false;//Запрещаем переименование (отмена)...(ок)
                                root.blUdalitVibor = false;//Запрещено выбирать документ на удаление.
                                txuUdalit.visible = false;//Убираем запрос на удаление, если он есть.
                                txnZagolovok.visible = false;//Отключаем создание Элемента.
                                menuDannie.visible = false;//Делаем невидимым всплывающее меню.
                                cppqml.ullDannieKod = ntKod;//Присваиваем Код Документа к свойству Q_PROPERTY
                                cppqml.strDannie = strDannie;//Присваиваем имя Документа к свойству Q_PROPERTY
								//Открываем Pdf документ.
                                if(root.pdfViewer)//Если настройка настроена на собственный pdf просмотрщик,то
                                    root.clickedDannie(strDannie);//сигнал с кодом и именем Документа.
                                else//Если на сторонний просмотщик pdf документов, то...
                                    Qt.openUrlExternally(cppqml.strDannieUrl);//Открываем pdf в стороннем app.
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
				id: menuDannie
				visible: false//Невидимое меню. 
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: root.ntCoff
                pctFona: 0.95//Прозрачность фона меню.
                clrTexta: root.clrMenuText
                //clrTexta: root.clrTexta
                clrFona: "SlateGray"
				imyaMenu: "dannie"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
				onClicked: function(ntNomer, strMenu) {
					menuDannie.visible = false;//Делаем невидимым меню.
                    if(ntNomer === 1){//Добавить.
                        fnMenuSozdat();//Функция обработки пункта меню Добавить.
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
                    if(ntNomer === 5){//Выход
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
        root.focus = true;//Фокус на головном элементе, чтоб работал Escape.
    }
    onBlUdalitViborChanged: {//Слот сигнала изменения property blUdalitVibor(on...Changed)
        root.blUdalitVibor? rctBorder.border.color = "red" : rctBorder.border.color = "transparent";
        root.focus = true;//Фокус на головном элементе, чтоб работал Escape.
    }
    Item {//Данные Тулбар
		id: tmToolbar 
        DCKnopkaSozdat {
			id: knopkaSozdat
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
            clrKnopki: root.clrFaila//Цвет файлов
			clrFona: root.clrFona
            blKrug: false//Не круглая кнопка.
			visible: root.appRedaktor ? true : false//Настройка вкл/вык Редактор приложения.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                fnClickedSozdat();//Функция нажатия кнопки Создать.
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
                txnZagolovok.visible = false;//Отключаем режим ввода данных заголовка.
                menuDannie.visible ? menuDannie.visible = false : menuDannie.visible = true;
                root.blPereimenovat = false;//Запрещаем переименовывание (отмена)...(ок).
                root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
                root.blUdalitVibor = false;//Запрещено удалять.
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvZona.enabled = true;//Делаем кликабельную Зону.
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
		}
    }
}
