local M = {}

M.keymaps_setup = false
M.selected_ticket_id = nil
M.tickets = {}
M.messages = {}
M.chat = {}
M.notification = nil
M.selected_message_to_reply = nil
M.nui_lines = {}
M.conversations = {}

M.set_local_conversation = function(ticket_id, messages)
	local local_conversation_index = nil

	for i, conversation in ipairs(M.conversations) do
		if tostring(conversation.ticket_id) == tostring(ticket_id) then
			local_conversation_index = i
			break
		end
	end

	if local_conversation_index == nil then
		table.insert(M.conversations, { ticket_id = ticket_id, messages = messages })
	else
		M.conversations[local_conversation_index] = { ticket_id = ticket_id, messages = messages }
	end
end

return M
