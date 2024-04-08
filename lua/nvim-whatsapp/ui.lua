local Popup = require("nui.popup")
local Layout = require("nui.layout")
local Input = Popup:extend("NuiInput")

local M = {}

M.is_open = false

local nui_message_input = Input({
	border = {
		style = "single",
		text = {
			top = "Input",
			top_align = "left",
		},
	},
})

local nui_tickets_list_popup, nui_chat_popup =
	Popup({
		enter = true,
		border = {
			style = "single",
			text = {
				top = "Tickets",
				top_align = "left",
			},
		},
	}), Popup({
		border = {
			style = "single",
			text = {
				top = "Chat",
				top_align = "left",
			},
		},
	})

local root_layout = Layout(
	{
		position = "50%",
		relative = "editor",
		size = {
			width = "90%",
			height = "80%",
		},
	},
	Layout.Box({
		Layout.Box(nui_tickets_list_popup, { size = "30%" }),
		Layout.Box({
			Layout.Box(nui_chat_popup, { size = "85%" }),
			Layout.Box(nui_message_input, { grow = 1 }),
		}, { size = "70%", dir = "col" }),
	}, { dir = "row" })
)

M.layout = root_layout
M.nui_message_input = nui_message_input
M.nui_tickets_list_popup = nui_tickets_list_popup
M.nui_chat_popup = nui_chat_popup

return M
