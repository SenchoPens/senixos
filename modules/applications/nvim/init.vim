" Set ergonomic <leader> key
let mapleader = ","

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
" ignore case in search if no capitals 
set ignorecase
" don't ignore if there is a capital
set smartcase

" Allow easy navigation between wrapped lines.
vmap j gj
vmap k gk
nmap j gj
nmap k gk

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
highlight clear SignColumn
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Autowrite on disk on buffer switching, exit, etc
set autowrite

" If opening buffer, search first in opened windows.
set switchbuf=usetab

filetype plugin on
filetype indent on
set scrolloff=7

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
autocmd FileType hs setlocal tabstop=2 shiftwidth=2
autocmd FileType haskell setlocal tabstop=2 shiftwidth=2

" Do not close the buffer when changing them
set hid

" Wildmenu
set wildmenu
set wildmode=longest:list,full

" Remove blank line below statusline
set cmdheight=1

""""" PLUGINS """""

" airline
let g:airline_powerline_fonts=1
let g:airline_section_z = '%{strftime("%c")}'
let g:airline_theme = 'minimalist'
let g:airline_skip_empty_sections = 1
" don't show mode outside of statusbar
set noshowmode

let g:airline#extensions#tabline#enabled = 1

" vim-polyglot
let g:polyglot_disabled = ['tex', 'autoindent']

" vimtex
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
  \ 'build_dir' : '.latexmk',
  \ 'callback' : 1,
  \ 'continuous' : 1,
  \ 'executable' : 'latexmk',
  \ 'hooks' : [],
  \ 'options' : [
  \   '-verbose',
  \   '-file-line-error',
  \   '-synctex=1',
  \   '-interaction=nonstopmode',
  \ ],
\}
set conceallevel=1
let g:tex_conceal='abdmg'

" Limelight
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
" Default: 0.5
let g:limelight_default_coefficient = 0.7
" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 1

" Completion-nvim
" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
" Default is wierd pink
highlight Pmenu ctermbg=gray guibg=gray

" Vim-vsnip
" Without this, j and k move selection in Select mode
let g:completion_enable_snippet = 'vim-vsnip'
smap j j
smap k k
" Expand or jump
imap <expr> <C-l>  vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>  vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

set background=dark
let base16colorspace=256
