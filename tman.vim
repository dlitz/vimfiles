" Dwayne's .vimrc
" based on:
" Tillman's .vimrc
" Version date: Mar 05/2000

" Set up the stuff for color highlighing in an xterm (or konsole, or compatible)
" Without this, VIM is in ugly greyscale with underline and bold!
"if has("terminfo")
"	set t_Co=16
"	set t_Sf=[3%p1%dm
"	set t_Sb=[4%p1%dm
"	set t_vb=
"else
"	set t_Co=16
"	set t_Sf=[3%dm
"	set t_Sb=[4%dm
"	set t_vb=
"endif

syntax on
set noinsertmode
set backspace=2
set tabstop=8
set ruler
set mouse=
set showcmd
set laststatus=2
let java_highlight_functions=1
set esckeys
set textwidth=78
set keywordprg=man

""" EMAIL
" Make VIM use shorter lines for emails
au BufNewFile,BufRead .letter,mutt*,nn.*,snd.* set tw=75
" Delete quoted .sig's
au BufRead /tmp/mutt-* normal :g/^> --.*/,/^$/-1d

" Fix the delete key problem
"map ^[[3~ <Del>
"inoremap ^[[3~ <Del>

" Word forward and back with F11 and F12
"imap <F12> <ESC>lwi
"imap <F11> <ESC>lbi
"map <F12> lw
"map <F11> hb

""" Setup my F10 macros:
" Edit my .vimrc file
"map <F10>v :e ~/.vimrc
" Update the system settings from my vimrc file
"map <F10>u :source ~/.vimrc
" Set up commenting
"map <F10># 0i#<SPACE><ESC>
"imap <F10># <ESC>mT0i#<SPACE><ESC>`Tlli
" My email address
"imap <F10>@ dlitz@cheerful.com
" Some common HTML stuff
"imap <F10>c &copy;
"imap <F10>& &amp;
"imap <F10>" &quote;
"imap <F10>< &lt;
"imap <F10>> &gt;
" Some common C stuff
"imap <F10>Cs /*******************************************************************************<CR>
"imap <F10>Ce *******************************************************************************/<CR>
" Stick paragraph tags on a block of text
"map  <F10>p {j:s/^/<P>/}k:s#$#</P>#gqip}j
"imap <F10>p <ESC>{j:s/^/<P>/}k:s#$#</P>#gqip}ji

" Set up some movement keys from within Insert mode
inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <C-B> <ESC><C-B>i
inoremap <C-F> <ESC><C-F>i

" Pico-like paragraph justification (also try gqap to collapse trailing lines)
"imap <C-J> <c-o>gqip
"map <C-J> gqip

" Make it so that I can see my own maps using the BASH alias command
"map :alias :map

""" Some Misc. one-time-only or experimental stuff (usually commented out)
"nmap <F10>s :w ! grep -v '^>' \| ispell -l \| more<CR>
"imap <F10>^ ywmno^[P:s/./\~/g^M0"nDdd`n@n

" all of this stuff allows me to write gzipped files natively...cool eh?
" [It's been done in /etc/vimrc -DL- ]
"autocmd BufRead *.gz set bin|%!gunzip
"autocmd BufRead *.gz set nobin
"autocmd BufWritePre *.gz %!gzip
"autocmd BufWritePre *.gz set bin
"autocmd BufWritePost *.gz undo|set nobin
"autocmd FileReadPost *.gz set bin|'[,']!gunzip
"autocmd FileReadPost set nobin

" this clears out the old colors before we begin
highlight Constant    NONE
highlight Delimiter   NONE
highlight Directory   NONE
highlight Error       NONE
highlight ErrorMsg    NONE
highlight Identifier  NONE
highlight LineNr      NONE
highlight ModeMsg     NONE
highlight MoreMsg     NONE
highlight Normal      NONE
highlight NonText     NONE
highlight PreProc     NONE
highlight Question    NONE
highlight Search      NONE
highlight Special     NONE
highlight SpecialKey  NONE
highlight Statement   NONE
highlight StatusLine  NONE
highlight Title       NONE
highlight Todo        NONE
highlight Type        NONE
highlight Visual      NONE
highlight WarningMsg  NONE
" these are the new superior colors
highlight Comment     ctermfg=3 ctermbg=0 guifg=#FF005F guibg=gray
highlight Constant    term=underline ctermfg=6 guifg=#FF2f8f
highlight Delimiter   term=bold cterm=bold ctermfg=1 gui=bold guifg=Red
highlight Directory   term=bold ctermfg=DarkBlue guifg=Blue
highlight Error       term=standout cterm=bold ctermbg=1 ctermfg=1 gui=bold guifg=red
highlight ErrorMsg    term=standout cterm=bold ctermfg=1 gui=bold guifg=red
highlight Identifier  term=underline cterm=bold ctermfg=6 guifg=yellow3
highlight LineNr      term=underline cterm=bold ctermfg=3 guifg=Brown
highlight ModeMsg     term=bold cterm=bold ctermfg=3 ctermbg=1 guifg=yellow2 guibg=red
highlight MoreMsg     term=bold cterm=bold ctermfg=2 gui=bold guifg=Green
highlight NonText     term=bold ctermfg=2 guifg=green3
highlight Normal      ctermfg=7 guifg=grey90 guibg=#000020
highlight PreProc     ctermfg=2 ctermbg=0 guifg=cyan
highlight Question    term=standout cterm=bold ctermfg=2 gui=bold guifg=Green
highlight Search      term=reverse ctermbg=2 guibg=Yellow
highlight Special     term=bold ctermfg=5 guifg=SlateBlue
highlight SpecialKey  term=bold ctermfg=DarkBlue guifg=Blue
highlight Statement   term=bold ctermfg=2 gui=bold guifg=green3
highlight StatusLine  term=reverse cterm=bold ctermfg=3 ctermbg=4 guifg=wheat guibg=#2f4f4f
highlight StatusLineNC term=bold cterm=bold ctermfg=0 ctermbg=3 guifg=#071f1f guibg=#5f9f9f
highlight Title       term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
highlight Todo        term=bold ctermfg=red ctermbg=yellow guifg=red guibg=yellow1 gui=bold
highlight Type        term=underline cterm=bold ctermfg=3 guifg=yellow3 gui=bold
highlight Visual      term=reverse cterm=bold ctermfg=6 ctermbg=5 guifg=yellow guibg=blue
highlight WarningMsg  term=standout cterm=bold ctermfg=1 ctermbg=4 guifg=Red

