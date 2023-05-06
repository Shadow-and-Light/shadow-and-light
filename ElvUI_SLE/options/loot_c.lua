local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local LT = SLE.Loot

--GLOBALS: unpack, select, _G, gsub, tinsert, ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC, GetMaxPlayerLevel, CHAT_MSG_BN_WHISPER, CHAT_MSG_WHISPER_INFORM
local _G = _G
local gsub, tinsert = gsub, tinsert
local ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC = ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC
local GetMaxPlayerLevel = GetMaxPlayerLevel
local CHAT_MSG_BN_WHISPER, CHAT_MSG_WHISPER_INFORM = CHAT_MSG_BN_WHISPER, CHAT_MSG_WHISPER_INFORM

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH
	local function CreateChannel(Name, Order)
		local config = {
			order = Order,
			type = "toggle",
			name = _G[Name] or _G[gsub(Name, "CHAT_MSG_", "")],
			disabled = function() return not E.db.sle.loot.looticons.enable end,
			get = function(_) return E.db.sle.loot.looticons.channels[Name] end,
			set = function(_, value) E.db.sle.loot.looticons.channels[Name] = value end,
		}
		return config
	end

	E.Options.args.sle.args.modules.args.loot = {
		order = 1,
		type = "group",
		name = L["Loot"],
		childGroups = 'tab',
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function() return E.db.sle.loot.enable end,
				set = function(_, value) E.db.sle.loot.enable = value; LT:Toggle() end
			},
			spacer1 = ACH:Spacer(2),
			autoroll = {
				order = 1,
				type = "group",
				name = L["Loot Auto Roll"],
				args = {
					header = ACH:Header(L["Loot Auto Roll"], 1),
					info = ACH:Description(L["LOOT_AUTO_DESC"], 2),
					spacer1 = ACH:Spacer(3),
					enable = {
						order = 4,
						type = "toggle",
						name = L["Enable"],
						disabled = function() return not E.db.sle.loot.enable end,
						get = function() return E.db.sle.loot.autoroll.enable end,
						set = function(_, value) E.db.sle.loot.autoroll.enable = value; LT:Update() end,
					},
					spacer2 = ACH:Spacer(5),
					autoconfirm = {
						order = 6,
						type = "toggle",
						name = L["Auto Confirm"],
						desc = L["Automatically click OK on BOP items"],
						disabled = function() return not E.db.sle.loot.enable or not E.db.sle.loot.autoroll.enable end,
						get = function() return E.db.sle.loot.autoroll.autoconfirm end,
						set = function(_, value) E.db.sle.loot.autoroll.autoconfirm = value end,
					},
					autogreed = {
						order = 7,
						type = "toggle",
						name = L["Auto Greed"],
						desc = L["Automatically greed uncommon (green) quality items at max level"],
						disabled = function() return not E.db.sle.loot.enable or not E.db.sle.loot.autoroll.enable end,
						get = function() return E.db.sle.loot.autoroll.autogreed end,
						set = function(_, value) E.db.sle.loot.autoroll.autogreed = value end,
					},
					autode = {
						order = 8,
						type = "toggle",
						name = L["Auto Disenchant"],
						desc = L["Automatically disenchant uncommon (green) quality items at max level"],
						disabled = function() return not E.db.sle.loot.enable or not E.db.sle.loot.autoroll.enable end,
						get = function() return E.db.sle.loot.autoroll.autode end,
						set = function(_, value) E.db.sle.loot.autoroll.autode = value end,
					},
					autoqlty = {
						order = 9,
						type = "select",
						name = L["Loot Quality"],
						desc = L["Sets the auto greed/disenchant quality\n\nUncommon: Rolls on Uncommon only\nRare: Rolls on Rares & Uncommon"],
						disabled = function() return not E.db.sle.loot.enable or not E.db.sle.loot.autoroll.enable end,
						get = function() return E.db.sle.loot.autoroll.autoqlty end,
						set = function(_, value) E.db.sle.loot.autoroll.autoqlty = value end,
						values = {
							[4] = "|cffA335EE"..ITEM_QUALITY4_DESC.."|r",
							[3] = "|cff0070DD"..ITEM_QUALITY3_DESC.."|r",
							[2] = "|cff1EFF00"..ITEM_QUALITY2_DESC.."|r",
						},
					},
					spacer3 = ACH:Spacer(10),
					bylevel = {
						order = 11,
						type = "toggle",
						name = L["Roll based on level."],
						desc = L["This will auto-roll if you are above the given level if: You cannot equip the item being rolled on, or the iLevel of your equipped item is higher than the item being rolled on or you have an heirloom equipped in that slot"],
						disabled = function() return not E.db.sle.loot.enable or not E.db.sle.loot.autoroll.enable end,
						get = function() return E.db.sle.loot.autoroll.bylevel end,
						set = function(_, value) E.db.sle.loot.autoroll.bylevel = value end,
					},
					level = {
						order = 12,
						type = "range",
						name = L["Level to start auto-rolling from"],
						disabled = function() return not E.db.sle.loot.enable or not E.db.sle.loot.autoroll.enable end,
						min = 1, max = GetMaxPlayerLevel(), step = 1,
						get = function() return E.db.sle.loot.autoroll.level end,
						set = function(_, value) E.db.sle.loot.autoroll.level = value end,
					},
				},
			},
			history = {
				order = 3,
				type = "group",
				name = L["Loot Roll History"],
				args = {
					header = ACH:Header(L["Loot Roll History"], 1),
					info = ACH:Description(L["LOOTH_DESC"], 2),
					window = {
						order = 3,
						type = "toggle",
						name = L["Auto Hide"],
						desc = L["Automatically hides Loot Roll History frame when leaving the instance."],
						disabled = function() return not E.db.sle.loot.enable end,
						get = function() return E.db.sle.loot.history.autohide end,
						set = function(_, value) E.db.sle.loot.history.autohide = value; LT:LootShow() end,
					},
					alpha = {
						order = 4,
						type = "range",
						name = L["Alpha"],
						desc = L["Sets the alpha of Loot Roll History frame."],
						min = 0.2, max = 1, step = 0.1,
						disabled = function() return not E.db.sle.loot.enable end,
						get = function() return E.db.sle.loot.history.alpha end,
						set = function(_, value) E.db.sle.loot.history.alpha = value; LT:LootAlpha() end,
					},
					scale = {
						order = 5,
						type = "range",
						name = L["Scale"],
						-- desc = L["Sets the alpha of Loot Roll History frame."],
						min = 0.2, max = 2, step = 0.1,
						disabled = function() return not E.db.sle.loot.enable end,
						get = function() return E.db.sle.loot.history.scale end,
						set = function(_, value) E.db.sle.loot.history.scale = value; LT:LootScale() end,
					},
				},
			},
			looticon = {
				type = "group",
				name = L["Loot Icons"],
				order = 11,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Shows icons of items looted/created near respective messages in chat. Does not affect usual messages."],
						get = function() return E.db.sle.loot.looticons.enable end,
						set = function(_, value) E.db.sle.loot.looticons.enable = value; LT:LootIconToggle() end,
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						disabled = function() return not E.db.sle.loot.looticons.enable end,
						get = function() return E.db.sle.loot.looticons.position end,
						set = function(_, value) E.db.sle.loot.looticons.position = value end,
						values = {
							LEFT = L["Left"],
							RIGHT = L["Right"],
						},
					},
					size = {
						order = 3,
						type = "range",
						name = L["Size"],
						disabled = function() return not E.db.sle.loot.looticons.enable end,
						min = 8, max = 32, step = 1,
						get = function() return E.db.sle.loot.looticons.size end,
						set = function(_, value)	E.db.sle.loot.looticons.size = value end,
					},
					channels = {
						type = "group",
						name = L["CHANNELS"],
						order = 4,
						guiInline = true,
						args = {
							CHANNEL = CreateChannel("CHAT_MSG_CHANNEL", 4),
							EMOTE = CreateChannel("CHAT_MSG_EMOTE", 5),
							GUILD = CreateChannel("CHAT_MSG_GUILD", 6),
							INSTANCE_CHAT = CreateChannel("CHAT_MSG_INSTANCE_CHAT", 7),
							INSTANCE_CHAT_LEADER = CreateChannel("CHAT_MSG_INSTANCE_CHAT_LEADER", 8),
							LOOT = CreateChannel("CHAT_MSG_LOOT", 9),
							OFFICER = CreateChannel("CHAT_MSG_OFFICER", 10),
							PARTY = CreateChannel("CHAT_MSG_PARTY", 11),
							PARTY_LEADER = CreateChannel("CHAT_MSG_PARTY_LEADER", 12),
							RAID = CreateChannel("CHAT_MSG_RAID", 13),
							RAID_LEADER = CreateChannel("CHAT_MSG_RAID_LEADER", 14),
							RAID_WARNING = CreateChannel("CHAT_MSG_RAID_WARNING", 15),
							SAY = CreateChannel("CHAT_MSG_SAY", 16),
							SYSTEM = CreateChannel("CHAT_MSG_SYSTEM", 17),
							YELL = CreateChannel("CHAT_MSG_YELL", 20),
						},
					},
					privateChannels = {
						type = "group",
						name = L["Private channels"],
						order = 5,
						guiInline = true,
						args = {
							CHAT_MSG_BN_CONVERSATION = CreateChannel("CHAT_MSG_BN_CONVERSATION", 1),
							BN_WHISPER = {
								type = "group",
								name = CHAT_MSG_BN_WHISPER,
								order = 2,
								guiInline = true,
								args = {
									inc = {
										order = 1,
										type = "toggle",
										name = L["Incoming"],
										disabled = function() return not E.db.sle.loot.looticons.enable end,
										get = function() return E.db.sle.loot.looticons.channels.CHAT_MSG_BN_WHISPER end,
										set = function(_, value) E.db.sle.loot.looticons.channels.CHAT_MSG_BN_WHISPER = value end,
									},
									out = {
										order = 2,
										type = "toggle",
										name = L["Outgoing"],
										disabled = function() return not E.db.sle.loot.looticons.enable end,
										get = function() return E.db.sle.loot.looticons.channels.CHAT_MSG_BN_WHISPER_INFORM end,
										set = function(_, value) E.db.sle.loot.looticons.channels.CHAT_MSG_BN_WHISPER_INFORM = value end,
									},
								},
							},
							WHISPER = {
								type = "group",
								name = CHAT_MSG_WHISPER_INFORM,
								order = 3,
								guiInline = true,
								args = {
									inc = {
										order = 1,
										type = "toggle",
										name = L["Incoming"],
										disabled = function() return not E.db.sle.loot.looticons.enable end,
										get = function() return E.db.sle.loot.looticons.channels.CHAT_MSG_WHISPER end,
										set = function(_, value) E.db.sle.loot.looticons.channels.CHAT_MSG_WHISPER = value end,
									},
									out = {
										order = 2,
										type = "toggle",
										name = L["Outgoing"],
										disabled = function() return not E.db.sle.loot.looticons.enable end,
										get = function() return E.db.sle.loot.looticons.channels.CHAT_MSG_WHISPER_INFORM end,
										set = function(_, value) E.db.sle.loot.looticons.channels.CHAT_MSG_WHISPER_INFORM = value end,
									},
								},
							},
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
