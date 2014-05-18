" vim:tabstop=2:shiftwidth=2:expandtab:foldmethod=marker:textwidth=79
" Zimwiki ftdetect plugin
" Last Change: 2014 May 18
" Maintainer: Dwayne Litzenberger <dlitz@dlitz.net>
" License:  This file is placed in the public domain.
"           https://creativecommons.org/publicdomain/zero/1.0/
augroup filetypedetect
  au! BufRead,BufNewFile *.txt if getline(1) =~ '^\cContent-Type: text/x-zim-wiki\>' | setfiletype zim | endif
augroup end
