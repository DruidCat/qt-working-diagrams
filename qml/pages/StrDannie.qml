import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/zones"//Импортируем зону Данных.
//Страница с Данными, где отображаются сами документы в виде списка.
Item {
    id: tmDannie
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
    property bool blPereimenovat: false//Переименовать, если true
    anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedDannie(var strDannie);//Сигнал когда нажат один из элементов Данных.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuDannie.visible = false;//Делаем невидимым всплывающее меню.
        tmDannie.blPereimenovat = false;//Запрещаем переименовывать.
    }
    focus: true//Не удалять, может Escape не работать.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmDannie
        onClicked: {
            cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    function fnClickedOk(){//Функция переименования Данных.
        cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
        if(blPereimenovat){//Если Переименовываем, то...
            cppqml.renStrDannieDB(cppqml.strDannie, txnZagolovok.text);//Переименовываем имя Документа.
        }
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
        blPereimenovat = false;//Запрещено переименовывать. НЕ УДАЛЯТЬ.
        menuDannie.visible = false;//Делаем невидимым меню.
        tmDannie.clickedSozdat();//Излучаем сигнал, что нужно запустить Файловый Диалог.
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        blPereimenovat = true;
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ДОКУМЕНТА");//Подсказка пользователю,что вводить нужн
        tmDannie.signalToolbar(qsTr("Выберите документ для его переименования."))
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
				textInput.maximumLength: 33
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
                        knopkaSozdat.visible = false;//Конопка Создать Невидимая.
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                        textInput.cursorVisible = true;//Делаем курсор видимым обязательно.
                        textInput.forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
					}
                    else{//Если DCTextInput не видим, то...
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
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
	onBlPereimenovatChanged: {//Слот сигнала изменения property blPereimenovat (on...Changed)
        tmDannie.blPereimenovat ? rctZona.border.color = clrTexta : rctZona.border.color = "transparent";
	}
    Item {//Данные Зона
		id: tmZona
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			border.width: tmDannie.ntCoff/2//Бордюр при переименовании.
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
				clrTexta: tmDannie.clrTexta
				clrFona: "SlateGray"
                onClicked: function(ntKod, strDannie) {//Слот нажатия на один из Документов списка.
					if(cppqml.blDanniePervi){//Если это первый Документ, то...
                        fnClickedSozdat();//Функция при нажатии кнопки Создать(Проводник).
					}
					else{//Если не первый элемент, то...
                        if(blPereimenovat) {//Если ПЕРЕИМНОВАТЬ, то...
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            cppqml.strDannie = strDannie;//Присваиваем Документ к свойству Q_PROPERTY
                            txnZagolovok.text = strDannie;//Добавляем в строку выбранный Документ.
                        }
                        else {//Если НЕ ПЕРЕИМЕНОВАТЬ, ТО ОТКРЫТЬ ФАЙЛ К ПРОСМОТРУ...
                            blPereimenovat = false;//Запрещено переименовывать
                            txnZagolovok.visible = false;//Отключаем создание Элемента.
                            menuDannie.visible = false;//Делаем невидимым всплывающее меню.
                            cppqml.ullDannieKod = ntKod;//Присваиваем Код Документа к свойству Q_PROPERTY
                            cppqml.strDannie = strDannie;//Присваиваем имя Документа к свойству Q_PROPERTY
                            tmDannie.clickedDannie(strDannie);//Излучаем сигнал с именем Документа.
                            //TODO Открыть файл к просмотру.
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
                    if(ntNomer === 5){//Выход
						Qt.quit();//Закрыть приложение.
					}
				}
			}
		}
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
                blPereimenovat = false;//Запрещено переименовывать.
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
            }
		}
    }
}
