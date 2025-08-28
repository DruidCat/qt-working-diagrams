import QtQuick //2.15
import "qrc:/js/jsJSON.js" as JSZona

Item {
    id: root
    //Свойства.
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrPapki: "orange"
    property color clrFaila: "yellow"
    property color clrFona: "SlateGray"
    //Сигналы.
    signal clicked(int ntNomer, var strFileData);//Сигнал клика на одном из элементов, передаёт номер и имя.
    signal tap();//Сигнал нажатия не на элементы.
    //Функции.
    function fnFocus() {//Функция для фокусировки ListView
        lsvZona.forceActiveFocus();//Чтоб работали кнопки листания.
    }
    ListView {
        id: lsvZona
        anchors.fill: root
        anchors.margins: root.ntCoff
        spacing: root.ntCoff//Расстояние между строками
        model: JSZona.fnFileDialogJSON()
        delegate: cmpZona

        Keys.priority: Keys.BeforeItem//Чтобы дочерний lsvZona обрабатывал клавиши раньше родителя StrSpisok.
        focus: true//Фокус на lvsZona
        activeFocusOnTab: true//Фокус, если Таб нажат.
        //Функции
        Component.onCompleted: fnFocus()//Когда загрузится Зона, форсируем фокус.
        onModelChanged: {//Если модель перегружается, не уезжать за пределы
            if (currentIndex >= count) currentIndex = count - 1
            if (currentIndex < 0 && count > 0) currentIndex = 0
        }
        Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
            if((event.key === Qt.Key_Up)||(event.key === Qt.Key_K)){//Если нажата кнопка Up или K, то...
                if (currentIndex > 0) currentIndex--
                positionViewAtIndex(currentIndex, ListView.Visible)
                event.accepted = true;//Завершаем обработку эвента.
            }
            if((event.key === Qt.Key_Down)||(event.key === Qt.Key_J)){//Если нажата кнопка Down или J, то...
                if (currentIndex < count - 1) currentIndex++
                positionViewAtIndex(currentIndex, ListView.Visible)
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_PageUp){//Если нажата кнопка PageUp, то...
                const step = Math.max(1, Math.floor(height / (root.ntWidth*root.ntCoff + root.ntCoff)))
                currentIndex = Math.max(0, currentIndex - step)
                positionViewAtIndex(currentIndex, ListView.Beginning)
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_PageDown){//Если нажата кнопка PageDown, то...
                const step = Math.max(1, Math.floor(height / (root.ntWidth*root.ntCoff + root.ntCoff)))
                currentIndex = Math.min(count - 1, currentIndex + step)
                positionViewAtIndex(currentIndex, ListView.End)
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_Home){//Если нажата кнопка Home, то...
                currentIndex = 0;
                positionViewAtBeginning();
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_End){//Если нажата кнопка End, то...
                currentIndex = count - 1;
                positionViewAtEnd();
                event.accepted = true;//Завершаем обработку эвента.
            }
            if((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)||(event.key === Qt.Key_Space)){
                fnActivateCurrent();
                event.accepted = true;//Завершаем обработку эвента.
            }
            //cppqml.strDebug = event.key;
        }
        function fnActivateCurrent(){//Функция активация текущего элемента по Enter/Space (эмулируем клик)
            const cIndex = currentIndex//Индекс действующий
            if (cIndex < 0 || cIndex >= count) return//Если индекс за пределами, то выходим из функции.
            const cModel = lsvZona.model//Действующая модель[массив]
            root.clicked(cModel[cIndex].tip, cModel[cIndex].imya)//МодельJS-массив,берем данные напрямую
        }
        TapHandler {//Нажимаем не на элементы, а на пустую область.
            id: tphTap
            onTapped: {
                fnFocus()//Чтобы после клика мышью стрелки сразу работали
                root.tap()
            }
        }
        Component {//Компонент читающий из Модели, и создающий поочереди каждый элемент каталога с настройками
            id: cmpZona
            Rectangle {
                id: rctZona
                width: lsvZona.width
                height: root.ntWidth*root.ntCoff+root.ntCoff
                radius: (width/(root.ntWidth*root.ntCoff))/root.ntCoff
                opacity: 0.95//Небольшая прозрачность, чтоб был виден Логотип под надписями.
                clip: true//Обрезаем лишний текст в прямоугольнике.
                color: (ListView.isCurrentItem||maZona.containsPress)?Qt.darker(root.clrFona,1.3):root.clrFona
                TextMetrics {
                    id: txmText
                    elide: Text.ElideMiddle//Обрезаем текст с середины, ставя точки... (Dru..Cat)
                    elideWidth: rctZona.width//Максимальная длина обезания текста.
                    text: {//Пишем функцию на JS для цвета текста папки или файла.
                        var strModel = modelData.imya;//Считываем модель с именем папки или файла.
                        cppqml.strFileDialogModel = strModel;//Отправляем в бизнес логику.
                        if(cppqml.strFileDialogModel === "0")//Если 0-папка
                            txtText.color = root.clrPapki;//Задаём цвет текста модели для папки.
                        else//Если 1-файл.
                            txtText.color = root.clrFaila;//Задаём цвет текста модели для файла.
                        return strModel;//вернуть в переменную text значение модели для отображения.
                    }
                }
                Text{
                    id: txtText
                    color: (ListView.isCurrentItem || maZona.containsPress)
                           ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
                    anchors.centerIn: rctZona
                    text: txmText.elidedText//Отображаем текст уже обрезанный по длине с точками по середине.
                }
                MouseArea {//Создаём MA для каждого элемента каталога.
                    id: maZona
                    anchors.fill: rctZona
                    onClicked: {//При клике на Элемент
                        fnFocus()//Фокус, чтоб горячие клавиши работали.
                        lsvZona.currentIndex = index//Индекс Списка через индекс делегата, подсветится делегат
                        root.clicked(modelData.tip, modelData.imya);//Излучаем сигнал с типом и именем
                    }
                }
                onWidthChanged:{//Длина прямоугольника строки изменилась.
                    txmText.elideWidth = rctZona.width//Задаём ограничение текста по границе длины строки.
                }
            }
        }
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrFileDialogPutChanged(){//Слот Если изменился strFileDialogPut (Q_PROPERTY), то...
                lsvZona.model = JSZona.fnFileDialogJSON();//Перегружаем модель ListView с новыми данными
            }
        }
    }
}
