﻿import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница отображающая Описание чего либо.
Item {
    id: root
    //Свойства
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "Orange"
	property color clrFona: "Black"
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
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property bool appRedaktor: false//true - включить Редактор приложения.
    property bool isMobile: true//true - мобильная платформа.
    property alias textTextEdit: txdZona.text
	property string strOpisanie: "titul"
    //Настройки
    anchors.fill: parent//Растянется по Родителю.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать
    signal clickedPlan();//Сигнал нажатия кнопки План.
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    //Функции
    focus: true//Чтоб горячие клавиши работали.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
            if(event.key === Qt.Key_N){//Если нажата клавиша N, то...
                if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
                    fnClickedSozdat();//Функция редактирования текста.
                event.accepted = true;//Завершаем обработку эвента.
            }
            else{
                if(event.key === Qt.Key_S){//Если нажат "S", то.
                    if(knopkaOk.visible)//Если кнопка Ок видимая, то...
                        fnClickedOk();//Функция сохранения изменений
                    event.accepted = true;//Завершаем обработку эвента.
                }
                else{
                    if(event.key === Qt.Key_F){//Если нажат "F", то.
                        if(knopkaPlan.visible)
                            fnClickedPlan();//Функция нажатия на кнопку План.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
        }
        else{
            if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
                if (event.key === Qt.Key_Left){//Если нажата клавиша стрелка влево, то...
                    if(knopkaNazad.visible)//Если кнопка Назад видимая, то...
                        fnClickedNazad();//Функция нажатия кнопки Назад
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
            else{
                if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                    if(event.key === Qt.Key_I){//Если нажата клавиша I, то...
                        if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
                            fnClickedSozdat();//Функция редактирования текста.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
                }
            }
        }
        //cppqml.strDebug = event.key;
    }
    function fnClickedNazad() {//Функция нажатия кнопки Назад
        txdZona.readOnly = true;//запрещаем редактировать текст.
        root.clickedNazad();//Сигнал, что кнопка Назад нажата.
    }
    function fnClickedPlan(){//Нажитие кнопки План.
        root.clickedPlan();//Сигнал нажатия кнопки План.
    }
    function fnClickedOtmena(){//Отмена редакрирования
        root.focus = true;//Фокус на главном окне, чтоб работали горячие клавиши.
        root.signalToolbar("");//Удаляем надпись Подсказки.
        txdZona.readOnly = true;//запрещаем редактировать текст.
		if(strOpisanie == "titul"){//Если Титул, то...
			txdZona.text = cppqml.strTitulOpisanie;//Загружаем текст из бизнес логики.
		}
		else{
			if(strOpisanie == "spisok"){//Если Список, то...
				txdZona.text = cppqml.strSpisokOpisanie;//Загружаем текст из бизнес логики.
			}
			else{
				if(strOpisanie == "element"){//Если Элемент, то...
					txdZona.text = cppqml.strElementOpisanie;//Загружаем текст из бизнес логики.
                }
			}
		}
	}
    function fnClickedOk(){//Сохранение редакрированного описания.
        root.focus = true;//Фокус на главном окне, чтоб работали горячие клавиши.
        root.signalToolbar("");//Удаляем надпись Подсказки.
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
    function fnClickedSozdat(){//Функция нажатия кнопки Создать, для редактирования текста.
        root.signalToolbar(qsTr("Для окончания редактирования нажмите ОК."));//Подсказка.
        txdZona.readOnly = false;//Разрешить редактировать.
        root.clickedSozdat();//Излучаем сигнал Создать
    }

	Item {
		id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад
		} 
        DCKnopkaPlan {
            id: knopkaPlan
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            visible: true
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedPlan();//Функция нажатия кнопки План.
        }
        DCKnopkaZakrit {
            id: knopkaOtmena
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedOtmena();//Функция обрабатывающая кнопку Отмена.
        }
        DCKnopkaOk {
			id: knopkaOk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			visible: false 
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedOk();//Нажата кнопка Ок.
		}
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			readOnly: true//Запрещено редактировать текст
            textEdit.selectByMouse: !root.isMobile//Запрещаем выделять текст в Android из-за свайпа. На ПК нет
            radius: root.ntCoff/4//Радиус возьмём из настроек элемента qml через property
            clrFona: root.clrFona//Цвет фона рабочей области
            clrTexta: root.clrTexta//Цвет текста
            clrBorder: root.clrTexta//Цвет бардюра при редактировании текста.
            italic: true//Текст курсивом.
            onReadOnlyChanged: {
                if(readOnly){//Если запрещено редактировать, то...
                    txdZona.textEdit.cursorVisible = false;//Курсор сделаем не видимым
                    knopkaOtmena.visible = false;//делаем невидимой кнопку Отмена.
                    knopkaNazad.visible = true;//делаем видимой кнопку Назад.
                    knopkaOk.visible = false;//делаем невидимой кнопку Ок.
                    knopkaPlan.visible = true;//Делаем видимой кнопка План.
                    knopkaSozdat.visible = true;//делаем видимой кнопку Создать.
                }
                else{
                    txdZona.textEdit.cursorVisible = true;//Курсор сделае видимым
                    txdZona.textEdit.cursorPosition = txdZona.text.length;//Курсор в конец текста
                    knopkaSozdat.visible = false//Делаем невидимой кнопку Создать.
                    knopkaNazad.visible = false;//делаем невидимой кнопку Назад.
                    knopkaOtmena.visible = true;//делаем видимой кнопку Отмена.
                    knopkaPlan.visible = false;//Делаем невидимой кнопка План.
                    knopkaOk.visible = true;//Делаем видимой кнопку Ок
                }
            }
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
        DCKnopkaSozdat {
            id: knopkaSozdat
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.left: tmToolbar.left
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
			visible: root.appRedaktor ? true : false//Настройка вкл/вык Редактор приложения.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedSozdat();//Функция нажатия кнопки Создать.
		}
	}
}
