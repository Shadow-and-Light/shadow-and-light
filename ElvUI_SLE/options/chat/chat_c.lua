local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local NONE = NONE
local function configTable()
	if not SLE.initialized then return end
	local function CreateJustify(i)
		local config = {
			order = i + 1,
			type = "select",
			name = L["Frame "..i],
			get = function(info) return E.db.sle.chat.justify["frame"..i] end,
			set = function(info, value)	E.db.sle.chat.justify["frame"..i] = value; C:JustifyChat(i) end,
			values = {
				LEFT = L["Left"],
				RIGHT = L["Right"],
				CENTER = L["Center"],
			},
		}
		return config
	end

	E.Options.args.sle.args.modules.args.chat = {
		order = 7,
		type = "group",
		name = L["Chat"],
		childGroups = 'select',
		args = {
			header = { order = 1, type = "header", name = L["Chat"] },
			editreset = {
				order = 3, type = 'execute',
				name = L["Reset Editbox History"], desc = L["Clears the editbox history and will reload your UI."],
				func = function() E:StaticPopup_Show("SLE_EDIT_HISTORY_CLEAR") end,
			},
			header2 = { order = 4, type = "description", name = "" },
			guildmaster = {
				order = 5, type = "toggle",
				name = L["Guild Master Icon"],
				desc = L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."],
				get = function(info) return E.db.sle.chat.guildmaster end,
				set = function(info, value)	E.db.sle.chat.guildmaster = value; C:GMIconUpdate() end,
			},
			editboxhistory = {
				order = 6, type = "range",
				name = L["Chat Editbox History"],
				desc = L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."],
				min = 5, max = 20, step = 1,
				get = function(info) return E.db.sle.chat.editboxhistory end,
				set = function(info, value) E.db.sle.chat.editboxhistory = value; end,
			},
			chatMax = {
				order = 7, type = "range",
				name = L["Chat Max Messages"],
				desc = L["The amount of messages to save in chat window.\n\n|cffFF0000Warning:|r Can increase the amount of memory needed. Also changing this setting will clear the chat in all windows, leaving just lines saved in chat history."],
				min = 10, max = 5000, step = 1,
				disabled = function() return not E.private.chat.enable or SLE._Compatibility["ElvUI_CustomTweaks"] end,
				get = function(info) return E.private.sle.chat.chatMax end,
				set = function(info, value) E.private.sle.chat.chatMax = value; C:UpdateChatMax() end,
			},
			dpsSpam = {
				order = 8, type = "toggle",
				name = L["Filter DPS meters' Spam"],
				desc = L["Replaces long reports from damage meters with a clickeble hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter te report of other things"],
				get = function(info) return E.db.sle.chat.dpsSpam end,
				set = function(info, value)	E.db.sle.chat.dpsSpam = value; C:SpamFilter() end,
			},
			combathide = {
				order = 9, type = "select",
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
				order = 20, type = "group",
				name = L["Texture Alpha"],
				args = {
					enable = {
						order = 1, type = "toggle",
						name = L["Enable"],
						desc = L["Allows separate alpha setting for textures in chat"],
						get = function(info) return E.db.sle.chat.textureAlpha.enable end,
						set = function(info, value)	E.db.sle.chat.textureAlpha.enable = value; E:UpdateMedia() end,
					},
					alpha = {
						order = 2, type = "range",
						name = L["Alpha"],
						isPercent = true,
						disabled = function() return not E.db.sle.chat.textureAlpha.enable end,
						min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.chat.textureAlpha.alpha end,
						set = function(info, value)	E.db.sle.chat.textureAlpha.alpha = value; E:UpdateMedia() end,
					},
				},
			},
			justify = {
				order = 30, type = "group",
				name = L["Chat Frame Justify"],
				args = {
					frame1 = CreateJustify(1),
					frame2 = CreateJustify(2),
					frame3 = CreateJustify(3),
					frame4 = CreateJustify(4),
					frame5 = CreateJustify(5),
					frame6 = CreateJustify(6),
					frame7 = CreateJustify(7),
					frame8 = CreateJustify(8),
					frame9 = CreateJustify(9),
					frame10 = CreateJustify(10),
					identify = {
						order = 12, type = "execute",
						name = L["Identify"],
						desc = L["Showes the message in each chat frame containing frame's number."],
						func = function() C:IdentifyChatFrames() end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)