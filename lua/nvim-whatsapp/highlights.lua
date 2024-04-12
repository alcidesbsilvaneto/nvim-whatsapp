local M = {}

M.setup = function()
	-- set custom highlights
	vim.api.nvim_set_hl(
		0,
		"NvimWhatsappChatSenderName",
		{ fg = "#b4befe", italic = true, bold = false, default = true }
	)

	vim.api.nvim_set_hl(
		0,
		"NvimWhatsappSelectedTicket",
		{ fg = "#b4befe", italic = true, bold = false, default = true }
	)

	vim.api.nvim_set_hl(
		0,
		"NvimWhatsappTicketListItemId",
		{ fg = "#928374", italic = true, bold = false, default = true }
	)

	vim.api.nvim_set_hl(
		0,
		"NvimWhatsappTicketListItemName",
		{ fg = "#FFFFFF", italic = true, bold = false, default = true }
	)

	vim.api.nvim_set_hl(
		0,
		"NvimWhatsappTicketListItemUnread",
		{ fg = "#25cf4d", italic = true, bold = false, default = true }
	)
end

return M
