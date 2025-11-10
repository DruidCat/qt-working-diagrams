import QtQuick //2.15

import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
//Страница просмотра PDF документов.
Item {
	id: root
    //Свойства
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "Orange"
	property color clrFona: "Black"
	property color clrMenuFon: "SlateGray"
    property color clrPoisk: "Yellow"
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
    property bool pdfMentor: false//true - собственный просмотщик pdf документов.
    property int logoRazmer: 22//Размер Логотипа
    property string logoImya: "mentor"//Имя логотипа в DCLogo
    property bool isMobile: true//true - мобильная платформа.
    //Настройки
    anchors.fill: parent//Растянется по Родителю.
    focus: true//Чтоб работали горячие клавиши.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    //Функции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event => 
		if (event.modifiers & Qt.ControlModifier && event.modifiers & Qt.ShiftModifier){//Если "Ctrl + Shift"
            if(event.key === 43){//Если нажата клавиша "+", то...
                if(knopkaPovorotPo.visible && knopkaPovorotPo.enabled)//Если кнопка видимая, и активная то...
					fnClickedPovorotPo()//Функция нажатия кнопки поворота по часовой стрелке.
                event.accepted = true;//Завершаем обработку эвента.
            }
			else{
				if(event.key === 95){//Если нажата клавиша "-", то...
                    if(knopkaPovorotProtiv.visible && knopkaPovorotProtiv.enabled)//Если видимая и активная,то
						fnClickedPovorotProtiv()//Функция нажатия кнопки поворота против часовой стрелке.
					event.accepted = true;//Завершаем обработку эвента.
				}
                else{
                    if(event.key === Qt.Key_N){//Если нажата клавиша N, то...
                        fnClickedPage()//Функция клика на ввод номера страницы.
                        event.accepted = true;//Завершаем обработку эвента.
                    }
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
				else{
					if(event.key === Qt.Key_Minus){//Если нажат "-", то.
						var ntScaleDown = pdfScale.value - 25;//-1 страница
						if(ntScaleDown > pdfScale.from)//Если больше или равно минимальному значению, то...
							pdfLoader.item.renderScale = ntScaleDown/100;//уменьшаем масштаб документа.
						else{
							if(pdfScale.value !== pdfScale.from)
								pdfLoader.item.renderScale = pdfScale.from/100;//Выставляем мин значение.
						}
						event.accepted = true;//Завершаем обработку эвента.
					}
					else{
						if(event.key === Qt.Key_F){//Если нажат "F", то.
                            if(knopkaPoisk.visible && knopkaPoisk.enabled)//Если поиск видимый и активный,то..
								fnClickedPoisk();//Запускаем режим поиска
							event.accepted = true;//Завершаем обработку эвента.
						}
						else{
							if(event.key === Qt.Key_S){
								if(knopkaOk.visible)//Если кнопка Ок видимая, то...
									fnClickedOk();//Функция нажатия кнопки Ок
								event.accepted = true;//Завершаем обработку эвента.
							}
                            else{
                                if(event.key === Qt.Key_C){
                                    if(pdfLoader.item)//Если существует Загрузчик, то...
                                        pdfLoader.item.fnCopyToClipboard();//Копируем выделенный текст в file.pdf.
                                    event.accepted = true;//Завершаем обработку эвента.
                                }
                                else{
                                    if(event.key === Qt.Key_B){//Если нажата клавиша B
                                        fnSidebarZakladki()//Функция открытия боковой панели на Закладке.
                                        event.accepted = true;//Завершаем обработку эвента.
                                    }
                                    else{
                                        if(event.key === Qt.Key_T){//Если нажата клавиша T
                                            fnSidebarPoster()//Открытие боковой панели на Миниатюрах.
                                            event.accepted = true;//Завершаем обработку эвента.
                                        }
                                    }
                                }
                            }
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
                    else{
                        if (event.key === Qt.Key_F){//Если нажата клавиша F, то...
                            fnSidebarNaideno()//Функция открытия боковой панели на Найдено.
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                    }
                }
                else{
                    if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                        if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                            fnClickedPoiskPrevious()//Функция нажатия кнопки Предыдущего поиска
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                    }
                    else{//Если не нажат shift, то...
                        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
                            if(knopkaZakrit.visible)//Если кнопка Закрыть на поиск видима, то...
                                fnClickedZakrit();//Закрываем эту строку
                            event.accepted = true;//Завершаем обработку эвента.
                        }
                        else{
                            if(event.key === Qt.Key_Down){//нажата "Стрелка вниз",то
                                fnClickedKeyVniz();//Функция нажатия клавиши вниз
                                event.accepted = true;//Завершаем обработку эвента.
                            }
                            else{
                                if(event.key === Qt.Key_Up){//нажата "Стрелка вверх"
                                    fnClickedKeyVverh();//Функция нажатия клавиши вверх
                                    event.accepted = true;//Завершаем обработку эвента.
                                }
                                else{
                                    if(event.key === Qt.Key_Left){//Если нажата стрелка влево,то.
                                        fnClickedKeyVlevo()//нажатия клавиши влево
                                        event.accepted = true;//Завершаем обработку эвента.
                                    }
                                    else{
                                        if(event.key === Qt.Key_Right){//Если нажата стрелка вправо, то.
                                            fnClickedKeyVpravo()//нажатия клавиши вправо
                                            event.accepted = true;//Завершаем обработку эвента.
                                        }
                                        else{
                                            if(event.key === Qt.Key_PageDown){//нажата "Page Down",то
                                                fnClickedKeyPgDown();//Функция нажатия клавиши Page Down
                                                event.accepted = true;//Завершаем обработку эвента.
                                            }
                                            else{
                                                if(event.key === Qt.Key_PageUp){//нажата "Page Up"
                                                    fnClickedKeyPgUp();//Функция нажатия клавиши Page Up
                                                    event.accepted = true;//Завершаем обработку эвента.
                                                }
                                                else{
                                                    if(event.key === Qt.Key_Home){//Если нажата кнопка Home,то
                                                        fnClickedKeyHome();//Функция нажатия клавиши Home
                                                        event.accepted = true;//Завершаем обработку эвента.
                                                    }
                                                    else{
                                                        if(event.key === Qt.Key_End){//Если нажата кнопка End
                                                            fnClickedKeyEnd();//Функция нажатия клавиши End
                                                            event.accepted = true;//Завершаем обработку эвента
                                                        }
                                                        else{
                                                            if((event.key===Qt.Key_F3)
                                                                    ||(event.key===Qt.Key_Enter)
                                                                    ||(event.key===Qt.Key_Return)){//F3
                                                                fnClickedPoiskNext();//нажатия Следующий поиск
                                                                event.accepted = true;//Завер обработку эвента
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
			}
		}
        //cppqml.strDebug = event.key;
    }
    function fnPdfSource(urlPdfPut){//управление свойствами загруженного компонента
        spbPdfPage.value = 1;//Задаём первую страницу в DCSpinBox до открытия документа по умолчанию, ВАЖНО!
        let uniqueUrl = urlPdfPut + "?t=" + Date.now();//Уникальный путь, чтоб не кешировался документ в Qml
        pdfLoader.strPdfPut = uniqueUrl;//Устанавливаем уникальный путь.
        if(urlPdfPut){//Если путь не пустая строка, то...
            pdfLoader.blClose = false;//Не закрываем Загрузчик.
            pdfLoader.active = true;//Активируем загрузчик, загружаем pdf документ.
        }
        else{//Если путь пустая строка, то...
            pdfLoader.item.fnClickedPoiskStop()//Передаём пустой запрос в поисковую модель. Обнуляем её.
            pssPassword.strPasswordOld = "";//Обнуляем при закрытии старый пароль.
            pdfLoader.pdfRotation = 0;//0 градусов.
            pdfLoader.item.source = "qrc:///workingdata/base.pdf";//Чтоб можно было удалить предыдущий doc.pdf
            pdfLoader.blClose = true;//Закрываем Загрузчик.
            pdfLoader.active = false;//Деактивируем загрузчик, уничтожаем всё его содержимое.
            Qt.callLater(fnGarbageCollector);//Принудительно вызываем сборщик мусора
            root.clickedNazad();//Сигнал нажатия кнопки Назад. А потом обнуление.
        }
    }
    function fnGarbageCollector(){//Функция сборщика мусора, после закрытия документа.
        if (typeof gc === "function")//Если это функция, то...
            gc();//Прямой вызов JavaScript-сборщика мусора.
        else//Если это метод, то...
            Qt.gc();
    }
    function fnClickedNazad(){//Функция нажатия кнопки Назад.
        if(pdfLoader.item)//Если документ загрузился в загрузчике, то...
            cppqml.strDannieStr = pdfLoader.item.nomerStranici;//Записываем в БД номер открытой страницы.
        fnPdfSource("");//Пустой путь PDF документа, закрываем.
    }
    function fnClickedKeyPgDown(){//Функция нажатия клавиши Page Down
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyPgDown()//Вниз на одну страницу
    }
    function fnClickedKeyPgUp(){//Функция нажатия клавиши Page Up
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyPgUp()//Вверх на одну страницу
    }
    function fnClickedKeyVniz(){//Функция нажатия клавиши вниз
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyVniz()//Вниз на одну страницу
    }
    function fnClickedKeyVverh(){//Функция нажатия клавиши вверх
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyVverh()//Вверх на одну страницу
    }
    function fnClickedKeyVlevo(){//Функция нажатия клавиши влево
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyVlevo()//Вверх на одну страницу
    }
    function fnClickedKeyVpravo(){//Функция нажатия клавиши вправо
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyVpravo()//Вниз на одну страницу
    }
    function fnClickedKeyHome(){//Функция нажатия клавиши Home
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyHome()//На первую страницу.
    }
    function fnClickedKeyEnd(){//Функция нажатия клавиши End
        if(pdfLoader.item) pdfLoader.item.fnClickedKeyEnd()//На последнюю страницу.
    }
    function fnClickedPoiskNext(){//Функция следующего номера поиска
        if(pskPoisk.visible) pdfLoader.item.fnClickedPoiskNext()//Функция перехода к следующему номеру поиска
    }
    function fnClickedPoiskPrevious(){//Функция предыдущего номера поиска
        if(pskPoisk.visible) pdfLoader.item.fnClickedPoiskPrevious()//переход к предыдущему номеру поиска
    }
    function fnClickedSidebar(){//Функция нажатия кнопки SideBar.
        if(pdfLoader.item) pdfLoader.item.fnClickedSidebar()//Открываем/закрываем боковую панель через функцию
    }
    function fnSidebarNaideno(){//Функция открытия/закрытия вкладки Найдено
        if((knopkaSidebar.visible && knopkaSidebar.enabled)||pskPoisk.visible)//боковая панель видима/активна
            if(pdfLoader.item) pdfLoader.item.fnSidebarNaideno()//открытие/закрытие вкладки Найдено
    }
    function fnSidebarZakladki(){//Функция открытия/закрытия вкладки Закладки
        if((knopkaSidebar.visible && knopkaSidebar.enabled)||pskPoisk.visible)//Боковая панель видима/активна
            if(pdfLoader.item) pdfLoader.item.fnSidebarZakladki()//открытие/закрытие вкладки Закладки
    }
    function fnSidebarPoster(){//Функция открытия/закрытия вкладки Миниатюр
        if((knopkaSidebar.visible && knopkaSidebar.enabled)||pskPoisk.visible)//Боковая панель видима/активна
            if(pdfLoader.item) pdfLoader.item.fnSidebarPoster()//открытие/закрытие вкладки Миниатюр
    }
	function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
		txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
	}
	function fnClickedOk(){//Функция отправить запрос на поиск
        if(cppqml.isPdfPoiskPusto(txnZagolovok.text)){//Если пустой запрос с кучей пробелов, то...
			txnZagolovok.text = "";//Делаем поле запроса на поиск полностью пустым.
 			txnZagolovok.placeholderColor = "#9c3a3a";//Серо красный цвет.
        	txnZagolovok.placeholderText = qsTr("ПУСТОЙ ПОИСКОВЫЙ ЗАПРОС");//Подсказка пользователю.
		}
		else{
            if(cppqml.isPdfPoiskTri(txnZagolovok.text)){//Если в запросе три и более символов, то...
                pskPoisk.text = txnZagolovok.text;//текст присваиваем.
                pskPoisk.visible = true;//Делаем видимым режим поиска
                txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
                pdfLoader.item.fnClickedPoiskStop()//ОБЯЗАТЕЛЬНО ВСЁ ОБНУЛЯЕМ ПЕРЕД НОВЫМ ПОИСКОМ.
                pdfLoader.item.searchString = txnZagolovok.text//Передаём запрос
            }
            else{//Если менее трёх символов, то...
                txnZagolovok.text = "";//Делаем поле запроса на поиск полностью пустым.
                txnZagolovok.placeholderColor = "#9c3a3a";//Серо красный цвет.
                txnZagolovok.placeholderText = qsTr("В ЗАПРОСЕ МЕНЕЕ ТРЁХ СИМВОЛОВ");//Подсказка пользователю.
            }
        }
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
    function fnClickedPage(){//Функция клика на ввод номера страницы.
        if(spbPdfPage.visible){//Если видимый виджет выбора страниц, то...
            if(spbPdfPage.spinBox.focus)//Если фокус на вводе цифр, то...
                root.focus = true;//Фокусируемся на виджете StrPdf.
            else//Если фокус не на вводе цифр, то...
                spbPdfPage.spinBox.focus = true;//Фокусируемся на виджете ввода цифр DCSpinBox.
        }
    }
    function fnClickedPoisk(){//Функция запуска режима поиска.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ПОИСКОВЫЙ ЗАПРОС");//Подсказка пользователю.
        txnZagolovok.placeholderColor = "#aaa";//Светло серый цвет
        txnZagolovok.visible = true;//Режим запроса на поиск ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
    }

    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 110; running: false; repeat: true
        property bool blLogoTMK: false
        onTriggered: {
            if(blLogoTMK){//Если true, то...
                lgLogo.ntCoff++;
                if(lgLogo.ntCoff >= root.logoRazmer)
                    blLogoTMK = false;
            }
            else{
                lgLogo.ntCoff--;
                if(lgLogo.ntCoff <= 1)
                    blLogoTMK = true;
            }
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                ldrProgress.active = true;//Запускаем виджет загрузки
                knopkaSidebar.enabled = false;//Делаем неактивной кнопку боковой панели.
                knopkaPovorotPo.enabled = false;//Делаем неактивной кнопку По часовой стрелки.
                knopkaPovorotProtiv.enabled = false;//Делаем неактивной кнопку Против часовой стрелки.
                spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
                pdfScale.visible = false;//Делаем невидимым DCScale
                knopkaPoisk.enabled = false;//Делаем неактивной кнопку Поиска.
            }
            else{//Если таймер выключен, то...
                ldrProgress.active = false;//Отключаем прогресс. 
                spbPdfPage.visible = true;//Делаем видимым DCSpinBox
                pdfScale.visible = true;//Делаем видимым DCScale
                if(pskPoisk.visible){//Если видим виджет поиска, то...
                    knopkaSidebar.visible = false;//Делаем невидимой кнопку боковой панели.
                    knopkaPovorotPo.visible = false;//Делаем невидимым кнопку По часовой стрелки.
                	knopkaPovorotProtiv.visible = false;//Делаем невидимым кнопку Против часовой стрелки.
                }
				else{//Если не видим виджет поиска(например при увеличении), то...
                    knopkaSidebar.enabled = true;//Делаем активной кнопку боковой панели.
                    knopkaPovorotPo.enabled = true;//Делаем активное кнопку По часовой стрелки.
                    knopkaPovorotProtiv.enabled = true;//Делаем активной кнопку Против часовой стрелки.
                    knopkaPoisk.enabled = true;//Делаем активной кнопку Поиска.
                }
            }
        }
    }
	Item {
		id: tmZagolovok
        DCKnopkaNazad {
			id: knopkaNazad
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left: tmZagolovok.left
			clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedNazad();//Функция нажатия кнопки Назад.
        }
        Rectangle {
            id: rctKnopka
            width: root.ntWidth*root.ntCoff
            height: width
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left: knopkaNazad.right
            color: "transparent"
        }
        DCKnopkaSidebar {
            id: knopkaSidebar
            opened: false//По умолчанию закрыта боковая панель.
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left: rctKnopka.right
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedSidebar();//Функция нажатия кнопки SideBar.
        }
        DCKnopkaZakrit {
            id: knopkaZakrit
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.left: tmZagolovok.left
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokLevi
            onClicked: fnClickedZakrit()//Функция обрабатывающая кнопку Закрыть.
        }
		Item {
			id: tmTextInput
            anchors.top: tmZagolovok.top; anchors.bottom: tmZagolovok.bottom
            anchors.left: knopkaNazad.right; anchors.right: knopkaPoisk.left
            anchors.topMargin: root.ntCoff/4; anchors.bottomMargin: root.ntCoff/4
            DCTextInput {
				id: txnZagolovok
                ntWidth: root.ntWidth; ntCoff: root.ntCoff
				anchors.fill: tmTextInput
                visible: false; radius: root.ntCoff/2
                clrTexta: root.clrTexta; clrFona: root.clrMenuFon
				blSqlProtect: false//Отключаем защиту от Sql инъекций, вводить можно любой текст.
                textInput.maximumLength: cppqml.untNastroikiMaxLength
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
                        knopkaNazad.visible = false;//Кнопка назад Невидимая.
                        knopkaSidebar.visible = false;//Делаем невидимым кнопку Боковой панели
                        knopkaPovorotPo.visible = false;//Делаем невидимым кнопку По часовой стрелки.
                        knopkaPovorotProtiv.visible = false;//Делаем невидимым кнопку Против часовой стрелки.
                        knopkaPoisk.visible = false;//Конопка Поиск Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
					}
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
						if(!pskPoisk.visible){//Если не открыли Режим поиска, то...
                            root.focus = true;//Фокус на основной странице, чтоб горячие клавиши работали.
							knopkaNazad.visible = true;//Кнопка назад видимая.
                            knopkaSidebar.visible = true;//Делаем видимым кнопку Боковой панели
                            knopkaPovorotPo.visible = true;//Делаем видимым кнопку По часовой стрелки.
                            knopkaPovorotProtiv.visible = true;//Делаем видимым кнопку Против часовой стрелки.
                            knopkaPoisk.visible = true;//Конопка Поиск Видимая.
                        	txnZagolovok.text = "";//Текст обнуляем вводимый.
						}
					}
				}
				onClickedEnter: {
					if(knopkaOk.visible)//Если кнопка Ок видимая, то...
						fnClickedOk()//Функция отправить запрос на поиск
				}
                onClickedCopyToClipboard: {//Если нажато в виджете сочетание клавишь Ctrl+C
                    if(textInput.selectedText)//Если текст в самом виджете выделен, то...
                        textInput.copy();//Копируем выделенный текст в виджете.
                    else//Если текст в виджете не выделен, значен он может быть выделен в file.pdf, то...
                        pdfLoader.item.fnCopyToClipboard();//Копируем выделенный текст в file.pdf.
                }
			}
		}	
        DCKnopkaOk{
			id: knopkaOk
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokPravi
            onClicked: fnClickedOk()//Функция отправить запрос на поиск
		}	
        DCPoisk {
            id: pskPoisk
            //Свойства
            sumPoisk: pdfLoader.item ? pdfLoader.item.searchCount : 0
            //Настройки
            anchors.top: tmZagolovok.top; anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left; anchors.right: tmZagolovok.right
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false//Невидимый виджет.
            clrFona: root.clrFona; clrTexta: root.clrPoisk; clrKnopki: root.clrPoisk; clrBorder: root.clrTexta
            tapKnopkaZakrit: 1.3; tapKnopkaVniz: 1.3; tapKnopkaVverh: 1.3
            onClickedSidebar: fnClickedSidebar()//Открываем/Закрываем боковую панель.
            onClickedSidebarZakladki: fnSidebarZakladki()//Функция нажатия кнопки SideBar.
            onClickedSidebarPoster: fnSidebarPoster()//Функция нажатия кнопки SideBar.
            onClickedSidebarNaideno: fnSidebarNaideno()//Функция нажатия кнопки SideBar.
            onClickedNext: fnClickedPoiskNext()//Функция следующего номера поиска
            onClickedPrevious: fnClickedPoiskPrevious()//Функция предыдущего номера поиска
            onClickedVverh: fnClickedKeyVverh()//Функция нажатия клавиши Вверх
            onClickedVniz: fnClickedKeyVniz()//Функция нажатия клавиши Вниз
            onClickedVlevo: fnClickedKeyVlevo()//Функция нажатия клавиши Влево
            onClickedVpravo: fnClickedKeyVpravo()//Функция нажатия клавиши Вправо
            onClickedZakrit: {//Нажатие кнопки Закрытия поиска.
                root.focus = true;//Фокус на основной странице, чтоб горячие клавиши работали.
                pskPoisk.visible = false;//Делаем невидимый режим Поиска, и только после этого...
                knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                knopkaOk.visible = false;//Кнопка Ок Невидимая.
                knopkaNazad.visible = true;//Кнопка назад видимая.
                knopkaSidebar.visible = true;//Делаем видимым кнопку Боковой панели
                knopkaSidebar.enabled = true;//Делаем активной кнопку Боковой панели
                knopkaPovorotPo.visible = true;//Делаем видимым кнопку По часовой стрелки.
                knopkaPovorotPo.enabled = true;//Делаем активной кнопку По часовой стрелки.
                knopkaPovorotProtiv.visible = true;//Делаем видимым кнопку Против часовой стрелки.
                knopkaPovorotProtiv.enabled = true;//Делаем активной кнопку Против часовой стрелки.
                knopkaPoisk.visible = true;//Конопка Поиск Видимая.
                knopkaPoisk.enabled = true;//Конопка Поиск активния.
                txnZagolovok.text = "";//Текст обнуляем вводимый.
                pdfLoader.item.fnClickedPoiskStop()//ОБЯЗАТЕЛЬНО ВСЁ ОБНУЛЯЕМ ПЕРЕД НОВЫМ ПОИСКОМ.
                if(knopkaSidebar.opened)//Если боковая панель открыта, то...
                    fnSidebarNaideno();//Закрываем боковую панель с вкладкной Найдено.
            }
        }
        DCKnopkaPoisk{
            id: knopkaPoisk
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokPravi
            onClicked: fnClickedPoisk();//Запускаем режим поиска 
        }
        DCKnopkaPovorotPo {
            id: knopkaPovorotPo
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: knopkaPoisk.left
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
        DCPassword{
            id: pssPassword
            property string strPasswordOld: ""//Переменная хранящая предыдущий пароль.
            anchors.top: tmZagolovok.top; anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left; anchors.right: tmZagolovok.right
            anchors.topMargin: root.ntCoff/4; anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2; anchors.rightMargin: root.ntCoff/2
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false//Невидимый виджет.
            clrFona: root.clrFona; clrFonaPass: root.clrTexta; clrTexta: root.clrFona
            clrKnopki: root.clrPoisk;clrBorder:root.clrPoisk
            placeholderTextTrue: qsTr("ВВЕДИТЕ ПАРОЛЬ ДОКУМЕНТА")
            placeholderTextFalse: qsTr("НЕВЕРНЫЙ ПАРОЛЬ ДОКУМЕНТА")
            tapKnopkaZakrit: root.tapZagolovokLevi; tapKnopkaOk: root.tapZagolovokPravi
            onClickedOk: function (strPassword)  {//Слот нажатия кнопки Ок
                pssPassword.passTrue = false;//Делаем крассным, если пароль верный, никто не увидит.
                if(strPassword){//Если пользователь ввёл хоть что то, то...
                    if(strPassword !== strPasswordOld){//Если Пароль введённый не совпадает со старым, то...
                        strPasswordOld = strPassword;//Запоминаем введённый пароль.
                        pssPassword.visible = false;//Невидимым ввода пароля.
                        pdfLoader.item.password = strPassword;//Передаём пароль в документ.
                        pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                        //pssPassword.passTrue = false;//Делаем крассным, если пароль верный, никто не увидит.
                        spbPdfPage.from = 1;//1 страница, это минимум.
                        spbPdfPage.to = pdfLoader.item.pageCount;//Задаём максимальное кол-во страниц в DCSpinBox
                    }
                    else//Если пароли совпадают, то...
                        pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                }
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                pssPassword.visible = false;//Делаем невидимым виджет
                pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                fnPdfSource("");//Закрываем страницу.
            }
			onVisibleChanged: {//Если видимость изменилась, то...
                if(pssPassword.visible)
                    spbPdfPage.spinBox.readOnly = true;//запрещаем редактировать для Android.
                else
                    spbPdfPage.spinBox.readOnly = false;//разрешаем редактировать для Android.
			}
        }
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.	
        DCLogo {//Логотип
            id: lgLogo
            anchors.centerIn: tmZona
            ntCoff: root.logoRazmer; logoImya: root.logoImya
            clrLogo: root.clrTexta; clrFona: root.clrFona
		}
        Loader {//Loader динамической загрузки PDF Viewer
            id: pdfLoader
            //Свойства.
            property string strPdfPut: ""//Путь к документу,который нужно открыть или пустой путь,чтоб закрыть
            property bool blClose: true//true - закрываем документ.
            property int pdfRotation: 0//Угол поворота (может быть: 0, 90, 180, 270)
            property bool isDannie: false//true-открывается файл из Данных
            property bool isKatalog: false//true-открывается файл из Каталога
            property int ntWidth: root.ntWidth//Передаём длину символа для боковой панели
            property int ntCoff: root.ntCoff//Передаём коэффициент для боковой панели
            property color clrTexta: root.clrTexta
            property color clrFona: root.clrFona
            property color clrMenuFon: root.clrMenuFon
            property color clrPois: root.clrPoisk
            property bool isMobile: root.isMobile
            //Настройки.
            anchors.fill: tmZona
            source: pdfLoader.blClose ? "" : "qrc:/qml/DCMethods/DCPdfMPV.qml"//Указываем путь отдельному QMl
            active: false//не активирован.
            //Функции
            function fnNastroiki(){//Функция передающая свойства в загрузчик.
                item.ntWidth = ntWidth
                item.ntCoff = ntCoff
                item.clrTexta = clrTexta
                item.clrFona = clrFona
                item.clrMenuFon = clrMenuFon
                item.clrPoisk = clrPoisk
                item.isMobile = isMobile
            }
            onLoaded: { 
                if(isDannie)//Если открывается из Данных документ, то...
                    pdfLoader.item.currentPage = cppqml.strDannieStr;//Считываем из БД номер странцы документа.
                if(isKatalog)//Если открывается из Каталога документ, то...
                    pdfLoader.item.currentPage = 0;//Всегда с 1 страницы.
                pdfLoader.item.source = pdfLoader.strPdfPut;// Устанавливаем путь к PDF
                pdfLoader.fnNastroiki();//Передаём настройки в загрузчик.
            }
        }
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
                if(root.pdfMentor){//Если выбран в настройках собственный просмотрщик, то...
                    tmrLogo.running = true;//Запускаем таймер анимации логотипа
                    pssPassword.passTrue = true;//Пароль верный, текс стандартный, надпись стандартная.
                    var strPdfUrl = cppqml.strDannieUrl;//Считываем путь+документ.pdf
                    pdfLoader.isDannie = true; pdfLoader.isKatalog = false;
                    fnPdfSource(strPdfUrl);//Передаём путь к pdf документу и тем самым его открываем.
                    //console.error("446: Url: " + strPdfUrl);
                    spbPdfPage.to = pdfLoader.item.pageCount;//Максимальное количество страниц в DCSpinBox
                }
            }
            function onStrKatalogUrlChanged(){//Если изменился элемент списка в strKatalogUrl (Q_PROPERTY), то
                if(root.pdfMentor){//Если выбран в настройках собственный просмотрщик, то...
                    tmrLogo.running = true;//Запускаем таймер анимации логотипа
                    pssPassword.passTrue = true;//Пароль верный, текс стандартный, надпись стандартная.
                    var strPdfUrl = cppqml.strKatalogUrl;//Считываем путь+документ.pdf
                    pdfLoader.isKatalog = true; pdfLoader.isDannie = false;
                    fnPdfSource(strPdfUrl);//Передаём путь к pdf документу и тем самым его открываем.
                    //console.error("456: Url: " + strPdfUrl);
                    spbPdfPage.to = pdfLoader.item.pageCount;//Максимальное количество страниц в DCSpinBox
                }
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
                    lgLogo.ntCoff = root.logoRazmer;//Задаём размер логотипа.
                }
                else{//Виджет не видимый. При открытии этот флаг не изменится.
                    if(!pdfLoader.blClose)//Если Pdf загрузчик не закрываем... НЕ УДАЛЯТЬ!
                        tmrLogo.running = true;//Запускаем таймер анимации логотипа
                }
            }
            function onSgnCurrentPage(ntStranica){//Изменился номер страницы
                spbPdfPage.value = ntStranica + 1//В DCSpinBox выставляем значение страницы.
            }
            function onRenderScaleChanged(){//Изменился масштаб документа.
                pdfScale.value = pdfLoader.item.renderScale*100;//Выставляем значение масштаба в DCScale.
            }
            function onSgnScaleMin(rlScaleMin){//Изменился минимальный масштаб документа.
                pdfScale.from = rlScaleMin*100;//Выставляем минимальное значение масштаба документа в DCScale.
            }
            function onSgnPassword(){//Произошёл запрос на ввод пароля.
                tmrPassword.running = true;//Делаем видимым поле ввода пароля через небольшую паузу.
            }
            function onSgnProgress(ntProgress, strStatus){//Изменился прогресс документа.
                if(ldrProgress.item){//Если загрузчик создался, то...
                    ldrProgress.item.ntWidth = root.ntWidth;//ВАЖНО! Для изменения размера шрифта.
                    ldrProgress.item.ntCoff = root.ntCoff;//ВАЖНО! Для изменения размера шрифта.
                    ldrProgress.item.progress = ntProgress;//Отправляем прогресс загрузки в DCProgress.
                    ldrProgress.item.text = strStatus;//Выводим статус загрузки документа.
                }
            }
            function onIsSearchChanged(){//Если статус поиска изменился, то...
                if(pdfLoader.item.isSearch)//Если поиск идёт, то...
                    pskPoisk.enabled = false;//Деактивируем кнопки в виджете поиска.
                else//Если поиск окончился, то...
                    pskPoisk.enabled = true;//Активируем кнопки в виджете поиска.
            }
            function onCurrentResultChanged(){//Если обрабатываемый результат поиска изменён, то...
                pskPoisk.currentResult = pdfLoader.item.currentResult//Задаём отображение номера поиска.
            }
            function onClickedPoiskNext(){//Если нажато сочетание клавиш Следующего поиска, то...
                fnClickedPoiskNext()//Функция Следующего поиска, то...
            }
            function onClickedPoiskPrevious(){//Если нажато сочетание клавиш Предыдущего поиска, то...
                fnClickedPoiskPrevious()//Функция Предыдущего поиска, то...
            }
            function onClickedSidebarNaideno(){//Если нажата горячая клавиша Atl+F
                fnSidebarNaideno()//Открываем боковую панель.
            }
            function onClickedSidebarZakladki(){//Если нажата горячая клавиша Ctrl+B
                fnSidebarZakladki()//Открываем боковую панель.
            }
            function onClickedSidebarPoster(){//Если нажата горячая клавиша Ctrl+T
                fnSidebarPoster()//Открываем боковую панель.
            }
            function onSgnOpenedSidebar(blOpened){//Если боковая панель открыта/закрыта, то...
                pskPoisk.isOpenedSidebar = blOpened;//Приравниваем флаг открыта ли боковая панель?
                knopkaSidebar.opened = blOpened//Передаём сигнал кнопке, для отображения нужной позиции.
            }
        }
        Timer{//Таймер нужен, чтоб виджет успел исчезнуть и потом появиться, если пароль неверный.
            id: tmrPassword
            interval: 11; repeat: false; onTriggered: pssPassword.visible = true;//Делаем видимым ввод пароля.
        }
		Rectangle {//Это граница документа очерченая линией для красоты.
			id: rctBorder
			anchors.fill: tmZona
			color: "transparent"
			border.color: root.clrTexta
            border.width: root.ntCoff/4//Бордюр
		}	
	}
    Item {//Тулбар
		id: tmToolbar
        clip: true//Обрезаем загрузчик, который выходит за границы toolbar
        Loader {//Loader Прогресса загрузки pdf документа
            id: ldrProgress
            anchors.fill: tmToolbar
            source: "qrc:/qml/DCMethods/DCProgress.qml"//Указываем путь к отдельному QMl
            active: false//не активирован.
            onLoaded: {//Когда загрузчик загрузился, передаём свойства в него.
                ldrProgress.item.ntWidth = root.ntWidth; ldrProgress.item.ntCoff = root.ntCoff;
                ldrProgress.item.clrProgress = root.clrTexta; ldrProgress.item.clrTexta = root.clrMenuFon;
            }
        }
        DCSpinBox {
			id: spbPdfPage
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false 
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.left: tmToolbar.left
            anchors.margins: root.ntCoff/2
            clrTexta: root.clrTexta; clrFonaPassive: root.clrFona; clrFonaActive: root.clrMenuFon
			radius: root.ntCoff/2
            from: 1; value: 1
			spinBox.cursorVisible: true;//Делаем курсор видимым обязательно.
            tapKnopkaMinus: root.tapToolbarLevi; tapKnopkaPlus: root.tapToolbarLevi
            onValueModified: {
                pdfLoader.item.currentPage = (spbPdfPage.value-1)//Если изменение страницы пришло из виджета
                root.focus = true;//Фокус на основной странице, чтоб не было фокуса на DCSpinBox.
            }
		}
        DCScale{
			id: pdfScale
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.right: tmToolbar.right
			visible: true
            clrTexta: root.clrTexta; clrFona: root.clrFona
			radius: root.ntCoff/2
            from: 1; to: 300; value: 100; stepSize: 25
            tapKnopkaMinus: root.tapToolbarPravi; tapKnopkaPlus: root.tapToolbarPravi
            onValueModified: pdfLoader.item.renderScale = value/100;//Масштабируем документ по значению value
		}
	}
}
