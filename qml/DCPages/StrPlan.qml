import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница с отображением Плана.
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
    property real tapZagolovokLevi: 1
    property real tapZagolovokPravi: 1
    property real tapToolbarLevi: 1
    property real tapToolbarPravi: 1
    property bool appRedaktor: false//true - включить Редактор приложения.
    property bool pdfViewer: false//true - собственный просмотщик pdf документов.
    property int ntLogoTMK: 16
    property string source: ""//Путь к pdf документу.
    //Настройки
	anchors.fill: parent//Растянется по Родителю.
    //Сигналы
    signal clickedNazad();//Сигнал нажатия кнопки Назад
    signal clickedSozdat();//Сигнал нажатия кнопки Создать
    //Функции
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
		if (event.modifiers & Qt.ControlModifier && event.modifiers & Qt.ShiftModifier){//Если "Ctrl + Shift"
            if(event.key === 43){//Если нажата клавиша "+", то...
                if(knopkaPovorotPo.enabled)//Если кнопка видимая, то...
					fnClickedPovorotPo()//Функция нажатия кнопки поворота по часовой стрелке.
                event.accepted = true;//Завершаем обработку эвента.
            }
			else{
				if(event.key === 95){//Если нажата клавиша "-", то...
                    if(knopkaPovorotProtiv.enabled)//Если кнопка активная, то...
						fnClickedPovorotProtiv()//Функция нажатия кнопки поворота против часовой стрелке.
					event.accepted = true;//Завершаем обработку эвента.
				}
			}
        }
		else{
			if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
				if(event.key === Qt.Key_Equal){//Если нажата "+",то.
					var ntScaleUp = pdfScale.value + 25;
					if(ntScaleUp <= pdfScale.to)//Если это не максимальное значение масштаба, то...
						pdfLoader.item.renderScale = ntScaleUp/100;
					else{//Если больше максимального масштаба, то...
						if(pdfScale.value !== pdfScale.to)//Если не равна максимальному значению до увеличения, то
							pdfLoader.item.renderScale = pdfScale.to/100;//Выставляем максимальное значение.
					}
					event.accepted = true;//Завершаем обработку эвента.
				}
				else{//Если не нажата клавиша "+"
					 if(event.key === Qt.Key_Minus){//Если нажат "-", то.
						var ntScaleDown = pdfScale.value - 25;//-1 страница
						if(ntScaleDown > pdfScale.from)//Если больше или равно минимальному значению, то...
							pdfLoader.item.renderScale = ntScaleDown/100;//уменьшаем масштаб документа.
						else{
							if(pdfScale.value !== pdfScale.from)
								pdfLoader.item.renderScale = pdfScale.from/100;//Выставляем минимальное значение.
						}
						event.accepted = true;//Завершаем обработку эвента.
					}
					else{
						if(event.key === Qt.Key_N){//Если нажата клавиша N, то...
							if(knopkaSozdat.visible)//Если кнопка Созать видимая, то...
								fnClickedSozdat();//Функция добавления Плана.
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
                                fnClickedSozdat();//Функция добавления Плана.
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                    }
                }
			}
		}
        
    }
    function fnClickedNazad(){//Функция нажатия кнопки Назад
        fnPdfSource("");//Пустой путь PDF документа, закрываем.
        root.clickedNazad();//Сигнал нажатия кнопки Назад. А потом обнуление.
    }
    function ustSource(strPdfUrl) {//Передаём адрес pdf документа.
		tmrLogo.running = true;//Запускаем таймер анимации логотипа
		//pssPassword.passTrue = true;//Пароль верный, текс стандартный, надпись стандартная.
		//console.error("39: Url: " + strPdfUrl);
		fnPdfSource(strPdfUrl);//Передаём путь к pdf документу и тем самым его открываем.
    }
    function fnPdfSource(urlPdfPut){//управление свойствами загруженного компонента
        let uniqueUrl = urlPdfPut + "?t=" + Date.now();//Уникальный путь, чтоб не кешировался документ в Qml
        pdfLoader.strPdfPut = uniqueUrl;//Устанавливаем уникальный путь.
        if(urlPdfPut){//Если путь не пустая строка, то...
            pdfLoader.blClose = false;//Не закрываем Загрузчик.
            pdfLoader.active = true;//Активируем загрузчик, загружаем pdf документ.
        }
        else{//Если путь пустая строка, то...
            pdfLoader.pdfRotation = 0;//0 градусов.
            pdfLoader.blClose = true;//Закрываем Загрузчик.
            pdfLoader.active = false;//Деактивируем загрузчик, уничтожаем всё его содержимое.
            Qt.callLater(fnGarbageCollector);//Принудительно вызываем сборщик мусора
        }
    }
    function fnGarbageCollector(){//Функция сборщика мусора, после закрытия документа.
        if (typeof gc === "function")//Если это функция, то...
            gc();//Прямой вызов JavaScript-сборщика мусора.
        else//Если это метод, то...
            Qt.gc();
    }
	function fnClickedPovorotPo(){//Функция нажатия кнопки поворота по часовой стрелке.
		pdfLoader.pdfRotation += 90;//Прибавляем по 90 градусов.
		if(pdfLoader.pdfRotation === 360)//Если 360 градусов, то...
			pdfLoader.pdfRotation = 0;//0 градусов.
		//pdfLoader.item.rotation = pdfLoader.pdfRotation;//Поворот сцены документа.
		pdfLoader.item.pageRotation = pdfLoader.pdfRotation;//Поворот страниц документа.
	}
	function fnClickedPovorotProtiv(){//Функция нажатия кнопки поворота против часовой стрелке.
		pdfLoader.pdfRotation -= 90;//Убавляем по 90 градусов.
		if(pdfLoader.pdfRotation === -90)//Если -90 градусов, то...
			pdfLoader.pdfRotation = 270;//270 градусов.
		//pdfLoader.item.rotation = pdfLoader.pdfRotation;//Поворот сцены документа.
		pdfLoader.item.pageRotation = pdfLoader.pdfRotation;//Поворот страниц документа.
	}
	function fnClickedSozdat(){//Функция добавления Плана.
		fnPdfSource("");//Пустой путь PDF документа, закрываем.
		root.clickedSozdat();//Сигнал нажатия кнопки Создать
	}
    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 110; running: false; repeat: true
        property bool blLogoTMK: false
        onTriggered: {
            if(blLogoTMK){//Если true, то...
                lgTMK.ntCoff++;
                if(lgTMK.ntCoff >= root.ntLogoTMK)
                    blLogoTMK = false;
            }
            else{
                lgTMK.ntCoff--;
                if(lgTMK.ntCoff <= 1)
                    blLogoTMK = true;
            }
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                ldrProgress.active = true;//Запускаем виджет загрузки
                knopkaPovorotPo.enabled = false;//Делаем неактивной кнопку По часовой стрелки.
                knopkaPovorotProtiv.enabled = false;//Делаем неактивной кнопку Против часовой стрелки.
                pdfScale.visible = false;//Делаем невидимым DCScale
                knopkaSozdat.visible = false;//Невидимая кнопка Создать.
            }
            else{//Если таймер выключен, то...
                ldrProgress.active = false;//Отключаем прогресс.
                knopkaPovorotPo.enabled = true;//Делаем активной кнопку По часовой стрелки.
                knopkaPovorotProtiv.enabled = true;//Делаем активной кнопку Против часовой стрелки.
                pdfScale.visible = true;//Делаем видимым DCScale
                if(root.appRedaktor)//Если редактор включен, то...
                    knopkaSozdat.visible = true;//Видимая кнопка Создать.
            }
        }
    }
    Item {//Данные Заголовок
		id: tmZagolovok
        DCKnopkaNazad {
            id: knopkaNazad
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left:tmZagolovok.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад
        }
        DCKnopkaPovorotPo {
            id: knopkaPovorotPo
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokPravi
            onClicked: fnClickedPovorotPo();//Функция нажатия кнопки поворота по часовой стрелке.
        }
        DCKnopkaPovorotProtiv {
            id: knopkaPovorotProtiv
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: knopkaPovorotPo.left
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokPravi
            onClicked: fnClickedPovorotProtiv();//Функция нажатия кнопки поворота против часовой стрелке.
        }
    }
    Item {
        id: tmZona
        clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
        DCLogo {//Логотип до ZonaFileDialog, чтоб не перекрывать список.
            id: lgTMK
            ntCoff: root.ntLogoTMK
            anchors.centerIn: tmZona
            clrLogo: root.clrTexta; clrFona: root.clrFona
        }
        Loader {//Loader динамической загрузки PDF Viewer
            id: pdfLoader
            //Свойства.
            property string strPdfPut: ""//Путь к pdf документу, который нужно открыть или пустой путь, чтоб закрыть.
            property bool blClose: true//true - закрываем документ.
            property int pdfRotation: 0//Угол поворота (может быть: 0, 90, 180, 270)
            //Настройки.
            anchors.fill: tmZona
            source: pdfLoader.blClose ? "" : "qrc:/qml/DCMethods/DCPdfMPV.qml"//Указываем путь отдельному QMl
            active: false//не активирован.

            onLoaded: {
                pdfLoader.item.currentPage = 0;//номер 1 странцы документа.
                pdfLoader.item.source = pdfLoader.strPdfPut;// Устанавливаем путь к PDF
            }
        }
        Connections {//Соединение сигналов из qml файла со слотами.
            target: pdfLoader.item
            function onSgnError() {//Ошибка при открытии документа
                fnPdfSource("");//Пустой путь PDF документа, закрываем.
            }
            function onSgnDebug(strDebug){//Пришла ошибка из qml файла.
                cppqml.strDebug = strDebug;//Отображаем ошибку.
            }
            function onVisibleChanged(){//Изменилась видимость виджета отображения pdf документа.
                if(pdfLoader.item.visible){//Виджет видимый.
                    tmrLogo.running = false;//отключаем таймер, и тем самым показываем документ и кнопки.
                    lgTMK.ntCoff = root.ntLogoTMK;//Задаём размер логотипа.
                }
                else{//Виджет не видимый. При открытии этот флаг не изменится.
                    if(!pdfLoader.blClose)//Если Pdf загрузчик не закрываем... НЕ УДАЛЯТЬ!
                        tmrLogo.running = true;//Запускаем таймер анимации логотипа
                }
            }
            function onRenderScaleChanged(){//Изменился масштаб документа.
                pdfScale.value = pdfLoader.item.renderScale*100;//Выставляем значение масштаба в DCScale
            }
            function onSgnScaleMin(rlScaleMin){//Изменился минимальный масштаб документа.
                pdfScale.from = rlScaleMin*100;//Выставляем минимальное значение масштаба документа в DCScale.
            }
            /*
            function onSgnPassword(){//Произошёл запрос на ввод пароля.
                tmrPassword.running = true;//Делаем видимым поле ввода пароля через небольшую паузу.
            }
            */
            function onSgnProgress(ntProgress, strStatus){//Изменился прогресс документа.
                if(ldrProgress.item)
                    ldrProgress.item.progress = ntProgress;//Отправляем прогресс загрузки в DCProgress.
                if(ldrProgress.item)
                    ldrProgress.item.text = strStatus;//Выводим статус загрузки документа.
            }
        }
        /*
        Timer{//Таймер нужен, чтоб виджет успел исчезнуть и потом появиться, если пароль неверный.
            id: tmrPassword
            interval: 11; repeat: false; onTriggered: pssPassword.visible = true;//Делаем видимым ввод пароля.
        }
        */
        Rectangle {//Это граница документа очерченая линией для красоты.
            id: rctBorder
            anchors.fill: tmZona
            color: "transparent"
            border.color: root.clrTexta
            border.width: root.ntCoff/4//Бордюр при переименовании и удалении.
        }
    }
    Item {//Данные Тулбар
		id: tmToolbar
        clip: true//Обрезаем загрузчик, который выходит за границы toolbar
        Loader {//Loader Прогресса загрузки pdf документа
            id: ldrProgress
            anchors.fill: tmToolbar
            source: "qrc:/qml/DCMethods/DCProgress.qml"//Указываем путь к отдельному QMl
            active: false//не активирован.
            onLoaded: {//Когда загрузчик загрузился, передаём свойства в него.
                ldrProgress.item.ntWidth = root.ntWidth; ldrProgress.item.ntCoff = root.ntCoff;
                ldrProgress.item.clrProgress = root.clrTexta; ldrProgress.item.clrTexta = "grey";
            }
        }

        DCKnopkaSozdat {
            id: knopkaSozdat
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.left: tmToolbar.left
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            visible: root.appRedaktor ? true : false//Настройка вкл/вык Редактор приложения.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff
            tapWidth: tapHeight*root.tapZagolovokLevi
			onClicked: fnClickedSozdat();//Функция добавления Плана. 
        }
        DCScale{
            id: pdfScale
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.right: tmToolbar.right
            visible: true
            clrTexta: root.clrTexta; clrFona: root.clrFona
            radius: root.ntCoff/2
            from: 1; to: 200; value: 100; stepSize: 25
            tapKnopkaMinus: root.tapToolbarPravi; tapKnopkaPlus: root.tapToolbarPravi
            onValueModified: pdfLoader.item.renderScale = value/100;//Масштабируем документ по значению value
        }
    }
}
