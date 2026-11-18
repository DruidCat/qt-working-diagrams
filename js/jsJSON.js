function vrMenuSpisok(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
			{
				"nomer": "1",
                "menu": qsTr("Добавить")
			},
			{
				"nomer": "2",
                "menu": qsTr("Переименовать")
			},
			{
				"nomer": "3",
                "menu": qsTr("Удалить")
			},
            {
                "nomer": "4",
                "menu": qsTr("Сортировать")
            },
            {
                "nomer": "5",
                "menu": qsTr("Изменить Заголовок")
            },
			{
                "nomer": "6",
                "menu": qsTr("Выход")
			}
    ]
}
function vrMenuElement(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
			{
				"nomer": "1",
                "menu": qsTr("Добавить")
			},
			{
				"nomer": "2",
                "menu": qsTr("Переименовать")
			},
			{
				"nomer": "3",
                "menu": qsTr("Удалить")
			},
            {
                "nomer": "4",
                "menu": qsTr("Сортировать")
            },
			{
                "nomer": "5",
                "menu": qsTr("Выход")
			}
    ]
}
function vrMenuDannie(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
			{
				"nomer": "1",
                "menu": qsTr("Добавить")
			},
			{
				"nomer": "2",
                "menu": qsTr("Переименовать")
			},
			{
				"nomer": "3",
                "menu": qsTr("Удалить")
			},
            {
                "nomer": "4",
                "menu": qsTr("Сортировать")
            },
			{
                "nomer": "5",
                "menu": qsTr("Выход")
			}
    ]
}
function vrMenuAnimaciya(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
            {
                "nomer": "1",
                "menu": qsTr("Добавить")
            },
            {
                "nomer": "2",
                "menu": qsTr("Старт")
            },
            {
                "nomer": "3",
                "menu": qsTr("Без рамки")
            },
            {
                "nomer": "4",
                "menu": qsTr("Рамка 16:9")
            },
            {
                "nomer": "5",
                "menu": qsTr("Выход")
            }
    ]
}
function vrMenuFileDialog(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
            {
                "nomer": "1",
                "menu": qsTr("Закрыть")
            }
    ]
}
function vrMenuJurnal(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
            {
                "nomer": "1",
                "menu": qsTr("Поиск")
            },
            {
                "nomer": "2",
                "menu": qsTr("Инструкция")
            },
            {
                "nomer": "3",
                "menu": qsTr("Закрыть")
            }
    ]
}
function vrMenuVihod(){//Массив возвращается новым на каждый вызов: qsTr() вычисляется
    //заново, и меню всегда на актуальном языке интерфейса (задача #776).
    return [
            {
                "nomer": "1",
                "menu": qsTr("Выход")
            }
    ]
}

function fnSpisokJSON () {//Функция чтения JSON запроса Списка из бизнес логики.
	return JSON.parse(cppqml.strSpisokDB);//Читаем JSON запрос.
}

function fnElementJSON () {//Функция чтения JSON запроса Элементов из бизнес логики.
    return JSON.parse(cppqml.strElementDB);//Читаем JSON запрос.
}

function fnDannieJSON () {//Функция чтения JSON запроса Документов из бизнес логики.
	return JSON.parse(cppqml.strDannieDB);//Читаем JSON запрос.
}

function fnFileDialogJSON () {//Функция чтения JSON запроса каталога папок и файлов из бизнес логики.
    return JSON.parse(cppqml.strFileDialog);//Читаем JSON запрос.
}
