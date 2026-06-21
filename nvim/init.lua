local colorscheme = "catppuccin"

vim.pack.add({
    "gh:catppuccin/nvim",
    "gh:nvim-lua/plenary.nvim",
    "gh:MunifTanjim/nui.nvim",
    "gh:s1n7ax/nvim-window-picker",
    "gh:nvim-telescope/telescope.nvim",
    "gh:Saghen/blink.cmp",
    "gh:MeanderingProgrammer/render-markdown.nvim",

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
require('nvim-treesitter').setup({})

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

-- Setup mini.files and extra configuration
require("file_browser")
require("blink.cmp").setup({
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "normal" },
    snippets = { preset = "mini_snippets" },
    sources = {
        default = { "lsp", "path", "snippets" },
        providers = {
            path = {
                opts = {
                    get_cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                },
            },
        },
    },
    fuzzy = {
        sorts = {
            "exact",
            "score",
            "sort_text",
        },
        implementation = "prefer_rust_with_warning",
    },
    signature = {
        enabled = true,
        window = {
            border = "single",
        }
    },
    completion = {
        ghost_text = { enabled = true },
        keyword = { range = "full" },
        trigger = {
            show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        },
        menu = {
            border = "single",
            draw = {
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                            return kind_icon
                        end
                    }
                }
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
            window = { border = "single" },
        }
    }
})

-- require("markdown").setup({})

vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

vim.cmd.colorscheme(colorscheme)

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "kotlin", "lua", "c", "cpp", "swift", "zig" },
    callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.require'folding'.foldexpr()"
        vim.wo.foldmethod = "expr"

        local indentexpr = require('nvim-treesitter').indentexpr()
        if indentexpr ~= 0 then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end
})

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

-------------------------------------------------------------------------------
-- Configure LSP
--
local lsp = vim.lsp
local blink = require("blink.cmp")
local capabilities = lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities({}, false))
capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = {
        foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
    }
})

lsp.config("*", { capabilities = capabilities })

function lsp_config(name, opts)
    lsp.config(name, opts)
    lsp.enable(name)
end

lsp_config("kotlin-lsp", {
    cmd = {
        "/data/devtools/lsp/kotlin-lsp-262.1668.0-linux-x64/kotlin-lsp.sh",
        "--stdio"
    },
    filetypes = { "kotlin" },
    root_markers = { "settings.gradle.kts", "build.gradle.kts", ".git" },
})

lsp_config("zls", {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_markers = { "build.zig" },
})

lsp_config("lua_ls", {
    cmd = { "/data/devtools/lsp/lua-language-server-3.17.1/bin/lua-language-server" },
    filetypes = { "lua" },
    root_markers = { "init.lua" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end
})

vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        -- Get the detaching client
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Remove the autocommand to format the buffer on save, if it exists
        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({
                event = 'BufWritePre',
                buffer = args.buf,
            })
        end
    end
})
