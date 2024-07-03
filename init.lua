if vim.g.vscode then
	require("ar.vscode.bootstrap")
	require("ar.vscode")
else
	require("ar.bootstrap")
end
