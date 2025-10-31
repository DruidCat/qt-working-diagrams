import QtQml
import QtQuick
//DCFontAuto.qml - автоматическая подгонка размера текста внутри прямоугольника.
QtObject {
    id: root
    property var	target//передаём объект Text или Label, в котором будем масштабировать текст
    property real	ntCoff:	8
    property bool	blFontAuto: true//true - Автоподгон шрифта под ширину кнопки, false - [...]
    property int	minPixelSize: 1
    property int	width: target.width
    property int	height: target.height
    property string	text: target.text

    function fnFontAuto(){//Функция автоматической подгонки размера текста под прямоугольник
        if (!target) return//Если пустой объект, то выходим
        if (!blFontAuto) {//Если отключено автомасштабирование текста, то...
            target.elide = Text.ElideRight//Текст обрезается [...]
            return//Выходим из функции.
        }
        target.elide = Text.ElideNone//Не редактируем текст силами Qt.

        const cnWidth = target.width
        const cnHeight = target.height
        if (cnWidth <= 0 || cnHeight <= 0) return
        if (cnWidth > (target.implicitWidth + ntCoff)){//Если длина строки больше длины текста
            for (let ltShag = target.font.pixelSize; ltShag < cnHeight - ntCoff; ltShag++){
                if ((target.implicitWidth + ntCoff) < cnWidth){//Если длина txt меньше динны стр
                    target.font.pixelSize = ltShag//Увеличиваем размер шрифта
                    if ((target.implicitWidth + ntCoff) > cnWidth){//Но, если переборщили
                        target.font.pixelSize--//То уменьшаем размер шрифта и...
                        return//Выходим из увеличения шрифта.
                    }
                }
            }
        }
        else{//Если длина строки меньше длины текста, то...
            for (let ltShag2 = target.font.pixelSize; ltShag2 > minPixelSize; ltShag2--){//Цикл уменьшения
                if ((target.implicitWidth + ntCoff) > cnWidth)//Если текст дилиннее строки, то
                    target.font.pixelSize = ltShag2//Уменьшаем размер шрифта.
            }
        }
    }
    Component.onCompleted:	fnFontAuto()//Когда текст отрисовался, то нужно выставить размер шрифта.
    onWidthChanged:			fnFontAuto()//Если длина строки изменилась, то автомасштабируем
    onHeightChanged:		fnFontAuto()//Если высота изменилась, то автомасштабируем
    onTextChanged:			fnFontAuto()//Если текст изменился, то автомасштабируем
    onNtCoffChanged:		fnFontAuto()//Если коэффициент изменился, то нужно выставить размер шрифта
    onBlFontAutoChanged:	fnFontAuto()//Если изменился флаг автомасштабирования, отрисовываем текст.
}
