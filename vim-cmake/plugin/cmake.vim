if !exists("g:cmake_bin")
  let g:cmake_bin='cmake'
endif

function! cmake#build(preset = 'default')
  execute 'AsyncRun -cwd=<root> -save=2 '.g:cmake_bin.' --build --preset=' .. a:preset
endfunction

function! s:cmake_configure()
  execute 'AsyncRun -cwd=<root> '.g:cmake_bin.' --preset=default'
endfunction

function! s:cmake_clean_cache()
  if !exists("g:cmake_binary_dir")
    echom "g:cmake_binary_dir is not specified, can't clean cache"
    return
  endif
  let cmd='rm -fv '.g:cmake_binary_dir.'/CMakeCache.txt'
  execute 'AsyncRun -cwd=<root> '.cmd
endfunction

function! s:cmake_reconfigure()
  if !exists("g:cmake_binary_dir")
    echom "g:cmake_binary_dir is not specified, can't reconfigure"
    return
  endif
  let cmd='rm -fv '.g:cmake_binary_dir.'/CMakeCache.txt && '.g:cmake_bin.' --preset=default'
  execute 'AsyncRun -cwd=<root> -save=2 '.cmd
endfunction

command CleanCache call s:cmake_clean_cache()
command Configure call s:cmake_configure()
command Reconfigure call s:cmake_reconfigure()
command -nargs=? Build call cmake#build(<q-args>)
