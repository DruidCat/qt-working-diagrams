"Сохранить все открытые изменённые файл и Запустить проект с помощью клавиши Alt+F7
if has('win32')
	nnoremap <a-F7> :wa<cr>:!./ru.Mentor.exe .<cr>
	inoremap <a-F7> <ESC>:wa<cr>:!./ru.Mentor.exe .<cr>
endif
if has('unix')
	nnoremap <a-F7> :wa<cr>:!./ru.Mentor .<cr>
	inoremap <a-F7> <ESC>:wa<cr>:!./ru.Mentor .<cr>
endif


