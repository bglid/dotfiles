" ~/.vimrc (configuration file for vim only)
set nocompatible
syntax on
set t_Co=256
set termguicolors
colorscheme ron

let mapleader=" "

" Some basic gui stuff and nicities
set number relativenumber
set cursorline
set ignorecase smartcase incsearch hlsearch
set scrolloff=5
set wildmenu
set hidden

" better indentation
set expandtab shiftwidth=4 tabstop=4
set smartindent
set autoindent

" Python file settings
autocmd FileType python setlocal shiftwidth=4 tabstop=4 expandtab

" Shell file settings
autocmd FileType sh setlocal shiftwidth=2 tabstop=2

" YAML file settings
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab

" to match my navigation in nvim
nnoremap <leader>pv :Rexplore<CR>

function! SKEL_spec()
	0r /usr/share/vim/current/skeletons/skeleton.spec
	language time en_US
	let login = system('whoami')
	if v:shell_error
	   let login = 'unknown'
	else
	   let newline = stridx(login, "\n")
	   if newline != -1
		let login = strpart(login, 0, newline)
	   endif
	endif
	let hostname = system('hostname -f')
	if v:shell_error
	    let hostname = 'localhost'
	else
	    let newline = stridx(hostname, "\n")
	    if newline != -1
		let hostname = strpart(hostname, 0, newline)
	    endif
	endif
	exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
	exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
	exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
endfunction
autocmd BufNewFile	*.spec	call SKEL_spec()
" ~/.vimrc ends here
