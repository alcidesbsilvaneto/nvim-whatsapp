local Job = require("plenary.job")
local token = vim.fn.system("cat ~/.pode_token"):gsub("\n", "")
local chat = require("nvim-whatsapp.chat")

local M = {}

M.setup = function()
	-- Get plugin path
	local plugin_path = debug.getinfo(1).source:match("@(.*/)")
	Job:new({
		command = "node",
		args = { plugin_path .. "js/socket.js", token },
		on_stdout = function(_, data)
			M.handle_ticket_update(data)
		end,
		on_exit = vim.schedule_wrap(function(response)
			vim.notify("Socket discnnected")
			vim.notify(vim.inspect(response))
		end),
	}):start()
end

M.handle_ticket_update = function(event)
	-- Find ticket id in regex ticket:id:update
	if event == "ticket:updated" and chat.ticket_id then
		chat.load_chat(chat.ticket_id)
	end
end

return M
