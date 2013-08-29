local E, L, V, P, G, _ =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
V['skins']['addons'] = {
	['EmbedSkada'] = true,
}
V['sle'] = {
	['dbm'] = {
		['size'] = 10,
	},
	
	--Character Frame Options
	['characterframeoptions'] = {
		["enable"] = false,
	},
	
	["datatext"] = {
		["dp1hide"] = false,
		["dp2hide"] = false,
		["tophide"] = false,
		["dp3hide"] = false,
		["dp4hide"] = false,
		["dp5hide"] = false,
		["bottomhide"] = false,
		["dp6hide"] = false,
	},

	['exprep'] = {
		['autotrack'] = false,
	},

	['farm'] = {
		['enable'] = false,
		['seedtrash'] = false,
	},
	
	['equip'] = {
		['enable'] = false,
		['spam'] = false,
		['primary'] = "NONE",
		['secondary'] = "NONE",
		['instance'] = "NONE",
		['pvp'] = "NONE",
	},

	--Minimap Moduel
	['minimap'] = {
		['buttons'] = {
			['enable'] = true,
		},
	},
	
	['loot'] = {
		['enable'] = false,
	},
}
