local lspz = require('lsp-zero')
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')

local M = {}

function M.setup()
    lspz.on_attach(function(client, bufnr)
        M.setup_keybindings(client, bufnr)
    end)

    lspz.format_on_save({
        format_opts = {
            async = false,
            timout_ms = 10000,
        }
    })

    require('lspconfig').rust_analyzer.setup({
        ['rust-analyzer'] = {
            settings = {
                imports = {
                    granularity = {
                        enforce = true,
                    }
                }
            }
        }
    })

    lspz.setup_servers({'lua_ls', 'zls', 'rust_analyzer', 'emmet_language_server', 'dartls', 'sourcekit'})
    lspz.setup()

    M.setup_mason()
end

function M.setup_keybindings(client, bufnr) 
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

function M.setup_mason()
    mason.setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"

            }
        }
    })

    mason_lsp.setup({
        handlers = {
            lspz.default_setup
        },
        ensure_installed = {
            'zls',
            'lua_ls',
            'rust_analyzer',
            -- 'clangd',
        }
    })
end

return { setup = M.setup }
