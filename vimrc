source ~/.vim/tman.vim

autocmd BufNewFile,BufRead *.as setf actionscript 
autocmd BufNewFile,BufRead *.as setf actionscript 
autocmd BufNewFile,BufRead *.dxhtml setf xhtml
autocmd BufNewFile,BufRead *.gcov set ft=gcov
autocmd BufNewFile,BufRead *.pspi setf spyce
autocmd BufNewFile,BufRead *.psp setf spyce
autocmd BufNewFile,BufRead *.pspt setf spyce
autocmd BufNewFile,BufRead *.spy setf spyce
autocmd BufNewFile,BufRead *.S set ft=asmarm
autocmd BufNewFile,BufRead *.myt set ft=myghty
autocmd BufNewFile,BufRead *.mako set ft=mako
autocmd BufNewFile,BufRead *.i set ft=swig

autocmd FileType html,xml,xsl,xsd,xslt,dxhtml,xhtml,dtml,php,spyce,eruby,wml,myghty,mako source ~/.vim/closetag.vim

autocmd FileType python,spyce,php set ts=8 sw=4 sts=4 expandtab textwidth=0
autocmd FileType html,myt,mako set ts=8 sw=2 sts=2 expandtab textwidth=0
autocmd FileType ruby,verilog,haskell set ts=8 sw=2 sts=2 expandtab

"autocmd FileType tex source ~/.vim/tex.vim
autocmd FileType tex set ts=8 sw=2 sts=2 expandtab

autocmd BufNewFile,BufRead .letter,mutt*,nn.*,snd.* set formatoptions=wantql

"imap <F7> <ESC>:make<CR>i
"map <F7> :make<CR>

"imap <F6> <ESC>:make clean<CR>i
"map <F6> :make clean<CR>

nnoremap \tp :set invpaste paste?<CR>
nmap <F5> \tp
imap <F5> <C-O>\tp
set pastetoggle=<F5>

"nnoremap \tl :set invlist list?<CR>
"nmap <F6> \tl
nmap <F6> :NERDTreeToggle<CR>

nnoremap \th :set invhls hls?<CR>
nmap <F7> \th

"imap <F4> <ESC>:cn<CR>i
"map <F4> :cn<CR>

set modeline
set modelines=3
set mouse=a
set autoindent
set showmatch
set undolevels=10000

imap <C-t>bi \begin{itemize}<CR><CR><CR><CR>\end{itemize}<CR><c-o>3k<tab>\item 
imap <C-t>bn \begin{enumerate}<CR><CR><CR><CR>\end{enumerate}<CR><c-o>3k<tab>\item 

imap <F8> <c-o>$ # DEBUG FIXME

" Used for StillWeb.TeXPlugin
imap <F9> <lt>p:m>

set printoptions=paper:letter
set ts=8 sw=4 sts=4 expandtab

set title
set sh=/bin/bash

" Highlight trailing whitespace
highlight WhitespaceEOL ctermbg=red guibg=red
autocmd BufWinEnter,WinEnter * match WhitespaceEOL /\s\+$/

" When "set list" is set, show tabs and EOL explicitly
set listchars=eol:$,tab:>-
