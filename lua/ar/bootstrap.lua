local fn, o, opt, g, env = vim.fn, vim.o, vim.opt, vim.g, vim.env

g.mapleader = " "
g.maplocalleader = ","
g.projects_dir = env.DEV_HOME or fn.expand("~/personal/workspace/coding")

_G.map = vim.keymap.set

local nnoremap = function(...)
	map("n", ...)
end
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "H", "<cmd>bprevious<CR>", { desc = "previous buffer" })
map("n", "L", "<cmd>bnext<CR>", { desc = "next buffer" })
map("n", "<leader>c", "<cmd>bdel<CR>", { desc = "delete buffer" })
-- Quick find/replace
nnoremap("<leader>[", [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], { desc = "replace all" })
nnoremap("<leader>]", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], { desc = "replace in line" })

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
o.foldlevelstart = 99
o.foldlevel = 99
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
		-- {
		-- 	"abeldekat/lazyflex.nvim",
		-- 	import = "lazyflex.hook",
		-- 	opts = {
		-- 		enable_match = false,
		-- 		kw = { "fzf-lua" },
		-- 	},
		-- },
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",

		{
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			keys = {
				{ "<c-p>", "<cmd>Telescope find_files<cr>", desc = "find files" },
			},
			opts = {},
			config = function(_, opts)
				require("telescope").setup(opts)
				require("telescope").load_extension("smart_open")
			end,
		},
		{
			"danielfalk/smart-open.nvim", -- use fork to get show_scores working
			dependencies = {
				"kkharji/sqlite.lua",
				"nvim-telescope/telescope-fzy-native.nvim",
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
			event = "VimEnter",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					auto_install = true,
					highlight = { enable = true },
					ensure_installed = { "lua" },
				})
			end,
		},
		-- {
		--   'razak17/tailwind-fold.nvim',
		--   opts = { min_chars = 5, symbol = '󱏿' },
		--   ft = {
		--     'html',
		--     'svelte',
		--     'astro',
		--     'vue',
		--     'typescriptreact',
		--     'php',
		--     'blade',
		--     'eruby',
		--     'htmldjango',
		--     'templ',
		--   },
		-- },
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
		{
			"NeogitOrg/neogit",
			cmd = "Neogit",
			dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  -- stylua: ignore
  keys = {
    { '<localleader>gs', function() require('neogit').open() end, desc = 'open status buffer', },
    { '<localleader>gc', function() require('neogit').open({ 'commit' }) end, desc = 'open commit buffer', },
    { '<localleader>gl', function() require('neogit.popups.pull').create() end, desc = 'open pull popup', },
    { '<localleader>gp', function() require('neogit.popups.push').create() end, desc = 'open push popup', },
  },
			opts = {
				disable_signs = false,
				disable_hint = true,
				disable_commit_confirmation = true,
				disable_builtin_notifications = true,
				disable_insert_on_commit = false,
				disable_context_highlighting = true,
				signs = {
					item = { "▸", "▾" },
					hunk = { "樂", "" },
				},
				integrations = {
					diffview = true,
				},
			},
		},
		-- {
		-- 	"ErichDonGubler/lsp_lines.nvim",
		-- 	event = "LspAttach",
		-- 	config = function()
		-- 		require("lsp_lines").setup()
		-- 	end,
		-- },

		{
			"mikesmithgh/kitty-scrollback.nvim",
			enabled = true,
			lazy = true,
			cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
			event = { "User KittyScrollbackLaunch" },
			config = function()
				require("kitty-scrollback").setup()
			end,
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

-- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
	callback = function()
		local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
		if not normal.bg then
			return
		end
		-- io.write(string.format("\027]11;#%06x\027\\", normal.bg))
		io.write(string.format("\027Ptmux;\027\027]11;#%06x\007\027\\", normal.bg)) -- tmux
	end,
})

vim.api.nvim_create_autocmd("UILeave", {
	callback = function()
		-- io.write("\027]111\027\\")
		io.write("\027Ptmux;\027\027]111;\007\027\\") -- tmux
	end,
})
