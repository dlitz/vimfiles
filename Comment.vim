" File: Comment.vim
"
" Purpose: functions to comment/uncomment lines
"
" Author: Ralf Arens <ralf.arens@gmx.de>
"
" Last Modified: 2000-03-15 13:28:14 CET
" + bugfixes in CommentToggleSmart(...)
" + no report will be given (neither for substitute, nor for pattern failed)


" All functions support comment styles, these are:
"	"0": insert comment in first column
"	"1": insert comment in first column, plus one space after starting
"	comment and one before ending comment
"	"2": insert starting comment after leading whitespace
"	"3": like "2" with additional spaces, as in "1"

" The functions take two arguments and one optional
"	style
"	starting_comment (eg. "//" in C++)
"	ending_comment (eg. "*/" in C) [optional]


" CommentToggle(style, starting_comment, [ending_comment])
"	toggle the comments for one line or for a whole region
fun! CommentToggle(style, startc, ...)
	let startc = escape(a:startc, '¹*^$.[]\')
	let lin = getline(".")
	if (a:0 == 0)
		" only leading comment
		" check if line is commented
		if (match(lin, '^\s*'.startc) == -1)
			" line is uncommented -> comment
			call Comment(a:style, a:startc)
		else
			" line is commented -> uncomment
			call UnComment(a:style, a:startc)
		endif
	else
		" comment has two parts
		let endc = escape(a:1, '¹*^$.[]\')
		" check if line is commented
		if (match(lin, '^\s*'.startc.'.*'.endc.'\s*') == -1)
			" line is uncommented -> comment
			call Comment(a:style, a:startc, a:1)
		else
			" line is commented -> uncomment
			call UnComment(a:style, a:startc, a:1)
		endif
	endif
endfun


" CommentToggleSmart(style, starting_comment, [ending_comment])
"	toggle the comments for one line or for a whole region
"	if the first line of the region is not commented, the whole region
"	will be commented. and vice versa. double-commenting is avoided.
fun! CommentToggleSmart(style, startc, ...) range
	let first = a:firstline
	let lastl = a:lastline
	let startc = escape(a:startc, '¹*^$.[]\')
	let lin = getline(first)
	let current = line(".")
	if (a:0 == 0)
		" only leading comment
		" check if line is commented
		if (match(lin, '^\s*'.startc) == -1)
			" line is uncommented -> comment all lines
			exe 'norm '.first.'G'
			while (first <= lastl)
				call CommentSmart(a:style, a:startc)
				let first = first + 1
				norm j
			endwhile
		else
			" line is commented -> uncomment
			exe 'norm '.first.'G'
			while (first <= lastl)
				call UnComment(a:style, a:startc)
				let first = first + 1
				norm j
			endwhile
		endif
	else
		" comment has two parts
		let endc = escape(a:1, '¹*^$.[]\')
		" check if line is commented
		if (match(lin, '^\s*'.startc.'.*'.endc.'\s*') == -1)
			" line is uncommented -> comment
			exe 'norm '.first.'G'
			while (first <= lastl)
				call CommentSmart(a:style, a:startc, a:1)
				let first = first + 1
				norm j
			endwhile
		else
			" line is commented -> uncomment
			exe 'norm '.first.'G'
			while (first <= lastl)
				call UnComment(a:style, a:startc, a:1)
				let first = first + 1
				norm j
			endwhile
		endif
	endif
	exe 'norm '.current.'G'
endfun


" CommentSmart(style, start_comment, [end_comment])
"	comment a single line or whole region, but do not `double-comment' a
"	line
fun! CommentSmart(style, startc, ...)
	let startc = escape(a:startc, '¹*^$.[]\')
	let lin = getline(".")
	if (a:0 == 0)
		if (match(lin, '^\s*'.startc) == -1)
			call Comment(a:style, a:startc)
		endif
	else
		let endc = escape(a:1, '¹*^$.[]\')
		if (match(lin, '^\s*'.startc.'.*'.endc.'\s*') == -1)
			call Comment(a:style, a:startc, a:1)
		endif
	endif
endfun


" Comment(style, start_comment, [end_comment])
"	comment a single line or a whole region
fun! Comment(style, startc, ...)
	let or = &report
	let &report= 9999
	let startc = escape(a:startc, '¹*^$.[]\')
	if (a:0 == 0)
	" only "startc" exists
		if (a:style == "0")
			exe 's¹^¹'.startc.'¹'
		elseif (a:style == "1")
			exe 's¹^'.startc.' ¹'
		elseif (a:style == "2")
			exe 's¹^\(\s*\)¹\1'.startc.'¹'
		elseif (a:style == "3")
			exe 's¹^\(\s*\)¹\1'.startc.' ¹'
		else
			echo "Style ".a:style." is not defined."
		endif
	else
	" "endc" exists also
		let endc = escape(a:1, '¹*^$.[]\')
		if (a:style == "0")
			exe 's¹^\(.*\)$¹'.startc.'\1'.endc.'¹'
		elseif (a:style == "1")
			exe 's¹^\(.*\)$¹'.startc.' \1 '.endc.'¹'
		elseif (a:style == "2")
			exe 's¹^\(\s*\)\(.*\)$¹\1'.startc.'\2'.endc.'¹'
		elseif (a:style == "3")
			exe 's¹^\(\s*\)\(.*\)$¹\1'.startc.' \2 '.endc.'¹'
		else
			echo "Style ".a:style." is not defined."
		endif
	endif
	let &report = or
endfun


" UnComment(style, start_comment, [end_comment])
"	uncomment a single line or a whole region
"	no error messages will be given, if substitute fails
fun! UnComment(style, startc, ...)
	let or = &report
	let &report= 9999
	let startc = escape(a:startc, '¹*^$.[]\')
	if (a:0 == 0)
	" only "startc" exists
		if (a:style == "0" || a:style == "2")
			exe 's¹^\(\s*\)'.startc.'¹\1¹e'
		elseif (a:style == "1" || a:style == "3")
			exe 's¹^\(\s*\)'.startc.' \=¹\1¹e'
		else
			echo "Style ".a:style." is not defined."
		endif
	else
	" "endc" exists also
		let endc = escape(a:1, '¹*^$.[]\')
		if (a:style == "0" || a:style == "2")
			exe 's¹^\(\s*\)'.startc.'\(.*\)'.endc.'\s*¹\1\2¹e'
		elseif (a:style == "1" || a:style == "3")
			exe 's¹^\(\s*\)'.startc.' \=\(.\{-}\) \='.endc.'\s*¹\1\2¹e'
		else
			echo "Style ".a:style." is not defined."
		endif
	endif
	let &report = or
endfun


" the autocommand section
"	mappings for calling CommentToggle() according to filetype
map <F10># :call CommentToggleSmart("0", "#")<CR>
au FileType c :map <F10># :call CommentToggleSmart("0", '/*', '*/')<CR>
au FileType cpp :map <F10># :call CommentToggleSmart("0", '//')<CR>
au FileType html :map <F10># :call CommentToggleSmart("0", "<!--", '-->')<CR>
au FileType slang :map <F10># :call CommentToggleSmart("0", '%')<CR>
au FileType slrnrc :map <F10># :call CommentToggleSmart("0", '%')<CR>
au FileType slrnsc :map <F10># :call CommentToggleSmart("0", '%')<CR>
au FileType tex :map <F10># :call CommentToggleSmart("0", '%')<CR>
au FileType vim :map <F10># :call CommentToggleSmart("0", '"')<CR>
au FileType xdefaults :map <F10># :call CommentToggleSmart("0", '!')<CR>
au FileType scheme :map <F10># :call CommentToggleSmart("0", ';')<CR>


" note: I can't use "exe 's/^/'.a:startc.'/'" because the separators my match
" chars of the comment like in this example ("/" is separator, "//" is C++
" comment
"
" but since using "substitute()" is ugly, I'll use ":s¹···¹···¹" for some time
" "¹" is Alt-Gr 1 here. Since I discovered `escape()' it's no problem anymore.
"

" vim: set noet ts=8 sw=8 sts=8:
