import QtQuick //2.15
import "qrc:/js/DCFunkciiJS.js" as JSFileDialog

Item {
    id: tmZona
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrPapki: "orange"
    property color clrFaila: "yellow"
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
                clip: true//Обрезаем лишний текст в прямоугольнике.
                color: maZona.containsPress
                       ? Qt.darker(tmZona.clrFona, 1.3) : tmZona.clrFona
                TextMetrics {
                    id: txmText
                    elide: Text.ElideMiddle//Обрезаем текст с середины, ставя точки... (Dru..Cat)
                    elideWidth: rctZona.width//Максимальная длина обезания текста.
                    text: {//Пишем функцию на JS для цвета текста папки или файла.
                        var strModel = modelData.filedialog;//Считываем модель с именем папки или файла.
                        cppqml.strFileDialogModel = strModel;//Отправляем в бизнес логику.
                        if(cppqml.strFileDialogModel === "0")//Если 0-папка
                            txtText.color = tmZona.clrPapki;//Задаём цвет текста модели для папки.
                        else//Если 1-файл.
                            txtText.color = tmZona.clrFaila;//Задаём цвет текста модели для файла.
                        return strModel;//вернуть в переменную text значение модели для отображения.
                    }
                }
                Text{
                    id: txtText
                    anchors.horizontalCenter: rctZona.horizontalCenter
                    anchors.verticalCenter: rctZona.verticalCenter
                    text: txmText.elidedText//Отображаем текст уже обрезанный по длине с точками по середине.
                }
                MouseArea {//Создаём MA для каждого элемента каталога.
                    id: maZona
                    anchors.fill: rctZona
                    onClicked: {//При клике на Элемент
                        tmZona.clicked(modelData.tip, modelData.filedialog);//Излучаем сигнал с типом и именем
                    }
                }
				onWidthChanged:{//Длина прямоугольника строки изменилась.
					txmText.elideWidth = rctZona.width//Задаём ограничение текста по границе длины строки.
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
