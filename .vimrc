""""""""""""""""""""""""""""""
"
" Package Management
"

  packadd! dracula

""""""""""""""""""""""""""""""
"
" General Configuration
"

  set encoding=utf-8
  set wildmenu
  filetype plugin on
  

  
"
" Display
"

  set ls=2
  set showmode
  set showcmd
  set modeline
  set ruler
  set title
  set nu rnu

  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"

"
" Line Wrapping
"

  set nowrap
  set linebreak
  set showbreak=▹

"
" Searching
"

  set ignorecase
  set smartcase
  set gdefault
  set hlsearch
  set showmatch

"
"  Indentation
"

  set autoindent
  set shiftwidth=4
  set tabstop=4
  set softtabstop=4
  set shiftround
  set expandtab

""""""""""""""""""""""""""""""
"
"	Theming Stuff
"

  set termguicolors
  syntax enable
  colorscheme dracula


""""""""""""""""""""""""""""""
"
"  Plugins Configuration
"

"
"  Syntastic
"
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0

"
" Rust.Vim
"

  let g:rustfmt_autosave = 1

 

""""""""""""""""""""""""""""""
"
" Keybindings
"

  map º <Esc>:NERDTreeToggle<CR>
  nmap <silent> <A-Up> :wincmd k<CR>
  nmap <silent> <A-Down> :wincmd j<CR>
  nmap <silent> <A-Left> :wincmd h<CR>
  nmap <silent> <A-Right> :wincmd l<CR>

" Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-@> coc#refresh()






