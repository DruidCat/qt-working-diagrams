var vrMenuSpisok = [
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
var vrMenuElement = [
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
var vrMenuDannie = [
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
var vrMenuAnimaciya = [
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
                "menu": qsTr("Без формата")
            },
            {
                "nomer": "4",
                "menu": qsTr("Формат 16:9")
            },
            {
                "nomer": "5",
                "menu": qsTr("Выход")
            }
]
var vrMenuFileDialog = [
            {
                "nomer": "1",
                "menu": qsTr("Закрыть")
            }
]
var vrMenuVihod = [
            {
                "nomer": "1",
                "menu": qsTr("Выход")
            }
]

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
