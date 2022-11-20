scriptencoding utf-8

" Basic options.  This file sould evaluate without (visible) errors in
" vim.tiny (i.e. no +eval feature) and old versions of vim.
" NOTE: Anything in an if..else..endif block is IGNORED on tiny builds.
"       For details, see :help no-eval-feature

" tab & indentation settings
set expandtab       " use soft tabs by default
set tabstop=8       " hard tabs are usually always 8 spaces
set shiftwidth=4    " indent 4 spaces by default
set softtabstop=4   " For Vim < 7.3.693
silent! set softtabstop=-1  " For Vim >= 7.3.693; emulated in vimrc-main
set autoindent
set nocindent       " dumber than indentexpr=
set copyindent
set preserveindent
set nosmartindent   " dumber than indentexpr=
set nosmarttab

" default file encoding
" This isn't the default on Windows for some reason
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1

" search preferences

" misc default settings
set backspace=2
set nobackup
set belloff=all
silent! set foldlevelstart=99   " Requires Vim >= 7.0
silent! set foldmethod=indent   " Requires Vim >= 7.0
set formatoptions=tcq   " vim default, modified by filetypes
set hlsearch    " highlight all matches
set ignorecase  " case-insensitive searches by default (see also 'smartcase' below)
set incsearch   " incremental search while typing the pattern
set isfname-==      " make auto-completion work after '=' sign
set laststatus=2
set listchars=eol:$,tab:>-,extends:→
set nomodeline      " using the 'securemodelines' plugin instead
silent! set mouse=a
set number
set printfont=courier:h8
set printoptions=paper:letter
set ruler
set scrolloff=2
set showcmd
set showmatch
set smartcase   " case-sensitive searches when pattern contains uppercase
set swapsync=   " Don't fsync() the swapfiles.   Might lose data, but it's too slow.
"set t_vb=           " setting this blank when visualbell is set means we get no bell at alls
set textwidth=0
silent! set nospell                 " Requires Vim >= 7.0
silent! set spelllang=en_us,en_ca   " Requires Vim >= 7.0
set undolevels=10000
"set visualbell
set wildmenu wildmode=list:longest  " more bash-like tab completion, except cursors enable menu mode

" colorscheme
"silent! colorscheme dwon
silent! colorscheme solarized

" Set colorcolumn to match coding styleguides of various source trees.
silent! set colorcolumn=+1  " highlight the column after 'textwidth' (requires Vim >= 7.3)

" <Leader>i -- toggle ignorecase
noremap <silent> \i :setlocal ignorecase!<cr>:setlocal ignorecase?<cr>

" <Leader>h -- toggle hlsearch
noremap <silent> \h :setlocal hlsearch!<cr>:setlocal hlsearch?<cr>

" <Leader>l -- toggle list
"noremap <silent> <Leader>l :setlocal list!<cr>:setlocal list?<cr>
noremap <silent> \l :setlocal list!<cr>:setlocal list?<cr>

" <Leader>p -- toggle paste
noremap <silent> \p :setlocal paste!<cr>:setlocal paste?<cr>

" <Leader>t -- toggle expandtab
noremap <silent> \t :setlocal expandtab!<cr>:setlocal expandtab?<cr>

" <Leader>n -- toggle numbers
noremap <silent> \n :setlocal number!<cr>:setlocal number?<cr>

" <Leader>w -- toggle wrap
noremap <silent> \w :setlocal wrap!<cr>:setlocal wrap?<cr>

" Ctrl-Shift-C -- Copy to clipboard (gvim)
vnoremap <c-s-c> "+ygv

" Ctrl-Shift-C -- Cut to clipboard (gvim)
vnoremap <c-s-x> "+dgv

" Ctrl-Shift-V -- Paste (gvim)
inoremap <c-s-v> <c-o>"+gP
