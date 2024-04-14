local ui = require("nvim-whatsapp.ui")

local M = {}

M.lock_buffer = function()
	vim.api.nvim_set_option_value("modifiable", false, { buf = ui.nui_chat_popup.bufnr })
	vim.api.nvim_set_option_value("readonly", true, { buf = ui.nui_chat_popup.bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = ui.nui_chat_popup.bufnr })
end

M.unlock_buffer = function()
	vim.api.nvim_set_option_value("modifiable", true, { buf = ui.nui_chat_popup.bufnr })
	vim.api.nvim_set_option_value("readonly", false, { buf = ui.nui_chat_popup.bufnr })
end

return M
