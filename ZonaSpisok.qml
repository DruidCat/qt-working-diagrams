import QtQuick
import QtQuick.Window

import "qrc:/js/DCFunkciiJS.js" as JSSpisok

Item {
	id: tmZonaSpisok
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
	signal clickedSpisok(int ntNomer, var strSpisok);

	ListView {
		id: lsvZonaSpisok

		Component {
			id: cmpZonaSpisok
			Rectangle {
				id: rctZonaSpisok
				width: lsvZonaSpisok.width
				height: tmZonaSpisok.ntWidth*tmZonaSpisok.ntCoff+tmZonaSpisok.ntCoff
				radius: (width/(tmZonaSpisok.ntWidth*tmZonaSpisok.ntCoff))/tmZonaSpisok.ntCoff
				color: maZonaSpisok.containsPress
					   ? Qt.darker(tmZonaSpisok.clrFona, 1.3) : tmZonaSpisok.clrFona
				Text {
					color: maZonaSpisok.containsPress
						   ? Qt.darker(tmZonaSpisok.clrTexta, 1.3) : tmZonaSpisok.clrTexta
					anchors.horizontalCenter: rctZonaSpisok.horizontalCenter
					anchors.verticalCenter: rctZonaSpisok.verticalCenter
					text: modelData.spisok
					font.pixelSize: (rctZonaSpisok.width/text.length>=rctZonaSpisok.height)
					? rctZonaSpisok.height-tmZonaSpisok.ntCoff
					: rctZonaSpisok.width/text.length-tmZonaSpisok.ntCoff
				}
				MouseArea {
					id: maZonaSpisok
					anchors.fill: rctZonaSpisok
					onClicked: {
						tmZonaSpisok.clickedSpisok(modelData.nomer, modelData.spisok)
					}
				}
			}
		}

		anchors.fill: tmZonaSpisok
		anchors.margins: tmZonaSpisok.ntCoff
		spacing: tmZonaSpisok.ntCoff//Расстояние между строками
		model: JSSpisok.fnSpisokJSON()
		delegate: cmpZonaSpisok
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokDBChanged(){//Слот Если изменился элемент списка в strSpisok (Q_PROPERTY), то.
				lsvZonaSpisok.model = JSSpisok.fnSpisokJSON();//Перегружаем модель ListView с новыми данными.
			}
		}
	}
}
