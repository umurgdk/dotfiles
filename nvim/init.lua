vim.pack.add({
    "gh:catppuccin/nvim",
    "gh:nvim-lua/plenary.nvim",
    "gh:MunifTanjim/nui.nvim",
    "gh:s1n7ax/nvim-window-picker",
    "gh:nvim-telescope/telescope.nvim",
    "gh:Saghen/blink.cmp",
    "gh:MeanderingProgrammer/render-markdown.nvim",

    "gh:nvim-orgmode/orgmode",
    "gh:tpope/vim-fugitive",

    -- mini.nvim
    "gh:nvim-mini/mini.nvim",
    -- "gh:ms-jpq/coq_nvim",

    -- Treesitter
    "gh:nvim-tree/nvim-tree.lua",
    "gh:nvim-treesitter/nvim-treesitter",

    -- DAP
    "gh:mfussenegger/nvim-dap",
    "gh:rcarriga/nvim-dap-ui",
    "gh:nvim-neotest/nvim-nio",
})

require('options')
require('keybind')
require('autocmds')

require('catppuccin').setup({})

require('telescope').setup({
    defaults = {
        results_title = false,
        prompt_title = false,
        dynamic_preview_title = true,
        path_display = {
            shorten = 2,
            smart = {},
        },
        border = true,
        selection_caret = "",
        entry_prefix = "",
        wrap_results = false,
        sorting_strategy = 'ascending',
        borderchars = {
            prompt = { " " },
            results = { " " },
            preview = { " " },
        },
        layout_strategy = 'flex',
        layout_config = {
            width = { padding = 0 },
            height = { padding = 0 },
            prompt_position = "top",
            vertical = {
                mirror = true,
            },
            horizontal = {
                preview_width = 0.60
            },
        },
    },
})

require('mini.pairs').setup()
require('mini.icons').setup({ style = "glyph" })
require("mini.notify").setup({})
require('mini.align').setup()
require('mini.bracketed').setup({})


local ms = require("mini.snippets")
ms.setup()

vim.keymap.set("i", "<C-h>", function()
    if ms.session.get() ~= nil then
        ms.session.jump("prev")
    end
end, { desc = "snippet or nop" })
vim.keymap.set("i", "<C-l>", function()
    if ms.session.get() ~= nil then
        ms.session.jump("next")
    end
end, { desc = "snippet or nop" })

local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        -- Leader triggers
        { mode = { 'n', 'x' }, keys = '<Leader>' },

        -- `[` and `]` keys
        { mode = 'n',          keys = '[' },
        { mode = 'n',          keys = ']' },

        -- Built-in completion
        { mode = 'i',          keys = '<C-x>' },

        -- `g` key
        { mode = { 'n', 'x' }, keys = 'g' },

        -- Marks
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },

        -- Registers
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },

        -- Window commands
        { mode = 'n',          keys = '<C-w>' },

        -- `z` key
        { mode = { 'n', 'x' }, keys = 'z' },
    },
    clues = {
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    }
});

require('orgmode').setup({})

-- Setup mini.files and extra configuration
require("file_browser")

-- require("markdown").setup({})

vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

local colorscheme_file = vim.fn.expand("$HOME") .. "/.local/state/darkman/colorscheme"

local function read_colorscheme()
  local f = io.open(colorscheme_file, "r")
  if not f then return nil end
  local content = f:read("*l")
  f:close()
  if content == "dark" then return "dark_mono" end
  if content == "light" then return "light_mono" end
  return nil
end

local function apply_colorscheme()
  local cs = read_colorscheme() or "dark_mono"
  if vim.g.colors_name ~= cs then
    vim.cmd.colorscheme(cs)
  end
end

local handle = vim.uv.new_fs_event()
handle:start(colorscheme_file, { watch_entry = true }, vim.schedule_wrap(function()
  apply_colorscheme()
end))

apply_colorscheme()

-------------------------------------------------------------------------------
-- region: Configure DAP Debug Adapter Protocol
--
local dap, dapui = require("dap"), require("dapui")

dap.adapters.lldb = {
    type = "executable",
    command = "lldb-dap",
    name = "lldb",
}

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end
