local E, L, V, P, G = unpack(ElvUI);

V['skins']['addons'] = {
	['EmbedSkada'] = true,
}

V['sle'] = {
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

	['uiButtonStyle'] = "dropdown",
	
	['auras'] = {
		['consolidatedMark'] = false,
	},
}

G['sle'] = {
	['export'] = {
		['full'] = false,
		['profile'] = true,
		['private'] = false,
		['global'] = false,
	},
}