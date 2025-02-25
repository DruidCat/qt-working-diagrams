import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной. 
import "qrc:/qml/zones"//Импортируем зону Данных.
//Страница с Данными, где отображаются сами документы в виде списка.
Item {
    id: tmDannie
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
	property color clrFona: "black"
    property color clrFaila: "yellow"
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
    property bool blPereimenovatVibor: false//Выбрать элемент для переименования, если true
    property bool blPereimenovat: false//Запрос на переименование, если true
    property bool blUdalitVibor: false//Включить режим выбора удаляемого документа, если true
    anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedDannie(var strDannie);//Сигнал когда нажат один из элементов Данных.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    signal signalZagolovok (var strZagolovok);//Сигнал излучающий имя каталога в Проводнике.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuDannie.visible = false;//Делаем невидимым всплывающее меню.
        tmDannie.blPereimenovat = false;//Запрещаем выбор переименовывания.
        tmDannie.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        tmDannie.blUdalitVibor = false;//Запрещаем выбирать документ для удаления.
        txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
    }
    focus: true//Не удалять, может Escape не работать.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmDannie
        onClicked: {
            tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedOk(){//Функция переименования Данных.
        tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
        if(tmDannie.blPereimenovat)//Если запрос на переименовывание.
            cppqml.renStrDannieDB(cppqml.strDannie, txnZagolovok.text);//Переименовываем имя Документа.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnUdalit(strKod, strImya){//Функция запуска Запроса на Удаление выбранного документа.
        tmDannie.blUdalitVibor = false;//Запрещено выбирать элементы на удаление.
        txuUdalit.blVisible = true;//Делаем видимый запрос на удаление.
        txuUdalit.kod = strKod;//Код на удаление
        txuUdalit.text = strImya;//Имя на удаление
        tmDannie.signalToolbar(qsTr("Удалить данный документ?"));//Делаем предупреждение в Toolbar.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
        tmDannie.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        tmDannie.blUdalitVibor = false;//Запрещено выбирать документ на удаление. НЕ УДАЛЯТЬ.
        menuDannie.visible = false;//Делаем невидимым меню.
        tmDannie.clickedSozdat();//Излучаем сигнал, что нужно запустить Файловый Диалог.
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        tmDannie.blPereimenovatVibor = true;//Разрешаем выбор элементов для переименовывания.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ДОКУМЕНТА");//Подсказка пользователю,что вводить нужн
        tmDannie.signalToolbar(qsTr("Выберите документ для его переименования."))
    }
    function fnMenuUdalit(){//Нажат пункт меню Удалить.
        tmDannie.blUdalitVibor = true;//Включаем режим выбора удаляемого файла
        tmDannie.signalToolbar(qsTr("Выберите документ для его удаления."))
    }

    Item {//Данные Заголовок
		id: tmZagolovok

        DCKnopkaNazad {
			id: knopkaNazad
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
            onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
                tmDannie.clickedNazad();
            }
        } 
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
            clrFona: tmDannie.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
        DCKnopkaSozdat {
			id: knopkaSozdat
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
			clrFona: tmDannie.clrFona
            onClicked: {
                fnClickedSozdat();//Функция нажатия кнопки Создать.
            }
        }
        DCKnopkaOk{
            id: knopkaOk
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
            clrFona: tmDannie.clrFona
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

            anchors.topMargin: tmDannie.ntCoff/4
            anchors.bottomMargin: tmDannie.ntCoff/4
            anchors.leftMargin: tmDannie.ntCoff/2
            anchors.rightMargin: tmDannie.ntCoff/2

            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff

            clrFona: "orange"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"
            onClickedUdalit: function (strKod) {//Слот нажатия кнопки Удалить
                txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
                if(cppqml.delStrDannie(strKod))//Запускаю метод удаление записи из БД и самого Документа.
                    tmDannie.signalToolbar(qsTr("Успешное удаление документа"));
                else
                    cppqml.strDebug = qsTr("Ошибка при удалении.");
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
                tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
        }
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaNazad.right
			anchors.right: knopkaSozdat.left
			anchors.topMargin: tmDannie.ntCoff/4
			anchors.bottomMargin: tmDannie.ntCoff/4
			anchors.leftMargin: tmDannie.ntCoff/2
			anchors.rightMargin: tmDannie.ntCoff/2
			DCTextInput {
				id: txnZagolovok
				ntWidth: tmDannie.ntWidth
				ntCoff: tmDannie.ntCoff
				anchors.fill: tmTextInput
				visible: false
				clrTexta: tmDannie.clrTexta
				clrFona: "SlateGray"
				radius: tmDannie.ntCoff/2
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                textInput.maximumLength: cppqml.untNastroikiMaxLength
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
                        knopkaNazad.visible = false;//Кнопка назад Невидимая.
                        knopkaSozdat.visible = false;//Конопка Создать Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                        textInput.cursorVisible = true;//Делаем курсор видимым обязательно.
                        textInput.forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
					}
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
                        knopkaNazad.visible = true;//Кнопка назад видимая.
                        knopkaSozdat.visible = true;//Конопка Создать Видимая.
                        txnZagolovok.text = "";//Текст обнуляем вводимый.
                        knopkaSozdat.focus = true;//Фокус на кнопке Создать, чтоб не работал Enter.
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
            DCLogoTMK {//Логотип до ZonaDannie, чтоб не перекрывать Документы.
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: tmElement.clrTexta
                clrFona: tmElement.clrFona
            }
			ZonaDannie {
				id: lsvZona
				ntWidth: tmDannie.ntWidth
				ntCoff: tmDannie.ntCoff
				anchors.fill: rctZona
                clrTexta: tmDannie.clrFaila//Цвет файлов
				clrFona: "SlateGray"
                onClicked: function(ntKod, strDannie) {//Слот нажатия на один из Документов списка.
					if(cppqml.blDanniePervi){//Если это первый Документ, то...
                        fnClickedSozdat();//Функция при нажатии кнопки Создать(Проводник).
					}
					else{//Если не первый элемент, то...
                        if(tmDannie.blPereimenovatVibor) {//Если разрешён выбор элементов для переименовывания
                            tmDannie.blPereimenovat = true;//Переименование (отмена)...(ок)
                            tmDannie.signalToolbar(qsTr("Переименуйте выбранный документ."));
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            cppqml.strDannie = strDannie;//Присваиваем Документ к свойству Q_PROPERTY
                            txnZagolovok.text = strDannie;//Добавляем в строку выбранный Документ.
                            tmDannie.blPereimenovatVibor = false;//Запрещаем выбор элемента для переименования
                        }
                        else {//Если не выбор элементов переименования, то ...
                            if(tmDannie.blUdalitVibor){//Если удалить, то...
                                fnUdalit(ntKod, strDannie);
                            }
                            else{//Если не выбор элемента на удаление, то открыть файл к просмотру...
                                cppqml.strDebug = "";
                                tmDannie.blPereimenovat = false;//Запрещаем переименование (отмена)...(ок)
                                tmDannie.blUdalitVibor = false;//Запрещено выбирать документ на удаление.
                                txuUdalit.blVisible = false;//Убираем запрос на удаление, если он есть.
                                txnZagolovok.visible = false;//Отключаем создание Элемента.
                                menuDannie.visible = false;//Делаем невидимым всплывающее меню.
                                cppqml.ullDannieKod = ntKod;//Присваиваем Код Документа к свойству Q_PROPERTY
                                cppqml.strDannie = strDannie;//Присваиваем имя Документа к свойству Q_PROPERTY
								//Открываем Pdf документ.
                                tmDannie.clickedDannie(strDannie);//сигнал с кодом и именем Документа.
                            }
                        }
					}
				}
			}
			DCMenu {
				id: menuDannie
				visible: false//Невидимое меню. 
				ntWidth: tmDannie.ntWidth
				ntCoff: tmDannie.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: tmDannie.ntCoff
				clrTexta: tmDannie.clrTexta
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
                    if(ntNomer === 5){//Выход
						Qt.quit();//Закрыть приложение.
					}
				}
			}
			Rectangle{//Это Рамка поверх логотипа и списков для переименования и удаления.
				id: rctBorder
				anchors.fill: rctZona
				color: "transparent"
				border.width: tmDannie.ntCoff/2//Бордюр при переименовании и удалении.
			}
		}
    }
	onBlPereimenovatViborChanged: {//Слот сигнала изменения property blPereimenovatVibor (on...Changed)
        tmDannie.blPereimenovatVibor ? rctBorder.border.color=clrTexta : rctBorder.border.color="transparent";
	}
    onBlUdalitViborChanged: {//Слот сигнала изменения property blUdalitVibor(on...Changed)
        tmDannie.blUdalitVibor? rctBorder.border.color = "red" : rctBorder.border.color = "transparent";
    }
    Item {//Данные Тулбар
		id: tmToolbar
        DCKnopkaInfo {
            ntWidth: tmDannie.ntWidth
            ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
            anchors.margins: tmDannie.ntCoff/2
            clrKnopki: tmDannie.clrTexta
			clrFona: tmDannie.clrFona
            onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
                tmDannie.clickedInfo();
            }
        }
		DCKnopkaNastroiki {
			ntWidth: tmDannie.ntWidth
			ntCoff: tmDannie.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: tmDannie.ntCoff/2
			clrKnopki: tmDannie.clrTexta
			clrFona: tmDannie.clrFona
			onClicked: {
                txnZagolovok.visible = false;//Отключаем режим ввода данных заголовка.
                menuDannie.visible ? menuDannie.visible = false : menuDannie.visible = true;
                tmDannie.blPereimenovat = false;//Запрещаем переименовывание (отмена)...(ок).
                tmDannie.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
                tmDannie.blUdalitVibor = false;//Запрещено удалять.
                txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
                tmDannie.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
		}
    }
}
