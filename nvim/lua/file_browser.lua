local mf = require('mini.files')

vim.keymap.set("n", "<leader>k", function()
    if not mf.close() then mf.open() end
end)

local show_dotfiles = false
local filter_show = function() return true end
local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, ".")
end

mf.setup({
    content = { filter = filter_hide },
    windows = { preview = true, width_preview = 50 },
})

local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    mf.refresh({ content = { filter = new_filter } })
end

local map_split = function(buf_id, lhs, direction)
    local rhs = function()
        local cur_target = mf.get_explorer_state().target_window
        local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
        end)

        mf.set_target_window(new_target)
        mf.close()
    end

    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

local with_path = function(cb)
    return function()
        local path = (mf.get_fs_entry() or {}).path
        if path == nil then return vim.notify("Cursor is not on valid entry") end
        cb(path)
    end
end

local set_cwd = with_path(function(path) vim.fn.chdir(vim.fs.dirname(path)) end)
local yank_path = with_path(function(path) vim.fn.setarg(vim.v.register, path) end)
local sys_open = with_path(vim.ui.open)

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesExplorerOpen",
    callback = function()
        mf.set_bookmark("C", "~/.config", { desc = "$HOME/.config" })
        mf.set_bookmark("w", vim.fn.getcwd, { desc = "CWD" })
        mf.set_bookmark("H", "~", { desc = "$HOME" })
    end
})

vim.api.nvim_create_autocmd("User", {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local b = args.data.buf_id
        vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = b, desc = "toggle hidden" })
        vim.keymap.set("n", "g~", set_cwd, { buffer = b, desc = "set cwd" })
        vim.keymap.set("n", "gX", sys_open, { buffer = b, desc = "sys open" })
        vim.keymap.set("n", "gY", yank_path, { buffer = b, desc = "yank path" })
        map_split(b, '<C-x>', 'belowright horizontal')
        map_split(b, '<C-v>', 'belowright vertical')
        map_split(b, '<C-t>', 'tab')
    end,
})
