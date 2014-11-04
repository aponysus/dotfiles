" Launch Config {{{
call pathogen#infect()
" }}}

" Colors {{{
syntax enable	        " enable syntax processing
colorscheme DevC++	    " colors 
" }}}

" Spaces and Tabs {{{
set tabstop=4	        " number of visual spaces per TAB
set softtabstop=4	    " number of spaces in TAB when editing
set expandtab	        " tabs are spaces
set shiftwidth=4
" }}}

" UI Layout {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set showmode            " show current mode at bottom
set cursorline          " highlight current line
set visualbell          "No sounds
set autoread
" Allow backspace in insert mode
set backspace=indent,eol,start

filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to
set showmatch           " highlight matching [{()}]
" }}}

" Search {{{
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase

" turn off search highlight - map to ,<space>
nnoremap <leader><space> :nohlsearch<CR>
" }}}

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max

" space open/closes folds
nnoremap <space> za

set foldmethod=indent   " fold based on indent level
set modelines=1
" }}}

" Movement {{{
nnoremap j gj
nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]
" }}}

" Leader Shortcuts {{{
let mapleader=","       " leader is comma

" jk is escape
inoremap jk <esc>

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" edit vimrc and load vimrc bindings
nnoremap <leader>ev :tabedit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session
nnoremap <leader>s :mksession<CR>
" }}}

" Backups {{{
set backup
set backupdir=~/.vim/.tmp
set directory=~/.vim/.tmp
set writebackup
" }}}

" vim:foldmethod=marker:foldlevel=0
