local E, L, V, P, G = unpack(ElvUI);

local function configTable()
	E.Options.args.sle.args.options.args.general.args.tooltip = {
		order = 66,
		type = "group",
		get = function(info) return E.db.sle.tooltip[ info[#info] ] end,
		name = L["Tooltip"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Tooltip"],
			},
			--[[intro = {
				order = 2,
				type = 'description',
				name = L["Tooltip enhancements"],
			},]]
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
				--get = function(info) return E.db.sle.tooltip.showFaction end,
				set = function(info, value) E.db.sle.tooltip.showFaction = value end,
			},
			space2 = {
				order = 6,
				type = 'description',
				name = "",
			},
			offset = {
				type = "group",
				name = L["Tooltip Cursor Offset"],
				order = 7,
				guiInline = true,
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
						--get = function(info) return E.db.sle.tooltip.xOffset end,
						set = function(info, value) E.db.sle.tooltip[ info[#info] ] = value end,
					},
					yOffset = {
						order = 32,
						type = 'range',
						name = L["Tooltip Y-offset"],
						desc = L["Offset the tooltip on the Y-axis."],
						min = -200, max = 200, step = 1,
						--get = function(info) return E.db.sle.tooltip.yOffset
						set = function(info, value) E.db.sle.tooltip[ info[#info] ] = value end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)