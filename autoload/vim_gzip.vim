let s:vim_gzip_dir = fnamemodify(globpath(&rtp, 'bin/vim_gzip_wrapper/gzip'), ":p:h")
if has('win32')
  let s:pathsep = ';'
else
  let s:pathsep = ':'
endif

fun vim_gzip#read(cmd)
  let saved_path = getenv('PATH')
  call setenv('VIM_GZIP_NAME_HACK', expand('%'))
  call setenv('PATH', s:vim_gzip_dir . s:pathsep . saved_path)
  call gzip#read(a:cmd . ' --always-suffix')
  call setenv('PATH', saved_path)
  call setenv('VIM_GZIP_NAME_HACK', v:null)
endfun

fun vim_gzip#write(cmd)
  let saved_path = getenv('PATH')
  call setenv('VIM_GZIP_NAME_HACK', expand('%'))
  call setenv('PATH', s:vim_gzip_dir . s:pathsep . saved_path)
  call gzip#write(a:cmd . ' --always-suffix')
  call setenv('PATH', saved_path)
  call setenv('VIM_GZIP_NAME_HACK', v:null)
endfun

fun vim_gzip#appre(cmd)
  let saved_path = getenv('PATH')
  call setenv('VIM_GZIP_NAME_HACK', expand('%'))
  call setenv('PATH', s:vim_gzip_dir . s:pathsep . saved_path)
  call gzip#appre(a:cmd . ' --always-suffix')
  call setenv('PATH', saved_path)
  call setenv('VIM_GZIP_NAME_HACK', v:null)
endfun
