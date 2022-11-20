local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.nu = true

-- tabs & indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true
--opt.hlsearch = false
opt.hidden = true
opt.errorbells = false

-- history settings
opt.swapfile = false
opt.backup = false
opt.undodir = "/home/drsh4dow/.vim/undodir"
opt.undofile = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.colorcolumn = "80"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- misc
opt.iskeyword:append("-")
