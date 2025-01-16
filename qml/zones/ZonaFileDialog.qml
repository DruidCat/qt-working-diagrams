import QtQuick 2.14
import QtQuick.Window 2.14

import "qrc:/js/DCFunkciiJS.js" as JSFileDialog

Item {
    id: tmZona
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
    property color clrFona: "SlateGray"
    signal clicked(int ntNomer, var strFileData);//Сигнал клика на одном из элементов, передаёт номер и имя.

    ListView {
        id: lsvZona

        Component {//Компонент читающий из Модели, и создающий поочереди каждый элемент каталога с настройками
            id: cmpZona
            Rectangle {
                id: rctZona
                width: lsvZona.width
                height: tmZona.ntWidth*tmZona.ntCoff+tmZona.ntCoff
                radius: (width/(tmZona.ntWidth*tmZona.ntCoff))/tmZona.ntCoff
                opacity: 0.9//Небольшая прозрачность, чтоб был виден Логотип под надписями.
                color: maZona.containsPress
                       ? Qt.darker(tmZona.clrFona, 1.3) : tmZona.clrFona
                Text {
                    color: maZona.containsPress
                           ? Qt.darker(tmZona.clrTexta, 1.3) : tmZona.clrTexta
                    anchors.horizontalCenter: rctZona.horizontalCenter
                    anchors.verticalCenter: rctZona.verticalCenter
                    text: modelData.filedialog
                    font.pixelSize: (rctZona.width/text.length>=rctZona.height)
                    ? rctZona.height-tmZona.ntCoff
                    : rctZona.width/text.length-tmZona.ntCoff
                }
                MouseArea {//Создаём MA для каждого элемента каталога.
                    id: maZona
                    anchors.fill: rctZona
                    onClicked: {//При клике на Элемент
                        tmZona.clicked(modelData.tip, modelData.filedialog);//Излучаем сигнал с типом и именем.
                    }
                }
            }
        }
        anchors.fill: tmZona
        anchors.margins: tmZona.ntCoff
        spacing: tmZona.ntCoff//Расстояние между строками
        model: JSFileDialog.fnFileDialogJSON()
        delegate: cmpZona
        Connections {//Соединяем сигнал из C++ с действием в QML
            target: cppqml;//Цель объект класса С++ DCCppQml
            function onStrFileDialogPutChanged(){//Слот Если изменился strFileDialogPut (Q_PROPERTY), то...
                lsvZona.model = JSFileDialog.fnFileDialogJSON();//Перегружаем модель ListView с новыми данными
            }
        }
    }
}
