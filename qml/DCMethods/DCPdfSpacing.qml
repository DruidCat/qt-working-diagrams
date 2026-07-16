import QtQuick //2.15
//DCSpacing - расчёт расстояния между страницами pdf документа
Item {
    id: root
    //Свойства
    property var pmpDoc//PdfMultiPageView (pmpDoc)
    property var pdfDoc//PdfDocument (pdfDoc)
    property var flickable//PdfMultiPageView Flickable
    property real spacing: 3//приблизительное расстояние между страницами pdf документа
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
                let ltSpacing = (pointY - sumPointHeight)/(nomerStranici+1)//Растчёт расстояния
                if (ltSpacing > root.spacing){//Если расчётное расстояние выше, то...
                    root.spacing = ltSpacing//Приравниваем расчётное значение
                    root.isSpacing = true//Успешный расчёт расстояния между страницами
                }
            }
            console.log("dcSpacingStart", root.spacing)
        }
    }
}
