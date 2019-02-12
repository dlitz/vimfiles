":" Run this file as "sh ~/.vim/vimrc" to set up the symlinks
"[" -e ~/.vimrc ] && mv -v -f ~/.vimrc ~/.vimrc~ || true
"[" -e ~/.gvimrc ] && mv -v -f ~/.gvimrc ~/.gvimrc~ || true
"ln" -v -s .vim/vimrc ~/.vimrc
"ln" -v -s .vim/vimrc ~/.gvimrc
"exit" 0

" This has side effects, so only do it if it isn't already done
if &compatible
    set nocompatible
endif

" Trust termcap before builtin
if has("gui_running")
    set nottybuiltin
else
    set nottybuiltin term=$TERM
endif

" See :help defaults.vim
" This might make things less predictable between vim versions, I dunno.  Some
" part of this was new in Vim 8.
"
" This was added later, so it might make sense to remove some other things.
"
" The main reason for doing this was that my timeoutlen & ttimeoutlen values
" were unreasonable and annoying.  (The default is 1000ms or 100ms if using
" defaults.vim)
"
" In theory, setting a short timeout could break escape sequences over a
" delayed connection, but I'd bet that terminal escape sequences typically
" stay together inside their own TCP segment, so problems should be
" rare---much rarer than the difficulty I'm having when I habitually press ESC
" extra times to get back to a known state.
if version >= 800
    unlet! skip_defaults_vim
    source $VIMRUNTIME/defaults.vim
else
    " For earlier versions, fix the ESC key, at least
    set timeoutlen=1000 ttimeoutlen=100
endif

" Early initialization
syntax off
filetype off

" Pathogen
call pathogen#infect()      " Must be before filetype plugin indent on

" filetype-specific auto-indent
filetype plugin indent on

" Terminal workarounds
if has("gui_running")
    " do nothing
elseif match(&term, "^konsole") != -1
    " Enable true-color
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Better mouse protocol
if match(&ttym, "^xterm") != -1
    set ttym=sgr
endif

" true-color support doesn't exist in vim 7.4? (before vim 8 maybe?)
" also we don't want to set this unless we have the actual escape codes
if exists("&termguicolors") && !empty(&t_8f) && !empty(&t_8b)
    " Use RGB colors in text mode if supported by the terminal (see :help xterm-true-color)
  set termguicolors
endif

" Enable syntax highlighting (must be after `filetype plugin indent on`, apparently, or VimOrganizer syntax highlighting breaks)
syntax on

" highlight bad whitespace (this part must be before colorscheme is loaded)
augroup spaceerror
    autocmd!
    " highlight bad whitespace (this part must be after "syntax on")
    " We highlight trailing spaces and spaces-before-tabs.
    autocmd Syntax * syntax match SpaceError display excludenl /\s\+$\| \+\t/ containedin=ALL
    autocmd ColorScheme * highlight default SpaceError ctermbg=red guibg=red
    " Don't lose the syntax highlighting when vimrc is reloaded
    doautoall spaceerror Syntax
augroup END

" syntax highlighting - enable and basic options
colorscheme dwon
let java_highlight_all=1
let java_highlight_debug=1
let java_highlight_functions=1
let python_highlight_all=1
let python_space_error_highlight=1

" plugin/ctab.vim -- disable by default; we'll set it up ourselves
"let g:ctab_filetype_maps = 1
"let g:ctab_enable_default_filetype_maps = 0
"let g:ctab_disable_tab_maps = 1
"let g:ctab_disable_checkalign = 1

" Texas Instruments PRU-ICSS assembly language
" XXX - No longer needed?
"autocmd FileType BufRead,BufNewFile *.p,*.hp setfiletype msp

" Don't allow setting 'softtabstop'; We pin it to the value of 'shiftwidth'
runtime plugin/securemodelines.vim
call filter(g:secure_modelines_allowed_items, 'v:val !=# "softtabstop" && v:val !=# "sts"')

" tab & indentation settings
set expandtab       " use soft tabs by default
set tabstop=8       " hard tabs are usually always 8 spaces
set shiftwidth=4    " indent 4 spaces by default
try
    let &softtabstop = -1  " use the value of 'shiftwidth' implicitly
catch /^Vim:\(\a+\):E487:/  " 'Argument must be positive'
    let &softtabstop = &shiftwidth  " use the value of 'shiftwidth' directly
endtry
set autoindent
set nocindent       " dumber than indentexpr=
set copyindent
set preserveindent
set nosmartindent   " dumber than indentexpr=
set nosmarttab

" Some filetypes screw up these values
au FileType make let [&l:ts, &l:sw, &l:sts, &l:et] = [&g:ts, &g:sw, &g:sts, &g:et]

au FileType make,gitconfig,zim              setlocal sw=0 noet " | call ctab#SetFileTypeMaps()
au FileType html,mako,myt,php,yaml          setlocal sw=2   " 2-space tabs
au FileType haskell,ruby,tex,verilog        setlocal sw=2
au FileType objc,objcpp,coffee              setlocal sw=2
au FileType python                          setlocal sw=4 ts=8
au FileType yaml                            setlocal sw=2 indentexpr=

au BufRead,BufWrite,BufWritePost,BufNewFile *.tac setlocal ft=python

" email editing
"autocmd BufNewFile,BufRead .letter,mutt*,nn.*,snd.* setlocal spell formatoptions=wantql
autocmd FileType mail setlocal spell formatoptions=wantql

" auto-formatting comments when editing code
autocmd FileType c,objc,objcpp,coffee,make,haskell,ruby,verilog,python,objc,objcpp,coffee
    \ setlocal formatoptions=croq

" other file-specific settings
autocmd FileType text setlocal spell

" default file encoding
" This isn't the default on Windows for some reason
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1

" search preferences

" misc default settings
set backspace=2
set nobackup
set foldlevelstart=99
set foldmethod=indent
set formatoptions=tcq   " vim default, modified by filetypes
set hlsearch    " highlight all matches
set ignorecase  " case-insensitive searches by default (see also 'smartcase' below)
set incsearch   " incremental search while typing the pattern
set laststatus=2
set listchars=eol:$,tab:>-
set nomodeline      " using the 'securemodelines' plugin instead
set mouse=a
set number
set printfont=courier:h8
set printoptions=paper:letter
set ruler
set scrolloff=2
set showcmd
set showmatch
set smartcase   " case-sensitive searches when pattern contains uppercase
set t_vb=           " setting this blank when visualbell is set means we get no bell at all
set textwidth=0
set nospell
set spelllang=en_us,en_ca
set undolevels=10000
set visualbell
set wildmenu wildmode=list:longest  " more bash-like tab completion, except cursors enable menu mode

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
    " OK, ideally, Ctrl-V would be for Visual Block mode, and Ctrl-Shift-V
    " would paste from the CLIPBOARD, bit Vim can't distinguish between <C-V>
    " and <C-S-V>.  Ctrl-Q also works in GUI mode, but not in many terminals
    " (it's the XON software flow-control signal).  Argh.

    " Shift-Insert : Paste from CLIPBOARD (default is <MiddleMouse>)
    noremap <S-Insert> "+gP
    inoremap <S-Insert> <C-\><C-O>"+gP

    " Ctrl-C : Copy to CLIPBOARD
    vnoremap <C-C> "+ygv

    " Ctrl-Insert : Copy to CLIPBOARD
    vnoremap <C-Insert> "+ygv

    " Shift-Del : Cut to CLIPBOARD
    vnoremap <S-Del> "+dgv
endif

" Set colorcolumn to match coding styleguides of various source trees.
if exists("&colorcolumn")   " old vim doesn't have colorcolumn
    set colorcolumn=+1  " highlight the column after 'textwidth'
    au BufRead,BufNewFile,BufWritePost *
      \ if expand('<amatch>') =~ '\v^/.*/(source|work/.*)/client[^/]*/.*$' | 
      \     setl textwidth=80 colorcolumn=121 |
      \ elseif expand('<amatch>') =~ '\v^/.*/(source|work/.*)/(server|go-server|configs)/.*$' |
      \     setl textwidth=80 colorcolumn=101 |
      \ endif
    " Prefer not to aggressively line-wrap some file types
    au FileType vim setl colorcolumn=
endif

" force * and # to always be case-sensitive
function! <SID>Star(cmd, count, was_visualmode) abort
    if a:was_visualmode
        normal! gv
    endif
    let save_view = winsaveview()
    let save_ic = &ignorecase
    let save_search = @/
    let &ignorecase = 0
    try
        let @/ = ""
        try
            try
                silent execute 'normal! ' . (a:count ? a:count : '') . a:cmd
            catch /\v^Vim\(normal\):(E384|E385):/
                " E384: search hit TOP without match
                " E385: search hit BOTTOM without match
                let searchforward = v:searchforward
                let @/ = '\C' . @/
                call histdel('search', -1)
                call histdel('search', @/)
                call winrestview(save_view)
                silent execute 'normal! ' . (a:count ? a:count : '') .  (searchforward ? '/' : '?') . "\n"
            endtry
        catch /\v^Vim\(normal\):(E348|E384|E385):/
            " E348: No string under cursor
            " E384: search hit TOP without match
            " E385: search hit BOTTOM without match
            let v:errmsg = substitute(v:exception, '\v^Vim\(normal\):', '', '')
        endtry
    finally
        if @/ == ""
            let @/ = save_search
        else
            let @/ = @/     " fixes hlsearch
        endif
        let &ignorecase = save_ic
    endtry
endfunction

noremap  <silent> * :<C-U>let v:errmsg = "" \| call <SID>Star('*', v:count, 0) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
vnoremap <silent> * :<C-U>let v:errmsg = "" \| call <SID>Star('*', v:count, 1) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
noremap  <silent> # :<C-U>let v:errmsg = "" \| call <SID>Star('#', v:count, 0) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
vnoremap <silent> # :<C-U>let v:errmsg = "" \| call <SID>Star('#', v:count, 1) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
noremap  <silent> g* :<C-U>let v:errmsg = "" \| call <SID>Star('g*', v:count, 0) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
vnoremap <silent> g* :<C-U>let v:errmsg = "" \| call <SID>Star('g*', v:count, 1) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
noremap  <silent> g# :<C-U>let v:errmsg = "" \| call <SID>Star('g#', v:count, 0) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>
vnoremap <silent> g# :<C-U>let v:errmsg = "" \| call <SID>Star('g#', v:count, 1) \| if v:errmsg != "" \| echoerr v:errmsg \| endif<cr>

function! <SID>SelectParagraph(visual, exclusive)
    " Fall back to regular definition, if we're not in a comment
    if ! search('\v^\s*#', 'bcW', line("."))
        if a:visual
            normal! gv
        endif
        if a:exclusive
            normal! ip
        else
            normal! ap
        endif
        return
    endif

    call s:MoveToStartOfCommentBlock()
    normal! v
    call s:MoveToEndOfCommentBlock(a:exclusive)
endfunction

function! s:MoveToStartOfCommentBlock()
    call search('\v^\s*([^#]|$)', 'bW')
    normal! j
endfunction

function! s:MoveToEndOfCommentBlock(exclusive)
    call search('\v^\s*([^#]|$)', 'W')
    if a:exclusive
        normal! k$h
    else
        normal! k$
    endif
endfunction

" Attempt to redefine paragraphs to be meaningful in code
"omap ap :call <SID>SelectParagraph(0, 0)<cr>
"vmap ap <Esc>:call <SID>SelectParagraph(1, 0)<cr>

"omap ip :call <SID>SelectParagraph(0, 1)<cr>
"vmap ip <Esc>:call <SID>SelectParagraph(1, 1)<cr>


" ag.vim is deprecated; we can just use ack.vim
"" BEGIN copied from https://github.com/rking/ag.vim/issues/124#issuecomment-227038003
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
"" END copied from https://github.com/rking/ag.vim/issues/124#issuecomment-227038003

" ack.vim configuration
unlet! g:ackprg
if executable('ag')
    " thesilversearcher; like ack but faster.
    let g:ackprg = 'ag'
    let g:ack_default_options = '--vimgrep --silent'
elseif executable('ack-grep') || executable('ack')
    " ack.vim will find ack-grep or ack on its own in the PATH, so we do
    " nothing in this case.
elseif version < 800 && has('unix')
    let g:ackprg = shellescape(globpath(&rtp, 'bin/ack-2.24-single-file'))
elseif version < 800 && has('win32')
    if executable('C:\Progra~1\Git\usr\bin\perl.exe')
        let s:perl_exe = 'C:\Progra~1\Git\usr\bin\perl.exe'
    elseif executable('C:\Progra~2\Git\usr\bin\perl.exe')
        let s:perl_exe = 'C:\Progra~2\Git\usr\bin\perl.exe'
    else
    endif
    if !empty(s:perl_exe)
        let g:ackprg = printf('"%s" "%s"', s:perl_exe, globpath(&rtp, 'bin/ack-2.24-single-file'))
    endif
else
    " Use bundled ack script, if possible.  It's a perl script.
    let s:bundled_ack = globpath(&rtp, 'bin/ack-2.24-single-file', 0, 1)[0]
    if has('unix')      " this includes win32unix (cygwin/mingw)
        " Unix probably has perl.  It's likely enough that I'm not going to
        " waste time searching the filesystem at vim startup.
        let g:ackprg = shellescape(s:bundled_ack)
    elseif has('win32')     " *deep sigh*
        " Windows won't respect the #! and doesn't usually come with perl
        " installed, but it can be installed with various things, so let's
        " try.
        let s:perl_exe = exepath('perl')
        if empty(s:perl_exe)
            " Git for Windows
            let s:git_exe = exepath('git')  " Probably something like 'C:\Program Files\Git\cmd\git.EXE'
            if !empty(s:git_exe)
                let s:git_install_path = substitute(s:git_exe, '\v\c\\cmd\\git(\.EXE)?$', '', '')   " 'C:\Program Files\Git'
                let s:perl_exe = exepath(s:git_install_path . '\usr\bin\perl')       " 'C:\Program Files\Git\usr\bin\perl.EXE'
            endif
        endif
        if !empty(s:perl_exe)
            " Found perl!
            let g:ackprg = shellescape(s:perl_exe) . ' ' . shellescape(s:bundled_ack)
        endif
    endif
endif

" VimOrganizer - a lot of this is copied from bundle/hsitz-VimOrganizer-*/_vimrc
"au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
"au BufEnter *.org            call org#SetOrgFileType()
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
else
    let g:me = system("whoami")
endif

" I sometimes use a different username
if g:me == "dwon"
    let g:me = "dlitz"
endif

" Insert-mode autocompletion
inoremap @#$% <c-\><c-o>$<tab><c-r>=printf(&commentstring, printf(" DEBUG FIXME(%s) ", g:me))<cr><space><space>
map      @#$% $a@#$%<esc>
inoremap !@#$ <c-\><c-o>$<tab><c-r>=printf(&commentstring, printf(" TODO(%s)", g:me))<cr>
map      !@#$ $a!@#$<esc>

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

" <Leader>K -- search the source code for the word under the cursor
noremap <silent> <Leader>K :<C-U>Ack<cr>

" <Leader>i -- toggle ignorecase
noremap <silent> <Leader>i :setlocal ignorecase!<cr>:setlocal ignorecase?<cr>

" <Leader>l -- toggle list
noremap <silent> <Leader>l :setlocal list!<cr>:setlocal list?<cr>

" <Leader>p -- toggle paste
noremap <silent> <Leader>p :setlocal paste!<cr>:setlocal paste?<cr>

" <Leader>t -- toggle expandtab
noremap <silent> <Leader>t :setlocal expandtab!<cr>:setlocal expandtab?<cr>

" <Leader>n -- toggle numbers
noremap <silent> <Leader>n :setlocal number!<cr>:setlocal number?<cr>

" <Leader>w -- toggle wrap
noremap <silent> <Leader>w :setlocal wrap!<cr>:setlocal wrap?<cr>

" <Leader>/ -- clear the search pattern
noremap <Leader>/ :let @/ = ""<cr>

" Custom status line
let &g:statusline = '%<%f %h%m%r%=' .
    \   '%{&paste ? "paste " : ""}' .
    \   '%{&et ? "spaces" : "tabs"} ' .
    \   '%{&sts == 0 ? "nosts " : &sts > 0 && &sts != &sw ? "sts:".&sts." " : ""}' .
    \   '%{&sw && &sw != &ts ? "sw:".&sw." " : ""}' .
    \   'ts:%{&ts} ' .
    \   'tw:%{&tw} ' .
    \   ' %-14.(%l,%c%V%) %P'

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

"" BEGIN copied and modified from https://github.com/vivien/vim-linux-coding-style/blob/7da66c1b34dc2976a70c9393c7e0c9f47e129e89/plugin/linuxsty.vim
function! LinuxFormatting()
    setlocal tabstop=8
    setlocal shiftwidth=0
    setlocal softtabstop=-1
    setlocal textwidth=80
    setlocal noexpandtab

    setlocal cindent
    setlocal cinoptions=:0,l1,t0,g0,(0
endfunction
function! LinuxKeywords()
    syn keyword cOperator likely unlikely
    syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
    syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64
endfunction
"" END copied and modified from https://github.com/vivien/vim-linux-coding-style/blob/7da66c1b34dc2976a70c9393c7e0c9f47e129e89/plugin/linuxsty.vim
function! LinuxCodingStyle()
    call LinuxFormatting()
    if &filetype =~ '\v^(asm|c|cpp|diff)$'
        call LinuxKeywords()
    endif
endfunction
function! MaybeLinuxCodingStyle()
    "let amatch = expand('<amatch>')
    let path = expand('<afile>:p')
    if path =~ '\v/linux|/kernel'
        call LinuxCodingStyle()
    endif
endfunction
augroup linuxcodingstyle
    autocmd!
    autocmd BufNewFile,BufRead * call MaybeLinuxCodingStyle()
    autocmd FileType c,cpp call MaybeLinuxCodingStyle()
    autocmd FileType kconfig,gitconfig call LinuxCodingStyle()
augroup END
