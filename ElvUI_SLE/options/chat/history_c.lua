local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local _G = _G
local function configTable()
	if not SLE.initialized then return end
	local function CreateHistoryChannel(Name, Order)
		local config = {
			order = Order,
			type = "toggle",
			name = _G[Name] or _G[T.gsub(Name, "CHAT_MSG_", "")],
			hidden = function() return not E.global.sle.advanced.general end,
			get = function(info) return E.private.sle.chat.chatHistory[Name] end,
			set = function(info, value) E.private.sle.chat.chatHistory[Name] = value; C:ChatHistoryToggle(true) end,
		}
		return config
	end

	E.Options.args.sle.args.modules.args.chat.args.chatHistory = {
		type = "group",
		name = L["Chat History"],
		order = 10,
		args = {
			historyreset = {
				order = 1,
				type = 'execute',
				name = L["Reset Chat History"],
				desc = L["Clears your chat history and will reload your UI."],
				disabled = function() return not E.db.chat.chatHistory end,
				func = function() E:StaticPopup_Show("SLE_CHAT_HISTORY_CLEAR") end,
			},
			size = {
				order = 3,
				name = L["Chat history size"],
				desc = L["Sets how many messages will be stored in history."],
				type = "range",
				min = 50, max = 500, step = 1,
				get = function(info) return E.private.sle.chat.chatHistory.size end,
				set = function(info, value) E.private.sle.chat.chatHistory.size = value; end
			},
			infos = {
				order = 4,
				type = "description",
				hidden = function() return not E.global.sle.advanced.general end,
				name = "\n"..L["Following options determine which channels to save in chat history.\nNote: disabling a channel will immideately delete saved info for that channel."],
			},
			CHAT_MSG_INSTANCE_CHAT = CreateHistoryChannel("CHAT_MSG_INSTANCE_CHAT", 5),
			CHAT_MSG_INSTANCE_CHAT_LEADER = CreateHistoryChannel("CHAT_MSG_INSTANCE_CHAT_LEADER", 6),
			CHAT_MSG_CHANNEL = CreateHistoryChannel("CHAT_MSG_CHANNEL", 7),
			CHAT_MSG_EMOTE = CreateHistoryChannel("CHAT_MSG_EMOTE", 8),
			CHAT_MSG_GUILD = CreateHistoryChannel("CHAT_MSG_GUILD", 9),
			CHAT_MSG_GUILD_ACHIEVEMENT = CreateHistoryChannel("CHAT_MSG_GUILD_ACHIEVEMENT", 10),
			CHAT_MSG_OFFICER = CreateHistoryChannel("CHAT_MSG_OFFICER", 11),
			CHAT_MSG_PARTY = CreateHistoryChannel("CHAT_MSG_PARTY", 12),
			CHAT_MSG_PARTY_LEADER = CreateHistoryChannel("CHAT_MSG_PARTY_LEADER", 13),
			CHAT_MSG_RAID = CreateHistoryChannel("CHAT_MSG_RAID", 14),
			CHAT_MSG_RAID_LEADER = CreateHistoryChannel("CHAT_MSG_RAID_LEADER", 15),
			CHAT_MSG_RAID_WARNING = CreateHistoryChannel("CHAT_MSG_RAID_WARNING", 16),
			CHAT_MSG_SAY = CreateHistoryChannel("CHAT_MSG_SAY", 17),
			CHAT_MSG_YELL = CreateHistoryChannel("CHAT_MSG_YELL", 18),
			WHISPER = {
				order = 19,
				type = "toggle",
				name = _G["CHAT_MSG_WHISPER"],
				hidden = function() return not E.global.sle.advanced.general end,
				get = function(info) return E.private.sle.chat.chatHistory["CHAT_MSG_WHISPER"] end,
				set = function(info, value) E.private.sle.chat.chatHistory["CHAT_MSG_WHISPER"] = value; E.private.sle.chat.chatHistory["CHAT_MSG_WHISPER_INFORM"] = value; C:ChatHistoryToggle(true) end,
			},
			BN_WHISPER = {
				order = 20,
				type = "toggle",
				name = _G["CHAT_MSG_BN_WHISPER"],
				hidden = function() return not E.global.sle.advanced.general end,
				get = function(info) return E.private.sle.chat.chatHistory["CHAT_MSG_BN_WHISPER"] end,
				set = function(info, value) E.private.sle.chat.chatHistory["CHAT_MSG_BN_WHISPER"] = value; E.private.sle.chat.chatHistory["CHAT_MSG_BN_WHISPER_INFORM"] = value; C:ChatHistoryToggle(true) end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)