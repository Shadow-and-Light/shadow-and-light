local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local M = E:GetModule('Misc')

function M:ErrorFrameToggle(event)
	if event == 'PLAYER_REGEN_DISABLED' and E.private.sle.errors ~= true then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end

E.Options.args.sle.args.general.args.errors = {
	order = 3,
	type = "toggle",
	name = L["Errors in combat"],
	desc = L["Show/hide error messages in combat."],
	get = function(info) return E.private.sle.errors end,
	set = function(info, value) E.private.sle.errors = value; E:StaticPopup_Show("PRIVATE_RL") end
}



--[[E.Options.args.sle.args.auras = {
	type = "group",
	name = L["],
	order = 5,
	guiInline = true,
	args = {
		info = {
			order = 1,
			type = "description",
			name = L["Options for customizing auras near the minimap."],
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Caster Name"],
			desc = L["Enabling this will show caster name in the buffs and debuff icons."],
			get = function(info) return E.private.sle.auras.castername end,
			set = function(info, value) E.private.sle.auras.castername = value; E:StaticPopup_Show("PRIVATE_RL") end,
		},
	},
}]]