local E, L, V, P, G, _ = unpack(ElvUI); 
local RM = E:GetModule('SLE_RaidMarks')
local RF = E:GetModule('SLE_RaidFlares')
local function configTable()

E.Options.args.sle.args.options.args.marks = {
	order = 4,
	type = "group",
	name = L["Raid Marks"],
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L['Options for panels providing fast access to raid markers and flares.'],
		},
		marks = {
			order = 2,
			type = "group",
			name = L["Raid Marks"],
			args = {
				marksheader = {
					order = 1,
					type = "header",
					name = L["Raid Marks"],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide raid marks."],
					get = function(info) return E.private.sle.marks.marks end,
					set = function(info, value) E.private.sle.marks.marks = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				backdrop = {
					order = 3,
					type = "toggle",
					name = L["Backdrop"],
					disabled = function() return not E.private.sle.marks.marks end,
					get = function(info) return E.db.sle.marks.backdrop end,
					set = function(info, value) E.db.sle.marks.backdrop = value; RM:Backdrop() end
				},
				Reset = {
					order = 4,
					type = 'execute',
					name = L['Restore Defaults'],
					desc = L["Reset these options to defaults"],
					disabled = function() return not E.private.sle.marks.marks end,
					func = function() E:GetModule('SLE'):Reset(nil, nil, nil, nil, true) end,
				},
				spacer = {
					order = 5,
					type = 'description',
					name = "",
				},
				showinside = {
					order = 6,
					type = "toggle",
					name = L["Show only in instances"],
					desc = L["Selecting this option will have the Raid Markers appear only while in a raid or dungeon."],
					disabled = function() return not E.private.sle.marks.marks end,
					get = function(info) return E.db.sle.marks.showinside end,
					set = function(info, value) E.db.sle.marks.showinside = value; RM:UpdateVisibility() end
				},
				target = {
					order = 7,
					type = "toggle",
					name = L["Target Exists"],
					desc = L["Selecting this option will have the Raid Markers appear only when you have a target."],
					disabled = function() return not E.private.sle.marks.marks end,
					get = function(info) return E.db.sle.marks.target end,
					set = function(info, value) E.db.sle.marks.target = value; RM:Target(); RM:UpdateVisibility() end
				},
				mouseover = {
					order = 7,
					type = "toggle",
					name = L["Mouseover"],
					desc = L["Show on mouse over."],
					disabled = function() return not E.private.sle.marks.marks end,
					get = function(info) return E.db.sle.marks.mouseover end,
					set = function(info, value) E.db.sle.marks.mouseover = value; RM:UpdateVisibility() end 
				},
				size = {
					order = 9,
					type = "range",
					name = L['Size'],
					desc = L["Sets size of buttons"],
					disabled = function() return not E.private.sle.marks.marks end,
					min = 15, max = 30, step = 1,
					get = function(info) return E.db.sle.marks.size end,
					set = function(info, value) E.db.sle.marks.size = value; RM:FrameButtonsGrowth(); RM:FrameButtonsSize() end,
				},
				growth = {
					order = 10,
					type = "select",
					name = L["Direction"],
					desc = L["Change the direction of buttons growth from the skull marker"],
					disabled = function() return not E.private.sle.marks.marks end,
					get = function(info) return E.db.sle.marks.growth end,
					set = function(info, value) E.db.sle.marks.growth = value; RM:FrameButtonsGrowth() end,
					values = {
						['RIGHT'] = L["Right"],
						['LEFT'] = L["Left"],
						['UP'] = L["Up"],
						['DOWN'] = L["Down"],
					},
				},
			},
		},
		flares = {
			order = 3,
			type = "group",
			name = L["Raid Flares"],
			args = {
				header = {
					order = 1,
					type = "header",
					name = L["Raid Flares"],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show/Hide Raid Flares."],
					get = function(info) return E.private.sle.marks.flares end,
					set = function(info, value) E.private.sle.marks.flares = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				backdrop = {
					order = 3,
					type = "toggle",
					name = L["Backdrop"],
					disabled = function() return not E.private.sle.marks.flares end,
					get = function(info) return E.db.sle.flares.backdrop end,
					set = function(info, value) E.db.sle.flares.backdrop = value; RF:Backdrop() end
				},
				spacer = {
					order = 5,
					type = 'description',
					name = "",
				},
				showinside = {
					order = 6,
					type = "toggle",
					name = L["Show only in instances"],
					desc = L["Selecting this option will have the Raid Flares appear only while in a raid or dungeon."],
					disabled = function() return not E.private.sle.marks.flares end,
					get = function(info) return E.db.sle.flares.showinside end,
					set = function(info, value) E.db.sle.flares.showinside = value; RF:UpdateVisibility() end
				},
				mouseover = {
					order = 7,
					type = "toggle",
					name = L["Mouseover"],
					desc = L["Show on mouse over."],
					disabled = function() return not E.private.sle.marks.flares end,
					get = function(info) return E.db.sle.flares.mouseover end,
					set = function(info, value) E.db.sle.flares.mouseover = value; RF:UpdateVisibility() end
				},
				tooltips = {
					order = 8,
					type = "toggle",
					name = L["Show Tooltip"],
					disabled = function() return not E.private.sle.marks.flares end,
					get = function(info) return E.db.sle.flares.tooltips end,
					set = function(info, value) E.db.sle.flares.tooltips = value; end
				},
				size = {
					order = 9,
					type = "range",
					name = L['Size'],
					desc = L["Sets size of buttons"],
					disabled = function() return not E.private.sle.marks.flares end,
					min = 15, max = 30, step = 1,
					get = function(info) return E.db.sle.flares.size end,
					set = function(info, value) E.db.sle.flares.size = value; RF:FrameButtonsGrowth(); RF:FrameButtonsSize() end,
				},
				growth = {
					order = 9,
					type = "select",
					name = L["Direction"],
					desc = L["Change the direction of buttons growth from the square marker"],
					disabled = function() return not E.private.sle.marks.flares end,
					get = function(info) return E.db.sle.flares.growth end,
					set = function(info, value) E.db.sle.flares.growth = value; RF:FrameButtonsGrowth() end,
					values = {
						['RIGHT'] = L["Right"],
						['LEFT'] = L["Left"],
						['UP'] = L["Up"],
						['DOWN'] = L["Down"],
					},
				},
			},
		},
	},
}
end

table.insert(E.SLEConfigs, configTable)