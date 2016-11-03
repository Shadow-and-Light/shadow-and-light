local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins');
local Sk = SLE:GetModule("Skins")
local _G = _G

local function LoadSkin()
	hooksecurefunc('PawnUI_InventoryPawnButton_Move', function()
		if _G["PawnUI_InventoryPawnButton"] then
			if PawnCommon.ButtonPosition == PawnButtonPositionRight then
				--print("1")
				_G["PawnUI_InventoryPawnButton"]:ClearAllPoints()
				_G["PawnUI_InventoryPawnButton"]:SetPoint('BOTTOMRIGHT', _G["PaperDollFrame"], 'BOTTOMRIGHT', 0, 0)
			elseif PawnCommon.ButtonPosition == PawnButtonPositionLeft then
				--print("2")
				_G["PawnUI_InventoryPawnButton"]:ClearAllPoints()
				_G["PawnUI_InventoryPawnButton"]:SetPoint('BOTTOMLEFT', _G["PaperDollFrame"], 'BOTTOMLEFT', 0, 0)
			end
		end
	end)
end

S:RegisterSkin('Pawn', LoadSkin)