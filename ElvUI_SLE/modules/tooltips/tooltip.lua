local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local TT = E:GetModule('Tooltip');
local GameTooltip = GameTooltip
local GetCursorPosition = GetCursorPosition
local iconPath = [[Interface\AddOns\ElvUI_SLE\media\textures\]]
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local _G = _G

--GLOBALS: UIParent, hooksecurefunc

local function AnchorFrameToMouse()
	if not SLE.initialized then return end
	if not E.db.tooltip.cursorAnchor or (E.db.sle.tooltip.xOffset == 0 and E.db.sle.tooltip.yOffset == 0) then return end

	local frame = GameTooltip
	if frame:GetAnchorType() ~= "ANCHOR_CURSOR" then return end

	local x, y = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	local tipWidth = frame:GetWidth();

	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x/scale + (E.db.sle.tooltip.xOffset - tipWidth/2)), (y/scale + E.db.sle.tooltip.yOffset));
end

local function OnTooltipSetUnit(self, tt)
	if not SLE.initialized then return end
	if not E.db.sle.tooltip.showFaction then return end

	local unit = T.select(2, tt:GetUnit())
	if (T.UnitIsPlayer(unit)) then
		local text = _G["GameTooltipTextLeft1"]:GetText()
		local faction = T.UnitFactionGroup(unit)

		if not faction then faction = "Neutral" end

		_G["GameTooltipTextLeft1"]:SetText("|T"..iconPath..faction..".blp:15:15:0:0:64:64:2:56:2:56|t "..text)
	end
end

function SLE:SetCompareItems()
	if E.db.sle.tooltip.alwaysCompareItems then
		E:LockCVar("alwaysCompareItems", 1)
	else
		E:LockCVar("alwaysCompareItems", 0)
	end
end

local function Init()
	if not E.private.tooltip.enable then return end
	hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", OnTooltipSetUnit)

	hooksecurefunc(TT, "CheckBackdropColor", AnchorFrameToMouse)
end
hooksecurefunc(TT, "Initialize", Init)