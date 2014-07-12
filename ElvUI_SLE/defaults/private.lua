local E, L, V, P, G, _ =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
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
	},

	['vehicle'] = {
		['enable'] = false,
	},
	
	['guildmaster'] = false,
	['backgrounds'] = false,
}

G['sle'] = {
	['fonts'] = {
		['enable'] = false,
		['zone'] = {
			['font'] = "ElvUI Font",
			['size'] = 32,
			['outline'] = "OUTLINE",
		},
		['subzone'] = {
			['font'] = "ElvUI Font",
			['size'] = 25,
			['outline'] = "OUTLINE",
		},
	},
}