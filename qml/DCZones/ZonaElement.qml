import QtQuick //2.15
import "qrc:/js/jsJSON.js" as JSElement

Item {
    id: root
    //Свойства.
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrTexta: "orange"
	property color clrFona: "SlateGray"
    property bool enabled: true
    //Сигналы
    signal clicked(int ntNomer, var strElement);//Сигнал клика на одном из элементов, передаёт номер и имя.
    signal tap();//Сигнал нажатия не на элементы.
    //Функции.
	ListView {
		id: lsvZona
        TapHandler {//Нажимаем не на элементы, а на пустую область.
            id: tphTap
            onTapped: root.tap()
        }
        Component {//Компонент читающий из Модели, и создающий поочереди каждый Элемент с настройками.
			id: cmpZona
			Rectangle {
				id: rctZona
				width: lsvZona.width
                height: root.ntWidth*root.ntCoff+root.ntCoff
                radius: (width/(root.ntWidth*root.ntCoff))/root.ntCoff
                opacity: 0.9//Небольшая прозрачность, чтоб был виден Логотип под надписями.
                clip: true//Обрезаем лишний текст в прямоугольнике.
                color: maZona.containsPress
                       ? Qt.darker(root.clrFona, 1.3) : root.clrFona
				Text {
					id: txtText
					color: maZona.containsPress
                           ? Qt.darker(root.clrTexta, 1.3) : root.clrTexta
					anchors.horizontalCenter: rctZona.horizontalCenter
					anchors.verticalCenter: rctZona.verticalCenter
					text: modelData.element
                    font.pixelSize: rctZona.height-root.ntCoff
				}
				Component.onCompleted:{//Когда текст отрисовался, нужно выставить размер шрифта.
					if(rctZona.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(var ltShag=txtText.font.pixelSize; ltShag<rctZona.height-root.ntCoff; ltShag++){
							if(txtText.width < rctZona.width){//Если длина текста меньше динны строки
								txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
								if(txtText.width > rctZona.width){//Но, если переборщили
									txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
									return;//Выходим из увеличения шрифта.
								}
							}
						}
					}
					else{//Если длина строки меньше длины текста, то...
						for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
							if(txtText.width > rctZona.width)//Если текст дилиннее строки, то...
								txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
						}
					}
				}
                MouseArea {//Создаём MA для каждого Элемента.
					id: maZona
					anchors.fill: rctZona
                    enabled: root.enabled ? true : false
                    onClicked: {//При клике на Элемент
                        root.clicked(modelData.kod, modelData.element);//Излучаем сигнал с номером и именем.
					}
				}
				onWidthChanged: {//Если длина строки изменилась, то...
					if(rctZona.width > txtText.width){//Если длина строки больше длины текста, то...
                        for(var ltShag=txtText.font.pixelSize; ltShag<rctZona.height-root.ntCoff; ltShag++){
							if(txtText.width < rctZona.width){//Если длина текста меньше динны строки
								txtText.font.pixelSize = ltShag;//Увеличиваем размер шрифта
								if(txtText.width > rctZona.width){//Но, если переборщили
									txtText.font.pixelSize--;//То уменьшаем размер шрифта и...
									return;//Выходим из увеличения шрифта.
								}
							}
						}
					}
					else{//Если длина строки меньше длины текста, то...
						for(let ltShag = txtText.font.pixelSize; ltShag > 0; ltShag--){//Цикл уменьшения 
							if(txtText.width > rctZona.width)//Если текст дилиннее строки, то...
								txtText.font.pixelSize = ltShag;//Уменьшаем размер шрифта.
						}
					}
				}
			}
		}
        anchors.fill: root
        anchors.margins: root.ntCoff
        spacing: root.ntCoff//Расстояние между строками
		model: JSElement.fnElementJSON()
		delegate: cmpZona
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrElementDBChanged(){//Слот Если изменился Элемент в strElementDB (Q_PROPERTY), то...
				lsvZona.model = JSElement.fnElementJSON();//Перегружаем модель ListView с новыми данными.
            }
        }
		Connections {//Соединяем сигнал из C++ с действием в QML
			target: cppqml;//Цель объект класса С++ DCCppQml
			function onStrSpisokChanged(){//Слот Если изменился элемент Списка strSpisok (Q_PROPERTY), то...
				lsvZona.model = JSElement.fnElementJSON();//Перегружаем модель ListView с новыми данными.
            }
        }
	}
}
