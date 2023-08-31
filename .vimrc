""" Style
colorscheme evening
"colorscheme desert
set guifont=Bitstream\ Vera\ Sans\ Mono\ 16
set nocompatible	" Use Vim Keyboard mode as defaults (much better than vi!)
set number		"show line number
set history=100		" keep 100 lines of command line history
set ruler		" show the cursor position all the time
set nobackup		"no *~ backup files
set noswapfile  "donnot set up .swap backup file, 
"set autoread " auto read when file is changed from outside
"set clipboard+=unnamed "let Vim share Windows clipboard. seems useless.
"set fileformats=unix,dos,mac " try file format.
set fileformats=unix " try file format.
"set wildchar=<TAB>	" start wild expansion in the command line using <TAB>
set wildmenu " wild char completion menu
set showcmd     "show (partial) command in the last line of the screen, this also shows visual selection info 
set laststatus=2 "always show status bar
syntax on " syntax highlight
syntax enable " Enable syntax highlighting

""" TAB setting
set tabstop=4 	" a tab is four spaces
set shiftwidth=4 " number of spaces to use for autoindenting
set cindent         "c language auto indentation
set autoindent		" auto indentation
set copyindent " copy the previous indentation on autoindenting
set smartindent
set expandtab	"replace tab with spaces
set smarttab " insert tabs on the start of a line according to context

set list
set listchars=tab:\|\  "dispaly Tab as '|'

""" search setting
set cursorline  " highlight line
set cursorcolumn " highlight column
set showmatch " Cursor shows matching ) and }
set hlsearch	" search highlighting
set incsearch	" incremental search
set ignorecase " ignore case when searching
set smartcase " ignore case if search pattern is all lowercase,case-sensitive otherwise

""" tab page setting
set tabpagemax=9
set showtabline=2
" Key Shortcut
nmap <C-t> :tabnew<cr>
nmap <C-n> :tabnext<cr>
nmap <C-k> :tabclose<cr>
nmap <C-Tab> :tabnext<cr> 
vnoremap <C-y> "+y
nnoremap <C-p> "*p

""" file
"filetype off 		" necessary to make ftdetect work on Linux
filetype on 		" Enable filetype detection
filetype indent on 	" Enable filetype-specific indenting
filetype plugin on 	" Enable filetype-specific plugins

""" ENCODING SETTINGS
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

fun! ViewUTF8()
set encoding=utf-8
set termencoding=big5
endfun
fun! UTF8()
set encoding=utf-8
set termencoding=big5
set fileencoding=utf-8
set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
set encoding=big5
set fileencoding=big5
endfun

""" Auto-completion
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
":inoremap { {<CR>}<ESC>O
":inoremap } <c-r>=ClosePair('}')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
":inoremap " ""<ESC>i
":inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

inoremap : <c-r>=Swap()<CR>
inoremap , ,<space>
"support format: += -+ *= /+
function! EqualSign(char)
    if a:char  =~ '='  && getline('.') =~ ".*("
        return a:char
    endif
    let ex1 = getline('.')[col('.') - 3]
    let ex2 = getline('.')[col('.') - 2]
    if ex1 =~ "[-=+><>\/\*]"
        if ex2 !~ "\s"
            return "\<ESC>i".a:char."\<SPACE>"
        else
            return "\<ESC>xa".a:char."\<SPACE>"
        endif
    else
        if ex2 !~ "\s"
            return "\<SPACE>".a:char."\<SPACE>\<ESC>a"
        else
            return a:char."\<SPACE>\<ESC>a"
        endif
    endif
endf 

function! Swap()
    if getline('.')[col('.') - 1] =~ ")"
        return "\<ESC>la:"
    else
        return ":"
    endif
endf

map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>

"---------------------------------------------------------------------------------------------
" My Function 
"  - Setfilehead() : write head string when create new *.sv ect file
"
autocmd BufNewFile *.v,*.sv,*.svh,*.c,*.h exec ":call Setfilehead()"

func Setfilehead()
call append(0, '//!***************************************************************************//')
call append(1, '//!  Copyright (c) 2020 - 2023 by ** Technologies Inc.')
call append(2, '//!  ')
call append(3, '//!     FileName    : '.expand("%:t"))
call append(4, '//!     ')
call append(5, '//!     Author      : '.expand("$USER"))
call append(6, '//!     Versrion    : v1.0')
call append(7, '//!     Update      : '.strftime("%Y-%m-%d %H:%M:%S")." - first version v1.0")
call append(8, '//!')
call append(9, '//!     Description : ')
call append(10,'//!')
call append(11,'//!***************************************************************************//')
call append(12, '')
call append(13, '`ifndef __'.toupper(expand("%:t:r")).('__'))
call append(14, '`define __'.toupper(expand("%:t:r")).('__'))
call append(15, '')
call append(16, '')
call append(17, '`endif')
endfunc

"======================================================================
" Tap <F11> to decrease font size and <F12> to increase
"======================================================================
nnoremap <F11> :call DecreaseFontSize()<CR>
nnoremap <F12> :call IncreaseFontSize()<CR>

function! DecreaseFontSize()
    let current_font = &guifont
    let font_parts = split(current_font, " ")
    let current_size = str2nr(font_parts[1])

    if current_size > 1
        let new_size = current_size - 1
        let new_font = font_parts[0].'\ '.new_size 
        execute "set guifont=" . new_font
    endif
endfunction

function! IncreaseFontSize()
    let current_font = &guifont
    let font_parts = split(current_font, " ")
    let current_size = str2nr(font_parts[1])

    let new_size = current_size + 1
    let new_font = font_parts[0].'\ '.new_size 
    execute "set guifont=" . new_font
endfunction


function! CleverTab()
    let col = col('.') - 1
    let line = getline('.')
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    elseif col > 0 && line[col - 1] =~ '\s'
        return "\<Tab>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
