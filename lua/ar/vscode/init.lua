local fn = vim.fn

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local lazy_path = fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazy_path) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

require('lazy').setup({
  spec = { import = 'ar.vscode.plugins' },

  defaults = { lazy = true },
  change_detection = { notify = false },
  git = { timeout = 720 },
})
