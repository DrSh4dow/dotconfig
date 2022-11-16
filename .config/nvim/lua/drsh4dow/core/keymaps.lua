vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- no delete and yank
keymap.set("n", "x", '"_x')

-- remove highlight
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- increment & decrement
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- split windows
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sq", ":close<CR>")


keymap.set("n", "<leader>to", ":tabnew<CR>") -- Open new tab

keymap.set("n", "<leader>tq", ":tabclose<CR>") -- close current tab

keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab

keymap.set("n", "<leader>tp", ":tabp<CR>") -- got to previous tab

-- Plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- Vim-Maximizer
