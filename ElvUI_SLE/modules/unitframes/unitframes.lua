local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local SUF = SLE:NewModule("UnitFrames", "AceEvent-3.0")
local RC = LibStub("LibRangeCheck-2.0")
--GLOBALS: hooksecurefunc, CreateFrame
local _G = _G
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitHonorLevel = UnitHonorLevel
local UnitIsPVP = UnitIsPVP

function SUF:NewTags()
	_G["ElvUF"].Tags.Events['health:current:sl-rehok'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
	_G["ElvUF"].Tags.Methods['health:current:sl-rehok'] = function(unit)
		local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

		if (status) then
			return status
		else
			local curHealth = UnitHealth(unit)
			local perHealth = (UnitHealth(unit)/UnitHealthMax(unit))*100

			if curHealth >= 1e9 then
				return format("%.2fB", curHealth / 1e9) .. " | " .. format("%.0f", perHealth)
			elseif curHealth >= 1e6 then
				return format("%.2fM", curHealth / 1e6) .. " | " .. format("%.0f", perHealth)
			elseif curHealth >= 1e3 then
				return format("%.0fk", curHealth / 1e3) .. " | " .. format("%.0f", perHealth)
			else
				return format("%d", curHealth) .. " | " .. format("%.1f", perHealth)
			end
		end
	end

	_G["ElvUF"].Tags.Methods["range:sl"] = function(unit)
		local name, server = T.UnitName(unit)
		local rangeText = ''
		local min, max = RC:GetRange(unit)
		local curMin = min
		local curMax = max

		if(server and server ~= "") then
			name = T.format("%s-%s", name, server)
		end

		if min and max and (name ~= T.UnitName('player')) then
			rangeText = curMin.."-"..curMax
		end
		return rangeText
	end

	_G["ElvUF"].Tags.Events['absorbs:sl-short'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
	_G["ElvUF"].Tags.Methods['absorbs:sl-short'] = function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb == 0 then
			return 0
		else
			return E:ShortValue(absorb)
		end
	end

	_G["ElvUF"].Tags.Events['absorbs:sl-full'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
	_G["ElvUF"].Tags.Methods['absorbs:sl-full'] = function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb == 0 then
			return 0
		else
			return absorb
		end
	end

	ElvUF.Tags.OnUpdateThrottle["sl:pvptimer"] = 1
	_G["ElvUF"].Tags.Methods["sl:pvptimer"] = function(unit)
		if (UnitIsPVPFreeForAll(unit) or UnitIsPVP(unit)) then
			local timer = GetPVPTimer()

			if timer ~= 301000 and timer ~= -1 then
				local mins = floor((timer / 1000) / 60)
				local secs = floor((timer / 1000) - (mins * 60))
				return ("%01.f:%02.f"):format(mins, secs)
			else
				return "PvP"
			end
		else
			return nil
		end
	end

	_G["ElvUF"].Tags.Events['sl:pvplevel'] = "HONOR_LEVEL_UPDATE UNIT_FACTION"
	_G["ElvUF"].Tags.Methods['sl:pvplevel'] = function(unit)
		-- if unit ~= "target" and unit ~= "player" then return "" end
		return (UnitIsPVP(unit) and UnitHonorLevel(unit) > 0) and UnitHonorLevel(unit) or ""
	end
	
	-- Ad the tags to the ElvUI Options
	E:AddTagInfo("sl:pvptimer", "Shadow&Light", L["SLE_Tag_sl-pvptimer"])
	E:AddTagInfo("sl:pvplevel", "Shadow&Light", L["SLE_Tag_sl-pvplevel"])
	E:AddTagInfo("absorbs:sl-short", "Shadow&Light", L["SLE_Tag_absorb-sl-short"])
	E:AddTagInfo("absorbs:sl-full", "Shadow&Light", L["SLE_Tag_absorb-sl-full"])
	-- E:AddTagInfo("health:current:sl-rehok", "Shadow&Light", L["SLE_Tag_health-current-rehok"])
	E:AddTagInfo("range:sl", "Shadow&Light", L["SLE_Tag_range-sl"])
end



local function UpdateAuraTimer(self, elapsed)
	local timervalue, formatid
	local unitID = self:GetParent():GetParent().unitframeType
	local auraType = self:GetParent().type
	if unitID and E.db.sle.unitframes.unit[unitID] and E.db.sle.unitframes.unit[unitID].auras then
		timervalue, formatid, self.nextupdate = E:GetTimeInfo(self.expirationSaved, E.db.sle.unitframes.unit[unitID].auras[auraType].threshold)
	else
		timervalue, formatid, self.nextupdate = E:GetTimeInfo(self.expirationSaved, 4)
	end
	local timeColors, timeThreshold = E.TimeColors, E.db.cooldown.threshold
	if E.db.unitframe.cooldown.override and E.TimeColors['unitframe'] then
		timeColors, timeThreshold = E.TimeColors['unitframe'], E.db.unitframe.cooldown.threshold
	end
	if not timeThreshold then
		timeThreshold = E.TimeThreshold
	end
	if self.text:GetFont() then
		self.text:SetFormattedText(("%s%s|r"):format(timeColors[formatid], E.TimeFormats[formatid][2]), timervalue)
	elseif self:GetParent():GetParent().db then
		self.text:FontTemplate(E.LSM:Fetch("font", E.db['unitframe'].font), self:GetParent():GetParent().db[auraType].fontSize, E.db['unitframe'].fontOutline)
		self.text:SetFormattedText(("%s%s|r"):format(timeColors[formatid], E.TimeFormats[formatid][2]), timervalue)
	end
end

function SUF:Initialize()
	if not SLE.initialized or not E.private.unitframe.enable then return end
	--DB convert
	if E.private.sle.unitframe.resizeHealthPrediction then E.private.sle.unitframe.resizeHealthPrediction = nil end

	SUF:NewTags()
	-- SUF:InitPlayer()

	--Raid stuff
	SUF.specNameToRole = {}
	for i = 1, T.GetNumClasses() do
		local _, class, classID = T.GetClassInfo(i)
		SUF.specNameToRole[class] = {}
		for j = 1, T.GetNumSpecializationsForClassID(classID) do
			local _, spec, _, _, role = T.GetSpecializationInfoForClassID(classID, j)
			SUF.specNameToRole[class][spec] = role
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		SUF:SetRoleIcons()
		if E.private.sle.unitframe.statusbarTextures.cast then SUF:CastBarHook() end
	end)

	--Hooking to group frames
	hooksecurefunc(UF, "Update_PartyFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_RaidFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_Raid40Frames", SUF.Update_GroupFrames)

	--Hook pvp icons
	SUF:UpgradePvPIcon()

	SUF:InitStatus()

	hooksecurefunc(UF, "UpdateAuraTimer", UpdateAuraTimer)

	function SUF:ForUpdateAll()
		SUF:SetRoleIcons()
		if E.private.sle.unitframe.statusbarTextures.power then SUF:BuildStatusTable() end
	end
end

SLE:RegisterModule(SUF:GetName())
