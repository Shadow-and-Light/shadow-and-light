local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
V['skins']['addons'] = {
	['EmbedSkada'] = true,
}

V['sle'] = {
	--Character Frame Options
	['characterframeoptions'] = {
		['enable'] = false,
	},
	
	['inspectframeoptions'] = {
		['enable'] = false,
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
		['setoverlay'] = false,
	},
	
	['marks'] = {
		['marks'] = false,
		['flares'] = false,
	},

	--Minimap Moduel
	['minimap'] = {
		['buttons'] = {
			['enable'] = true,
		},
		['mapicons'] = {
			['enable'] = false,
		},
	},
	
	['loot'] = {
		['enable'] = false,
		['autoconfirm'] = false,
		['autogreed'] = false,
		['autodisenchant'] = false,
	},

	['vehicle'] = {
		['enable'] = false,
	},

	['backgrounds'] = false,
}

G['sle'] = {
	['export'] = {
		['full'] = false,
		['profile'] = true,
		['private'] = false,
		['global'] = false,
	},
}