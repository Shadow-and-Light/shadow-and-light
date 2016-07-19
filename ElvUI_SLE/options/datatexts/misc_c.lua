local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DTP = SLE:GetModule('Datatexts')
local DT = E:GetModule('DataTexts')
local datatexts = {}
local RAID_FINDER = RAID_FINDER
local RAIDS = RAIDS
local EXPANSION_NAME3, EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6 = EXPANSION_NAME3, EXPANSION_NAME4, EXPANSION_NAME5, EXPANSION_NAME6
local DURABILITY = DURABILITY
local MANA_REGEN = MANA_REGEN

local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slmail = {
		type = "group",
		name = L["S&L Mail"],
		order = 5,
		args = {
			header = {
				order = 1,
				type = "description",
				name = L["These options are for modifing the Shadow & Light Mail datatext."],
			},
			icon = {
				order = 2,
				type = "toggle",
				name = L["Minimap icon"],
				desc = L["If enabled will show new mail icon on minimap."],
				get = function(info) return E.db.sle.dt.mail.icon end,
				set = function(info, value) E.db.sle.dt.mail.icon = value; DTP:MailUp() end,
			}
		},
	}
	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.sldurability = {
		type = "group",
		name = DURABILITY,
		order = 6,
		get = function(info) return E.db.sle.dt.durability[ info[#info] ] end,
		set = function(info, value) E.db.sle.dt.durability[ info[#info] ] = value; DT:LoadDataTexts(); end,
		args = {
			header = {
				order = 1,
				type = "description",
				name = L["Options below are for standard ElvUI's durability datatext."],
			},
			gradient = {
				order = 2,
				type = "toggle",
				name = L["Gradient"],
				desc = L["If enabled will color durability text based on it's value."],
				
			},
			threshold = {
				order = 3,
				type = "range",
				min = -1, max = 99, step = 1,
				name = L["Durability Threshold"],
				desc = L["Datatext will flash if durability shown will be equal or lower that this value. Set to -1 to disable"],
			}
		},
	}
	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slregen = {
		type = "group",
		name = MANA_REGEN,
		order = 7,
		args = {
			short = {
				order = 1,
				type = "toggle",
				name = L["Short text"],
				desc = L["Changes the text string to a shorter variant."],
				get = function(info) return E.db.sle.dt.regen.short end,
				set = function(info, value) E.db.sle.dt.regen.short = value; DT:LoadDataTexts(); end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)