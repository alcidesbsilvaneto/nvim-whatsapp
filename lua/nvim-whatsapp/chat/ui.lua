local NuiLine = require("nui.line")
local chat_util = require("nvim-whatsapp.chat.util")
local ui = require("nvim-whatsapp.ui")

local M = {}

M.build_nui_line = function(message)
	local line = NuiLine()
	local finalMessage = message.message:gsub("^(.-):", "")
	finalMessage = finalMessage:gsub("^%*", "")
	finalMessage = finalMessage:gsub("\n", "")

	if message.is_mine then
		line:append("Você: ", "NvimWhatsappChatSenderName")
	else
		if message.sender_name then
			line:append(message.sender_name .. ": ", "NvimWhatsappChatSenderName")
		else
			line:append("Desconhecido: ", "NvimWhatsappChatSenderName")
		end
	end

	line:append(finalMessage, "NvimWhatsappChatMessage")

	return line
end

M.clear_chat = function()
	-- Unlock buffer
	chat_util.unlock_buffer()

	-- Clear buffer
	vim.api.nvim_buf_set_lines(ui.nui_chat_popup.bufnr, 0, -1, false, {})

	-- Lock buffer
	chat_util.lock_buffer()
end

return M
