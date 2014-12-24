local E, L, V, P, G = unpack(ElvUI);
local TT = E:GetModule('Tooltip');

--Defaults (Need to be moved.)
P['tooltip']['overrideCombat'] = false

local iconPath = [[Interface\AddOns\ElvUI_SLE\media\textures\]]

local function AnchorFrameToMouse()
	if not E.db.tooltip.cursorAnchor or (E.db.sle.tooltip.xOffset == 0 and E.db.sle.tooltip.yOffset == 0) then return end

	local frame = GameTooltip
	if frame:GetAnchorType() ~= "ANCHOR_CURSOR" then return end

	local x, y = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	local tipWidth = frame:GetWidth();

	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x/scale + (E.db.sle.tooltip.xOffset - tipWidth/2)), (y/scale + E.db.sle.tooltip.yOffset));
end

local function SetDefaultAnchor(self, tt, parent)
	if (tt:GetAnchorType() ~= "ANCHOR_CURSOR") then
		return
	end
	if InCombatLockdown() and self.db.visibility.combat then
		tt:Hide()
		return
	end
	if (parent) then
		if(self.db.cursorAnchor) then
			AnchorFrameToMouse(tt);
			return  
		end
	end
end

local function OnTooltipSetUnit(self, tt)
	if not E.db.sle.tooltip.showFaction then return end

	local unit = select(2, tt:GetUnit())
	if (UnitIsPlayer(unit)) then
		local text = GameTooltipTextLeft1:GetText()
		local faction = UnitFactionGroup(unit)

		if not faction then faction = "Neutral" end

		GameTooltipTextLeft1:SetText("|T"..iconPath..faction..".blp:15:15:0:0:64:64:2:56:2:56|t "..text)
	end
end

local function Init()
	if not E.private.tooltip.enable then return end
	hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", OnTooltipSetUnit)

	--if not E.db.tooltip.cursorAnchor then return end
	hooksecurefunc(TT, "CheckBackdropColor", AnchorFrameToMouse)
	--hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", SetDefaultAnchor)
end
hooksecurefunc(TT, "Initialize", Init)