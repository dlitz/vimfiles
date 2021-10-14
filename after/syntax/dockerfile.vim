" dlitz 2021
" Enhance FROM ... AS ...
syntax region dockerfileFrom matchgroup=dockerfileFromKeyword start=/\v^\s*(FROM)\ze(\s|$)/ skip=/\v\\\_./ end=/\v$/ contains=dockerfileOption,dockerfileAs
syntax region dockerfileAs contained matchgroup=dockerfileAsKeyword start=/\v<(AS)>\ze(\s|$)/ skip=/\v\\\_./ end=/\v\ze(\s|$)/

hi def link dockerfileFromKeyword dockerfileKeyword
hi def link dockerfileAsKeyword   dockerfileKeyword
hi def link dockerfileFrom        Identifier

" Regions defined purely for foldmethod=syntax
syn region dockerfileFromFold start=/\v\c^FROM>/ skip=/\v\\\_./ end=/\v\c\ze(\_^#.*\n|\_^\n)*\_^FROM>/ fold transparent keepend
syn region dockerfileRunFold start="\v\c^RUN>" skip=/\v\\\_./ end="\v\n" fold transparent keepend

setlocal foldmethod=syntax
