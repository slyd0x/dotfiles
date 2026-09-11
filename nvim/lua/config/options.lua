local opt = vim.opt

-- Line numbers & layout
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search & behavior
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"
