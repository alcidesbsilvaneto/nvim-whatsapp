local ui = require("nvim-whatsapp.ui")
local keymaps = require("nvim-whatsapp.keymaps")
local tickets_list = require("nvim-whatsapp.tickets-list")
local highlights = require("nvim-whatsapp.highlights")
local chat = require("nvim-whatsapp.chat")
local socket = require("nvim-whatsapp.socket")

local M = {}

M.chats = {}

M.setup = function()
	keymaps.setup()
	tickets_list.setup()
	highlights.setup()
	chat.setup()
	socket.setup()
end

M.Open = function()
	if ui.mounted then
		ui.layout:show()
	else
		ui.layout:mount()
		ui.mounted = true
	end
end

M.Toggle = function()
	ui.layout:hide()
end

return M
