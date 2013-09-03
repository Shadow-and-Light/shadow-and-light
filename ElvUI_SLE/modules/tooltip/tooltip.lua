local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT = E:GetModule('Tooltip');

--Defaults (Need to be moved.)
P['tooltip']['mouseOffsetX'] = 0
P['tooltip']['mouseOffsetY'] = 0
P['tooltip']['overrideCombat'] = false

TT.GameTooltip_SetDefaultAnchorSLE = TT.GameTooltip_SetDefaultAnchor
function TT:GameTooltip_SetDefaultAnchor(tt, parent)
	TT:GameTooltip_SetDefaultAnchorSLE(tt, parent)
	if E.private["tooltip"].enable ~= true then return end
	if(tt:GetAnchorType() ~= "ANCHOR_NONE") then return end
	if InCombatLockdown() and self.db.visibility.combat then
		tt:Hide()
		return
	end

	if(parent) then
		if(self.db.cursorAnchor) then
			TTOS:AnchorFrameToMouse(tt);
			return		
		end
	end
end

function TT:AnchorFrameToMouse(frame)
	if frame:GetAnchorType() ~= "ANCHOR_CURSOR" then return end
	--if (E.db.tooltip.onlyMod and not (IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown())) then return end
	local x, y = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x/scale + E.db.tooltip.mouseOffsetX), (y/scale + E.db.tooltip.mouseOffsetY));
end

function TT:AddonName_OnUpdate(self, elapsed)
  TT:AnchorFrameToMouse(self);
end

--function TT:MODIFIER_STATE_CHANGED(event, key)
	--if InCombatLockdown() and E.db.tooltip.combathide and not (E.db.tooltip.overrideCombat and IsShiftKeyDown()) then
	--		GameTooltip:Hide()
	--end
--end

TT.InitializeSLE = TT.Initialize
function TT:Initialize()
	TT:InitializeSLE()
	self:HookScript(GameTooltip, "OnUpdate", "AddonName_OnUpdate");
end