import QtQuick
import QtQuick.Window

Item{
	id: tmKnopkaKruglaya
	property int ntWidth: 8
	property int ntCoff: 8
	property color clrFona: "grey"
	property color clrTexta: "yellow"
	property alias text: txtKnopkaKruglaya.text

	width:  ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle{
		id: rctKnopkaKruglaya
		anchors.fill: tmKnopkaKruglaya
		color: maKnopkaKruglaya.containsPress ?  Qt.darker(clrFona, 1.3) : clrFona
		radius: width/ 2

		Text{
			id: txtKnopkaKruglaya
			color: maKnopkaKruglaya.containsPress ? Qt.darker(clrTexta, 1.3) : clrTexta
			anchors.centerIn: rctKnopkaKruglaya
			text: tmKnopkaKruglaya.strText
			font.pixelSize: rctKnopkaKruglaya.width/text.length//Расчёт размера шрифта
		}

		MouseArea{
			id: maKnopkaKruglaya
			anchors.fill: rctKnopkaKruglaya
			onClicked: {
				tmKnopkaKruglaya.clicked();
				//console.debug(txtKnopkaKruglaya.text.length)
			}
		}
	}
}
