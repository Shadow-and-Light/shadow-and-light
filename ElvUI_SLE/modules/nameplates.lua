local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")
local N = SLE:NewModule("Nameplates", 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local rosterTimer
N.targetCount = 0

local function Hex(r, g, b)
	return T.format('|cFF%02x%02x%02x', r * 255, g * 255, b * 255)
end

N.GroupMembers = {}

hooksecurefunc(NP, 'NAME_PLATE_CREATED', function(self, event, frame)
	local myPlate = frame.UnitFrame
	if not myPlate then return end

	if not myPlate.threatInfo then
		myPlate.threatInfo = myPlate.HealthBar:CreateFontString(nil, "OVERLAY")
		myPlate.threatInfo:SetPoint("BOTTOMLEFT", myPlate.HealthBar, "BOTTOMLEFT", 1, 2)
		myPlate.threatInfo:SetJustifyH("LEFT")
	end
	if not frame.targetcount then
		myPlate.targetcount = myPlate.HealthBar:CreateFontString(nil, "OVERLAY")
		myPlate.targetcount:SetPoint('BOTTOMRIGHT', myPlate.HealthBar, 'BOTTOMRIGHT', 1, 2)
		myPlate.targetcount:SetJustifyH("RIGHT")
		myPlate.targetCount = 0
	end
	myPlate.threatInfo:FontTemplate(LSM:Fetch("font", NP.db.font), NP.db.fontSize, NP.db.fontOutline)
	myPlate.targetcount:FontTemplate(LSM:Fetch("font", NP.db.font), NP.db.fontSize, NP.db.fontOutline)
	myPlate.targetcount:SetText()
end)

hooksecurefunc(NP, 'Update_ThreatList', function(self, myPlate)
	if not myPlate then return end

	if myPlate.threatInfo then
		myPlate.threatInfo:SetText()

		if N.db.showthreat and frame.UnitType == "ENEMY_NPC" then
			local unit = myPlate.unit
			if not unit then
				for i=1, 4 do
					if myPlate.guid == T.UnitGUID(T.format('boss%d', i)) then
						unit = T.format('boss%d', i)
						break
					end
				end
			end
			if unit and not T.UnitIsPlayer(unit) and T.UnitCanAttack('player', unit) then
				local status, percent = T.select(2, T.UnitDetailedThreatSituation('player', unit))
				if (status) then
					myPlate.threatInfo:SetFormattedText('%s%.0f%%|r', Hex(T.GetThreatStatusColor(status)), percent)
				end
			end
		end
	end
end)

function N:UpdateCount(event,unit,force)
	if (not T.find(unit, "raid") and not T.find(unit, "party") and not (unit == "player" and force) ) or T.find(unit, "pet") then return end
	if force and (T.IsInRaid() or T.IsInGroup()) then N:UpdateRoster() end
	local target
	for _, frame in T.pairs(C_NamePlate.GetNamePlates()) do
		if(frame and frame.UnitFrame) then
			local plate = frame.UnitFrame
			plate.targetcount:SetText("")
			plate.targetCount = 0
			if N.db.targetcount and plate.targetcount then
				if T.IsInRaid() or T.IsInGroup() then
					for name, unitid in T.pairs(N.GroupMembers) do
						if not T.UnitIsUnit(unitid,"player") then
							target = T.format("%starget", unitid)
							plate.guid = T.UnitGUID(plate.unit)
							if plate.guid and T.UnitExists(target) then
								if T.UnitGUID(target) == plate.guid then plate.targetCount = plate.targetCount + 1 end
							end
							if not (plate.targetCount == 0) then
								plate.targetcount:SetText(T.format('[%d]', plate.targetCount))
							end
						end
					end
				end
			end
		end
	end
end

local function AddToRoster(unitId)
	local unitName = T.UnitName(unitId)
	if unitName then
		N.GroupMembers[unitName] = unitId
	end
end

function N:UpdateRoster()
	T.twipe(N.GroupMembers)

	local groupSize = T.IsInRaid() and T.GetNumGroupMembers() or T.IsInGroup() and T.GetNumSubgroupMembers() or 0
	local groupType = T.IsInRaid() and "raid" or T.IsInGroup() and "party" or "solo"

	for index = 1, groupSize do
		AddToRoster(groupType..index)
	end

	if groupType == 'party' then
		AddToRoster('player')
	end
end

function N:StartRosterUpdate()
	if not rosterTimer or N:TimeLeft(rosterTimer) == 0 then
		rosterTimer = N:ScheduleTimer(N.UpdateRoster, 1)
	end
end

function N:Initialize()
	if not SLE.initialized then return end
	N.db = E.db.sle.nameplate
	N.viewPort = NP.viewPort
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "StartRosterUpdate")
	self:RegisterEvent("UNIT_TARGET", "UpdateCount")

	E:Delay(.3, function() N:UpdateCount(nil,"player", true) end)
	function N:ForUpdateAll()
		N.db = E.db.sle.nameplate
	end
end

SLE:RegisterModule(N:GetName())