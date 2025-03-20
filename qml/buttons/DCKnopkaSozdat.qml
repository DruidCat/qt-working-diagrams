import QtQuick //2.14
//import QtQuick.Window //2.14
//import QtQuick.Controls //2.14

Item {
	id: tmKnopkaSozdat
	property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopki: "black"
    property color clrFona: "white"
    property bool blKrug: true

	width: ntWidth*ntCoff
	height: width

	signal clicked();

	Rectangle{
		id: rctKnopkaKrug
		anchors.fill: tmKnopkaSozdat

		color: maKnopkaSozdat.containsMouse ? Qt.darker(clrKnopki, 1.3) : clrKnopki
		border.color: Qt.darker(clrKnopki, 1.3)//Граница кнопки чуть темнее
		border.width: 1//Ширина границы
        radius: blKrug ? width/2 : 1
		smooth: true//Сглаживание
	}

	Rectangle{
		id: rctKnopkaSeredina
		width: tmKnopkaSozdat.width/2
		height: tmKnopkaSozdat.width/8
		anchors.centerIn: tmKnopkaSozdat

		color: maKnopkaSozdat.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		radius: tmKnopkaSozdat.width/4
	}

	Rectangle{
		id: rctKnopkaNiz
		width: tmKnopkaSozdat.width/8
		height: tmKnopkaSozdat.width/2
		anchors.centerIn: tmKnopkaSozdat

		color: maKnopkaSozdat.containsMouse ? Qt.darker(clrFona, 1.3) : clrFona
		radius: tmKnopkaSozdat.width/4
	}

	MouseArea {
		id: maKnopkaSozdat
		width: tmKnopkaSozdat.width
		height:  width
		onClicked: {
			tmKnopkaSozdat.clicked();
		}
	}
}
