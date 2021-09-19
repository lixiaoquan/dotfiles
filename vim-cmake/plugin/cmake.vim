if !exists("g:cmake_bin")
  let g:cmake_bin='cmake'
endif

if !exists("g:cmake_configure_preset")
  let g:cmake_configure_preset='default'
endif

function! cmake#set_configure_preset(preset)
  let l:parts = split(a:preset)
  let l:preset = substitute(l:parts[0], '"', "", "g")
  echomsg "Current configure preset is set to " . l:preset
  let g:cmake_configure_preset = l:preset
endfunction

function! cmake#select_preset()
  " rely on asyncrun <root>
  let l:dir = asyncrun#get_root('%')
  let l:cmd = g:cmake_bin . " --list-presets -S " . l:dir
  let l:list = split(system(l:cmd), '\n')[2:]
  return fzf#run({
              \ 'source': l:list,
              \ 'options': '+m -n 1 --prompt CMakePreset\>\ ',
              \ 'window': {'width': 0.2, 'height': 0.2},
              \ 'sink': function("cmake#set_configure_preset"),
              \ })
endfunction

function! cmake#build(preset = 'default')
  execute 'AsyncRun -cwd=<root> -save=2 '.g:cmake_bin.' --build --preset=' .. a:preset
endfunction

function! s:cmake_configure()
  execute 'AsyncRun -cwd=<root> '.g:cmake_bin.' -Wno-dev --preset=' . g:cmake_configure_preset
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
  let cmd='rm -fv '.g:cmake_binary_dir.'/CMakeCache.txt && '.g:cmake_bin.' -Wno-dev --preset=' . g:cmake_configure_preset
  execute 'AsyncRun -cwd=<root> -save=2 '.cmd
endfunction

command CleanCache call s:cmake_clean_cache()
command Configure call s:cmake_configure()
command Reconfigure call s:cmake_reconfigure()
command -nargs=? Build call cmake#build(<q-args>)
