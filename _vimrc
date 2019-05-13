" For win32
" Clone repo to %HOME%\.vim, then copy this file to %HOME%\_vimrc so that vim
" looks there instead of in %HOME%\vimfiles
let &rtp = substitute(&rtp, '\v^([^,]+)([\\/])vimfiles,', '\1\2.vim,', '')
let &rtp = substitute(&rtp, '\v,([^,]+)([\\/])vimfiles([\\/]after)$', ',\1\2.vim\3', '')
source ~/.vim/vimrc
