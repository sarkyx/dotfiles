local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.autowrite = true
opt.autoindent = true
opt.autoread = true
opt.smartindent = true
opt.gdefault = true
opt.secure = true
opt.undofile = false

opt.relativenumber = true
opt.number = true
opt.wrap = true
opt.list = true
opt.listchars = { tab = '┊ ', trail = '·', nbsp = '␣'}
opt.showbreak = '↳'
opt.scrolloff = 1
opt.sidescrolloff = 4
opt.breakindent = true

opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 0

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = false
opt.signcolumn = 'yes'
opt.cursorline = true

opt.splitright = true
opt.splitbelow = true
