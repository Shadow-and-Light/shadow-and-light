local E, L, V, P, G = unpack(ElvUI);
local NP = E:GetModule('NamePlates')
local LSM = LibStub("LibSharedMedia-3.0")

local UnitCanAttack, UnitDetailedThreatSituation, GetThreatStatusColor = UnitCanAttack, UnitDetailedThreatSituation, GetThreatStatusColor
local GetNumGroupMembers, GetNumSubgroupMembers = GetNumGroupMembers, GetNumSubgroupMembers
local IsInRaid, IsInGroup, UnitGUID, UnitName = IsInRaid, IsInGroup, UnitGUID, UnitName
local format, twipe = string.format, table.wipe
local rosterTimer

local function Hex(r, g, b)
	return format('|cFF%02x%02x%02x', r * 255, g * 255, b * 255)
end

local GroupMembers = {}

hooksecurefunc(NP, 'CreatePlate', function(self, frame)
	local myPlate = self.CreatedPlates[frame]
	if not myPlate then return end
	
	if not myPlate.threatInfo then
		myPlate.threatInfo = myPlate:CreateFontString(nil, "OVERLAY")
		myPlate.threatInfo:SetPoint("BOTTOMLEFT", myPlate.healthBar, "BOTTOMLEFT", 1, 2)
		myPlate.threatInfo:SetJustifyH("LEFT")
	end
	if not frame.targetcount then
		myPlate.targetcount = myPlate:CreateFontString(nil, "OVERLAY")
		myPlate.targetcount:SetPoint('BOTTOMRIGHT', myPlate.healthBar, 'BOTTOMRIGHT', 1, 2)
		myPlate.targetcount:SetJustifyH("RIGHT")
	end
	myPlate.threatInfo:FontTemplate(LSM:Fetch("font", NP.db.font), NP.db.fontSize, NP.db.fontOutline)
	myPlate.targetcount:FontTemplate(LSM:Fetch("font", NP.db.font), NP.db.fontSize, NP.db.fontOutline)
end)

hooksecurefunc(NP, 'GetThreatReaction', function(self, frame)
	local myPlate = self.CreatedPlates[frame]
	if not myPlate then return end

	if myPlate.threatInfo then
		myPlate.threatInfo:SetText()

		if E.db.sle.nameplate.showthreat then
			local unit = frame.unit
			if not unit then
				for i=1, 4 do
					if frame.guid == UnitGUID(('boss%d'):format(i)) then
						unit = ('boss%d'):format(i)
						break
					end
				end
			end

			if unit and not UnitIsPlayer(unit) and UnitCanAttack('player', unit) then
				local status, percent = select(2, UnitDetailedThreatSituation('player', unit))
				if (status) then
					myPlate.threatInfo:SetFormattedText('%s%.0f%%|r', Hex(GetThreatStatusColor(status)), percent)
				else
					myPlate.threatInfo:SetFormattedText('|cFF808080%s|r', L["None"])
				end
			end
		end
	end
	if E.db.sle.nameplate.targetcount and myPlate.targetcount then
		myPlate.targetcount:SetText()
		if frame.guid then
			local targetCount = 0
			local target
			for name, unitid in pairs(GroupMembers) do
				target = ("%starget"):format(unitid)
				if UnitExists(target) and UnitGUID(target) == frame.guid then
					targetCount = targetCount + 1
				end
			end
			--Set the target count text
			if not (targetCount == 0) then
				myPlate.targetcount:SetText(('[%d]'):format(targetCount))
			end
		end	
	end
end)

local function AddToRoster(unitId)
	local unitName = UnitName(unitId)
	if unitName then
		GroupMembers[unitName] = unitId
	end
end

local function UpdateRoster()
	twipe(GroupMembers)

	local groupSize = IsInRaid() and GetNumGroupMembers() or IsInGroup() and GetNumSubgroupMembers() or 0
	local groupType = IsInRaid() and "raid" or IsInGroup() and "party" or "solo"

	for index = 1, groupSize do
		AddToRoster(groupType..index)
	end
	
	if groupType == 'party' then
		AddToRoster('player')
	end
end

local function StartRosterUpdate()
	if not rosterTimer or NP:TimeLeft(rosterTimer) == 0 then
		rosterTimer = NP:ScheduleTimer(UpdateRoster, 1)
	end
end

NP:RegisterEvent("GROUP_ROSTER_UPDATE", StartRosterUpdate)