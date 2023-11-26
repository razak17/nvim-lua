local api, fn = vim.api, vim.fn

api.nvim_create_augroup("AttachWinbar", {})
api.nvim_create_autocmd({
	"BufWinEnter",
	"TabNew",
	"TabEnter",
	"BufEnter",
	"WinClosed",
}, {
	group = "AttachWinbar",
	callback = function()
    local bufname = api.nvim_buf_get_name(api.nvim_get_current_buf())
    local filepath = fn.fnamemodify(bufname, ':p:.')
		vim.wo.winbar = filepath
	end,
})
