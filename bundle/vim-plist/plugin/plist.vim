" Name:    plist.vim
" Version: 1.0.0
" Author:  Moritz Heckscher
" Summary: Vim plugin for transparent editing of binary/xml .plist files.
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
"
" Section: Documentation {{{1
"
" Description: {{{2
"
"   This script implements transparent editing of binary & xml plist files.
"   The filename must have a ".plist" suffix. When opening such a file the
"   content is converted to XML if in binary format. If it was previously a
"   binary-plist, the file content will be converted back to binary-plist
"   format before it is written.
"
" Known Issues: {{{2
"
"   When a file changes externally and you answer no to vim's question if
"   you want to write anyway, the autocommands (e.g. for BufWritePost) are still
"   executed, it seems, which could have some unwanted side effects.
"
" Section: Autocmd setup {{{1

augroup plist
  " Delete existing commands (avoid problems if this file is sourced twice)
  autocmd!

  " Set binary mode (needs to be set _before_ reading binary files to avoid
  " breaking lines etc; since setting this for normal plist files doesn't
  " hurt and it's not yet known whether or not the file to be read is stored
  " in binary format, set the option in any case to be sure).
  " Do it before editing a file in a new buffer and before reading a file
  " into in an existing buffer (using ':read foo.plist').
  autocmd BufReadPre,FileReadPre     *.plist set binary

  " Call MyBinaryPlistReadPost just after editing a file in a new buffer...
  autocmd BufReadPost                *.plist call MyBinaryPlistReadPost()

  " Call MyBinaryPlistReadPost when reading a file into an existing buffer (in
  " that case, don't save as binary later on).
  autocmd FileReadPost               *.plist call MyBinaryPlistReadPost()
        \ | let b:saveAsBinaryPlist = 0

  autocmd BufWritePre,FileWritePre   *.plist call MyBinaryPlistWritePre()
  autocmd BufWritePost,FileWritePost *.plist call MyBinaryPlistWritePost()
augroup END

" Section: Functions {{{1

" Function: MyBinaryPlistReadPost() {{{2
"
" A little function to convert binary files if necessary...
"
function MyBinaryPlistReadPost()
  " Check if the first line just read in indicates a binary plist
  if getline("'[") =~ "^bplist"
    " Filter lines read into buffer (convert to XML with plutil)
    '[,']!plutil -convert xml1 /dev/stdin -o /dev/stdout
    " Many people seem to want to save files originally stored
    " in binary format as such after editing, so memorize format.
    let b:saveAsBinaryPlist = 1
  endif
  " Yeah, plain text (finally or all the way through, either way...)!
  set nobinary
  " Trigger file type detection to get syntax coloring etc. according
  " to file contents (alternative: 'setfiletype xml' to force xml).
  filetype detect
endfunction

" Function: MyBinaryPlistWritePre() {{{2
"
" Conversion back to binary format
"
function MyBinaryPlistWritePre()
  if exists("b:saveAsBinaryPlist") && b:saveAsBinaryPlist
    " Must set binary mode before conversion (for EOL settings)
    set binary
    " Convert buffer lines to be written to binary
    silent '[,']!plutil -convert binary1 /dev/stdin -o /dev/stdout
    " If there was a problem, e.g. when the file contains syntax
    " errors, undo the conversion and go back to nobinary so the
    " file will be saved in text format.
    if v:shell_error | undo | set nobinary | endif
  endif
endfunction

" Function: MyBinaryPlistWritePost() {{{2
"
" Verify the saving of the plist
"
function MyBinaryPlistWritePost()
  " If file was to be written in binary format and there was no error
  " doing the conversion, ...
  if exists("b:saveAsBinaryPlist") && b:saveAsBinaryPlist && !v:shell_error
    " ... undo the conversion and go back to nobinary so the
    " lines are shown as text again in vim.
    undo
    set nobinary
  endif
endfunction
