import QtQuick 2.14
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
    property string strPutDom: ""//Иннициализируется в Component.onComplite домашней дерикторией.
    anchors.fill: parent//Растянется по Родителю.
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedZakrit();//Сигнал нажатия кнопки Закрыть.
    signal clickedInfo();//Сигнал нажатич кнопки Инфо, где будет описание работы Файлового Диалога.
    signal clickedPut (var strPut);//Сигнал излучающий путь к файлу.
    signal signalZagolovok (var strZagolovok);//Сигнал излучающий имя каталога в Проводнике.

    function fnClickedNazad(){//Функция нажатия кнопки Назад или клика папки [..]
        if(cppqml.strFileDialogPut === tmFileDialog.strPutDom){//Если каталог совпадает с домашним, то...
           fnClickedZakrit();//Закрываем проводник.
        }
        else{//Противном случае...
            cppqml.strFileDialog = "[..]";//Назад в папке.
            tmFileDialog.signalZagolovok(cppqml.strFileDialogPut);//Передаю имя папки назад [..].
        }
    }

    function fnClickedZakrit(){
        cppqml.strFileDialogPut = "dom";//Закрываем проводник и назначаем домашнюю деррикторию.
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
                fnClickedNazad();//Функция клика Назад.
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
                onClicked: function(ntTip, strFileDialog) {//Слот нажатия на один из Элементов Проводника.
                    if(!ntTip){//Если Тип = 0, это нажатие кнопки Назад
                        fnClickedNazad();//Функция клика назад.
                    }
                    else{
                        if(ntTip === 1){//Если это Папки, то...
                            cppqml.strFileDialog = strFileDialog;//Присваиваем имя папки выбранной.
                            tmFileDialog.signalZagolovok(cppqml.strFileDialogPut);//Передаю имя папки.`
                        }
                        else{//Если это file.pdf, то...

                        }
                    }
                }
            }
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
    Component.onCompleted: {//Вызывается при завершении иннициализации компонента.
        tmFileDialog.strPutDom = cppqml.strFileDialogPut;//Запоминаем домашнюю деррикторию.
    }
}
