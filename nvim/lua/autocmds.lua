vim.api.nvim_create_autocmd('TextYankPost', {
    desc = "Briefly highlight yanked text",
    callback = function() vim.hl.on_yank() end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

require('lang.zig')
require('lang.slang')
