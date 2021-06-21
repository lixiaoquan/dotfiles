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

set cursorline
set cursorcolumn
set number
set relativenumber
set mouse=a

" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
set ttimeoutlen=0

" viminfo and last-position-jump
set viminfo='20,\"100,<500
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" coding mapping
" Disable useless functions
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

let s:cmake='~/cmake-3.20.1-linux-x86_64/bin/cmake'
let s:cmake_cache_file='../build-ai_software-Desktop-Debug/CMakeCache.txt'
" Use F1 as save and build
function! SaveAndBuild()
  execute 'AsyncRun -cwd=<root> -save=2 '.s:cmake.' --build --preset=default'
endfunction
inoremap <silent> <F1> <ESC> :call SaveAndBuild() <CR>
noremap <silent> <F1> :call SaveAndBuild() <CR>

function! s:cmake_configure()
  execute 'AsyncRun -cwd=<root> '.s:cmake.' --preset=default'
endfunction

function! s:cmake_clean_cache()
  let cmd=`rm -fv `.s:cmake_cache_file
  execute 'AsyncRun -cwd=<root> '.cmd
endfunction

function! s:cmake_reconfigure()
  let cmd=`rm -fv `.s:cmake_cache_file.' && '.s:cmake.' --preset=default'
  execute 'AsyncRun -cwd=<root> -save=2 '.cmd
endfunction

command CleanCache call s:cmake_clean_cache()
command Configure call s:cmake_configure()
command Reconfigure call s:cmake_reconfigure()

noremap <F3> <ESC><C-O>
" noremap <F4> :call system('xclip', @0)<CR>
noremap <F4> :
inoremap <F4> <ESC>:
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>
noremap <F6> mz:r !xclip -o -sel clip<CR>`z
map <F7> :set paste<CR>i<CR><ESC>k<F6>gJgJ:set nopaste<CR>
noremap <F8> <ESC>f)i<CR><ESC>kf(a<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>
noremap <F12> :Cheat40<cr>
inoremap <F12> <ESC>:Cheat40<cr>
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
" paste clipboard
" register * sometimes doesn't work in some vnc
" inoremap <C-V> <Esc>"*pa
inoremap <C-k> <c-o>d$

function! Paste()
  " read clipboard to a
  let @a=system("xclip -o -sel clip")
  " paste a
  normal! "ap
endfunction

inoremap <C-V> <Esc>:call Paste()<CR>a

map H ^
map L $

" Save as sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Map ALT keys
" ALT-D to dw to delete a word, same as bash
execute "set <M-d>=\ed"
inoremap <M-d> <C-O>dw

" map <enter> o<ESC>

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
" {{{
  "let g:solarized_termcolors=256
  set background=dark
" }}}
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
" {{{
  " Use Ctrl-/ to comment/uncomment
  imap <C-_> <C-O>gcc
  nmap <C-_> gcc
" }}}
Plug 'MattesGroeger/vim-bookmarks'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{
  noremap <F2> :call CocAction('jumpDefinition')<CR>

  " TextEdit might fail if hidden is not set.
  set hidden

  " Some servers have issues with backup files, see #649.
  set nobackup
  set nowritebackup

  " Give more space for displaying messages.
  set cmdheight=2

  " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  " delays and poor user experience.
  set updatetime=300

  " Don't pass messages to |ins-completion-menu|.
  set shortmess+=c

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
  " position. Coc only does snippet and additional edit on confirm.
  if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  " nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current line.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Introduce function text object
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " Use <TAB> for selections ranges.
  " NOTE: Requires 'textDocument/selectionRange' support from the language server.
  " coc-tsserver, coc-python are the examples of servers that support it.
  nmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <TAB> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings using CoCList:
  " Show all diagnostics.
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}
Plug 'skywind3000/asyncrun.vim'
" {{{
  " automatically open quickfix window when AsyncRun command is executed
  " set the quickfix window 6 lines height.
  let g:asyncrun_open = 6

  " ring the bell to notify you job finished
  let g:asyncrun_bell = 1

  " root
  let g:asyncrun_rootmarks = ['CMakeUserPresets.json']

  " F10 to toggle quickfix window
  nnoremap <F9> :call asyncrun#quickfix_toggle(6)<cr>
" }}}
Plug 'Raimondi/delimitMate'
Plug 'wellle/targets.vim'
" {{{
  autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'b': {'pair': [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}]},
      \ })
" }}}
Plug 'lifepillar/vim-cheat40'
" {{{
  let g:cheat40_use_default=0

  nnoremap <silent> <space>t  :<C-u>Cheat40<cr>
" }}}
Plug 'machakann/vim-sandwich'
Plug 'unblevable/quick-scope'
call plug#end()
runtime macros/sandwich/keymap/surround.vim

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

" https://vi.stackexchange.com/questions/74/is-it-possible-to-make-vim-auto-save-files
" Save on lost focus
autocmd FocusLost * silent! wa
