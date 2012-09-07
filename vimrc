" Pathogen
call pathogen#infect()      " Must be before filetype plugin indent on

" filetype-specific auto-indent
filetype plugin indent on

" highlight bad whitespace (this part must be before colorscheme is loaded)
autocmd ColorScheme * highlight SpaceError ctermbg=red guibg=red

" syntax highlighting - enable and basic options
syntax on
colorscheme dwon
let java_highlight_all=1
let java_highlight_debug=1
let java_highlight_functions=1
let python_highlight_all=1
let python_space_error_highlight=1

" highlight bad whitespace (this part must be after "syntax on")
" We hightlight trailing spaces and spaces-before-tabs.
autocmd Syntax * syntax match SpaceError display excludenl /\s\+$\| \+\t/ containedin=ALL

" spaces and tabs
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab  " default
autocmd FileType make setlocal ts=8 sw=8 sts=0 noexpandtab
autocmd FileType html,mako,myt,php setlocal ts=2 sw=2 sts=2 expandtab
autocmd FileType haskell,ruby,tex,verilog setlocal ts=2 sw=2 sts=2 expandtab
autocmd FileType python setlocal ts=4 sw=4 sts=4 expandtab

" email editing
autocmd BufNewFile,BufRead .letter,mutt*,nn.*,snd.* setlocal formatoptions=wantql

" misc default settings
set backspace=2
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set listchars=eol:$,tab:>-
set mouse=a
set nomodeline
set number
set printfont=courier:h8
set printoptions=paper:letter
set ruler
set showcmd
set showmatch
set smartcase
set undolevels=10000
set wildmenu
set wildmode=longest:full

" VimOrganizer
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
au BufEnter *.org            call org#SetOrgFileType()
