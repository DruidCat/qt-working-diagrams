import QtQuick //2.15
import "qrc:/js/jsJSON.js" as JSSpisok

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
    property bool enabled: true
    //Сигналы.
    signal clicked(int ntNomer, var strSpisok)
    signal tap()//Сигнал нажатия не на элементы.
    //Функции.
    function fnFocus() {//Функция для фокусировки ListView
        lsvZona.forceActiveFocus();//Чтоб работали кнопки листания.
    }
    ListView {
        id: lsvZona
        //Настройки
        anchors.fill: root
        anchors.margins: root.ntCoff
        spacing: root.ntCoff//Расстояние между строками
        model: JSSpisok.fnSpisokJSON()
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
                currentIndex = 0; positionViewAtBeginning();
                event.accepted = true;//Завершаем обработку эвента.
            }
            if(event.key === Qt.Key_End){//Если нажата кнопка End, то...
                currentIndex = count - 1; positionViewAtEnd();
                event.accepted = true;//Завершаем обработку эвента.
            }
            if((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)||(event.key === Qt.Key_Space)){
                fnActivateCurrent();
                event.accepted = true;//Завершаем обработку эвента.
            }
            //cppqml.strDebug = event.key;
        }
        function fnActivateCurrent(){//Функция активация текущего элемента по Enter/Space (эмулируем клик)
            const idx = currentIndex
            if (idx < 0 || idx >= count) return
            const m = lsvZona.model
            root.clicked(m[idx].kod, m[idx].spisok)//Модель — JS-массив, берем данные напрямую
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
                width: lsvZona.width
                height: root.ntWidth*root.ntCoff+root.ntCoff
                radius: (width/(root.ntWidth*root.ntCoff))/root.ntCoff
                opacity: 0.95//Небольшая прозрачность, чтоб был виден Логотип под надписями.
                clip: true//Обрезаем лишний текст в прямоугольнике.
                color: (ListView.isCurrentItem || maZona.containsPress)
                       ? Qt.darker(root.clrFona, 1.3) : root.clrFona//Подсветка текущего элемента
                Text {
                    id: txtText
                    color: (ListView.isCurrentItem || maZona.containsPress)
                            ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
                    anchors.centerIn: parent
                    text: modelData.spisok
                    font.pixelSize: rctZona.height-root.ntCoff
                }
                MouseArea {
                    id: maZona
                    anchors.fill: rctZona
                    enabled: root.enabled ? true : false
                    onClicked: {
                        fnFocus()
                        root.clicked(modelData.kod, modelData.spisok)
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
        Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokDBChanged(){//Слот Если изменился элемент списка в strSpisok (Q_PROPERTY), то.
                lsvZona.model = JSSpisok.fnSpisokJSON();//Перегружаем модель ListView с новыми данными.
                if (lsvZona.count > 0 && lsvZona.currentIndex < 0)
                    lsvZona.currentIndex = 0//Зафиксировать выбор на первом элементе
			}
        }
	}
}
