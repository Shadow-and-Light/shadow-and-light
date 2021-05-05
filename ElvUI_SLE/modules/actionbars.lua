local SLE, _, E = unpack(select(2, ...))
local A = SLE.Actionbars
local AB = E.ActionBars

--GLOBALS: unpack, select, hooksecurefunc, NUM_ACTIONBAR_BUTTONS, LibStub
local hooksecurefunc = hooksecurefunc
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

A.CheckedTextures = {}

function A:Initialize()
	if not SLE.initialized or E.private.actionbar.enable ~= true then return end
	A.MaxBars = 10 --In case ExtraActionBars is enabled. Cause 7+ bars will not be affected otherwise

	--Creating checked textures on actionbars
	if E.private.sle.actionbars.checkedtexture and not (LibStub('Masque', true) and E.private.actionbar.masque.actionbars) then
		hooksecurefunc(AB, 'PositionAndSizeBar', function(_, barName)
			local bar = AB['handledBars'][barName]
			if not A.CheckedTextures[barName] then A.CheckedTextures[barName] = {} end

			for i=1, NUM_ACTIONBAR_BUTTONS do
				local button = bar.buttons[i]

				if button.SetCheckedTexture then
					if not A.CheckedTextures[barName][i] then
						A.CheckedTextures[barName][i] = button:CreateTexture(button:GetName()..'CheckedTexture', 'OVERLAY')
					end

					local color = E.private.sle.actionbars.checkedColor
					button.checked = A.CheckedTextures[barName][i]
					button.checked:SetColorTexture(color.r, color.g, color.b, color.a)
					button.checked:SetInside()
					button:SetCheckedTexture(A.CheckedTextures[barName][i])
				end
			end
		end)
	end

	for i = 1, 10 do
		AB:PositionAndSizeBar('bar'..i)
	end
end

SLE:RegisterModule(A:GetName())
