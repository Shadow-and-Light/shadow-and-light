local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local _G = _G
local HideUIPanel = HideUIPanel
local ReloadUI = ReloadUI

local lib = LibStub('LibElv-GameMenu-1.0')

function SLE:BuildGameMenu()
	if not E.global.sle.advanced.gameMenu.enable then return end
	local buttons = {
		[1] = {
			name = 'GameMenu_SLEConfig',
			text = '|cff9482c9Shadow & Light|r',
			func = function()
				if InCombatLockdown() then return end
				E:ToggleOptions()
				E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'sle')
				HideUIPanel(_G.GameMenuFrame)
			end,
		},
	}
	if E.global.sle.advanced.gameMenu.reload then
		tinsert(buttons, {name = 'GameMenuReloadUI', text = E.global.sle.advanced.gameMenu.reloadLabel ~= "" and E.global.sle.advanced.gameMenu.reloadLabel or L["Reload UI"], func = function() ReloadUI() end})
	end
	for i = 1, #buttons do
		lib:AddMenuButton(buttons[i])
	end

	lib:UpdateHolder()
end
