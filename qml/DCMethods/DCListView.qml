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
    property alias model: lsvZona.model//Модель
    property bool isSort: false//true - Включаем режим сортировки. false - выключаем.
    property int ntSortFixed: 0//Сколько верхних элементов «приклеены» (не перетаскиваются)
    property alias lsvZona: lsvZona
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
        model: "[]"
        delegate: cmpZona
        Keys.priority: Keys.BeforeItem//Чтобы дочерний lsvZona обрабатывал клавиши раньше родителя StrSpisok.
        focus: true//Фокус на lvsZona
        activeFocusOnTab: true//Фокус, если Таб нажат.
        flickableDirection: Flickable.VerticalFlick//Включаем явную вертикальную прокрутку
        //Функции
        function fnIsListModel() {//Функция определяющая true - ListModel, false - ListView
            return lsvZona.model
                    && typeof lsvZona.model.get === "function" && typeof lsvZona.model.move === "function"
        }
        function fnUstWidget(i) {//Функция задающая  ListModel или ListView
            return fnIsListModel() ? lsvZona.model.get(i) : lsvZona.model[i]
        }
        function fnMoveItem(from, to) {//Функция меняющая местами элементы списка.
            if (from === to) return//Если равны, то выходим.
            if (from < root.ntSortFixed) return//Если выбранный по счету меньше фиксированых элементов, выход.
            to = Math.max(root.ntSortFixed, Math.min(count - 1, to))

            const cIsListModel = fnIsListModel()
            if (cIsListModel)//Если это ListModel, то...
                lsvZona.model.move(from, to, 1)//Используем move, который есть в моделе ListModel
            else {
                //Модель — JS массив: пересобираем и переназначаем
                var massivModel = lsvZona.model.slice()//Копируем в массив модель. slice()копирование в массив
                var it = massivModel.splice(from, 1)[0]//Удаляем один json {} блок from, и запоминаем его.
                massivModel.splice(to, 0, it)//Вставляем удалённый блок it на позицию to. 0-элементов удалить.
                lsvZona.model = massivModel//Присваеваем модель массива, где был удалён from и в ставлен в to
            }
            lsvZona.currentIndex = to//Задаём currentIndex и подсвечиваем его, как выбранный.
            lsvZona.positionViewAtIndex(to, ListView.Contain)
            let ltOrder = []// Собираем порядок
            if (cIsListModel) {//Если это ListModel, то...
                for (let ltShag = 0; ltShag < lsvZona.model.count; ++ltShag) {
                    const cIndex = lsvZona.model.get(ltShag)
                    ltOrder.push({kod: cIndex.kod, nomer: ltShag+1})
                }
            }
            else {//Если это ListView, то...
                for (var vrShag = 0; vrShag < lsvZona.model.length; ++vrShag) {
                    const cIndex = lsvZona.model[vrShag]
                    ltOrder.push({kod: cIndex.kod, nomer: vrShag+1})
                }
            }
            root.signalSort(ltOrder)//Отправляем сигнал о том, что произошла сортировка.
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
                    const cShag = Math.max(1, Math.floor(height / (root.ntWidth*root.ntCoff + root.ntCoff)))
                    currentIndex = Math.max(0, currentIndex - cShag)
                    positionViewAtIndex(currentIndex, ListView.Beginning)
                }
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_PageDown){//Если нажата кнопка PageDown, то...
                if(root.enabled){//Если активирован виджет, то
                    const cShag = Math.max(1, Math.floor(height / (root.ntWidth*root.ntCoff + root.ntCoff)))
                    currentIndex = Math.min(count - 1, currentIndex + cShag)
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
            root.clicked(parseInt(obj.kod), obj.imya)//Отправляем kod и imya во вне.
            //root.clicked(cModel[cIndex].kod, cModel[cIndex].imya)//Модель JS-массив, берем данные напрямую
        }
        TapHandler {//Нажимаем на всю область виджета.
            onTapped: root.tap();
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
                color: (ListView.isCurrentItem || tphItem.active || drhDrag.active)
                       ? Qt.darker(root.clrFona, 1.3) : root.clrFona
                //Функции
                Text {
                    id: txtText
                    color: (ListView.isCurrentItem || tphItem.active || drhDrag.active)
                           ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
                    anchors.centerIn: rctZona
                    text: modelData.imya//Добавляем данные модели в текст.
                    font.pixelSize: rctZona.height - root.ntCoff
                }
                DragHandler {//Перетаскивание
                    id: drhDrag
                    //Настройки
                    enabled: root.isSort && index >= root.ntSortFixed
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
                                vrListView.fnMoveItem(vrListView.dragFromIndex, dropIndex)//Перемещаем от -> в

                            vrListView.dragFromIndex = -1//Обнуляем на значение по умолчанию.
                            vrListView.interactive = true//Разрешаем Flickable листания lvsZona
                        }
                    }
                }
                TapHandler {//Клик + временная блокировка прокрутки
                    id: tphItem
                    enabled: root.enabled
                    onActiveChanged: {//Если Активность тапа изменилась, то...
                        var vrListView = rctZona.ListView.view//Это lsvZona
                        if (!vrListView) return//Если зона не создана, выходим.Чтоб не залезть в чужую область
                        if (active) {//Если тап активен, то...
                            if (root.isSort && index >= root.ntSortFixed)//Если вкл. режим перемещения и fixed
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
                        root.clicked(modelData.kod, modelData.imya)//Клик возращает код и имя модели.
                    }
                }
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
	}
}
