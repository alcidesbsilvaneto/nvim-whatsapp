local api = require("nvim-whatsapp.api")
local util = require("nvim-whatsapp.util")
local ui = require("nvim-whatsapp.ui")
local keymaps = require("nvim-whatsapp.keymaps")
local chat = require("nvim-whatsapp.chat")
local NuiLine = require("nui.line")

local M = {}
M.tickets = {}
M.nui_lines = {}
M.selected_ticket_id = nil
M.keymaps_setup = false

M.select_ticket = function()
	-- Get the current line
	local line = vim.api.nvim_get_current_line()
	-- Get ticket id
	local ticketId = util.split(line, " - ")[1]
	-- Initialize chat data
	chat.load_chat(ticketId)

	for i, ticket in ipairs(M.tickets) do
		if tostring(ticket.id) == ticketId then
			M.mark_ticket_as_read(ticketId)
			M.selected_ticket_id = ticketId
			M.tickets[i].selected = true
		else
			M.tickets[i].selected = false
		end
	end

	M.render(M.tickets)
end

M.build_nui_line = function(ticket, selected)
	local line = NuiLine()
	local contactName = ticket.contact.name:gsub("^(.-):", ""):gsub("^%*", ""):gsub("\n", "")
	local lastMessage = ticket.last_message:gsub("^(.-):", ""):gsub("\n", ""):gsub("^%*", "")

	line:append(ticket.id .. " ", "NvimWhatsappTicketListItemId")
	if ticket.unread_count > 0 then
		line:append(tostring(ticket.unread_count) .. " ", "NvimWhatsappTicketListItemUnread")
	end
	if selected or M.selected_ticket_id == ticket.id then
		line:append(contactName, "NvimWhatsappSelectedTicket")
	else
		line:append(contactName, "NvimWhatsappTicketListItemName")
	end
	if ticket.last_message then
		line:append(" " .. lastMessage, "NvimWhatsappTicketListItemLastMessage")
	end
	return line
end

M.lock_buffer = function()
	vim.api.nvim_set_option_value("modifiable", false, { buf = ui.nui_tickets_list_popup.bufnr })
	vim.api.nvim_set_option_value("readonly", true, { buf = ui.nui_tickets_list_popup.bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = ui.nui_tickets_list_popup.bufnr })
end

M.unlock_buffer = function()
	vim.api.nvim_set_option_value("modifiable", true, { buf = ui.nui_tickets_list_popup.bufnr })
	vim.api.nvim_set_option_value("readonly", false, { buf = ui.nui_tickets_list_popup.bufnr })
end

M.render = function(tickets)
	M.unlock_buffer()
	local lines = {}
	for _, ticket in ipairs(tickets) do
		local existing_ticket = nil

		for _, oldTicket in ipairs(M.tickets) do
			if oldTicket.id == ticket.id then
				existing_ticket = oldTicket
				break
			end
		end

		if existing_ticket and existing_ticket.selected then
			ticket.selected = existing_ticket.selected
			M.selected_ticket_id = existing_ticket.id
		end

		local line = M.build_nui_line(ticket, ticket.selected)
		table.insert(lines, line)
	end

	M.nui_lines = lines

	for i, line in ipairs(lines) do
		line:render(ui.nui_tickets_list_popup.bufnr, -1, i)
	end

	M.lock_buffer()
end

M.mark_ticket_as_read = function(ticketId)
	for i, ticket in ipairs(M.tickets) do
		if tostring(ticket.id) == ticketId then
			if ticket.unread_count > 0 then
				api.markAsRead(ticketId, function()
					M.tickets[i].unread_count = 0
				end)
			end
			M.tickets[i].unread_count = 0
			M.render(M.tickets)
		end
	end
end

M.setup = function()
	if not M.keymaps_setup then
		keymaps.setup_tickets_list_keymaps()
		M.keymaps_setup = true
	end
	api.get("/tickets?per_page=1000", function(response)
		M.render(response.tickets)
		M.tickets = response.tickets
	end)
end

SelectTicket = M.select_ticket

return M
