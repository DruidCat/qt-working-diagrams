import QtQuick
import QtQuick.Window

import "qrc:/js/DCFunkciiJS.js" as JSSpisok

Item {
	id: tmPVSpisok
	property int ntWidth: 2
	property int ntCoff: 8
	property alias pathItemCount: pvwSpisok.pathItemCount
	property color clrTexta: "orange"
	property color clrFona: "slategray"

	height: pathItemCount*ntWidth*ntCoff*2

	signal sSpisok(var strSpisok);

	Rectangle {
		anchors.fill: tmPVSpisok
		color: "transparent"
		border.color: "red"
		border.width: 3
	}
	Path {//Размеры PathView, и направление бесконечного скролинга.
		id: pthSpisok
		startX: tmPVSpisok.width/2//Середина строчки списка - это середина Item
		startY: ntWidth*ntCoff+ntCoff/2//Начальная Y координата середины строчки по вертикали.
		PathLine {//координаты середины крайней строчки
			id: plnSpisok
			x: tmPVSpisok.width/2
			y: tmPVSpisok.height
		}
	}
	PathView {//Представление модели с бесконечным скролингом.
		id: pvwSpisok
		Component {
			id: cmpPVSpisok

			Rectangle {//Прямоугольник каждой отдельной строчки в модели.
				id: rctPVSpisok
				width: tmPVSpisok.width
				height: tmPVSpisok.ntWidth*tmPVSpisok.ntCoff+tmPVSpisok.ntCoff

				color: maPVSpisok.containsPress
					? Qt.darker(tmPVSpisok.clrFona, 1.3) : tmPVSpisok.clrFona
				radius: (width/(tmPVSpisok.ntWidth*tmPVSpisok.ntCoff))/tmPVSpisok.ntCoff
				opacity: PathView.isCurrentItem ? 1 : 0.5//Прозрачность

				Text {//Текст внутри прямоугольника, считанный из модели.
					anchors.horizontalCenter: rctPVSpisok.horizontalCenter
					anchors.verticalCenter: rctPVSpisok.verticalCenter

					color: maPVSpisok.containsPress
						? Qt.darker(tmPVSpisok.clrTexta, 1.3) : tmPVSpisok.clrTexta
					text: modelData.spisok//Читаем текст из модели.
					font.pixelSize: (rctPVSpisok.width/text.length>=rctPVSpisok.height)
						? rctPVSpisok.height-tmPVSpisok.ntCoff
						: rctPVSpisok.width/text.length-tmPVSpisok.ntCoff
				}
				MouseArea {
					id: maPVSpisok
					anchors.fill: rctPVSpisok
					onClicked: {
						tmPVSpisok.sSpisok(modelData.spisok)
					}
				}
			}
		}
		anchors.fill: tmPVSpisok
		model: JSSpisok.ltSpisok
		delegate: cmpPVSpisok
		path: pthSpisok//Устанавливаем габариты и направление скролинга в представлении
		pathItemCount: 3//Количество отображаемых элементов в представлении.
	}
	Component.onCompleted: {//Слот, кода всё представление отрисовалось.
		//console.debug(pvwSpisok.pathItemCount);
	}
}
