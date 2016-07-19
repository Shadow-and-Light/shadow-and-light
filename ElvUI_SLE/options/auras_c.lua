local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local BUFFOPTIONS_LABEL = BUFFOPTIONS_LABEL
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.auras = {
		type = "group",
		name = BUFFOPTIONS_LABEL,
		order = 4,
		disabled = function() return not E.private.auras.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = BUFFOPTIONS_LABEL,
			},
			intro = {
				order = 2,
				type = "description",
				name = L["AURAS_DESC"],
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
				get = function(info) return E.db.sle.auras.hideBuffsTimer end,
				set = function(info, value) E.db.sle.auras.hideBuffsTimer = value end,
			},
			debuffs = {
				order = 7,
				type = "toggle",
				name = L["Hide Debuff Timer"],
				desc = L["This hides the time remaining for your debuffs."],
				get = function(info) return E.db.sle.auras.hideDebuffsTimer end,
				set = function(info, value) E.db.sle.auras.hideDebuffsTimer = value end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)