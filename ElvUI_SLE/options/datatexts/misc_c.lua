local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DT = E.DataTexts

--GLOBALS: unpack, select, tinsert, DURABILITY, MANA_REGEN
local tinsert = tinsert
local MANA_REGEN = MANA_REGEN

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext.args.slregen = {
		type = 'group',
		name = MANA_REGEN,
		order = 7,
		args = {
			short = {
				order = 1,
				type = 'toggle',
				name = L["Short text"],
				desc = L["Changes the text string to a shorter variant."],
				get = function() return E.db.sle.dt.regen.short end,
				set = function(_, value) E.db.sle.dt.regen.short = value; DT:LoadDataTexts() end,
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
