import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
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
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.

    function fnClickedEscape(){//Функция нажатия кнопки Escape.
        //txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
        menuDannie.visible = false;//Делаем невидимым всплывающее меню.
        tmDannie.blPereimenovat = false;//Запрещаем переименовывать.
    }
    focus: true//Не удалять, может Escape не работать.
    //onClickedEscape: {}
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
//        if(blPereimenovat){//Если Переименовываем, то...
//            cppqml.renStrElementDB(cppqml.strElement, txnZagolovok.text);//Переименовываем Элемент списка.
//        }
//        else{//Если НЕ ПЕРЕИМЕНОВАТЬ, то Сохранить.
//            cppqml.strElementDB = txnZagolovok.text;//Сохранить название Элемента списка, и только потом..
//        }
        fnClickedEscape();//Функция нажатия кнопки Escape.
    }
    function fnClickedSozdat(){//Функция при нажатии кнопки Создать.
        blPereimenovat = false;//Запрещено переименовывать. НЕ УДАЛЯТЬ.
        menuDannie.visible = false;//Делаем невидимым меню.
        //txnZagolovok.visible = true;//Режим создания элемента Списка.
        //tmDannie.signalToolbar("Добавьте ваш документ.")
        tmDannie.clickedSozdat();//Излучаем сигнал, что нужно запустить Файловый Диалог.
    }
    function fnMenuSozdat(){//Нажат пункт меню Добавить.
        fnClickedSozdat();//Функция обработки кнопки Создать.
    }
    function fnMenuPereimenovat(){//Нажат пункт меню Переименовать.
        blPereimenovat = true;
        tmDannie.signalToolbar("Выберите документ для его переименования.")
    }

    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
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
    }
    Item {//Данные Зона
		id: tmZona
		Rectangle {
			id: rctZona
			anchors.fill: tmZona
			color: "transparent"
			border.width: tmDannie.ntCoff/2//Бордюр при переименовании.
			clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCLogoTMK {//Логотип до ZonaDannie, чтоб не перекрывать список.
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: tmElement.clrTexta
                clrFona: tmElement.clrFona
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
                //txnZagolovok.visible = false;//Отключаем создание Элемента списка.
                menuDannie.visible ? menuDannie.visible = false : menuDannie.visible = true;
                blPereimenovat = false;//Запрещено переименовывать.
                cppqml.strDebug = "";//Делаем пустую строку в Toolbar.
            }
		}
    }
}
