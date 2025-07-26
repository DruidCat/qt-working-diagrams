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
    property bool pdfViewer: false//true - собственный просмотщик pdf документов.
    property int ntLogoTMK: 16
    //Настройки
    anchors.fill: parent//Растянется по Родителю.
    focus: true//Чтоб работали горячие клавиши.
    //Сигналы.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
    //Функции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event => 
		if (event.modifiers & Qt.ControlModifier && event.modifiers & Qt.ShiftModifier){//Если "Ctrl + Shift"
            if(event.key === 43){//Если нажата клавиша "+", то...
				if(knopkaPovorotPo.visible)//Если кнопка видимая, то...
					fnClickedPovorotPo()//Функция нажатия кнопки поворота по часовой стрелке.
                event.accepted = true;//Завершаем обработку эвента.
            }
			else{
				if(event.key === 95){//Если нажата клавиша "-", то...
					if(knopkaPovorotProtiv.visible)//Если кнопка видимая, то...
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
							if(knopkaPoisk.visible)//Если кнопка поиск видимая, то...
								fnClickedPoisk();//Запускаем режим поиска
							event.accepted = true;//Завершаем обработку эвента.
						}
						else{
							if(event.key === Qt.Key_S){
								if(knopkaOk.visible)//Если кнопка Ок видимая, то...
									fnClickedOk();//Функция нажатия кнопки Ок
								event.accepted = true;//Завершаем обработку эвента.
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
                }
                else{
                    if (event.modifiers & Qt.ShiftModifier){//Если нажат "Shift"
                        if(event.key === Qt.Key_F3){//Если нажата клавиша F3, то...
                            if(pskPoisk.visible)//Если виджет поиска видимый, то...
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
                            if(event.key === Qt.Key_F3){//Если нажата "F3", то.
                                if(pskPoisk.visible)//Если режим поиска видимый, то...
                                    fnClickedPoiskNext();//Функция нажатия кнопки Следующего поиска
                                event.accepted = true;//Завершаем обработку эвента.
                            }
                            else{
                                if((event.key === 16777237)||(event.key === 16777239)){//нажата "Page Down",то
                                    var ntStrDown = pdfLoader.item.nomerStranici + 1;
                                    if(ntStrDown < pdfLoader.item.pageCount)
                                        pdfLoader.item.currentPage = ntStrDown;
                                    event.accepted = true;//Завершаем обработку эвента.
                                }
                                else{
                                    if((event.key === 16777235)||(event.key === 16777238)){//нажата "Page Up"
                                        var ntStrUp = pdfLoader.item.nomerStranici - 1;//-1 страница
                                        if(ntStrUp >= 0)//Если больше 0, то листаем к началу документа.
                                            pdfLoader.item.currentPage = ntStrUp;
                                        event.accepted = true;//Завершаем обработку эвента.
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
            pssPassword.strPasswordOld = "";//Обнуляем при закрытии старый пароль.
            pdfLoader.pdfRotation = 0;//0 градусов.
            root.clickedNazad();//Сигнал нажатия кнопки Назад. А потом обнуление.
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
    function fnClickedNazad(){//Функция нажатия кнопки Назад.
        cppqml.strDannieStr = pdfLoader.item.nomerStranici;//Записываем в БД номер открытой страницы.
        fnPdfSource("");//Пустой путь PDF документа, закрываем.
    }
	function fnClickedZakrit(){//Функция обрабатывающая кнопку Закрыть.
		txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
	}
	function fnClickedOk(){//Функция отправить запрос на поиск
		if(cppqml.isPdfPoisk(txnZagolovok.text)){//Если пустой запрос с кучей пробелов, то...
			txnZagolovok.text = "";//Делаем поле запроса на поиск полностью пустым.
 			txnZagolovok.placeholderColor = "#9c3a3a";//Серо красный цвет.
        	txnZagolovok.placeholderText = qsTr("ПУСТОЙ ПОИСКОВЫЙ ЗАПРОС");//Подсказка пользователю.
		}
		else{
			pskPoisk.text = txnZagolovok.text;//текст присваиваем.
			pskPoisk.visible = true;//Делаем видимым режим поиска
			txnZagolovok.visible = false;//Делаем невидимой строку, остальное onVisibleChanged сделает
            pdfLoader.item.searchString = txnZagolovok.text;//Передаём запрос в поисковую модель.
            pdfLoader.item.searchForward();//Показываем следующий результат поиска.
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
    function fnClickedPoisk(){//Функция запуска режима поиска.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ПОИСКОВЫЙ ЗАПРОС");//Подсказка пользователю.
        txnZagolovok.placeholderColor = "#aaa";//Светло серый цвет
        txnZagolovok.visible = true;//Режим запроса на поиск ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
    }
    function fnClickedPoiskNext(){//Функция нажатия кнопки Следующего поиска
        pdfLoader.item.searchForward();//Показываем следующий результат поиска.
    }
    function fnClickedPoiskPrevious(){//Функция нажатия кнопки Предыдущего поиска
        pdfLoader.item.searchBack();//Показываем предыдущий результат поиска.
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
                knopkaPovorotPo.visible = false;//Делаем невидимым кнопку По часовой стрелки.
                knopkaPovorotProtiv.visible = false;//Делаем невидимым кнопку Против часовой стрелки.
                spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
                pdfScale.visible = false;//Делаем невидимым DCScale
                knopkaPoisk.visible = false;//Делаем невидимым кнопку Поиска.
            }
            else{//Если таймер выключен, то...
                ldrProgress.active = false;//Отключаем прогресс. 
                spbPdfPage.visible = true;//Делаем видимым DCSpinBox
                pdfScale.visible = true;//Делаем видимым DCScale
                if(pskPoisk.visible){//Если видим виджет поиска, то...
					knopkaPovorotPo.visible = false;//Делаем невидимым кнопку По часовой стрелки.
                	knopkaPovorotProtiv.visible = false;//Делаем невидимым кнопку Против часовой стрелки.
				}
				else{//Если не видим виджет поиска(например при увеличении), то...
                    knopkaPoisk.visible = true;//Делаем видимым кнопку Поиска.
					knopkaPovorotPo.visible = true;//Делаем видимым кнопку По часовой стрелки.
                	knopkaPovorotProtiv.visible = true;//Делаем видимым кнопку Против часовой стрелки.
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
			}
		}	
        DCKnopkaOk{
			id: knopkaOk
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: tmZagolovok.right
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokPravi
            onClicked: fnClickedOk()//Функция отправить запрос на поиск
		}	
        DCPoisk {
            id: pskPoisk
            anchors.top: tmZagolovok.top; anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left; anchors.right: tmZagolovok.right
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false//Невидимый виджет.
            clrFona: root.clrFona; clrTexta: "yellow"; clrKnopki: "yellow"; clrBorder: root.clrTexta
            tapKnopkaZakrit: 1.3; tapKnopkaVniz: 1.3; tapKnopkaVverh: 1.3
            onClickedNext: fnClickedPoiskNext()//Функция нажатия кнопки Следующего поиска
			onClickedPrevious: fnClickedPoiskPrevious()//Функция нажатия кнопки Предыдущего поиска
            onClickedZakrit: {//Слот нажатия кнопки Отмены режима поиска. 
                root.focus = true;//Фокус на основной странице, чтоб горячие клавиши работали.
                pskPoisk.visible = false;//Делаем невидимый режим Поиска, и только после этого...
                knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                knopkaOk.visible = false;//Кнопка Ок Невидимая.
				knopkaNazad.visible = true;//Кнопка назад видимая.
                knopkaPovorotPo.visible = true;//Делаем видимым кнопку По часовой стрелки.
                knopkaPovorotProtiv.visible = true;//Делаем видимым кнопку Против часовой стрелки.
                knopkaPoisk.visible = true;//Конопка Поиск Видимая.
                txnZagolovok.text = "";//Текст обнуляем вводимый.
                pdfLoader.item.searchString = "";//Передаём пустой запрос в поисковую модель.
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
            clrKnopki: root.clrTexta; clrFona: root.clrFona
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapZagolovokPravi
            onClicked: fnClickedPovorotPo();//Функция нажатия кнопки поворота по часовой стрелке. 
        }
        DCKnopkaPovorotProtiv {
            id: knopkaPovorotProtiv
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter; anchors.right: knopkaPovorotPo.left
            clrKnopki: root.clrTexta; clrFona: root.clrFona
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
            clrKnopki: "yellow";clrBorder:"yellow"
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
        DCLogoTMK {//Логотип до ZonaFileDialog, чтоб не перекрывать список.
			id: lgTMK
			ntCoff: root.ntLogoTMK
			anchors.centerIn: tmZona
            clrLogo: root.clrTexta; clrFona: root.clrFona
		}
        Loader {//Loader динамической загрузки PDF Viewer
            id: pdfLoader
            //Свойства.
            property string strPdfPut: ""//Путь к документу,который нужно открыть или пустой путь,чтоб закрыть
            property bool blClose: true//true - закрываем документ.
            property int pdfRotation: 0//Угол поворота (может быть: 0, 90, 180, 270)
            //Настройки.
            anchors.fill: tmZona
            source: pdfLoader.blClose ? "" : "qrc:/qml/DCMethods/DCPdfMPV.qml"//Указываем путь отдельному QMl
            active: false//не активирован.

            onLoaded: { 
                pdfLoader.item.currentPage = cppqml.strDannieStr;//Считываем из БД номер странцы документа.
                pdfLoader.item.source = pdfLoader.strPdfPut;// Устанавливаем путь к PDF
            }
        }
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
                if(root.pdfViewer){//Если выбран в настройках собственный просмотрщик, то...
                    tmrLogo.running = true;//Запускаем таймер анимации логотипа
                    pssPassword.passTrue = true;//Пароль верный, текс стандартный, надпись стандартная.
                    var strPdfUrl = cppqml.strDannieUrl;//Считываем путь+документ.pdf
                    fnPdfSource(strPdfUrl);//Передаём путь к pdf документу и тем самым его открываем.
                    //console.error("390: Url: " + strPdfUrl);
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
                    lgTMK.ntCoff = root.ntLogoTMK;//Задаём размер логотипа.
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
                if(ldrProgress.item)
                    ldrProgress.item.progress = ntProgress;//Отправляем прогресс загрузки в DCProgress.
                if(ldrProgress.item)
                    ldrProgress.item.text = strStatus;//Выводим статус загрузки документа.
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
			border.width: root.ntCoff/4//Бордюр при переименовании и удалении.
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
                ldrProgress.item.clrProgress = root.clrTexta; ldrProgress.item.clrTexta = "grey";
            }
        }
        DCSpinBox {
			id: spbPdfPage
            ntWidth: root.ntWidth; ntCoff: root.ntCoff
			visible: false 
            anchors.verticalCenter: tmToolbar.verticalCenter; anchors.left: tmToolbar.left
            anchors.margins: root.ntCoff/2
            clrTexta: root.clrTexta; clrFona: root.clrFona
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
            from: 1; to: 200; value: 100; stepSize: 25
            tapKnopkaMinus: root.tapToolbarPravi; tapKnopkaPlus: root.tapToolbarPravi
            onValueModified: pdfLoader.item.renderScale = value/100;//Масштабируем документ по значению value
		}
	}
}
