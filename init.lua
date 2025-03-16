if vim.g.vscode then
  local opt = vim.opt
  local config = vim.fn.stdpath('config')
  opt.rtp:remove(config .. '/plugin')
  opt.rtp:remove(config .. '/after')
  opt.rtp:remove(config .. '/after/plugin')
	require("ar.vscode")
	require("ar.vscode.mappings")
else
	require("ar.bootstrap")
end
