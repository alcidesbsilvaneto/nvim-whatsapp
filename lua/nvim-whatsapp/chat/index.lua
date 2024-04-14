local ui = require("nvim-whatsapp.ui")
local chat_ui = require("nvim-whatsapp.chat.ui")
local api = require("nvim-whatsapp.api")
local navigation = require("nvim-whatsapp.navigation")
local keymaps = require("nvim-whatsapp.keymaps")
local chat_util = require("nvim-whatsapp.chat.util")

-- Import messages module avoiding circular dependencies
local messages = require("nvim-whatsapp.chat.messages")

local M = {}

M.ticket_id = nil
M.messages = {}
M.selected_message_to_reply = nil

M.setup = function()
	keymaps.setup_chat_keymaps()
	keymaps.setup_message_input_keymaps()

	-- Set chat input buffer options
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = ui.nui_message_input.bufnr })
	vim.api.nvim_set_option_value("filetype", "nvim-whatsapp", { buf = ui.nui_message_input.bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = ui.nui_message_input.bufnr })
	vim.api.nvim_set_option_value("buflisted", false, { buf = ui.nui_message_input.bufnr })
end

M.render = function(messages)
	-- Unlock buffer
	chat_util.unlock_buffer()

	-- Build lines from messages
	for i, message in ipairs(messages) do
		local line = chat_ui.build_nui_line(message)
		line:render(ui.nui_chat_popup.bufnr, -1, i)
	end

	-- Scroll to the bottom without moving the cursor
	vim.api.nvim_win_set_cursor(ui.nui_chat_popup.winid, { #messages, 0 })

	-- Lock buffer
	chat_util.lock_buffer()
end

M.load_chat = function(ticket_id)
	vim.schedule(function()
		-- Focus chat input
		navigation.FocusMessageInput()
		-- Enter insert mode
		vim.cmd("startinsert!")

		if not ticket_id == M.ticket_id then
			chat_ui.clear_chat()
		end

		api.get("/messages?page=1&per_page=1000&ticket_id=" .. ticket_id, function(response)
			chat_ui.clear_chat()
			M.ticket_id = ticket_id
			M.messages = response.messages
			M.render(response.messages)
		end)
	end)
end

return M
