local E, L, V, P, G = unpack(ElvUI); 
local AT = E:GetModule('SLE_AuraTimers')
local A = E:GetModule('Auras')


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
				name = L['AURAS_DESC'],
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = ENABLE,
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
			space3 = {
				order = 8,
				type = 'description',
				name = "",
			},
			consolidatedMark = {
				order = 9,
				type = "toggle",
				name = L["Mark Your Consolidated Buffs"],
				desc = L["Create a mark bar on a consolidated buffs bar's icons for buffs your class can provide."],
				disabled = function() return (E.private.general.minimap.enable ~= true or E.private.auras.disableBlizzard ~= true) end,
				get = function(info) return E.private.sle.auras.consolidatedMark end,
				set = function(info, value) E.private.sle.auras.consolidatedMark = value; AT:BuildCasts(); A:Update_ConsolidatedBuffsSettings() end,
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)