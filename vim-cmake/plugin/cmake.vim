let g:cmake_bin='/mercury/utility/cmake-3.20.5-linux-x86_64/bin/cmake'
let g:cmake_cache_file='../build-ai_software-Desktop-Debug/CMakeCache.txt'

function! cmake#build()
  execute 'AsyncRun -cwd=<root> -save=2 '.g:cmake_bin.' --build --preset=default'
endfunction

function! s:cmake_configure()
  execute 'AsyncRun -cwd=<root> '.g:cmake_bin.' --preset=default'
endfunction

function! s:cmake_clean_cache()
  let cmd='rm -fv '.g:cmake_cache_file
  execute 'AsyncRun -cwd=<root> '.cmd
endfunction

function! s:cmake_reconfigure()
  let cmd='rm -fv '.g:cmake_cache_file.' && '.g:cmake_bin.' --preset=default'
  execute 'AsyncRun -cwd=<root> -save=2 '.cmd
endfunction

command CleanCache call s:cmake_clean_cache()
command Configure call s:cmake_configure()
command Reconfigure call s:cmake_reconfigure()
