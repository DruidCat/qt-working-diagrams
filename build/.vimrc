"Сохранить все открытые изменённые файл и Запустить проект с помощью клавиши Alt+F7
if has('win32')
	nnoremap <a-F7> :wa<cr>:!./ru.Mentor.exe .<cr>
	inoremap <a-F7> <ESC>:wa<cr>:!./ru.Mentor.exe .<cr>
endif
if has('unix')
	nnoremap <a-F7> :wa<cr>:!./ru.Mentor .<cr>
	inoremap <a-F7> <ESC>:wa<cr>:!./ru.Mentor .<cr>
endif

" Сборка Release-версии проекта по F8: отдельный каталог ../build-release,
" чтобы не перетирать Debug-кэш основного build/.
" (F8 локально перекрывает TagList в этом каталоге.)
if has('win32')
	function! ReleaseBuild()
		let out = system('cmake -S .. -B ../build-release && ' .
			\ 'cmake --build ../build-release --config Release --parallel')
		echom out
		redraw!
	endfunction
endif
if has('unix')
	function! ReleaseBuild()
		let out = system('cmake -S .. -B ../build-release -DCMAKE_BUILD_TYPE=Release && ' .
			\ 'cmake --build ../build-release --parallel')
		echom out
		redraw!
	endfunction
endif
nnoremap <F8> :wa<cr>:call ReleaseBuild()<cr>
inoremap <F8> <ESC>:wa<cr>:call ReleaseBuild()<cr>a


