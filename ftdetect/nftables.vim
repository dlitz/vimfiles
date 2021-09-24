function! s:DetectFiletype()
    if getline(1) =~# '^#!\s*\%\(/\S\+\)\?/\%\(s\)\?bin/\%\(env\s\+\)\?nft\>'
        setfiletype nftables
    endif
endfunction

augroup nftables
    autocmd!
    " 2021-01-02 dlitz - Added StdinReadPost and BufWritePost because
    " otherwise using netrw (e.g. scp://...) it resets to filetype=conf after
    " every write, aaaaa.  This might actually be a netrw bug, idk.
    "   XXX It still seems to change back when using :Ex or something?
    autocmd BufRead,BufNewFile,StdinReadPost,BufWritePost * call s:DetectFiletype()
    autocmd BufRead,BufNewFile *.nft,nftables.conf setfiletype nftables
augroup END
