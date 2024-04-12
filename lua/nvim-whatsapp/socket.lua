local Job = require("plenary.job")
local token = vim.fn.system("cat ~/.pode_token"):gsub("\n", "")
local chat = require("nvim-whatsapp.chat")
local tickets_list = require("nvim-whatsapp.tickets-list")

local M = {}
M.pid = nil

M.setup = function()
	-- Get plugin path
	local plugin_path = debug.getinfo(1).source:match("@(.*/)")
	Job:new({
		command = "forever",
		args = { plugin_path .. "js/socket.js", token },
		on_stdout = function(_, data)
			M.handle_ticket_update(data)
		end,
		on_exit = vim.schedule_wrap(function(response)
			vim.notify("Socket disconnected")
			vim.notify(vim.inspect(response))
		end),
	}):start()
end

M.handle_ticket_update = function(event)
	if event == "connected" then
		vim.notify("nvim-whatsapp connected")
	end
	-- Find ticket id in regex ticket:id:update
	if event == "ticket:updated" and chat.ticket_id then
		vim.notify("New message")
		chat.load_chat(chat.ticket_id)
		vim.schedule(function()
			tickets_list.setup()
		end)
	end
end

return M
