import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
//Страница отображающая Описание чего либо.
Item {
	id: tmOpisanie
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
	property alias radiusZona: txdZona.radius
	property alias textTextEdit: txdZona.text
	property string strOpisanie: "titul"
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
    function fnClickedOk(){
		knopkaOk.visible = false;//Делаем невидимой кнопку Ок.
		knopkaSozdat.visible = true;//Делаем видимой кнопку Создать.
		txdZona.readOnly = true;//Запрещаем редактировать текст.
		if(strOpisanie == "titul"){//Если Титул, то...
			cppqml.strTitulOpisanie = txdZona.text;//Отправляем текст в бизнес логику.
		}
		else{
			if(strOpisanie == "spisok"){//Если Список, то...
				cppqml.strSpisokOpisanie = txdZona.text;//Отправляем текст в бизнес логику.
			}
			else{
				if(strOpisanie == "element"){//Если Элемент, то...
					cppqml.strElementOpisanie = txdZona.text;//Отправляем текст в бизнес логику.
                }
			}
		}
	}
	Item {
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmOpisanie.ntCoff/2
			clrKnopki: tmOpisanie.clrTexta
			onClicked: {
                //fnClickedOk();//Нажатие кнопки Ок. Если строку расскоментировать, сохранение будет текста.
                knopkaOk.visible = false;//Делаем невидимой кнопку Ок.
                knopkaSozdat.visible = true;//Делаем видимой кнопку Создать.
                txdZona.readOnly = true;//Запрещаем редактировать текст.
				tmOpisanie.clickedNazad();//Сигнал, что кнопка Назад нажата.
			}
		}
        DCKnopkaSozdat {//@disable-check M300
			id: knopkaSozdat
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmOpisanie.ntCoff/2
			visible: true 
			clrKnopki: tmOpisanie.clrTexta
			clrFona: tmOpisanie.clrFona
			onClicked: {
				txdZona.readOnly = false;//Разрешить редактировать.
				txdZona.textEdit.cursorPosition = txdZona.text.length;//Курсор в конец текста
				txdZona.textEdit.focus = true;//Сфокусироваться на области ввода
				txdZona.textEdit.cursorVisible = true;//Курсор сделать видимым
				visible = false//Делаем невидимой кнопку Создать.
				knopkaOk.visible = true;//Делаем видимой кнопку Ок
				tmOpisanie.clickedSozdat();//Излучаем сигнал Создать
			}
		}
        DCKnopkaOk {//@disable-check M300
			id: knopkaOk
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmOpisanie.ntCoff/2
			visible: false 
			clrKnopki: tmOpisanie.clrTexta
			clrFona: tmOpisanie.clrFona
			onClicked: {
				fnClickedOk();//Нажата кнопка Ок.
			}
		}
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCTextEdit {//@disable-check M300//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			readOnly: true//Запрещено редактировать текст
            textEdit.selectByMouse: false//Запрещаем выделять текст, то нужно для свайпа Android
            radius: tmOpisanie.ntCoff/4//Радиус возьмём из настроек элемента qml через property
			clrFona: tmOpisanie.clrFona//Цвет фона рабочей области
			clrTexta: tmOpisanie.clrTexta//Цвет текста
			clrBorder: tmOpisanie.clrTexta//Цвет бардюра при редактировании текста.
			italic: true//Текст курсивом.
		}
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrTitulOpisanieChanged(){//Слот, изменилось Описание в strTitulOpisanie(Q_PROPERTY)
                txdZona.text = cppqml.strTitulOpisanie;//Отображаем проверенное описание через sql_encode()
            }
        }
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrSpisokOpisanieChanged(){//Слот, изменилось Описание в strSpisokOpisanie(Q_PROPERTY)
                txdZona.text = cppqml.strSpisokOpisanie;//Отображаем проверенное описание через sql_encode()
            }
        }
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrElementOpisanieChanged(){//Слот,изменилось Описание в strElementOpisanie(Q_PROPERTY)
                txdZona.text = cppqml.strElementOpisanie;//Отображаем проверенное описание через sql_encode()
            }
        }
	}
	Item {
		id: tmToolbar
	}
}
