local E, L, V, P, G = unpack(ElvUI);

local function configTable()
	E.Options.args.sle.args.options.args.general.args.tooltip = {
		order = 10,
		type = "group",
		get = function(info) return E.db.tooltip[ info[#info] ] end,
		name = L["Tooltip"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Tooltip"],
			},
			intro = {
				order = 2,
				type = 'description',
				name = L["Tooltip enhancements"],
			},
			tooltipicon = {
				order = 3,
				type = 'toggle',
				name = L["Faction Icon"],
				desc = L["Show faction icon to the left of player's name on tooltip."],
				get = function(info) return E.db.sle.tooltipicon end,
				set = function(info, value) E.db.sle.tooltipicon = value end,
			},
			offset = {
				type = "group",
				name = L["Tooltip Cursor Offset"],
				order = 4,
				guiInline = true,
				disabled = function() return not E.private.tooltip.enable or (not E.db.tooltip.cursorAnchor and E.private.tooltip.enable) end,
				args = {
					mouseOffsetX = {
						order = 31,
						type = 'range',
						name = L["Tooltip X-offset"],
						desc = L["Offset the tooltip on the X-axis."],
						min = -200, max = 200, step = 1,
						set = function(info, value) E.db.tooltip[ info[#info] ] = value end,
					},
					mouseOffsetY = {
						order = 32,
						type = 'range',
						name = L["Tooltip Y-offset"],
						desc = L["Offset the tooltip on the Y-axis."],
						min = -200, max = 200, step = 1,
						set = function(info, value) E.db.tooltip[ info[#info] ] = value end,
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)