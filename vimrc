:set nocompatible
:set tabstop=2
:set shiftwidth=2
:set softtabstop=2      " Make tabs into spaces
:set expandtab          " Make tabs into spaces
:set history=250
:set ignorecase
:set smartcase
:set hlsearch
:set incsearch
:set ruler
:set hidden             " Just hide buffers that have been modified, do not require a save
:set showcmd            " Show (partial) command in status line.
:set showmatch          " Show matching brackets.
:set cursorline
:set autoindent
:set previewheight=5
:set tags=tags;/
:set path+=./**
:syntax enable
" Yank from the cursor to the end of the line, to be consistent with C and D
:nnoremap Y y$
" CDC = Change window to Directory of Current file
command CDC lcd %:p:h   

" Use the filtering.vim script to show all matching lines in another buffer                    
:nmap <silent> <Leader>ff :call Gather(@/, 0)<CR>:echo<CR>

" Use the CamelCaseMotion script to quickly move to the next capital letter or _
:map <S-W> <Plug>CamelCaseMotion_w
:map <S-B> <Plug>CamelCaseMotion_b
:map <S-E> <Plug>CamelCaseMotion_e

