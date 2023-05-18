local o, g = vim.o, vim.g

g.mapleader = " "
g.maplocalleader = ","

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", 'H', '<cmd>bprevious<CR>', { desc = 'previous buffer' })
vim.keymap.set("n", 'L', '<cmd>bnext<CR>', { desc = 'next buffer' })

o.udir = vim.call("stdpath", "cache") .. "/undodir"
o.viewdir = vim.call("stdpath", "cache") .. "/view"
o.undofile = true
o.wrap = false
o.wrapmargin = 2
o.autoindent = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = -1
o.smartindent = true

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazy_path,
	})
end
vim.opt.runtimepath:prepend(lazy_path)

local lazy_opts = {
	defaults = { lazy = true },
	git = { timeout = 720 },
	ui = { border = "single" },
	performance = { enabled = true },
}

require("lazy").setup({
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"razak17/onedark.nvim",

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		config = function()
			require("telescope").setup({})
			vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
		end,
	},
	{
		"xiyaowong/accelerated-jk.nvim",
		event = "VeryLazy",
		config = function()
			require("accelerated-jk").setup({
				mappings = { j = "gj", k = "gk" },
			})
		end,
	},
}, lazy_opts)

vim.cmd.colorscheme("onedark")
