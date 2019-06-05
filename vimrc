inoremap <F1> <nop>
noremap <F1> <nop>
noremap <F11> <ESC>:colo torte<CR>
noremap <F12> <ESC>:colo pablo_my<CR>

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
"inoremap { {<CR>}<CR><ESC>kO<TAB>
"inoremap ( ()<LEFT>
"inoremap [ []<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"inoremap ; <ESC>A;

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
Plug 'bfrg/vim-cpp-modern'
Plug 'tpope/vim-fugitive'
call plug#end()

" Fuzzy Finder
if version > 701
noremap <Leader>b :Files<CR>
noremap <Leader>f :Buffers<CR>
noremap <Leader>g :Tags<CR>
noremap <Leader>t :FufTaggedFile<CR>
let g:fuf_previewHeight=1
let g:fuf_enumeratingLimit=20
endif

" Set color
"colorscheme torte
"colorscheme pablo
"colorscheme pablo_my
"colorscheme diablo3

"autocmd FileType c,h autocmd BufWritePre <buffer> :%s/\s\+$//e
set list listchars=tab:>-,trail:-

" clang complete
let g:clang_use_library = 1
let g:clang_library_path = "/home/xiaoquan.li"
let g:clang_complete_macros = 1
let g:clang_complete_auto = 1
let g:clang_auto_select = 1

map H ^
map L $

map <enter> o<ESC>
