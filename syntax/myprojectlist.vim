" Vim syntax file
" Language:	my projects.list file
" Maintainer:	Dwayne Litzenberger <dlitz@dlitz.net>

" group names are: Comment Constant Identifier Statement PreProc Type
" Delimiter
syn clear

" The selection of meanings comes entirely from the colour scheme I use.
" Don't try to make any sense of it.
syn match Error "^.*$"
syn match Special "^[^:]*:%:.*$"
syn match Comment "^[^:]*:\*:.*$"
syn match Comment "^[^:]*:/:.*$"
syn match Comment "^[^:]*:x:.*$"
syn match Constant "^[^:]*:=:.*$"
syn match Constant "^[^:]*:-:.*$"
syn match PreProc "^[^:]*:+:.*$"
syn match NONE "^[^:]*: :.*$"

" comments
syn match Comment "^#.*$"
