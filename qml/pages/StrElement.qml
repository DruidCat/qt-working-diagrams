import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
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
	property alias radiusZona: rctBorder.radius//Радиус Зоны рабочей
    property bool blPereimenovatVibor: false//Выбрать элемент для переименования, если true
    property bool blPereimenovat: false//Запрос на переименование, если true
    property bool blUdalitVibor: false//Включить режим выбора удаляемого Элемента, если true
    anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
	signal clickedInfo();//Сигнал нажатия кнопки Информация
	signal clickedElement(var strElement);//Сигнал когда нажат один из Элементов.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuElement.visible = false;//Делаем невидимым всплывающее меню.
        tmElement.blPereimenovat = false;//Запрещаем выбор переименовывания.
        tmElement.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        tmElement.blUdalitVibor = false;//Запрещаем выбирать Элемент для удаления.
        txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
    }
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
    function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
        tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedOk(){//Функция сохранения/переименования Элементов списка.
        tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
        if(tmElement.blPereimenovat)//Если запрос на переименовывание.
            cppqml.renStrElementDB(cppqml.strElement, txnZagolovok.text);//Переименовываем Элемент списка.
        else{//Если НЕ ПЕРЕИМЕНОВАТЬ, то Сохранить.
            cppqml.strElementDB = txnZagolovok.text;//Сохранить название Элемента списка, и только потом..
        }
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnUdalit(strKod, strImya){//Функция запуска Запроса на Удаление выбранного документа.
        tmElement.blUdalitVibor = false;//Запрещено выбирать элементы на удаление.
        txuUdalit.blVisible = true;//Делаем видимый запрос на удаление.
        txuUdalit.kod = strKod;//Код на удаление
        txuUdalit.text = strImya;//Имя на удаление
        tmElement.signalToolbar(qsTr("Удалить данный элемент?"));//Делаем предупреждение в Toolbar.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
        tmElement.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
        tmElement.blUdalitVibor = false;//Запрещено выбирать элементы на удаление.
        menuElement.visible = false;//Делаем невидимым меню.
        txnZagolovok.visible = true;//Режим создания элемента Списка.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ЭЛЕМЕНТА");//Подсказка пользователю,что вводить нужно
        tmElement.signalToolbar(qsTr("Создайте новый элемент."));
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        tmElement.blPereimenovatVibor = true;//Разрешаем выбор элементов для переименовывания.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ИМЯ ЭЛЕМЕНТА");//Подсказка пользователю,что вводить нужно
        tmElement.signalToolbar(qsTr("Выберите элемент для его переименования."));
    }
    function fnMenuUdalit(){//Нажат пункт меню Удалить.
        tmElement.blUdalitVibor = true;//Включаем режим выбора удаляемого Элемента
        tmElement.signalToolbar(qsTr("Выберите элемент для его удаления."))
    }

	Item {//Элементы Заголовок
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
			id: knopkaNazad
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.left: tmZagolovok.left
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
				tmElement.clickedNazad();//Сигнал Назад.
			}
		}
        DCKnopkaZakrit {//@disable-check M300
            id: knopkaZakrit
            ntWidth: tmElement.ntWidth
            ntCoff: tmElement.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            anchors.margins: tmElement.ntCoff/2
            clrKnopki: tmElement.clrTexta
            clrFona: tmElement.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
        DCKnopkaSozdat {//@disable-check M300
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
        DCKnopkaOk{//@disable-check M300
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
        DCTextUdalit {//@disable-check M300
            id: txuUdalit
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            anchors.topMargin: tmElement.ntCoff/4
            anchors.bottomMargin: tmElement.ntCoff/4
            anchors.leftMargin: tmElement.ntCoff/2
            anchors.rightMargin: tmElement.ntCoff/2

            ntWidth: tmElement.ntWidth
            ntCoff: tmElement.ntCoff

            clrFona: "orange"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "black"
            clrKnopki: "black"
            clrBorder: "black"
            onClickedUdalit: function (strKod) {//Слот нажатия кнопки Удалить
                txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
                if(cppqml.delStrElement(strKod))//Запускаю метод удаление Элемента из БД и их Документов.
                    tmElement.signalToolbar(qsTr("Успешное удаление элемента."));
                else
                    cppqml.strDebug = qsTr("Ошибка при удалении.");
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                txuUdalit.blVisible = false;//Делаем невидимый запрос на удаление.
                tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
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
            DCTextInput {//@disable-check M300
				id: txnZagolovok
				ntWidth: tmElement.ntWidth
				ntCoff: tmElement.ntCoff
				anchors.fill: tmTextInput
				visible: false
                textInput.readOnly: true;//Запрещено редактировать.
                clrTexta: tmElement.clrTexta
				clrFona: "SlateGray"
				radius: tmElement.ntCoff/2
				textInput.font.capitalization: Font.AllUppercase//Отображает текст весь с заглавных букв.
                textInput.maximumLength: cppqml.untNastroikiMaxLength
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
						textInput.readOnly = false;//Можно редактировать.
                        knopkaNazad.visible = false;//Кнопка назад Невидимая.
                        knopkaSozdat.visible = false;//Конопка Создать Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
                        textInput.cursorVisible = true;//Делаем курсор видимым обязательно.
                        textInput.forceActiveFocus();//Напрямую форсируем фокус, по другому не работает.
					}
                    else{//Если DCTextInput не видим, то...
						textInput.readOnly = true;//Запрещено редактировать.
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
	Item {//Список Рабочей Зоны
		id: tmZona
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCLogoTMK {//@disable-check M300 Логотип
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: tmElement.clrTexta
                clrFona: tmElement.clrFona
            }
            ZonaElement {//@disable-check M300
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
                        if(blPereimenovatVibor) {//Если разрешён выбор элементов для переименовывания, то...
                            tmElement.blPereimenovat = true;//Переименование (отмена)...(ок)
                            tmElement.signalToolbar(qsTr("Переименуйте выбранный элемент."));
                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
                            cppqml.strElement = strElement;//Присваиваем Элемент списка к свойству Q_PROPERTY
                            txnZagolovok.text = strElement;//Добавляем в строку выбранный Элемент списка.
                            tmElement.blPereimenovatVibor = false;//Запрещаем выбор элемента для переименовани
                        }
                        else {//Если не выбор элементов переименования, то ...
                            if(tmElement.blUdalitVibor){//Если удалить, то...
                                fnUdalit(ntKod, strElement);//Функция удаления
                            }
                            else {//Если не режим выбора элементов Переименования, то перейти к Данным...
                                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                                tmElement.blPereimenovat = false;//Запрещаем переименование (отмена)...(ок)
                                tmElement.blUdalitVibor = false;//Запрещено выбирать Элементы на удаление.
                                txuUdalit.blVisible = false;//Убираем запрос на удаление, если он есть.
                                txnZagolovok.visible = false;//Отключаем создание Элемента.
                                menuElement.visible = false;//Делаем невидимым всплывающее меню.
                                cppqml.ullElementKod = ntKod;//Присваиваем Код Элемента к свойству Q_PROPERTY
                                cppqml.strElement = strElement;//Присваиваем элемент списка к свойству Q_PROPE
                                tmElement.clickedElement(strElement);//Излучаем сигнал с именем Элемента.
                            }
                        }
					}
				}
			}	
            DCMenu {//@disable-check M300
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
				border.width: tmElement.ntCoff/2//Бордюр при переименовании и удалении.
			}
		}
	}
	onBlPereimenovatViborChanged: {//Слот сигнала изменения property blPereimenovatVibor (on...Changed)
        tmElement.blPereimenovatVibor ? rctBorder.border.color=clrTexta:rctBorder.border.color="transparent";
    }
    onBlUdalitViborChanged: {//Слот сигнала изменения property blUdalitVibor(on...Changed)
        tmElement.blUdalitVibor? rctBorder.border.color = "red" : rctBorder.border.color = "transparent";
    }
	Item {//Состава Тулбар
		id: tmToolbar
        DCKnopkaInfo {//@disable-check M300
			ntWidth: tmElement.ntWidth
			ntCoff: tmElement.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			anchors.margins: tmElement.ntCoff/2
			clrKnopki: tmElement.clrTexta
			onClicked: {//Слот клика кнопки Инфо
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
                fnClickedEscape();//Функция нажатия кнопки Escape.
				tmElement.clickedInfo();//Излучаем сигнал, что кнопка в блоке кода нажата.
			}
		}
        DCKnopkaNastroiki {//@disable-check M300
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
                tmElement.blPereimenovat = false;//Запрещаем переименовывание (отмена)...(ок).
                tmElement.blPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
                tmElement.blUdalitVibor = false;//Запрещено выбирать Элементы на удаление.
                txuUdalit.blVisible = false;//Убираем запрос на удаление, если он есть.
                tmElement.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
		}
	}
}
