﻿import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/zones"//Импортируем зону файлового диалога.
//Страница с отображением каталога папок и файлов
Item {
    id: tmFileDialog
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
    anchors.fill: parent//Растянется по Родителю.
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedZakrit();//Сигнал нажатия кнопки Закрыть.
    signal clickedInfo();//Сигнал нажатич кнопки Инфо, где будет описание работы Файлового Диалога.
    signal clickedPut (var strPut);//Сигнал излучающий путь к файлу.

    function fnClickedZakrit(){
       tmFileDialog.clickedZakrit();//Излучаем сигнал закрытия проводника.
    }

    Item {//Данные Заголовок
        id: tmZagolovok
        DCKnopkaNazad {
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left:tmZagolovok.left
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            onClicked: {
                tmFileDialog.clickedNazad();
            }
        }
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            clrFona: tmFileDialog.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
    }
    Item {//Данные Зона
        id: tmZona
        Rectangle {
            id: rctZona
            anchors.fill: tmZona
            color: "transparent"
            border.width: tmElement.ntCoff/2//Бордюр при переименовании.
            clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
            DCLogoTMK {//Логотип до ZonaFileDialog, чтоб не перекрывать список.
                ntCoff: 16
                anchors.centerIn: parent
                clrLogo: tmFileDialog.clrTexta
                clrFona: tmFileDialog.clrFona
            }
            ZonaFileDialog {
                id: lsvZona
                ntWidth: tmFileDialog.ntWidth
                ntCoff: tmFileDialog.ntCoff
                anchors.fill: rctZona
                clrTexta: tmFileDialog.clrTexta
                clrFona: "SlateGray"
                onClicked: function(ntKod, strFileDialog) {//Слот нажатия на один из Элементов Проводника.
//					if(cppqml.blElementPervi){//Если это первый элемент, то...
//                        fnClickedSozdat();//Функция при нажатии кнопки Создать.
//					}
//					else{//Если не первый элемент, то...
//                        if(blPereimenovat) {//Если ПЕРЕИМНОВАТЬ, то...
//                            txnZagolovok.visible = true;//Включаем Переименование Элемента списка.
//                            cppqml.strElement = strElement;//Присваиваем Элемент списка к свойству Q_PROPERTY
//                            txnZagolovok.text = strElement;//Добавляем в строку выбранный Элемент списка.
//                        }
//                        else {//Если НЕ ПЕРЕИМЕНОВАТЬ, то СОХРАНИТЬ...
//                            blPereimenovat = false;//Запрещено переименовывать
//                            txnZagolovok.visible = false;//Отключаем создание Элемента.
//                            menuFileDialog.visible = false;//Делаем невидимым всплывающее меню.
//                            cppqml.ullElementKod = ntKod;//Присваиваем Код Элемента к свойству Q_PROPERTY
//                            cppqml.strElement = strElement;//Присваиваем элемент списка к свойству Q_PROPERTY
//                            tmElement.clickedElement(strElement);//Излучаем сигнал с именем Элемента.
//                        }
//					}
                }
            }
//			DCMenu {
//				id: menuFileDialog
//				visible: false//Невидимое меню.
//				ntWidth: tmFileDialog.ntWidth
//				ntCoff: tmFileDialog.ntCoff
//				anchors.left: rctZona.left
//				anchors.right: rctZona.right
//				anchors.bottom: rctZona.bottom
//				anchors.margins: tmFileDialog.ntCoff
//				clrTexta: tmFileDialog.clrTexta
//				clrFona: "SlateGray"
//				imyaMenu: "filedialog"//Глянь в MenuSpisok все варианты меню в слоте окончательной отрисовки.
//				onClicked: function(ntNomer, strMenu) {
//					menuFileDialog.visible = false;//Делаем невидимым меню.
//                    if(ntNomer === 1){//Добавить.
//                        fnMenuSozdat();//Функция нажат пункт меню Добавить.
//                    }
//                    if(ntNomer === 2){//Переименовать.
//                        fnMenuPereimenovat();//Функция нажатия пункта меню Переименовать.
//					}
//                    if(ntNomer === 5){//Выход
//						Qt.quit();//Закрыть приложение.
//					}
//				}
//			}
        }
    }
    Item {//Данные Тулбар
        id: tmToolbar
        DCKnopkaInfo {
            ntWidth: tmFileDialog.ntWidth
            ntCoff: tmFileDialog.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.right: tmToolbar.right
            anchors.margins: tmFileDialog.ntCoff/2
            clrKnopki: tmFileDialog.clrTexta
            clrFona: tmFileDialog.clrFona
            onClicked: {
                tmFileDialog.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
            }
        }
    }
}
