local ui = require("nvim-whatsapp.ui")

local M = {}

local FocusChat = function()
	vim.api.nvim_set_current_win(ui.nui_chat_popup.winid)
end

local FocusTicketsList = function()
	vim.api.nvim_set_current_win(ui.nui_tickets_list_popup.winid)
end

local FocusMessageInput = function()
	vim.api.nvim_set_current_win(ui.nui_message_input.winid)
end

M.FocusChat = FocusChat
M.FocusTicketsList = FocusTicketsList
M.FocusMessageInput = FocusMessageInput

return M
