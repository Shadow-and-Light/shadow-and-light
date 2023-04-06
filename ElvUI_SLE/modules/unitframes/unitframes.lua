local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local UF = E.UnitFrames
local SUF = SLE.UnitFrames

--GLOBALS: hooksecurefunc

local auraType, unitframeType
SUF.CreatedShadows = {}
SUF.powerbars = {}

local function Cooldown_Options(_, timer, _, cooldown)
	if not SLE.initialized or not E.private.unitframe.enable then return end
	if not timer or not cooldown then return end

	local parent = cooldown:GetParent()
	if not parent or not parent:GetParent() then return end
	local owner = parent:GetParent().__owner
	if not owner then return end

	local db = E.db.sle.unitframe.units
	auraType = parent.filter == 'HELPFUL' and 'buffs' or 'debuffs'
	unitframeType = owner.unitframeType
	if not auraType or not unitframeType then return end
	if not db[unitframeType] or not db[unitframeType][auraType] or not db[unitframeType][auraType].enable then return end

	timer.threshold = db[unitframeType][auraType].threshold
end
hooksecurefunc(E, 'Cooldown_Options', Cooldown_Options)

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

function SUF:Construct_UF(frame, unit)
	if not UF.groupunits[unit] then
		--* player, target, targettarget, targettargettarget, focus, focustarget, pet, pettarget
		SUF['Construct_'..gsub(E:StringTitle(unit), 't(arget)', 'T%1')..'Frame'](SUF, frame, unit)

		if unit and _G['ElvUF_'..gsub(E:StringTitle(unit), 't(arget)', 'T%1')].Power then
			SUF.powerbars[_G['ElvUF_'..gsub(E:StringTitle(unit), 't(arget)', 'T%1')].Power] = true
		end
	else
		--* arena1, arena2, arena3, arena4, arena5, boss1, boss2, boss3, boss4, boss5
		SUF['Construct_'..E:StringTitle(UF.groupunits[unit])..'Frames'](SUF, frame, unit)
	end
end

local function HookConstructUnitFrames()
	hooksecurefunc(UF, 'Construct_UF', SUF.Construct_UF)
	hooksecurefunc(UF, 'Construct_PartyFrames', SUF.Construct_PartyFrames)
	hooksecurefunc(UF, 'Construct_RaidFrames', SUF.Construct_RaidFrames)
	hooksecurefunc(UF, 'Construct_TankFrames', SUF.Construct_TankFrames)
	hooksecurefunc(UF, 'Construct_AssistFrames', SUF.Construct_AssistFrames)
end

local function HookUpdateUnitFrames()
	--* Individual Units
	hooksecurefunc(UF, 'Update_PlayerFrame', SUF.Update_PlayerFrame)
	hooksecurefunc(UF, 'Update_TargetFrame', SUF.Update_TargetFrame)
	hooksecurefunc(UF, 'Update_TargetTargetFrame', SUF.Update_TargetTargetFrame)
	hooksecurefunc(UF, 'Update_TargetTargetTargetFrame', SUF.Update_TargetTargetTargetFrame)
	hooksecurefunc(UF, 'Update_FocusFrame', SUF.Update_FocusFrame)
	hooksecurefunc(UF, 'Update_FocusTargetFrame', SUF.Update_FocusTargetFrame)
	hooksecurefunc(UF, 'Update_PetFrame', SUF.Update_PetFrame)
	hooksecurefunc(UF, 'Update_PetTargetFrame', SUF.Update_PetTargetFrame)

	--* Group Units
	hooksecurefunc(UF, "Update_PartyFrames", SUF.Update_PartyFrames)
	hooksecurefunc(UF, "Update_RaidFrames", SUF.Update_RaidFrames)
	hooksecurefunc(UF, "Update_TankFrames", SUF.Update_TankFrames)
	hooksecurefunc(UF, "Update_AssistFrames", SUF.Update_AssistFrames)
	hooksecurefunc(UF, "Update_ArenaFrames", SUF.Update_ArenaFrames)
	hooksecurefunc(UF, 'Update_BossFrames', SUF.Update_BossFrames)
end

function SUF:Initialize()
	if not SLE.initialized or not E.private.unitframe.enable then return end

	hooksecurefunc(UF, 'Configure_ClassBar', SUF.Configure_ClassBar)
	--* Construct Elements/Etc
	HookConstructUnitFrames()

	--* Configure/Update Elements
	HookUpdateUnitFrames()
	hooksecurefunc(UF, 'Update_StatusBars', SUF.Update_StatusBars)
	hooksecurefunc(UF, 'Update_StatusBar', SUF.Update_StatusBar)
	hooksecurefunc(UF, 'ToggleTransparentStatusBar', SUF.ToggleTransparentStatusBar)

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

	function SUF:ForUpdateAll()

	end
end

SLE:RegisterModule(SUF:GetName())
