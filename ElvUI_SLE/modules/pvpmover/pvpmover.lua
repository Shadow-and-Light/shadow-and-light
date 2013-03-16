local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local P = E:NewModule('PvPMover', 'AceHook-3.0', 'AceEvent-3.0');
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

E:RegisterModule(P:GetName())