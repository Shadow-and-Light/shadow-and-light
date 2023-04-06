local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local A = SLE.Actionbars
local AB = E.ActionBars

--GLOBALS: unpack, select, hooksecurefunc, NUM_ACTIONBAR_BUTTONS, LibStub
local hooksecurefunc = hooksecurefunc
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function A:Initialize()
	if not SLE.initialized or E.private.actionbar.enable ~= true then return end

	--Creating checked textures on actionbars
	if E.private.sle.actionbars.checkedtexture and not (LibStub('Masque', true) and E.private.actionbar.masque.actionbars) then
		hooksecurefunc(AB, 'PositionAndSizeBar', function(_, barName)
			local bar = AB['handledBars'][barName]

			for i=1, NUM_ACTIONBAR_BUTTONS do
				local button = bar.buttons[i]
				if button.checked and button.checked.SetColorTexture then
					local color = E.private.sle.actionbars.checkedColor
					button.checked:SetColorTexture(color.r, color.g, color.b, color.a)
				end
			end
		end)
	end

	for i = 1, 10 do
		AB:PositionAndSizeBar('bar'..i)
	end
end

SLE:RegisterModule(A:GetName())
