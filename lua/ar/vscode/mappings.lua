local vscode = require("vscode")
local map = vim.keymap.set

vim.notify = vscode.notify

vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

-- local function open_which_key_in_visual_mode()
-- 	vim.cmd("normal! gv")
-- 	local visualmode = vim.fn.visualmode()
-- 	if visualmode == "V" then
-- 		local start_line = vim.fn.line("v")
-- 		local end_line = vim.fn.line(".")
-- 		vscode.action("whichkey.show", {
--       range = { start_line, end_line },
--     })
-- 	else
-- 		local start_pos = vim.fn.getpos("v")
-- 		local end_pos = vim.fn.getpos(".")
-- 		vscode.action("whichkey.show", { args = { start_pos[1], end_pos[1], start_pos[2], end_pos[2], 1 } })
-- 	end
-- end

map("n", "<Space>", function() vscode.action("whichkey.show")
end, { silent = true })

-- map("x", "<Space>", function()
-- 	open_which_key_in_visual_mode()
-- end, { silent = true })

map("x", "p", "pgvy")
map("v", "<leader>p", '"_dP', { desc = "greatest remap" })
map("n", "<tab>", "<Cmd>Tabnext<CR>")
map("n", "<S-tab>", "<Cmd>Tabprevious<CR>")
map("n", "<leader>qq", "<Cmd>Tabclose<CR>")

-- add space line
map("n", "]<space>", "<Cmd>put =repeat(nr2char(10), v:count1) <Bar> '[-1<CR>")
map("n", "[<space>", "<Cmd>put! =repeat(nr2char(10), v:count1) <Bar> ']+1<CR>")

map({ "n", "x" }, "<C-h>", function()
	vscode.action("workbench.action.navigateLeft")
end, { silent = true })
map({ "n", "x" }, "<C-j>", function()
	vscode.action("workbench.action.navigateDown")
end, { silent = true })
map({ "n", "x" }, "<C-k>", function()
	vscode.action("workbench.action.navigateUp")
end, { silent = true })
map({ "n", "x" }, "<C-l>", function()
	vscode.action("workbench.action.navigateRight")
end, { silent = true })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<leader>nf", function()
	vscode.call("workbench.action.files.newUntitledFile")
end, { desc = "New file" })

map("n", "<leader>fs", function()
	vscode.call("workbench.action.findInFiles")
end, { desc = "Search in files" })

map("n", "[h", function()
	vscode.call("workbench.action.editor.previousChange")
end, { desc = "Previous change" })
map("n", "]h", function()
	vscode.call("workbench.action.editor.nextChange")
end, { desc = "Next change" })
