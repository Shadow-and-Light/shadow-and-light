local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local M = E:GetModule('Misc')

function M:ErrorFrameToggle(event)
	if event == 'PLAYER_REGEN_DISABLED' and not E.db.sle.errors then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end