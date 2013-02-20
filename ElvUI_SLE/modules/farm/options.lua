local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local F = E:GetModule('Farm')

E.Options.args.sle.args.farm = {
	type = 'group',
	order = 7,
	name = L['Farm'],
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = L["FARM_DESC"],
		},
		enable = {
			type = "toggle",
			order = 2,
			name = L['Enable'],
			get = function(info) return E.private.sle.farm end,
			set = function(info, value) E.private.sle.farm = value; E:StaticPopup_Show("PRIVATE_RL") end
		},
		active = {
			order = 3,
			type = 'toggle',
			name = L['Only active buttons'],
			desc = L['Only show the buttons for the seeds, portals, tools you have in your bags.'],
			disabled = function() return not E.private.sle.farm end,
			get = function(info) return E.db.sle.farm.active end,
			set = function(info, value) E.db.sle.farm.active = value F:UpdateLayout() end,
		},
		size = {
			order = 4,
			type = "range",
			name = L["Button Size"],
			disabled = function() return not E.private.sle.farm end,
			min = 15, max = 60, step = 1,
			get = function(info) return E.db.sle.farm.size end,
			set = function(info, value) E.db.sle.farm.size = value; F:UpdateLayout() end,
		},
		seedbar = {
			type = "group",
			order = 5,
			name = L["Seed Bars"],
			guiInline = true,
			args = {
				autotarget = {
					type = "toggle",
					order = 1,
					name = L["Auto Planting"],
					desc = L["Automatically plant seeds to the nearest tilled soil if one is not already selected."],
					get = function(info) return E.db.sle.farm.autotarget end,
					set = function(info, value) E.db.sle.farm.autotarget = value; end
				},
				growth = {
					order = 8,
					type = "select",
					name = L["Dock Buttons To"],
					desc = L["Change the position from where seed bars will grow."],
					disabled = function() return not E.private.sle.farm end,
					get = function(info) return E.db.sle.farm.seedor end,
					set = function(info, value) E.db.sle.farm.seedor = value; F:UpdateLayout() end,
					values = {
						['RIGHT'] = L["Right"],
						['LEFT'] = L["Left"],
						['BOTTOM'] = L["Bottom"],
						['TOP'] = L["Top"],
					},
				},
			},
		},
	},
}