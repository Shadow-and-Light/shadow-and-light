local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local TT = E:GetModule('Tooltip');

--GLOBALS: unpack, select, hooksecurefunc
local _G = _G
local iconPath = [[Interface\AddOns\ElvUI_SLE\media\textures\]]

local function OnTooltipSetUnit(self, tt)
	if not SLE.initialized then return end
	if not E.db.sle.tooltip.showFaction then return end

	local unit = select(2, tt:GetUnit())
	if (UnitIsPlayer(unit)) then
		local text = _G["GameTooltipTextLeft1"]:GetText()
		local faction = UnitFactionGroup(unit)

		if not faction then faction = "Neutral" end

		_G["GameTooltipTextLeft1"]:SetText("|T"..iconPath..faction..".tga:15:15:0:0:64:64:2:56:2:56|t "..text)
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

	SLE:SetCompareItems() --Blizz cvar for item compare
end
hooksecurefunc(TT, "Initialize", Init)