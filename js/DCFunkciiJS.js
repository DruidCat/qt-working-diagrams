var vrMenuSpisok = [
			{
				"nomer": "1",
                "menu": "Добавить"
			},
			{
				"nomer": "2",
				"menu": "Переименовать"
			},
			{
				"nomer": "3",
				"menu": "Удалить"
			},
            {
                "nomer": "4",
                "menu": "Сортировать"
            },
			{
                "nomer": "5",
				"menu": "Выход"
			}
]
var vrMenuElement = [
			{
				"nomer": "1",
                "menu": "Добавить"
			},
			{
				"nomer": "2",
				"menu": "Переименовать"
			},
			{
				"nomer": "3",
				"menu": "Удалить"
			},
            {
                "nomer": "4",
                "menu": "Сортировать"
            },
			{
                "nomer": "5",
				"menu": "Выход"
			}
]
var vrMenuDannie = [
			{
				"nomer": "1",
                "menu": "Добавить"
			},
			{
				"nomer": "2",
				"menu": "Переименовать"
			},
			{
				"nomer": "3",
				"menu": "Удалить"
			},
            {
                "nomer": "4",
                "menu": "Сортировать"
            },
			{
                "nomer": "5",
				"menu": "Выход"
			}
]
var vrMenuVihod = [
            {
                "nomer": "1",
                "menu": "Выход"
            }
]

function fnSpisokJSON () {//Функция чтения JSON запроса Списка из бизнес логики.
	return JSON.parse(cppqml.strSpisokDB);//Читаем JSON запрос.
}

function fnElementJSON () {//Функция чтения JSON запроса Элементов из бизнес логики.
	return JSON.parse(cppqml.strElementDB);//Читаем JSON запрос.
}

function fnFileDialogJSON () {//Функция чтения JSON запроса каталога папок и файлов из бизнес логики.
    return JSON.parse(cppqml.strFileDialog);//Читаем JSON запрос.
}
