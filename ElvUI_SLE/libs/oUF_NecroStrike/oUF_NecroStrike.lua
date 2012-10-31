local _, ns = ...
local oUF = ElvUF or oUF
local E, L, V, P, G =  unpack(ElvUI);
if not oUF then return end
local NecroticStrikeTooltip

--Enabling only for DKs
if E.myclass ~= "DEATHKNIGHT" then return end

local function GetNecroticAbsorb(unit)
	local i = 1
	while true do
		local _, _, texture, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, "HARMFUL")
		--local _, _, texture, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, "HELPFUL") --Debug for testing with holy pally mastery
		if not texture then break end
		if spellId == 73975 then
		--if spellId == 86273 then --Debug for testing with holy pally mastery
			if not NecroticStrikeTooltip then
				NecroticStrikeTooltip = CreateFrame("GameTooltip", "NecroticStrikeTooltip", nil, "GameTooltipTemplate")
				NecroticStrikeTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
			end
			NecroticStrikeTooltip:ClearLines()
			NecroticStrikeTooltip:SetUnitDebuff(unit, i)
			--NecroticStrikeTooltip:SetUnitBuff(unit, i)  --Debug for testing with holy pally mastery
			if (GetLocale() == "ruRU") then
				return tonumber(string.match(_G[NecroticStrikeTooltip:GetName() .. "TextLeft2"]:GetText(), "(%d+%s?) .*"))
			else
				return tonumber(string.match(_G[NecroticStrikeTooltip:GetName() .. "TextLeft2"]:GetText(), ".* (%d+%s?) .*"))
			end
		end
		i = i + 1
	end
	return 0
end

local function UpdateOverlay(object)
	local healthFrame = object.Health
	local amount = 0
	if healthFrame.NecroAbsorb then
		amount = healthFrame.NecroAbsorb
	end
	if amount > 0 then
		local currHealth = UnitHealth(object.unit)
		local maxHealth = UnitHealthMax(object.unit)
		
		--Calculatore overlay posistion based on current health
		local lOfs = (healthFrame:GetWidth() * (currHealth / maxHealth)) - (healthFrame:GetWidth() * (amount / maxHealth))
		local rOfs = (healthFrame:GetWidth() * (currHealth / maxHealth)) - healthFrame:GetWidth()
		
		--Compensate for smooth health bars
		local rOfs2 = (healthFrame:GetWidth() * (healthFrame:GetValue() / maxHealth)) - healthFrame:GetWidth()
		if rOfs2 > rOfs then rOfs = rOfs2 end
		
		--Clamp to health bar
		if lOfs < 0 then lOfs = 0 end
		if rOfs > 0 then rOfs = 0 end
		
		--Redraw overlay
		healthFrame.NecroticOverlay:ClearAllPoints()
		healthFrame.NecroticOverlay:SetPoint("LEFT", lOfs, 0)
		healthFrame.NecroticOverlay:SetPoint("RIGHT", rOfs, 0)
		healthFrame.NecroticOverlay:SetPoint("TOP", 0, 0)
		healthFrame.NecroticOverlay:SetPoint("BOTTOM", 0, 0)
		
		--Select overlay color based on if class color is enabled
		if healthFrame.colorClass then
			healthFrame.NecroticOverlay:SetVertexColor(0, 0, 0, 0.4)
		else
			local r, g, b = healthFrame:GetStatusBarColor()
			healthFrame.NecroticOverlay:SetVertexColor(1-r, 1-g, 1-b, 0.4)
		end
		
		healthFrame.NecroticOverlay:Show()
	else
		healthFrame.NecroticOverlay:Hide()
	end
end

local function Update(object, event, unit)
	if object.unit ~= unit then return end
	object.Health.NecroAbsorb = GetNecroticAbsorb(unit)
	UpdateOverlay(object)
end
 
local function Enable(object)
	if not object.Health then return end
	
	--Create overlay for this object
	if not object.Health.NecroticOverlay then
		object.Health.NecroticOverlay = object.Health:CreateTexture(nil, "OVERLAY", object.Health)
		object.Health.NecroticOverlay:SetAllPoints(object.Health)
		object.Health.NecroticOverlay:SetTexture(1, 1, 1, 1)
		object.Health.NecroticOverlay:SetBlendMode("BLEND")
		object.Health.NecroticOverlay:SetVertexColor(0, 0, 0, 0.4)
		object.Health.NecroticOverlay:Hide()
	end

	object:RegisterEvent("UNIT_AURA", Update)
	object:RegisterEvent("UNIT_HEALTH_FREQUENT", Update)
	return true
end
 
local function Disable(object)
	if not object.Health then return end
	
	if object.Health.NecroticOverlay then
		object.Health.NecroticOverlay:Hide()
	end

	object:UnregisterEvent("UNIT_AURA", Update)
	object:UnregisterEvent("UNIT_HEALTH_FREQUENT", Update)
end
 
oUF:AddElement('NecroStrike', Update, Enable, Disable)
 
for i, frame in ipairs(oUF.objects) do Enable(frame) end