" let g:python3_host_prog = '/usr/local/bin/python3'

call plug#begin('~/.vim/plugged')

" Languages
" Plug 'alaviss/nim.nvim', { 'for': 'elm'}
Plug 'lambdatoast/elm.vim', {'for':'elm'}
Plug 'rust-lang/rust.vim', { 'for': 'rust'}
Plug 'jimenezrick/vimerl', { 'for': 'erlang'}
Plug 'cespare/vim-toml', { 'for': 'toml'}
Plug 'google/vim-maktaba', {'for': 'python'}
Plug 'google/vim-codefmt', {'for': 'python'}
Plug 'google/vim-glaive', {'for': 'python'}
Plug 'ziglang/zig.vim', {'for': 'zig'}
Plug 'udalov/kotlin-vim', {'for': 'kotlin'}
Plug 'jparise/vim-graphql'
Plug 'jaawerth/fennel-nvim'
" Languages

Plug 'AndrewRadev/linediff.vim'

Plug 'Chiel92/vim-autoformat'
Plug 'srcery-colors/srcery-vim'
" Plug 'airblade/vim-rooter'
Plug 'kylef/apiblueprint.vim'
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-rhubarb'
Plug 'benekastah/neomake'
Plug 'jpalardy/vim-slime'
Plug 'previm/previm'
Plug 'tyru/open-browser.vim'
Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
Plug 'scrooloose/vim-slumlord'
Plug 'aklt/plantuml-syntax'
Plug 'nanotech/jellybeans.vim'
Plug 'chr4/sslsecure.vim'
Plug 'zackhsi/sorbet.vim'
" Plug 'junegunn/fzf.vim'
Plug 'lotabout/skim'
Plug 'lotabout/skim.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-flagship'
" Plug 'itchyny/lightline.vim'
Plug 'vimwiki/vimwiki'
Plug 'fatih/vim-go', { 'for': 'go'}
" Plug 'ycm-core/YouCompleteMe'
Plug 'rhysd/vim-grammarous'

Plug 'tpope/vim-sensible'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Colorschemes
Plug 'itchyny/landscape.vim'
Plug 'morhetz/gruvbox'
" Plug 'elixir-lang/vim-elixir'
Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
Plug 'tpope/vim-rails'
Plug 'tpope/vim-commentary'
"
Plug 'godlygeek/Tabular'
Plug 'tmhedberg/matchit'
Plug 'editorconfig/editorconfig-vim'
" Plug 'roman/golden-ratio'

call plug#end()

set nocompatible
set wildmode=full
set wildmenu

" allow plugins by file type
filetype on
filetype plugin on
filetype indent on

" tabs and spaces handling
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" always show status bar
set ls=2

" incremental search
set incsearch "Highlight as you type
set hidden    "Handle multiple buffers better
set ignorecase " Case-insensitive searching.
set smartcase " But case-sensitive if expression contains a capital letter.
set swapfile
set directory=~/tmp,/var/tmp,/tmp

" highlighted search results
set hlsearch

" line numbers
set number

syntax on

"set t_Co=256
scriptencoding utf-8
set encoding=utf-8

" After write, remove trailling whitespaces
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre *.go :GoImports

set backspace=indent,eol,start

" Required:
filetype plugin indent on

colorscheme elflord
let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ]]
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
      \ },
      \ }

"""" lightline.vim""""""""
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8

let g:slime_target = "tmux"
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    "   " render properly when inside 256-color tmux and GNU screen.
    "     " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif


augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

set mouse=
set modelines=0
set modeline

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
if executable('rg')
  set grepprg=rg\ --color=never
endif


nnoremap ,f :Files<CR>
nnoremap ,b :Buffers<CR>
let g:skim_layout = { 'down': '~40%' }

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

set splitright
set splitbelow

" command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'ctrl-h'))

" let g:go_metalinter_command='golangci-lint run --print-issued-lines=false --build-tags  --exclude-use-default=false -E maligned ./...'
