let g:mapleader = "\<Space>"

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

set scrolloff=10

" viminfo and last-position-jump
set viminfo='20,\"100,<500
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" coding mapping
" Disable useless functions
inoremap <F1> <nop>
noremap <F1> <nop>
noremap K k
noremap J j
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
"inoremap <Up> <nop>
"inoremap <Down> <nop>
"inoremap <Left> <nop>
"inoremap <Right> <nop>


noremap <F3> <ESC><C-O><CR>
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
nnoremap <silent> _ <C-w>>
nnoremap <silent> + <C-w><

noremap <C-S> :w<CR>
vnoremap <C-S> <C-C>:w<CR>
inoremap <C-S> <C-O>:w<CR>
inoremap <C-t> <esc>:wq!<cr>               " save and exit
nnoremap <C-t> :wq!<cr>
inoremap <C-q> <esc>:qa!<cr>               " quit discarding changes
nnoremap <C-q> :qa!<cr>
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I

map H ^
map L $

" map <enter> o<ESC>

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



"auto close {
function! s:CloseBracket()
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
      return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
      " Probably inside a function call. Close it off.
      return "{\<Enter>});\<Esc>O"
    else
      return "{\<Enter>}\<Esc>O"
    endif
    endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()

nmap Q gq

" Set VIM runtime
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_vim_statusline = 0 " disable statusline overwriting

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
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'valloric/youcompleteme'
" {{{
  noremap <F1> :YcmCompleter GoToDeclaration<CR>
  noremap <F2> :YcmCompleter GoToDefinition<CR>
  "inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

  function! s:CRComplete()
    if empty(v:completed_item)
        execute "norm! i\<CR>"
    endif
  endfunction
  inoremap <CR> <LEFT><RIGHT><C-O>:call <SID>CRComplete()<CR>

  let g:ycm_use_clangd=0
  let g:ycm_add_preview_to_completeopt = 0
  let g:ycm_show_diagnostics_ui = 0
  let g:ycm_server_log_level = 'info'
  let g:ycm_min_num_identifier_candidate_chars = 2
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_strings=1
  let g:ycm_key_invoke_completion = '<c-z>'
  set completeopt=menu,menuone
  noremap <c-z> <NOP>
  let g:ycm_semantic_triggers = {
              \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
              \ 'cs,lua,javascript': ['re!\w{2}'],
              \ }

  let g:ycm_filetype_whitelist = {
             \ "c":1,
             \ "cpp":1,
             \ "objc":1,
             \ "sh":1,
             \ "zsh":1,
             \ "zimbu":1,
             \ "py":1,
             \ }
" }}}
call plug#end()

"let g:solarized_termcolors=256
set background=dark
colorscheme solarized

"autocmd FileType c,h autocmd BufWritePre <buffer> :%s/\s\+$//e
set list listchars=tab:>-,trail:-
set gdefault

set autoread
set encoding=utf-8

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
