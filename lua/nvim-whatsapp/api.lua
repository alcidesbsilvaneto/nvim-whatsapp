local Job = require("plenary.job")
local baseUrl = "https://api.podeorganizar.com.br"

-- Load token from storage
local token = vim.fn.system("cat ~/.pode_token"):gsub("\n", "")

local function get(endpoint, cb)
	Job:new({
		command = "curl",
		args = {
			"-X",
			"GET",
			baseUrl .. endpoint,
			"-H",
			"Authorization: Bearer " .. token,
			"-H",
			"Content-Type: application/json",
		},
		on_exit = vim.schedule_wrap(function(response)
			cb(vim.fn.json_decode(response._stdout_results[1]))
		end),
	}):start()
end

local function sendMessage(message, ticket_id, cb)
	Job:new({
		command = "curl",
		args = {
			"-X",
			"POST",
			baseUrl .. "/messages",
			"-H",
			"Authorization: Bearer " .. token,
			"-H",
			"Content-Type: application/json",
			"-d",
			'{"text": "' .. message .. '", "ticket_id": "' .. ticket_id .. '"}',
		},
		on_exit = vim.schedule_wrap(function(response)
			cb(vim.fn.json_decode(response._stdout_results[1]))
		end),
	}):start()
end

local function markAsRead(ticket_id, cb)
	Job:new({
		command = "curl",
		args = {
			"-X",
			"PATCH",
			baseUrl .. "/tickets/" .. ticket_id .. "/read",
			"-H",
			"Authorization: Bearer " .. token,
			"-H",
			"Content-Type: application/json",
		},
		on_exit = vim.schedule_wrap(function(response)
			cb(vim.fn.json_decode(response._stdout_results[1]))
		end),
	}):start()
end

local M = {
	get = get,
	sendMessage = sendMessage,
	markAsRead = markAsRead,
}

return M
