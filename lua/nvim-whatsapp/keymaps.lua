local ui = require("nvim-whatsapp.ui")
local api = require("nvim-whatsapp.api")

local M = {}

M.setup = function()
	-- set custom highlights
	vim.api.nvim_set_keymap("n", "<leader>m", ":lua require('nvim-whatsapp').Open()<CR>", {
		noremap = true,
		silent = true,
	})
end

M.setup_tickets_list_keymaps = function()
	-- Navigate to the chat window
	ui.nui_tickets_list_popup:map("n", "<C-l>", function()
		require("nvim-whatsapp.navigation").FocusChat()
	end, { noremap = true })

	-- Select ticket
	ui.nui_tickets_list_popup:map("n", "<CR>", function()
		SelectTicket()
	end, { noremap = true, silent = true })

	ui.nui_tickets_list_popup:map("n", "q", function()
		require("nvim-whatsapp.init").Toggle()
	end, { noremap = true, silent = true })

	-- Avoid navigating outside the layout
	ui.nui_tickets_list_popup:map("n", "<C-j>", function() end, { noremap = true, silent = true })
	ui.nui_tickets_list_popup:map("n", "<C-h>", function() end, { noremap = true, silent = true })
	ui.nui_tickets_list_popup:map("n", "<C-k>", function() end, { noremap = true, silent = true })

	-- Set all tickets as read
	ui.nui_tickets_list_popup:map("n", "<leader>mr", function()
		api.markAllAsRead(function()
			require("nvim-whatsapp.tickets-list").setup()
		end)
	end, { noremap = true, silent = true })
end

M.setup_chat_keymaps = function()
	ui.nui_chat_popup:map("n", "<C-h>", function()
		require("nvim-whatsapp.navigation").FocusTicketsList()
	end, { noremap = true, silent = true })

	ui.nui_chat_popup:map("n", "q", function()
		require("nvim-whatsapp.init").Toggle()
	end, { noremap = true, silent = true })

	ui.nui_chat_popup:map("n", "<C-l>", function() end, { noremap = true })

	ui.nui_chat_popup:map("n", "<C-j>", function()
		require("nvim-whatsapp.navigation").FocusMessageInput()
	end, { noremap = true, silent = true })
end

M.setup_message_input_keymaps = function()
	ui.nui_message_input:map("n", "<C-k>", function()
		require("nvim-whatsapp.navigation").FocusChat()
	end, { noremap = true, silent = true })

	ui.nui_message_input:map("n", "q", function()
		require("nvim-whatsapp.init").Toggle()
	end, { noremap = true, silent = true })

	ui.nui_message_input:map("n", "<C-h>", function()
		require("nvim-whatsapp.navigation").FocusTicketsList()
	end, { noremap = true, silent = true })

	ui.nui_message_input:map("n", "<C-j>", function() end, { noremap = true, silent = true })
	ui.nui_message_input:map("n", "<C-l>", function() end, { noremap = true, silent = true })
	ui.nui_message_input:map("i", "<CR>", function()
		SendMessage()
	end, { noremap = true, silent = true })
end

return M
