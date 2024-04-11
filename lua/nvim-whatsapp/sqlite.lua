local sqlite = require("sqlite")

local chats = sqlite.tbl("chats", {
	ticket_id = "number",
	messages = "text",
})

sqlite({ uri = "nvim_whatsapp_db", chats = chats })

return chats
