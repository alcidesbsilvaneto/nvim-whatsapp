local ui = require("nvim-whatsapp.ui")
local M = {}

M.apply_highlights = function(lines)
	local col_start = 0
	for i, line in ipairs(lines) do
		-- Get the sender name based on *ContactName:* pattern
		local sender_name = line:match("^(.-):")
		if sender_name then
			local sender_name_length = #sender_name
			vim.api.nvim_buf_add_highlight(
				ui.nui_chat_popup.bufnr,
				-1,
				"NvimWhatsappChatSenderName",
				i - 1,
				col_start,
				col_start + sender_name_length
			)
		end
	end
end

return M
