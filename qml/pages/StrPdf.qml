import QtQuick //2.15
import QtQuick.Pdf //5.15

import "qrc:/qml"//Импортируем основные элементы qml
import "qrc:/qml/buttons"//Импортируем кнопки
import "qrc:/qml/methods"//Импортируем методы написанные мной.
//Страница просмотра PDF документов.
Item {
	id: root
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

    property bool pdfViewer: false//true - собственный просмотщик pdf документов.

    property int ntLogoTMK: 16
    property bool blLogoTMK: false//true - логотип на увеличение.
    //Расчитываемые при открытии/закрытии pdf документа.
    property bool blClose: true//true - закрываем документ.
    property string strPdfPut: ""//Пустой путь к pdf документу.
    property int currentPage: 0//Номер страницы из БД, которую нужно открыть.

    anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад

    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.key === Qt.Key_Escape){//Если нажата на странице кнопка Escape, то...
			if(txnZagolovok.visible)//Если строка ввода запроса на поиск видима, то...
				fnClickedZakrit();//Закрываем эту строку
        }
        /*
		if((event.key === 16777237)||(event.key === 16777239)){//Если нажата "Page Down",то.
            var ntStrDown = ldrDoc.item.currentPage + 1;
            if(ntStrDown < pdfDoc.pageCount)
                fnPdfGoToPage(ntStrDown);
			
        }
		if((event.key === 16777235)||(event.key === 16777238)){//Если нажата "Page Up", то.
            var ntStrUp = ldrDoc.item.currentPage - 1;//-1 страница
            if(ntStrUp >= 0)//Если больше 0, то листаем к началу документа.
                fnPdfGoToPage(ntStrUp);//На -1 страницу.
		}
        */
        //cppqml.strDebug = event.key;
    }
    MouseArea {//Если кликнуть на пустую зону, свернётся Меню. Объявлять в начале Item. До других MouseArea.
        anchors.fill: root
        //onClicked:
    }

    function fnPdfSource(urlPdfPut){//управление свойствами загруженного компонента
        root.strPdfPut = urlPdfPut;//Устанавливаем путь.
        if(urlPdfPut){//Если путь не пустая строка, то...
            root.blClose = false;//Не закрываем Загрузчик.
            pdfLoader.active = true;
        }
        else{//Если путь пустая строка, то...
            console.error("71:fnNazad. закрываем pdf документ.");
            root.clickedNazad();//Сигнал нажатия кнопки Назад. А потом обнуление.
            root.blClose = true;//закрываем Загрузчик.
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

	function fnPdfOtkrit(){//Функция открытия Pdf документа.
        var strPdfUrl = cppqml.strDannieUrl;//Считываем путь+документ.pdf
        fnPdfSource(strPdfUrl);//Передаём путь к pdf документу и тем самым его открываем.
        //console.error("81: Url: " + strPdfUrl);

		//Порядок вызова переменных, чтоб документы повторно открывались с первой страницы и не зависали.
		//1) root.blClose = false;
		//2) ldrDoc.active = true;
		//3)tmrLogo.running = true;
		//4) pdfDoc.source = strPdfUrl;
        //tmrLogo.running = true;//включаем таймер  и тем самым не показываем документ и кнопки
        //pdfDoc.source = strPdfUrl;//Добавляем ссылку на документ.

        spbPdfPage.from = 1;//Задаём минимальное количество страниц в DCSpinBox
        //spbPdfPage.to = pdfDoc.pageCount;//Задаём максимальное количество страниц в DCSpinBox
    }

    Timer {//таймер бесконечной анимации логотипа, пока не будет результат.
        id: tmrLogo
        interval: 110
        running: false
        repeat: true
        onTriggered: {
            if(root.blLogoTMK){//Если true, то...
                lgTMK.ntCoff++;
                if(lgTMK.ntCoff >= root.ntLogoTMK)
                    root.blLogoTMK = false;
            }
            else{
                lgTMK.ntCoff--;
                if(lgTMK.ntCoff <= 1)
                    root.blLogoTMK = true;
            }
        }
        onRunningChanged: {//Если таймер изменился, то...
            if(running){//Если запустился таймер, то...
                spbPdfPage.visible = false;//Делаем невидимым DCSpinBox
                pdfScale.visible = false;//Делаем невидимым DCScale
                //ldrDoc.item.visible = false;//Делаем отображение сцены невидимой.
            }
            else{//Если таймер выключен, то...
                spbPdfPage.visible = true;//Делаем видимым DCSpinBox
                pdfScale.visible = true;//Делаем видимым DCScale
                //ldrDoc.item.visible = true;//Делаем отображение сцены видимой.
            }
        }
    } 
	function fnClickedPoisk(){//Функция обрабатывающая кнопку Поиск.
        txnZagolovok.placeholderText = qsTr("ВВЕДИТЕ ПОИСКОВЫЙ ЗАПРОС");//Подсказка пользователю,что вводить нужно
 		txnZagolovok.placeholderColor = "#aaa";//Светло серый цвет
        txnZagolovok.visible = true;//Режим запроса на поиск ТОЛЬКО ПОСЛЕ НАЗНАЧЕНИЯ ТЕКСТА!!!
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
            //ldrDoc.item.searchString = txnZagolovok.text;//Передаём запрос в поисковую модель.
            //ldrDoc.item.searchForward();//Показываем следующий результат поиска.
		}
	}
	Item {
		id: tmZagolovok
        DCKnopkaNazad {//@disable-check M300
			id: knopkaNazad
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			onClicked: {
                cppqml.strDannieStr = pdfLoader.item.nomerStranici;//Записываем в БД номер открытой страницы.
                fnPdfSource("");//Пустой путь PDF документа, закрываем.
			}
		}	
		DCKnopkaZakrit {//@disable-check M300
            id: knopkaZakrit
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            visible: false
            anchors.verticalCenter: tmZagolovok.verticalCenter
            anchors.left: tmZagolovok.left
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            onClicked: {//Слот сигнала clicked кнопки Создать.
                fnClickedZakrit();//Функция обрабатывающая кнопку Закрыть.
            }
        }
		Item {
			id: tmTextInput
			anchors.top: tmZagolovok.top
			anchors.bottom: tmZagolovok.bottom
			anchors.left: knopkaNazad.right
			anchors.right: knopkaPoisk.left
			anchors.topMargin: root.ntCoff/4
			anchors.bottomMargin: root.ntCoff/4
			anchors.leftMargin: root.ntCoff/2
			anchors.rightMargin: root.ntCoff/2
            DCTextInput {//@disable-check M300
				id: txnZagolovok
				ntWidth: root.ntWidth
				ntCoff: root.ntCoff
				anchors.fill: tmTextInput
				visible: false
                clrTexta: root.clrTexta
				clrFona: "SlateGray"
				radius: root.ntCoff/2
				blSqlProtect: false//Отключаем защиту от Sql инъекций, вводить можно любой текст.
                textInput.maximumLength: cppqml.untNastroikiMaxLength
				onVisibleChanged: {//Если видимость DCTextInput изменился, то...
                    if(txnZagolovok.visible){//Если DCTextInput видимый, то...
                        knopkaNazad.visible = false;//Кнопка назад Невидимая.
                        knopkaPoisk.visible = false;//Конопка Поиск Невидимая.
                        knopkaZakrit.visible = true;//Кнопка закрыть Видимая
                        knopkaOk.visible = true;//Кнопка Ок Видимая.
					}
                    else{//Если DCTextInput не видим, то...
                        knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                        knopkaOk.visible = false;//Кнопка Ок Невидимая.
						if(!pskPoisk.visible){//Если не открыли Режим поиска, то...
							console.error("Режим поиск невидимый");
							knopkaNazad.visible = true;//Кнопка назад видимая.
							knopkaPoisk.visible = true;//Конопка Поиск Видимая.
							knopkaPoisk.focus = true;//Фокус на кнопке Информация, чтоб не работал Enter.
                        	txnZagolovok.text = "";//Текст обнуляем вводимый.
						}
					}
				}
				onClickedEnter: {//слот нажатия кнопки Enter.
					fnClickedOk();//Функция отправить запрос на поиск
				}
			}
		}	
		DCKnopkaOk{//@disable-check M300
			id: knopkaOk
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			visible: false
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: root.ntCoff/2
			clrKnopki: root.clrTexta
			clrFona: root.clrFona
			onClicked: {
				fnClickedOk();//Функция отправить запрос на поиск
			}
		}	
		DCPoisk {//@disable-check M300
            id: pskPoisk
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

			visible: false//Невидимый виджет.

            clrFona: "black"//Если не задать цвет, будет видно текст под надписью
            clrTexta: "yellow"
            clrKnopki: "yellow"
            clrBorder: "orange"
            onClickedNext: {//Слот нажатия кнопки Следующего поиска
                //ldrDoc.item.searchForward();//Показываем следующий результат поиска.
			}
			onClickedPrevious: {//Слот нажатия кнопки Предыдущего поиска
                //ldrDoc.item.searchBack();//Показываем предыдущий результат поиска.
            }
            onClickedZakrit: {//Слот нажатия кнопки Отмены режима поиска. 
                pskPoisk.visible = false;//Делаем невидимый режим Поиска, и только после этого...
                knopkaZakrit.visible = false;//Кнопка закрыть Невидимая
                knopkaOk.visible = false;//Кнопка Ок Невидимая.
				knopkaNazad.visible = true;//Кнопка назад видимая.
				knopkaPoisk.visible = true;//Конопка Поиск Видимая.
				knopkaPoisk.focus = true;//Фокус на кнопке поиск, чтоб не работал Enter.
                txnZagolovok.text = "";//Текст обнуляем вводимый.
                //ldrDoc.item.searchString = "";//Передаём пустой запрос в поисковую модель.
            }
        }
        DCKnopkaPoisk{//@disable-check M300
            id: knopkaPoisk
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
            anchors.margins: root.ntCoff/2
            clrKnopki: root.clrTexta
            clrFona: root.clrFona
            onClicked: {//Слот сигнала clicked кнопки Поиск.
                fnClickedPoisk();//Функция обрабатывающая кнопку Поиск.
            }
        }
        DCPassword{//@disable-check M300
            id: pssPassword
            anchors.top: tmZagolovok.top
            anchors.bottom: tmZagolovok.bottom
            anchors.left: tmZagolovok.left
            anchors.right: tmZagolovok.right

            anchors.topMargin: root.ntCoff/4
            anchors.bottomMargin: root.ntCoff/4
            anchors.leftMargin: root.ntCoff/2
            anchors.rightMargin: root.ntCoff/2

            ntWidth: root.ntWidth
            ntCoff: root.ntCoff

			visible: false//Невидимый виджет.

            clrFona: "black"
            clrFonaPass: "orange"
            clrTexta: "black"
            clrKnopki: "yellow"
            clrBorder: "yellow"
            placeholderTextTrue: qsTr("ВВЕДИТЕ ПАРОЛЬ ДОКУМЕНТА")
            placeholderTextFalse: qsTr("НЕВЕРНЫЙ ПАРОЛЬ ДОКУМЕНТА")
            onClickedOk: function (strPassword)  {//Слот нажатия кнопки Ок
                //pdfDoc.password = strPassword;//Передаём пароль в документ.
                pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                pssPassword.passTrue = false;//Делаем крассным, если пароль верный, никто не увидит.
                fnPdfOtkrit();
            }
            onClickedOtmena: {//Слот нажатия кнопки Отмены Удаления
                pssPassword.visible = false;//Делаем невидимым виджет
                pssPassword.password = "";//Обнуляем вводимый пароль в TextInput.
                fnPdfSource("");//Закрываем страницу.
            }
			onVisibleChanged: {//Если видимость изменилась, то...
				if(pssPassword.visible){
                    spbPdfPage.spinBox.readOnly = true;//запрещаем редактировать для Android.
				}
				else{
                    spbPdfPage.spinBox.readOnly = false;//разрешаем редактировать для Android.
				}
			}
        }
	}
	Item {
		id: tmZona
        //anchors.top: tmZagolovok.bottom
        //anchors.left: root.left
        //anchors.right: root.right
        //anchors.bottom: tmToolbar.top
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.	
        DCLogoTMK {//@disable-check M300//Логотип до ZonaFileDialog, чтоб не перекрывать список.
			id: lgTMK
			ntCoff: root.ntLogoTMK
			anchors.centerIn: tmZona
			clrLogo: root.clrTexta
			clrFona: root.clrFona
		}
        Loader {//Loader динамической загрузки PDF Viewer
            id: pdfLoader
            anchors.fill: tmZona
            source: root.blClose ? "" : "qrc:/qml/methods/DCPdfMPV.qml"//Указываем путь к отдельному QML-файлу
            active: false//не активирован.
            onLoaded: {
                pdfLoader.item.currentPage = cppqml.strDannieStr;//Считываем из БД номер странцы документа.
                //pdfLoader.item.currentPage = root.currentPage;//
                pdfLoader.item.source = root.strPdfPut;// Устанавливаем путь к PDF
            }
        }
        Connections {//Соединение сигналов из qml файла со слотами.
            target: pdfLoader.item
            function onSgnError() {//Ошибка при открытии документа
                //tmrLogo.running = false;//Останавливаем таймер главной анимации.
                fnPdfSource("");//Пустой путь PDF документа, закрываем.
            }
            function onSgnDebug(strDebug){//Пришла ошибка из qml файла.
                //cppqml.strDebug = strDebug;//Отображаем ошибку.
                console.error(strDebug);//Отображаем ошибку.
            }
            function onSgnVisible(){//Изменилась видимость виджета отображения pdf документа.
                if(pdfLoader.item.visible){//Виджет видимый.
                    //tmrLogo.running = false;//отключаем таймер, и тем самым показываем документ и кнопки.
                    //root.blLogoTMK = false;//Делаем флаг анимации логотипа ТМК на уменьшение.
                    //lgTMK.ntCoff = ntLogoTMK;//Задаём размер логотипа.
                }
                else{//Виджет не видимый.
                    //tmrLogo.running = true;//Запускаем таймер анимации логотипа
                }
            }
            function onSgnCurrentPage(ntStranica){//Изменился номер страницы
                console.error("Страница: " + (ntStranica + 1));
                //spbPdfPage.value = ntStranica + 1//В DCSpinBox выставляем значение страницы.
            }
            function onSgnRenderScale(rlMasshtab){//Изменился масштаб документа.
                var ntScale = rlMasshtab*100;//Чтоб несколько раз не вызывать, так быстрее.
                console.error("Масштаб: " + ntScale);
                //pdfScale.from = ntScale;//Выставляем минимальное значение масштаба по уст. масштабу документа.
                //pdfScale.value = ntScale;//И только после pdfScale.from выставляем значение масштаба в DCScale
            }
            function onSgnPassword(){//Произошёл запрос на ввод пароля.
                console.error("Введите пожалуйста пароль.");
                //pssPassword.visible = true;//Делаем видимым поле ввода пароля.
            }
        }
		Rectangle {//Это граница документа очерченая линией для красоты.
			id: rctBorder
			anchors.fill: tmZona
			color: "transparent"
			border.color: root.clrTexta
			border.width: root.ntCoff/4//Бордюр при переименовании и удалении.
		}
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieChanged(){//Слот Если изменился элемент списка в strDannie (Q_PROPERTY), то...
                //Первоначальная иннициализация флагов.
                pssPassword.passTrue = true;//Пароль верный, текс стандартный, надпись стандартная.
                root.blLogoTMK = false;//логотип на уменьшение.
                //root.currentPage = cppqml.strDannieStr;//Считываем из БД номер странцы документа.
                //Если отключен запуск анимации, то эти строки необходимы.
                spbPdfPage.visible = true;//Делаем видимым DCSpinBox
                pdfScale.visible = true;//Делаем видимым DCScale
                if(root.pdfViewer)//Если выбран в настройках собственный просмотрщик, то...
                    fnPdfOtkrit();//Функция открытия Pdf документа.
			}
		}
	}
    Item {//Тулбар
		id: tmToolbar
        DCSpinBox {//@disable-check M300
			id: spbPdfPage
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			visible: false 
            anchors.verticalCenter: tmToolbar.verticalCenter
            anchors.left: tmToolbar.left
            anchors.margins: root.ntCoff/2
			clrTexta: root.clrTexta
			clrFona: root.clrFona 
			radius: root.ntCoff/2
			from: 1
			value: 1
			spinBox.cursorVisible: true;//Делаем курсор видимым обязательно.
			onValueModified:{//Если значение измениловь в DCSpinBox...
                //fnPdfGoToPage(value-1)
			}
		}
        DCScale{//@disable-check M300
			id: pdfScale
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			anchors.verticalCenter: tmToolbar.verticalCenter
			anchors.right: tmToolbar.right
			visible: true
			clrTexta: root.clrTexta
			clrFona: root.clrFona 
			radius: root.ntCoff/2
			from: 25
			to: 200
			value: 100
			stepSize: 25
			scale.cursorVisible: true;//Делаем курсор видимым обязательно.
			onValueModified:{//Если значение измениловь в DCScale...
                //fnScale(true);//Масштабируем документ по значению value этого виджета.
			}	
		}
	}
}
