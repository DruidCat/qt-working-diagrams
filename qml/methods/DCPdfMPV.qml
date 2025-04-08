import QtQuick //2.15
import QtQuick.Pdf //5.15

Component {
    id: root
    property PdfDocument pdfDocument: null
    signal signalCurrentPage(var page);
    Item {
        anchors.fill: parent
        PdfMultiPageView{//Мульти страница добавленая в Компонет для Загрузчика
            id:pmpDoc
            anchors.fill: parent
            document: root.pdfDocument//Добавляем pdf документ.
            visible: false//По умолчанию не видимый.
            searchString: ""
            onCurrentPageChanged: {//Если страница документа изменилась, то...
                root.signalCurrentPage(currentPage + 1);
                //spbPdfPage.value = ldrDoc.item.currentPage + 1//В DCSpinBox выставляем значение страницы.
            }
            onCurrentPageRenderingStatusChanged:{//Если рендер страницы изменился, то...
                console.error("124:fnPdfPageStatus.vvv")
                if(currentPageRenderingStatus === Image.Loading){//Статус рендеринга страницы ЗАГРУЗКА.
                    //blPageStatusLoad = false;//Сбрасываем флаг, тем самым документ начал грузиться.
                    console.error("127:Статус рендера страницы: "+ currentPage +" Загрузка.");
                }
                if(currentPageRenderingStatus === Image.Ready){//Статус рендеринга страницы ОТКРЫТ.
                    //blPageStatusReady = false;//Сбрасываем флаг, тем самым документ загрузился.
                    console.error("131:Статус рендера страницы: "+ currentPage +" Открыт.");
                    /*
                    if(root.blOpen){//Если это рендер страницы после открытия документа, то.
                        console.error("133:RenderPage Ready. blScale: " + root.blScale);
                        if(!root.blScale){//Если стартового масштабирование не было, то...
                            root.blScale = true;//Активируем флаг, что началось первичное масштабирование.
                            console.error("136:Timer tmrScale start");
                            tmrScale.running = true;//запускаем таймер, перед переходом на страницу
                        }
                        else{//Если первичное масштабирование произошло, то...
                            root.blOpen = false;//сбрасываем флаг открытия документа.
                            root.blScale = false;//Сбрасываем флаг масштабирование первичного.
                            console.error("142:Timer tmrGoToPage start");
                            tmrGoToPage.running = true;//запускаем таймер, перед переходом на страницу
                        }
                    }
                    */
                }
            }
        }
    }
}
