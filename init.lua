local fn, o, opt, g, env = vim.fn, vim.o, vim.opt, vim.g, vim.env

g.mapleader = " "
g.maplocalleader = ","
g.projects_dir = env.DEV_HOME or fn.expand("~/personal/workspace/coding")

_G.map = vim.keymap.set

map("n", "<leader>q", "<cmd>q<CR>")
map("n", "H", "<cmd>bprevious<CR>", { desc = "previous buffer" })
map("n", "L", "<cmd>bnext<CR>", { desc = "next buffer" })
map("n", "<leader>c", "<cmd>bdel<CR>", { desc = "delete buffer" })

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
o.foldlevelstart = 3
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

local lazy_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
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

require("lazy").setup({
	spec = {
		{
			"razak17/onedark.nvim",
			lazy = false,
			priority = 1000,
			opts = { variant = "fill" },
			config = function(_, opts)
				require("onedark").setup(opts)
			end,
		},
		{
			"abeldekat/lazyflex.nvim",
			import = "lazyflex.hook",
			opts = {
				enable_match = false,
				kw = { "fzf-lua" },
			},
		},
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",

		{
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			config = function()
				require("telescope").setup({})
				vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
			end,
			dependencies = {
				{
					"natecraddock/telescope-zf-native.nvim",
					config = function()
						require("telescope").load_extension("zf-native")
					end,
				},
			},
		},

		{
			"ibhagwan/fzf-lua",
			cmd = "FzfLua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			keys = {
				{ "<leader>ff", "<Cmd>FzfLua files<CR>", desc = "find files" },
				{ "<leader>fs", "<Cmd>FzfLua live_grep<CR>", desc = "live grep" },
			},
			config = function()
				vim.api.nvim_set_hl(0, "FzfLuaNormal", { fg = "#ffff00", bg = "#ff0000" })
				vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#ffff00", bg = "#ff0000" })

				local fzf = require("fzf-lua")
				fzf.setup()
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
		{
			"nvim-treesitter/nvim-treesitter",
			event = "BufReadPost",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					auto_install = true,
					highlight = { enable = true },
					ensure_installed = { "lua" },
				})
			end,
		},
		{
			"chrisgrieser/nvim-origami",
			event = "BufReadPost",
			keys = {
				{
					"<BS>",
					function()
						require("origami").h()
					end,
					desc = "toggle fold",
				},
			},
			opts = { setupFoldKeymaps = false },
		},
	},
	defaults = { lazy = true },
	git = { timeout = 720 },
	dev = {
		path = vim.g.projects_dir .. "/plugins",
		patterns = { "razak17" },
		fallback = true,
	},
	ui = { border = "single" },
	performance = { enabled = true },
})

map("n", "<localleader>L", "<cmd>Lazy<CR>", { desc = "toggle lazy ui" })

vim.cmd.colorscheme("onedark")

if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_cursor_vfx_mode = "railgun"
	-- vim.opt.guifont = { 'Operator Mono SSm Lig Book:h8', ':h14' }
	vim.o.guifont = "Operator Mono SSm Lig Book:h9" -- text below applies for VimScript
	vim.g.neovide_input_macos_alt_is_meta = true
	vim.opt.linespace = 0
end
