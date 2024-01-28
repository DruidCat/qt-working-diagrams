import QtQuick
import QtQuick.Window
import QtQuick.Controls

Item {
	id: tmOpisanie
    property int ntWidth: 2
    property int ntCoff: 8
    property color clrTexta: "orange"
	property color clrFona: "black"
	property alias zagolovokX: tmZagolovok.x
	property alias zagolovokY: tmZagolovok.y
	property alias zagolovokWidth: tmZagolovok.width
	property alias zagolovokHeight: tmZagolovok.height
	property alias zonaX: tmZona.x
	property alias zonaY: tmZona.y
	property alias zonaWidth: tmZona.width
	property alias zonaHeight: tmZona.height
	property alias toolbarX: tmToolbar.x
	property alias toolbarY: tmToolbar.y
	property alias toolbarWidth: tmToolbar.width
	property alias toolbarHeight: tmToolbar.height
	property alias radiusTextEdit: txdZona.radius
	property alias textTextEdit: txdZona.text
	anchors.fill: parent//Растянется по Родителю.
	signal clickedNazad();//Сигнал нажатия кнопки Назад
	signal clickedSozdat();//Сигнал нажатия кнопки Создать

	Item {
		id: tmZagolovok
		DCKnopkaNazad {
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.left: tmZagolovok.left
			anchors.margins: tmOpisanie.ntCoff/2
			clrKnopki: tmOpisanie.clrTexta
			onClicked: {
				knopkaOk.visible = false;//Делаем невидимой кнопку Ок.
				knopkaSozdat.visible = true;//Делаем видимой кнопку Создать.
				txdZona.readOnly = true;//Запрещаем редактировать текст.
				cppqml.strSpisokOpisanie = txdZona.text;//Отправляем текст в бизнес логику.
				tmOpisanie.clickedNazad();//Сигнал, что кнопка Назад нажата.
			}
		}
		DCKnopkaSozdat {
			id: knopkaSozdat
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmOpisanie.ntCoff/2
			visible: true 
			clrKnopki: tmOpisanie.clrTexta
			clrFona: tmOpisanie.clrFona
			onClicked: {
				txdZona.readOnly = false;//Разрешить редактировать.
				txdZona.textEdit.cursorPosition = txdZona.text.length;//Курсор в конец текста
				txdZona.textEdit.focus = true;//Сфокусироваться на области ввода
				txdZona.textEdit.cursorVisible = true;//Курсор сделать видимым
				visible = false//Делаем невидимой кнопку Создать.
				knopkaOk.visible = true;//Делаем видимой кнопку Ок
				tmOpisanie.clickedSozdat();//Излучаем сигнал Создать
			}
		}
		DCKnopkaOk {
			id: knopkaOk
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			anchors.verticalCenter: tmZagolovok.verticalCenter
			anchors.right: tmZagolovok.right
			anchors.margins: tmOpisanie.ntCoff/2
			visible: false 
			clrKnopki: tmOpisanie.clrTexta
			clrFona: tmOpisanie.clrFona
			onClicked: {
				visible = false;//Делаем невидимой кнопку Ок.
				knopkaSozdat.visible = true;//Делаем видимой кнопку Создать.
				txdZona.readOnly = true;//Запрещаем редактировать текст.
				cppqml.strSpisokOpisanie = txdZona.text;//Отправляем текст в бизнес логику.
			}
		}
	}
	Item {
		id: tmZona
		clip: true//Обрезаем всё что выходит за пределы этой области. Это для листания нужно.
		DCTextEdit {//Модуль просмотра текста, прокрутки и редактирования.
			id: txdZona
			ntWidth: tmOpisanie.ntWidth
			ntCoff: tmOpisanie.ntCoff
			readOnly: true//Запрещено редактировать текст
			radius: tmOpisanie.ntCoff/4//Радиус возьмём из настроек элемента qml через property
			clrFona: tmOpisanie.clrFona//Цвет фона рабочей области
			clrTexta: tmOpisanie.clrTexta//Цвет текста
			clrBorder: tmOpisanie.clrTexta//Цвет бардюра при редактировании текста.
			italic: true//Текст курсивом.
		}
	}
	Item {
		id: tmToolbar
	}
}
