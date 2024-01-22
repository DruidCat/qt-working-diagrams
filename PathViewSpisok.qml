import QtQuick
import QtQuick.Window

import "qrc:/js/DCFunkciiJS.js" as JSSpisok

Item {
	id: tmPVSpisok
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "slategray"

	height:pvwSpisok.pathItemCount*ntWidth*ntCoff*2

	signal sSpisok(var strSpisok);

	Path {//Размеры PathView, и направление бесконечного скролинга.
		id: pthSpisok
		//Середина - начало.
		startX: tmPVSpisok.width/2//Середина строчки списка - это середина Item
		startY: tmPVSpisok.height/2
		PathAttribute { name: "prozrachnost"; value: 1.0 }
		PathAttribute { name: "masshtab"; value: 1.0 }
		PathAttribute { name: "z"; value: 0 }//0 (+1 - это передний слой, -1 - это занлий слой)

		//Верх
		PathQuad {
			x: tmPVSpisok.width/2
			y: (tmPVSpisok.ntWidth*tmPVSpisok.ntCoff+tmPVSpisok.ntCoff)/2
			controlX: tmPVSpisok.width/2
			controlY: (tmPVSpisok.height/2-(tmPVSpisok.ntWidth*tmPVSpisok.ntCoff+tmPVSpisok.ntCoff)/2)/2
		}

		PathAttribute { name: "prozrachnost"; value: 0.5 }
		PathAttribute { name: "masshtab"; value: 0.95 }
		PathAttribute { name: "z"; value: -1 }

		//Низ
		PathQuad {
			x: tmPVSpisok.width/2
			y: tmPVSpisok.height-(tmPVSpisok.ntWidth*tmPVSpisok.ntCoff+tmPVSpisok.ntCoff)/2
			controlX: tmPVSpisok.width/2
			controlY: tmPVSpisok.height/2
		}

		PathAttribute { name: "prozrachnost"; value: 0.5 }
		PathAttribute { name: "masshtab"; value: 0.95 }
		PathAttribute { name: "z"; value: -1 }

		PathQuad{//Переход к началу в середину.
			x: tmPVSpisok.width/2
			y: tmPVSpisok.height/2
			controlX: tmPVSpisok.width/2
			controlY: tmPVSpisok.height/2+(tmPVSpisok.height/2
				-(tmPVSpisok.ntWidth*tmPVSpisok.ntCoff+tmPVSpisok.ntCoff)/2)/2
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

				opacity: PathView.prozrachnost//Прозрачность
				z: PathView.z//Номер отображаемого элемента списка
				scale: PathView.masshtab//Масштаб

				color: maPVSpisok.containsPress ? Qt.darker(tmPVSpisok.clrFona, 1.3) : tmPVSpisok.clrFona
				radius: (width/(tmPVSpisok.ntWidth*tmPVSpisok.ntCoff))/tmPVSpisok.ntCoff

				Text {//Текст внутри прямоугольника, считанный из модели.
					anchors.horizontalCenter: rctPVSpisok.horizontalCenter
					anchors.verticalCenter: rctPVSpisok.verticalCenter

					color:maPVSpisok.containsPress ? Qt.darker(tmPVSpisok.clrTexta, 1.3) : tmPVSpisok.clrTexta
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
		snapMode: PathView.SnapOneItem
		/*
		//Не работает, хз почему.
		focus: true//Без фокуса не будут работать клавиши.
		Keys.onUpPressed: decrementCurrentIndex();
		Keys.onDownPressed: incrementCurrentIndex();
		*/
	}
	Component.onCompleted: {//Слот, кода всё представление отрисовалось.
		//console.debug(pvwSpisok.pathItemCount);
	}
}
