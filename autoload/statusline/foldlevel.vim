" foldlevel statusline helpers
" dlitz 2021
scriptversion 4

" Configuration: Whether to show the foldlevel when requested
if !exists("g:statusline_foldlevel_enable")
  let g:statusline_foldlevel_enable = 1
endif

" Configuration: Whether to output syntax-highlighting info
if !exists("g:statusline_foldlevel_syntax_enable")
  let g:statusline_foldlevel_syntax_enable = 1
endif

" Configuration: Whether to set default syntax-highlighting colors
if !exists("g:statusline_foldlevel_default_colors")
  let g:statusline_foldlevel_default_colors = 1
endif

if !exists("g:statusline_foldlevel_cmdname_show")
  let g:statusline_foldlevel_cmdname_show = "ShowFoldLevel"
endif

if !exists("g:statusline_foldlevel_cmdname_hide")
  let g:statusline_foldlevel_cmdname_hide = "HideFoldLevel"
endif

" Returns the current fold level (syntax highlighted by default)
" Arguments may be funcrefs.
" Usage:
"   statusline#foldlevel#foldlevel([outerPrefix, [innerPrefix, [innerSuffix, [outerSuffix]]]])
" Examples:
"   let F = { -> 'fold(' .. &foldmethod .. ')' }
"   if has('patch-8.2.2854')  " If support for re-evaluating the function output is available
"     let &g:statusline ..= '%{% statusline#foldlevel#foldlevel() %}'
"     let &g:statusline ..= '%{% statusline#foldlevel#foldlevel("", "fold:") %}'
"     let &g:statusline ..= '%{% statusline#foldlevel#foldlevel(" ", "fold[", "]", " ") %}'
"     let &g:statusline ..= '%{% statusline#foldlevel#foldlevel(" ", F) %}'
"   else
"     let &g:statusline ..= statusline#foldlevel#legacy#snippet()
"     let &g:statusline ..= statusline#foldlevel#legacy#snippet('', 'fold:')
"     let &g:statusline ..= statusline#foldlevel#legacy#snippet(' ', 'fold[', ']', ' ')
"     let &g:statusline ..= statusline#foldlevel#legacy#snippet(' ', F)
"   endif
"
"   let &g:statusline ..=
"     \ (has('patch-8.2.2854')
"     \  ? '%{% statusline#foldlevel#foldlevel(" ", F) %}'
"     \  : statusline#foldlevel#legacy#snippet(' ', F))
function statusline#foldlevel#foldlevel(...) abort
  if !g:statusline_foldlevel_enable
    return ""
  endif

  " arguments that are Funcrefs will be evaluated here
  let GetArg = { arg -> type(arg) == v:t_func ? call(get(arg, 'name'), []) : arg }
  let outerPrefix = a:0 >= 1 ? GetArg(a:1) : ''
  let innerPrefix = a:0 >= 2 ? GetArg(a:2) : ''
  let innerSuffix = a:0 >= 3 ? GetArg(a:3) : ''
  let outerSuffix = a:0 >= 4 ? GetArg(a:4) : ''

  let lvl = foldlevel(".")
  let isActiveWindow = g:actual_curwin == win_getid()

  if g:statusline_foldlevel_syntax_enable
    let syntaxStart = "%#" .. statusline#foldlevel#hlName(!isActiveWindow, lvl) .. "#"
    let syntaxEnd = "%*"
  else
    let syntaxStart = ""
    let syntaxEnd = ""
  endif

  return outerPrefix .. syntaxStart .. innerPrefix .. lvl .. innerSuffix .. syntaxEnd .. outerSuffix
endf

function statusline#foldlevel#hlName(nc, lvl) abort
  if a:nc
    let hlNamePrefix = "statuslineFoldLevelNC"
  else
    let hlNamePrefix = "statuslineFoldLevel"
  endif
  if a:lvl == -1
    return hlNamePrefix
  else
    let hlName = hlNamePrefix .. a:lvl
    if !hlexists(hlName)
      let hlName = hlNamePrefix
    endif
    return hlName
  endif
endfunction

hi def link statuslineFoldLevel   StatusLine
hi def link statuslineFoldLevelNC StatusLineNC
if g:statusline_foldlevel_default_colors
  hi def statuslineFoldLevel0  ctermfg=7 ctermbg=0 guifg=White guibg=Black
  hi def statuslineFoldLevel1  ctermfg=7 ctermbg=1 guifg=White guibg=Red
  hi def statuslineFoldLevel2  ctermfg=0 ctermbg=2 guifg=Black guibg=Green
  hi def statuslineFoldLevel3  ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow
  hi def statuslineFoldLevel4  ctermfg=7 ctermbg=4 guifg=White guibg=Blue
  hi def statuslineFoldLevel5  ctermfg=7 ctermbg=5 guifg=White guibg=Magenta
  hi def statuslineFoldLevel6  ctermfg=0 ctermbg=6 guifg=Black guibg=Cyan
  hi def statuslineFoldLevel7  ctermfg=0 ctermbg=7 guifg=Black guibg=White

  if !exists("g:statusline_foldlevel_max_level")
    let g:statusline_foldlevel_max_level = 7
  endif
  if !exists("g:statusline_foldlevel_max_level_nc")
    let g:statusline_foldlevel_max_level_nc = -1
  endif
else
  " Configuration: The maximum level X where highlight statuslineFoldLevelX is defined
  if !exists("g:statusline_foldlevel_max_level")
    let g:statusline_foldlevel_max_level = -1
  endif

  " Configuration: The maximum level X where highlight statuslineFoldLevelNCX is defined
  if !exists("g:statusline_foldlevel_max_level_nc")
    let g:statusline_foldlevel_max_level_nc = -1
  endif
endif

" Command to show/hide foldlevel
function statusline#foldlevel#Show() abort
  let g:statusline_foldlevel_enable = 1
endf
function statusline#foldlevel#Hide() abort
  let g:statusline_foldlevel_enable = 0
endf
if g:statusline_foldlevel_cmdname_show != ""
  execute "command " .. g:statusline_foldlevel_cmdname_show .. " call statusline#foldlevel#Show()"
endif
if g:statusline_foldlevel_cmdname_hide != ""
  execute "command " .. g:statusline_foldlevel_cmdname_hide .. " call statusline#foldlevel#Hide()"
endif

function statusline#foldlevel#NoOp() abort
endfunction

" == Demo area ==
" Level 0
  " Level 1
    " Level 2
      " Level 3
        " Level 4
          " Level 5
            " Level 6
              " Level 7
                " Level 8
                  " Level 9
                    " Level 10
" == End demo area ==

" vim:set sw=2 expandtab foldmethod=indent:
