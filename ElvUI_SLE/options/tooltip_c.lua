local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local RP = SLE:GetModule("RaidProgress")

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.tooltip = {
		order = 20,
		type = "group",
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
				-- desc = L["Show faction icon to the left of player's name on tooltip."],
				disabled = function() return not E.private.tooltip.enable end,
				set = function(info, value) E.db.sle.tooltip.alwaysCompareItems = value; SLE:SetCompareItems() end,
			},
			offset = {
				type = "group",
				name = L["Tooltip Cursor Offset"],
				order = 7,
				guiInline = true,
				set = function(info, value) E.db.sle.tooltip[ info[#info] ] = value end,
				disabled = function() return not E.private.tooltip.enable or not E.db.tooltip.cursorAnchor end,
				args = {
					intro = {
						order = 1,
						type = 'description',
						name = L["TTOFFSET_DESC"],
					},
					space1 = {
						order = 2,
						type = 'description',
						name = "",
					},
					xOffset = {
						order = 31,
						type = 'range',
						name = L["Tooltip X-offset"],
						desc = L["Offset the tooltip on the X-axis."],
						min = -200, max = 200, step = 1,
					},
					yOffset = {
						order = 32,
						type = 'range',
						name = L["Tooltip Y-offset"],
						desc = L["Offset the tooltip on the Y-axis."],
						min = -200, max = 200, step = 1,
					},
				},
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
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)