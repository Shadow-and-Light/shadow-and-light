local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local LSM = LibStub("LibSharedMedia-3.0")
local A = SLE:NewModule("Actionbars", 'AceHook-3.0', 'AceEvent-3.0')

local AB = E:GetModule('ActionBars');

local _G = _G
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

A.CheckedTextures = {}

function A:BarsBackdrop()
	-- Actionbar backdrops
	for i = 1, 10 do
		local transBars = {_G["ElvUI_Bar"..i]}
		for _, frame in T.pairs(transBars) do
			if frame.backdrop then
				frame.backdrop:SetTemplate('Transparent')
			end
		end
	end

	-- Other bar backdrops
	local transOtherBars = {_G["ElvUI_BarPet"], _G["ElvUI_StanceBar"], _G["ElvUI_TotemBar"], _G["ElvUIBags"]}
	for _, frame in T.pairs(transOtherBars) do
		if frame.backdrop then
			frame.backdrop:SetTemplate('Transparent')
		end
	end
	
	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G["PetActionButton"..i]}
		for _, button in T.pairs(petButtons) do
			if button.backdrop then
				button.backdrop:SetTemplate('Transparent')
			end
		end
	end
end

function A:ButtonsBackdrop()
	for i = 1, 10 do
		for k = 1, 12 do
			local buttonBars = {_G["ElvUI_Bar"..i.."Button"..k]}
			for _, button in T.pairs(buttonBars) do
				if button.backdrop then
					button.backdrop:SetTemplate('Transparent')
				end
			end
		end	
	end
end

function A:Initialize()
	if not SLE.initialized then return end
	if E.private.actionbar.enable ~= true then return; end
	A.MaxBars = T.IsAddOnLoaded('ElvUI_ExtraActionBars') and 10 or 6

	if E.private.sle.actionbars.oorBind then 
		hooksecurefunc(AB, "UpdateButtonConfig", function(self, bar, buttonName)
			if T.InCombatLockdown() then return end

			bar.buttonConfig.outOfRangeColoring = "hotkey"
			for i, button in T.pairs(bar.buttons) do
				bar.buttonConfig.keyBoundTarget = T.format(buttonName.."%d", i)
				button.keyBoundTarget = bar.buttonConfig.keyBoundTarget

				button:UpdateConfig(bar.buttonConfig)
			end
		end)
		for barName, bar in T.pairs(AB["handledBars"]) do
			AB:UpdateButtonConfig(bar, bar.bindButtons)
		end
	end

	if E.private.sle.actionbars.checkedtexture and not (LibStub("Masque", true) and E.private.actionbar.masque.actionbars) then
		hooksecurefunc(AB, "PositionAndSizeBar", function(self, barName)
			local bar = self["handledBars"][barName]
			if not A.CheckedTextures[barName] then A.CheckedTextures[barName] = {} end
			for i=1, NUM_ACTIONBAR_BUTTONS do
				local button = bar.buttons[i];
				if button.SetCheckedTexture then 
					if not A.CheckedTextures[barName][i] then
						A.CheckedTextures[barName][i] = button:CreateTexture(button:GetName().."CheckedTexture", "OVERLAY")
					end
					local color = E.private.sle.actionbars.checkedColor
					button.checked = A.CheckedTextures[barName][i]
					button.checked:SetTexture(color.r, color.g, color.b, color.a)
					button.checked:SetInside()
					button:SetCheckedTexture(A.CheckedTextures[barName][i])
				end
			end
		end)
		for i=1, A.MaxBars do
			AB:PositionAndSizeBar('bar'..i)
		end
	end
	
	C_Timer.After(0.3, function()
		if E.private.sle.actionbars.transparentBackdrop then A:BarsBackdrop() end
		if E.private.sle.actionbars.transparentButtons then A:ButtonsBackdrop() end
	end)
end

SLE:RegisterModule(A:GetName())