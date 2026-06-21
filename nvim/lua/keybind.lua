local function map_n(lhs, desc, rhs, opts)
    vim.keymap.set('n', lhs, rhs, vim.tbl_deep_extend("force", { desc = desc }, opts or {}))
end

local function map_v(lhs, desc, rhs, opts)
    vim.keymap.set('v', lhs, rhs, vim.tbl_deep_extend("force", { desc = desc }, opts or {}))
end

local function map_i(lhs, desc, rhs, opts)
    vim.keymap.set('i', lhs, rhs, vim.tbl_deep_extend("force", { desc = desc }, opts or {}))
end

local function map_t(lhs, desc, rhs)
    vim.keymap.set('t', lhs, rhs, { desc = desc })
end

map_n("<Esc>", "clear search hl", "<cmd>nohlsearch<CR>")

map_n("[d", "diagnostic prev", function()
    vim.diagnostic.jump({ count = -1 })
    vim.schedule(vim.diagnostic.open_float)
end)

map_n("]d", "diagnostic next", function()
    vim.diagnostic.jump({ count = 1 })
    vim.schedule(vim.diagnostic.open_float)
end)

map_n("<leader>de", "diagnostic show", vim.diagnostic.open_float)
map_n("<leader>dq", "diagnostic quicklist", vim.diagnostic.setqflist)

map_t("<Esc><Esc>", "terminal exit", "<C-\\><C-n>")

map_n("<C-h>", "focus left", "<C-w><C-h>")
map_n("<C-l>", "focus right", "<C-w><C-l>")
map_n("<C-j>", "focus lowerwindow", "<C-w><C-j>")
map_n("<C-k>", "focus upper", "<C-w><C-k>")

map_t("<C-h>", "focus left", "<C-\\><C-w><C-h>")
map_t("<C-l>", "focus right", "<C-\\><C-w><C-l>")
map_t("<C-j>", "focus lowerwindow", "<C-\\><C-w><C-j>")
map_t("<C-k>", "focus upper", "<C-\\><C-w><C-k>")

local tele = require("telescope.builtin")
map_n("<leader>sf", "search files", tele.find_files)
map_n("<leader>si", "search files noignore", function()
    tele.find_files({ no_ignore = true, hidden = true })
end)
map_n("<leader>sg", "grep files", tele.live_grep)
map_n("<leader> ", "search buffers", tele.buffers)
map_n("<leader>sh", "search help", tele.help_tags)
map_n("<leader>sn", "search nvim", function()
    tele.find_files({ cwd = vim.fn.expand("~") .. "/.config/nvim" })
end)

-- map_i("<Tab>", "select completion", function()
--     return vim.fn.pumvisible() == 1 and '<C-y>' or '<Tab>'
-- end, { expr = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp.keybind", {}),
    callback = function(ev)
        map_n("<leader>ca", "code actions", vim.lsp.buf.code_action, { buffer = ev.buf })
        map_n("<leader>rn", "code rename", vim.lsp.buf.rename, { buffer = ev.buf })
        map_n("<leader>gr", "code references", tele.lsp_references, { buffer = ev.buf })
        map_n("<leader>ds", "buffer symbols", tele.lsp_document_symbols, { buffer = ev.buf })
        map_n("<leader>ws", "workspace symbols", tele.lsp_workspace_symbols, { buffer = ev.buf })

        map_i("<C-space>", "autocomplete", vim.lsp.completion.get, { buffer = ev.buf })

        map_n("gd", "goto definition", function()
            vim.lsp.buf.definition({ reuse_win = true })
        end, { buffer = ev.buf })

        map_n("gD", "goto definition split", function()
            vim.cmd("vsplit")
            vim.lsp.buf.definition({ reuse_win = true })
        end, { buffer = ev.buf })

        map_n("K", "code hover", vim.lsp.buf.hover, { buffer = ev.buf })
        map_v("}", "select more", function()
            vim.lsp.buf.selection_range(1, 100)
        end, { buffer = ev.buf })
        map_v("{", "select less", function()
            vim.lsp.buf.selection_range(-1, 100)
        end, { buffer = ev.buf })
    end
})

local dap = require("dap")
map_n("<C-Down>", "debug step over", function() dap.step_over() end)
map_n("<C-Right>", "debug step into", function() dap.step_into() end)
map_n("<C-Up>", "debug step out", function() dap.step_out() end)
map_n("<leader>dc", "debug continue", function() dap.continue() end)
map_n("<leader>db", "debug toggle breakpoint", function() dap.toggle_breakpoint() end)
map_n("<leader>dB", "debug set breakpoint cond", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
map_n("<leader>dr", "debug restart", function() dap.restart() end)
map_n("<leader>dq", "debug terminate", function() dap.terminate() end)
