local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local TT = E.Tooltip

local _G = _G
local TooltipDataType = Enum.TooltipDataType
local iconPath = [[Interface\AddOns\ElvUI_SLE\media\textures\afk\factionlogo\blizzard\]]

local function OnTooltipSetUnit(tt)
	if not SLE.initialized then return end
	if not E.db.sle.tooltip.showFaction then return end

	local unit = select(2, tt:GetUnit())
	if UnitIsPlayer(unit) then
		local text = _G.GameTooltipTextLeft1:GetText()
		local faction = UnitFactionGroup(unit) or 'Neutral'

		if text and faction then
			-- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
			-- _G["GameTooltipTextLeft1"]:SetText("|T"..iconPath..faction..".tga:15:15:0:0:64:64:2:56:2:56|t "..text)
			_G.GameTooltipTextLeft1:SetText('|T'..iconPath..faction..'.tga:0:0:0:0:128:128:28:100:28:100|t '..text)
		end
	end
end

function SLE:SetCompareItems()
	if E.db.sle.tooltip.alwaysCompareItems then
		SetCVar('alwaysCompareItems', 1)
	else
		SetCVar('alwaysCompareItems', 0)
	end
end

local function Init()
	if not E.private.tooltip.enable then return end
	TooltipDataProcessor.AddTooltipPostCall(TooltipDataType.Unit, OnTooltipSetUnit)

	SLE:SetCompareItems()
end
hooksecurefunc(TT, 'Initialize', Init)
