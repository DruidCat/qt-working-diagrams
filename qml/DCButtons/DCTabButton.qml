//DCTabButton.qml
import QtQuick
import QtQuick.Controls

TabButton {
    id: root
    //Свойства
    property color clrTexta:	"Orange"
    property color clrFona:		"Black"
    property color clrHover:	"SlateGray"
    property real  ntCoff:		8//Для автоподгонки шрифта во вкладке
    property real radius:		0//0 - без радиуса
    property bool blAutoFont:	true//true - Автоподгон шрифта под ширину кнопки, false - [...]
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
        border.width: root.checked || root.down ? 0 : root.ntCoff/4
        border.color: root.clrBorder
    }
    contentItem: Label{
        id: lblText
        text: root.text//У TabButton есть свойство text, нет смысла его переназначать.
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: root.height - root.ntCoff//Размер шрифта - это высота вкладки, минус ntCoff
        color: !root.enabled	? root.clrTxtPressed
            : root.checked		? root.clrTxtChecked
            : root.down			? root.clrTxtPressed
            : 					root.clrTxtNormal
    }
    function fnAutoFont(){//Функция авто подгонки размера текста во вкладке
        if (!blAutoFont){//Если авто подгон размера шрифта отключен, то...
            lblText.elide = Text.ElideRight//автоматически сокращает текст, добавляя многоточие (...) в конце
            return;//Выходим из функции.
        }
        if(width > (lblText.implicitWidth+root.ntCoff)){//Если длина строки больше длины текста
            for(var ltShag=lblText.font.pixelSize; ltShag<height-root.ntCoff; ltShag++){
                if((lblText.implicitWidth+root.ntCoff) < width){//Если длина txt меньше динны стр
                    lblText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
                    if((lblText.implicitWidth+root.ntCoff) > width){//Но, если переборщили
                        lblText.font.pixelSize--;//То уменьшаем размер шрифта и...
                        return;//Выходим из увеличения шрифта.
                    }
                }
            }
        }
        else{//Если длина строки меньше длины текста, то...
            for(let ltShag = lblText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения
                if((lblText.implicitWidth+root.ntCoff) > width)//Если текст дилиннее строки, то
                    lblText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
            }
        }
    }
    Component.onCompleted:	fnAutoFont()//Когда текст отрисовался, то нужно выставить размер шрифта.
    onWidthChanged:			fnAutoFont()//Если длина строки изменилась, то нужно выставить размер шрифта.
    onHeightChanged:		fnAutoFont()//Если высота изменилась, значить изменился размер шрифта в настройках
    onTextChanged:			fnAutoFont()//Если текст изменился, то нужно выставить размер шрифта.
    onNtCoffChanged:		fnAutoFont()//Если коэффициент изменился, то нужно выставить размер шрифта.
}
