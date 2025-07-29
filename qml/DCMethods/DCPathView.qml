import QtQuick //2.15

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
    property color clrTexta: "Orange"
    property color clrFona: "Slategray"
    property var modelData: []//Свойства для модели.
    property alias karusel: pvwKarusel
    //Настройки.
    height:pvwKarusel.pathItemCount*ntWidth*ntCoff*1.5//Высота виджета
    //Сигналы
    signal clicked(var strSpisok);//Сигнал нажатия на элемент
    //Функции.
	Path {//Размеры PathView, и направление бесконечного скролинга.
        id: pthKarusel
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
        id: pvwKarusel
		Component {
            id: cmpKarusel

			Rectangle {//Прямоугольник каждой отдельной строчки в модели.
                id: rctKarusel
                width: root.width
                height: root.ntWidth*root.ntCoff

				opacity: PathView.prozrachnost//Прозрачность
				z: PathView.z//Номер отображаемого элемента списка
				scale: PathView.masshtab//Масштаб

                color: maKarusel.containsPress ? Qt.darker(root.clrFona, 1.3) : root.clrFona
                radius: (width/(root.ntWidth*root.ntCoff))/root.ntCoff

				Text {//Текст внутри прямоугольника, считанный из модели.
                    anchors.horizontalCenter: rctKarusel.horizontalCenter
                    anchors.verticalCenter: rctKarusel.verticalCenter

                    color:maKarusel.containsPress ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
                    text: spisok//Читаем текст из модели.
                    font.pixelSize: (rctKarusel.width/text.length>=rctKarusel.height)
                        ? rctKarusel.height-root.ntCoff
                        : rctKarusel.width/text.length-root.ntCoff
				}
				MouseArea {
                    id: maKarusel
                    anchors.fill: rctKarusel
					onClicked: {
                        root.clicked(spisok)
					}
				}
			}
		}
        anchors.fill: root
        model: root.modelData//Добавляем модель из свойства.
        delegate: cmpKarusel
        path: pthKarusel//Устанавливаем габариты и направление скролинга в представлении
        pathItemCount: 3//Количество видимых элементов модели.
        snapMode: PathView.SnapOneItem
		Keys.onUpPressed: decrementCurrentIndex();
		Keys.onDownPressed: incrementCurrentIndex();
	}
	Component.onCompleted: {//Слот, кода всё представление отрисовалось.
        pvwKarusel.forceActiveFocus();//Без форсированного фокуса не будут работать клавиши.
	}
}
