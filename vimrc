colorscheme zellner
"colorscheme railscasts
"colorscheme sunburst


syntax on
set ruler
set showcmd
set showmatch
set backspace=2
set laststatus=2
set modeline
set modelines=3
set number
set listchars=eol:$,tab:>-
" http://items.sjbach.com/319/configuring-vim-right
set history=1000
set wildmode=list:longest
set scrolloff=3
set shortmess=atI
set visualbell
"set autowrite " Automatically save before commands like :next
set grepprg=ack

" http://github.com/hgimenez/vimfiles/blob/master/vimrc

""""""""""""""""""""""""""""""""
" Searching
"""""""""""""""""""""""""""""""""
set ignorecase        " search case insensitive
set smartcase         " search case sensitive when term has a capital letter
set hlsearch          " Highlight search terms...
set incsearch         " search dynamically as keyword is typed.


set tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent " Set two space tabs:
if has("autocmd")
  filetype indent on
endif

" Fix my seplling
set spell
if exists("+spelllang")
  set spelllang=en_ca
endif

set splitbelow                    " Split windows at bottom
set ttimeoutlen=50                " Speed up <esc>

"Rebuild tags with F5
map <silent> <F5>:!ctags -R --exclude=.svn --exclude=.git --exclude=log *<CR>


nnoremap <C-e> 3<C-e>             " faster scrolling up
nnoremap <C-y> 3<C-y>             " and down


autocmd FileType html,xml,xsl,php,jsp,eruby let b:closetag_html_style=1
autocmd FileType html,xml,xsl,php,jsp,eruby source ~/.vim/scripts/closetag.vim
autocmd BufRead,BufNewFile *.vm set filetype=velocity
autocmd BufRead,BufNewFile *.treetop set filetype=treetop
autocmd FileType hl7 source ~/.vim/scripts/hl7-status.vim

" Highlight trailing whitespace
autocmd FileType * highlight WhitespaceEOL ctermbg=red guibg=red
autocmd FileType * match WhitespaceEOL /\s\+$/

let mapleader = ","

inoremap <F13> <c-o>$<tab># DEBUG FIXME

map <F6> :NERDTreeToggle<cr>
map ` :NERDTreeToggle<cr>


" For fuzzy finder/textmate
" Requires fuzzyfinder and fuzzyfinder_textmate plugins
let g:fuzzy_ignore = "log/*, .svn/*, .git/*"
let g:fuzzy_matching_limit = 70
map <leader>t :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>r :ruby finder.rescan!<CR>


" https://wincent.com/blog/2-hours-with-vim
function! AckGrep(command)
  cexpr system("ack " . a:command)
  cw " show quickfix window already
endfunction

command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
map <leader>f :Ack<space>
" previous ack result
map <leader>[ :cp<CR>
" next ack result
map <leader>] :cn<CR>


" shortcut to open vim config
map ,v :sp $MYVIMRC<CR><C-W>_
" Shortcut to reload vim config
map <silent> ,V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>



" Printing options
set printoptions=duplex:long,paper:letter

function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction

map <leader>s :call ToggleScratch()<CR>

"""""""""""""""""""""""""""""""""
" line wrapping and movements
"""""""""""""""""""""""""""""""""
" toggle wrapping with <Leader>w (typically \w)
nnoremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    call UnwrapIt()
  else
    echo "Wrap ON"
    call WrapIt()
  endif
endfunction

function WrapIt()
  set wrap linebreak
  set virtualedit=
  set breakat=\ ^I!@*-+;:,./?       " when wrapping, break at these characters (requires linbreak, see above)
  set showbreak=>                   " character to show that a line is wrapped
  setlocal display+=lastline
  noremap  <buffer> <silent> k gk
  noremap  <buffer> <silent> j gj
  noremap  <buffer> <silent> <Up>   gk
  noremap  <buffer> <silent> <Down> gj
  noremap  <buffer> <silent> <Home> g<Home>
  noremap  <buffer> <silent> <End>  g<End>
  inoremap <buffer> <silent> <Up>   <C-o>gk
  inoremap <buffer> <silent> <Down> <C-o>gj
  inoremap <buffer> <silent> <Home> <C-o>g<Home>
  inoremap <buffer> <silent> <End>  <C-o>g<End>
endfunction

function UnwrapIt()
  set nowrap
  set virtualedit=all
  silent! nunmap <buffer> j
  silent! nunmap <buffer> k
  silent! nunmap <buffer> <Up>
  silent! nunmap <buffer> <Down>
  silent! nunmap <buffer> <Home>
  silent! nunmap <buffer> <End>
  silent! iunmap <buffer> <Up>
  silent! iunmap <buffer> <Down>
  silent! iunmap <buffer> <Home>
  silent! iunmap <buffer> <End>
endfunction

if &wrap
  call WrapIt()
endif

"""""""""""""""""""""""""""""""""
" Backup files
"""""""""""""""""""""""""""""""""

" Use a common directory for backups and swp files
" Create it if it doesn't exist
silent execute '!mkdir -p ~/.vim_backups'
set backupdir=~/.vim_backups//
set directory=~/.vim_backups//


"define :Lorem command to dump in a paragraph of lorem ipsum
command! -nargs=0 Lorem :normal iLorem ipsum dolor sit amet, consectetur
      \ adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore
      \ magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation
      \ ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
      \ irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
      \ fugiat nulla pariatur.  Excepteur sint occaecat cupidatat non
      \ proident, sunt in culpa qui officia deserunt mollit anim id est
      \ laborum

" Set the screen size to something a bit bigger
if has("gui_running")
  set lines=80 columns=130
endif
