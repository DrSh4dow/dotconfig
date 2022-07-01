""""""""""""""""""""""""""""""""""""""""
"           SET CONFIGS                "
""""""""""""""""""""""""""""""""""""""""

" Tab settings
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" exrc, if there is a vimrc inside a directory it will source it
set exrc

" Relative numbers is self explanatory, nu set the current line number instead
" of 0
set relativenumber
set nu

" No Highlight after find
set nohlsearch
set hidden
set noerrorbells
set nowrap

" About history
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" Search
set incsearch

" Moar config
set scrolloff=8
set colorcolumn=80
set signcolumn=yes
set termguicolors
set background=dark
set clipboard+=unnamedplus



""""""""""""""""""""""""""""""""""""""""
"               PLUGINS                "
""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Telescope and dependencies
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'

" Theme
Plug 'gruvbox-community/gruvbox'

" LSPCONFIG
" Plug 'neovim/nvim-lspconfig'

call plug#end()

colorscheme gruvbox
