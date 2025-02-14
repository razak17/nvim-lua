-- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
    if not normal.bg then return end
    -- io.write(string.format("\027]11;#%06x\027\\", normal.bg))
    io.write(string.format('\027Ptmux;\027\027]11;#%06x\007\027\\', normal.bg)) -- tmux
  end,
})

vim.api.nvim_create_autocmd('UILeave', {
  callback = function()
    -- io.write("\027]111\027\\")
    io.write('\027Ptmux;\027\027]111;\007\027\\') -- tmux
  end,
})
