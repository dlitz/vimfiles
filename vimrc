":" Run this file as "sh ~/.vim/vimrc" to set up the symlinks
"[" -e ~/.vimrc ] && mv -v -f ~/.vimrc ~/.vimrc~ || true
"[" -e ~/.gvimrc ] && mv -v -f ~/.gvimrc ~/.gvimrc~ || true
"ln" -v -s .vim/vimrc ~/.vimrc
"ln" -v -s .vim/vimrc ~/.gvimrc
"exit" 0

" Early initialization
set nocompatible
syntax off
filetype off

" Pathogen
call pathogen#infect()      " Must be before filetype plugin indent on

" filetype-specific auto-indent
filetype plugin indent on

" Enable syntax highlighting (must be after `filetype plugin indent on`, apparently, or VimOrganizer syntax highlighting breaks)
syntax on

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
autocmd FileType gitconfig setlocal sw=8 sts=0 noexpandtab
autocmd FileType html,mako,myt,php setlocal sw=2 sts=2 expandtab
autocmd FileType haskell,ruby,tex,verilog setlocal sw=2 sts=2 expandtab
autocmd FileType python setlocal sw=4 sts=4 expandtab
autocmd FileType objc,objcpp,coffee setlocal sw=2 sts=2 expandtab foldmethod=syntax

" email editing
"autocmd BufNewFile,BufRead .letter,mutt*,nn.*,snd.* setlocal spell formatoptions=wantql
autocmd FileType mail setlocal spell formatoptions=wantql

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

" This isn't the default on Windows for some reason
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1

" gvim font
if has("gui_macvim")
    set guifont=Menlo\ Regular:h11
elseif has("gui_win32")
    "set guifont=Terminal:h9        " Terminal doesn't display Unicode
    set guifont=Lucida_Console:h9:cANSI
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

" The coding styleguide for the client recommends 120-column line length limit
if exists("&colorcolumn")   " old vim doesn't have colorcolumn
    autocmd BufRead * if expand('<amatch>') =~ "^/.*/source/.*\.py$" | setl colorcolumn=121 | endif
endif

" ack-grep plugin
if has("win32")
    " This is insane:
    " - The result of this gets passed to exec 'set grepprg=' . g:ackprg
    " - The result of that gets passed to cmd /c
    " - cmd /c handles a single double-quoted string as the command name, but
    "   if you give it a double-quoted string as an argument, it suddenly says
    "   that the *command* isn't found.  So we pass single-quoted $HOME into
    "   that, and let the fact that the mingw perl knows how to parse
    "   single-quotes.
    let g:ackprg=fnameescape(
        \ shellescape($ProgramFiles . '\Git\bin\perl') . " " .
        \ "'$HOME\\vimfiles\\bin\\ack-1.96-single-file' -H --nocolor --nogroup")
else
    let g:ackprg=fnameescape('ack-grep -H --nocolor --nogroup')
endif

" Disable gitgutter on windows (it just repeatedly invokes vimrun.exe forever. Maybe it's just a high-DPI thing?)
if has("gui_running") && has("win32")
    let g:gitgutter_enabled = 0
end

" VimOrganizer - a lot of this is copied from bundle/hsitz-VimOrganizer-*/_vimrc
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
au BufEnter *.org            call org#SetOrgFileType()
command! OrgCapture :call org#CaptureBuffer()
command! OrgCaptureFile :call org#OpenCaptureFile()
"let g:org_todo_setup='TODO NEXT STARTED WAITING INREVIEW DELEG | DONE CANCELED'
"let g:org_capture_file = '~/Dropbox/org-notes/gtd/captures.org'
"let g:org_agenda_select_dirs=["~/Dropbox/org-notes/gtd"]
"let g:agenda_files = split(glob("~/Dropbox/org-notes/gtd/*.org"),"\n") + ["~/Dropbox/org-notes/status.org"]
let g:org_capture_file = '~/mnt/gtd-private/stuff.org'
let g:org_agenda_select_dirs=["~/mnt/gtd-private"]
let g:agenda_files = split(glob("~/mnt/gtd-private/*.org"),"\n")
let g:org_custom_searches = [
            \  { 'name':"Next week's agenda", 'type':'agenda',
            \    'agenda_date':'+1w', 'agenda_duration':'w' }
            \, { 'name':"Next week's TODOS", 'type':'agenda',
            \    'agenda_date':'+1w', 'agenda_duration':'w',
            \    'spec':'+UNFINISHED_TODOS' }
            \, { 'name':'Home tags', 'type':'heading_list', 'spec':'+HOME' }
            \, { 'name':'Home tags', 'type':'sparse_tree', 'spec':'+HOME' }
            \  ]

" Comment personalization tag.  For comments that specify things like
" "XXX(yournamehere)".  Useful in projects with multiple people, where it's
" helpful to know who wrote the comment without having to look at "git blame".
if exists("$VIMUSER")
    let g:me = $VIMUSER
elseif has("win32")
    let g:me = $USERNAME
elseif exists("$SUDO_USER")
    let g:me = $SUDO_USER
elseif exists("$USER")
    let g:me = $USER
endif

" I sometimes use a different username
if g:me == "dwon"
    let g:me = "dlitz"
endif

" Insert-mode autocompletion
inoremap @#$% <c-\><c-o>$<tab># DEBUG FIXME(<c-r>=g:me<cr>)<space><space>
map      @#$% $a@#$%<esc>

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

" tagbar configuration -- thanks http://thomashunter.name/blog/installing-vim-tagbar-with-macvim-in-os-x/
"let g:tagbar_ctags_bin='/usr/local/bin/ctags'
"let g:tagbar_width=26
noremap <silent> <Leader>y :TagbarToggle<cr>

"" BEGIN copied from http://www.daskrachen.com/2011/12/how-to-make-tagbar-work-with-objective.html
" add a definition for Objective-C to tagbar
let g:tagbar_type_objc = {
    \ 'ctagstype' : 'ObjectiveC',
    \ 'kinds'     : [
        \ 'i:interface',
        \ 'I:implementation',
        \ 'p:Protocol',
        \ 'm:Object_method',
        \ 'c:Class_method',
        \ 'v:Global_variable',
        \ 'F:Object field',
        \ 'f:function',
        \ 'p:property',
        \ 't:type_alias',
        \ 's:type_structure',
        \ 'e:enumeration',
        \ 'M:preprocessor_macro',
    \ ],
    \ 'sro'        : ' ',
    \ 'kind2scope' : {
        \ 'i' : 'interface',
        \ 'I' : 'implementation',
        \ 'p' : 'Protocol',
        \ 's' : 'type_structure',
        \ 'e' : 'enumeration'
    \ },
    \ 'scope2kind' : {
        \ 'interface'      : 'i',
        \ 'implementation' : 'I',
        \ 'Protocol'       : 'p',
        \ 'type_structure' : 's',
        \ 'enumeration'    : 'e'
    \ }
\ }
"" END copied from http://www.daskrachen.com/2011/12/how-to-make-tagbar-work-with-objective.html
