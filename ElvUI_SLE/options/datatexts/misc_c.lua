local SLE, _, E, L = unpack(select(2, ...))
local DTP = SLE:GetModule('Datatexts')
local DT = E:GetModule('DataTexts')

--GLOBALS: unpack, select, tinsert, DURABILITY, MANA_REGEN
local tinsert = tinsert
local MANA_REGEN = MANA_REGEN

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slmail = {
		type = "group",
		name = L["S&L Mail"],
		order = 5,
		args = {
			desc = ACH:Description(L["These options are for modifying the Shadow & Light Mail datatext."], 1, "large"),
			icon = {
				order = 2,
				type = "toggle",
				name = L["Minimap icon"],
				desc = L["If enabled will show new mail icon on minimap."],
				get = function() return E.db.sle.dt.mail.icon end,
				set = function(_, value) E.db.sle.dt.mail.icon = value; DTP:MailUp() end,
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
				get = function() return E.db.sle.dt.regen.short end,
				set = function(_, value) E.db.sle.dt.regen.short = value; DT:LoadDataTexts(); end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)