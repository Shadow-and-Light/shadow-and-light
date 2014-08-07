local E, L, V, P, G, _ = unpack(ElvUI);
local LT = E:GetModule('SLE_Loot')

local function configTable()
	E.Options.args.sle.args.options.args.loot = {
		order = 9,
		type = "group",
		name = L['Loot'],
		args = {
			autoconfirm = {
				order = 1,
				type = "toggle",
				name = "Auto Confirm",
				desc = "Automatically click OK on BOP items",
				get = function(info) return E.private.sle.loot.autoconfirm end,
				set = function(info,value) E.private.sle.loot.autoconfirm = value; end,
			},
			autogreed = {
				order = 2,
				type = "toggle",
				name = "Auto Greed",
				desc = "Automatically greed uncommon (green) quality items at max level",
				get = function(info) return E.private.sle.loot.autogreed end,
				set = function(info,value) E.private.sle.loot.autogreed = value; LT:Update() end,
			},
			autodisenchant = {
				order = 3,
				type = "toggle",
				name = "Auto Disenchant",
				desc = "Automatically disenchant uncommon (green) quality items at max level",
				get = function(info) return E.private.sle.loot.autodisenchant end,
				set = function(info,value) E.private.sle.loot.autodisenchant = value; LT:Update() end,
			},
			space1 = {
				order = 4,
				type = 'description',
				name = "",
			},
			space2 = {
				order = 4,
				type = 'description',
				name = "",
			},
			lootannouncer = {
				order = 5,
				type = "group",
				name = L["Loot Announcer"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L['Loot Announcer'],
					},
					info = {
						order = 2,
						type = "description",
						name = L["LOOT_DESC"],
					},
					enable = {
						order = 3,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.private.sle.loot.enable end,
						set = function(info, value) E.private.sle.loot.enable = value; E:StaticPopup_Show("CONFIG_RL") end
					},
					auto = {
						order = 4,
						type = "toggle",
						name = L["Auto Announce"],
						desc = L["AUTOANNOUNCE_DESC"],
						disabled = function() return not E.private.sle.loot.enable end,
						get = function(info) return E.db.sle.loot.auto end,
						set = function(info, value) E.db.sle.loot.auto = value; end
					},
					spacer = {
						order = 5,
						type = "description",
						name = "",
					},
					quality = {
						order = 9,
						type = "select",
						name = L["Loot Quality"],
						desc = L["Sets the minimum loot threshold to announce."],
						disabled = function() return not E.private.sle.loot.enable end,
						get = function(info) return E.db.sle.loot.quality end,
						set = function(info, value) E.db.sle.loot.quality = value;  end,
						values = {
							['EPIC'] = "|cffA335EE"..ITEM_QUALITY4_DESC.."|r",
							['RARE'] = "|cff0070DD"..ITEM_QUALITY3_DESC.."|r",
							['UNCOMMON'] = "|cff1EFF00"..ITEM_QUALITY2_DESC.."|r",
						},
					},
					chat = {
						order = 10,
						type = "select",
						name = L["Chat"],
						desc = L["Select chat channel to announce loot to."],
						disabled = function() return not E.private.sle.loot.enable end,
						get = function(info) return E.db.sle.loot.chat end,
						set = function(info, value) E.db.sle.loot.chat = value;  end,
						values = {
							['RAID'] = "|cffFF7F00"..RAID.."|r",
							['PARTY'] = "|cffAAAAFF"..PARTY.."|r",
							['SAY'] = "|cffFFFFFF"..SAY.."|r",
						},
					},
				},
			},
			lootwindow = {
				order = 6,
				type = "group",
				name = L["Loot History"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Loot History"],
					},
					info = {
						order = 2,
						type = "description",
						name = L["LOOTH_DESC"],
					},
					window = {
						order = 3,
						type = "toggle",
						name = L["Auto hide"],
						desc = L["Automaticaly hides Loot Roll Histroy frame when leaving the instance."],
						get = function(info) return E.db.sle.lootwin end,
						set = function(info, value) E.db.sle.lootwin = value; LT:LootShow() end
					},
					alpha = {
						order = 4,
						type = "range",
						name = L['Alpha'],
						desc = L["Sets the alpha of Loot Roll Histroy frame."],
						min = 0.2, max = 1, step = 0.1,
						get = function(info) return E.db.sle.lootalpha end,
						set = function(info, value) E.db.sle.lootalpha = value; LT:LootShow() end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)