local api = require("nvim-whatsapp.api")
local util = require("nvim-whatsapp.util")
local ui = require("nvim-whatsapp.ui")
local keymaps = require("nvim-whatsapp.keymaps")
local chat = require("nvim-whatsapp.chat")

local M = {}
M.tickets = {}

M.select_ticket = function()
	-- Get the current line
	local line = vim.api.nvim_get_current_line()
	-- Get ticket id
	local ticketId = util.split(line, " - ")[1]
	-- Initialize chat data
	chat.load_chat(ticketId)

	-- Clear highlights
	vim.api.nvim_buf_clear_namespace(ui.nui_tickets_list_popup.bufnr, -1, 0, -1)

	-- Apply highlight to current line (selected ticket)
	vim.api.nvim_buf_add_highlight(
		ui.nui_tickets_list_popup.bufnr,
		-1,
		"NvimWhatsappSelectedTicket",
		vim.api.nvim_win_get_cursor(0)[1] - 1,
		0,
		#line
	)
end

M.render = function(tickets)
	local lines = {}
	for _, ticket in ipairs(tickets) do
		table.insert(lines, ticket.id .. " - " .. ticket.contact.name)
	end
	vim.api.nvim_buf_set_lines(ui.nui_tickets_list_popup.bufnr, 0, 1, false, lines)
end

M.setup = function()
	keymaps.setup_tickets_list_keymaps()

	api.get("/tickets?per_page=1000", function(response)
		M.tickets = response.tickets
		M.render(response.tickets)
	end)
end

SelectTicket = M.select_ticket

return M
