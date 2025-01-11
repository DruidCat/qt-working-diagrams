import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import "pages"//Импортируем Страницы программы.

Window {
	id: root
    width: 480
    height: 640
	visible: true
	color: "grey"
    title: qsTr("Рабочий Список от druidcat@yandex.ru")

    property int ntWidth: 2
	property int ntCoff: 8
	property color clrKnopok: "orange"
	property color clrFona: "grey"
	property color clrStranic: "black"

	StackView {
		id: stvStr
		property string strOpisanie: "titul"
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
				onClickedSvet: {
					stvStr.push(pgStrSvet)//Переходим на страницу Потолочного освещения.
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
		Stranica {//Свет
		/////////////
		///С В Е Т///
		/////////////
			id: pgStrSvet
			visible: false
			ntWidth: root.ntWidth
			ntCoff: root.ntCoff
			clrFona: root.clrFona
			clrTexta: root.clrKnopok
			clrRabOblasti: "black"
			textZagolovok: "Управление потолочным освещением"
			StrSvet {
				id: tmSvet
				ntWidth: pgStrSvet.ntWidth; ntCoff: pgStrSvet.ntCoff
				clrTexta: pgStrSvet.clrTexta; clrFona: pgStrSvet.clrRabOblasti
				zagolovokX: pgStrSvet.rctStrZagolovok.x; zagolovokY: pgStrSvet.rctStrZagolovok.y
				zagolovokWidth: pgStrSvet.rctStrZagolovok.width
				zagolovokHeight: pgStrSvet.rctStrZagolovok.height
				zonaX: pgStrSvet.rctStrZona.x; zonaY: pgStrSvet.rctStrZona.y
				zonaWidth: pgStrSvet.rctStrZona.width; zonaHeight: pgStrSvet.rctStrZona.height
				toolbarX: pgStrSvet.rctStrToolbar.x; toolbarY: pgStrSvet.rctStrToolbar.y
				toolbarWidth: pgStrSvet.rctStrToolbar.width; toolbarHeight: pgStrSvet.rctStrToolbar.height
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
				radiusZona: pgStrSpisok.rctStrZona.radius//Радиус берём из настроек элемента qml
				onClickedMenu: {//Слот нажатия кнопки Меню.
					stvStr.push(pgStrMenu)//Перейти на страницу Меню
				}
				onClickedSozdat: {

				}
                onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strTitulOpisanie;//Отправляем текст в бизнес логику.
					stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
				onClickedSpisok: function(strSpisok) {
					stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
					pgStrElement.textZagolovok = strSpisok;//Задаём заголовок на странице Элементов.
					stvStr.push(pgStrElement);//Переключаемся на страницу Элементов.
				}
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrSpisok.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
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
					stvStr.strOpisanie = "titul";//Показываем описание Титульной страницы.
					stvStr.pop()//Назад страницу
				}
				onClickedSozdat: {

				}
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strSpisokOpisanie;//Отправляем текст в бизнес логику.
					stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
                onClickedElement: function(strElement) {//Слот сигнала нажатия на Элемент, вернув имя Элемента
					stvStr.strOpisanie = "element";//Показываем описание Элемента.
					pgStrDannie.textZagolovok = strElement;//Задаём заголовок на странице Данных.
					stvStr.push(pgStrDannie);//Переключаемся на страницу Данных..
				}
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrElement.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
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
					stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
					stvStr.pop()//Назад страницу
				}
                onClickedSozdat: {//Слот нажатия кнопки Создать.
                    stvStr.push(pgStrFileDialog);//Переключаемся на страницу Файлового Диалога.
                }
				onClickedInfo: {
					tmOpisanie.textTextEdit = cppqml.strElementOpisanie;//Отправляем текст в бизнес логику.
					stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
				}
                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
                    pgStrDannie.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
                }
			}
		}
        Stranica {//Страница Файловым Диалогом
        ///////////////////////////////////
        ///Ф А Й Л О В Ы Й   Д И А Л О Г///
        ///////////////////////////////////
            id: pgStrFileDialog
            visible: false
            ntWidth: root.ntWidth
            ntCoff: root.ntCoff
            clrFona: root.clrFona
            clrTexta: root.clrKnopok
            clrRabOblasti: root.clrStranic
            textZagolovok: "ПРОВОДНИК"
            StrFileDialog{//Блок Файлового Диалога, чтоб разгрузить Main.qml
                ntWidth: pgStrFileDialog.ntWidth; ntCoff: pgStrFileDialog.ntCoff
                clrTexta: pgStrFileDialog.clrTexta; clrFona: pgStrFileDialog.clrRabOblasti
                zagolovokX: pgStrFileDialog.rctStrZagolovok.x; zagolovokY: pgStrFileDialog.rctStrZagolovok.y
                zagolovokWidth: pgStrFileDialog.rctStrZagolovok.width;
                zagolovokHeight: pgStrFileDialog.rctStrZagolovok.height
                zonaX: pgStrFileDialog.rctStrZona.x; zonaY: pgStrFileDialog.rctStrZona.y
                zonaWidth: pgStrFileDialog.rctStrZona.width; zonaHeight: pgStrFileDialog.rctStrZona.height
                toolbarX: pgStrFileDialog.rctStrToolbar.x; toolbarY: pgStrFileDialog.rctStrToolbar.y
                toolbarWidth: pgStrFileDialog.rctStrToolbar.width;
                toolbarHeight: pgStrFileDialog.rctStrToolbar.height
                onClickedNazad: {//Слот нажатия кнопки Назад.
                    //stvStr.strOpisanie = "spisok";//Показываем описание элемента Списка.
                    //TODO сделать описание.
                    //TODO вернуть Путь первоначальный.
                    stvStr.pop()//Назад страницу
                }
                onClickedZakrit: {
                    //TODO вернуть Путь первоначальный.
                    stvStr.pop()//Назад страницу
                }
                onClickedInfo: {
                    //tmOpisanie.textTextEdit = cppqml.strElementOpisanie;//Отправляем текст в бизнес логику.
                    //stvStr.push(pgStrOpisanie);//Переключаемся на страницу Описания.
                    //TODO Зделать описание.
                }
//                onSignalToolbar: function(strToolbar) {//Слот сигнала signalToolbar с новым сообщением.
//                    pgStrFileDialog.textToolbar = strToolbar;//Пишем в ToolBar новое сообщение.
//                }
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
				strOpisanie: stvStr.strOpisanie//Передаём флаг Отображения конкретного Описания.
				onClickedNazad: {//Слот нажатия кнопки Назад.
					stvStr.pop()//Назад страницу
				}
				onClickedSozdat: {

				}
			}
		}
	}
}
