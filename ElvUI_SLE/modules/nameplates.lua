local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule('NamePlates')
local N = SLE:NewModule("Nameplates", 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local rosterTimer

local GetNamePlates = C_NamePlate.GetNamePlates

local function Hex(r, g, b)
	return T.format('|cFF%02x%02x%02x', r * 255, g * 255, b * 255)
end

N.GroupMembers = {}

function N:UpdateFonts(plate)
	if not plate then return end

	if plate.targetcount then
		plate.targetcount:FontTemplate(E.LSM:Fetch("font", N.db.targetcount.font), N.db.targetcount.size, N.db.targetcount.fontOutline)
	end
	if plate.threatInfo then
		plate.threatInfo:FontTemplate(E.LSM:Fetch("font", N.db.threat.font), N.db.threat.size, N.db.threat.fontOutline)
	end
end

function N:UpdatePlateFonts()
	self:ForEachPlate("UpdateFonts")
	if self.PlayerFrame__ then
		self:UpdateFonts(self.PlayerFrame__.unitFrame)
	end
end

function N:CreateTargetCounter(plate)
	plate.targetcount = plate.HealthBar:CreateFontString(nil, "OVERLAY")
	plate.targetcount:SetPoint('BOTTOMRIGHT', plate.HealthBar, 'BOTTOMRIGHT', 1, 2)
	plate.targetcount:SetJustifyH("RIGHT")
	plate.targetCount = 0
	plate.targetcount:FontTemplate(E.LSM:Fetch("font", N.db.targetcount.font), N.db.targetcount.size, N.db.targetcount.fontOutline)
	plate.targetcount:SetText()
end

function N:CreateThreatIndicator(plate)
	plate.threatInfo = plate.HealthBar:CreateFontString(nil, "OVERLAY")
	plate.threatInfo:SetPoint("BOTTOMLEFT", plate.HealthBar, "BOTTOMLEFT", 1, 2)
	plate.threatInfo:SetJustifyH("LEFT")
	plate.threatInfo:FontTemplate(E.LSM:Fetch("font", N.db.threat.font), N.db.threat.size, N.db.threat.fontOutline)
end

function N:CreateNameplate(event, frame)
	local plate = frame.unitFrame
	if not plate then return end

	if not plate.threatInfo then
		N:CreateThreatIndicator(plate)
	end
	if not plate.targetcount then
		N:CreateTargetCounter(plate)
	end
end

hooksecurefunc(NP, 'Update_ThreatList', function(self, myPlate)
	if not plate then return end

	if plate.threatInfo then
		plate.threatInfo:SetText()

		if E.db.sle.nameplates.threat.enable and plate.UnitType == "ENEMY_NPC" then
			local unit = plate.unit
			if not unit then
				for i=1, 4 do
					if plate.guid == T.UnitGUID(T.format('boss%d', i)) then
						unit = T.format('boss%d', i)
						break
					end
				end
			end
			if unit and not T.UnitIsPlayer(unit) and T.UnitCanAttack('player', unit) then
				local status, percent = T.select(2, T.UnitDetailedThreatSituation('player', unit))
				if (status) then
					plate.threatInfo:SetFormattedText('%s%.0f%%|r', Hex(T.GetThreatStatusColor(status)), percent or "")
				end
			end
		end
	end
end)

function N:UpdateCount(event,unit,force)
	if (not T.find(unit, "raid") and not T.find(unit, "party") and not (unit == "player" and force) and not N.TestSoloTarget) or T.find(unit, "pet") then return end
	if force and (T.IsInRaid() or T.IsInGroup()) then N:UpdateRoster() end
	local target
	for _, frame in T.pairs(GetNamePlates()) do
		if(frame and frame.unitFrame) then
			local plate = frame.unitFrame
			plate.targetcount:SetText("")
			plate.targetCount = 0
			if N.db.targetcount.enable and plate.targetcount then
				if T.IsInRaid() or T.IsInGroup() then
					for name, unitid in T.pairs(N.GroupMembers) do
						if not T.UnitIsUnit(unitid,"player") and plate.unit then
							target = T.format("%starget", unitid)
							plate.guid = T.UnitGUID(plate.unit)
							if plate.guid and T.UnitExists(target) then
								if T.UnitGUID(target) == plate.guid then plate.targetCount = plate.targetCount + 1 end
							end
						end
					end
				end
				if N.TestSoloTarget then
					plate.guid = T.UnitGUID(plate.unit)
					if plate.guid and T.UnitExists("target") then
						if T.UnitGUID("target") == plate.guid then plate.targetCount = plate.targetCount + 1 end
					end
				end
				if not (plate.targetCount == 0) then plate.targetcount:SetText(T.format('[%d]', plate.targetCount))	end
			end
		end
	end
end

local function AddToRoster(unitId)
	local unitName = T.UnitName(unitId)
	if unitName then N.GroupMembers[unitName] = unitId end
end

function N:UpdateRoster()
	T.twipe(N.GroupMembers)

	local groupSize = T.IsInRaid() and T.GetNumGroupMembers() or T.IsInGroup() and T.GetNumSubgroupMembers() or 0
	local groupType = T.IsInRaid() and "raid" or T.IsInGroup() and "party" or "solo"

	for index = 1, groupSize do AddToRoster(groupType..index) end

	if groupType == 'party' then AddToRoster('player') end
end

function N:StartRosterUpdate()
	if not rosterTimer then
		rosterTimer = N:ScheduleTimer(N.UpdateRoster, 1)
	end
end

function N:NAME_PLATE_UNIT_ADDED(event, unit, frame)
	local frame = frame or NP:GetNamePlateForUnit(unit);
	
	N:UpdateCount(nil,"player", true)
end

function N:NAME_PLATE_UNIT_REMOVED(event, unit, frame, ...)
	local frame = frame or NP:GetNamePlateForUnit(unit);
	local plate = frame.unitFrame
	if not plate then return end
	if plate.threatInfo then plate.threatInfo:SetText("") end
	if plate.targetcount then
		plate.targetcount:SetText("")
		plate.targetCount = 0
	end
end

function N:UpdateAllFrame(frame)
	if(frame == self.PlayerFrame__) then return end

	local unit = frame.unit
	N:NAME_PLATE_UNIT_REMOVED("NAME_PLATE_UNIT_REMOVED", unit)
	N:NAME_PLATE_UNIT_ADDED("NAME_PLATE_UNIT_ADDED", unit)
end

function N:Initialize()
	if not SLE.initialized or not E.private.nameplates.enable then return end
	--DB converts
	if E.db.sle.nameplates.targetcount and T.type(E.db.sle.nameplates.targetcount) == "boolean" then
		local oldEnable = E.db.sle.nameplates.targetcount
		E.db.sle.nameplates.targetcount = {
			["enable"] = oldEnable,
			["font"] = "PT Sans Narrow",
			["size"] = 12,
			["fontOutline"] = "OUTLINE",
		}
	end
	if E.db.sle.nameplates.showthreat then
		E.db.sle.nameplates.threat.enable = E.db.sle.nameplates.showthreat
		E.db.sle.nameplates.showthreat = nil
	end
	
	N.db = E.db.sle.nameplates
	
	hooksecurefunc(NP, 'NAME_PLATE_CREATED', N.CreateNameplate)
	hooksecurefunc(NP, "UpdateFonts", N.UpdateFonts)
	hooksecurefunc(NP, "UpdateAllFrame", N.UpdateAllFrame)
	
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "StartRosterUpdate")
	self:RegisterEvent("UNIT_TARGET", "UpdateCount")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")

	E:Delay(.3, function() N:UpdateCount(nil,"player", true) end)
	function N:ForUpdateAll()
		--DB converts
		if (E.db.sle.nameplates.targetcount and T.type(E.db.sle.nameplates.targetcount) == "boolean") or not E.db.sle.nameplates.targetcount then
			local oldEnable = E.db.sle.nameplates.targetcount
			E.db.sle.nameplates.targetcount = {
				["enable"] = oldEnable,
				["font"] = "PT Sans Narrow",
				["size"] = 12,
				["fontOutline"] = "OUTLINE",
			}
		end
		if E.db.sle.nameplates.showthreat then
			E.db.sle.nameplates.threat.enable = E.db.sle.nameplates.showthreat
			E.db.sle.nameplates.showthreat = nil
		end
	
		N.db = E.db.sle.nameplates
	end
end

SLE:RegisterModule(N:GetName())