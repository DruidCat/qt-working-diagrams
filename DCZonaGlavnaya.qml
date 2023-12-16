import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import "qrc:/js/DCZonaGlavnaya.js" as JSUchastki

Item {
	id: tmZonaGlavnaya
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
	signal sUchastki(int ntNomer);

	ListView {
		id: lsvGlavnayaZona

		Component {
			id: cmpUchastki
			Rectangle {
				id: rctUchastki
				width: lsvGlavnayaZona.width
				height: tmZonaGlavnaya.ntWidth*tmZonaGlavnaya.ntCoff+tmZonaGlavnaya.ntCoff
				radius: (width/(tmZonaGlavnaya.ntWidth*tmZonaGlavnaya.ntCoff))/tmZonaGlavnaya.ntCoff
				color: maUchastki.containsPress
					   ? Qt.darker(tmZonaGlavnaya.clrFona, 1.3) : tmZonaGlavnaya.clrFona
				Text {
					color: maUchastki.containsPress
						   ? Qt.darker(tmZonaGlavnaya.clrTexta, 1.3) : tmZonaGlavnaya.clrTexta
					anchors.horizontalCenter: rctUchastki.horizontalCenter
					anchors.verticalCenter: rctUchastki.verticalCenter
					text: modelData.uchastok
					font.pixelSize: (rctUchastki.width/text.length>=rctUchastki.height)
									? rctUchastki.height-tmZonaGlavnaya.ntCoff : rctUchastki.width/text.length-tmZonaGlavnaya.ntCoff
				}
				MouseArea {
					id: maUchastki
					anchors.fill: rctUchastki
					onClicked: {
						tmZonaGlavnaya.sUchastki(modelData.nomer)
					}
				}
			}
		}

		anchors.fill: tmZonaGlavnaya
		anchors.margins: tmZonaGlavnaya.ntCoff
		spacing: tmZonaGlavnaya.ntCoff
		model: JSUchastki.vrUchastki
		delegate: cmpUchastki
	}
}
