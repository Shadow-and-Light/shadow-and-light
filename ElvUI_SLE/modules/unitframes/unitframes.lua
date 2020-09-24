local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local SUF = SLE:NewModule('UnitFrames', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
SUF.CreatedShadows = {}
--GLOBALS: hooksecurefunc, CreateFrame

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

function SUF:UpdateUnitFrames()
	--* Groups Folder
	SUF:InitArena()
	SUF:InitBoss()
	SUF:InitParty()
	SUF:InitRaid()
	SUF:InitRaid40()

	--* Units Folder
	SUF:InitFocus()
	SUF:InitFocusTarget()
	SUF:InitPet()
	SUF:InitPetTarget()
	SUF:InitPlayer()
	SUF:InitTarget()
	SUF:InitTargetTarget()
	SUF:InitTargetTargetTarget()
end

function SUF:UpdateShadows()
	if UnitAffectingCombat('player') then SUF:RegisterEvent('PLAYER_REGEN_ENABLED', SUF.UpdateShadows) return end
	SUF:UnregisterEvent('PLAYER_ENTERING_WORLD')

	for frame, _ in pairs(SUF.CreatedShadows) do
		SUF:UpdateShadowColor(frame)
	end
end

function SUF:UpdateShadowColor(shadow)
	local db = E.db.sle.shadows
	local r, g, b = db.shadowcolor.r, db.shadowcolor.g, db.shadowcolor.b
	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.9)
end

function SUF:Initialize()
	if not SLE.initialized or not E.private.unitframe.enable then return end
	--DB convert
	if E.private.sle.unitframe.resizeHealthPrediction then E.private.sle.unitframe.resizeHealthPrediction = nil end

	-- Init and Update Unitframe Stuff which is shadows atm
	SUF:UpdateUnitFrames()

	--Raid stuff
	SUF.specNameToRole = {}
	for i = 1, GetNumClasses() do
		local _, class, classID = GetClassInfo(i)
		SUF.specNameToRole[class] = {}
		for j = 1, GetNumSpecializationsForClassID(classID) do
			local _, spec, _, _, role = GetSpecializationInfoForClassID(classID, j)
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
		if E.private.sle.module.shadows.enable then SUF:UpdateUnitFrames() end
	end
end

SLE:RegisterModule(SUF:GetName())
