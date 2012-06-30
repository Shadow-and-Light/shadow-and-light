local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB

V['namelist'] = {};
V['channellist'] = {};

V['channelcheck'] = {
	['say'] = false,
	['yell'] = false,
	['party'] = true,
	['raid'] = true,
	['battleground'] = false,
	['guild'] = true,
	['officer'] = false,
	['general'] = false,
	['trade'] = false,
	['defense'] = false,
	['lfg'] = false,
	['time'] = 3,
}

V['dpe'] = {
	--Auras Frame
	['auras'] = {
		['size'] = 30,
	},

	--Skada Backdrop
	['skadaback'] = true,
	
	['dbm'] = {
		['size'] = 10,
	},
}