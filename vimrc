":" Run this file as "sh ~/.vim/vimrc" to set up the symlinks
"[" -e ~/.vimrc ] && mv -v -f ~/.vimrc ~/.vimrc~ || true
"[" -e ~/.gvimrc ] && mv -v -f ~/.gvimrc ~/.gvimrc~ || true
"ln" -v -s .vim/vimrc ~/.vimrc
"ln" -v -s .vim/vimrc ~/.gvimrc
"exit" 0

" Pathogen
call pathogen#infect()      " Must be before filetype plugin indent on

" Enable syntax highlighting (must before filetype plugin indent on, apparently, or VimOrganizer syntx highlighting breaks)
syntax on

" VimOrganizer -- pre-filetype stuff
let g:ft_ignore_pad = '\.org'

" filetype-specific auto-indent
filetype plugin indent on

" highlight bad whitespace (this part must be before colorscheme is loaded)
autocmd ColorScheme * highlight SpaceError ctermbg=red guibg=red

" syntax highlighting - enable and basic options
colorscheme dwon
let java_highlight_all=1
let java_highlight_debug=1
let java_highlight_functions=1
let python_highlight_all=1
let python_space_error_highlight=1

" highlight bad whitespace (this part must be after "syntax on")
" We highlight trailing spaces and spaces-before-tabs.
autocmd Syntax * syntax match SpaceError display excludenl /\s\+$\| \+\t/ containedin=ALL

" spaces and tabs
set tabstop=8 shiftwidth=4 softtabstop=4 expandtab  " default
autocmd FileType make setlocal sw=8 sts=0 noexpandtab
autocmd FileType html,mako,myt,php setlocal sw=2 sts=2 expandtab
autocmd FileType haskell,ruby,tex,verilog setlocal sw=2 sts=2 expandtab
autocmd FileType python setlocal sw=4 sts=4 expandtab
autocmd FileType objc setlocal sw=2 sts=2 expandtab foldmethod=syntax

" email editing
autocmd BufNewFile,BufRead .letter,mutt*,nn.*,snd.* setlocal spell formatoptions=wantql

" other file-specific settings
autocmd FileType text setlocal spell

" misc default settings
set backspace=2
set foldlevelstart=99
set foldmethod=indent
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
set t_vb=           " setting this blank when visualbell is set means we get no bell at all
set nospell
set spelllang=en_us,en_ca
set undolevels=10000
set visualbell
set wildmenu
set wildmode=longest:full

" gvim font
if has("gui_macvim")
    set guifont=Menlo\ Regular:h11
elseif has("gui_win32")
    set guifont=Terminal:h9
else
    set guifont=Monospace\ 8
endif

" Copy and Paste (Linux GUI)
if has("gui_running") && has("X11")
    " paste (Ctrl-V/Ctrl-Shift-V).  (Ctrl-Q still works for visual select)
    noremap <c-v> "+gP
    inoremap <c-v> <c-\><c-o>"+gP

    " copy
    vnoremap <c-c> "+ygv
endif

" Host-specific settings
if hostname() == 'mba415'
    " On this machine, I edit a lot of files in my Dropbox, and Vim .swp files
    " normally create a lot of noise in Dropbox.
    set directory^=~/.vim/swapfiles/
endif

" VimOrganizer - a lot of this is copied from bundle/hsitz-VimOrganizer-*/_vimrc
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
au BufEnter *.org            call org#SetOrgFileType()
command! OrgCapture :call org#CaptureBuffer()
command! OrgCaptureFile :call org#OpenCaptureFile()
let g:org_capture_file = '~/Dropbox/org-notes/gtd/captures.org'
let g:org_todo_setup='TODO NEXT STARTED WAITING DELEG | DONE CANCELED'
let g:org_agenda_select_dirs=["~/Dropbox/org-notes/gtd"]
let g:agenda_files = split(glob("~/Dropbox/org-notes/gtd/*.org"),"\n") + ["~/Dropbox/org-notes/status.org"]
let g:org_custom_searches = [
            \  { 'name':"Next week's agenda", 'type':'agenda',
            \    'agenda_date':'+1w', 'agenda_duration':'w' }
            \, { 'name':"Next week's TODOS", 'type':'agenda',
            \    'agenda_date':'+1w', 'agenda_duration':'w',
            \    'spec':'+UNFINISHED_TODOS' }
            \, { 'name':'Home tags', 'type':'heading_list', 'spec':'+HOME' }
            \, { 'name':'Home tags', 'type':'sparse_tree', 'spec':'+HOME' }
            \  ]

" Insert-mode autocompletion
inoremap @#$DF <c-\><c-o>$<tab># DEBUG FIXME<space><space>

" Create the :Retag command
" requires exuberant-ctags
function! Retag() abort
    call system("ctags -R --languages=-TeX --python-kinds=-i .")
    exec "redraw!"
endfunction
function! RetagObjC() abort
    call system("ctags -R --languages=-TeX --python-kinds=-i --langmap=C:.m.h .")
    call system("ctags -R --languages=-TeX --python-kinds=-i --langmap=ObjectiveC:.m.h --append .")
    exec "redraw!"
endfunction
command! Retag call Retag()
command! RetagObjC call RetagObjC()
