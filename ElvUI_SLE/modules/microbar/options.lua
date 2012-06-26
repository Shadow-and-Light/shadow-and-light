local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local MB = E:GetModule('Microbar')

--Microbar
E.Options.args.dpe.args.microbar = {
	type = "group",
    name = L["Microbar"],
    get = function(info) return E.db.microbar[ info[#info] ] end,
    set = function(info, value) E.db.microbar[ info[#info] ] = value; end, 
	order = 4,
   	args = {
		intro = {
			order = 1,
			type = "description",
			name = L['Module for adding micromenu to ElvUI.'],
		},
		enable = {
				order = 2,
				type = 'toggle',
				name = L['Enable'],
				set = function(info, value) E.db.microbar.enable = value; MB:MenuShow(); end,
		},
		visibility = {
			order = 3,
			type = "group",
			name = L["Visibility"],
			guiInline = true,
			disabled = function() return not E.db.microbar.enable end,
			args = {
				mouse = {
					order = 1,
					type = "toggle",
					name = L['On Mouse Over'],
					desc = L['Hide microbar unless you mouse over it.'],
					set = function(info, value) E.db.microbar.mouse = value; end,
				},
				backdrop = {
					order = 2,
					type = "toggle",
					name = L['Backdrop'],
					desc = L['Show backdrop for micromenu'],
					set = function(info, value) E.db.microbar.backdrop = value; MB:Backdrop(); end,
				},
				combat = {
					order = 3,
					type = "toggle",
					name = L['Hide in Combat'],
					desc = L['Hide Microbar in combat.'],
					set = function(info, value) E.db.microbar.combat = value; end,
				},
				alpha = {
					order = 4,
					type = "range",
					name = L['Set Alpha'],
					desc = L['Sets alpha of the microbar'],
					min = 0.2, max = 1, step = 0.01,
					set = function(info, value) E.db.microbar.alpha = value; end,
				},
				scale = {
					order = 5,
					type = "range",
					name = L['Set Scale'],
					desc = L['Sets Scale of the microbar'],
					isPercent = true,
					min = 0.3, max = 2, step = 0.01,
					set = function(info, value) E.db.microbar.scale = value; MB:Scale(); MB:MicroMoverSize(); end,
				},
			}
		},
		positioning = {
			order = 4,
			type = "group",
			name = L["Positioning"],
			guiInline = true,
			disabled = function() return not E.db.microbar.enable end,
			args = {
				layout = {
					order = 1,
					type = "select",
					name = L["Microbar Layout"],
					desc = L["Change the positioning of buttons on Microbar."],
					set = function(info, value) E.db.microbar.layout = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); end,
					values = {
						['Micro_Hor'] = L["Horizontal"],
						['Micro_Ver'] = L["Vertical"],
						['Micro_62'] = L["2 rows"],
						['Micro_43'] = L["3 rows"],
						['Micro_34'] = L["4 rows"],
						['Micro_26'] = L["6 rows"],
					},
				},
				xoffset = {
					order = 2,
					type = "range",
					name = L["X Offset"],
					desc = L["Sets X offset for microbar buttons"],
					min = 0, max = 10, step = 1,
					set = function(info, value) E.db.microbar.xoffset = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); MB:MicroMoverSize(); end,
				},
				yoffset = {
					order = 3,
					type = "range",
					name = L["Y Offset"],
					desc = L["Sets Y offset for microbar buttons"],
					min = 0, max = 10, step = 1,
					set = function(info, value) E.db.microbar.yoffset = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); MB:MicroMoverSize(); end,
				},
			},
		},	
	},
}