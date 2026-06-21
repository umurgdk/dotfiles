vim.g.mapleader      = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.expandtab      = true
vim.o.softtabstop    = -1
vim.o.tabstop        = 4
vim.o.shiftwidth     = 4

vim.o.termguicolors  = true
vim.o.exrc           = true
vim.o.number         = true
vim.o.relativenumber = true
vim.o.showmode       = false
vim.o.clipboard      = "unnamedplus"
vim.o.breakindent    = true
vim.o.undofile       = true
vim.o.ignorecase     = true
vim.o.smartcase      = true
vim.o.signcolumn     = "yes"
vim.o.timeoutlen     = 400
vim.o.splitright     = true
vim.o.splitbelow     = true
vim.o.list           = false
vim.o.inccommand     = "split"
vim.o.cursorline     = false
vim.o.scrolloff      = 2
vim.o.foldmethod     = "expr"
vim.o.foldexpr       = "v:lua.require'folding'.foldexpr()"
vim.o.foldlevel      = 999
vim.o.hlsearch       = true
vim.o.mousemodel     = "popup_setpos"

-- Disbale right mouse click
vim.keymap.set({ "n", "v", "i" }, "<RightMouse>", "<Nop>")

-- vim.cmd("set completeopt += noinsert,noselect,menu,menuone,fuzzy,popup,preinsert")
