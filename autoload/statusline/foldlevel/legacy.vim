" statusline-foldlevel compatibility code
" Not needed after patch-8.2.2854
" dlitz 2021
scriptversion 4

let s:SID = expand('<SID>')

" This is just to ensure that the statusline#foldlevel globals get loaded
call statusline#foldlevel#NoOp()

" Returns a snippet of code that can be added to statusline
" Arguments may be funcrefs.
" Usage:
"   statusline#foldlevel#legacy#snippet([outerPrefix, [innerPrefix, [innerSuffix, [outerSuffix]]]])
" Examples:
"   let s:showLevelFunc = { -> 'fold(' .. &foldmethod .. ')' }
"   let &g:statusline ..= statusline#snippet()
"   let &g:statusline ..= statusline#snippet('', 'fold:')
"   let &g:statusline ..= statusline#snippet(' ', 'fold[', ']', ' ')
"   let &g:statusline ..= statusline#snippet(' ', s:showLevelFunc)
function statusline#foldlevel#legacy#snippet(...) abort
  let outerPrefixExpr = s:string_expr(get(a:, 1, ''))
  let innerPrefixExpr = s:string_expr(get(a:, 2, ''))
  let innerSuffixExpr = s:string_expr(get(a:, 3, ''))
  let outerSuffixExpr = s:string_expr(get(a:, 4, ''))

  let result = ''
    \ .. '%{' .. s:SID .. 'evalCase(0,0,' .. string(outerPrefixExpr) .. ')}'

  for [active, maxlevel] in [[v:false, g:statusline_foldlevel_max_level_nc],
                           \ [v:true, g:statusline_foldlevel_max_level]]
    for lvl in range(-2, maxlevel)
      if lvl == -2 && active == v:false
        " The no-highlighting case
        let mode = 1
      elseif lvl == -2
        " The no-highlighting case only needs to be handled once
        continue
      else
        let mode = active ? 3 : 2
        let result ..= '%#' .. statusline#foldlevel#hlName(!active, lvl) .. '#'
      endif
      let result ..= ''
        \ .. '%{' .. s:SID .. 'evalCase('
          \ .. string(mode) .. ','
          \ .. string(lvl) .. ','
          \ .. string(s:SID .. 'foldlevel_inner('
            \ .. innerPrefixExpr .. ','
            \ .. innerSuffixExpr
          \ .. ')')
        \ .. ')}'
    endfor
  endfor

  let result ..= '%*'
    \ .. '%{' .. s:SID .. 'evalCase(0,0,' .. string(outerSuffixExpr) .. ')}'

  return result
endfunction

function s:evalCase(mode, wantlvl, expr) abort
  if !g:statusline_foldlevel_enable
    return ''
  endif
  let cur_isActiveWindow = g:actual_curwin == win_getid()
  let cur_lvl = foldlevel('.')
  if a:mode == 0
    " outerPrefix, outerSuffix
    let result = v:true
  elseif a:mode == 1 && !g:statusline_foldlevel_syntax_enable
    " inner, no-highlighting case
    let result = v:true
  elseif (a:mode == 2 || a:mode == 3) && g:statusline_foldlevel_syntax_enable
    " inner, with highlighting
    if a:mode == 2
      " inactive window
      let maxlevel = g:statusline_foldlevel_max_level_nc
      let wantactive = v:false
    else
      " active window
      let maxlevel = g:statusline_foldlevel_max_level
      let wantactive = v:true
    endif
    let level_match = a:wantlvl == cur_lvl || (a:wantlvl == -1 && cur_lvl > maxlevel)
    let window_match = cur_isActiveWindow == wantactive
    let result = level_match && window_match
  elseif a:mode == 3 && g:statusline_foldlevel_syntax_enable && cur_isActiveWindow
    " inner, with highlighting, active window
    let maxlevel = g:statusline_foldlevel_max_level
    if a:lvl == cur_lvl || (a:lvl == -1 && cur_lvl > maxlevel)
      let result = v:true
    else
      let result = v:false
    endif
  else
    let result = v:false
  endif
  if result
    return eval(a:expr)
  else
    return ''
  endif
endfunction

function s:foldlevel_inner(innerPrefix, innerSuffix) abort
  return a:innerPrefix .. foldlevel(".") .. a:innerSuffix
endfunction

" Like string(), but converts a funcref to code that will invoke it
function s:string_expr(value) abort
  if type(a:value) == v:t_func
    return 'call(' .. string(get(a:value, 'name')) .. ', [])'
  else
    return string(a:value)
  endif
endfunction

" vim:set sw=2 expandtab:
