local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P['sle'] = {
	--Background frames
	['backgrounds'] = {
		['bottom'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/4 + 32,
			['height'] = E.screenheight/6 - 13,
			['xoffset'] = 0,
			['yoffset'] = 0,
		},
		['left'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/10 - 4,
			['height'] = E.screenheight/5 + 11,
			['xoffset'] = 0,
			['yoffset'] = 0,
		},
		['right'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/10 - 4,
			['height'] = E.screenheight/5 + 11,
			['xoffset'] = 0,
			['yoffset'] = 0,
		},
		['action'] = {
			['enabled'] = false,
			['trans'] = false,
			['texture'] = "",
			['width'] = E.screenwidth/4 + 32,
			['height'] = E.screenheight/20 + 5,
			['xoffset'] = 0,
			['yoffset'] = 0,
		},
	},
	
	--Raid marks
	['marks'] = {
		['enabled'] = true,
		['growth'] = "RIGHT",
		['size'] = 18,
	},
	
	--Balance text
	['bpenable'] = false;
	
	--Auto release
	['pvpautorelease'] = true,
	
	--Datatexts panels
	['datatext'] = {
		['dp1'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},	
		['dp2'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},
		['top'] = {
			['enabled'] = true,
			['width'] = E.screenwidth/5 - 4,
		},
		['dp3'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},
		['dp4'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/5,
		},	
		['dp5'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
		},	
		['bottom'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/10 - 4,
		},
		['dp6'] = {
			['enabled'] = false,
			['width'] = E.screenwidth/4 - 60,
		},
		['chatleft'] = {
			['enabled'] = true,
			['width'] = 396,
		},
		['chatright'] = {
			['enabled'] = true,
			['width'] = 396,
		},
	},
	
	--Raid Utility
	['raidutil'] = {
		['xpos'] = E.screenwidth/3,
		['ypos'] = E.screenheight - 16,
	},
	
	--Exp/Rep info
	['xprepinfo'] = {
		['enabled'] = false,
		['xprepdet'] = false,
		['repreact'] = false,
		['xprest'] = false,
	},
	
	--PvP indicator
	['pvp'] = {
		['pos'] = 'CENTER',
		['mouse'] = true,
	},
	
	--Combat Icon
	['combatico'] = {
		['pos'] = 'TOP',
	},
	
	--UI Buttons
	['uibuttons'] = {
		['enable'] = false,
		['size'] = 17,
		['mouse'] = false,
		['position'] = "uib_vert",
	},
	
	--Pet Bar Autocast
	['petbar'] = {
		['autocast'] = true,
	},
	
	--Chat
	['chat'] = {
		['fade'] = false,
		['sound'] = false,
		['warningsound'] = "ElvUI Warning",
	},
	
	--Unit Frames text formatting
	['unitframes'] = {
		['reverse'] = {
			['health'] = false,
			['mana'] = false,
		},
		['normal'] = {
			['health'] = false,
			['mana'] = false,
		},
	},
}

P['microbar'] = {
	['enable'] = true,
	['mouse'] = false, --Mouseover
    ['backdrop'] = true, --Backdrop
	['combat'] = false, --Hide in combat
	['alpha'] = 1, --Transparency
	['scale'] = 1, --Scale
	['layout'] = "Micro_Hor", --Button layuot format
	['xoffset'] = 0,
	['yoffset'] = 0,
}

--For some reason datatext settings refuses to work if there is no general setting block here O_o
--Core
P['general'] = {
	["taingLog"] = false,
	["autoscale"] = true,
	["stickyFrames"] = true,
	['loginmessage'] = true,
	["interruptAnnounce"] = "NONE",
	["autoRepair"] = "NONE",
	['vendorGrays'] = false,
	['autoAcceptInvite'] = false,
	
	-- fonts
	["fontsize"] = 11,
	["font"] = "ElvUI Pixel",
	
	--colors
	["bordercolor"] = { r = 0.1,g = 0.1,b = 0.1 },
	["backdropcolor"] = { r = 0.1,g = 0.1,b = 0.1 },
	["backdropfadecolor"] = { r = .054,g = .054,b = .054, a = 0.8 },
	["valuecolor"] = {r = 23/255,g = 132/255,b = 209/255},
	
	--panels
	['panelWidth'] = 412,
	['panelHeight'] = 180,
	['panelBackdropNameLeft'] = '',
	['panelBackdropNameRight'] = '',
	['panelBackdrop'] = 'SHOWBOTH',
	['expRepPos'] = 'TOP_SCREEN',
	
	--misc
	['mapTransparency'] = 1,
	['minimapSize'] = 176,
	['raidReminder'] = true,
	['minimapPanels'] = true,
	['tinyWorldMap'] = true,
	['minimapLocationText'] = 'MOUSEOVER',
};

P.chat.editboxhistory = 5
P.auras.perRow = 19

--Datatexts
if IsAddOnLoaded("ElvUI_LocPlus") then
P['datatexts'] = {
	['panels'] = {
		['LeftChatDataPanel'] = {
			['left'] = 'Armor',
			['middle'] = 'Durability',
			['right'] = 'Avoidance',
		},
		['RightChatDataPanel'] = {
			['left'] = 'System',
			['middle'] = 'Time',	
			['right'] = 'Gold',
		},
		['DP_1'] = {
			['left'] = 'Swatter',
			['middle'] = 'Skada',
			['right'] = 'MrtWoo',
		},
		['DP_2'] = {
			['left'] = 'Altoholic',
			['middle'] = 'TellMeWhen',
			['right'] = 'AtlasLoot',
		},
		['DP_3'] = {
			['left'] = 'Notes',
			['middle'] = 'DBM-LDB',
			['right'] = 'WIM',
		},
		['DP_4'] = {
			['left'] = '',
			['middle'] = '',
			['right'] = '',
		},
		['DP_5'] = {
			['left'] = 'Bags',
			['middle'] = 'Gold',
			['right'] = 'Armor',
		},
		['DP_6'] = {
			['left'] = 'Spell/Heal Power',
			['middle'] = 'Haste',
			['right'] = 'Crit Chance',
		},
		['Bottom_Panel'] = 'System',
		['LeftMiniPanel'] = 'Guild',
		['RightMiniPanel'] = 'Friends',
		['RightCoordDtPanel'] = 'System', --LocPlus
		['LeftCoordDtPanel'] = 'Durability', --LocPlus
	},
	['localtime'] = true,
	['time24'] = false,
	['battleground'] = true,
}
else
P['datatexts'] = {
	['panels'] = {
		['LeftChatDataPanel'] = {
			['left'] = 'Armor',
			['middle'] = 'Durability',
			['right'] = 'Avoidance',
		},
		['RightChatDataPanel'] = {
			['left'] = 'System',
			['middle'] = 'Time',	
			['right'] = 'Gold',
		},
		['DP_1'] = {
			['left'] = 'Swatter',
			['middle'] = 'Skada',
			['right'] = 'MrtWoo',
		},
		['DP_2'] = {
			['left'] = 'Altoholic',
			['middle'] = 'TellMeWhen',
			['right'] = 'AtlasLoot',
		},
		['DP_3'] = {
			['left'] = 'Notes',
			['middle'] = 'DBM-LDB',
			['right'] = 'WIM',
		},
		['DP_4'] = {
			['left'] = '',
			['middle'] = '',
			['right'] = '',
		},
		['DP_5'] = {
			['left'] = 'Bags',
			['middle'] = 'Gold',
			['right'] = 'Armor',
		},
		['DP_6'] = {
			['left'] = 'Spell/Heal Power',
			['middle'] = 'Haste',
			['right'] = 'Crit Chance',
		},
		['Bottom_Panel'] = 'System',
		['LeftMiniPanel'] = 'Guild',
		['RightMiniPanel'] = 'Friends',
	},
	['localtime'] = true,
	['time24'] = false,
	['battleground'] = true,
}
end

P.unitframe.units.player.classbar.xOffset = 0
P.unitframe.units.player.classbar.yOffset = 0
P.unitframe.units.player.classbar.offset = false

