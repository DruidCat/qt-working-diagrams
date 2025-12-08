import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница с отладочной информацией.
Item {
    id: root
    //Свойства.
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
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
	property alias radiusZona: txdZona.radius
	property string strDebug: ""//Глобальная переменная, в ней собирается строка со всеми Сообщениями.
    //Настройки.
	anchors.fill: parent//Растянется по Родителю.
    focus: true;//Чтоб работали горячие клавиши.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal signalToolbar(var strToolbar);//Сигнал, когда передаём новую надпись в Тулбар.
    signal clickedInfo();//Сигнал нажатия кнопки Инфо, где будет описание работы Файлового Диалога.
    //Функции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.modifiers & Qt.AltModifier){//Если нажат "Alt"
            if (event.key === Qt.Key_Left){//Если нажата клавиша стрелка влево, то...
                if(knopkaNazad.visible)//Если кнопка Назад видимая, то...
                    fnClickedNazad();//Функция нажатия кнопки Назад
                event.accepted = true;//Завершаем обработку эвента.
            }
        }
        else{
            if(event.key === Qt.Key_F1){//Если нажата кнопка F1, то...
                if(knopkaInfo.visible)
                    fnClickedInfo();//Функция нажатия на кнопку Информация.
                event.accepted = true;//Завершаем обработку эвента.
            }
        }
    }
    function fnClickedNazad(){//Функция нажатия кнопки Назад
        root.clickedNazad();
    }
    function fnClickedInfo(){//Функция нажатия на кнопку Информации.
        fnClickedEscape();//Меню сворачиваем
        root.clickedInfo();//Сигнал излучаем, что нажата кнопка Описание.
    }
    function fnClickedPoisk(){//Функция нажатия кнопки Poisk.
    }
    function fnClickedEscape(){//Меню сворачиваем
        //menuDebug.visible = false;//Делаем невидимым всплывающее меню.
    }
    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад
        }
        DCKnopkaInfo {
            id: knopkaInfo
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: true
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedInfo();//Функция нажатия на кнопку Информации.
        }
    }
    Item {//Данные Зона
		id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
			readOnly: true//Запрещено редактировать текст
            textEdit.selectByMouse: false//Запрещаем выделять текст, то нужно для свайпа Android
            pixelSize: root.ntWidth/2*root.ntCoff//размер шрифта текста в два раза меньше.
            radius: root.ntCoff/4//Радиус возьмём из настроек элемента qml через property
            clrFona: root.clrFona//Цвет фона рабочей области
            clrTexta: root.clrTexta//Цвет текста
            clrBorder: root.clrTexta//Цвет бардюра при редактировании текста.
			italic: true//Текст курсивом.
		}
    }
    Item {//Данные Тулбар
		id: tmToolbar
        DCKnopkaPoisk{
            id: knopkaPoisk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            clrKnopki: root.clrTexta//Цвет файлов
            clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedPoisk();//Функция нажатия кнопки Poisk.
        }
        DCKnopkaNastroiki {
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.right: tmToolbar.right
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            blVert: true//Вертикольное исполнение
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: {
                /*
                txnZagolovok.visible = false;//Отключаем режим ввода данных заголовка.
                menuDannie.visible ? menuDannie.visible = false : menuDannie.visible = true;
                lsvDannie.isPereimenovat = false;//Запрещаем переименовывание (отмена)...(ок).
                lsvDannie.isPereimenovatVibor = false;//Запрещаем выбор элементов для переименовывания.
                lsvDannie.isUdalitVibor = false;//Запрещено удалять.
                lsvDannie.isSort = false;//Выключаем сортировку элементов.
                txuUdalit.visible = false;//Делаем невидимый запрос на удаление.
                lsvDannie.enabled = true;//Делаем кликабельную Зону.
                */
                root.signalToolbar("");//Делаем пустую строку в Toolbar.
            }
        }
    }
	Connections {//Соединяем сигнал из C++ с действием в QML
		target: cppqml;//Цель объект класса С++ DCCppQml
		function onStrDebugChanged(){//Слот Если изменилось сообщение в strDebug (Q_PROPERTY), то...
			let ltDebug = cppqml.strDebug;//Считываем сообщение из переменной.
            if(ltDebug !== ""){//Если не пустая строка, которая затирает старое сообщение в Toolbar, то...
				strDebug = strDebug + ltDebug + "\n";//Пишем текст в переменную из Свойтва Q_PROPERTY
				txdZona.text = strDebug;//Отображаем собранную строку в TextEdit модуле.
			}
		}
	}
}
