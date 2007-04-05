source $VIMRUNTIME/syntax/asm68k.vim
syn match asm68kComment "|.*" contains=asm68kTodo
syn keyword asm68kTodo contained FIXME
