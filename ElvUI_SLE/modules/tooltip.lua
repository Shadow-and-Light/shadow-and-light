local E, L, V, P, G, _ = unpack(ElvUI);
local TT = E:GetModule('Tooltip');

--Defaults (Need to be moved.)
P['tooltip']['mouseOffsetX'] = 0
P['tooltip']['mouseOffsetY'] = 0
P['tooltip']['overrideCombat'] = false

local iconPath = [[Interface\AddOns\ElvUI_SLE\media\textures\]]

TT.GameTooltip_SetDefaultAnchorSLE = TT.GameTooltip_SetDefaultAnchor
function TT:GameTooltip_SetDefaultAnchor(tt, parent)
	TT:GameTooltip_SetDefaultAnchorSLE(tt, parent)
	if E.private["tooltip"].enable ~= true then return end
	if(tt:GetAnchorType() ~= "ANCHOR_CURSOR") then return end
	if InCombatLockdown() and self.db.visibility.combat then
		tt:Hide()
		return
	end
	if(parent) then
		if(self.db.cursorAnchor) then
			TT:AnchorFrameToMouse(tt);
			return  
		end
	end
end

function TT:AnchorFrameToMouse(frame)
	if frame:GetAnchorType() ~= "ANCHOR_CURSOR" then return end
	local x, y = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	local tipWidth = frame:GetWidth();
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x/scale + (E.db.tooltip.mouseOffsetX - tipWidth/2)), (y/scale + E.db.tooltip.mouseOffsetY));
end



TT.GameTooltip_OnTooltipSetUnitSLE = TT.GameTooltip_OnTooltipSetUnit
function TT:GameTooltip_OnTooltipSetUnit(tt)
	TT:GameTooltip_OnTooltipSetUnitSLE(tt)
	if not E.db.sle.tooltipicon then return end
	local unit = select(2, tt:GetUnit())
	if(UnitIsPlayer(unit)) then
		local text = GameTooltipTextLeft1:GetText()
		local faction = UnitFactionGroup(unit)
		if not faction then faction = "Neutral" end
		GameTooltipTextLeft1:SetText("|T"..iconPath..faction..".blp:15:15:0:0:64:64:2:56:2:56|t "..text)
	end
end

function TT:AddonName_OnUpdate(self, elapsed)
  TT:AnchorFrameToMouse(self);
end

TT.InitializeSLE = TT.Initialize
function TT:Initialize()
	TT:InitializeSLE()
	self:HookScript(GameTooltip, "OnUpdate", "AddonName_OnUpdate");
end