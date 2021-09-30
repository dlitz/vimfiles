":" Run this file as "sh ~/.vim/vimrc" to set up the symlinks
"[" -e ~/.vimrc ] && mv -v -f ~/.vimrc ~/.vimrc~ || true
"[" -e ~/.gvimrc ] && mv -v -f ~/.gvimrc ~/.gvimrc~ || true
"ln" -v -s .vim/vimrc ~/.vimrc
"ln" -v -s .vim/vimrc ~/.gvimrc
"exit" 0

scriptencoding utf-8

" This is a stub vimrc, used to prevent tiny builds of vim from trying to
" parse my main vimrc.

if version >= 700
  " Note, this won't be executed if has('eval') wouldn't return TRUE.
  runtime vimrc-main
else
  runtime rc/options-tiny.vim
endif

" The following is for vim.tiny, which is built without +eval support.  See :help no-eval-feature
" Without +eval support, if..else..endif blocks are ignored.
silent! while 0
set nocompatible
runtime rc/options-tiny.vim
silent! endwhile
