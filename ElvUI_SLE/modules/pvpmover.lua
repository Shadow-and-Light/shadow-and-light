local E, L, V, P, G = unpack(ElvUI); 
local P = E:GetModule('SLE_PvPMover');
local holder = CreateFrame("Frame", "SLE_PvP", E.UIParent)


local function update()
	if WorldStateCaptureBar1 then
		local bar = WorldStateCaptureBar1
		bar:HookScript("OnShow", function(self) self:SetPoint("TOP", WorldStateAlwaysUpFrame, "BOTTOM", 0, -10) end)
		bar:Hide()
		bar:Show()
		P:UnregisterEvent("UPDATE_WORLD_STATES")
	end
end

function P:Initialize()
	holder:SetSize(10, 58)
	holder:SetPoint("TOP", E.UIParent, "TOP", -5, -15)
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:SetPoint("CENTER", holder)
	self:RegisterEvent("UPDATE_WORLD_STATES", update)
	E:CreateMover(holder, "PvPMover", "PvP", nil, nil, nil, "ALL,S&L,S&L MISC")
end