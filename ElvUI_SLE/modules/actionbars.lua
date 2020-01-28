local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local A = SLE:NewModule("Actionbars", 'AceHook-3.0', 'AceEvent-3.0')
local AB = E:GetModule('ActionBars');
--GLOBALS: hooksecurefunc, LibStub
local _G = _G
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local C_Timer_After = C_Timer.After

A.CheckedTextures = {}

function A:Initialize()
	if not SLE.initialized or E.private.actionbar.enable ~= true then return; end
	A.MaxBars = 10 --In case ExtraActionBars is enabled. Cause 7+ bars will not be affected otherwise

	--Making OOR indication use keybind text
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
		--Calling for update since at this point all default updates are done
		for barName, bar in T.pairs(AB["handledBars"]) do
			AB:UpdateButtonConfig(bar, bar.bindButtons)
		end
	end

	--Creating checked textures on actionbars
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
end

SLE:RegisterModule(A:GetName())