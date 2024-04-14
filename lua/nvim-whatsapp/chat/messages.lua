local api = require("nvim-whatsapp.api")
local ui = require("nvim-whatsapp.ui")
local data = require("nvim-whatsapp.data")

local M = {}

M.send_message = function()
	local message = vim.fn.join(vim.fn.getline(1, "$"), "\n")
	vim.api.nvim_buf_set_lines(ui.nui_message_input.bufnr, 0, -1, false, {})
	api.sendMessage(message, data.selected_ticket_id, function()
		-- Clear input buffer
	end)
end

SendMessage = M.send_message

return M
