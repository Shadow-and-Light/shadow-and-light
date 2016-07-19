local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local lib = LibStub("LibElv-GameMenu-1.0")
local _G = _G
local HideUIPanel = HideUIPanel

function SLE:BuildGameMenu()
	if not E.global.sle.advanced.gameMenu.enable then return end
	local buttons = {
		[1] = {
			["name"] = "GameMenu_SLEConfig",
			["text"] = "|cff9482c9Shadow & Light|r",
			["func"] = function() if T.InCombatLockdown() then return end; E:ToggleConfig(); SLE.ACD:SelectGroup("ElvUI", "sle"); HideUIPanel(_G["GameMenuFrame"]) end,
		},
	}
	if E.global.sle.advanced.gameMenu.reload then
		T.tinsert(buttons, {["name"] = "GameMenuReloadUI", ["text"] = L["Reload UI"], ["func"] = function() ReloadUI() end})
	end
	for i = 1, #buttons do
		lib:AddMenuButton(buttons[i])
	end


	lib:UpdateHolder()
end