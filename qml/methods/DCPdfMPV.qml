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
    property int currentPage : 0//Номер страницы устанавливаемый вне виджет(set).(не путать с ntStranica)
    property int nomerStranici: 0//Номер страницы внутри виджета(get).
    //Сигналы.
    signal sgnVisible()//Сигнал - изменилась видимость документа. А состояние отследить по visible.
    signal sgnError()//Закрываем pdf документ.
    signal sgnDebug(string strDebug)//Передаём ошибку.
    signal sgnCurrentPage(int ntStranica)//Сигнал возвращающий номер страницы документа.
    signal sgnRenderScale(real rlMasshtab)//Cигнал возвращающий значение масштаба.
    signal sgnPassword()//Сигнал о том, что запрашивается пароль. 

    onRenderScaleChanged: {//Если масштаб поменялся из вне, то...
        pmpDoc.ntPdfPage = pmpDoc.currentPage;//Сохраняем действующую страницу.
        root.visible = false;//Невидимый виджет.
        root.sgnVisible();//Изменилась видимость.
        console.error("35:Timer tmrScale start");
        pmpDoc.blScaleAuto = false;//Ручное масштабирование, обязательно перед таймером.
        tmrScale.running = true;//Запускаем таймер перед масштабированием, чтоб сцена успела исчезнуть.
    }
    onCurrentPageChanged: {//Если страница поменялась из вне, то...
        console.error("33: страница поменялась из вне");
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
    function fnTimerAppSize(){//Функция старта таймера при изменении размеров приложения пользователем.
        if(!pmpDoc.blSize){//Принимаю размеры приложения, пока не запустится обработкик показа документа.
            if(!tmrAppSize.running){//Если таймер еще не запускался, то...
                pmpDoc.ntPdfPage = pmpDoc.currentPage;//Сохраняем действующую страницу.
                console.error("55:fnTimerAppSize. Невидимость виджета");
                root.visible = false;//Невидимым виджет делаем.
                root.sgnVisible();//Изменилась видимость.
            }
            tmrAppSize.restart();//Таймер перезапускаем.
        }
    }
    function fnScale(){//Функция авто/руч. масштабирования в зависимости от формата pdf документа.
        console.error("68:fnScale. Начало масштабирования.")
        if(pmpDoc.blScaleAuto){//Если автоматический режим, то...
            var widthRect = pmpDoc.childrenRect.width;
            var heightRect = pmpDoc.childrenRect.height;
            if(pmpDoc.blDocVert)//Если вертикальная страница, то...
                pmpDoc.scaleToPage(widthRect, heightRect);//масштаб по высоте страницы.
            else//Если горизонтальная страница, то...
                pmpDoc.scaleToWidth(widthRect, heightRect);//Масштаб по ширине страницы.
        }
        else{
            pmpDoc.renderScale = root.renderScale;//Выставляем масштаб из Свойства.
            tmrGoToPage.running = true;//Запускаем таймер перехода на страницу после масштабирования.
        }
        console.error("81:fnScale. Окончание масштабирования.")
    }
    function fnGoToPage(ntPage){//Функция обрабатывающая переход на новую страницу документа.
        console.error("79:fnGoToPage Номер страницы: " + ntPage);
        pmpDoc.goToLocation(ntPage, Qt.point(0, 0), pmpDoc.renderScale);//Переходим на страницу.
        console.error("81:fnGoToPage tmrVisible start");
        tmrVisible.running = true;//Запускаем таймер отображения документа.
    }
    Timer {//Таймер необходим, чтоб пока пользователь изменяет размер окна приложения,не обрабатывался масштаб
        id: tmrAppSize
        interval: 333
        running: false
        repeat: false
        onTriggered: {
            pmpDoc.blSize = true;//Открываем документ, игнорируя изменения размера приложения.
            pmpDoc.blScaleAuto = true;//Автоматический режим масштабирования по размеру виджета
            fnScale();//Выставляем масштаб по ширине или по высоте в зависимости от размера документа.
            tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел загрузиться, и можно было масштабировать документ.
        id: tmrScale
        interval: 111//Таймер необходим,чтоб страница успела загрузится в виджет,и чтоб успела исчезнуть сцена
        running: false
        repeat:	false
        onTriggered: {
            console.error("108:Timer tmrScale stop");
            fnScale();//масштабируем документ автоматически/вручную.
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел смаштабироваться, и можно было выставить страницу.
        id: tmrGoToPage
        interval: 333//Чтоб отмасштабироваться успела страница, иначе переход на страницу не корректный будет.
        running: false
        repeat:	false
        onTriggered: {
            console.error("112:Timer tmrGoToPage stop");
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
    Timer {//Таймер необходим, чтоб после перехода на страницу произошла небольшая пауза.
        id: tmrVisible
        interval: 111
        running: false
        repeat:	false
        onTriggered: {
            console.error("129:Timer tmrVisible stop");
            pmpDoc.blSize = false;//Готов к изменению размера приложения.
            root.visible = true;//Видимый виджет
            root.sgnVisible();//Изменилась видимость.
        }
    }
    Timer {//Таймер необходим, чтоб чтоб после аварии закрыть страницу.
        id: tmrError
        interval: 111
        running: false
        repeat:	false
        onTriggered: {
            console.error("131:Timer tmrError stop");
            if(pmpDoc.blPassword){//Если был запрос на пароль, то...
                pmpDoc.blPassword = false;//Сбрасываем флаг.
                //if(!pssPassword.passTrue)//Если пароль введён неверно, то...
                    //root.signalDebug(qsTr("Введён неверный пароль."));
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
        property bool blSize: false//true - когда pdf документ изменяет размер при масштабе виджета.
        property bool blStartWidth: true//true - пришёл сигнал об измении ширины виджета при его открытии.
        property bool blStartHeight: true//true - пришёл сигнал об измении высоты виджета при его открытии.
        property bool blStranica: true//true-чтоб не обрабатывать первоначально заданную страницу в прерывании
        property bool blGoToPage: false//true - когда в pdf документе перешли на заданную страницу.
        property int ntPdfPage: 0//Номер страницы запомненный перед изменением масштаба.
        property bool blPassword: false//true - когда в pdf документе запрашиваем пароль.

        document: PdfDocument {
            id: pdfDoc
            source: root.source//Привязываем источник PDF
            password: root.password//Пароль для pdf документа.
            onStatusChanged: {
                console.error("154:PdfDocumentStatus: " + pdfDoc.status);
                if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
                    console.error("156: TimerError Start");
                    tmrError.running = true;//Запускаю таймер с обработчиком ошибки. ТАЙМЕР КРИТИЧЕСКИ ВАЖЕН.
                }
                else{//Если не ошибка, то...
                    if(pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился, то...
                        root.sgnDebug("");//Документ открыт, в тулбар не должно быть никаких надписей.
                        console.error("162:PdfDocumentStatus Ready");
                        //Расчитываем, вертикальный или горизонтальный документ.
                        if(pdfDoc.pagePointSize(root.currentPage).height
                                >= pdfDoc.pagePointSize(root.currentPage).width)
                            pmpDoc.blDocVert = true;//true - вертикальный документ.
                        else
                            pmpDoc.blDocVert = false;//false - горизонтальный документ.
                    }
                }
            }
            onPasswordRequired: {//Если пришёл сигнал passwordRequire запроса пароля в pdf документе, то...
                console.error("173: Запрашиваю пароль.")
                pmpDoc.blPassword = true;//Запрашиваю пароль.
                root.sgnPassword();//Сигнал о том, что есть запрос на ввод пароля.
            }
        }
        onCurrentPageChanged: {//Если страница документа изменилась, то...
            console.error("179: страница поменялась внутри виджета.")
            root.nomerStranici = pmpDoc.currentPage;//Сохраняем действующу страницу для всего виджета.
            root.sgnCurrentPage(root.nomerStranici)//Сигнал с номером страницы отсылаем.
        }
        onCurrentPageRenderingStatusChanged:{//Если рендер страницы изменился, то...
            console.error("184:PdfPageStatus.vvv")
            if(pmpDoc.currentPageRenderingStatus === Image.Loading){//Статус рендеринга страницы ЗАГРУЗКА.
                console.error("186: Рендера страницы: " + pmpDoc.currentPage + " Загрузка.");
            }
            if(pmpDoc.currentPageRenderingStatus === Image.Ready){//Статус рендеринга страницы ОТКРЫТ.
                console.error("189: Рендера страницы: " + pmpDoc.currentPage + " Открыт.");
                if(!pmpDoc.blScale){//Если стартового масштабирование не было, то...
                    pmpDoc.blScale = true;//Активируем флаг, что началось первичное масштабирование.
                    console.error("192:Timer tmrScale start");
                    pmpDoc.blScaleAuto = true;//Автоматическое масштабирование, обязательно перед таймером.
                    tmrScale.running = true;//запускаем таймер, перед переходом на страницу
                }
                else{//Если первичное масштабирование произошло, то...
                    if(!pmpDoc.blGoToPage){//Если не было стартового перехода на страницу, то...
                        pmpDoc.blGoToPage = true;//Активируем флаг, что начался первичный переход на страницу.
                        console.error("199:Timer tmrGoToPage start");
                        tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
                    }
                }
            }
        }
        onRenderScaleChanged: {//Если масштаб изменился, то...
            root.rlMasshtab = pmpDoc.renderScale;//Присваемаем масштаб внутри виджета.
            root.sgnRenderScale(root.rlMasshtab);//отправляем сигнал со значением масштаба
            console.error("208:Масштаб поменялся, сбрасываем сцену.")
            if(!pmpDoc.blResetScene){//Если это первичное масштабирование, то...
                pmpDoc.blResetScene = true;//Изменяем флаг, чтоб последующие масштабирования были качественные
                //Это быстрый способ, но с ошибками в консоли, так как документ обнуляется.
                let doc = pmpDoc.document;//Запоминаем pdf документ.
                pmpDoc.document = null;//Выставляем нулевой документ, и тем самым сбрасываем сцену.
                pmpDoc.document = doc;//Восстанавливаем старый документ с обновлённой сценой.
            }
            else{//Дальнейший медленный сброс сцены, он корректно масштабирует документ и стабильно. ВАЖНО!
                //Это очень медленный способ, даже на быстром компьютере, но без ошибок.
                pmpDoc.anchors.fill = undefined;//Не определен якорь.
                pmpDoc.width = pdfDoc.pagePointSize(0).width * pmpDoc.renderScale;//Задаём посчитанную длину.
                pmpDoc.height = pdfDoc.pagePointSize(0).height * pmpDoc.renderScale * pdfDoc.pageCount//Ширину
                pmpDoc.anchors.fill = parent;//Растягиваем pmpDoc, и тем самым пересчитываем Сцену.
            }
        }
    }
    property PdfSearchModel searchModel: PdfSearchModel {
        document: pdfDoc // модель завязана на документ внутри этого скоупа
    }
    function setSearchText(text) {
        searchModel.searchString = text
    }
    // Дополнительные элементы управления, если нужно
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
}
