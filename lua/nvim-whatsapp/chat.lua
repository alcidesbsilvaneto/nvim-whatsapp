local ui = require("nvim-whatsapp.ui")
local api = require("nvim-whatsapp.api")
local navigation = require("nvim-whatsapp.navigation")
local keymaps = require("nvim-whatsapp.keymaps")
local NuiLine = require("nui.line")

local M = {}

M.ticket_id = nil
M.messages = {}

M.setup = function()
	keymaps.setup_chat_keymaps()
	keymaps.setup_message_input_keymaps()

	-- Set chat input buffer options
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = ui.nui_message_input.bufnr })
	vim.api.nvim_set_option_value("filetype", "nvim-whatsapp", { buf = ui.nui_message_input.bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = ui.nui_message_input.bufnr })
	vim.api.nvim_set_option_value("buflisted", false, { buf = ui.nui_message_input.bufnr })
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

M.send_message = function()
	local message = vim.fn.join(vim.fn.getline(1, "$"), "\n")
	vim.api.nvim_buf_set_lines(ui.nui_message_input.bufnr, 0, -1, false, {})
	api.sendMessage(message, M.ticket_id, function()
		-- Clear input buffer
	end)
end

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

M.render = function(messages)
	-- Unlock buffer
	M.unlock_buffer()

	-- Build lines from messages
	for i, message in ipairs(messages) do
		local line = M.build_nui_line(message)
		line:render(ui.nui_chat_popup.bufnr, -1, i)
	end

	-- Scroll to the bottom without moving the cursor
	vim.api.nvim_win_set_cursor(ui.nui_chat_popup.winid, { #messages, 0 })

	-- Lock buffer
	M.lock_buffer()
end

M.clear_chat = function()
	-- Unlock buffer
	M.unlock_buffer()

	-- Clear buffer
	vim.api.nvim_buf_set_lines(ui.nui_chat_popup.bufnr, 0, -1, false, {})

	-- Lock buffer
	M.lock_buffer()
end

M.load_chat = function(ticket_id)
	vim.schedule(function()
		-- Focus chat input
		navigation.FocusMessageInput()
		-- Enter insert mode
		vim.cmd("startinsert!")

		M.clear_chat()

		api.get("/messages?page=1&per_page=1000&ticket_id=" .. ticket_id, function(response)
			M.ticket_id = ticket_id
			M.messages = response.messages
			M.render(response.messages)
		end)
	end)
end

SendMessage = M.send_message

return M
