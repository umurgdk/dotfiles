local M = {}

local tree = require('nvim-tree')
local api = require('nvim-tree.api')

function M.setup()
    tree.setup({
        sort = {
            -- sorter = 'case_insensitive',
        },
        view = {
            width = 30,
        },
        renderer = {
            -- group_empty = true,
        },
    })

    M.setup_keybindings()
end

function M.setup_keybindings(bufnr)
    vim.api.nvim_set_keymap('n', '<leader>k', ':NvimTreeToggle<cr>', { silent = true, noremap = true })
end

return { setup = M.setup }
