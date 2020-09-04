" Set ergonomic <leader> key
:let mapleader = ","

" Change between buffers
map <C-J> :bprev<CR>
map <C-K> :bnext<CR>

" Change between windows
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-I> <C-W>k
map <C-M> <C-W>j
tnoremap <ESC> <C-\><C-n>

""""" GENERAL SETTINGS """""

" This will enable the usage of your mouse inside Vim
set mouse=a

" This option speeds up macro execution in Vim
" I have drawing defects because of it
"set lazyredraw

" This will enable Vim's spell checking feature
" set spell spelllang=en,ru

" This will make Vim start searching the moment you start
" typing the first letter of your search keyword
set incsearch
" This will make Vim highlight all search results that
" matched the search keyword
set hlsearch

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent

" Folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

" Line numbers
set number

" Autowrite on disk on buffer switching, exit, etc
set autowrite

filetype plugin on
filetype indent on
set so=10

" Set to auto read when a file is changed from the outside
set autoread
syntax enable

" Make Y behave like other capitals
map Y y$

" Do not continue comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Language indentation settings
autocmd FileType go setlocal tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
autocmd FileType nix setlocal tabstop=2 shiftwidth=2

" Do not close the buffer when changing them
set hid

" Wildmenu
set wildmenu
set wildmode=longest:list,full

""""" PLUGIN SETTINGS """""

" Airline
let g:airline_powerline_fonts=1
let g:airline_section_z = '%{strftime("%c")}'
let g:airline_theme = 'base16_nixos_airline_theme'
let g:airline_skip_empty_sections = 1

let g:airline#extensions#tabline#enabled = 1
