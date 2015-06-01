local E, L, V, P, G = unpack(ElvUI); 
local BG = E:GetModule('SLE_BackGrounds')

local function configTable()
	--GroupName = { ShortName, Order }
	local drop = {
		["Bottom BG"] = {"bottom", 1},
		["Left BG"] = {"left", 2},
		["Right BG"] = {"right", 3},
		["Actionbar BG"] = {"action", 4},
	}

	--Options for additional background frames. Main group
	E.Options.args.sle.args.datatext.args.backgrounds = {
		type = "group",
		name = L["Backgrounds"],
		order = 3,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Additional Background Panels"],
			},
			intro = {
				order = 2,
				type = "description",
				name = L["BG_DESC"]
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = ENABLE,
				desc = L["Show/Hide this frame."],
				get = function(info) return E.private.sle.backgrounds end,
				set = function(info, value) E.private.sle.backgrounds = value; E:StaticPopup_Show("PRIVATE_RL") end
			},
			Reset = {
				order = 4,
				type = 'execute',
				name = L['Restore Defaults'],
				desc = L["Reset these options to defaults"],
				disabled = function() return not E.private.sle.backgrounds end,
				func = function() E:GetModule('SLE'):Reset("backgrounds") end,
			},
			spacerreset = {
				order = 5,
				type = 'description',
				name = "",
			},
			bottom_enabled = {
				order = 6,
				type = "toggle",
				name = L["Bottom BG"],
				desc = L["Show/Hide this frame."],
				disabled = function() return not E.private.sle.backgrounds end,
				get = function(info) return E.db.sle.backgrounds.bottom.enabled end,
				set = function(info, value) E.db.sle.backgrounds.bottom.enabled = value; BG:FramesVisibility() end
			},
			left_enabled = {
				order = 7,
				type = "toggle",
				name = L["Left BG"],
				desc = L["Show/Hide this frame."],
				disabled = function() return not E.private.sle.backgrounds end,
				get = function(info) return E.db.sle.backgrounds.left.enabled end,
				set = function(info, value) E.db.sle.backgrounds.left.enabled = value; BG:FramesVisibility() end
			},
			spacer = {
				order = 8,
				type = "description",
				name = "",
			},
			right_enabled = {
				order = 9,
				type = "toggle",
				name = L["Right BG"],
				desc = L["Show/Hide this frame."],
				disabled = function() return not E.private.sle.backgrounds end,
				get = function(info) return E.db.sle.backgrounds.right.enabled end,
				set = function(info, value) E.db.sle.backgrounds.right.enabled = value; BG:FramesVisibility() end
			},
			action_enabled = {
				order = 10,
				type = "toggle",
				name = L["Actionbar BG"],
				desc = L["Show/Hide this frame."],
				disabled = function() return not E.private.sle.backgrounds end,
				get = function(info) return E.db.sle.backgrounds.action.enabled end,
				set = function(info, value) E.db.sle.backgrounds.action.enabled = value; BG:FramesVisibility() end
			},
		}
	}

	--Subgroups
	for k,v in pairs(drop) do
		E.Options.args.sle.args.datatext.args.backgrounds.args[v[1]] = {
			type = "group",
			name = L[k],
			order = v[2],
			get = function(info) return E.db.sle.backgrounds[v[1]][ info[#info] ] end,
			disabled = function() return not E.db.sle.backgrounds[v[1]].enabled or not E.private.sle.backgrounds end,
			args = {
				width = {
					order = 1,
					type = "range",
					name = L['Width'],
					desc = L["Sets width of the frame"],
					min = 50, max = E.screenwidth, step = 1,
					set = function(info, value) E.db.sle.backgrounds[v[1]].width = value; BG:FramesSize() end,
				},
				height = {
					order = 2,
					type = "range",
					name = L['Height'],
					desc = L["Sets height of the frame"],
					min = 30, max = E.screenheight/2, step = 1,
					set = function(info, value) E.db.sle.backgrounds[v[1]].height = value; BG:FramesSize() end,
				},
				spacer = {
					order = 3,
					type = "description",
					name = "",
				},
				texture = {
					order = 6,
					type = 'input',
					width = 'full',
					name = L["Texture"],
					desc = L["Set the texture to use in this frame.  Requirements are the same as the chat textures."],
					set = function(info, value) 
						E.db.sle.backgrounds[v[1]].texture = value
						E:UpdateMedia()
						BG:UpdateTex()
					end,
				},
				template = {
					order = 7,
					type = "select",
					name = L["Backdrop Template"],
					desc = L["Change the template used for this backdrop."],
					get = function(info) return E.db.sle.backgrounds[v[1]].template end,
					set = function(info, value) E.db.sle.backgrounds[v[1]].template = value; BG:UpdateFrames() end,
					values = {
						['Default'] = L["Default"],
						['Transparent'] = L["Transparent"],
					},
				},
				pethide = {
					order = 8,
					type = "toggle",
					name = L["Hide in Pet Batlle"],
					desc = L["Show/Hide this frame during Pet Battles."],
					set = function(info, value) E.db.sle.backgrounds[v[1]].pethide = value; BG:RegisterHide() end
				},
				clickthrough = {
					order = 9,
					type = "toggle",
					name = L["Click Through"],
					set = function(info, value) E.db.sle.backgrounds[v[1]].clickthrough = value; BG:MouseCatching() end
				},
				alpha = {
					order = 12,
					type = 'range',
					name = L['Alpha'],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.db.sle.backgrounds[v[1]].alpha end,
					set = function(info, value) E.db.sle.backgrounds[v[1]].alpha = value; BG:UpdateFrames() end,
				},
			},
		}
	end
end

table.insert(E.SLEConfigs, configTable)