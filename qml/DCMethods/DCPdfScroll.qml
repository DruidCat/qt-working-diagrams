import QtQuick
//DCPdfScroll - скролл страниц pdf документа
Item {
    id: root
    //Свойства
    //var, а не Flickable: нужен метод itemAtIndex, он есть у ListView, а не у Flickable.
    property var flickable//Скрытый указатель на ListView внутри PdfMultiPageView
    property int currentPage: -1//Номер действующей страницы (привязывается к pmpDoc.currentPage)
    property int pageCount: 0//Количество страниц в документе
    readonly property int ntStepScroll: 10//Документ листается клавишами за 10 нажатий на страницу.
    readonly property real rlEps: 2//Допуск в пикселях при проверке достижения края страницы.
    readonly property real viewWidth: flickable ? flickable.width : 0//Ширина видимой области
    readonly property real viewHeight: flickable ? flickable.height : 0//Высота видимой области
    //Сигналы.
    signal sgnGoToPage(int ntStranica)//Просьба перейти на страницу (вместо присваивания currentPage).
    //Настройки
    onFlickableChanged: {//Проверяем, что внутри действительно TableView.
		if(flickable && !flickable.itemAtCell)
			console.warn("DCPdfScroll: у flickable нет itemAtCell, скролл по страницам работать не будет.")
	}
    //Функции.
	function pageRect(){//Геометрия действующей страницы в пикселях контента. null - делегата ещё нет.
		if(!flickable || !flickable.itemAtCell || currentPage < 0) return null
		const cnItem = flickable.itemAtCell(Qt.point(0, currentPage))//TableView: колонка 0, строка = страница
		if(!cnItem) return null
		return { top: cnItem.y, bottom: cnItem.y + cnItem.height, width: cnItem.width }
	} 
    function maxY(rect){//Максимальная contentY на странице. Если страница влезает во view, то равна верху.
		return Math.max(rect.top, rect.bottom - viewHeight + flickable.bottomMargin)
    }
    function clampX(x, rect){//Ограничение координаты X в пределах страницы.
        const cnWidth = Math.max(flickable.contentWidth, rect.width)//Ширина контента
		return Math.max(0, Math.min(x, Math.max(0, cnWidth + flickable.rightMargin - viewWidth)))
    }
	function clampY(y, rect){//Ограничение координаты Y в пределах страницы.
		const cur = flickable.contentY
		const lo = Math.min(rect.top, cur)//Уже выше верха - выше не пускаем, но и не дёргаем.
		const hi = Math.max(maxY(rect), cur)//Уже ниже низа - ниже не пускаем, но и не дёргаем.
		return Math.max(lo, Math.min(y, hi))
	}
	function stepY(rect){//Шаг скролла по вертикали.
		//Коэффициент 0.9 оставляет около 10 % перекрытия, чтобы взгляд не терял строку
		return Math.min((rect.bottom - rect.top) / ntStepScroll, viewHeight * 0.9)
	}
	function stepX(rect){//Шаг скролла по горизонтали.
		//Коэффициент 0.9 оставляет около 10 % перекрытия, чтобы взгляд не терял строку
		return Math.min(rect.width / ntStepScroll, viewWidth * 0.9)
	}
    function fnKeyVniz(){//Функция скролла вниз страницы.
        const rect = pageRect()
        if(!rect) return//Страница ещё не готова.
        if(flickable.contentY >= maxY(rect) - rlEps && (currentPage + 1) < pageCount)//Достигли низа страницы.
            sgnGoToPage(currentPage + 1)//Листаем на +1 страницу.
        else//Иначе двигаем документ на шаг.
            flickable.contentY = clampY(flickable.contentY + stepY(rect), rect)
    }
    function fnKeyVverh(){//Функция скролла вверх страницы.
        const rect = pageRect()
        if(!rect) return
        if(flickable.contentY <= rect.top + rlEps && currentPage > 0)//Достигли верха страницы.
            sgnGoToPage(currentPage - 1)//Листаем на -1 страницу.
        else
            flickable.contentY = clampY(flickable.contentY - stepY(rect), rect)
    }
    function fnKeyVlevo(){//Функция скролла влево страницы.
        const rect = pageRect()
        if(!rect) return
        flickable.contentX = clampX(flickable.contentX - stepX(rect), rect)
    }
    function fnKeyVpravo(){//Функция скролла вправо страницы.
        const rect = pageRect()
        if(!rect) return
        flickable.contentX = clampX(flickable.contentX + stepX(rect), rect)
    }
    function fnPageMove(dx, dy){//Функция движения pdf мышкой с ограничением в границах страницы.
        const rect = pageRect()
        if(!rect) return
        flickable.contentX = clampX(flickable.contentX + dx, rect)
        flickable.contentY = clampY(flickable.contentY + dy, rect)
    }
}
