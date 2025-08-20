import QtQuick //2.15
import "qrc:/js/jsJSON.js" as JSZona
//DCListView -
Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
    property bool enabled: true
    property string zona: ""
    property bool blSort: false//true - Включаем режим сортировки. false - выключаем.
    property int ntSortFixed: 0//Сколько верхних элементов «приклеены» (не перетаскиваются)
    //Сигналы.
    signal clicked(int ntNomer, var strSpisok)
    signal tap()//Сигнал нажатия не на элементы.
    signal signalSort(var vrSort)//Сигнал с новым порядком сортировки[{kod, nomer}, ...]
    //Функции.
    function fnFocus() {//Функция для фокусировки ListView
        lsvZona.forceActiveFocus();//Чтоб работали кнопки листания.
    }
    ListView {
        id: lsvZona
        //Свойства
        property int dragFromIndex: -1
        //Настройки
        anchors.fill: root
        anchors.margins: root.ntCoff
        spacing: root.ntCoff//Расстояние между строками
        model: {
            if(root.zona === "spisok"){
                JSZona.fnSpisokJSON()
            }
            else{
                if(root.zona === "element"){
                    JSZona.fnElementJSON()
                }
                else{
                    if(root.zona === "dannie")
                        JSZona.fnDannieJSON()
                }
            }
        }
        delegate: cmpZona
        Keys.priority: Keys.BeforeItem//Чтобы дочерний lsvZona обрабатывал клавиши раньше родителя StrSpisok.
        focus: true//Фокус на lvsZona
        activeFocusOnTab: true//Фокус, если Таб нажат.
        flickableDirection: Flickable.VerticalFlick//Включаем явную вертикальную прокрутку
        //Функции
        function modelIsListModel() {
            return lsvZona.model && typeof lsvZona.model.get === "function" && typeof lsvZona.model.move === "function"
        }
        function getItemAt(i) {
            return modelIsListModel() ? lsvZona.model.get(i) : lsvZona.model[i]
        }
        function moveItem(from, to) {
            if (from === to) return
            if (from < root.ntSortFixed) return
            to = Math.max(root.ntSortFixed, Math.min(count - 1, to))

            const isLM = modelIsListModel()
            if (isLM) {
                lsvZona.model.move(from, to, 1)
            } else {
                // Модель — JS массив: пересобираем и переназначаем
                var arr = lsvZona.model.slice()
                var it = arr.splice(from, 1)[0]
                arr.splice(to, 0, it)
                lsvZona.model = arr
            }

            // Перенумеровываем "nomer" по новому порядку (1..N)
            if (isLM) {
                for (var i = 0; i < lsvZona.model.count; ++i)
                    lsvZona.model.setProperty(i, "nomer", String(i + 1))
            } else {
                for (var j = 0; j < lsvZona.model.length; ++j)
                    lsvZona.model[j].nomer = String(j + 1)
            }

            lsvZona.currentIndex = to
            lsvZona.positionViewAtIndex(to, ListView.Contain)

            // Собираем порядок и оповещаем наружу
            var order = []
            if (isLM) {
                for (var k = 0; k < lsvZona.model.count; ++k) {
                    var o = lsvZona.model.get(k)
                    order.push({ kod: o.kod, nomer: o.nomer })
                }
            } else {
                for (var q = 0; q < lsvZona.model.length; ++q) {
                    var oo = lsvZona.model[q]
                    order.push({ kod: oo.kod, nomer: oo.nomer })
                }
            }
            root.signalSort(order)//Отправляем сигнал о том, что споизошла сортировка.
        }
        Component.onCompleted: fnFocus()//Когда загрузится Зона, форсируем фокус.
        onModelChanged: {//Если модель перегружается, не уезжать за пределы
            if (currentIndex >= count) currentIndex = count - 1
            if (currentIndex < 0 && count > 0) currentIndex = 0
        }
        Keys.onPressed: (event) => {//Это запись для Qt6, для Qt5 нужно удалить event =>
            if((event.key === Qt.Key_Up)||(event.key === Qt.Key_K)){//Если нажата кнопка Up или K, то...
                if(root.enabled){//Если активирован виджет, то
                    if (currentIndex > 0) currentIndex--
                    positionViewAtIndex(currentIndex, ListView.Visible)
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if((event.key === Qt.Key_Down)||(event.key === Qt.Key_J)){//Если нажата кнопка Down или J, то...
                if(root.enabled){//Если активирован виджет, то
                    if (currentIndex < count - 1) currentIndex++
                    positionViewAtIndex(currentIndex, ListView.Visible)
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_PageUp){//Если нажата кнопка PageUp, то...
                if(root.enabled){//Если активирован виджет, то
                    const step = Math.max(1, Math.floor(height / (root.ntWidth*root.ntCoff + root.ntCoff)))
                    currentIndex = Math.max(0, currentIndex - step)
                    positionViewAtIndex(currentIndex, ListView.Beginning)
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_PageDown){//Если нажата кнопка PageDown, то...
                if(root.enabled){//Если активирован виджет, то
                    const step = Math.max(1, Math.floor(height / (root.ntWidth*root.ntCoff + root.ntCoff)))
                    currentIndex = Math.min(count - 1, currentIndex + step)
                    positionViewAtIndex(currentIndex, ListView.End)
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_Home){//Если нажата кнопка Home, то...
                if(root.enabled){//Если активирован виджет, то
                    currentIndex = 0;
                    positionViewAtBeginning();
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_End){//Если нажата кнопка End, то...
                if(root.enabled){//Если активирован виджет, то
                    currentIndex = count - 1;
                    positionViewAtEnd();
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)||(event.key === Qt.Key_Space)){
                if(root.enabled)//Если активирован виджет, то
                    fnActivateCurrent();//Активируем горячую кнопку.
                event.accepted = true;//Завершаем обработку эвента.
            }
            //cppqml.strDebug = event.key;
        }
        function fnActivateCurrent(){//Функция активация текущего элемента по Enter/Space (эмулируем клик)
            var vrIndex = currentIndex//Индекс действующий
            if (vrIndex < 0 || vrIndex >= count) return//Если индекс за пределами, то выходим из функции.
            var vrModel = lsvZona.model//Действующая модель
            //Чтобы работало и с ListModel, и с массивом, то...
            var obj = (vrModel && typeof vrModel.get === "function") ? vrModel.get(vrIndex) : vrModel[vrIndex]
            root.clicked(parseInt(obj.kod), obj.dannie)//Отправляем kod и nomer во вне.
            //root.clicked(cModel[cIndex].kod, cModel[cIndex].dannie)//Модель JS-массив, берем данные напрямую
        }
        TapHandler {//Нажимаем не на элементы, а на пустую область.
            id: tphTap
            onTapped: {
                fnFocus()//Чтобы после клика мышью стрелки сразу работали
                root.tap()
            }
        }
        Component {
            id: cmpZona

            Rectangle {
                id: rctZona
                //Настройки
                width: ListView.view ? ListView.view.width : 0//Длина делегата берётся из ListView
                height: root.ntWidth*root.ntCoff + root.ntCoff//Высоту делегата считаем.
                opacity: 0.95//Прозрачность.
                clip: true
                color: (ListView.isCurrentItem || tap.active || drhDrag.active)
                       ? Qt.darker(root.clrFona, 1.3) : root.clrFona
                //Функции
                Text {
                    id: txtText
                    color: (ListView.isCurrentItem || tap.active || drhDrag.active)
                           ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
                    anchors.centerIn: rctZona
                    text: modelData.dannie//Добавляем данные модели в текст.
                    font.pixelSize: rctZona.height - root.ntCoff
                }
                DragHandler {//Перетаскивание
                    id: drhDrag
                    //Настройки
                    enabled: root.blSort && index >= root.ntSortFixed
                    target: null
                    xAxis.enabled: false//По горизонтали X не перетасвиваем.
                    yAxis.enabled: true//По вкртикали Y перетасвиваем.
                    onActiveChanged: {//Если Активность перетаскивания изменилась, то...
                        var vrListView = rctZona.ListView.view//Это lvsZona.
                        if (!vrListView) return//Если зона не создана, выходим.Чтоб не залезть в чужую область
                        if (active) {//Если true - то начало перетаскивания.
                            rctZona.scale = 1.1//Масштаб увеличиваем перетаскиваемого элемента
                            rctZona.opacity = 1//Убираем прозрачность перетаскиваемого элемента
                            rctZona.z = 1//Перетасвиваемый по верх того, кого поменяем.
                            vrListView.dragFromIndex = index//Задаём перетаскиваемый элемент через Индекс.
                            vrListView.interactive = false//Отключаем flickable листания lvsZona
                            vrListView.currentIndex = index//Подсвечиваем выбранный делегат, что он выбран.
                        }
                        else {
                            rctZona.scale = 1.0//Масштаб возращаем в исходное перетащеного элемента
                            rctZona.opacity = 0.95//Возращаем прозрачность перетащеного элемента
                            rctZona.z = 0//Возвращаем позицию висходное состояние.
                            //Координаты точки отпускания в системе contentItem
                            var p = rctZona.mapToItem(vrListView.contentItem,
                                                      drhDrag.centroid.position.x,
                                                      drhDrag.centroid.position.y)
                            var midX = vrListView.contentItem.width * 0.5//Координата середины Х.
                            var dropIndex = vrListView.indexAt(midX, p.y)//Получаем индекс под курсором/пальце
                            if (dropIndex < 0) {// Фолбэк, если indexAt попал в зазор (spacing)
                                var h = rctZona.height + vrListView.spacing
                                dropIndex = Math.round(p.y / Math.max(1, h))
                            }
                            dropIndex = Math.max(root.ntSortFixed, Math.min(vrListView.count - 1, dropIndex))
                            if (vrListView.dragFromIndex !== -1)//Если выбран элемент для перемещения, то...
                                vrListView.moveItem(vrListView.dragFromIndex, dropIndex)//Перемещаем от -> в

                            vrListView.dragFromIndex = -1//Обнуляем на значение по умолчанию.
                            vrListView.interactive = true//Разрешаем Flickable листания lvsZona
                        }
                    }
                }
                TapHandler {//Клик + временная блокировка прокрутки
                    id: tap
                    enabled: root.enabled
                    onActiveChanged: {//Если Активность тапа изменилась, то...
                        var vrListView = rctZona.ListView.view//Это lsvZona
                        if (!vrListView) return//Если зона не создана, выходим.Чтоб не залезть в чужую область
                        if (active) {//Если тап активен, то...
                            if (root.blSort && index >= root.ntSortFixed)//Если вкл. режим перемещения и fixed
                                vrListView.interactive = false//Отключаем flickable листания lsvZona
                        }
                        else {//Если Тап не активен, то...
                            if (!drhDrag.active)//Если не происходит перемещения элемента, то...
                                vrListView.interactive = true//Включем flickable листания lvsZona
                        }
                    }
                    onTapped: {
                        var vrListView = rctZona.ListView.view//Это lsvZona
                        if (!vrListView) return//Если зона не создана, выходим.Чтоб не залезть в чужую область
                        vrListView.interactive = true//Включем flickable листания lvsZona
                        fnFocus()//Фокус, чтоб горячие клавиши работали.
                        vrListView.currentIndex = index//Подсвечиваем выбранный делегат, что он выбран.
                        root.clicked(modelData.kod, modelData.dannie)//Клик возращает код и данные модели.
                    }
                }
                /*
                MouseArea {
                    id: maZona
                    anchors.fill: rctZona
                    //enabled: root.enabled ? true : false
                    preventStealing: true
                    onClicked: {
                        fnFocus()//Фокус, чтоб горячие клавиши работали.
                        lsvZona.currentIndex = index//Индекс Списка через индекс делегата, подсветится делегат
                        root.clicked(modelData.kod, modelData.dannie)//Клик возращает код и данные модели.
                    }
                }
                */
                Component.onCompleted:{//Когда текст отрисовался, нужно выставить размер шрифта.
                    if(rctZona.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(var ltShag=txtText.font.pixelSize; ltShag<rctZona.height-root.ntCoff; ltShag++){
                            if(txtText.width < rctZona.width){//Если длина текста меньше динны строки
                                txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(txtText.width > rctZona.width){//Но, если переборщили
                                    txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(txtText.width > rctZona.width)//Если текст дилиннее строки, то...
                                txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
                onWidthChanged: {//Если длина строки изменилась, то...
                    if(rctZona.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(var ltShag=txtText.font.pixelSize; ltShag<rctZona.height-root.ntCoff; ltShag++){
                            if(txtText.width < rctZona.width){//Если длина текста меньше динны строки
                                txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                if(txtText.width > rctZona.width){//Но, если переборщили
                                    txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
                                    return;//Выходим из увеличения шрифта.
                                }
                            }
                        }
                    }
                    else{//Если длина строки меньше длины текста, то...
                        for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                            if(txtText.width > rctZona.width)//Если текст дилиннее строки, то...
                                txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                        }
                    }
                }
                onHeightChanged: {//Если изменилась высота, значит изменился размер Шрифта в StrMenu.
                    Qt.callLater(function () {//Делаем паузу на такт,иначе не успеет пересчитаться высота!
                        txtText.font.pixelSize = rctZona.height-root.ntCoff
                        if(rctZona.width > txtText.width){//Если длина строки больше длины текста, то...
                            for(var ltShag=txtText.font.pixelSize;ltShag<rctZona.height-root.ntCoff;ltShag++){
                                if(txtText.width < rctZona.width){//Если длина текста меньше динны строки
                                    txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                                    if(txtText.width > rctZona.width){//Но, если переборщили
                                        txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
                                        return;//Выходим из увеличения шрифта.
                                    }
                                }
                            }
                        }
                        else{//Если длина строки меньше длины текста, то...
                            for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                                if(txtText.width > rctZona.width)//Если текст дилиннее строки, то...
                                    txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
                            }
                        }
                    })
                }
            }
        }
        Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokDBChanged(){//Слот Если изменился элемент списка в strSpisok (Q_PROPERTY), то.
                if(root.zona === "spisok"){//Если Список, то...
                    lsvZona.model = JSZona.fnSpisokJSON();//Перегружаем модель ListView с новыми данными.
                    if (lsvZona.count > 0 && lsvZona.currentIndex < 0)//Модель не пустая и Индекс не верный,то
                        lsvZona.currentIndex = 0//Зафиксировать выбор на первом элементе
                }
            }
            function onStrSpisokChanged(){//Слот Если изменился элемент Списка strSpisok (Q_PROPERTY), то...
                if(root.zona === "element")//Если Элемент, то...
                    lsvZona.model = JSZona.fnElementJSON();//Перегружаем модель ListView с новыми данными.
            }
            function onStrElementDBChanged(){//Слот Если изменился Элемент в strElementDB (Q_PROPERTY), то...
                if(root.zona === "element")//Если Элемент, то...
                    lsvZona.model = JSZona.fnElementJSON();//Перегружаем модель ListView с новыми данными.
            }
            function onStrElementChanged(){//Слот Если изменился Элемент strElement (Q_PROPERTY), то...
                if(root.zona === "dannie")//Если Данные, то...
                    lsvZona.model = JSZona.fnDannieJSON();//Перегружаем модель ListView с новыми данными.
            }
            function onStrDannieDBChanged(){//Слот Если изменился Документ в strDannieDB (Q_PROPERTY), то...
                if(root.zona === "dannie")//Если Данные, то...
                    lsvZona.model = JSZona.fnDannieJSON();//Перегружаем модель ListView с новыми данными.
            }
        }
	}
}
