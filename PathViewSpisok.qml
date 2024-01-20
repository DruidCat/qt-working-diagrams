import QtQuick
import QtQuick.Window

import "qrc:/js/DCFunkciiJS.js" as JSSpisok

Item {
	id: tmZonaSpisok
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"

	signal sSpisok(var strSpisok);

	ListView {
		id: lsvZonaSpisok

		Component {
			id: cmpZonaSpisok
			Rectangle {
				id: rctSpisok
				width: lsvZonaSpisok.width
				height: tmZonaSpisok.ntWidth*tmZonaSpisok.ntCoff+tmZonaSpisok.ntCoff
				radius: (width/(tmZonaSpisok.ntWidth*tmZonaSpisok.ntCoff))/tmZonaSpisok.ntCoff
				color: maUchastki.containsPress
					   ? Qt.darker(tmZonaSpisok.clrFona, 1.3) : tmZonaSpisok.clrFona
				Text {
					color: maUchastki.containsPress
						   ? Qt.darker(tmZonaSpisok.clrTexta, 1.3) : tmZonaSpisok.clrTexta
					anchors.horizontalCenter: rctSpisok.horizontalCenter
					anchors.verticalCenter: rctSpisok.verticalCenter
					text: modelData.spisok
					font.pixelSize: (rctSpisok.width/text.length>=rctSpisok.height)
					? rctSpisok.height-tmZonaSpisok.ntCoff
					: rctSpisok.width/text.length-tmZonaSpisok.ntCoff
				}
				MouseArea {
					id: maUchastki
					anchors.fill: rctSpisok
					onClicked: {
						tmZonaSpisok.sSpisok(modelData.spisok)
					}
				}
			}
		}

		anchors.fill: tmZonaSpisok
		anchors.margins: tmZonaSpisok.ntCoff
		spacing: tmZonaSpisok.ntCoff
		model: JSSpisok.ltSpisok
		delegate: cmpZonaSpisok
	}
}
