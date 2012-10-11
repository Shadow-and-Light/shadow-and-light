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
