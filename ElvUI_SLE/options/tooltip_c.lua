local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RP = SLE:GetModule("RaidProgress")

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.tooltip = {
		order = 1,
		type = "group",
		disabled = function() return not E.private.toltip.enable end,
		get = function(info) return E.db.sle.tooltip[ info[#info] ] end,
		name = L["Tooltip"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Tooltip"],
			},
			space1 = {
				order = 4,
				type = 'description',
				name = "",
			},
			showFaction = {
				order = 5,
				type = 'toggle',
				name = L["Faction Icon"],
				desc = L["Show faction icon to the left of player's name on tooltip."],
				disabled = function() return not E.private.tooltip.enable end,
				set = function(info, value) E.db.sle.tooltip.showFaction = value end,
			},
			alwaysCompareItems = {
				order = 6,
				type = 'toggle',
				name = L["Always Compare Items"],
				disabled = function() return not E.private.tooltip.enable end,
				set = function(info, value) E.db.sle.tooltip.alwaysCompareItems = value; SLE:SetCompareItems() end,
			},
			RaidProg = {
				type = "group",
				name = L["Raid Progression"],
				order = 12,
				guiInline = true,
				get = function(info) return E.db.sle.tooltip.RaidProg[ info[#info] ] end,
				set = function(info, value) E.db.sle.tooltip.RaidProg[ info[#info] ] = value end,
				disabled = function() return not E.private.tooltip.enable end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L["Show raid experience of character in tooltip (requires holding shift)."],
					},
					NameStyle = {
						order = 2,
						name = L["Name Style"],
						type = "select",
						set = function(info, value) E.db.sle.tooltip.RaidProg[ info[#info] ] = value; T.twipe(RP.Cache) end,
						values = {
							["LONG"] = L["Full"],
							["SHORT"] = L["Short"],
						},
					},
					DifStyle = {
						order = 3,
						name = L["Difficulty Style"],
						type = "select",
						set = function(info, value) E.db.sle.tooltip.RaidProg[ info[#info] ] = value; T.twipe(RP.Cache) end,
						values = {
							["LONG"] = L["Full"],
							["SHORT"] = L["Short"],
						},
					},
					Raids = {
						order = 4,
						type = "group",
						name = RAIDS,
						guiInline = true,
						get = function(info) return E.db.sle.tooltip.RaidProg.raids[ info[#info] ] end,
						set = function(info, value) E.db.sle.tooltip.RaidProg.raids[ info[#info] ] = value end,
						args = {
							nightmare = { order = -50, type = "toggle", name = SLE:GetMapInfo(777 , "name") },
							trial = { order = -49, type = "toggle", name = SLE:GetMapInfo(806, "name") },
							nighthold = { order = -48, type = "toggle", name = SLE:GetMapInfo(764, "name") },
							sargeras = { order = -47, type = "toggle", name = SLE:GetMapInfo(850 , "name") },
							antorus = { order = -46, type = "toggle", name = SLE:GetMapInfo(909, "name") },
							uldir = { order = -45, type = "toggle", name = SLE:GetMapInfo(1148, "name") },
							daz = { order = -44, type = "toggle", name = SLE:GetMapInfo(1358, "name") },
							sc = { order = -43, type = "toggle", name = SLE:GetMapInfo(1345, "name") },
							ep = { order = -42, type = "toggle", name = SLE:GetMapInfo(1512, "name") },
						},
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
