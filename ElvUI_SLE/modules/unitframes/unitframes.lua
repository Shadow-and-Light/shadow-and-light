local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local UF = E.UnitFrames
local SUF = SLE.UnitFrames
SUF.CreatedShadows = {}
--GLOBALS: hooksecurefunc, CreateFrame

local function Cooldown_Options(_, timer, _, button)
	if not SLE.initialized or not E.private.unitframe.enable then return end
	if not button then return end

	local buttonParent = button:GetParent()
	if not buttonParent then return end

	local parent = buttonParent:GetParent()
	if not parent or not parent.__owner or not parent.type then return end

	local unitID, auraType = parent.__owner.unitframeType, parent.type
	local sldb = E.db.sle.unitframes.unit
	if not unitID or not sldb[unitID] then return end

	if unitID and sldb[unitID].auras and sldb[unitID].auras[auraType] then
		timer.threshold = sldb[unitID].auras[auraType].threshold
	end
end
hooksecurefunc(E, 'Cooldown_Options', Cooldown_Options)

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
		if E.private.sle.unitframe.statusbarTextures.cast then SUF:CastBarHook() end
	end)

	--Hooking to group frames
	hooksecurefunc(UF, "Update_PartyFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_RaidFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_Raid40Frames", SUF.Update_GroupFrames)

	--Hook pvp icons
	SUF:UpgradePvPIcon()

	SUF:InitStatus()

	function SUF:ForUpdateAll()
		if E.private.sle.unitframe.statusbarTextures.power then SUF:BuildStatusTable() end
		if E.private.sle.module.shadows.enable then SUF:UpdateUnitFrames() end
	end
end

SLE:RegisterModule(SUF:GetName())
