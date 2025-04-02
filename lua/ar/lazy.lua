local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  })
end
vim.opt.runtimepath:prepend(lazy_path)

require('lazy').setup({
  spec = { { import = 'ar.plugins' } },
  defaults = { lazy = true },
  git = { timeout = 720 },
  dev = {
    path = vim.g.projects_dir .. '/plugins',
    patterns = { 'razak17' },
    fallback = true,
  },
  checker = {
    enabled = true,
    concurrency = 30,
    notify = false,
    frequency = 3600,
  },
  ui = { border = 'single' },
  performance = { enabled = true },
})

map('n', '<localleader>L', '<cmd>Lazy<CR>', { desc = 'toggle lazy ui' })
