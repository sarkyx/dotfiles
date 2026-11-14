local keymap = vim.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })
