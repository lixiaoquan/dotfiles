let g:mapleader = "\<Space>"

" syntax
syntax on

"basic configure
set nocompatible
set ignorecase
set smartcase
set incsearch
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

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set scrolloff=10

set cursorline
set cursorcolumn
set number
set relativenumber
set mouse=a

" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
set ttimeoutlen=0

" coding mapping
" Disable useless functions
noremap K k
noremap J j
noremap <Up> <c-w>k
noremap <Down> <c-w>j
noremap <Left> <c-w>h
noremap <Right> <c-w>l
nnoremap t <c-w>t
nnoremap \ <c-w>b
nnoremap q <c-w>q
"inoremap <Up> <nop>
"inoremap <Down> <nop>
"inoremap <Left> <nop>
"inoremap <Right> <nop>

" Use F1 as save and build
inoremap <silent> <F1> <ESC> :call cmake#build() <CR>
noremap <silent> <F1> :call cmake#build() <CR>

noremap <F3> <ESC><C-O>
" noremap <F4> :call system('xclip', @0)<CR>
noremap <F4> :
inoremap <F4> <ESC>:
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>
noremap <F6> :call cmake#generate_pytest_command() <CR>
map <F7> :set paste<CR>i<CR><ESC>k<F6>gJgJ:set nopaste<CR>
" noremap <F8> <ESC>f)i<CR><ESC>kf(a<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>f,li<CR><ESC>
noremap <F12> :Cheat40<cr>
inoremap <F12> <ESC>:Cheat40<cr>
nnoremap <silent> _ <C-w>>
nnoremap <silent> + <C-w><

noremap <C-S> :w<CR>
vnoremap <C-S> <C-C>:w<CR>
inoremap <C-S> <C-O>:w<CR>
inoremap <C-t> <esc>:wqa!<cr>               " save and exit
nnoremap <C-t> :wqa!<cr>
inoremap <C-q> <esc>:qa!<cr>                " quit discarding changes
nnoremap <C-q> :qa!<cr>
xnoremap <C-q> <esc>:qa!<cr>
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
if !has("nvim")
  execute "set <M-d>=\ed"
endif
inoremap <M-d> <C-O>dw

" map <enter> o<ESC>
" <CR> to clear highlight caused by search
nnoremap <silent> <CR> :nohlsearch<CR><CR>

nmap Q gq

nnoremap <leader>v :<C-U>vs<CR>
nnoremap <leader>l <c-w>l
nnoremap <leader>p :<C-U>pwd<CR>

" command line mode mappings
" quit discarding change
cnoremap <c-q> <C-u>qa!<cr>

" i mode mappings
" go definition
inoremap <F2> <esc>:call CocAction('jumpDefinition')<cr>
" go back
inoremap <F3> <esc><c-o>

" n mode mappings
function! UseF4()
  echo "You can use F4 to replace :"
  sleep 1000m
  call feedkeys("\<F4>")
endfunction

nnoremap : <esc>:call UseF4()<cr>

" Plugins
call plug#begin('~/.vim/plugged')
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_vim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <leader><space> :Files<CR>
  nnoremap <silent> <leader>b :Buffers<CR>
  nnoremap <silent> <leader>A :Windows<CR>
  nnoremap <silent> <leader>; :BLines<CR>
  nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>O :Tags<CR>
  nnoremap <silent> <leader>h :History<CR>
  nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
  nnoremap <silent> <leader>. :AgIn

  nnoremap <silent> K :call SearchWordWithAg()<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
  " nnoremap <silent> <leader>gl :Commits<CR>
  " nnoremap <silent> <leader>ga :BCommits<CR>
  " nnoremap <silent> <leader>ft :Filetypes<CR>

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
    call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': a:1}))
  endfunction
  command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)

  let g:fzf_preview_window = ['right:50%', 'ctrl-_']
  command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '-U', fzf#vim#with_preview(), <bang>0)
" }}}
if has("nvim")
  Plug 'nvim-treesitter/nvim-treesitter', {'do' : ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'm-demare/hlargs.nvim'
else
  " Plug 'bfrg/vim-cpp-modern'
  Plug 'jackguo380/vim-lsp-cxx-highlight'
endif
Plug 'vim-airline/vim-airline'
" {{{
  let g:airline#extensions#whitespace#enabled = 0
" }}}
Plug 'vim-airline/vim-airline-themes'
" {{{
  let g:airline_theme='solarized'
  let g:airline_powerline_fonts=1
" }}}
Plug 'lifepillar/vim-solarized8'
" {{{
  set background=light
  autocmd vimenter * ++nested colorscheme solarized8_flat
  if has("nvim")
    set fillchars+=vert:\|
  endif
" }}}
Plug 'tpope/vim-commentary'
" {{{
  " Use Ctrl-/ to comment/uncomment
  imap <C-_> <C-O>gcc
  nmap <C-_> gcc
" }}}
Plug 'MattesGroeger/vim-bookmarks'
" {{{
  let g:bookmark_save_per_working_dir = 1
  let g:bookmark_auto_save = 1
  nmap <C-_> gcc
" }}}
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
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use <leader>d to show documentation in preview window.
  nnoremap <silent> <leader>d :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
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
  " nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  " nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  " nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  " nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


  nnoremap <silent> <F8> :<C-u>CocList -N mru<CR>
  inoremap <silent> <F8> <esc>:<C-u>CocList -N mru<CR>

  " Close quickfix and open file from mru in opposite window
  nnoremap <silent> <space>o  :<C-u>cclose<cr><C-w>w:<C-u>CocList mru<cr>

  let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-lists',
      \ 'coc-cmake',
      \ 'coc-word',
      \ 'coc-json',
      \ ]
" }}}
Plug 'skywind3000/asyncrun.vim'
" {{{
  " automatically open quickfix window when AsyncRun command is executed
  " set the quickfix window 50 lines height.
  let g:asyncrun_open = 6

  " ring the bell to notify you job finished
  let g:asyncrun_bell = 1

  " root
  let g:asyncrun_rootmarks = ['CMakeUserPresets.json']

  " F10 to toggle quickfix window
  nnoremap <F10> :call asyncrun#quickfix_toggle(g:asyncrun_open)<cr>
" }}}
Plug 'skywind3000/asyncrun.extra'
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

  nnoremap <silent> <leader>t  :<C-u>Cheat40<cr>
" }}}
Plug 'machakann/vim-sandwich'
Plug 'unblevable/quick-scope'
Plug 'embear/vim-localvimrc'
" {{{
  let g:localvimrc_ask=0
  let g:localvimrc_sandbox=0
" }}}
Plug 'voldikss/vim-floaterm'
" {{{
  nnoremap   <silent>   <F12>   :FloatermToggle<CR>
  tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
  let g:floaterm_autoclose = 2
" }}}
Plug 'antoinemadec/coc-fzf'
Plug 'airblade/vim-gitgutter'
Plug 'justinmk/vim-sneak'
" {{{
  let g:sneak#use_ic_scs=1
  let g:sneak#label=1
" }}}
Plug 'liuchengxu/vim-which-key'
" {{{
  nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
  set timeoutlen=500
" }}}
Plug 'honza/vim-snippets'
Plug 'farmergreg/vim-lastplace'
Plug 'rhysd/git-messenger.vim'
Plug 'jabirali/vim-tmux-yank'
Plug '~/dotfiles/vim-cmake'
call plug#end()
runtime macros/sandwich/keymap/surround.vim

"autocmd FileType c,h autocmd BufWritePre <buffer> :%s/\s\+$//e
set list listchars=tab:»·,trail:·
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

" vertical split on startup
au BufEnter *.py,*.cpp if winnr('$') == 1 | vsplit | endif

" It has to be here
autocmd vimenter * ++nested hi LspCxxHlGroupMemberVariable guifg=#839496

" Use <C-K> to clear the highlighting of :set hlsearch.
if maparg('<C-K>', 'n') ==# ''
  nnoremap <silent> <C-K> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

lua require("hlargs").setup()
