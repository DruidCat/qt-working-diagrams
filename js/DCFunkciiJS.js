/*
var vrUchastki = [
			{
				"nomer": 1,
				"spisok": "Формовка",
				"opisanie": "Участок формовки и всё такое."
			},
			{
				"nomer": 2,
				"spisok": "Сварка",
				"opisanie": "Участок сварки и всё такое."

			},
			{
				"nomer": 3,
				"spisok": "Отделка",
				"opisanie": "Участок отделки и всё такое."
			}
]
*/
function fnSpisokJSON () {//Функция чтения JSON запроса Списка из бизнес логики.
	return JSON.parse(cppqml.strSpisokDB);//Читаем JSON запрос.
}

function fnElementJSON () {//Функция чтения JSON запроса Элементов из бизнес логики.
	return JSON.parse(cppqml.strElementDB);//Читаем JSON запрос.
}
