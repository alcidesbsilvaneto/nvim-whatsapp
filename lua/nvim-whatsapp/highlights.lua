local M = {}

M.setup = function()
	-- set custom highlights
	vim.api.nvim_set_hl(
		0,
		"NvimWhatsappChatSenderName",
		{ fg = "#b4befe", italic = true, bold = false, default = true }
	)
end

return M
