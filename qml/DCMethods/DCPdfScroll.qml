import QtQuick //2.15
//DCPdfScroll - скролл страниц pdf документа
Item {
    id: root
    //Свойства
    property var pdfDoc//PdfDocument (pdfDoc)
    property var flickable//Скрытый указатель Flickeble в PdfMultiPageView
    //---scroll---//
    property real pagePointY: 0//Координата начала страницы на действующей странице
    property bool isPagePointY: true;//true - посчитана координата начала страницы. Для 1 стр true!
    property real lastPagePointY: 0//Координата начала страницы на прошлой странице
    property real cachePointY: 0//Временная координата начала страницы при скролле системы на неё.
    property int currentPage: -1//Номер страницы, на которую нужно перейти.
    property bool isCurrentPage: false//true - нужно менять номер странице в mentorPDF. false-запрещено менять
    property int pageCount: 0//Колличество страниц в документе
    property real renderScale: 1//Коэффициент масштаба 1.
    property real pointPageHeight: 0//Действительная высота страницы
    property real pointPageWidth: 0//Действительная ширина страницы
    property real pointRectHeight: 0//Действительная высота прямоугольника сцены
    property real pointRectWidth: 0//Действительная ширина прямоугольника сцены
    readonly property int ntStepScroll: 10;//Шаг скролла клавишами документа.
    property real stepScrollHeight: 0//Шаг скроллинга по вертикали.
    property real stepScrollWidth: 0//Шаг скроллинга по горизонтали.
    property real pointScrollBarWidth: 0//высота самого scrollbar
    //---spacing---//
    property real spacing: 3//приблизительное расстояние между страницами pdf документа
    property real spacingMin: 2.2//приблизительное минимальное расстояние между страницами pdf документа
    property real spacingMax: 7//приблизительное максимальное расстояние между страницами pdf документа
    property bool isSpacing: false//true - расстояние между страницами посчитано.
    property bool isSpacingStart: false//true - fnSpacingStart() уже запускалась.
    //Настройки
    //Сигналы.
    //Функции.
    function fnSteps(){//Функция расчёта шагов скролла.
        stepScrollHeight = pointPageHeight/ntStepScroll//Шар скролла по вертикали.
        stepScrollWidth = pointPageWidth/ntStepScroll//Шаг скролла по горизонтали.
    }
    function fnKeyVniz(){//Функция скролла вниз страницы.
        if(isPagePointY){//Если расчитана координата начала страницы, то...
            var maxHeight = (pagePointY + pointPageHeight) * renderScale
            var coordinataY = flickable.contentY + stepScrollHeight * renderScale
            if((currentPage+1) === pageCount){//Это единственная или последняя страница, то?
                if ((coordinataY + pointRectHeight) > maxHeight)//Если координата больше макс,то
                    flickable.contentY = maxHeight - pointRectHeight//Максимальное значение
                else//Если это не конец документа, то...
                    flickable.contentY = coordinataY//Листаем документ.
            }
            else{
                if (coordinataY > maxHeight){//Если расчитаная координата больше максимальной, то...
                    isCurrentPage = true//Взводим флаг, для защиты от самомызова.
                    currentPage = currentPage + 1//Листаем на +1 страницу.
                    isCurrentPage = false//Сбрасываем флаг.
                }
                else//Если не перескочили координаты за границы страницы,то перескакиваем на коорд. на шаг
                    flickable.contentY = coordinataY//Листаем документ.
            }
        }
        else console.log("ОЖИДАЙТЕ! Страница еще не перескачила на начала страницы.")
    }
    function fnKeyVverh(){//Функция скролла вверх страницы.
        if(isPagePointY){//Если расчитана координата начала страницы, то...
            var minHeight = pagePointY * renderScale//Координата верхнего края страницы.
            var coordinataY = flickable.contentY - stepScrollHeight * renderScale
            if(currentPage < 1){//Если это единственная или первая (0) страница, то?
                if (coordinataY < minHeight)//Если расчитаная координата меньше минимальной, то...
                    flickable.contentY = minHeight//Делаем нулевую координату, не двигаем документ
                else//Если нет, то...
                    flickable.contentY = coordinataY//двигаем документ вверх
            }
            else{
                if (coordinataY < minHeight){//Если расчитаная координата меньше минимальной, то...
                    isCurrentPage = true//Взводим флаг, для защиты от самомызова.
                    currentPage = currentPage - 1//Листаем на -1 страницу.
                    isCurrentPage = false//Сбрасываем флаг.
                }
                else//Если не перескочили координаты за границы страницы,то перескакиваем на коорд. на шаг
                    flickable.contentY = coordinataY//двигаем документ вверх
            }
        }
        else console.log("ОЖИДАЙТЕ! Страница еще не перескачила на начала страницы.")
    }
    function fnKeyVlevo(){//Функция скролла влево страницы.
        if(isPagePointY){//Если расчитана координата начала страницы, то...
            var coordinataX = flickable.contentX - stepScrollWidth * renderScale
            if (coordinataX < 0)//Если расчитаная координата меньше минимальной, то...
                flickable.contentX = 0//Минимальное значение.
            else//Если не перескочили координаты за границы страницы,то перескакиваем на координату на шаг
                flickable.contentX = coordinataX
        }
        else console.log("ОЖИДАЙТЕ! Страница еще не перескачила на начала страницы.")
    }
    function fnKeyVpravo(){//Функция скролла вправо страницы.
        if(isPagePointY){//Если расчитана координата начала страницы, то...
            var maxWidth = pointPageWidth * renderScale;//Максимальная длина страницы
            var coordinataX = flickable.contentX + stepScrollWidth * renderScale
            if ((coordinataX + pointRectWidth) > maxWidth){//Если координата больше максимальной
                flickable.contentX = maxWidth - pointRectWidth + 2 * pointScrollBarWidth
            }
            else//Если не перескочили координаты за границы страницы,то перескакиваем на координату на шаг
                flickable.contentX = coordinataX
        }
        else console.log("ОЖИДАЙТЕ! Страница еще не перескачила на начала страницы.")
    }
    function fnPagePointY(){//Функция высчитывает координату начала страницы по Y
        lastPagePointY = pagePointY;//Приравниваем,чтоб помнить координату Y прошлой стр
        isPagePointY = false;//Начала расчёта начала координаты страницы.
        cachePointY = flickable.contentY/renderScale//координаты начала страницы
        tmrPage.running = true//Запускаем таймер, запоимним стартовую координату Y страницы
    }
    Timer {//Таймер необходим, чтоб высчитать координату начала страницы по Y
        id: tmrPage
        interval: 111; running: false; repeat: false
        onTriggered: {
            const cnPointY = flickable.contentY/renderScale//координаты начала страницы
            if(cachePointY === cnPointY){//Если есть равенство, то страница перестала двигаться
                pagePointY = cnPointY//Приравниваем координату начала страницы.
                isPagePointY = true;//Посчитана координата начала страницы.
                const minPointHeigt = stepScrollHeight * (ntStepScroll -1)
                fnSpacingPagePage(lastPagePointY, pagePointY, pointPageHeight)
                if(pagePointY > lastPagePointY){//Если страницы увеличиваются
                    if(pagePointY < (lastPagePointY + minPointHeigt)){

                    } else {

                    }
                } else {//Если страницы уменьшаются
                    const minPointY = lastPagePointY - minPointHeigt - spacing
                    if(pagePointY > minPointY){//Если больше минимального значения,то
                        pagePointY = lastPagePointY - spacing - pointPageHeight
                    } else {

                    }
                }
            }
            else{//Если страница в процессе анимации перескока на начальную координату страницы, то...
                cachePointY = cnPointY//Запоминаем промежуточную координату
                tmrPage.running = true//Запускаем таймер, запоимним стартовую координату Y страницы
            }
        }
    }
    function fnPageMove(dx, dy) {//Функция движения pdf с ограничением в границах страницы.
        if (isPagePointY){//Если начальная коорд стр по Y расчитана, то...
            //Текущее положение куда уже переместилась мышка
            let newX = flickable.contentX + dx
            let newY = flickable.contentY + dy
            //Горизонтальное ограничение по текущей странице
            let minX = 0//Минимальная координата по Х
            let maxWidth = pointPageWidth * renderScale//Максимальная ширина
            let maxX = Math.max(0, maxWidth - pointRectWidth + 2 * pointScrollBarWidth)//Маx коорд.по Х
            newX = Math.max(minX, Math.min(newX, maxX))//Координата Х с ограничениями по странице.
            //Вертикальное ограничение по текущей странице
            let minY = pagePointY * renderScale//Координата Y начала страницы
            let maxY = (pagePointY + pointPageHeight) * renderScale - pointRectHeight + 2*pointScrollBarWidth
            newY = Math.max(minY, Math.min(newY, maxY))//Координата Y с ограничениями по странице.
            //Выставляем расчитанные координаты с ограничениями в пределах страницы.
            flickable.contentX = newX//Выставляем координату по Х с ограничениями в пределах страницы.
            flickable.contentY = newY//Выставляем координату по Y с ограничениями в пределах страницы.
        }
    }
    function fnSpacingStart(nomerStranici, pointY){//Расчитываем расстояние между страницами при открытии док
        if(!isSpacingStart){//Если данный метод не запускался ни разу, то...
            isSpacingStart = true;//взводим флаг, чтоб больше не запускался данный метод
            console.log("принимаю: Cтраница", nomerStranici, "Координата начала страницы", pointY)
            if (nomerStranici){//Если не 0 (первая страница), то...
                let sumPointHeight = 0
                for (let ltShag = 0; ltShag < nomerStranici; ltShag++){
                    sumPointHeight += pdfDoc.pagePointSize(ltShag).height
                }
                console.log("sumPoint", sumPointHeight)
                const cnSpacing = (pointY - sumPointHeight)/(nomerStranici+1)//Растчёт расстояния
                if ((cnSpacing > spacingMin) && (cnSpacing < spacingMax)){//
                    spacing = cnSpacing//Приравниваем расчётное значение
                    isSpacing = true//Успешный расчёт расстояния между страницами
                }
                else console.log("ОШИБКА РАСЧЁТА fnSpacingStart", cnSpacing)
            }
            console.log("dcSpacingStart", spacing)
        }
    }
    function fnSpacingPagePage(lastPointY, pointY, heightPage){//Функция расчитывает расстояние между двумя ст
        if(isSpacingStart && !isSpacing){//Если запускался fnSpacingStart, и не было расчёта spacing
            console.log("Предыдущая координата Y", lastPointY, "Действующая координата Y", pointY,
                        "Высота страницы", heightPage)
            let ltSpacing = 0//Переменная хранящая расстояние между страницами
            let heightContent = 0//Разность координат.
            if(pointY > lastPointY){//Если увелицивается страница
                heightContent = pointY - lastPointY//Считаем разницу координат
                ltSpacing = heightContent - heightPage//Считаем расстояние между страницами
            }
            else{//Если уменьшается страница
                heightContent = lastPointY - pointY
                ltSpacing =  heightContent - heightPage
            }
            if ((ltSpacing > spacingMin) //Если в пределах минимально заданого растояния
                    && (ltSpacing < spacingMax)//И в пределах максимально заданного расстояния
                    && (heightContent < (heightPage + heightPage * 0.05))){//разница коорд. меньше высоты+5%
                isSpacing = true//Успешный расчёт расстояния между страницами
                spacing = ltSpacing;//Расчёт правильный, приравниваем.
            }
            else console.log("ОШИБКА РАСЧЁТА fnSpacingPagaPage", ltSpacing)
            console.log("dcSpacingPagePage", spacing)
        }
    }
    Connections {
        target: flickable
        function onMovementStarted(){//Если скролл документа колёсиком мыши начался
            console.log("Движение колёсиком мыши началось")
        }
        function onMovementEnded() {//Если скролл документа колёсиком мыши закончился.
            console.log("Движение колёсиком мыши закончилось")
        }
    }
}
