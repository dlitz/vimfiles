"" BEGIN copied and modified from https://github.com/vivien/vim-linux-coding-style/blob/7da66c1b34dc2976a70c9393c7e0c9f47e129e89/plugin/linuxsty.vim
function! LinuxFormatting()
    setlocal tabstop=8
    setlocal shiftwidth=0
    setlocal softtabstop=-1
    setlocal textwidth=80
    setlocal noexpandtab

    setlocal cindent
    setlocal cinoptions=:0,l1,t0,g0,(0
endfunction
function! LinuxKeywords()
    syn keyword cOperator likely unlikely
    syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
    syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64
endfunction
"" END copied and modified from https://github.com/vivien/vim-linux-coding-style/blob/7da66c1b34dc2976a70c9393c7e0c9f47e129e89/plugin/linuxsty.vim
function! LinuxCodingStyle()
    call LinuxFormatting()
    if &filetype =~ '\v^(asm|c|cpp|diff)$'
        call LinuxKeywords()
    endif
endfunction
function! MaybeLinuxCodingStyle()
    "let amatch = expand('<amatch>')
    let path = expand('<afile>:p')
    if path =~ '\v/linux|/kernel'
        call LinuxCodingStyle()
    endif
endfunction
augroup linuxcodingstyle
    autocmd!
    autocmd BufNewFile,BufRead * call MaybeLinuxCodingStyle()
    autocmd FileType c,cpp call MaybeLinuxCodingStyle()
    autocmd FileType kconfig,gitconfig call LinuxCodingStyle()
augroup END

