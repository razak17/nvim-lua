local fn, g, env = vim.fn, vim.g, vim.env

g.mapleader = ' '
g.maplocalleader = ','
g.projects_dir = env.DEV_HOME or fn.expand('~/personal/workspace/coding')

_G.map = vim.keymap.set

if vim.g.neovide then require('ar.neovide') end

require('ar.lazy')
require('ar.mappings')
require('ar.autocommands')

vim.cmd.colorscheme('onedark')
