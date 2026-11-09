import QtQuick
import QtQuick.Pdf
import QtQuick.Controls
import QtQuick.Layouts
import DCButtons 1.0//Импортируем кнопки
import DCMethods 1.0//Импортируем методы написанные мной.
import QtQml.Models//Для DelegateModel
Item {
    id: root
    //Свойства.
    property string source: ""// Свойство для установки пути к PDF
    property string password: ""//Пароль для pdf документа.
    property real renderScale: 1//Коэффициент масштаба 1.
    property int currentPage : -1//Номер страницы устанавливаемый вне виджет(set).(не путать с ntStranica)
    property alias nomerStranici: pmpDoc.currentPage//Номер страницы внутри виджета(get).
    property alias pageCount: pdfDoc.pageCount//Общее количество страниц в документе.
    property alias searchString: pmpDoc.searchString//Запрос на поиск.
    //property int searchCount: cppqml.pdfPoisk.ntSchetchik//Количество совпадений при поиске.
    property int searchCount: pmpDoc.searchModel.count//Количество совпадений при поиске.
    property bool isSearch: cppqml.pdfPoisk.isPoisk//true - поиск идёт, false - поиск остановлен.
    property alias rotation: pmpDoc.rotation//Поворот сцены документа.
    property alias pageRotation: pmpDoc.pageRotation//Поворот страниц документа.
    property alias straniciVisible: rctStranici.visible//Вкл/Выкл дополнительное окно с количеством страниц.
    property int ntWidth: 1//Длина символа для боковой панели
    property int ntCoff: 8//Коэффициент для боковой панели
    property color clrTexta: "Orange"
    property color clrFona: "Black"
    property color clrMenuFon: "SlateGray"
    property color clrPoisk: "Yellow"
    property bool isMobile: true//true - мобильная платформа.
    property bool isVidelit: isMobile ? true : false//true - режим выделения текста, false - режим движения
    property int ntScrollMargin: root.isMobile ? 0 : 7//Ширина/высота ползунка полосы прокрутки.
	property int msWatchdog: 70000//Время сторожа открытия в миллисекундах (70000 = 1 мин 10 с).
	property real renderScaleWidth: 0//Масштаб «ширина страницы = ширине окна» у горизонтального документа. 0 - промежуточной ступени нет.
    property bool blLog: true//true - отладочные сообщения включены, false - выключены (для релиза).
    property alias sbCurrentIndex: dcSidebar.currentIndex//Индекс открытой вкладки в боковой панели.
    property int currentResult: -1//Номер Поиска, совпадение от 0....
	property bool _isPoiskNextStart: false//Начался поиск следующего элемента на мобильном устройстве
	property bool _isPoiskPreviousStart: false//Начался поиск предыдущего элемента на мобильном устройстве
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
    signal clickedPoisk()//Сигнал о том, что открываем Поиск.
    signal clickedInfo();//Сигнал нажатия кнопки Информация
    signal sgnOpenedSidebar(bool blOpened)//Сигнал о том, что боковая панель открыта/закрыта
    signal sgnFocus()//Сигнал о том, что фокус на DCPdfMPV
    //Функции.
    function fnLog(ntShag, strText){//Единая точка отладочных сообщений.ntShag: 1-11 шаг загрузки,0 - без шага
        if(!root.blLog) return//В релизе не шумим.
        console.log("pdf" + (ntShag > 0 ? " [" + ntShag + "/11]" : "") + ": " + strText)//Обычный цвет
    }
    Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
        root.sgnFocus()//Излучаем сигнал, так как фокус на DCPdfMPV перещёл.
        //cppqml.strDebug = event.key;
    }
    function fnCopyToClipboard(){//Функция копирования выделенного текста в буфер обмена.
        if(pmpDoc.selectedText !== "")//Если выбранный текст не пустота, то...
            pmpDoc.copySelectionToClipboard()//Копировать выделенный текст в документе
    }
    function fnClickedKeyPgDown(){//Функция нажатия клавиши Page Down
        var ntStrDown = pmpDoc.currentPage + 1;//+1 страница
        if(ntStrDown < pdfDoc.pageCount) pmpDoc.goToPage(ntStrDown)//Листаем страницы документа.
    }
    function fnClickedKeyPgUp(){//Функция нажатия клавиши Page Up
        var ntStrUp = pmpDoc.currentPage - 1;//-1 страница
        if(ntStrUp >= 0) pmpDoc.goToPage(ntStrUp)//Листаем страницы документа.
    }
    function fnClickedKeyVniz(){//Функция нажатия клавиши вниз
        if(dcSidebar.opened){//Если открыта боковая панель, то...
            if(dcSidebar.currentIndex === 0)//Если открыта вкладка Найдено, то...
                dcSidebar.fnNaidenoNext()//Функция перехода к следующему результату в списке.
            else//Если нет, то работает скролл страницы
                dcScroll.fnKeyVniz()//Функция скролла вниз страницы.
        }
        else//Если боковая панель не открыта, то...
            dcScroll.fnKeyVniz()//Функция скролла вниз страницы.
    }
    function fnClickedKeyVverh(){//Функция нажатия клавиши вверх
        if(dcSidebar.opened){//Если открыта боковая панель, то...
            if(dcSidebar.currentIndex === 0)//Если открыта вкладка Найдено, то...
                dcSidebar.fnNaidenoPrevious()//Функция перехода к предыдущему результату в списке.
            else//Если нет, то работает скролл страницы
                dcScroll.fnKeyVverh()//Функция скролла вверх страницы.
        }
        else//Если боковая панель не открыта, то...
            dcScroll.fnKeyVverh()//Функция скролла вверх страницы.
    }
    function fnClickedKeyVlevo(){//Функция нажатия клавиши влево.
        dcScroll.fnKeyVlevo()//Функция скролла влево страницы
    }
    function fnClickedKeyVpravo(){//Функция нажатия клавиши вправо.
        dcScroll.fnKeyVpravo()//Функция скролла вправо страницы
    }
    function fnModelPoisk(index){//Функция возвращающая объект модели на конкретный currentResult
        const cnModel = dlmPoisk.items.get(index);//Получаем объект на конкретный currentResult
        return cnModel ? cnModel.model : null;//если модель пустая, возвращаем null, если нет, то модель
    }
    function fnClickedKeyEnter(){//Функция перехода нажатия клавиши Enter.
        if(dcSidebar.opened){//Если боковая панель открыта, то...
            if(dcSidebar.currentIndex === 0)//Если открыта вкладка Найдено, то...
                dcSidebar.fnNaidenoEnter()//Функцию нажатия на клавишу Enter.
        }
        else//Если боковая панель не открыта
            fnClickedPoiskNext()//Функция перехода к следующему номеру поиска
    }
    function fnClickedPoiskStop(){//Функция остановки поиска.	
        root.currentResult = -1//Чтоб в пустом поиске не было 1
        root.searchString = "";//Сбрасываем поисковую модель именно сдесь, чтоб не было loop цикла.
    }
    function fnClickedPoiskNext(){//Функция перехода к следующему номеру поиска
		if (root.isMobile) {//Если мобильное устройство, то...
			if (dcSidebar.opened){//Если боковая панель открыта, то...
				root._isPoiskNextStart = true//Начинаем закрытие боковой панели, взводим флаг
				dcSidebar.close()//Закрываем боковую панель	
			} else pmpDoc.searchModel.currentResult += 1//Выбираем следующий номер поиска Если это не Мобильно
		} else pmpDoc.searchModel.currentResult += 1//Выбираем следующий номер поиска Если это не Мобильное
        
    }
    function fnClickedPoiskPrevious(){//Функция перехода к предыдущему номеру поиска
		if (root.isMobile) {//Если мобильное устройство, то...
			if (dcSidebar.opened){//Если боковая панель открыта, то...
				root._isPoiskPreviousStart = true//Начинаем закрытие боковой панели, взводим флаг
				dcSidebar.close()//Закрываем боковую панель
			} else pmpDoc.searchModel.currentResult -= 1//Выбираем предыдущий номер поиска, если не мобильное
		}
		else pmpDoc.searchModel.currentResult -= 1//Выбираем предыдущий номер поиска, если не мобильное устр
    }
    function fnClickedKeyHome(){//Функция нажатия клавиши Home
       pmpDoc.goToPage(0)//На первую страницу.
    }
    function fnClickedKeyEnd(){//Функция нажатия клавиши End
       pmpDoc.goToPage(pdfDoc.pageCount - 1)//На последнюю страницу
    }
    function fnOpenSidebar(){//Открыть боковую панель (именно открыть, а не переключить).
        if(dcSidebar.opened || tmrSidebar.running) return//Уже открыта или уже открывается.
        if(dcSidebar.position === 0)//Показываем «Загрузка» только если панель полностью закрыта.
            rctZagruzka.visible = true
        tmrSidebar.start()//Откроем через задержку таймера.
    }
    function fnZakritSidebar(){//Закрыть боковую панель.
        tmrSidebar.stop()//Если открытие ещё не стартовало, отменяем.
        rctZagruzka.visible = false//Надпись «Загрузка» гасим всегда.
        dcSidebar.close()//Закрываем боковую панель.
    }
    function fnClickedSidebar(){//Переключатель, только для кнопки.
        if(dcSidebar.position > 0) fnZakritSidebar()
        else fnOpenSidebar()
    }
    function fnInteractiveSidebar(isInteractive){//Функция, которая включает/выключает свайп боковой панели.
        dcSidebar.interactive = isInteractive;//вкл/выкл свайп боковой панели.
    }
    Timer {//Таймер необходим, чтоб надпись «Загрузка» успела отрисоваться до открытия боковой панели.
        id: tmrSidebar
        interval: 3; running: false; repeat: false
        onTriggered: dcSidebar.open()//Открываем боковую панель.
    }
    function fnSidebarNaideno(){//Функция нажатия кнопки Найдено.
        if(dcSidebar.opened && dcSidebar.currentIndex === 0)//Открыта именно эта вкладка, то...
            fnZakritSidebar()//Закрываем боковую панель.
        else{
            fnOpenSidebar()//Если уже открыта, функция сама вернётся.
            dcSidebar.fnNaidenoOpen()//Открываем и фокусируемся на Найдено
        }
    }
    function fnSidebarZakladki(){//Функция нажатия кнопки Закладки.
        if(dcSidebar.opened && dcSidebar.currentIndex === 1)//Открыта именно эта вкладка, то...
            fnZakritSidebar()//Закрываем боковую панель.
        else{
            fnOpenSidebar()
            dcSidebar.fnZakladkiOpen()//Открываем и фокусируемся на Закладках
        }
    }
    function fnSidebarPoster(){//Функция нажатия кнопки Миниатюры.
        if(dcSidebar.opened && dcSidebar.currentIndex === 2)//Открыта именно эта вкладка, то...
            fnZakritSidebar()//Закрываем боковую панель.
        else{
            fnOpenSidebar()
            dcSidebar.fnPosterOpen()//Открываем и фокусируемся на Страницах
        }
    }
	onRenderScaleChanged: {//Если масштаб поменялся из вне, то...
		if(pmpDoc.blRenderScale) return//Это эхо от самого виджета.
		if(!pmpDoc.blScale) return//Первичный конвейер ещё не стартовал.
		fnRestartPipeline("масштаб извне", false, tmrScale)//Ручное масштабирование.
	}	
	onCurrentPageChanged: {//Если страница поменялась из вне, то...
		if(!pmpDoc.blScale) return//Первичный конвейер ещё не запущен: страницу возьмёт он.
		if(root.currentPage < 0 || root.currentPage >= pdfDoc.pageCount) return
		if(pmpDoc.isBusy){//Конвейер идёт: страница назначения просто обновляется.
			pmpDoc.ntPdfPage = root.currentPage
			return
		}
		if(root.currentPage === pmpDoc.currentPage) return
		root.fnLog(0, "Страница " + root.currentPage + " из вне.")
		fnGoToPage(root.currentPage)
	}
	onRotationChanged: Qt.callLater(root.fnOnRotation)//Пауза в такт, чтоб сцена успела повернуться. 
    onSourceChanged: {//Когда меняется источник документа — обновим C++ поиск
        if(root.source && root.source !== "")
            cppqml.pdfPoisk.urlPdf = root.source//Отправляем адрес файла в бизнес логику.
    }
    onSearchStringChanged: {//Когда меняется поисковая строка — отдадим её в C++
        cppqml.pdfPoisk.strPoisk = root.searchString;//Отправляем поисковый запрос в бизнес логику.
        if(root.searchString){//Если не пустая строка, то...
            if(dcSidebar.opened){//Если боковая панель открыта, то...
                if(dcSidebar.currentIndex !== 0)//Если открыта вкладка не Найдено, то...
                    dcSidebar.fnNaidenoOpen()//Функция открытия и фокусировки Найдено
            }
            else{//Если боковая панель закрыта (или ещё открывается), то...
                dcSidebar.fnNaidenoOpen()//Функция открытия и фокусировки Найдено
                fnOpenSidebar()//Открываем боковую панель, а не переключаем.
            }
        }
    }
	onWidthChanged: { if(width > 0) fnTimerAppSize() }
	onHeightChanged: { if(height > 0) fnTimerAppSize() }
    function searchForward(){//Функция следующего поиска, пробрасываем вне виджета.
        //pmpDoc.searchForward();
        const cnCount = pmpDoc.searchModel.count//Количество совпадений
        if(cnCount <= 0) return//Совпадений нет, переходить некуда.
        const cnNext = pmpDoc.searchModel.currentResult + 1//Следующий результат
        pmpDoc.searchModel.currentResult = (cnNext >= cnCount) ? 0 : cnNext//После последнего идёт первый.
    }
    function searchBack(){//Функция предыдущего поиска, пробрасываем вне виджета.
        //pmpDoc.searchBack();
        const cnCount = pmpDoc.searchModel.count
        if(cnCount <= 0) return
        const cnPrev = pmpDoc.searchModel.currentResult - 1//Предыдущий результат
        pmpDoc.searchModel.currentResult = (cnPrev < 0) ? cnCount - 1 : cnPrev//Перед первым идёт последний.
    }
	function fnClampPage(ntStranica){//Страница в пределах документа.
		return Math.max(0, Math.min(ntStranica, pdfDoc.pageCount - 1))
	}
	function fnBeginPipeline(){//Общее начало: прячем виджет, взводим isBusy, будим сторожа.
		if(!pmpDoc.isBusy){//Страницу запоминаем только при ПЕРВОМ входе, иначе запомнится 0 из fnScale.
			pmpDoc.isBusy = true
			if(pmpDoc.currentPage >= 0)
				pmpDoc.ntPdfPage = pmpDoc.currentPage
		}
		root.visible = false
		tmrWatchdog.restart()
	}
	function fnStopTimers(){//Останавливаем всё, что запущено конвейером, чтоб старый прогон не дошёл до конца.
		tmrAppSize.stop()
		tmrScale.stop()
		tmrResetScene.stop()
		tmrGoToPage.stop()
		tmrVisible.stop()
	}
	function fnRestartPipeline(strPrichina, blAuto, tmrStart){//ЕДИНАЯ точка запуска конвейера.
		const blNew = !pmpDoc.isBusy//true - конвейер запускается, false - перезапуск посреди прогона.
		fnBeginPipeline()
		fnStopTimers()
		pmpDoc.blPinch = false//Перезапуск полностью заменяет щипок.
		pmpDoc.blScaleAuto = blAuto//Обязательно перед таймером.
		if(blNew){
			fnLog(3, "Старт таймера масштабирования (" + strPrichina + ").")
			sgnProgress(28, "3/11 Старт таймера масштабирования.")
		}
		else
			fnLog(3, "Перезапуск конвейера (" + strPrichina + "), страница " + pmpDoc.ntPdfPage + " сохранена.")
		tmrStart.restart()//tmrScale - обычный запуск, tmrAppSize - с задержкой на изменение размера.
	}
	function fnOnRotation(){//Именно именованная функция, чтоб Qt.callLater склеивал повторные вызовы.
		if(!pmpDoc.blScale) return//Первичный конвейер ещё не стартовал, он возьмёт актуальный поворот.
		pmpDoc.blRotation = true//Изменился поворот документа.
		fnRestartPipeline("поворот", true, tmrScale)
	}
	function fnTimerAppSize(){//Вызывается при каждом изменении размера окна.
		if(!pmpDoc.blScale) return//Первичный конвейер ещё не стартовал, он возьмёт актуальный размер.
		fnRestartPipeline("размер окна", true, tmrAppSize)//Конвейер перезапускается, пока окно тянут.
	}
	function fnScale(){//Функция авто/руч. масштабирования в зависимости от формата pdf документа.
		pmpDoc.isScaleStart = true;//Начало масштабирования.
		pmpDoc.goToPage(0);//Переходим на первую страницу, чтоб потом перейти на заданную страницу.
		root.fnLog(5, "Начало масштабирования документа.");
		root.sgnProgress(46, "5/11 Начало масштабирования документа.");
		let rlScaleMin = 0//Минимальный масштаб для DCScale, считается только в автоматическом режиме.
		if(pmpDoc.blScaleAuto){//Если автоматический режим, то...
			const cnFl = pmpDoc.flickable
			const cnW = (cnFl ? cnFl.width : pmpDoc.width) - root.ntScrollMargin//Область без полосы
			const cnH = (cnFl ? cnFl.height : pmpDoc.height) - root.ntScrollMargin
			const isRot90 = !((root.rotation === 0) || (root.rotation === 180))//Сцена повёрнута на 90/270.
			const isVisGor = pdfDoc.isDocVert ? isRot90 : !isRot90//true - документ на экране выглядит горизонтальным.
			if(isVisGor){//Горизонтальный документ: две ступени масштаба.
				pmpDoc.scaleToPage(cnW, cnH)//Высота страницы = высоте окна.
				const rlPage = pmpDoc.renderScale
				pmpDoc.scaleToWidth(cnW, cnH)//Ширина страницы = ширине окна, это стартовый масштаб, как раньше.
				const rlWidth = pmpDoc.renderScale
				if(rlPage < rlWidth * 0.99){//Страница по высоте даёт заметно меньший масштаб, вторая ступень есть.
					root.renderScaleWidth = rlWidth//Промежуточная ступень.
					rlScaleMin = rlPage//Новый минимум.
				}
				else{//Страница очень широкая: ступень одна, как раньше.
					root.renderScaleWidth = 0
					rlScaleMin = rlWidth
				}
			}
			else{//Вертикальный документ, всё как раньше.
				pmpDoc.scaleToPage(cnW, cnH)
				root.renderScaleWidth = 0
				rlScaleMin = pmpDoc.renderScale
			}
		}
		else
			pmpDoc.renderScale = root.renderScale;//Выставляем масштаб из Свойства.
		root.fnLog(6, "Окончание масштабирования документа.")
		root.sgnProgress(55, "6/11 Остановка анимации: ожидайте.");
		if(pmpDoc.blScaleAuto)//Минимум меняется только при автоматическом масштабировании.
			root.sgnScaleMin(rlScaleMin)//Минимальный масштаб в DCScale.
		pmpDoc.isSceneReset = true;//Сброс сцены запланирован: ошибки рендера Null/Error игнорируем.
		tmrResetScene.running = true;//запускаем таймер, сброса сцены.
	}
    function fnGoToPage(ntStranica){//Функция обрабатывающая переход на новую страницу документа.
		if(pdfDoc.pageCount <= 0) return
    	ntStranica = fnClampPage(ntStranica)//Защита от -1 и выхода за конец.
		root.fnLog(10, "Переходим на страницу: " + ntStranica);
		root.sgnProgress(91, "10/11 Переходим на страницу.");
		const cnFl = pmpDoc.flickable
		//После поворота старый contentX относится к прежней сцене, поэтому берём левый край страницы.
		const cnX = (cnFl && !pmpDoc.blRotation) ? cnFl.contentX / pmpDoc.renderScale : 0
		pmpDoc.goToLocation(ntStranica, Qt.point(cnX, 0), pmpDoc.renderScale)
		root.fnLog(11, "Старт таймера видимости.");
		root.sgnProgress(100, "11/11 Старт таймера отображения.");
		tmrVisible.running = true;//Запускаем таймер отображения документа.
	}
	function fnVremya(ntMs){//Переводит миллисекунды в текст «N мин M с», минуты не пишем, если их 0.
        const cnSek = Math.round(ntMs / 1000)//Всего секунд.
        const cnMin = Math.floor(cnSek / 60)//Целых минут.
        const cnOst = cnSek % 60//Оставшиеся секунды.
        return (cnMin > 0 ? cnMin + " мин " : "") + cnOst + " с"
    }
    Timer {//Таймер сброса сцены документа, чтоб сцена пересчиталась под новый масштаб.
        id: tmrResetScene
        interval: 3; running: false; repeat: false
        onTriggered: {
            root.sgnProgress(64, "7/11 Сброс сцены документа.");
            pmpDoc.isSceneReset = true;//Подстраховка: на случай, если таймер запущен не из fnScale.
            if(pmpDoc.flickable && pmpDoc.flickable.forceLayout) {//Если внутренности есть, то...
                root.fnLog(7, "Сброс сцены документа: forceLayout.")
                //Это быстрый способ сброса сцены
                pmpDoc.flickable.forceLayout()//Это способ сброса сцены через внутренности pmpDoc.flickable
            } else {//Если внутренности после обновления Qt не работают, то старый способ, долгий.
                root.fnLog(7, "Сброс сцены документа: document = null.")
                //Это тяжелый способ сброса сцены, но при нём документ на миг обнуляется.
                const doc = pmpDoc.document;//Запоминаем pdf документ.
                pmpDoc.document = null;//Выставляем нулевой документ, и тем самым сбрасываем сцену.
                pmpDoc.document = doc;//Восстанавливаем старый документ с обновлённой сценой.
            }
            pmpDoc.isScaleStart = false;//Окончание масштабирования, это для щипка.
            root.fnLog(8, "Старт таймера страницы.")
            root.sgnProgress(73, "8/11 Старт таймера страницы.");
            tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
        }
    }
    Timer {//Таймер необходим, чтоб пока пользователь изменяет размер окна приложения,не обрабатывался масштаб
        id: tmrAppSize
        interval: 333; running: false; repeat: false
        onTriggered: {
            pmpDoc.blScaleAuto = true;//Автоматический режим масштабирования по размеру виджета
            fnScale();//Выставляем масштаб по ширине или по высоте в зависимости от размера документа.
        }
    }
    Timer {//Таймер необходим, чтоб pdf документ успел загрузиться, и можно было масштабировать документ.
        id: tmrScale
        interval: 111; running: false; repeat: false
        onTriggered: {
            root.fnLog(4, "Стоп таймера масштабирования.");
            root.sgnProgress(37, "4/11 Стоп таймера масштабирования.");
            fnScale();//масштабируем документ автоматически/вручную.
        }
    }
	Timer {//Таймер необходим, чтоб pdf документ успел смаштабироваться, и можно было выставить страницу.
		id: tmrGoToPage
		interval: 777; running: false; repeat: false
		onTriggered: {
			pmpDoc.isSceneReset = false//Сброс сцены закончился, статусы рендера снова обрабатываем.
			pmpDoc.blPinch = false//Сбрасываем флаг
			root.fnLog(9, "Стоп таймера страницы.")
			root.sgnProgress(82, "9/11 Стоп таймера страницы.")
			fnGoToPage(pmpDoc.ntPdfPage)//Единая страница назначения для всех входов.
		}
	}
    Timer {//Таймер необходим, чтоб после перехода на страницу произошла небольшая пауза, минимум 333.
        id: tmrVisible
        interval: 333; running: false; repeat: false
        onTriggered: {
			tmrWatchdog.stop()//Конвейер дошёл до конца, сторож не нужен.
            root.fnLog(0, "Отображаем ваш документ.");
			pmpDoc.isBusy = false//Конвейер закончен.
            pmpDoc.blRotation = false;//Сбрасываем флаг поворота документа.
            root.visible = true;//Видимый виджет
			if(pmpDoc.currentPage >= 0){
				root.sgnCurrentPage(pmpDoc.currentPage)//Страницу отдаём один раз, в конце.
				dcSidebar.posterIndex = pmpDoc.currentPage
			}
        }
    }
    Timer {//Таймер необходим, чтоб чтоб после аварии закрыть страницу.
        id: tmrError
        interval: 111; running: false; repeat: false
        onTriggered: {
            root.sgnProgress(100, "11/11 Ошибка, окончание загрузки.");
            if(pmpDoc.blPassword){//Если был запрос на пароль, то...
                root.fnLog(11, "Запрос пароля, окончание загрузки.");
                pmpDoc.blPassword = false;//Сбрасываем флаг.
            }
            else{//Если не было запроса на пароль, то это ошибка обычная...
                console.error("DCPdfMPV: ошибка, окончание загрузки: " + pdfDoc.error);//ошибка красная
                root.sgnDebug(qsTr("Ошибка открытия документа: ") + pdfDoc.error);//Передаём ошибку.
                root.sgnError();//Закрываем документ.
            }
        }
    }
    Timer {//Сторож открытия: если конвейер не дошёл до tmrVisible, показываем pdf как есть.
        id: tmrWatchdog
        interval: root.msWatchdog; running: false; repeat: false//1 минуты 10 секунды.
        onTriggered: {
            console.warn("DCPdfMPV: watchdog, документ не открылся за " + root.fnVremya(root.msWatchdog) +
                         ", показываю как есть.",
                         "blScale=" + pmpDoc.blScale, "isSceneReset=" + pmpDoc.isSceneReset,
                         "isScaleStart=" + pmpDoc.isScaleStart, "isBusy=" + pmpDoc.isBusy,
                         "status=" + pdfDoc.status, "page=" + pmpDoc.currentPage)//Где именно застряли.
            pmpDoc.isSceneReset = false;//Сбрасываем состояния конвейера,чтоб не остались взведёнными навсегда
            pmpDoc.isScaleStart = false;
            pmpDoc.isBusy = false;//Иначе изменение размера окна больше не будет обрабатываться.
            pmpDoc.blRotation = false;
            root.sgnProgress(100, "11/11 Таймаут открытия: документ показан как есть.");
            root.visible = true;//Показываем документ как есть.
            if(pmpDoc.currentPage >= 0){//-1 в боковую панель не отдаём.
				root.sgnCurrentPage(pmpDoc.currentPage)
                dcSidebar.posterIndex = pmpDoc.currentPage//Подсвечиваем миниатюру, как в tmrVisible.
			}
        }
    } 
    PdfMultiPageView {
        id: pmpDoc
        anchors.fill: root
        anchors.leftMargin: dcSidebar.position * dcSidebar.width - dcSidebar.position * root.ntCoff
        searchString: ""
        //Иннициализация Свойств при каждой загрузке, от сюда берутся первоначальные данные Свойств.
        property bool isSceneReset: false//true - идёт сброс сцены, статусы рендера Null/Error игнорируем.
        property bool blScale: false//true - когда в pdf документе масштабирование произошло.
        property bool blRenderScale: false//Флаг предотвращающий рекурсию root.renderScale
        property bool blScaleAuto: true//true - автоматическое масштабирование. false - ручное масштабирование
        property bool isScaleStart: false//true - когда pdf документ изменяет масштаб.
		property bool isBusy: false//true - конвейер открытия/масштабирования идёт, документ скрыт.
        property bool blPinch: false//true - когда пользователь щипком изменил масштаб.
        property bool blRotation: false//true - нажата кнопка поворота документа.
        property int ntPdfPage: 0//Номер страницы запомненный перед изменением масштаба root.renderScale.
        property bool blPassword: false//true - когда в pdf документе запрашиваем пароль.
        //Scroll мышью документа
        property bool handMode: true//Режим "рука" активирован
        property bool spacePressed: false//true - Мышка нажата ЛКМ, false - ЛКМ не нажата.
        //Скрытые указатели PdfMultiPageView
        property var verticalScrollbar//Недокументированный указатель на scrollbar
        property var flickable//Недокументированный указатель на flickable
        document: PdfDocument {
            id: pdfDoc
            //Свойства
            property bool isDocVert: true//true - вертикальный документ, false - горизонтальный документ.
            property real rlWidth: 0//Длина текущей страницы
            property real rlHeight: 0//Высота текущей страницы
            //Настройки
            source: root.source//Привязываем источник PDF
            password: root.password//Пароль для pdf документа.
            onStatusChanged: {
                if(pdfDoc.status === PdfDocument.Error){//enum, если статус Ошибка, то...
					tmrWatchdog.stop()//Документ не открылся по настоящей причине, сторож не нужен.
                    console.error("DCPdfMPV [10/11]: статус документа Ошибка, старт таймера ошибки.");//ошибка
                    root.sgnProgress(91, "10/11 Старт таймера ошибки.");
                    tmrError.running = true;//Запускаю таймер с обработчиком ошибки. ТАЙМЕР КРИТИЧЕСКИ ВАЖЕН.
                }
                else if(pdfDoc.status === PdfDocument.Ready){//Если pdf документ загрузился, то...
                    root.fnLog(2, "Статус документа: Готов.");
                    root.sgnProgress(19, "2/11 Загрузка большого документа.");
                    if(pdfDoc.pageCount > 0){//Защита от пустого документа.
                        //Берём заданную страницу, но не меньше 0 и не больше последней.
                        const cnPage = Math.max(0, Math.min(root.currentPage, pdfDoc.pageCount - 1))
                        const cnSize = pdfDoc.pagePointSize(cnPage)//Размер страницы в пунктах.
                        pdfDoc.rlWidth = cnSize.width//Запоминаем ширину.
                        pdfDoc.rlHeight = cnSize.height//Запоминаем высоту.
                        pdfDoc.isDocVert = (cnSize.height >= cnSize.width)//true - вертикальный документ.
                    }
                }
                else if(pdfDoc.status === PdfDocument.Loading){//Если pdf документ загружается, то...
					tmrWatchdog.restart()//Запуск/перезапуск сторожа
                    root.fnLog(1, "Статус документа: Загрузка.");
                    root.sgnProgress(10, "1/11 Статус документа: Загрузка.");
                }
            }
            onPasswordRequired: {//Если пришёл сигнал passwordRequire запроса пароля в pdf документе, то...
				tmrWatchdog.stop()//Пока пользователь вводит пароль, сторож молчит. Перезапустится на загрузке
                root.fnLog(0, "Запрашиваю пароль.")
                pmpDoc.blPassword = true;//Запрашиваю пароль.
                root.sgnPassword();//Сигнал о том, что есть запрос на ввод пароля.
            }
        }
		onCurrentPageChanged: {//Если страница документа изменилась, то...
			const cnStranica = pmpDoc.currentPage//Номер страницы
			if(cnStranica < 0) return//Если страница -1, выходим из обработчика, так как это ошибка.
			if(!pmpDoc.isScaleStart){//Если не изменяется масштаб с перескоком на 0 страницу, то...
				const cnSize = pdfDoc.pagePointSize(cnStranica)//Один вызов вместо двух.
				if(pdfDoc.rlWidth !== cnSize.width || pdfDoc.rlHeight !== cnSize.height){
					pdfDoc.rlWidth = cnSize.width
					pdfDoc.rlHeight = cnSize.height
					pdfDoc.isDocVert = (cnSize.height >= cnSize.width)
					root.fnLog(0, "Размер страницы изменился, нужно менять масштаб.")
				}
				if(pmpDoc.blScale && !pmpDoc.isBusy){//Во время конвейера промежуточные 0 наружу не отдаём.
					root.sgnCurrentPage(cnStranica)//Сигнал с номером страницы отсылаем.
					dcSidebar.posterIndex = cnStranica//Для перескока на конкретную минниатюру в sidebar.
				}
			}
		}
        onCurrentPageRenderingStatusChanged: {//Если рендер страницы изменился, то...
            switch(pmpDoc.currentPageRenderingStatus){
            case Image.Loading://Статус рендеринга страницы ЗАГРУЗКА.
                root.fnLog(0, "Рендер страницы " + pmpDoc.currentPage + ": Загрузка.");
                break;
            case Image.Ready://Статус рендеринга страницы ОТКРЫТ.
                root.fnLog(0, "Рендер страницы " + pmpDoc.currentPage + ": Открыт.");
                if(!pmpDoc.blScale){//Если стартового масштабирование не было, то...
                    pmpDoc.blScale = true;//Активируем флаг, что началось первичное масштабирование.
                    root.fnRestartPipeline("первичный", true, tmrScale)
    				pmpDoc.ntPdfPage = root.fnClampPage(root.currentPage)//Стартовая страница из вне (при -1 будет 0).
                }
                else if(pmpDoc.blPinch && !pmpDoc.isSceneReset){//Щипок был, и сброс сцены ещё не запущен, то.
                    pmpDoc.isSceneReset = true;//Взводим сразу, чтоб повторный Ready не запустил второй сброс.
                    pmpDoc.goToPage(0);//Переходим на первую страницу, потом goTo на заданную страницу
                    root.fnLog(6, "Окончание масштабирования документа (щипок).")
                    root.sgnProgress(55, "6/11 Остановка анимации: ожидайте.");
                    tmrResetScene.running = true;//запускаем таймер, сброса сцены.
                }
                break;
            case Image.Error://Статус рендеринга страницы ОШИБКА.
                if(pmpDoc.isSceneReset || pmpDoc.isScaleStart){//Это не авария, а сброс сцены.
                    root.fnLog(0, "Рендер Error проигнорирован: идёт сброс сцены.");
                    break;
                }
				tmrWatchdog.stop()//Настоящая авария, документ закрывается, показывать нечего.
                console.error("DCPdfMPV [11/11]: ошибка рендера страницы " + pmpDoc.currentPage);//Ошибка крас
                root.sgnProgress(100, "11/11 Ошибка рендера страницы.");
                root.sgnDebug(qsTr("Ошибка рендера страницы."));//Передаём ошибку.
                root.sgnError();//Закрываем документ.
                break;
            case Image.Null://Статус рендеринга страницы Null
                if(pmpDoc.isSceneReset || pmpDoc.isScaleStart){//Это не авария, а сброс сцены.
                    root.fnLog(0, "Рендер Null проигнорирован: идёт сброс сцены.");
                    break;
                }
				tmrWatchdog.stop()//Настоящая авария, документ закрывается, показывать нечего.
                console.error("DCPdfMPV [11/11]: рендер страницы " + pmpDoc.currentPage + " Null");//Ошибка.
                root.sgnProgress(100, "11/11 Рендера страницы Null.");
                root.sgnDebug(qsTr("Рендера страницы Null."));//Передаём ошибку.
                root.sgnError();//Закрываем документ.
                break;
            }
        }
		onRenderScaleChanged: {//Если масштаб изменился, то...
			if(!pmpDoc.isScaleStart && pmpDoc.blScale){//Масштаб изменил пользователь щипком.
				pmpDoc.blPinch = true//То это увеличение масштаба пользователем через щипок
				root.fnBeginPipeline()//Только прячем и запоминаем страницу. Таймеры не трогаем: вход идёт через Image.Ready.
			}
			pmpDoc.blRenderScale = true//Взводим флаг, предотвращаем обработку root onRenderScaleChanged
			root.renderScale = pmpDoc.renderScale//Присваемаем масштаб внутри виджета.
			pmpDoc.blRenderScale = false//ОБЯЗАТЕЛЬНО сбрасываем флаг.
		}
        Component.onCompleted: {//Когда полностью загрузился виджет PdfMultiPageView, то...
            pmpDoc.verticalScrollbar = pmpDoc.fnPoiskScrollbar(pmpDoc)//Находим указатель на вертикалScrollbar
            pmpDoc.flickable = pmpDoc.fnPoiskFlickable(pmpDoc)//Находим указатель на Flickable
            pmpDoc.fnProverkaFlickable()//Предупреждаем, если устройство PdfMultiPageView не то, без flickable
        }
        function fnPoiskScrollbar(target){//Функция поиска Вертикального Scrolbar в детях PdfMultiPageView.
            for(let ltShag = 0; ltShag < target.children.length; ltShag++){//Цикл поиска в детях.
                const idScrollbar = target.children[ltShag]//Ищем в детях pmpDoc
                if(idScrollbar instanceof ScrollBar && idScrollbar.orientation === Qt.Vertical)
                    return idScrollbar
                const cnNashel = pmpDoc.fnPoiskScrollbar(idScrollbar)//Рекурсивно ищем в потомках.
                if(cnNashel) return cnNashel
            }
            return null//Если ничего не найдено, возвращаем нулевой указатель.
        }
        function fnPoiskFlickable(target){//Функция поиска Flickable в детях PdfMultiPageView.
            for(let ltShag = 0; ltShag < target.children.length; ltShag++){//Цикл поиска в детях.
                const idFlickable = target.children[ltShag]//Ищем в детях pmpDoc
                if(idFlickable instanceof Flickable) return idFlickable
                const cnNashel = pmpDoc.fnPoiskFlickable(idFlickable)//Рекурсивно ищем в потомках.
                if(cnNashel) return cnNashel
            }
            return null//Если ничего не найдено, возвращаем нулевой указатель.
        }
        function fnProverkaFlickable(){//Проверка недокументированных внутренностей PdfMultiPageView.
            const cnFl = pmpDoc.flickable
            if(!cnFl){
                console.warn("DCPdfMPV: внутри PdfMultiPageView не найден Flickable. Не будут работать: " +
                             "клавиши и «рука» (DCPdfScroll), поля под полосы прокрутки, forceLayout.")
                return
            }
            if(typeof cnFl.itemAtCell !== "function")//Метод TableView, на нём держится DCPdfScroll.pageRect()
                console.warn("DCPdfMPV: у flickable нет itemAtCell(), это не TableView:", cnFl,
                             "Скролл по страницам клавишами и «рукой» работать не будет.")
            if(typeof cnFl.forceLayout !== "function")//Метод TableView, им пересчитываем сцену после масштаба
                console.warn("DCPdfMPV: у flickable нет forceLayout(). " +
                             "Сброс сцены пойдёт через document = null.")
            if(!pmpDoc.verticalScrollbar)
                console.warn("DCPdfMPV: вертикальный ScrollBar внутри PdfMultiPageView не найден.")
			else ntScrollMargin = verticalScrollbar.width//Ширина вертикального ползунка из внутренностей.
        }
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Space) {
                spacePressed = true
                event.accepted = true
            }
        }
        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Space) {
                spacePressed = false
                event.accepted = true
            }
        }
        MouseArea {
            id: maDoc
            anchors.fill: pmpDoc
            anchors.rightMargin: root.ntScrollMargin//Не закрываем зону вертикальной полосы прокрутки.
            anchors.bottomMargin: root.ntScrollMargin//Не закрываем зону горизонтальной полосы прокрутки.
            acceptedButtons: Qt.LeftButton//Нажатие левой кнопки мыши
            hoverEnabled: true
            preventStealing: true//Очень важно, чтоб захват мышкой не сбрасывался при движении
            propagateComposedEvents: false
            // Включение режима, когда можно захватить лкм документ и перемещать его.
            enabled: (pmpDoc.handMode || pmpDoc.spacePressed) && !root.isVidelit
            //Вид курсора в зависимости нажатия или нет лкм и в зависимости режима Выделить или Перемещать.
            cursorShape: pressed
                         ? (root.isVidelit ? Qt.IBeamCursor : Qt.ClosedHandCursor)
                         : (root.isVidelit ? Qt.ArrowCursor : Qt.OpenHandCursor)
            property real rlLastX//Последняя запомнившаяся координата X
            property real rlLastY//Последняя запомнившаяся координата Y
            onPressed: (mouse) => {//Если нажата левая кнопка мыши.
                const cnFlickable = pmpDoc.flickable//Создаём указатель на непубличный pmpDoc.flickable
                if (cnFlickable) {//Если указатель существует, то обращаемся к закрытым методам и свойствам.
                    cnFlickable.contentY = cnFlickable.contentY//От микро-дёрганий
                    cnFlickable.cancelFlick()//Прерывает инерциальную прокрутку (flicking)
                    cnFlickable.interactive = false//Отключаем свайпы,pinch-to-zoom,выделение,вращение и т.д.
                }
                rlLastX = mouse.x//Запоминаем позицию мыши по X
                rlLastY = mouse.y//Запоминаем позицию мыши по Y
            }
            onPositionChanged: (mouse) => {//Если изменилась позиция мыши
                if (!(mouse.buttons & Qt.LeftButton))//Если при этом нажата не левая кнопка мыши, то...
                    return//Выходим
                let dx = mouse.x - rlLastX//Дельта по X
                let dy = mouse.y - rlLastY//Дельта по Y
                dcScroll.fnPageMove(-dx, -dy)//Функция передвижения на pdf странице.
                rlLastX = mouse.x//Запоминаем позицию мыши по X
                rlLastY = mouse.y//Запоминаем позицию мыши по Y
            }
            onReleased: fnRestoreInteractive()//Если отпустил правую кнопку мыши.
            onCanceled: fnRestoreInteractive()//Если enabled стал false во время нажатия.
            function fnRestoreInteractive(){
                if (pmpDoc.flickable)//Если указатель существует, то...
                    pmpDoc.flickable.interactive = true//Включаем свайпы, pinch-to-zoom, выделение, вращение
            }
        }
    }
    Binding {//Постоянный запас под вертикальную полосу прокрутки.
        target: pmpDoc.flickable; property: "rightMargin"
        value: root.ntScrollMargin; when: !!pmpDoc.flickable
        restoreMode: Binding.RestoreNone
    }
    Binding {//Постоянный запас под горизонтальную полосу прокрутки.
        target: pmpDoc.flickable; property: "bottomMargin"
        value: root.ntScrollMargin; when: !!pmpDoc.flickable
        restoreMode: Binding.RestoreNone
    }
    Connections {//Автовыбор первого совпадения и переход
        target: pmpDoc.searchModel
        function onCurrentResultChanged(){//Если обрабатываемый результат поиска изменён, то...
            root.currentResult = pmpDoc.searchModel.currentResult//Присваиваем действующий результат поиска.
            if(root.currentResult >= 0){//Проверка на -1, если нет, то...
                const cnModel = fnModelPoisk(root.currentResult);//Получаем объект модели по currentResult
                if (cnModel){//Если модень не null, то...
                    dcSidebar.fnNaidenoIndex(root.currentResult)//Подсвечиваем в боковой панели
                    pmpDoc.goToLocation(cnModel.page,//Номер страницы
                                        Qt.point(cnModel.location.x, cnModel.location.y),//Координаты
                                        pmpDoc.renderScale//Масштаю
                                        )//Переходим на страницу номера поиска.
                }
            }
        }
    }
    Rectangle {//Дополнительный элемент UI отображающий страницы, общее количество и текущую.
        id: rctStranici
        anchors.bottom: root.bottom; anchors.horizontalCenter: root.horizontalCenter
        anchors.bottomMargin: root.ntWidth*root.ntCoff//Отступ от низа
        width: txtStranici.width+root.ntWidth*root.ntCoff; height: txtStranici.height+root.ntCoff
        color: "lightgray"
        clip: true; opacity: 0.6; radius: 50
        visible: true//Видим дополнительный элемент управления.
        Text {
            id: txtStranici
            anchors.centerIn: rctStranici
            font.pixelSize: (root.ntWidth === 2) ? root.ntCoff : root.ntCoff*(root.ntWidth-2)//Размер шрифта
            text: qsTr("Страница ")
                  + ((pmpDoc.currentPage+1)?(pmpDoc.currentPage+1):(dcSidebar.posterIndex+1))//Проверка на -1
                  + qsTr(" из ") + pdfDoc.pageCount
        }
    }
    Rectangle{//Надпись ЗАГРУЗКА
        id: rctZagruzka
        anchors.centerIn: root
        width: txtZagruzka.width+root.ntWidth*root.ntCoff; height: txtZagruzka.height+root.ntCoff
        color: "Lightgray"
        visible: false
        clip: true; opacity: 0.6; radius: 50
        Text{
            id: txtZagruzka
            anchors.centerIn: rctZagruzka
            font.pixelSize: (root.ntWidth === 2) ? root.ntCoff : root.ntCoff*(root.ntWidth-2)//Размер шрифта
            text: qsTr("Загрузка")
        }
    }
    DelegateModel {
        id: dlmPoisk
        model: pmpDoc.searchModel
        delegate: QtObject {//Создаётся лёгкий объект на строку модели, и смогу читать роли по любому индексу
            property int page: model.page
            property var location: model.location
        }
    }
    DCPdfSidebar {
        id: dcSidebar
        //Свойства
        property bool isFirstOpened: false
        //Настройки
        //пробрасываем тему/параметры
        isMobile: root.isMobile
        ntWidth: root.ntWidth
        ntCoff: root.ntCoff
        clrTexta: root.clrTexta
        clrFona: root.clrFona
        clrMenuFon: root.clrMenuFon
        clrPoisk: root.clrPoisk
        //пробрасываем ссылки на пдф-вид и документ
        pmpDoc: pmpDoc//Передаём объект отображения
        pdfDoc: pdfDoc//Передаём объект документа
        //чтобы внешний сигнал продолжил работать
        onOpenedChanged: {//Если состояние боковой панели изменилось, она открыта или закрыта, то...
            if(!isFirstOpened){//Если панель не открывалась ни разу, то...
                isFirstOpened = true;//Взводим флаг первого открытия боковой панели.
                if(root.searchString)//Если поиск уже запущен, то первое открытие — на вкладке Найдено.
                    dcSidebar.fnNaidenoOpen()
                else//Иначе при первом открытии фокусируемся на Закладках.
                    dcSidebar.fnZakladkiOpen()
            }
            root.sgnOpenedSidebar(dcSidebar.opened)//Излучаем сигнал открыта/закрыта панель
            if(dcSidebar.opened) rctZagruzka.visible = false//Если боковая панель открыта, скрываем Загрузку.
        }
		onPositionChanged: {//Если позиция изменяется у боковой панели, то...
			if(!position) {//Если боковая панель закрылась, то...
				if(root._isPoiskNextStart){//Если пришёл сигнал на закрытие боковой панели, то...
					root._isPoiskNextStart = false//СБрасываем флаг
					pmpDoc.searchModel.currentResult += 1;//Выбираем следующий номер поиска
				} else if (root._isPoiskPreviousStart){//Если пришёл сигнал на закрытие боковой панели, то...
					root._isPoiskPreviousStart = false//Сбрасываем флаг
					pmpDoc.searchModel.currentResult -= 1;//Выбираем предыдущий номер поиска
				}
			}
		}
        onClickedPoisk: root.clickedPoisk()//Сигнал о том, что открываем Поиск.
        onClickedInfo: root.clickedInfo()//Сигнал о том, что нажата кнопка Информация.
    }
    DCPdfScroll {//Обработка и расчёт scroll документа
        id: dcScroll
        flickable: pmpDoc.flickable
        currentPage: pmpDoc.currentPage
        pageCount: pdfDoc.pageCount
		onSgnGoToPage: (ntStranica) => { if(!pmpDoc.isBusy) root.fnGoToPage(ntStranica) }//Листаем страницу
    }
}
