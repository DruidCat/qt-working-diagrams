import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
import "qrc:/qml/zones"//Импортируем зону списка.
//Страниц отображающая Список, первый, главный экран со Списком чего либо.
Item {
    id: root
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
    property bool blPereimenovatVibor: false//Выбрать элемент пеименования, если true
    property bool blPereimenovat: false//Запрос на переименование, если true
    property bool blUdalitVibor: false//Включить режим выбора удаляемого Списка, если true
    property bool blZagolovok: false//Переименовать Заголовок, если true
    anchors.fill: parent//Растянется по Родителю.
	signal clickedMenu();//Сигнал нажатия кнопки Меню. 
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedSpisok(var strSpisok);//Сигнал когда нажат один из элементов Списка.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    signal signalZagolovok(var strZagolovok);//Сигнал, когда передаём новую надпись в Заголовок.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuSpisok.visible = false;//Делаем невидимым всплывающее меню.
        root.blPereimenovat = false;//Запрещаем выбор переименовывания.
        root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        root.blUdalitVibor = false;//Запрещаем выбирать Список для удаления.
        txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
        root.blZagolovok = false;//Запрещаем изменять заголовок.
    }
    focus: true//Обязательно, иначе на Андроид экранная клавиатура не открывается.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        onClicked: {
            root.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
	function fnClickedOk(){//Функция сохранения/переименования элемента Списка.
        root.signalToolbar("");//Делаем пустую строку в Toolbar.
        if(blZagolovok){//Если изменить имя заголовка, то...
            cppqml.strTitul = txnZagolovok.text;//Переименовываем Заголовок Списка.
            root.signalZagolovok(txnZagolovok.text);//Отображаем Заголовок
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
    function fnMenuZagolovok(){//Нажат пункт меню Изменить Заголовок.
        blZagolovok = true;//Изменить заголовок.
        menuSpisok.visible = false;//Делаем невидимым меню.
        txnZagolovok.text = cppqml.strTitul;//Добавляем в строку Заголовок, для более понятного редактирования
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ЗАГОЛОВКА");//Подсказка пользователю,что вводить нужн
        txnZagolovok.visible = true;//Показ текстового редактора Заголовка ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
        root.signalToolbar(qsTr("Измените имя заголовка списка."));
    }
    Item {//Спискок Заголовка
        id: tmZagolovok
        DCKnopkaMenu {//@disable-check M300
            id: knopkaMenu
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
			onClicked: {//Если пришёл сигнал о нажатии кнопки меню, то...
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
				root.clickedMenu();//Сигнал Меню
            }
		}
        DCKnopkaZakrit {//@disable-check M300
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
		DCKnopkaInfo {//@disable-check M300
			id: knopkaInfo
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			visible: true
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
			onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
                root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
            }
		} 
        DCKnopkaOk{//@disable-check M300
            id: knopkaOk
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
			onClicked: {//Нажимаем Ок.
                fnClickedOk();//Нажимаем на Ок(Сохранить/Переименовать), чтоб не изменять в нескольких местах.
            }
		}
        DCTextUdalit {//@disable-check M300
            id: txuUdalit
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

            visible: false//Невидимый виджет

            clrFona: "orange"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"
            onClickedUdalit: function (strKod) {//Слот нажатия кнопки Удалить
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                if(cppqml.delStrSpisok(strKod))//Запускаю метод удаление Списка из БД, Элементов и  Документов
                    root.signalToolbar(qsTr("Успешное удаление списка."));
                else
                    cppqml.strDebug = qsTr("Ошибка при удалении.");
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
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
			
            DCTextInput {//@disable-check M300
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
                textInput.maximumLength: cppqml.untNastroikiMaxLength
                onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видим, то...
                        knopkaMenu.visible = false;//Кнопка Меню Невидимая.
                        knopkaInfo.visible = false;//Конопка Информация Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                    }
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
                        knopkaMenu.visible = true;//Кнопка Меню видимая.
                        knopkaInfo.visible = true;//Конопка Информация Видимая.
                        txnZagolovok.text = "";//Текст обнуляем вводимый.
                        knopkaInfo.focus = true;//Фокус на кнопке Информация, чтоб не работал Enter.
                    }
				}
				onClickedEnter: {//Если нажата Enter, то такое же действие, как и при нажатии кнопки Ок.
					fnClickedOk();//Нажимаем Ок(Сохранить/Переименовать), чтоб не менять в нескольких местах.
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
            DCLogoTMK {//@disable-check M300//Логотип до ZonaSpisok, чтоб не перекрывать список.
                id: lgTMK
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: root.clrTexta
                clrFona: root.clrFona
            }
            ZonaSpisok {//@disable-check M300
                id: lsvZona
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.fill: rctZona
				clrTexta: root.clrTexta
				clrFona: "SlateGray" 
                onClicked: function(ntKod, strSpisok) {//Слот clicked нажатия на один из элементов Списка.
                    if(cppqml.blSpisokPervi){//Если это первый в Списке, то...
                        fnClickedSozdat();//Функция обрабатывающая кнопку Создать.
                    }
                    else{//Если не первый элемент, то...
                        if(root.blPereimenovatVibor){//Если разрешён выбор элементов для переименовывания.
                            root.blPereimenovat = true;//Переименование (отмена)...(ок)
                            root.signalToolbar(qsTr("Переименуйте выбранный список."));
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            cppqml.strSpisok = strSpisok;//Присваиваем элемент списка к свойству Q_PROPERTY
                            txnZagolovok.text = strSpisok;//Добавляем в строку выбранный элемент Списка.
                            root.blPereimenovatVibor = false;//Запрещаем выбор элемента для переименования
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
			}	
            DCMenu {//@disable-check M300
                id: menuSpisok
				visible: false//Невидимое меню. 
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: root.ntCoff
				clrTexta: root.clrTexta
				clrFona: "SlateGray"
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
	}
    onBlUdalitViborChanged: {//Слот сигнала изменения property blUdalitVibor(on...Changed)
        root.blUdalitVibor? rctBorder.border.color = "red" : rctBorder.border.color = "transparent";
    }
	Item {//Список Тулбара
        id: tmToolbar	
		DCKnopkaSozdat {//@disable-check M300
            id: knopkaSozdat
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
				txnZagolovok.visible ? fnClickedZakrit() : fnClickedSozdat()
            }
		}
        DCKnopkaNastroiki {//@disable-check M300
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            onClicked: {
                //txnZagolovok.textInput.forceActiveFocus();//ОБЯЗАТЕЛЬНАЯ СТРОКА, чтоб работало нажатие Escape.
                txnZagolovok.visible = false;//Отключаем создание Элемента списка.
                menuSpisok.visible ? menuSpisok.visible = false : menuSpisok.visible = true;
                root.blPereimenovat = false;//Запрещаем переименовывание (отмена)...(ок).
                root.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
                root.blUdalitVibor = false;//Запрещено удалять.
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
		}
    }
}
