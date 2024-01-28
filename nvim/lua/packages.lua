return {
    setup = function()
        require('lazy').setup({
            {'folke/tokyonight.nvim'},

            {'nvim-tree/nvim-tree.lua'},


            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            {'stewartimel/Metal-Vim-Syntax-Highlighting'},
            {'cormacrelf/vim-colors-github'},
            {
                'echasnovski/mini.pairs',
                version = '*',
                config = function ()
                    require('mini.pairs').setup()
                end
            },

            {
                'numToStr/Comment.nvim',
                opts = { },
                lazy = false,
                config = function ()
                    require('Comment').setup()

                    local ft = require('Comment.ft')
                    ft.set('objc', {'//%s', '/*%s*/'})
                end,
            },

            {
                'nvim-treesitter/nvim-treesitter',
                config = function ()
                    local config = require('nvim-treesitter.configs')
                    config.setup({
                        ensure_installed = {'lua', 'c', 'objc', 'zig', 'rust'},
                        highlight = { enable = true, },
                        indent = { enable = true, },
                    })
                end
            },

            {
                'nvim-telescope/telescope.nvim',
                tag = '0.1.5',
                dependencies = {
                    'nvim-lua/plenary.nvim',
                    {
                        'nvim-telescope/telescope-fzf-native.nvim',
                        build = 'make',
                    }
                },
                config = function()
                    local telescope = require('telescope')
                    local actions = require('telescope.actions')

                    telescope.setup({
                        defaults = {
                            mappings = {
                                i = {
                                    ['<C-p>'] = actions.move_selection_previous,
                                    ['<C-n>'] = actions.move_selection_next,
                                    ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                                }
                            }
                        }
                    })

                    -- telescope.load_extension('fzf')


                    -- setup keymaps
                    local km = vim.keymap
                    km.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy file finder in cwd' })
                end
            },


            -- LSP Support
            {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x', lazy = true, config = false },
            {'neovim/nvim-lspconfig', dependencies = {
                {'hrsh7th/cmp-nvim-lsp'},
            } },

            -- Autocompletion
            {'hrsh7th/nvim-cmp', dependencies = {
                {'L3MON4D3/LuaSnip'},
            } },
        })
    end,


    ensure_installed = function()
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
            vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
            })
        end
        vim.opt.rtp:prepend(lazypath)
    end,
}
