local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local S = E.Skins
local _G = _G

local function LoadSkin()
	hooksecurefunc('PawnUI_InventoryPawnButton_Move', function()
		if _G.PawnUI_InventoryPawnButton then
			if PawnCommon.ButtonPosition == PawnButtonPositionRight then
				_G.PawnUI_InventoryPawnButton:ClearAllPoints()
				_G.PawnUI_InventoryPawnButton:SetPoint('BOTTOMRIGHT', _G.PaperDollFrame, 'BOTTOMRIGHT', 0, 0)
			elseif PawnCommon.ButtonPosition == PawnButtonPositionLeft then
				_G.PawnUI_InventoryPawnButton:ClearAllPoints()
				_G.PawnUI_InventoryPawnButton:SetPoint('BOTTOMLEFT', _G.PaperDollFrame, 'BOTTOMLEFT', 0, 0)
			end
		end
	end)
end

S:AddCallbackForAddon('Pawn', 'Pawn', LoadSkin)
