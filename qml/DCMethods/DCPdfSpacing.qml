import QtQuick //2.15
//DCSpacing - расчёт расстояния между страницами pdf документа
Item {
    id: root
    //Свойства
    property real spacing: 3//приблизительное расстояние между страницами pdf документа
    property real spacingMin: 2.2//приблизительное минимальное расстояние между страницами pdf документа
    property real spacingMax: 7//приблизительное максимальное расстояние между страницами pdf документа
    property bool isSpacing: false//true - расстояние между страницами посчитано.
    property bool isSpacingStart: false//true - fnSpacingStart() уже запускалась.
    //Настройки

    //Сигналы.
    //Функции.
    function fnSpacingStart(nomerStranici, pointY){//Расчитываем расстояние между страницами при открытии док
        if(!root.isSpacingStart){//Если данный метод не запускался ни разу, то...
            root.isSpacingStart = true;//взводим флаг, чтоб больше не запускался данный метод
            console.log("принимаю: Cтраница", nomerStranici, "Координата начала страницы", pointY)
            if (nomerStranici){//Если не 0 (первая страница), то...
                let sumPointHeight = 0
                for (let ltShag = 0; ltShag < nomerStranici; ltShag++){
                    sumPointHeight += pdfDoc.pagePointSize(ltShag).height
                }
                console.log("sumPoint", sumPointHeight)
                const cnSpacing = (pointY - sumPointHeight)/(nomerStranici+1)//Растчёт расстояния
                if ((cnSpacing > root.spacingMin) && (cnSpacing < root.spacingMax)){//
                    root.spacing = cnSpacing//Приравниваем расчётное значение
                    root.isSpacing = true//Успешный расчёт расстояния между страницами
                }
                else console.log("ОШИБКА РАСЧЁТА fnSpacingStart", cnSpacing)
            }
            console.log("dcSpacingStart", root.spacing)
        }
    }
    function fnSpacingPagePage(lastPointY, pointY, heightPage){//Функция расчитывает расстояние между двумя ст
        if(root.isSpacingStart){//Если не было запуска fnSpacingStart, то данная функция не запускается!!!
            console.log("Предыдущая координата Y", lastPointY, "Действующая координата Y", pointY,
                        "Высота страницы", heightPage)
            let ltSpacing//Переменная хранящая расстояние между страницами
            if(pointY > lastPointY)//Если увелицивается страница
                ltSpacing = pointY - lastPointY - heightPage
            else//Если уменьшается страница
                ltSpacing = lastPointY - pointY - heightPage
            if ((ltSpacing > root.spacingMin) && (ltSpacing < root.spacingMax)){//Если в пределах мин и макс
                root.isSpacing = true//Успешный расчёт расстояния между страницами
                root.spacing = ltSpacing;//Расчёт правильный, приравниваем.
            }
            else console.log("ОШИБКА РАСЧЁТА fnSpacingPagaPage", ltSpacing)
            console.log("dcSpacingPagePage", root.spacing)
        }
    }
}
