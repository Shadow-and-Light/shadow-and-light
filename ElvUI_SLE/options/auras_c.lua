local E, L, V, P, G = unpack(ElvUI); 
--local AT = E:GetModule('SLE_AuraTimers')

local function configTable()
	E.Options.args.sle.args.options.args.general.args.auras = {
		type = "group",
		name = BUFFOPTIONS_LABEL,
		order = 1,
		args = {
			header = {
				order = 1,
				type = "header",
				name = BUFFOPTIONS_LABEL,
			},
			intro = {
				order = 2,
				type = "description",
				name = "",
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				--desc = L["Show/Hide UI buttons."],
				get = function(info) return E.db.sle.auras.enable end,
				set = function(info, value) E.db.sle.auras.enable = value end
			},
			space1 = {
				order = 4,
				type = 'description',
				name = "",
			},
			space2 = {
				order = 5,
				type = 'description',
				name = "",
			},
			buffs = {
				order = 6,
				type = "toggle",
				name = L["Hide Buff Timer"],
				desc = L["This hides the time remaining for your buffs."],
				disabled = function() return not E.db.sle.auras.enable end,
				get = function(info) return E.db.sle.auras.buffs.hideTimer end,
				set = function(info, value) E.db.sle.auras.buffs.hideTimer = value end,
			},
			debuffs = {
				order = 7,
				type = "toggle",
				name = L["Hide Debuff Timer"],
				desc = L["This hides the time remaining for your debuffs."],
				disabled = function() return not E.db.sle.auras.enable end,
				get = function(info) return E.db.sle.auras.debuffs.hideTimer end,
				set = function(info, value) E.db.sle.auras.debuffs.hideTimer = value end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)