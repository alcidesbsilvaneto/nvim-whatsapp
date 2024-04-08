local ui = require("nvim-whatsapp.ui")
local api = require("nvim-whatsapp.api")
local navigation = require("nvim-whatsapp.navigation")
local keymaps = require("nvim-whatsapp.keymaps")

local M = {}

M.ticket_id = nil

M.setup = function()
	keymaps.setup_chat_keymaps()
	keymaps.setup_message_input_keymaps()
end

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

M.lock_buffer = function()
	vim.api.nvim_set_option_value("modifiable", false, { buf = ui.nui_chat_popup.bufnr })
	vim.api.nvim_set_option_value("readonly", true, { buf = ui.nui_chat_popup.bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = ui.nui_chat_popup.bufnr })
end

M.unlock_buffer = function()
	vim.api.nvim_set_option_value("modifiable", true, { buf = ui.nui_chat_popup.bufnr })
	vim.api.nvim_set_option_value("readonly", false, { buf = ui.nui_chat_popup.bufnr })
end

M.assemble_chat_messages = function(messages)
	local lines = {}

	for _, message in ipairs(messages) do
		local finalMessage = ""
		if type(message.message) == "string" then
			finalMessage = message.message
		end

		finalMessage = finalMessage:gsub("^(.-):", "")
		finalMessage = finalMessage:gsub("^%*", "")
		finalMessage = finalMessage:gsub("\n", "")

		if message.is_mine then
			finalMessage = "Você: " .. finalMessage
		else
			if message.sender_name then
				finalMessage = message.sender_name .. ": " .. finalMessage
			else
				finalMessage = "Desconhecido: " .. finalMessage
			end
		end

		table.insert(lines, finalMessage)
	end

	return lines
end

M.send_message = function()
	local message = vim.fn.join(vim.fn.getline(1, "$"), "\n")
	vim.api.nvim_buf_set_lines(ui.nui_message_input.bufnr, 0, -1, false, {})
	api.sendMessage(message, M.ticket_id, function()
		-- Clear input buffer
	end)
end

M.render = function(messages)
	-- Unlock buffer
	M.unlock_buffer()

	-- Clear buffer
	vim.api.nvim_buf_set_lines(ui.nui_chat_popup.bufnr, 0, -1, false, {})

	-- Build lines from messages
	local lines = M.assemble_chat_messages(messages)

	-- Add lines to buffer
	vim.api.nvim_buf_set_lines(ui.nui_chat_popup.bufnr, 0, 1, false, lines)

	-- Apply highlights
	M.apply_highlights(lines)

	-- Focus on chat window
	vim.api.nvim_set_current_win(ui.nui_chat_popup.winid)

	-- Lock buffer
	M.lock_buffer()

	-- Scroll to the bottom
	vim.api.nvim_win_set_cursor(ui.nui_chat_popup.winid, { #lines, 0 })

	-- Focus chat input
	navigation.FocusMessageInput()

	-- Enter insert mode
	vim.cmd("startinsert!")
end

M.load_chat = function(ticket_id)
	api.get("/messages?page=1&per_page=1000&ticket_id=" .. ticket_id, function(response)
		M.ticket_id = ticket_id
		M.render(response.messages)
	end)
end

SendMessage = M.send_message

return M
