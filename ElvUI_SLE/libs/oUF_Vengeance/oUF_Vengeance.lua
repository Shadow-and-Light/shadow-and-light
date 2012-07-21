--[[
	Project.: oUF_Vengeance
	File....: oUF_Vengeance.lua
	Version.: 40200.5
	Rev Date: 06/28/2011
	Authors.: Shandrela [EU-Baelgun] <Bloodmoon>
]]

--[[
	Elements handled:
	 .Vengeance [frame]
	 .Vengeance.Text [fontstring]
		
	Code Example:
	 .Vengeance = CreateFrame("StatusBar", nil, self)
	 .Vengeance:SetWidth(400)
	 .Vengeance:SetHeight(20)
	 .Vengeance:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 100)
	 .Vengeance:SetStatusBarTexture(normTex)
	 .Vengeance:SetStatusBarColor(1,0,0)
	 
	Functions that can be overridden from within a layout:
	 - :OverrideText(value)
	 
	Possible OverrideText function:
	
	local VengOverrideText(bar, value)
		local text = bar.Text
		
		text:SetText(value)
	end
	...
	ElvUF_Player.Vengeance.OverrideText = VengOverrideText
	
	others:
	ElvUF_Player.Vengeance.showInfight [boolean]
	if true, the Vengeance bar will be shown infight, even if you haven't got stacks of Vengeance
--]]
local E, L, V, P, G =  unpack(ElvUI); --Engine
local VG = E:NewModule('Vengeance', 'AceHook-3.0', 'AceEvent-3.0');
local _, ns = ...
local oUF = ElvUF or oUF

local _, class = UnitClass("player")
local vengeance = GetSpellInfo(93098) or GetSpellInfo(76691)

local UnitAura = UnitAura
local InCombatLockdown = InCombatLockdown

local tooltip = CreateFrame("GameTooltip", "VengeanceTooltip", UIParent, "GameTooltipTemplate")
local tooltiptext = _G[tooltip:GetName().."TextLeft2"]

tooltip:SetOwner(UIParent, "ANCHOR_NONE")
tooltiptext:SetText("")

function VG:CreateBar()
ElvUF_Player.Vengeance = CreateFrame("StatusBar", nil, RightChatTab)
local Vbar = ElvUF_Player.Vengeance
Vbar:CreateBackdrop("Default")
Vbar:SetFrameLevel(5)
Vbar:Point("TOPLEFT", RightChatTab, "TOPLEFT", 0, 0) --2 lines for determining positioning and size
Vbar:Point("BOTTOMRIGHT", RightChatTab, "BOTTOMRIGHT", 0, 0)
Vbar:SetStatusBarTexture(E["media"].normTex)

Vbar.Text = Vbar:CreateFontString(nil, 'OVERLAY')	
Vbar.Text:FontTemplate(nil, 10) --Font temeplate. will need to change that maybe
Vbar.Text:SetParent(Vbar)

Vbar.Text:Point("CENTER", Vbar, "CENTER", 0, 0) --May need to change that to be at the left side instead of center
end
	
local function valueChanged(self, event, unit)
	if unit ~= "player" then return end
	local bar = ElvUF_Player.Vengeance
	
	if not bar.isTank then
		bar:Hide()
		return
	end
	
	local name = UnitAura("player", vengeance, nil, "PLAYER|HELPFUL")
	
	if name then
		tooltip:ClearLines()
		tooltip:SetUnitBuff("player", name)
		local value = (tooltiptext:GetText() and tonumber(string.match(tostring(tooltiptext:GetText()), "%d+"))) or -1
				
		if value > 0 then
			if value > bar.max then value = bar.max end
			if value == bar.value then return end
			
			bar:SetMinMaxValues(0, bar.max)
			bar:SetValue(value)
			bar.value = value
			bar:Show()
			local percent = (value/bar.max)*100
			
			if bar.Text then
				if bar.OverrideText then
					bar:OverrideText(self, value)
				else
					bar.Text:SetText(string.format(vengeance..": %s/%s (%.2f%%)",value,bar.max,percent))
				end
			end
			if (percent <= 25) then
				bar:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
			elseif (percent > 25 and percent < 60) then
				bar:SetStatusBarColor(1, 180 / 255, 0, .8)
			else
				bar:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
			end
		end
	elseif bar.showInfight and InCombatLockdown() then
		bar:Show()
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(0)
		bar.value = 0
	else
		bar:Hide()
		bar.value = 0
	end
end

local function maxChanged(self, event, unit)
	if unit ~= "player" then return end
	local bar = ElvUF_Player.Vengeance
	
	if not bar.isTank then
		bar:Hide()
		return
	end
	
	local health = UnitHealthMax("player")
	local _, stamina = UnitStat("player", 3)
	local baseStam = min(20, stamina)
	local moreStam = stamina - baseStam
	local hpFromStam = (baseStam + (moreStam*UnitHPPerStamina("player")))*GetUnitMaxHealthModifier("player")
	local baseHP = health - hpFromStam
	
	if not health or not stamina then return end
	
	bar.max = stamina + floor(baseHP/10)
	bar:SetMinMaxValues(0, bar.max)
	
	valueChanged(self, event, unit)
end

local function isTank(self, event)
	local masteryIndex = GetPrimaryTalentTree()
	local bar = ElvUF_Player.Vengeance
	
	if masteryIndex then
		if class == "DRUID" and masteryIndex == 2 then
			bar.isTank = true
		elseif (class == "DEATH KNIGHT" or class == "DEATHKNIGHT") and masteryIndex == 1 then
			bar.isTank = true
		elseif class == "PALADIN" and masteryIndex == 2 then
			bar.isTank = true
		elseif class == "WARRIOR" and masteryIndex == 3 then
			bar.isTank = true
		else
			bar.isTank = false
			bar:Hide()
		end
	else
		bar.isTank = false
		bar:Hide()
	end
	
	maxChanged(self, event, "player")
end

local function Enable(self, unit)
	local bar = ElvUF_Player.Vengeance
	
	if bar and unit == "player" then
		bar.max = 0
		bar.value = 0
		self:RegisterEvent("UNIT_AURA", maxChanged)
		
		self:RegisterEvent("UNIT_MAXHEALTH", maxChanged)
		self:RegisterEvent("UNIT_LEVEL", maxChanged)
		
		self:RegisterEvent("PLAYER_REGEN_DISABLED", isTank)
		bar:Hide()
		
		return true
	end
end

local function Disable(self)
	local bar = ElvUF_Player.Vengeance
	
	if bar then
		self:UnregisterEvent("UNIT_AURA", valueChanged)
		
		self:UnregisterEvent("UNIT_MAXHEALTH", maxChanged)
		self:UnregisterEvent("UNIT_LEVEL", maxChanged)
		
		self:UnregisterEvent("PLAYER_REGEN_DISABLED", isTank)
	end
end

Enable(ElvUF_Player, "player")

oUF:AddElement("Vengeance", nil, Enable, Disable)

function VG:Initialize()
	VG:CreateBar()
	Enable(ElvUF_Player, "player")
end

E:RegisterModule(VG:GetName())