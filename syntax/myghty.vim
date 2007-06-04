" Vim syntax file
" Language:    Myghty (Python templating engine based on HTML::Mason)
" Maintainer:  Robert West <robert@lonestarcode.com>

" Last change: 2004 Dec 20
" URL:	       http://www.lonestarcode.com/myghty_vim/
"
" This file was blatantly stolen and hacked up from Andrew Smith's mason.vim

" Changes:
" 	- First Version: simple altered mason.vim to pull in python instead of
"     perl and fixed <%python> tag to allow for scope= modifiers

" Clear previous syntax settings unless this is v6 or above, in which case just
" exit without doing anything.
"
if version < 600
	syn clear
elseif exists("b:current_syntax")
	finish
endif

" The HTML syntax file included below uses this variable.
"
if !exists("main_syntax")
	let main_syntax = 'myghty'
endif

" First pull in the HTML syntax.
"
if version < 600
	so <sfile>:p:h/html.vim
else
	runtime! syntax/html.vim
	unlet b:current_syntax
endif

syn cluster htmlPreproc add=@myghtyTop

" Now pull in the Perl syntax.
"
if version < 600
	so <sfile>:p:h/python.vim
else
	syn include @Python syntax/python.vim
endif

" I've not really changed anything here from the mason.vim version, but soon I
" will start altering tags to be more myghty-specific. 
" If you have any suggestions, please let me know.
"
syn region myghtyLine matchgroup=Delimiter start="^%" end="$" contains=@Python
syn region myghtyExpr matchgroup=Delimiter start="<%" end="%>" contains=@Python
syn region myghtyPython matchgroup=Delimiter start="<%python[^>]*>" end="</%python>" contains=@Python
syn region myghtyComp keepend matchgroup=Delimiter start="<&" end="&>" contains=@Python

syn region myghtyArgs matchgroup=Delimiter start="<%args>" end="</%args>" contains=@Python

syn region myghtyInit matchgroup=Delimiter start="<%init>" end="</%init>" contains=@Python
syn region myghtyCleanup matchgroup=Delimiter start="<%cleanup>" end="</%cleanup>" contains=@Python
syn region myghtyOnce matchgroup=Delimiter start="<%once>" end="</%once>" contains=@Python
syn region myghtyShared matchgroup=Delimiter start="<%shared>" end="</%shared>" contains=@Python

syn region myghtyDef matchgroup=Delimiter start="<%def[^>]*>" end="</%def>" contains=@htmlTop
syn region myghtyMethod matchgroup=Delimiter start="<%method[^>]*>" end="</%method>" contains=@htmlTop

syn region myghtyFlags matchgroup=Delimiter start="<%flags>" end="</%flags>" contains=@Python
syn region myghtyAttr matchgroup=Delimiter start="<%attr>" end="</%attr>" contains=@Python

syn region myghtyFilter matchgroup=Delimiter start="<%filter>" end="</%filter>" contains=@Python

syn region myghtyDoc matchgroup=Delimiter start="<%doc>" end="</%doc>"
syn region myghtyText matchgroup=Delimiter start="<%text>" end="</%text>"

syn cluster myghtyTop contains=myghtyLine,myghtyExpr,myghtyPerl,myghtyComp,myghtyArgs,myghtyInit,myghtyCleanup,myghtyOnce,myghtyShared,myghtyDef,myghtyMethod,myghtyFlags,myghtyAttr,myghtyFilter,myghtyDoc,myghtyText

" Set up default highlighting. Almost all of this is done in the included
" syntax files.
"
if version >= 508 || !exists("did_myghty_syn_inits")
	if version < 508
		let did_myghty_syn_inits = 1
		com -nargs=+ HiLink hi link <args>

	else
		com -nargs=+ HiLink hi def link <args>
	endif

	HiLink myghtyDoc Comment

	delc HiLink
endif

let b:current_syntax = "myghty"

if main_syntax == 'myghty'
	unlet main_syntax
endif
