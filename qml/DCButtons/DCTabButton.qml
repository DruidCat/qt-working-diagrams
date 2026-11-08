//DCTabButton.qml
import QtQuick
import QtQuick.Controls
import DCMethods 1.0//Импортируем методы написанные мной.

TabButton {
    id: root
    //Свойства
    property color clrTexta:	"Orange"
    property color clrFona:		"Black"
    property color clrHover:	"SlateGray"
    property int ntCoff:		8//Для автоподгонки шрифта во вкладке
	property int ntWidth: 		2//Размер шрифта
    property real radius:		0//0 - без радиуса
    property bool borderFocus:	false//true - если фокус на вкладке, то она другого цвета
    //Настраиваемые параметры внешнего вида TabButton
    readonly property color clrFonNormal:	clrFona//Цвет фона фкладки, когда она не активна.
    readonly property color clrFonHover:	clrHover//Цвет фона вкладки при наведении мышки на неё.
    readonly property color clrFonPressed:	Qt.darker(clrTexta, 1.3)//Цвет фона вкладки,когда нажали на его
    readonly property color clrFonChecked:	clrTexta//Цвет фона выбранной вкладки пользователем.
    readonly property color clrTxtNormal:	clrTexta//Цвет текста вкладки, когда она не активна.
    readonly property color clrTxtPressed:	clrFona//Цвет текста вкладки при нажатии на неё
    readonly property color clrTxtChecked:	clrFona//Цвет текста вкладки выбранной пользователем постоянно.
    readonly property color clrBorder:		clrTexta//Цвет оконтовки вкладки.
    //Настройки
    hoverEnabled: false//Выкл отслеживание наведения мыши на кнопку в ПК.
    //Методы
    background: Rectangle {//Фон вкладки Прямоугольник.
        radius: root.radius//радиус
        color: !root.enabled	? Qt.darker(root.clrFonNormal, 1.25)
            : root.down			? root.clrFonPressed
            : root.checked		? root.clrFonChecked
            : root.hovered		? root.clrFonHover
            :					root.clrFonNormal
        border.width: root.ntCoff/4//Толщина бордюра.
        border.color: root.borderFocus ? root.clrFonPressed : root.clrBorder//При изменении фокуса меняется.
    }
    contentItem: Label{
        id: lblText
        text: root.text//У TabButton есть свойство text, нет смысла его переназначать.
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: fnFont()
        elide: Text.ElideRight//автоматически сокращает текст, добавляя многоточие (...) в конце
        color: !root.enabled	? root.clrTxtPressed
            : root.checked		? root.clrTxtChecked
            : root.down			? root.clrTxtPressed
            : 					root.clrTxtNormal
    }
    function fnFont(){//Функция  размера текста во вкладке
		return root.ntWidth * root.ntCoff - 2//ВНИМАНИЕ! РАЗМЕР ШРИФТА ЗАВИСИТ ОТ ВЫСОТЫ РОДИТЕЛЯ TARBAR
    }
    Component.onCompleted:	fnFont()//Когда текст отрисовался, то нужно выставить размер шрифта.
    onWidthChanged:			fnFont()//Если длина строки изменилась, то нужно выставить размер шрифта.
    onHeightChanged:		fnFont()//Если высота изменилась, значить изменился размер шрифта в настройках
    onTextChanged:			fnFont()//Если текст изменился, то нужно выставить размер шрифта.
    onNtCoffChanged:		fnFont()//Если коэффициент изменился, то нужно выставить размер шрифта.
}
