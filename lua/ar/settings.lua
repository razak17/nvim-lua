local o, opt = vim.o, vim.opt

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
