local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local P = E:NewModule('PvPMover', 'AceHook-3.0', 'AceEvent-3.0');

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
	self:RegisterEvent("UPDATE_WORLD_STATES", update)
	E:CreateMover(WorldStateAlwaysUpFrame, "PvPMover", "PvP", nil, nil, nil, "ALL,S&L")
end

E:RegisterModule(P:GetName())