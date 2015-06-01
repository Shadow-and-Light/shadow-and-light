local E, L, V, P, G = unpack(ElvUI);
local CH = E:GetModule('Chat')

local function configTable()
	E.Options.args.sle.args.options.args.general.args.chat = {
		order = 5,
		type = "group",
		name = L["Chat"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Chat"],
			},
			historyreset = {
				order = 2,
				type = 'execute',
				name = L["Reset Chat History"],
				desc = L["Clears your chat history and will reload your UI."],
				disabled = function() return not E.db.chat.chatHistory end,
				func = function() E:StaticPopup_Show("SLE_CHAT_HISTORY") end,
			},
			editreset = {
				order = 3,
				type = 'execute',
				name = L["Reset Editbox History"],
				desc = L["Clears the editbox history and will reload your UI."],
				disabled = function() return not E.db.chat.chatHistory end,
				func = function() E:StaticPopup_Show("SLE_EDIT_HISTORY") end,
			},
			header2 = {
				order = 4,
				type = "description",
				name = "",
			},
			guildmaster = {
				order = 5,
				type = "toggle",
				name = L["Guild Master Icon"],
				desc = L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."],
				get = function(info) return E.db.sle.chat.guildmaster end,
				set = function(info, value)	E.db.sle.chat.guildmaster = value; CH:GMIconUpdate() end,
			},
			editboxhistory = {
				order = 6,
				type = "range",
				name = L["Chat Editbox History"],
				desc = L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."],
				min = 0, max = 20, step = 1,
				get = function(info) return E.db.chat.editboxhistory end,
				set = function(info, value)	E.db.chat.editboxhistory = value; end,
			},
			dpsSpam = {
				order = 7,
				type = "toggle",
				name = L["Filter DPS meters' Spam"],
				desc = L["Replaces long reports from damage meters with a clickeble hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter te report of other things"],
				get = function(info) return E.db.sle.chat.dpsSpam end,
				set = function(info, value)	E.db.sle.chat.dpsSpam = value; CH:SpamFilter() end,
			},
			combathide = {
				order = 8,
				type = "select",
				name = L["Hide In Combat"],
				get = function(info) return E.db.sle.chat.combathide end,
				set = function(info, value)	E.db.sle.chat.combathide = value; end,
				values = {
					["NONE"] = NONE,
					["BOTH"] = L["Both"],
					["LEFT"] = L["Left"],
					["RIGHT"] = L["Right"],
				}
			},
			textureAlpha = {
				order = 10,
				type = "group",
				name = L["Texture Alpha"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = ENABLE,
						desc = L["Allows separate alpha setting for textures in chat"],
						get = function(info) return E.db.sle.chat.textureAlpha.enable end,
						set = function(info, value)	E.db.sle.chat.textureAlpha.enable = value; E:UpdateMedia() end,
					},
					alpha = {
						order = 2,
						type = "range",
						name = L["Alpha"],
						isPercent = true,
						disabled = function() return not E.db.sle.chat.textureAlpha.enable end,
						min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.chat.textureAlpha.alpha end,
						set = function(info, value)	E.db.sle.chat.textureAlpha.alpha = value; E:UpdateMedia() end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)