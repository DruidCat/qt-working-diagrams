import QtQuick
import QtQuick.Pdf
import QtQuick.Controls
import DCButtons 1.0//Импортируем кнопки

Item {
    id: root
    //Свойства.
    property string source: ""// Свойство для установки пути к PDF
    property string password: ""//Пароль для pdf документа.
    property real renderScale: 1//Коэффициень масштаба 1.
    property int currentPage : -1//Номер страницы устанавливаемый вне виджет(set).(не путать с ntStranica)
    property alias nomerStranici: pmpDoc.currentPage//Номер страницы внутри виджета(get).
    property alias pageCount: pdfDoc.pageCount//Общее количество страниц в документе.
    property alias searchString: pmpDoc.searchString//Запрос на поиск.
    property int searchCount: cppqml.pdfPoisk.ntSchetchik//Количество совпадений при поиске.
    property bool isSearch: cppqml.pdfPoisk.isPoisk//true - поиск идёт, false - поиск остановлен.
    property alias rotation: pmpDoc.rotation//Поворот сцены документа.
    property alias pageRotation: pmpDoc.pageRotation//Поворот страниц документа.
    property alias straniciVisible: rctStranici.visible//Вкл/Выкл дополнительное окно с количеством страниц.
    property int ntWidth: 1//Длина символа для боковой панели
    property int ntCoff: 8//Коэффициент для боковой панели
    property color clrTexta: "Orange"
    property color clrFona: "Black"
    property color clrMenuFon: "SlateGray"
    property bool isMobile: true//true - мобильная платформа.
    //Настройки
    anchors.fill: parent
    visible: false//по умолчанию он невидимый.
    //Сигналы.
    signal sgnError()//Закрываем pdf документ.
    signal sgnDebug(string strDebug)//Передаём ошибку.
    signal sgnCurrentPage(int ntStranica)//Сигнал возвращающий номер страницы документа.
    signal sgnScaleMin(real rlScaleMin)//Сигнал возвращающий минимальный масштаб страницы.
    signal sgnPassword()//Сигнал о том, что запрашивается пароль.
    signal sgnProgress(int ntProgress, string strStatus)//Сигнал возвращающий загрузку документа и его статус.
    signal clickedSidebar()//Сигнал о нажатии боковой панели.
    //Функции.
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if(event.modifiers & Qt.ControlModifier){//Если нажат "Ctrl"
            if(event.key === Qt.Key_C){//Если нажата "C",то...
                fnCopyToClipboard();//Копируем выделенный текст в документа в буфер обмена.
                event.accepted = true;//Завершаем обработку эвента.
            }
            else{
                if(event.key === Qt.Key_B){//Если нажата клавиша "B", то...
                    root.clickedSidebar();//Сигнал - Открываем боковую панель.
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
        }
        else{
            if((event.key === 16777237)||(event.key === 16777239)){//Если нажата "Page Down",то.
                var ntStrDown = pmpDoc.currentPage + 1;
                if(ntStrDown < root.pageCount)
                    root.currentPage = ntStrDown;
                event.accepted = true;//Завершаем обработку эвента.
            }
            else{
                 if((event.key === 16777235)||(event.key === 16777238)){//Если нажата "Page Up", то.
                    var ntStrUp = pmpDoc.currentPage - 1;//-1 страница
                    if(ntStrUp >= 0)//Если больше 0, то листаем к началу документа.
                        root.currentPage = ntStrUp;
                    event.accepted = true;//Завершаем обработку эвента.
                }
            }
        }
        //cppqml.strDebug = event.key;
    }
    function fnCopyToClipboard(){//Функция копирования выделенного текста в буфер обмена.
        if(pmpDoc.selectedText !== "")//Если выбранный текст не пустота, то...
            pmpDoc.copySelectionToClipboard()//Копировать выделенный текст в документе
    }
    function fnSidebar(){//Функция открывающая/закрывающая боковую панель.
        if(!drwSidebar.position){//Если не открыта панель боковая, то открываем.
            drwSidebar.open()//Открываем боковую панель.
            root.forceActiveFocus()
        }
        else{
            drwSidebar.close()//Закрываем боковую панель
        }
    }

    onRenderScaleChanged: {//Если масштаб поменялся из вне, то...
        if(!pmpDoc.blRenderScale){//Если не взведён флаг, обрабатываем из вне данные.
            pmpDoc.ntPdfPage = pmpDoc.currentPage;//Сохраняем действующую страницу.
            root.visible = false;//Невидимый виджет.
            pmpDoc.blScaleAuto = false;//Ручное масштабирование, обязательно перед таймером.
            console.error("49: 3. Старт таймера масштабирования.");
            root.sgnProgress(28, "3/11 Старт таймера масштабирования.");
            tmrScale.running = true;//Запускаем таймер перед масштабированием, чтоб сцена успела исчезнуть.
        }
        else{//Если внутреннее изменение масштаба, то...
            if(pmpDoc.blScaleAuto)//Если это автоматическое изменение масштаба, то...
                    root.sgnScaleMin(pmpDoc.renderScale);//Передаём значение минимального масштаба.
        }
    }
    onCurrentPageChanged: {//Если страница поменялась из вне, то...
        console.error("59: Страница " + root.currentPage + " из вне.");
        if(pmpDoc.blStranica)//Первоначальная установка страницы при загрузке документа
            pmpDoc.blStranica = false;//Сбрасываем флаг.
        else//Если изменение страницы не в первый раз, то...
            fnGoToPage(root.currentPage);//Переходим на заданную страницу.
    }
	onRotationChanged:{//Изменение поворота документа.
        Qt.callLater(function() {//Пауза в такт. Чтоб успела повернуться сцена, и перерасчет сторон произошёл.
            pmpDoc.blRotation = true;//Изменился поворот документа.
			pmpDoc.ntPdfPage = pmpDoc.currentPage;//Сохраняем действующую страницу.
            root.visible = false;//Невидимый виджет.
            pmpDoc.blScaleAuto = true;//Автоматическое масштабирование, обязательно перед таймером.
            console.error("69: 3. Старт таймера масштабирования.");
            root.sgnProgress(28, "3/11 Старт таймера масштабирования.");
            tmrScale.running = true;//Запускаем таймер перед масштабированием, чтоб сцена успела исчезнуть. 
        })
	}
    onSourceChanged: {//Когда меняется источник документа — обновим C++ поиск
        if(root.source && root.source !== "")
            cppqml.pdfPoisk.urlPdf = root.source//Отправляем адрес файла в бизнес логику.
    }
    onSearchStringChanged: {//Когда меняется поисковая строка — отдадим её в C++
        cppqml.pdfPoisk.strPoisk = root.searchString;//Отправляем поисковый запрос в бизнес логику.
    }
    onWidthChanged:{//Первое изменение при открытии окна и последнее изменения при закрытии окна.
        if(width > 0){//Если ширина больше 0, это не формирование при старте окна, то...
            if(pmpDoc.blStartWidth)//Окно открылось, не обрабатываем сигнал об изменении..
                pmpDoc.blStartWidth = false;//Взводим флаг на оброботку размера.
            else
                fnTimerAppSize();//Запускаем таймер.
        }
    }
    onHeightChanged:{//Первое изменение при открытии окна и последнее изменения при закрытии окна.
        if(height > 0){//Если высота больше 0, это не формирование при старте окна, то...
            if(pmpDoc.blStartHeight)//Окно открылось, не обрабатываем сигнал об изменении..
                pmpDoc.blStartHeight = false;//Взводим флаг на оброботку размера.
            else
                fnTimerAppSize();//Запускаем таймер.
        }
    }

    function searchForward(){//Функция следующего поиска, пробрасываем вне виджета.
        pmpDoc.searchForward();
    }
    function searchBack(){//Функция предыдущего поиска, пробрасываем вне виджета.
        pmpDoc.searchBack();
    }
    function fnTimerAppSize(){//Функция старта таймера при изменении размеров приложения пользователем.
        if(!pmpDoc.blSize){//Принимаю размеры приложения, пока не запустится обработкик показа документа.
            if(!tmrAppSize.running){//Если таймер еще не запускался, то...
                pmpDoc.ntPdfPage = pmpDoc.currentPage;//Сохраняем действующую страницу.
                console.error("100: 4. Изменился размер окна.");
                root.sgnProgress(37, "4/11 Изменился размер окна.")
                root.visible = false;//Невидимым виджет делаем.
            }
            tmrAppSize.restart();//Таймер перезапускаем.
        }
    }
    function fnScale(){//Функция авто/руч. масштабирования в зависимости от формата pdf документа.
        pmpDoc.blScaleStart = true;//Начало масштабирования.
        pmpDoc.goToPage(0);//Переходим на первую страницу, чтоб потом перейти на заданную страницу.
        console.error("110: 5. Начало масштабирования документа.");
        root.sgnProgress(46, "5/11 Начало масштабирования документа.");
        if(pmpDoc.blScaleAuto){//Если автоматический режим, то...
            var widthRect = pmpDoc.childrenRect.width;
            var heightRect = pmpDoc.childrenRect.height;
            if(pmpDoc.blDocVert){//Если вертикальная страница, то...
				if((root.rotation === 0) || (root.rotation === 180))//Если поворот нулевой или 180 градусов,то
                	pmpDoc.scaleToPage(widthRect, heightRect);//масштаб по высоте страницы.
				else//Если поворот 90 или 270 градусов, то...
                	pmpDoc.scaleToWidth(widthRect, heightRect);//Масштаб по ширине страницы.
			}
            else{//Если горизонтальная страница, то...
				if((root.rotation === 0) || (root.rotation === 180))//Если поворот нулевой или 180 градусов,то
                	pmpDoc.scaleToWidth(widthRect, heightRect);//Масштаб по ширине страницы.
				else//Если поворот 90 или 270 градусов, то...
                	pmpDoc.scaleToPage(widthRect, heightRect);//масштаб по высоте страницы.
			}
        }
        else
            pmpDoc.renderScale = root.renderScale;//Выставляем масштаб из Свойства.
        console.error("130: 6. Окончание масштабирования документа.")
        root.sgnProgress(55, "6/11 Остановка анимации: ожидайте.");
        tmrResetScene.running = true;//запускаем таймер, сброса сцены.
    }
    function fnGoToPage(ntPage){//Функция обрабатывающая переход на новую страницу документа.
        console.error("135: 10. Переходим на страницу: " + ntPage);
        root.sgnProgress(91, "10/11 Переходим на страницу.");
        pmpDoc.goToLocation(ntPage, Qt.point(0, 0), pmpDoc.renderScale);//Переходим на страницу.
        console.error("138: 11. Старт таймера видимости.");
        root.sgnProgress(100, "11/11 Старт таймера отображения.");
        tmrVisible.running = true;//Запускаем таймер отображения документа.
    }
    Timer {//Таймер необходим, чтоб
        id: tmrResetScene
        interval: 3; running: false; repeat: false
        onTriggered: {
            console.error("146: 7. Сброс сцены документа.")
            root.sgnProgress(64, "7/11 Сброс сцены документа.");
            /*
            const curPage   = pmpDoc.currentPage
            const curScale  = pmpDoc.renderScale
            const curPoint  = Qt.point(0, 0)      // можно сохранить scroll-offset
            Qt.callLater(function() {
                    pmpDoc.renderScale = curScale+0.001
                    pmpDoc.goToLocation(curPage, curPoint, curScale)
            })
            */
            //Это быстрый способ сброса сцены, но с ошибками в консоли, так как документ обнуляется.
            const doc = pmpDoc.document;//Запоминаем pdf документ.
            pmpDoc.document = null;//Выставляем нулевой документ, и тем самым сбрасываем сцену.
            pmpDoc.document = doc;//Восстанавливаем старый документ с обновлённой сценой.
            pmpDoc.blScaleStart = false;//Окончание масштабирования, это для щипка.
            /*
            //Это очень медленный способ, даже на быстром компьютере, но без ошибок. На Android падает app
            pmpDoc.anchors.fill = undefined;//Не определен якорь.
            pmpDoc.width = pdfDoc.pagePointSize(0).width * pmpDoc.renderScale;//Задаём посчитанную длину.
            pmpDoc.height = pdfDoc.pagePointSize(0).height * pmpDoc.renderScale * pdfDoc.pageCount//Ширину
            pmpDoc.anchors.fill = parent;//Растягиваем pmpDoc, и тем самым пересчитываем Сцену.
            */
            console.error("169: 8. Старт таймера страницы.")
            root.sgnProgress(73, "8/11 Старт таймера страницы.");
            tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
        }
    }
    Timer {//Таймер необходим, чтоб пока пользователь изменяет размер окна приложения,не обрабатывался масштаб
        id: tmrAppSize
        interval: 333; running: false; repeat: false
        onTriggered: {
            pmpDoc.blSize = true;//Открываем документ, игнорируя изменения размера приложения.
            pmpDoc.blScaleAuto = true;//Автоматический режим масштабирования по размеру виджета
            fnScale();//Выставляем масштаб по ширине или по высоте в зависимости от размера документа.
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел загрузиться, и можно было масштабировать документ.
        id: tmrScale
        interval: 111; running: false; repeat: false
        onTriggered: {
            console.error("187: 4. Стоп таймера масштабирования.");
            root.sgnProgress(37, "4/11 Стоп таймера масштабирования.");
            fnScale();//масштабируем документ автоматически/вручную.
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел смаштабироваться, и можно было выставить страницу.
        id: tmrGoToPage
        interval: 777; running: false; repeat: false
        onTriggered: {
            console.error("196: 9. Стоп таймера страницы.");
            root.sgnProgress(82, "9/11 Стоп таймера страницы.");
            if(pmpDoc.blPinch){//Если был щипок пользователя с изменением Масштаба, то...
                pmpDoc.blPinch = false;//Сбрасываем флаг
                fnGoToPage(pmpDoc.ntPinchPage);//Выставляем запомненную страницу после щипка
            }
            else{//Если не было щипка пользователя, то...
                if(pmpDoc.blSize)//Если идет изменение масштаба через изменение размера виджета, то...
                    fnGoToPage(pmpDoc.ntPdfPage);//Выставляем запомненную страницу из виджита
                else{//Если нет, то...
                    if(pmpDoc.blScaleAuto){//Если масштабирование Автоматическое при старте, то...
						if(pmpDoc.blRotation)//Если нажат поворот документа, то..
                        	fnGoToPage(pmpDoc.ntPdfPage);//Выставляем запомненную страницу из виджита
						else//Если не нажат поворот, то это автоматическое масштабирование, и поэтому...
                        	fnGoToPage(root.currentPage);//Выставляем заданную страницу из вне виджита.
					}
                    else//Если Ручное масштабирование пользователем, то...
                        fnGoToPage(pmpDoc.ntPdfPage);//Выставляем запомненную страницу из виджита
                }
            }
        }
    }
    Timer {//Таймер необходим, чтоб после перехода на страницу произошла небольшая пауза, минимум 333.
        id: tmrVisible
        interval: 333; running: false; repeat: false
        onTriggered: {
            console.error("218: Отображаем ваш документ.");
            pmpDoc.blSize = false;//Готов к изменению размера приложения.
			pmpDoc.blRotation = false;//Сбрасываем флаг поворота документа.
            root.visible = true;//Видимый виджет
            //forceActiveFocus();//Виджет видимый, форсируем фокус, чтоб event работал.
        }
    }
    Timer {//Таймер необходим, чтоб чтоб после аварии закрыть страницу.
        id: tmrError
        interval: 111; running: false; repeat: false
        onTriggered: {
            console.error("228: 11. Ошибка, окончание загрузки.");
            root.sgnProgress(100, "11/11 Ошибка, окончание загрузки.");
            if(pmpDoc.blPassword){//Если был запрос на пароль, то...
                pmpDoc.blPassword = false;//Сбрасываем флаг.
            }
            else{//Если не было запроса на пароль, то это ошибка обычная...
                root.sgnDebug(qsTr("Ошибка открытия документа: ") + pdfDoc.error);//Передаём ошибку.
                root.sgnError();//Закрываем документ.
            }
        }
    }
    PdfMultiPageView {
        id: pmpDoc
        anchors.fill: root
        anchors.leftMargin: drwSidebar.position * drwSidebar.width-drwSidebar.position*root.ntCoff
        searchString: ""
        //Иннициализация Свойств при каждой загрузке, от сюда берутся первоначальные данные Свойств.
        property bool blResetScene: false//false - быстрый сброс сцены при первом открытии pdf документа.
        property bool blDocVert: true//true - вертикальный документ, false - горизонтальный документ.
        property bool blScale: false//true - когда в pdf документе масштабирование произошло.
        property bool blRenderScale: false//Флаг предотвращающий рекурсию root.renderScale
        property bool blScaleAuto: true//true - автоматическое масштабирование. false - ручное масштабирование
        property bool blScaleStart: false//true - когда pdf документ изменяет масштаб.
        property bool blPinch: false//true - когда пользователь щипком изменил масштаб.
        property bool blSize: false//true - когда pdf документ изменяет размер при масштабе виджета.
        property bool blStartWidth: true//true - пришёл сигнал об измении ширины виджета при его открытии.
        property bool blStartHeight: true//true - пришёл сигнал об измении высоты виджета при его открытии.
        property bool blStranica: true//true-чтоб не обрабатывать первоначально заданную страницу в прерывании
		property bool blRotation: false//true - нажата кнопка поворота документа.
        property int ntPdfPage: 0//Номер страницы запомненный перед изменением масштаба root.renderScale.
        property int ntPinchPage: 0//Номер страницы, который запоминается при щипке на Android
        property bool blPassword: false//true - когда в pdf документе запрашиваем пароль.

        document: PdfDocument {
            id: pdfDoc
            source: root.source//Привязываем источник PDF
            password: root.password//Пароль для pdf документа.
            onStatusChanged: {
                if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
                    console.error("266: 10. Старт таймера ошибки.");
                    root.sgnProgress(91, "10/11 Старт таймера ошибки.");
                    tmrError.running = true;//Запускаю таймер с обработчиком ошибки. ТАЙМЕР КРИТИЧЕСКИ ВАЖЕН.
                }
                else{//Если не ошибка, то...
                    if(pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился, то...
                        console.error("272: 2. Статус документа: Готов.");
                        root.sgnProgress(19, "2/11 Загрузка большого документа.");
                        //Расчитываем, вертикальный или горизонтальный документ.
                        if(pdfDoc.pagePointSize(root.currentPage).height
                                >= pdfDoc.pagePointSize(root.currentPage).width)
                            pmpDoc.blDocVert = true;//true - вертикальный документ.
                        else
                            pmpDoc.blDocVert = false;//false - горизонтальный документ.
                    }
                    else{
                        if(pdfDoc.status === PdfDocument.Loading){//Если pdf документ загружается, то...
                            console.error("283: 1. Статус документа: Загрузка.");
                            root.sgnProgress(10, "1/11 Статус документа: Загрузка.");
                        }
                    }
                }
            }
            onPasswordRequired: {//Если пришёл сигнал passwordRequire запроса пароля в pdf документе, то...
                console.error("290: Запрашиваю пароль.")
                pmpDoc.blPassword = true;//Запрашиваю пароль.
                root.sgnPassword();//Сигнал о том, что есть запрос на ввод пароля.
            }
        }
        onCurrentPageChanged: {//Если страница документа изменилась, то...
            root.sgnCurrentPage(pmpDoc.currentPage)//Сигнал с номером страницы отсылаем.
        }
        onCurrentPageRenderingStatusChanged:{//Если рендер страницы изменился, то...
            if(pmpDoc.currentPageRenderingStatus === Image.Loading){//Статус рендеринга страницы ЗАГРУЗКА.
                console.error("300: Рендер страницы: " + pmpDoc.currentPage + " Загрузка.");
            }
            else{//Если не загружается страница, то...
                if(pmpDoc.currentPageRenderingStatus === Image.Ready){//Статус рендеринга страницы ОТКРЫТ.
                    console.error("304: Рендер страницы: " + pmpDoc.currentPage + " Открыт.");
                    if(!pmpDoc.blScale){//Если стартового масштабирование не было, то...
                        pmpDoc.blScale = true;//Активируем флаг, что началось первичное масштабирование.
                        console.error("307: 3. Старт таймера масштабирования.");
                        root.sgnProgress(28, "3/11 Старт таймера масштабирования.");
                        pmpDoc.blScaleAuto = true;//Автоматическое масштабирование, обязательно перед таймером
                        tmrScale.running = true;//запускаем таймер, перед переходом на страницу
                    }
                    else{//Если это не первичное масштабирование, то...
                        if(pmpDoc.blPinch){//Если щипок был,то страница отрендерилась и нужно сбрасывать сцену
                            pmpDoc.goToPage(0);//Переходим на первую страницу, потом goTo на заданную страницу
                            console.error("315: 6. Окончание масштабирования документа.")
                            root.sgnProgress(55, "6/11 Остановка анимации: ожидайте.");
                            tmrResetScene.running = true;//запускаем таймер, сброса сцены.
                        }
                    }
                }
                else{//Если не открылась страница, то...
                    if(pmpDoc.currentPageRenderingStatus === Image.Error){//Статус рендеринга страницы ОШИБКА.
                        console.error("323: Рендер страницы: " + pmpDoc.currentPage + " Ошибка.");
                        console.error("324: 11. Ошибка рендера страницы.");
                        root.sgnProgress(100, "11/11 Ошибка рендера страницы.");
                        root.sgnDebug(qsTr("Ошибка рендера страницы."));//Передаём ошибку.
                        root.sgnError();//Закрываем документ.
                    }
                    else{
                        if(pmpDoc.currentPageRenderingStatus === Image.Null){//Статус рендеринга страницы Null
                            console.error("331: Рендер страницы: " + pmpDoc.currentPage + " Null.");
                            console.error("332: 11. Рендера страницы Null.");
                            root.sgnProgress(100, "11/11 Рендера страницы Null.");
                            root.sgnDebug(qsTr("Рендера страницы Null."));//Передаём ошибку.
                            root.sgnError();//Закрываем документ.
                        }
                    }
                }
            }

        }
        onRenderScaleChanged: {//Если масштаб изменился, то...
            if(!pmpDoc.blScaleStart){//Если не была запущена функция масштабирования fnScale(), то...
                pmpDoc.ntPinchPage = pmpDoc.currentPage;//Запоминаем номер страницы до изменения масштаба.
                pmpDoc.blPinch = true;//То это увеличение масштаба пользователем через щипок
                root.visible = false;//Невидимый виджет.
            }
            pmpDoc.blRenderScale = true;//Взводим флаг, предотвращаем обработку root onRenderScaleChanged
            root.renderScale = pmpDoc.renderScale;//Присваемаем масштаб внутри виджета.
            pmpDoc.blRenderScale = false;//ОБЯЗАТЕЛЬНО сбрасываем флаг. 
        }
    }
    Rectangle {//Дополнительный элементы управления.
        id: rctStranici
        anchors.bottom: root.bottom; anchors.horizontalCenter: root.horizontalCenter; anchors.bottomMargin: 22
        width: 220; height: 22
        color: "lightgray"
        clip: true; opacity: 0.6; radius: 50
        visible: true//Видим дополнительный элемент управления.
        Text {
            anchors.centerIn: rctStranici
            text: qsTr("Страница ") + (pmpDoc.currentPage+1) + qsTr(" из ") + pdfDoc.pageCount
        }
    }
    Drawer {
        id: drwSidebar
        //Свойства
        //Настройки
        edge: Qt.LeftEdge
        modal: false
        width: 300//Ширина
        height: pmpDoc.height//Высота по высоте pdf сцены
        y: root.ntWidth*root.ntCoff+3*root.ntCoff//координату по Y брал из расчёта Stranica.qml
        dim: false
        clip: true//Образать всё лишнее.
        //Функции
        Rectangle {//Прямоугольник узкой полоски интерфейса слева
            id: rctBorder
            anchors.top: drwSidebar.top
            anchors.left: drwSidebar.left
            width: root.ntCoff
            height: drwSidebar.height
            color: root.clrMenuFon
        }
        Rectangle {//Прямоугольник всей оставшейся боковой панели.
            id: rctSibebar
            anchors.top: drwSidebar.top
            anchors.left: rctBorder.right
            width: drwSidebar.width - root.ntCoff
            height: drwSidebar.height
            color: root.clrFona
            border.color: root.clrTexta
            border.width: root.ntCoff/4//Бордюр
        }
        TabBar {
            id: tbSidebar
            //Свойства
            property color clrFonNormal: root.clrFona//Цвет фона фкладки, когда она не активна.
            property color clrFonHover: root.clrMenuFon//Цвет фона вкладки при наведении мышки на неё.
            property color clrFonPressed: Qt.darker(root.clrTexta, 1.3)//Цвет фона вкладки,когда нажали на его
            property color clrFonChecked: root.clrTexta//Цвет фона выбранной вкладки пользователем.
            property color clrTxtNormal: root.clrTexta//Цвет текста вкладки, когда она не активна.
            property color clrTxtPressed: root.clrFona//Цвет текста вкладки при нажатии на неё
            property color clrTxtChecked: root.clrFona//Цвет текста вкладки выбранной пользователем постоянно.
            property color clrBorder: root.clrTexta//Цвет оконтовки вкладки.
            //Настройки
            anchors.top: drwSidebar.top
            anchors.right: rctBorder.right
            height: ((root.ntWidth-1)*root.ntCoff < 22)		? 22
                    : ((root.ntWidth-1)*root.ntCoff > 30) 	? 30
                    :										((root.ntWidth-1)*root.ntCoff)
            x: -width//Смещаем х влево в минусовые координаты, для того,чтоб потом повернуть от точки поворота
            y: root.ntCoff/4//Опускаемся на полщину бардюра
            rotation: -90//Поворачиваем на 90 градусов против часовой стрелки боковую панель
            transformOrigin: Item.TopRight//Точка поворота боковой панели верхний правый угол.
            currentIndex: 1//Закладки выбраны по умолчанию
            //Функции
            /*
            TabButton {
                id: tbbNaideno
                text: qsTr("Найдено")
                width: (drwSidebar.height-root.ntCoff/2)/tbSidebar.count//Длина делется на количество кнопок
                height: tbSidebar.height//Расчитаная высота кнопок относительно размера шрифта
                hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
                onPressed: tbSidebar.currentIndex = 0//Меняем индекс сразу при нажатии
                background: Rectangle{//Фон вкладки Прямоугольник.
                    radius: 0//Без радиуса.
                    color: !tbbNaideno.enabled		? Qt.darker(tbSidebar.clrFonNormal, 1.25)
                            : tbbNaideno.down		? tbSidebar.clrFonPressed
                            : tbbNaideno.checked	? tbSidebar.clrFonChecked
                            : tbbNaideno.hovered	? tbSidebar.clrFonHover
                            :						tbSidebar.clrFonNormal
                    border.width: tbbNaideno.checked || tbbNaideno.down ? 0 : root.ntCoff/4
                    border.color: tbSidebar.clrBorder
                }
                contentItem: Label {
                    id: lblNaideno
                    text: tbbNaideno.text
                    font.pixelSize: tbSidebar.height-root.ntCoff//Задаём размер шрифта.
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    //elide: Text.ElideRight//автоматически сокращает текст, добавляя многоточие (...) в конце
                    color: !tbbNaideno.enabled		? tbSidebar.clrTxtPressed
                            : tbbNaideno.checked	? tbSidebar.clrTxtChecked
                            : tbbNaideno.down		? tbSidebar.clrTxtPressed
                            :						tbSidebar.clrTxtNormal
                }
                Component.onCompleted: {//Когда текст отрисовался, нужно выставить размер шрифта.
                    if(tbbNaideno.width > lblNaideno.implicitWidth){//Если длина строки больше длины текста,то
                        for(var ltShag=lblNaideno.font.pixelSize; ltShag<tbbNaideno.height-root.ntCoff;
                                                                                                    ltShag++){
                            if(lblNaideno.implicitWidth< tbbNaideno.width){//Если длина txt меньше динны строк
                                lblNaideno.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(lblNaideno.implicitWidth > tbbNaideno.width){//Но, если переборщили
                                    lblNaideno.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = lblNaideno.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(lblNaideno.implicitWidth > tbbNaideno.width)//Если текст дилиннее строки, то...
                                lblNaideno.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
                onWidthChanged: {//Если длина строки изменилась, то...
                    if(tbbNaideno.width > lblNaideno.implicitWidth){//Если длина строки больше длины текста,то
                        for(var ltShag=lblNaideno.font.pixelSize; ltShag<tbbNaideno.height-root.ntCoff;
                                                                                                    ltShag++){
                            if(lblNaideno.implicitWidth< tbbNaideno.width){//Если длина txt меньше динны строк
                                lblNaideno.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(lblNaideno.implicitWidth > tbbNaideno.width){//Но, если переборщили
                                    lblNaideno.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = lblNaideno.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(lblNaideno.implicitWidth > tbbNaideno.width)//Если текст дилиннее строки, то...
                                lblNaideno.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
            }
            TabButton {
                id: tbbZakladki
                text: qsTr("Закладки")
                width: (drwSidebar.height-root.ntCoff/2)/tbSidebar.count//Длина делется на количество кнопок
                height: tbSidebar.height//Расчитаная высота кнопок относительно размера шрифта
                hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
                onPressed: tbSidebar.currentIndex = 1//Меняем индекс сразу при нажатии
                background: Rectangle{//Фон вкладки Прямоугольник.
                    radius: 0//Без радиуса.
                    color: !tbbZakladki.enabled		? Qt.darker(tbSidebar.clrFonNormal, 1.25)
                            : tbbZakladki.down		? tbSidebar.clrFonPressed
                            : tbbZakladki.checked	? tbSidebar.clrFonChecked
                            : tbbZakladki.hovered	? tbSidebar.clrFonHover
                            : 						tbSidebar.clrFonNormal
                    border.width: tbbZakladki.checked || tbbZakladki.down ? 0 : root.ntCoff/4
                    border.color: tbSidebar.clrBorder
                }
                contentItem: Label {
                    id: lblZakladki
                    text: tbbZakladki.text
                    font.pixelSize: tbSidebar.height-root.ntCoff//Задаём размер шрифта.
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    //elide: Text.ElideRight//автоматически сокращает текст, добавляя многоточие (...) в конце
                    color: !tbbZakladki.enabled		? tbSidebar.clrTxtPressed
                            : tbbZakladki.checked	? tbSidebar.clrTxtChecked
                            : tbbZakladki.down		? tbSidebar.clrTxtPressed
                            :						tbSidebar.clrTxtNormal
                }
                Component.onCompleted: {//Когда текст отрисовался, нужно выставить размер шрифта.
                    if(tbbZakladki.width > lblZakladki.implicitWidth){//Если длина строки больше длины текста
                        for(var ltShag=lblZakladki.font.pixelSize; ltShag<tbbZakladki.height-root.ntCoff;
                                                                                                    ltShag++){
                            if(lblZakladki.implicitWidth< tbbZakladki.width){//Если длина txt меньше динны стр
                                lblZakladki.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(lblZakladki.implicitWidth > tbbZakladki.width){//Но, если переборщили
                                    lblZakladki.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = lblZakladki.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(lblZakladki.implicitWidth > tbbZakladki.width)//Если текст дилиннее строки, то.
                                lblZakladki.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
                onWidthChanged: {//Если длина строки изменилась, то...
                    if(tbbZakladki.width > lblZakladki.implicitWidth){//Если длина строки больше длины текста
                        for(var ltShag=lblZakladki.font.pixelSize; ltShag<tbbZakladki.height-root.ntCoff;
                                                                                                    ltShag++){
                            if(lblZakladki.implicitWidth< tbbZakladki.width){//Если длина txt меньше динны стр
                                lblZakladki.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(lblZakladki.implicitWidth > tbbZakladki.width){//Но, если переборщили
                                    lblZakladki.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = lblZakladki.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(lblZakladki.implicitWidth > tbbZakladki.width)//Если текст дилиннее строки, то.
                                lblZakladki.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
            }
            TabButton {
                id: tbbStranici
                text: qsTr("Страницы")
                width: (drwSidebar.height-root.ntCoff/2)/tbSidebar.count+root.ntCoff/4//делим на кол-во кнопок
                height: tbSidebar.height//Расчитаная высота кнопок относительно размера шрифта
                hoverEnabled: !root.isMobile//Вкл/Выкл отслеживание наведения мыши на кнопку в ПК/Мобильных.
                onPressed: tbSidebar.currentIndex = 2//Меняем индекс сразу при нажатии
                background: Rectangle{//Фон вкладки Прямоугольник.
                    radius: 0//Без радиуса.
                    color: !tbbStranici.enabled		? Qt.darker(tbSidebar.clrFonNormal, 1.25)
                           : tbbStranici.down		? tbSidebar.clrFonPressed
                           : tbbStranici.checked	? tbSidebar.clrFonChecked
                           : tbbStranici.hovered	? tbSidebar.clrFonHover
                           : 						tbSidebar.clrFonNormal
                    border.width: tbbStranici.checked || tbbStranici.down ? 0 : root.ntCoff/4
                    border.color: tbSidebar.clrBorder
                }
                contentItem: Label {
                    id: lblStranici
                    text: tbbStranici.text
                    font.pixelSize: tbSidebar.height-root.ntCoff//Задаём размер шрифта.
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    //elide: Text.ElideRight//автоматически сокращает текст, добавляя многоточие (...) в конце
                    color: !tbbStranici.enabled		? tbSidebar.clrTxtPressed
                            : tbbStranici.checked	? tbSidebar.clrTxtChecked
                            : tbbStranici.down		? tbSidebar.clrTxtPressed
                            :						tbSidebar.clrTxtNormal
                }
                Component.onCompleted: {//Когда текст отрисовался, нужно выставить размер шрифта.
                    if(tbbStranici.width > lblStranici.implicitWidth){//Если длина строки больше длины текста
                        for(var ltShag=lblStranici.font.pixelSize; ltShag<tbbStranici.height-root.ntCoff;
                                                                                                    ltShag++){
                            if(lblStranici.implicitWidth< tbbStranici.width){//Если длина txt меньше динны стр
                                lblStranici.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(lblStranici.implicitWidth > tbbStranici.width){//Но, если переборщили
                                    lblStranici.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = lblStranici.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(lblStranici.implicitWidth > tbbStranici.width)//Если текст дилиннее строки, то
                                lblStranici.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
                onWidthChanged: {//Если длина строки изменилась, то...
                    if(tbbStranici.width > lblStranici.implicitWidth){//Если длина строки больше длины текста
                        for(var ltShag=lblStranici.font.pixelSize; ltShag<tbbStranici.height-root.ntCoff;
                                                                                                    ltShag++){
                            if(lblStranici.implicitWidth< tbbStranici.width){//Если длина txt меньше динны стр
                                lblStranici.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(lblStranici.implicitWidth > tbbStranici.width){//Но, если переборщили
                                    lblStranici.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = lblStranici.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(lblStranici.implicitWidth > tbbStranici.width)//Если текст дилиннее строки, то
                                lblStranici.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
            }
            */
            // ВАЖНО: onPressed не нужен — TabBar сам управляет currentIndex при клике.

                DCTabButton {
                    text: qsTr("Найдено")
                    width:  (drwSidebar.height - tbSidebar.ntCoff/2) / tbSidebar.count
                    height: tbSidebar.height
                    hoverEnabled: !root.isMobile

                    // пробрасываем тему
                    clrFonNormal:  tbSidebar.clrFonNormal
                    clrFonHover:   tbSidebar.clrFonHover
                    clrFonPressed: tbSidebar.clrFonPressed
                    clrFonChecked: tbSidebar.clrFonChecked
                    clrTxtNormal:  tbSidebar.clrTxtNormal
                    clrTxtPressed: tbSidebar.clrTxtPressed
                    clrTxtChecked: tbSidebar.clrTxtChecked
                    clrBorder:     tbSidebar.clrBorder
                    ntCoff:        tbSidebar.ntCoff
                }

                DCTabButton {
                    text: qsTr("Закладки")
                    width:  (drwSidebar.height - tbSidebar.ntCoff/2) / tbSidebar.count
                    height: tbSidebar.height
                    hoverEnabled: !root.isMobile

                    clrFonNormal:  tbSidebar.clrFonNormal
                    clrFonHover:   tbSidebar.clrFonHover
                    clrFonPressed: tbSidebar.clrFonPressed
                    clrFonChecked: tbSidebar.clrFonChecked
                    clrTxtNormal:  tbSidebar.clrTxtNormal
                    clrTxtPressed: tbSidebar.clrTxtPressed
                    clrTxtChecked: tbSidebar.clrTxtChecked
                    clrBorder:     tbSidebar.clrBorder
                    ntCoff:        tbSidebar.ntCoff
                }

                DCTabButton {
                    text: qsTr("Страницы")
                    width:  (drwSidebar.height - tbSidebar.ntCoff/2) / tbSidebar.count + tbSidebar.ntCoff/4
                    height: tbSidebar.height
                    hoverEnabled: !root.isMobile

                    clrFonNormal:  tbSidebar.clrFonNormal
                    clrFonHover:   tbSidebar.clrFonHover
                    clrFonPressed: tbSidebar.clrFonPressed
                    clrFonChecked: tbSidebar.clrFonChecked
                    clrTxtNormal:  tbSidebar.clrTxtNormal
                    clrTxtPressed: tbSidebar.clrTxtPressed
                    clrTxtChecked: tbSidebar.clrTxtChecked
                    clrBorder:     tbSidebar.clrBorder
                    ntCoff:        tbSidebar.ntCoff
                }
        }
    }
}
