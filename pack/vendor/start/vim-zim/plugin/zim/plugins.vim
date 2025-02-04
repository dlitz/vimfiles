"let g:zim_python_path=substitute(system("find /usr/lib/python* -name 'zim' -type d"),
"      \"\n.*",'','')
" 2025-02-03 dlitz - hard-code path to speed up startup, and because it shouldn't really change anymore.
let g:zim_python_path="/usr/lib/python3/dist-packages/zim"

command! ZimArithmetic call zim#plugins#arithmetic#processfile()
