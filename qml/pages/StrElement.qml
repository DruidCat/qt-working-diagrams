import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/zones"//Импортируем зону элементов.
//Страница отображающая Элементы Списка.
Item {
	id: tmElement
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
	signal clickedElement(var strElement);//Сигнал когда нажат один из Элементов.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuElement.visible = false;//Делаем невидимым всплывающее меню.
        tmElement.blPereimenovat = false;//Запрещаем переименовывать.
    }
    //onClickedEscape: {}
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
            tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: tmElement
        onClicked: {
            tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
            fnClickedEscape();//Функция нажатия кнопки Escape.
        }
    }
    function fnClickedOk(){//Функция сохранения/переименования Элементов списка.
        tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
        if(blPereimenovat){//Если Переименовываем, то...
            cppqml.renStrElementDB(cppqml.strElement, txnZagolovok.text);//Переименовываем Элемент списка.
        }
        else{//Если НЕ ПЕРЕИМЕНОВАТЬ, то Сохранить.
            cppqml.strElementDB = txnZagolovok.text;//Сохранить название Элемента списка, и только потом..
        }
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        blPereimenovat = false;//Запрещено переименовывать. НЕ УДАЛЯТЬ.
        menuElement.visible = false;//Делаем невидимым меню.
        txnZagolovok.visible = true;//Режим создания элемента Списка.
        tmElement.signalToolbar("Создайте новый элемент.")
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        blPereimenovat = true;
        tmElement.signalToolbar("Выберите элемент для его переименования.")
    }

	Item {//Элементы Заголовок
		id: tmZagolovok
		DCKnopkaNazad {
			id: knopkaNazad
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.left: tmZagolovok.left
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {
                tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
				tmElement.clickedNazad();//Сигнал Назад.
			}
		}
		DCKnopkaSozdat {
			id: knopkaSozdat
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.right: tmZagolovok.right
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedSozdat();//Функция при нажатии кнопки Создать.
            }
		}
		DCKnopkaOk{
			id: knopkaOk
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
			onClicked: {
				fnClickedOk();//Функция сохранения данных.
			}
		}
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaNazad.right
			anchors.right: knopkaSozdat.left
			anchors.topMargin: tmElement.ntCoff/4
			anchors.bottomMargin: tmElement.ntCoff/4
			anchors.leftMargin: tmElement.ntCoff/2
			anchors.rightMargin: tmElement.ntCoff/2
			DCTextInput {
				id: txnZagolovok
				ntWidth: tmElement.ntWidth
				ntCoff: tmElement.ntCoff
				anchors.fill: tmTextInput
				visible: false
				clrTexta: tmElement.clrTexta
				clrFona: "SlateGray"
				radius: tmElement.ntCoff/2
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
        tmElement.blPereimenovat ? rctZona.border.color = clrTexta : rctZona.border.color = "transparent";
    }
	Item {//Список Рабочей Зоны
		id: tmZona
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			border.width: tmElement.ntCoff/2//Бордюр при переименовании.
			clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCLogoTMK {//Логотип до ZonaElement, чтоб не перекрывать список.
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: tmElement.clrTexta
                clrFona: tmElement.clrFona
            }
			ZonaElement {
				id: lsvZona
				ntWidth: tmElement.ntWidth
				ntCoff: tmElement.ntCoff
				anchors.fill: rctZona
				clrTexta: tmElement.clrTexta
				clrFona: "SlateGray"
                onClicked: function(ntKod, strElement) {//Слот нажатия на один из Элементов списка.
					if(cppqml.blElementPervi){//Если это первый элемент, то...
                        fnClickedSozdat();//Функция при нажатии кнопки Создать.
					}
					else{//Если не первый элемент, то...
                        if(blPereimenovat) {//Если ПЕРЕИМНОВАТЬ, то...
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            cppqml.strElement = strElement;//Присваиваем Элемент списка к свойству Q_PROPERTY
                            txnZagolovok.text = strElement;//Добавляем в строку выбранный Элемент списка.
                        }
                        else {//Если НЕ ПЕРЕИМЕНОВАТЬ, то СОХРАНИТЬ...
                            blPereimenovat = false;//Запрещено переименовывать
                            txnZagolovok.visible = false;//Отключаем создание Элемента.
                            menuElement.visible = false;//Делаем невидимым всплывающее меню.
                            cppqml.ullElementKod = ntKod;//Присваиваем Код Элемента к свойству Q_PROPERTY
                            cppqml.strElement = strElement;//Присваиваем элемент списка к свойству Q_PROPERTY
                            tmElement.clickedElement(strElement);//Излучаем сигнал с именем Элемента.
                        }
					}
				}
			}	
			DCMenu {
				id: menuElement
				visible: false//Невидимое меню. 
				ntWidth: tmElement.ntWidth
				ntCoff: tmElement.ntCoff
				anchors.left: rctZona.left
				anchors.right: rctZona.right
				anchors.bottom: rctZona.bottom
				anchors.margins: tmElement.ntCoff
				clrTexta: tmElement.clrTexta
				clrFona: "SlateGray"
				imyaMenu: "element"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
				onClicked: function(ntNomer, strMenu) {
					menuElement.visible = false;//Делаем невидимым меню.
                    if(ntNomer === 1){//Добавить.
                        fnMenuSozdat();//Функция нажат пункт меню Добавить.
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
	Item {//Состава Тулбар
		id: tmToolbar
		DCKnopkaInfo {
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {//Слот клика кнопки Инфо
                tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
				tmElement.clickedInfo();//Излучаем сигнал, что кнопка в блоке кода нажата.
			}
		}
		DCKnopkaNastroiki {
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			clrFona: tmElement.clrFona
			onClicked: {
                txnZagolovok.visible = false;//Отключаем создание Элемента списка.
                menuElement.visible ? menuElement.visible = false : menuElement.visible = true;
                blPereimenovat = false;//Запрещено переименовывать.
                tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
		}
	}
}
