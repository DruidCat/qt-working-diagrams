import QtQuick
import QtQuick.Pdf
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent
    visible: false;//по умолчанию он невидимый.

    property url source: ""// Свойство для установки пути к PDF
    property string password: ""//Пароль для pdf документа.
    property real renderScale: 1//Коэффициень масштаба 1.
    property real rlMasshtab: 1//Коэффициень масштаба 1.
    property int currentPage : -1//Номер страницы устанавливаемый вне виджет(set).(не путать с ntStranica)
    property alias nomerStranici: pmpDoc.currentPage//Номер страницы внутри виджета(get).
    property alias pageCount: pdfDoc.pageCount//Общее количество страниц в документе.
    property alias searchString: pmpDoc.searchString//Запрос на поиск.
    //Сигналы.
    signal sgnVisible()//Сигнал - изменилась видимость документа. А состояние отследить по visible.
    signal sgnError()//Закрываем pdf документ.
    signal sgnDebug(string strDebug)//Передаём ошибку.
    signal sgnCurrentPage(int ntStranica)//Сигнал возвращающий номер страницы документа.
    signal sgnRenderScale(real rlMasshtab)//Cигнал возвращающий значение масштаба.
    signal sgnPassword()//Сигнал о том, что запрашивается пароль. 
    signal sgnProgress(int ntProgress, string strStatus)//Сигнал возвращающий загрузку документа и его статус.

    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        if((event.key === 16777237)||(event.key === 16777239)){//Если нажата "Page Down",то.
            var ntStrDown = root.nomerStranici + 1;
            if(ntStrDown < root.pageCount)
                root.currentPage = ntStrDown;
        }
        if((event.key === 16777235)||(event.key === 16777238)){//Если нажата "Page Up", то.
            var ntStrUp = root.nomerStranici - 1;//-1 страница
            if(ntStrUp >= 0)//Если больше 0, то листаем к началу документа.
                root.currentPage = ntStrUp;
        }
        //cppqml.strDebug = event.key;
    }

    onRenderScaleChanged: {//Если масштаб поменялся из вне, то...
        pmpDoc.ntPdfPage = pmpDoc.currentPage;//Сохраняем действующую страницу.
        root.visible = false;//Невидимый виджет.
        root.sgnVisible();//Изменилась видимость.
        pmpDoc.blScaleAuto = false;//Ручное масштабирование, обязательно перед таймером.
        console.error("46: 3. Старт таймера масштабирования.");
        root.sgnProgress(28, "3. Старт таймера масштабирования.");
        tmrScale.running = true;//Запускаем таймер перед масштабированием, чтоб сцена успела исчезнуть.
    }
    onCurrentPageChanged: {//Если страница поменялась из вне, то...
        console.error("51:Страница " + root.currentPage + " из вне.");
        if(pmpDoc.blStranica)//Первоначальная установка страницы при загрузке документа
            pmpDoc.blStranica = false;//Сбрасываем флаг.
        else//Если изменение страницы не в первый раз, то...
            fnGoToPage(root.currentPage);//Переходим на заданную страницу.
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
                console.error("84: 4. Изменился размер окна.");
                root.sgnProgress(37, "4. Изменился размер окна.")
                root.visible = false;//Невидимым виджет делаем.
                root.sgnVisible();//Изменилась видимость.
            }
            tmrAppSize.restart();//Таймер перезапускаем.
        }
    }
    function fnScale(){//Функция авто/руч. масштабирования в зависимости от формата pdf документа.
        pmpDoc.blScaleStart = true;//Начало масштабирования.
        console.error("94: 5. Начало масштабирования документа.");
        root.sgnProgress(46, "5. Начало масштабирования документа.");
        if(pmpDoc.blScaleAuto){//Если автоматический режим, то...
            var widthRect = pmpDoc.childrenRect.width;
            var heightRect = pmpDoc.childrenRect.height;
            if(pmpDoc.blDocVert)//Если вертикальная страница, то...
                pmpDoc.scaleToPage(widthRect, heightRect);//масштаб по высоте страницы.
            else//Если горизонтальная страница, то...
                pmpDoc.scaleToWidth(widthRect, heightRect);//Масштаб по ширине страницы.
        }
        else
            pmpDoc.renderScale = root.renderScale;//Выставляем масштаб из Свойства.
        console.error("106: 7. Окончание масштабирования документа.")
        root.sgnProgress(64, "7. Окончание масштабирования документа.");
        pmpDoc.blScaleStart = false;//Окончание масштабирования.
        if(!pmpDoc.blScaleAuto){//Если ручной режим, то... необходимo для правильного логирования
            console.error("110: 8. Старт таймера страницы.")
            root.sgnProgress(73, "8. Старт таймера страницы.");
            tmrGoToPage.running = true;//Запускаем таймер перехода на страницу после масштабирования.
        }
    }
    function fnGoToPage(ntPage){//Функция обрабатывающая переход на новую страницу документа.
        console.error("116: 10. Переходим на страницу: " + ntPage);
        root.sgnProgress(91, "10. Переходим на страницу.");
        pmpDoc.goToLocation(ntPage, Qt.point(0, 0), pmpDoc.renderScale);//Переходим на страницу.
        console.error("119:fnGoToPage Старт таймера видимости.");
        tmrVisible.running = true;//Запускаем таймер отображения документа.
    }
    Timer {//Таймер необходим, чтоб пока пользователь изменяет размер окна приложения,не обрабатывался масштаб
        id: tmrAppSize
        interval: 333; running: false; repeat: false
        onTriggered: {
            pmpDoc.blSize = true;//Открываем документ, игнорируя изменения размера приложения.
            pmpDoc.blScaleAuto = true;//Автоматический режим масштабирования по размеру виджета
            fnScale();//Выставляем масштаб по ширине или по высоте в зависимости от размера документа.
            console.error("129: 8. Старт таймера страницы.")
            root.sgnProgress(73, "8. Старт таймера страницы.");
            tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел загрузиться, и можно было масштабировать документ.
        id: tmrScale
        interval: 111; running: false; repeat: false
        onTriggered: {
            console.error("138: 4. Стоп таймера масштабирования.");
            root.sgnProgress(37, "4. Стоп таймера масштабирования.");
            fnScale();//масштабируем документ автоматически/вручную.
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел смаштабироваться, и можно было выставить страницу.
        id: tmrGoToPage
        interval: 333; running: false; repeat: false
        onTriggered: {
            console.error("147: 9. Стоп таймера страницы.");
            root.sgnProgress(82, "9. Стоп таймера страницы.");
            if(pmpDoc.blPinch){//Если был щипок пользователя с изменением Масштаба, то...
                pmpDoc.blPinch = false;//Сбрасываем флаг
                fnGoToPage(pmpDoc.ntPinchPage);//Выставляем запомненную страницу после щипка
            }
            else{//Если не было щипка пользователя, то...
                if(pmpDoc.blSize)//Если идет изменение масштаба через изменение размера виджета, то...
                    fnGoToPage(pmpDoc.ntPdfPage);//Выставляем запомненную страницу из виджита
                else{//Если нет, то...
                    if(pmpDoc.blScaleAuto)//Если масштабирование Автоматическое при старте, то...
                        fnGoToPage(root.currentPage);//Выставляем заданную страницу из вне виджита.
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
            console.error("169: 11. Отображаем ваш документ.");
            root.sgnProgress(100, "11. Отображаем ваш документ.");
            pmpDoc.blSize = false;//Готов к изменению размера приложения.
            root.visible = true;//Видимый виджет
            root.sgnVisible();//Изменилась видимость.
        }
    }
    Timer {//Таймер необходим, чтоб чтоб после аварии закрыть страницу.
        id: tmrError
        interval: 111; running: false; repeat: false
        onTriggered: {
            console.error("180: 11. Ошибка, окончание загрузки.");
            root.sgnProgress(100, "11. Ошибка, окончание загрузки.");
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
        anchors.fill: parent
        searchString: ""
        //Иннициализация Свойств при каждой загрузке, от сюда берутся первоначальные данные Свойств.
        property bool blResetScene: false//false - быстрый сброс сцены при первом открытии pdf документа.
        property bool blDocVert: true//true - вертикальный документ, false - горизонтальный документ.
        property bool blScale: false//true - когда в pdf документе масштабирование произошло.
        property bool blScaleAuto: true//true - автоматическое масштабирование. false - ручное масштабирование
        property bool blScaleStart: false//true - когда pdf документ изменяет масштаб.
        property bool blPinch: false//true - когда пользователь щипком изменил масштаб.
        property bool blSize: false//true - когда pdf документ изменяет размер при масштабе виджета.
        property bool blStartWidth: true//true - пришёл сигнал об измении ширины виджета при его открытии.
        property bool blStartHeight: true//true - пришёл сигнал об измении высоты виджета при его открытии.
        property bool blStranica: true//true-чтоб не обрабатывать первоначально заданную страницу в прерывании
        property bool blGoToPage: false//true - когда в pdf документе перешли на заданную страницу.
        property int ntPdfPage: 0//Номер страницы запомненный перед изменением масштаба root.renderScale.
        property int ntPinchPage: 0//Номер страницы, который запоминается при щипке на Android
        property bool blPassword: false//true - когда в pdf документе запрашиваем пароль.

        document: PdfDocument {
            id: pdfDoc
            source: root.source//Привязываем источник PDF
            password: root.password//Пароль для pdf документа.
            onStatusChanged: {
                if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
                    console.error("218: 10. Старт таймера ошибки.");
                    root.sgnProgress(91, "10. Старт таймера ошибки.");
                    tmrError.running = true;//Запускаю таймер с обработчиком ошибки. ТАЙМЕР КРИТИЧЕСКИ ВАЖЕН.
                }
                else{//Если не ошибка, то...
                    if(pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился, то...
                        console.error("224: 2. Статус документа: открыто.");
                        root.sgnProgress(19, "2. Статус документа: открыто.");
                        //Расчитываем, вертикальный или горизонтальный документ.
                        if(pdfDoc.pagePointSize(root.currentPage).height
                                >= pdfDoc.pagePointSize(root.currentPage).width)
                            pmpDoc.blDocVert = true;//true - вертикальный документ.
                        else
                            pmpDoc.blDocVert = false;//false - горизонтальный документ.
                    }
                    else{
                        if(pdfDoc.status === PdfDocument.Loading){//Если pdf документ загружается, то...
                            console.error("235: 1. Статус документа: Загрузка.");
                            root.sgnProgress(10, "1. Статус документа: Загрузка.");
                        }
                    }
                }
            }
            onPasswordRequired: {//Если пришёл сигнал passwordRequire запроса пароля в pdf документе, то...
                console.error("242: Запрашиваю пароль.")
                pmpDoc.blPassword = true;//Запрашиваю пароль.
                root.sgnPassword();//Сигнал о том, что есть запрос на ввод пароля.
            }
        }
        onCurrentPageChanged: {//Если страница документа изменилась, то...
            root.sgnCurrentPage(pmpDoc.currentPage)//Сигнал с номером страницы отсылаем.
        }
        onCurrentPageRenderingStatusChanged:{//Если рендер страницы изменился, то...
            console.error("251:PdfPageStatus.vvv");
            if(pmpDoc.currentPageRenderingStatus === Image.Loading){//Статус рендеринга страницы ЗАГРУЗКА.
                console.error("253: Рендера страницы: " + pmpDoc.currentPage + " Загрузка.");
            }
            if(pmpDoc.currentPageRenderingStatus === Image.Ready){//Статус рендеринга страницы ОТКРЫТ.
                console.error("256: Рендера страницы: " + pmpDoc.currentPage + " Открыт.");
                if(!pmpDoc.blScale){//Если стартового масштабирование не было, то...
                    pmpDoc.blScale = true;//Активируем флаг, что началось первичное масштабирование.
                    console.error("259: 3. Старт таймера масштабирования.");
                    root.sgnProgress(28, "3. Старт таймера масштабирования.");
                    pmpDoc.blScaleAuto = true;//Автоматическое масштабирование, обязательно перед таймером.
                    tmrScale.running = true;//запускаем таймер, перед переходом на страницу
                }
                else{//Если первичное масштабирование произошло, то...
                    if(!pmpDoc.blGoToPage){//Если не было стартового перехода на страницу, то...
                        pmpDoc.blGoToPage = true;//Активируем флаг, что начался первичный переход на страницу.
                        console.error("267: 8. Старт таймера страницы.");
                        root.sgnProgress(73, "8. Старт таймера страницы.");
                        tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
                    }
                }
            }
            if(pmpDoc.blPinch){
                console.error("274: 8. Старт таймера страницы.")
                root.sgnProgress(73, "8. Старт таймера страницы.");
                tmrGoToPage.running = true;
            }
        }
        onRenderScaleChanged: {//Если масштаб изменился, то...
            if(!pmpDoc.blScaleStart){//Если не была запущена функция масштабирования fnScale(), то...
                pmpDoc.ntPinchPage = pmpDoc.currentPage;//Запоминаем номер страницы до изменения масштаба.
                pmpDoc.blPinch = true;//То это увеличение масштаба пользователем через щипок
                root.visible = false;//Невидимый виджет.
                root.sgnVisible();//Изменилась видимость.
            }
            root.rlMasshtab = pmpDoc.renderScale;//Присваемаем масштаб внутри виджета.
            root.sgnRenderScale(root.rlMasshtab);//отправляем сигнал со значением масштаба
            console.error("288: 6. Сброс сцены документа.")
            root.sgnProgress(55, "6. Сброс сцены документа.");
            //if(!pmpDoc.blResetScene){//Если это первичное масштабирование, то...
                pmpDoc.blResetScene = true;//Изменяем флаг, чтоб последующие масштабирования были качественные
                //Это быстрый способ, но с ошибками в консоли, так как документ обнуляется.
                let doc = pmpDoc.document;//Запоминаем pdf документ.
                pmpDoc.document = null;//Выставляем нулевой документ, и тем самым сбрасываем сцену.
                pmpDoc.document = doc;//Восстанавливаем старый документ с обновлённой сценой.
            /*
            }
            else{//Дальнейший медленный сброс сцены, он корректно масштабирует документ и стабильно. ВАЖНО!
                //Это очень медленный способ, даже на быстром компьютере, но без ошибок. На Android падает app
                pmpDoc.anchors.fill = undefined;//Не определен якорь.
                pmpDoc.width = pdfDoc.pagePointSize(0).width * pmpDoc.renderScale;//Задаём посчитанную длину.
                pmpDoc.height = pdfDoc.pagePointSize(0).height * pmpDoc.renderScale * pdfDoc.pageCount//Ширину
                pmpDoc.anchors.fill = parent;//Растягиваем pmpDoc, и тем самым пересчитываем Сцену.
            }
            */
        }
    }
    property PdfSearchModel searchModel: PdfSearchModel {
        document: pdfDoc // модель завязана на документ внутри этого скоупа
    }
    function setSearchText(text) {
        searchModel.searchString = text
    }
    /*
    //Дополнительные элементы управления
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 400
        height: 40
        color: "lightgray"

        Text {
            anchors.centerIn: parent
            text:{
                let ltScale = Math.floor(pmpDoc.renderScale*100);
                return "Страница "+(pmpDoc.currentPage+1)+" из "+pdfDoc.pageCount+" Масштаб "+ltScale+"%"
            }
        }
    }
    */
}
