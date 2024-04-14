local pkg = require('packages')
pkg.ensure_installed()
pkg.setup()

vim.g.mapleader = ","

-- require('treesitter').setup()
require('lsp').setup()
require('completion').setup()
require('filetree').setup()

require('reload_init')

vim.o.termguicolors = true        -- enable 24-bit RGB color in the TUI
vim.cmd.colorscheme('duskfox')

-- vim.o.clipboard = 'unnamedplus'
-- vim.o.completeopt = {'menu', 'menuone', 'noselect'}

-- Typing: Indentation
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- User Interface
vim.wo.number = true               -- show absolute number
vim.wo.relativenumber = true       -- add numbers to each line on the left side
vim.o.cursorline = true           -- highlight cursor line underneath the cursor horizontally
vim.o.splitbelow = true           -- open new vertical split bottom
vim.o.splitright = true           -- open new horizontal splits right
vim.o.showmode = false            -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.o.incsearch = true            -- search as characters are entered
vim.o.hlsearch = false            -- do not highlight matches
vim.o.ignorecase = true           -- ignore case in searches by default
vim.o.smartcase = true            -- but make it case sensitive if an uppercase is entered


vim.o.smartindent = true
vim.o.wrap = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.o.undofile = true

vim.wo.signcolumn = "yes"
vim.o.scrolloff = 8
vim.o.updatetime = 50

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'


-- Setup format on save
local format_on_save = require('format-on-save')
local formatters = require('format-on-save.formatters')

format_on_save.setup({
    exclude_path_patterns = {
        "/node_modules/",
    },
    formatter_by_ft = {
        rust = formatters.lsp,
    },
})

