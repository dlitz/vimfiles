au BufRead,BufNewFile *.pru       set filetype=pru
au BufRead,BufNewFile *.hpru      set filetype=pru
" The assembler itself is called 'pasm', so this file extension reflects that
au BufRead,BufNewFile *.pasm      set filetype=pru
" These file extensions are listed on TI's wiki-page for PASM syntax
" highlighting. Uncomment the following lines to treat these extensions
" as PRUSS extensions.
" au BufRead,BufNewFile *.p         set filetype=pru
" au BufRead,BufNewFile *.hp        set filetype=pru
" au BufRead,BufNewFile *.pdsp      set filetype=pru
