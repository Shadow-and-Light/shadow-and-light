local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:NewModule('CharacterFrameOptions', 'AceHook-3.0', 'AceEvent-3.0');

function CFO:ToggleCFO()
	self:UpdateItemDurability()
	self:UpdateItemLevel()
end

function CFO:Initialize()
	if not E.private.sle.characterframeoptions.enable then return; end
	self:LoadDurability()
	self:LoadItemLevel()
end

E:RegisterModule(CFO:GetName())