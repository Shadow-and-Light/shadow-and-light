local E, L, V, P, G =  unpack(ElvUI); --Engine
local VG = E:NewModule('Vengeance', 'AceHook-3.0', 'AceEvent-3.0');
local UF = E:GetModule('UnitFrames');
print("Vengeance loaded")

local Vbar
local Vstam
local VaddHP
local Vmax
local V_ScanTip = CreateFrame("GameTooltip","VengeanceModuleScanTip",nil,"GameTooltipTemplate")
V_ScanTip:SetOwner(UIParent, "ANCHOR_NONE")

local function getTooltipText(...) --This stuff is for knowing how much bonus AP we actually have. It's called from aura event function
	local text = ""
	for i=1,select("#",...) do
		local rgn = select(i,...)
		if rgn and rgn:GetObjectType() == "FontString" then
			text = text .. (rgn:GetText() or "")
		end
	end
	return text == "" and "0" or text
end

function VG:CreateBar()
	Vbar =  ElvUF_Player.Vengeance --This is actually from the plugin. idk how to put other functionings from there to the code O_o
	Vbar = CreateFrame("StatusBar", nil, ElvUF_Player)
	Vbar:CreateBackdrop("Default")
	Vbar:Point("TOPLEFT", ElvUF_Player.Power, "BOTTOMLEFT", 0, -4) --2 lines for determining positioning and size
	Vbar:Point("BOTTOMRIGHT", ElvUF_Player.Power, "BOTTOMRIGHT", 0, -12) --The bar is docked under power bar for now
	Vbar:SetStatusBarTexture(E["media"].normTex)
	--Vbar:SetStatusBarColor(1,0,0) --No need atm
	
	Vbar.value = Vbar:CreateFontString(nil, 'OVERLAY')	
	Vbar.value:FontTemplate(nil, 10) --Font temeplate. will need to change that to use UF font and size
	Vbar.value:SetParent(Vbar)
	
	Vbar.value:Point("CENTER", Vbar, "CENTER", 0, 0) --May need to change that to be at the keft side instead of center
	
	--Setting text on initial load as i didn't add a function for player_entering_world event
	V_ScanTip:ClearLines()
	V_ScanTip:SetUnitBuff("player", GetSpellInfo(93098) or GetSpellInfo(76691))
	local tipText = getTooltipText(V_ScanTip:GetRegions())
	local vengval,percentmax,downtime
	vengval = tonumber(string.match(tipText,"%d+"))
	percentmax = (vengval/Vmax)*100
	Vbar:SetMinMaxValues(0,Vmax)
	Vbar:SetValue(vengval)
	Vbar.value:SetText(string.format("%s/%s (%.2f%%)",vengval,Vmax,percentmax))
end

function VG:setBaseHPadd() --For knowing base HP bonus to AP
	local baseHP
	local level = UnitLevel("player");
	
	local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 3);
	local baseStam = min(20, effectiveStat);
	local moreStam = effectiveStat - baseStam;
	local healthPerStam = UnitHPPerStamina("player")
	local hpFromStam = (baseStam + (moreStam*healthPerStam))*GetUnitMaxHealthModifier("player")
	baseHP = UnitHealthMax("player") - hpFromStam

	if baseHP then
		VaddHP = floor(baseHP/10)
	else
		DEFAULT_CHAT_FRAME:AddMessage("ERROR - Unable to calculate baseHP")
	end
end

function VG:SetMax() --For knowing our current maximum AP bonus
	Vstam = UnitStat("player", 3);
	print("Stamina: "..Vstam)
	Vmax = VaddHP + Vstam
	print("Maximun Vengeance: "..Vmax)
end

function VG:UNIT_AURA(...) --Updating on aura event. Setting the values and colors when we gain or loose vengeance bonuses.
	local event, unit = ...;
	if unit == "player" then
		local n,_,_,_,_,_,_,_,_,_,id = UnitAura("player", (GetSpellInfo(93098) or GetSpellInfo(76691)));
		if n then
			V_ScanTip:ClearLines()
			V_ScanTip:SetUnitBuff("player",n)
			local tipText = getTooltipText(V_ScanTip:GetRegions())
			local vengval,percentmax,downtime
			vengval = tonumber(string.match(tipText,"%d+"))
			percentmax = (vengval/Vmax)*100
			print("Percent of vengeance:"..percentmax)
			Vbar:SetMinMaxValues(0,Vmax)
			Vbar:SetValue(vengval)
			Vbar.value:SetText(string.format("%s/%s (%.2f%%)",vengval,Vmax,percentmax))
			if (percentmax <= 25) then
				Vbar:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
			elseif (percentmax > 25 and percentmax < 60) then
				Vbar:SetStatusBarColor(1, 180 / 255, 0, .8)
			else
				Vbar:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
			end
		else
			VG:SetMax()
			Vbar:SetMinMaxValues(0,Vmax)
			Vbar:SetValue(0)
			Vbar.value:SetText("0/"..Vmax.." (0.00%)")
		end
	end	
end

function VG:UNIT_STATS(...) --Updating when our stats are changed
	local event, unit = ...;
	if unit == "player" then
		VG:SetMax()
		Vbar:SetMinMaxValues(0,Vmax)
		local vengval = Vbar:GetValue()
		if vengval and (vengval > 0) then
			local percentmax = min(((vengval/Vmax)*100),100)
			Vbar.value:SetText(string.format("%s/%s (%.2f%%)",vengval,Vgmax,percentmax))
		else
			Vbar.value:SetText("0/"..Vmax.." (0.00%)")
		end
	end
end

function VG:Initialize()
	VG:setBaseHPadd()
	VG:SetMax()
	VG:CreateBar()
	
	--Commented lines are for more events that can influence the bonus
	--self:RegisterEvent("ADDON_LOADED")
	--self:RegisterEvent("PLAYER_LOGIN")
	--self:RegisterEvent("PLAYER_DEAD")
	--self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_STATS")
	--self:RegisterEvent("UNIT_LEVEL")
	--self:RegisterEvent("PLAYER_REGEN_ENABLED")
	--self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

E:RegisterModule(VG:GetName())