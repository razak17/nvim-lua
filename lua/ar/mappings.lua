local nnoremap = function(...) map('n', ...) end
map('n', '<leader>qq', '<cmd>q<CR>')
nnoremap('<leader>Q', ':qa!<CR>', { desc = 'force quit all', silent = true })
map('n', 'H', '<cmd>bprevious<CR>', { desc = 'previous buffer' })
map('n', 'L', '<cmd>bnext<CR>', { desc = 'next buffer' })
map('n', '<leader>c', '<cmd>bdel<CR>', { desc = 'delete buffer' })
-- Quick find/replace
nnoremap(
  '<leader>[',
  [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]],
  { desc = 'replace all' }
)
nnoremap(
  '<leader>]',
  [[:s/\<<C-r>=expand("<cword>")<CR>\>/]],
  { desc = 'replace in line' }
)
nnoremap('[<space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]], {
  desc = 'add space above',
})
