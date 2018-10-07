local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule('NamePlates')
local N = SLE:NewModule("Nameplates", 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local rosterTimer

local GetNamePlates = C_NamePlate.GetNamePlates

local function RGBToHex(r, g, b)
	return T.format('|cFF%02x%02x%02x', r * 255, g * 255, b * 255)
end

--Table to cache the members of player's group
N.GroupMembers = {}

--Fonts update
function N:UpdateFonts(plate)
	if not plate then return end

	if plate.SLE_targetcount then
		plate.SLE_targetcount:FontTemplate(E.LSM:Fetch("font", N.db.targetcount.font), N.db.targetcount.size, N.db.targetcount.fontOutline)
	end
	if plate.SLE_threatInfo then
		plate.SLE_threatInfo:FontTemplate(E.LSM:Fetch("font", N.db.threat.font), N.db.threat.size, N.db.threat.fontOutline)
	end
end

function N:UpdateAllPlateFonts()
	self:ForEachPlate("UpdateFonts")
	if self.PlayerFrame__ then
		self:UpdateFonts(self.PlayerFrame__.unitFrame)
	end
end

function N:CreateThreatIndicator(plate)
	plate.SLE_threatInfo = plate.HealthBar:CreateFontString(nil, "OVERLAY")
	plate.SLE_threatInfo:SetPoint("BOTTOMLEFT", plate.HealthBar, "BOTTOMLEFT", 1, 2)
	plate.SLE_threatInfo:SetJustifyH("LEFT")
	plate.SLE_threatInfo:FontTemplate(E.LSM:Fetch("font", N.db.threat.font), N.db.threat.size, N.db.threat.fontOutline)
end

hooksecurefunc(NP, 'Update_ThreatList', function(self, plate)
	if not plate then return end

	if plate.SLE_threatInfo then
		plate.SLE_threatInfo:SetText() --Reseting text to empty

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
					plate.SLE_threatInfo:SetFormattedText('%s%.0f%%|r', RGBToHex(T.GetThreatStatusColor(status)), percent or "")
				end
			end
		end
	end
end)

function N:CreateTargetCounter(plate)
	plate.SLE_targetcount = plate.HealthBar:CreateFontString(nil, "OVERLAY")
	plate.SLE_targetcount:SetPoint('BOTTOMRIGHT', plate.HealthBar, 'BOTTOMRIGHT', 1, 2)
	plate.SLE_targetcount:SetJustifyH("RIGHT")
	plate.SLE_TargetedByCounter = 0
	plate.SLE_targetcount:FontTemplate(E.LSM:Fetch("font", N.db.targetcount.font), N.db.targetcount.size, N.db.targetcount.fontOutline)
	plate.SLE_targetcount:SetText()
end

function N:UpdateCount(event,unit,force)
	if N.db.targetcount == nil or not N.db.targetcount.enable then return end
	if (not T.find(unit, "raid") and not T.find(unit, "party") and not (unit == "player" and force) and not N.TestSoloTarget) or T.find(unit, "pet") then return end
	local isGrouped = T.IsInRaid() or T.IsInGroup()
	local target
	--Forced update of the roster. Usually on load
	if force and isGrouped then N:UpdateRoster() end
	for _, frame in T.pairs(GetNamePlates()) do
		if(frame and frame.unitFrame) then
			local plate = frame.unitFrame
			--Reset couunter
			plate.SLE_targetcount:SetText("")
			plate.SLE_TargetedByCounter = 0
			--If in group, then update counter
			if isGrouped then
				for _, unitid in T.pairs(N.GroupMembers) do --For every unit in roster
					if not T.UnitIsUnit(unitid,"player") and plate.unit then
						target = T.format("%starget", unitid) --Get group member's target
						plate.guid = T.UnitGUID(plate.unit) --Find unit's guid
						if plate.guid and T.UnitExists(target) then --If target exists and plate actually has unit, then someone actually targets this plate
							if T.UnitGUID(target) == plate.guid then plate.SLE_TargetedByCounter = plate.SLE_TargetedByCounter + 1 end
						end
					end
				end
			end
			--If debug mode is set
			if N.TestSoloTarget then
				plate.guid = T.UnitGUID(plate.unit)
				if plate.guid and T.UnitExists("target") then
					if T.UnitGUID("target") == plate.guid then plate.SLE_TargetedByCounter = plate.SLE_TargetedByCounter + 1 end
				end
			end
			if not (plate.SLE_TargetedByCounter == 0) then plate.SLE_targetcount:SetText(T.format('[%d]', plate.SLE_TargetedByCounter))	end
		end
	end
end

--Adding people to roster table
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

--Set a timer. cause on group update info about new member is not immidiately available
function N:StartRosterUpdate()
	if not rosterTimer then
		rosterTimer = N:ScheduleTimer(N.UpdateRoster, 1)
	end
end

--If nameplate is shown, update counter cause someone may have been targeting this bastard offscreen
function N:NAME_PLATE_UNIT_ADDED(event, unit, frame)
	local frame = frame or NP:GetNamePlateForUnit(unit);

	N:UpdateCount(nil,"player", true)
end

--Nameplate is hidden, reset everything
function N:NAME_PLATE_UNIT_REMOVED(event, unit, frame, ...)
	local frame = frame or NP:GetNamePlateForUnit(unit);
	local plate = frame.unitFrame
	if not plate then return end
	if plate.SLE_threatInfo then plate.SLE_threatInfo:SetText("") end
	if plate.SLE_targetcount then
		plate.SLE_targetcount:SetText("")
		plate.SLE_TargetedByCounter = 0
	end
end

function N:UpdateAllFrame(frame)
	if(frame == self.PlayerFrame__) then return end

	local unit = frame.unit
	N:NAME_PLATE_UNIT_REMOVED("NAME_PLATE_UNIT_REMOVED", unit)
	N:NAME_PLATE_UNIT_ADDED("NAME_PLATE_UNIT_ADDED", unit)
end

--Creating additional nameplate elements
function N:CreateNameplate(event, frame)
	local plate = frame.unitFrame
	if not plate then return end

	if not plate.SLE_threatInfo then
		N:CreateThreatIndicator(plate)
	end
	if not plate.SLE_targetcount then
		N:CreateTargetCounter(plate)
	end
end

function N:Initialize()
	if not SLE.initialized or not E.private.nameplates.enable then return end
	--DB Conversion
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

	--Hooking to ElvUI's nameplates
	hooksecurefunc(NP, 'NAME_PLATE_CREATED', N.CreateNameplate)
	hooksecurefunc(NP, "UpdateFonts", N.UpdateFonts)
	hooksecurefunc(NP, "UpdateAllFrame", N.UpdateAllFrame)
	
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "StartRosterUpdate")
	self:RegisterEvent("UNIT_TARGET", "UpdateCount")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")

	--This function call is to update target count, cause right after creating it doesn't show up
	E:Delay(.3, function() N:UpdateCount(nil,"player", true) end)

	function N:ForUpdateAll()
		N.db = E.db.sle.nameplates
		--Additional DB conversion
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
	end
end

SLE:RegisterModule(N:GetName())