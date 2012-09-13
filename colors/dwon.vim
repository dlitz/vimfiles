" Vim color file
" by Dwayne Litzenberger
" Based loosely on Tillman's .vimrc (2000-03-05)

set background=dark
hi clear

hi Comment     ctermfg=DarkYellow   guifg=DarkYellow
hi Constant    ctermfg=DarkCyan     guifg=DarkCyan                                          term=underline
hi Delimiter   ctermfg=Red          guifg=Red                                               cterm=bold gui=bold term=bold
hi Directory   ctermfg=Blue         guifg=Blue                                              cterm=bold gui=bold term=bold
hi Error       ctermfg=Red          guifg=#FF7777       ctermbg=DarkRed guibg=#DD0000       cterm=bold gui=bold term=standout
hi ErrorMsg    ctermfg=Red          guifg=Red           ctermbg=NONE    guibg=NONE          cterm=bold gui=bold term=standout
hi Folded      ctermfg=DarkGrey     guifg=#808080                       guibg=#101020       cterm=bold gui=bold term=standout
hi Identifier  ctermfg=Cyan         guifg=Cyan                                              cterm=bold gui=bold term=underline
hi LineNr      ctermfg=DarkYellow   guifg=DarkYellow                                        cterm=bold gui=bold term=underline
hi ModeMsg     ctermfg=Yellow       guifg=Yellow        ctermbg=Red     guibg=Red           cterm=bold term=bold
hi MoreMsg     ctermfg=Green        guifg=Green                                             cterm=bold gui=bold term=bold
hi NonText     ctermfg=DarkGreen    guifg=green3                                                                term=bold
hi Normal      ctermfg=LightGrey    guifg=grey90        ctermbg=Black   guibg=#000020
hi PreProc     ctermfg=DarkGreen    guifg=Green
hi Question    ctermfg=Green        guifg=Green                                             cterm=bold gui=bold term=standout
hi Search      ctermbg=Yellow       guibg=Yellow                                                                term=reverse
hi Special     ctermfg=DarkMagenta  guifg=DarkMagenta                                       term=bold
hi SpecialKey  ctermfg=DarkBlue     guifg=Blue                                                                  term=bold
hi SpellBad    ctermfg=NONE         guifg=NONE          ctermbg=NONE    guibg=NONE          cterm=undercurl gui=undercurl term=undercurl
hi Statement   ctermfg=DarkGreen    guifg=Green                                             cterm=NONE gui=NONE term=bold
hi StatusLine  ctermfg=Yellow       guifg=Yellow        ctermbg=Blue    guibg=DarkBlue      cterm=bold gui=bold term=reverse
hi StatusLineNC ctermfg=Black       guifg=grey20        ctermbg=Yellow  guibg=DarkYellow    cterm=bold gui=bold term=bold
hi Title       ctermfg=Blue         guifg=Blue                                              cterm=bold gui=bold term=bold
hi Todo        ctermfg=Red          guifg=Red           ctermbg=Yellow  guibg=Yellow        cterm=bold gui=bold term=bold
hi Type        ctermfg=Yellow       guifg=Yellow                                            cterm=bold gui=bold term=underline
hi Visual      ctermfg=DarkCyan     guifg=Cyan          ctermbg=DarkMagenta guibg=DarkMagenta cterm=bold        term=reverse
"hi Visual      ctermfg=Yellow       guifg=Yellow        ctermbg=Blue    guibg=Blue          cterm=bold          term=reverse
hi WarningMsg  ctermfg=Red          guifg=Red           ctermbg=Blue    guibg=Blue          cterm=bold gui=bold term=standout
