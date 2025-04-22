import QtQuick //2.15
import "qrc:/js/jsJSON.js" as JSSpisok

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "slategray"
    //Настройки.
	height:pvwSpisok.pathItemCount*ntWidth*ntCoff*2
    //Сигналы
	signal sSpisok(var strSpisok);
    //Функции.
	Path {//Размеры PathView, и направление бесконечного скролинга.
		id: pthSpisok
		//Середина - начало.
        startX: root.width/2//Середина строчки списка - это середина Item
        startY: root.height/2
		PathAttribute { name: "prozrachnost"; value: 1.0 }
		PathAttribute { name: "masshtab"; value: 1.0 }
		PathAttribute { name: "z"; value: 0 }//0 (+1 - это передний слой, -1 - это занлий слой)
		//Верх
		PathQuad {
            x: root.width/2
            y: (root.ntWidth*root.ntCoff+root.ntCoff)/2
            controlX: root.width/2
            controlY: (root.height/2-(root.ntWidth*root.ntCoff+root.ntCoff)/2)/2
		}

		PathAttribute { name: "prozrachnost"; value: 0.5 }
		PathAttribute { name: "masshtab"; value: 0.95 }
		PathAttribute { name: "z"; value: -1 }
		//Низ
		PathQuad {
            x: root.width/2
            y: root.height-(root.ntWidth*root.ntCoff+root.ntCoff)/2
            controlX: root.width/2
            controlY: root.height/2
		}

		PathAttribute { name: "prozrachnost"; value: 0.5 }
		PathAttribute { name: "masshtab"; value: 0.95 }
		PathAttribute { name: "z"; value: -1 }

		PathQuad{//Переход к началу в середину.
            x: root.width/2
            y: root.height/2
            controlX: root.width/2
            controlY: root.height/2+(root.height/2
                -(root.ntWidth*root.ntCoff+root.ntCoff)/2)/2
		}
	}
	PathView {//Представление модели с бесконечным скролингом.
		id: pvwSpisok
		Component {
			id: cmpPVSpisok

			Rectangle {//Прямоугольник каждой отдельной строчки в модели.
				id: rctPVSpisok
                width: root.width
                height: root.ntWidth*root.ntCoff+root.ntCoff

				opacity: PathView.prozrachnost//Прозрачность
				z: PathView.z//Номер отображаемого элемента списка
				scale: PathView.masshtab//Масштаб

                color: maPVSpisok.containsPress ? Qt.darker(root.clrFona, 1.3) : root.clrFona
                radius: (width/(root.ntWidth*root.ntCoff))/root.ntCoff

				Text {//Текст внутри прямоугольника, считанный из модели.
					anchors.horizontalCenter: rctPVSpisok.horizontalCenter
					anchors.verticalCenter: rctPVSpisok.verticalCenter

                    color:maPVSpisok.containsPress ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
					text: modelData.spisok//Читаем текст из модели.
					font.pixelSize: (rctPVSpisok.width/text.length>=rctPVSpisok.height)
                        ? rctPVSpisok.height-root.ntCoff
                        : rctPVSpisok.width/text.length-root.ntCoff
				}
				MouseArea {
					id: maPVSpisok
					anchors.fill: rctPVSpisok
					onClicked: {
                        root.sSpisok(modelData.spisok)
					}
				}
			}
		}
        anchors.fill: root
        model: JSSpisok.fnSpisokJSON()
		delegate: cmpPVSpisok
		path: pthSpisok//Устанавливаем габариты и направление скролинга в представлении
		pathItemCount: 3//Количество отображаемых элементов в представлении.
		snapMode: PathView.SnapOneItem
		Keys.onUpPressed: decrementCurrentIndex();
		Keys.onDownPressed: incrementCurrentIndex();
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokDBChanged(){//Слот Если изменился элемент списка в strSpisok (Q_PROPERTY), то...
                pvwSpisok.model = JSSpisok.fnSpisokJSON();//Перегружаем модель PathView с новыми данными.
			}
		}
	}
	Component.onCompleted: {//Слот, кода всё представление отрисовалось.
		pvwSpisok.forceActiveFocus();//Без форсированного фокуса не будут работать клавиши.
	}
}
