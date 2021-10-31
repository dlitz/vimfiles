" Statusline helpers
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
" Usage:
"   statusline#foldlevel([outerPrefix, [innerPrefix, [innerSuffix, [outerSuffix]]]])
" Examples:
"   let &g:statusline ..= '%{% statusline#foldlevel#foldlevel() %}'
"   let &g:statusline ..= '%{% statusline#foldlevel#foldlevel("", "fold:") %}'
"   let &g:statusline ..= '%{% statusline#foldlevel#foldlevel(" ", "fold[", "]", " ") %}'
function statusline#foldlevel#foldlevel(...) abort
  let outerPrefix = get(a:, 1, '')
  let innerPrefix = get(a:, 2, '')
  let innerSuffix = get(a:, 3, '')
  let outerSuffix = get(a:, 4, '')
  if !g:statusline_foldlevel_enable
    return ""
  else
    let lvl = foldlevel(".")

    if g:statusline_foldlevel_syntax_enable
      if g:actual_curwin == win_getid()
        let hlNamePrefix = "statuslineFoldLevel"
      else
        let hlNamePrefix = "statuslineFoldLevelNC"
      endif
      let hlName = hlNamePrefix .. lvl
      if !hlexists(hlName)
        let hlName = hlNamePrefix
      endif
      let syntaxStart = "%#" .. hlName .. "#"
      let syntaxEnd = "%*"
    else
      let syntaxStart = ""
      let syntaxEnd = ""
    endif

    return outerPrefix .. syntaxStart .. innerPrefix .. lvl .. innerSuffix .. syntaxEnd .. outerSuffix
  endif
endf

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
endif

" Command to show/hide foldlevel
function statusline#foldlevel#Show()
  let g:statusline_foldlevel_enable = 1
endf
function statusline#foldlevel#Hide()
  let g:statusline_foldlevel_enable = 0
endf
if g:statusline_foldlevel_cmdname_show != ""
  execute "command " .. g:statusline_foldlevel_cmdname_show .. " call statusline#foldlevel#Show()"
endif
if g:statusline_foldlevel_cmdname_hide != ""
  execute "command " .. g:statusline_foldlevel_cmdname_hide .. " call statusline#foldlevel#Hide()"
endif

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
