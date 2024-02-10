import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
	id: root
    width: 380
    height: 640
	visible: true
	color: "grey"
	title: qsTr("Список от druidcat@yandex.ru.")

    property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopok: "orange"
	property color clrFona: "grey"
	property color clrStranic: "black"

	StackView {
		id: stvStr
		anchors.fill: parent
		initialItem: pgStrSpisok
		//initialItem: pgStrMenu
		//initialItem: pgStrDannie
		Stranica {//Меню
		/////////////
		///М Е Н Ю///
		/////////////
			id: pgStrMenu
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			//clrRabOblasti: "darkslategray"
			clrRabOblasti: "MidnightBlue"
			textZagolovok: "МЕНЮ"
			StrMenu {
				id: tmMenu
				ntWidth: pgStrMenu.ntWidth; ntCoff: pgStrMenu.ntCoff
				clrTexta: pgStrMenu.clrTexta; clrFona: pgStrMenu.clrRabOblasti
				zagolovokX: pgStrMenu.rctStrZagolovok.x; zagolovokY: pgStrMenu.rctStrZagolovok.y
				zagolovokWidth: pgStrMenu.rctStrZagolovok.width
				zagolovokHeight: pgStrMenu.rctStrZagolovok.height
				zonaX: pgStrMenu.rctStrZona.x; zonaY: pgStrMenu.rctStrZona.y
				zonaWidth: pgStrMenu.rctStrZona.width; zonaHeight: pgStrMenu.rctStrZona.height
				toolbarX: pgStrMenu.rctStrToolbar.x; toolbarY: pgStrMenu.rctStrToolbar.y
				toolbarWidth: pgStrMenu.rctStrToolbar.width; toolbarHeight: pgStrMenu.rctStrToolbar.height
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
				onClickedLogi: {
					stvStr.push(pgStrDebug)//Переходим на страницу Логи.
				}
				onClickedAvtor: {
					stvStr.push(pgStrAvtor)//Переходим на страницу об Авторе.
				}
			}
		}
		Stranica {//Debug
		///////////////
		///D E B U G///
		///////////////
			id: pgStrDebug
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "MidnightBlue"
			textZagolovok: "Логи"
			StrDebug {
				id: tmDebug
				ntWidth: pgStrDebug.ntWidth; ntCoff: pgStrDebug.ntCoff
				clrTexta: pgStrDebug.clrTexta; clrFona: pgStrDebug.clrRabOblasti
				zagolovokX: pgStrDebug.rctStrZagolovok.x; zagolovokY: pgStrDebug.rctStrZagolovok.y
				zagolovokWidth: pgStrDebug.rctStrZagolovok.width
				zagolovokHeight: pgStrDebug.rctStrZagolovok.height
				zonaX: pgStrDebug.rctStrZona.x; zonaY: pgStrDebug.rctStrZona.y
				zonaWidth: pgStrDebug.rctStrZona.width; zonaHeight: pgStrDebug.rctStrZona.height
				toolbarX: pgStrDebug.rctStrToolbar.x; toolbarY: pgStrDebug.rctStrToolbar.y
				toolbarWidth: pgStrDebug.rctStrToolbar.width; toolbarHeight: pgStrDebug.rctStrToolbar.height
				radiusTextEdit: pgStrDebug.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
		Stranica {//Автор
		///////////////
		///А В Т О Р///
		///////////////
			id: pgStrAvtor
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
			textZagolovok: "Об авторе программы"
			StrAvtor {
				id: tmAvtor
				ntWidth: pgStrAvtor.ntWidth; ntCoff: pgStrAvtor.ntCoff
				clrTexta: pgStrAvtor.clrTexta; clrFona: pgStrAvtor.clrRabOblasti
				zagolovokX: pgStrAvtor.rctStrZagolovok.x; zagolovokY: pgStrAvtor.rctStrZagolovok.y
				zagolovokWidth: pgStrAvtor.rctStrZagolovok.width
				zagolovokHeight: pgStrAvtor.rctStrZagolovok.height
				zonaX: pgStrAvtor.rctStrZona.x; zonaY: pgStrAvtor.rctStrZona.y
				zonaWidth: pgStrAvtor.rctStrZona.width; zonaHeight: pgStrAvtor.rctStrZona.height
				toolbarX: pgStrAvtor.rctStrToolbar.x; toolbarY: pgStrAvtor.rctStrToolbar.y
				toolbarWidth: pgStrAvtor.rctStrToolbar.width; toolbarHeight: pgStrAvtor.rctStrToolbar.height
				radiusTextEdit: pgStrAvtor.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {
					stvStr.pop()//Назад страницу
				}
			}
		}
		Stranica {//Страница со Списком
		/////////////////
		///С П И С О К///
		/////////////////
			id: pgStrSpisok
			visible: true
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
			textZagolovok: "ТМК"
			StrSpisok {
				id: tmSpisok
				ntWidth: pgStrSpisok.ntWidth; ntCoff: pgStrSpisok.ntCoff
				clrTexta: pgStrSpisok.clrTexta; clrFona: pgStrSpisok.clrRabOblasti
				zagolovokX: pgStrSpisok.rctStrZagolovok.x; zagolovokY: pgStrSpisok.rctStrZagolovok.y
				zagolovokWidth: pgStrSpisok.rctStrZagolovok.width
				zagolovokHeight: pgStrSpisok.rctStrZagolovok.height
				zonaX: pgStrSpisok.rctStrZona.x; zonaY: pgStrSpisok.rctStrZona.y
				zonaWidth: pgStrSpisok.rctStrZona.width; zonaHeight: pgStrSpisok.rctStrZona.height
				toolbarX: pgStrSpisok.rctStrToolbar.x; toolbarY: pgStrSpisok.rctStrToolbar.y
				toolbarWidth: pgStrSpisok.rctStrToolbar.width; toolbarHeight: pgStrSpisok.rctStrToolbar.height
				onClickedMenu: {//Слот нажатия кнопки Меню.
					stvStr.push(pgStrMenu)//Перейти на страницу Меню
				}
				onClickedSozdat: {

				}
				onClickedInfo: {
				}
				onClickedSpisok: function(strSpisok) {
					pgStrElement.textZagolovok = strSpisok;//Задаём заголовок на второй странице.
					stvStr.push(pgStrElement);//Переключаемся на страницу Состава.
				}
			}
		}
		Stranica {//Страница Элементы Списка
		/////////////////////
		///Э Л Е М Е Н Т Ы///
		/////////////////////
			id: pgStrElement
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
            clrRabOblasti: root.clrStranic
			StrElement {
				id: tmElement
				ntWidth: pgStrElement.ntWidth; ntCoff: pgStrElement.ntCoff
				clrTexta: pgStrElement.clrTexta; clrFona: pgStrElement.clrRabOblasti
				zagolovokX: pgStrElement.rctStrZagolovok.x; zagolovokY: pgStrElement.rctStrZagolovok.y
				zagolovokWidth: pgStrElement.rctStrZagolovok.width
				zagolovokHeight: pgStrElement.rctStrZagolovok.height
				zonaX: pgStrElement.rctStrZona.x; zonaY: pgStrElement.rctStrZona.y
				zonaWidth: pgStrElement.rctStrZona.width; zonaHeight: pgStrElement.rctStrZona.height
				toolbarX: pgStrElement.rctStrToolbar.x; toolbarY: pgStrElement.rctStrToolbar.y
				toolbarWidth: pgStrElement.rctStrToolbar.width
				toolbarHeight: pgStrElement.rctStrToolbar.height
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
				onClickedSozdat: {

				}
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strSpisokOpisanie;
					stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
			}
		}
		Stranica {//Страница Описания
		/////////////////////
		///О П И С А Н И Е///
		/////////////////////
			id: pgStrOpisanie
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: root.clrStranic
			textZagolovok: "Описание"
			StrOpisanie {
				id: tmOpisanie
				ntWidth: pgStrOpisanie.ntWidth; ntCoff: pgStrOpisanie.ntCoff
				clrTexta: pgStrOpisanie.clrTexta; clrFona: pgStrOpisanie.clrRabOblasti
				zagolovokX: pgStrOpisanie.rctStrZagolovok.x; zagolovokY: pgStrOpisanie.rctStrZagolovok.y
				zagolovokWidth: pgStrOpisanie.rctStrZagolovok.width
				zagolovokHeight: pgStrOpisanie.rctStrZagolovok.height
				zonaX: pgStrOpisanie.rctStrZona.x; zonaY: pgStrOpisanie.rctStrZona.y
				zonaWidth: pgStrOpisanie.rctStrZona.width; zonaHeight: pgStrOpisanie.rctStrZona.height
				toolbarX: pgStrOpisanie.rctStrToolbar.x; toolbarY: pgStrOpisanie.rctStrToolbar.y
				toolbarWidth: pgStrOpisanie.rctStrToolbar.width
				toolbarHeight: pgStrOpisanie.rctStrToolbar.height
				radiusTextEdit: pgStrOpisanie.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
				onClickedSozdat: {

				}
			}
		}
		Stranica {//Страница с Данными
		/////////////////
		///Д А Н Н Ы Е///
		/////////////////
			id: pgStrDannie
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: root.clrStranic
			StrDannie {//Блок управления Данными, чтоб разгрузить Main.qml
				ntWidth: pgStrDannie.ntWidth; ntCoff: pgStrDannie.ntCoff
				clrTexta: pgStrDannie.clrTexta; clrFona: pgStrDannie.clrRabOblasti
				zagolovokX: pgStrDannie.rctStrZagolovok.x; zagolovokY: pgStrDannie.rctStrZagolovok.y
				zagolovokWidth: pgStrDannie.rctStrZagolovok.width;
				zagolovokHeight: pgStrDannie.rctStrZagolovok.height
				zonaX: pgStrDannie.rctStrZona.x; zonaY: pgStrDannie.rctStrZona.y
				zonaWidth: pgStrDannie.rctStrZona.width; zonaHeight: pgStrDannie.rctStrZona.height
				toolbarX: pgStrDannie.rctStrToolbar.x; toolbarY: pgStrDannie.rctStrToolbar.y
				toolbarWidth: pgStrDannie.rctStrToolbar.width; toolbarHeight: pgStrDannie.rctStrToolbar.height
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
			}
		}
	}
}
