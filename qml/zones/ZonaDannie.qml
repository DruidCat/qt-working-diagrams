import QtQuick 2.14
import QtQuick.Window 2.14

import "qrc:/js/DCFunkciiJS.js" as JSDannie

Item {
	id: tmZona
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
    signal clicked(int ntNomer, var strDannie);//Сигнал клика на одном из элементов, передаёт номер и имя.

	ListView {
		id: lsvZona

        Component {//Компонент читающий из Модели, и создающий поочереди каждый Документ с настройками.
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
				Text {
					color: maZona.containsPress
						   ? Qt.darker(tmZona.clrTexta, 1.3) : tmZona.clrTexta
					anchors.horizontalCenter: rctZona.horizontalCenter
					anchors.verticalCenter: rctZona.verticalCenter
					text: modelData.dannie
                    font.pixelSize: rctZona.height-tmZona.ntCoff
				}
                MouseArea {//Создаём MA для каждого Документа.
					id: maZona
					anchors.fill: rctZona
                    onClicked: {//При клике на Документ. 
                        tmZona.clicked(modelData.kod, modelData.dannie);//Излучаем сигнал с номером и именем.
					}
				}
			}
		}
		anchors.fill: tmZona
		anchors.margins: tmZona.ntCoff
		spacing: tmZona.ntCoff//Расстояние между строками
		model: JSDannie.fnDannieJSON()
		delegate: cmpZona
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrDannieDBChanged(){//Слот Если изменился Документ в strDannieDB (Q_PROPERTY), то...
				lsvZona.model = JSDannie.fnDannieJSON();//Перегружаем модель ListView с новыми данными.
			}
		}
		/*
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokChanged(){//Слот Если изменился элемент Списка strSpisok (Q_PROPERTY), то...
				lsvZona.model = JSDannie.fnDannieJSON();//Перегружаем модель ListView с новыми данными.
			}
		}
		*/
	}
}
