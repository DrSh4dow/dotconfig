vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- no delete and yank
keymap.set("n", "x", '"_x')
keymap.set("x", "<leader>p", '"_dP')

-- remove highlight
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- increment & decrement
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- visual movement
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- split windows
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sq", ":close<CR>")

-- tab windows
keymap.set("n", "<leader>to", ":tabnew<CR>") -- Open new tab
keymap.set("n", "<leader>tq", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- got to previous tab

-- rare error
keymap.set("i",  "<Tab>", "<Tab>") -- default tab behavior

-- trigger formating
keymap.set("n", "<leader>pp", function()
	vim.lsp.buf.format({
		timeout_ms = 5000,
		-- filter = function(client)
		--  only use null-ls for formatting instead of lsp server
		-- return client.name == "null-ls"
		-- end,
	})
end)

-- Plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- Vim-Maximizer
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- NvimTree Toggle

-- movements
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

-- telescope git
keymap.set("n", "<leader>gh", "<cmd>Telescope git_commits<cr>")
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")
keymap.set("n", "<leader>gc", "<cmd>Telescope git_bcommits<cr>")

-- replace word
vim.keymap.set("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
