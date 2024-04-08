local ui = require("nvim-whatsapp.ui")
local keymaps = require("nvim-whatsapp.keymaps")
local tickets_list = require("nvim-whatsapp.tickets-list")
local highlights = require("nvim-whatsapp.highlights")
local chat = require("nvim-whatsapp.chat")
local socket = require("nvim-whatsapp.socket")

local M = {}

M.setup = function()
	keymaps.setup()
	tickets_list.setup()
	highlights.setup()
	chat.setup()
	socket.setup()
end

M.Open = function()
	ui.layout:mount()
end

return M
