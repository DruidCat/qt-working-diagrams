import QtQuick //2.15
import DCButtons 1.0//Импортируем кнопки
//DCScale - ШАБЛОН ДЛЯ РАБОТЫ С ЧИСЛАМИ И ИХ УВЕЛИЧЕНИЕМ И УМЕНЬШЕНИЕМ КНОПКАМИ [+] И [-].
Item {
    id: root
    //Свойства.
    property alias textItem: txtScale//Объект Text с числом (раньше назывался scale и перекрывал Item.scale).
    property alias radius: rctScale.radius//Радиус рабочей зоны
    property alias bold: txtScale.font.bold
    property alias italic: txtScale.font.italic
    property color clrFona: "transparent"//Цвет фона.
    property color clrTexta: "orange"//Цвет текста, рамки и кнопок.
    property int ntWidth: 2
    property int ntCoff: 8
    property real value: 0//Значение масштаба
    property real from: 0//Минимальное значение.
    property real to: 32767//Максимальное значение.
    property int stepSize: 1
    property real tapKnopkaMinus: 1
    property real tapCentor: 3.9
    property real tapKnopkaPlus: 1
    readonly property real rlMax: Math.max(from, to)//Верхняя граница. Если from > to, то она равна from.
    //Настройки.
    height: ntWidth*ntCoff
    width: height*(tapKnopkaMinus+tapCentor+tapKnopkaPlus)
    //Сигналы.
    signal valueModified()//Сигнал нажатия [-],[+] с изменением значения. Значение брать из value.
    signal tap()//Сигнал о нажатии на любой элемент виджета.
    //Функции.
    function fnClamp(){//Прижимает value к диапазону [from, rlMax].
        if(isNaN(value)) return//NaN нельзя сравнивать, иначе зациклимся.
        const cnValue = Math.max(from, Math.min(rlMax, value))
        if(cnValue !== value)
            value = cnValue
    }
    function fnStep(ntNapravlenie){//Шаг на stepSize. ntNapravlenie: -1 минус, +1 плюс.
        const cnValue = Math.max(from, Math.min(rlMax, value + ntNapravlenie * stepSize))
        if(cnValue === value) return//Уже на границе, сигнал не нужен.
        value = cnValue
        valueModified()//А текст обновится по привязке.
    }
    function fnClickedMinus(){ fnStep(-1) }//Функция нажатия кнопки минус.
    function fnClickedPlus(){ fnStep(1) }//Функция нажатия кнопки плюс.
    onValueChanged: fnClamp()//Значение пришло из вне или из нутри.
    onFromChanged: fnClamp()//Минимум поменялся (например, после sgnScaleMin).
    onToChanged: fnClamp()
    onStepSizeChanged: {
        if(stepSize < 1){
            stepSize = 1
            console.error("DCScale.qml::stepSize(int): значение меньше 1.")
        }
    }
    TapHandler {//Обработка нажатия на весь виджет.
        onTapped: root.tap()
    }
    Rectangle {
        id: rctScale
        anchors.fill: root
        color: root.clrFona
        DCKnopkaMinus {//Кнопка минус.
            id: knopkaMinus
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctScale.verticalCenter
            anchors.left: rctScale.left
            clrKnopki: root.clrTexta
            border: false
            enabled: root.value > root.from//Активна, пока есть куда уменьшать.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaMinus
            onClicked: {
                root.tap()//Тапнули на кнопку.
                root.fnClickedMinus()
            }
        }
        Rectangle {
            id: rctTextInput
            height: root.ntWidth*root.ntCoff
            anchors.verticalCenter: rctScale.verticalCenter
            anchors.left: knopkaMinus.right; anchors.right: knopkaPlus.left
            color: "transparent"
            border.color: root.clrTexta
            border.width: root.ntCoff/8
            clip: true//Обрезаем текст, который выходит за границы этого прямоугольника.
            Text {//Область текста, только для показа.
                id: txtScale
                anchors.left: rctTextInput.left; anchors.right: txtProcent.left
                anchors.verticalCenter: rctTextInput.verticalCenter
                color: root.clrTexta
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                text: String(Math.round(root.value))//Привязку не ломаем, больше нигде text не присваиваем.
            }
            Text {
                id: txtProcent
                anchors.verticalCenter: rctTextInput.verticalCenter
                anchors.right: rctTextInput.right
                color: root.clrTexta
                font.pixelSize: root.ntWidth*root.ntCoff//размер шрифта текста.
                text: "%"
            }
        }
        DCKnopkaPlus {//Кнопка плюс.
            id: knopkaPlus
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            anchors.verticalCenter: rctScale.verticalCenter
            anchors.right: rctScale.right
            clrKnopki: root.clrTexta
            border: false
            enabled: root.value < root.rlMax//Активна, пока есть куда увеличивать.
            tapHeight: root.ntWidth*root.ntCoff+root.ntCoff; tapWidth: tapHeight*root.tapKnopkaPlus
            onClicked: {
                root.tap()//Тапнули на кнопку.
                root.fnClickedPlus()
            }
        }
    }
}
