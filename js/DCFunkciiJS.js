var vrMenuSpisok = [
			{
				"nomer": "1",
				"menu": "Переименовать"
			},
			{
				"nomer": "2",
				"menu": "Удалить"
			},
			{
				"nomer": "3",
				"menu": "Выход"
			}
]

function fnSpisokJSON () {//Функция чтения JSON запроса Списка из бизнес логики.
	return JSON.parse(cppqml.strSpisokDB);//Читаем JSON запрос.
}

function fnElementJSON () {//Функция чтения JSON запроса Элементов из бизнес логики.
	return JSON.parse(cppqml.strElementDB);//Читаем JSON запрос.
}
