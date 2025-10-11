// DCTabButton.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

TabButton {
    id: control

    // Настраиваемые параметры темы/внешнего вида
    property color clrFonNormal:  "#ffffff"
    property color clrFonHover:   "#eeeeee"
    property color clrFonPressed: "#cccccc"
    property color clrFonChecked: "#333333"

    property color clrTxtNormal:  "#333333"
    property color clrTxtPressed: "#ffffff"
    property color clrTxtChecked: "#ffffff"

    property color clrBorder:     "#333333"
    property real  ntCoff:        4            // коэф/толщина окантовки (как у вас в root.ntCoff)

    // Экспорт вовне: доступ к самому Label и его ширине
    property alias contentLabel: lbl
    readonly property real textImplicitWidth: lbl.implicitWidth

    // Автоподгон шрифта под ширину кнопки
    property bool autoFitFont: true
    property int  fontMinPixelSize: 8
    property int  fontMaxPixelSize: Math.max(fontMinPixelSize, height - ntCoff)

    hoverEnabled: true // можно переопределить снаружи

    background: Rectangle {
        radius: 0
        color: !control.enabled ? Qt.darker(control.clrFonNormal, 1.25)
              : control.down     ? control.clrFonPressed
              : control.checked  ? control.clrFonChecked
              : control.hovered  ? control.clrFonHover
              :                    control.clrFonNormal
        border.width: control.checked || control.down ? 0 : control.ntCoff/4
        border.color: control.clrBorder
    }

    contentItem: Label {
        id: lbl
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        // Добавите при желании:
        // elide: Text.ElideRight

        color: !control.enabled ? control.clrTxtPressed
              : control.checked ? control.clrTxtChecked
              : control.down    ? control.clrTxtPressed
              :                   control.clrTxtNormal

        // начальный размер — в разумных пределах
        font.pixelSize: Math.min(control.fontMaxPixelSize, Math.max(control.fontMinPixelSize, font.pixelSize || control.fontMaxPixelSize))
    }

    function adjustFont() {
        if (!autoFitFont) return;

        var max = fontMaxPixelSize;
        var min = fontMinPixelSize;
        var s   = lbl.font.pixelSize > 0 ? lbl.font.pixelSize : max;

        lbl.font.pixelSize = s;

        if (width > lbl.implicitWidth) {
            for (var x = s; x <= max; ++x) {
                lbl.font.pixelSize = x;
                if (lbl.implicitWidth > width) { lbl.font.pixelSize = x - 1; break; }
            }
        } else {
            for (var y = s; y >= min; --y) {
                lbl.font.pixelSize = y;
                if (lbl.implicitWidth <= width) break;
            }
        }
    }

    Component.onCompleted: adjustFont()
    onWidthChanged:        adjustFont()
    onHeightChanged:       adjustFont()
    onTextChanged:         adjustFont()
    onNtCoffChanged:       adjustFont()
}
