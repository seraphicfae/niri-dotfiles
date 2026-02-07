local vim = vim
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local status, ts = pcall(require, "nvim-treesitter.configs")
            if status then
                ts.setup({
                    ensure_installed = { "lua", "vim", "bash", "markdown" },
                    highlight = { enable = true },
                })
            end
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')

            telescope.setup({
                defaults = {
                    file_ignore_patterns = { "%.cache/.*", "node_modules/.*", "%.git/.*" },
                }
            })

            vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "Find Files" })

            vim.keymap.set('n', '<leader>c', function()
                builtin.find_files({
                    search_dirs = { "~/.config" },
                    hidden = true
                })
            end, { desc = "Search .config" })

            vim.keymap.set('n', '<leader>l', function()
                builtin.find_files({
                    search_dirs = { "~/.local" },
                    hidden = true
                })
            end, { desc = "Search .local" })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                term_colors = true,
                integrations = {
                    telescope = true,
                    treesitter = true,
                    which_key = true,
                }
            })
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    }
})
