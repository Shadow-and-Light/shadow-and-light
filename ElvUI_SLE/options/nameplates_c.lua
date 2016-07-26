local SLE, T, E, L, V, P, G = unpack(select(2, ...))

local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.nameplate = {
		type = "group",
		name = L["NamePlates"],
		order = 14,
		disabled = function() return not E.private.nameplates.enable end,
		get = function(info) return E.db.sle.nameplates[ info[#info] ] end,
		set = function(info, value) E.db.sle.nameplates[ info[#info] ] = value; E:GetModule('NamePlates'):ConfigureAll() end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NamePlates"],
			},
			targetcount = {
				type = "toggle",
				order = 2,
				name = L["Target Count"],
				desc = L["Display the number of party / raid members targetting the nameplate unit."],
			},
			showthreat = {
				type = "toggle",
				order = 3,
				name = L["Threat Text"],
				desc = L["Display threat level as text on targeted, boss or mouseover nameplate."],
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)