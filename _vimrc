" For win32
" Clone repo to %HOME%\vimfiles, then copy this file to %HOME%\_vimrc
let &rtp = substitute(&rtp, '\v^([^,]+)([\\/])\.vim,', '\1\2vimfiles,', '')
let &rtp = substitute(&rtp, '\v,([^,]+)([\\/])\.vim([\\/]after)$', ',\1\2vimfiles\3', '')
source ~/vimfiles/vimrc
