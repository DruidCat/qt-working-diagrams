import QtQuick
import QtQuick.Window

import "qrc:/js/DCFunkciiJS.js" as JSSpisok

Item {
	id: tmZona
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
	signal clicked(int ntNomer, var strSpisok);

	ListView {
		id: lsvZona

		Component {
			id: cmpZona
			Rectangle {
				id: rctZona
				width: lsvZona.width
				height: tmZona.ntWidth*tmZona.ntCoff+tmZona.ntCoff
				radius: (width/(tmZona.ntWidth*tmZona.ntCoff))/tmZona.ntCoff
				color: maZona.containsPress
					   ? Qt.darker(tmZona.clrFona, 1.3) : tmZona.clrFona
				Text {
					color: maZona.containsPress
						   ? Qt.darker(tmZona.clrTexta, 1.3) : tmZona.clrTexta
					anchors.horizontalCenter: rctZona.horizontalCenter
					anchors.verticalCenter: rctZona.verticalCenter
					text: modelData.spisok
					font.pixelSize: (rctZona.width/text.length>=rctZona.height)
					? rctZona.height-tmZona.ntCoff
					: rctZona.width/text.length-tmZona.ntCoff
				}
				MouseArea {
					id: maZona
					anchors.fill: rctZona
					onClicked: {
						tmZona.clicked(modelData.kod, modelData.spisok)
					}
				}
			}
		}

		anchors.fill: tmZona
		anchors.margins: tmZona.ntCoff
		spacing: tmZona.ntCoff//Расстояние между строками
		model: JSSpisok.fnSpisokJSON()
		delegate: cmpZona
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokDBChanged(){//Слот Если изменился элемент списка в strSpisok (Q_PROPERTY), то.
				lsvZona.model = JSSpisok.fnSpisokJSON();//Перегружаем модель ListView с новыми данными.
			}
		}
	}
}
