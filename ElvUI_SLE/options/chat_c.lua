local E, L, V, P, G, _ = unpack(ElvUI);
local CH = E:GetModule('Chat')

local function configTable()
	E.Options.args.sle.args.options.args.general.args.chat = {
		order = 7,
		type = "group",
		name = L["Chat"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Chat"],
			},
			editboxhistory = {
				order = 2,
				type = "range",
				name = L["Chat Editbox History"],
				desc = L["Amount of messages to save. Set to 0 to disable."],
				min = 0, max = 20, step = 1,
				get = function(info) return E.db.chat.editboxhistory end,
				set = function(info, value)	E.db.chat.editboxhistory = value; end,
			},
			guildmaster = {
				order = 3,
				type = "toggle",
				name = "Guild Master Icon",
				desc = [[Show an icon near your Guild Master's messages in chat.
	Will not affect messages in chat history and possibly some messages right after your loading screen disappears on login.]],
				get = function(info) return E.private.sle.guildmaster end,
				set = function(info, value)	E.private.sle.guildmaster = value; CH:GMIconUpdate() end,
			},
			historyreset = {
				order = 4,
				type = 'execute',
				name = "Reset Chat History",
				desc = "Will delete all messages from chat history added prior clicking the button.",
				disabled = function() return not E.db.chat.chatHistory end,
				func = function() E:StaticPopup_Show("SLE_CHAT_HISTORY") end,
			},
			editreset = {
				order = 5,
				type = 'execute',
				name = "Reset Editbox History",
				desc = "Will delete all messages from editbox history. Will immidiatly reload your UI.",
				disabled = function() return not E.db.chat.chatHistory end,
				func = function() E:StaticPopup_Show("SLE_EDIT_HISTORY") end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)