inoremap <F1> <nop>
noremap <F1> <nop>
noremap <F11> <ESC>:colo torte<CR>
noremap <F12> <ESC>:colo pablo_my<CR>

let g:mapleader = "\<Space>"

noremap K k
noremap J j



" syntax
syntax on
"let g:c_no_curly_error = 1
"set synmaxcol=500
"let loaded_matchparen=1

"basic configure
set nocompatible
set is
set ic
set ts=2
set shiftwidth=2
set expandtab
set autoindent
set smarttab
set nowrap
set diffopt+=context:8
set nonu
set backspace=indent,eol,start

" backup
set nowritebackup
set nobackup

"color in putty
set t_Co=256

"ctags
set tags=tags

set scrolloff=10

" viminfo and last-position-jump
set viminfo='20,\"100,<500
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" coding mapping
noremap <F2> ^i/* <ESC>$a */<ESC>
noremap <F3> <ESC>:s/\/\*\s//g<CR>:s/\s\*\///g<CR>
noremap <F8> <ESC>f)i<CR><ESC>kf(a<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>
"inoremap { {<CR>}<CR><ESC>kO<TAB>
"inoremap ( ()<LEFT>
"inoremap [ []<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"inoremap ; <ESC>A;
"
nnoremap <silent> _ <C-w>>
nnoremap <silent> + <C-w><
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
inoremap <C-e> <esc>:wq!<cr>               " save and exit
nnoremap <C-e> :wq!<cr>
inoremap <C-q> <esc>:qa!<cr>               " quit discarding changes
nnoremap <C-q> :qa!<cr>

function! RemoveNextDoubleChar(char)
    let l:line=getline(".")
    let l:next_char=l:line[col(".")-1]
    let l:pair_char=a:char

    if a:char == ')'
        let l:pair_char='('
    endif
    if a:char == ']'
        let l:pair_char='['
    endif

    if l:pair_char == l:next_char
        execute "normal! l"
    else
        execute "normal! a" . a:char . ""
    endif
endfunction

"inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>i
"inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>i

nmap Q gq

" Set VIM runtime
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <leader><space> :Files<CR>
  nnoremap <silent> <leader>b :Buffers<CR>
  nnoremap <silent> <leader>A :Windows<CR>
  nnoremap <silent> <leader>; :BLines<CR>
  nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>O :Tags<CR>
  nnoremap <silent> <leader>? :History<CR>
  nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
  nnoremap <silent> <leader>. :AgIn 

  nnoremap <silent> K :call SearchWordWithAg()<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
  nnoremap <silent> <leader>gl :Commits<CR>
  nnoremap <silent> <leader>ga :BCommits<CR>
  nnoremap <silent> <leader>ft :Filetypes<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)

  function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
  endfunction

  function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
  endfunction
  command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)
" }}}
Plug 'bfrg/vim-cpp-modern'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
call plug#end()

"let g:solarized_termcolors=256
set background=dark
colorscheme solarized

"autocmd FileType c,h autocmd BufWritePre <buffer> :%s/\s\+$//e
set list listchars=tab:>-,trail:-

map H ^
map L $

map <enter> o<ESC>
