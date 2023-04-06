local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local NP = E.NamePlates
local N = SLE.Nameplates

-- GLOBALS: unpack, select, format, UnitName, hooksecurefunc, UnitIsPlayer, C_NamePlate
local format = format
local GetNamePlates = C_NamePlate.GetNamePlates
local UnitName, UnitExists = UnitName, UnitExists

local rosterTimer

--Table to cache the members of player's group
N.GroupMembers = {}

function N:CreateThreatIndicator(nameplate)
	nameplate.SLE_threatInfo = nameplate.Health:CreateFontString(nil, 'OVERLAY')
	nameplate.SLE_threatInfo:SetPoint('BOTTOMLEFT', nameplate.Health, 'BOTTOMLEFT', E.db.sle.nameplates.threat.xoffset, E.db.sle.nameplates.threat.yoffset)
	nameplate.SLE_threatInfo:SetJustifyH('LEFT')
	nameplate.SLE_threatInfo:FontTemplate(E.LSM:Fetch('font', E.db.sle.nameplates.threat.font), E.db.sle.nameplates.threat.size, E.db.sle.nameplates.threat.fontOutline)
end

hooksecurefunc(NP, 'ThreatIndicator_PostUpdate', function(threat, unit)
	if not threat.__owner then return end
	if threat.__owner.SLE_threatInfo then
		threat.__owner.SLE_threatInfo:SetText() --Reseting text to empty

		if E.db.sle.nameplates.threat.enable and threat.__owner.frameType == 'ENEMY_NPC' then
			if not unit then
				for i=1, 4 do
					if threat.__owner.guid == UnitGUID(format('boss%d', i)) then
						unit = format('boss%d', i)
						break
					end
				end
			end
			if unit and not UnitIsPlayer(unit) and UnitCanAttack('player', unit) then
				local status, percent = select(2, UnitDetailedThreatSituation('player', unit))
				if (status) then
					threat.__owner.SLE_threatInfo:SetFormattedText('%s%.0f%%|r', E:RGBToHex(GetThreatStatusColor(status)), percent or '')
				end
			end
		else
			threat.__owner.SLE_threatInfo:SetText('')
		end
	end
end)

function N:CreateTargetCounter(nameplate)
	nameplate.SLE_targetcount = nameplate.Health:CreateFontString(nil, 'OVERLAY')
	nameplate.SLE_targetcount:SetPoint('BOTTOMRIGHT', nameplate.Health, 'BOTTOMRIGHT', E.db.sle.nameplates.targetcount.xoffset, E.db.sle.nameplates.targetcount.yoffset)
	nameplate.SLE_targetcount:SetJustifyH('RIGHT')
	nameplate.SLE_TargetedByCounter = 0
	nameplate.SLE_targetcount:FontTemplate(E.LSM:Fetch('font', E.db.sle.nameplates.targetcount.font), E.db.sle.nameplates.targetcount.size, E.db.sle.nameplates.targetcount.fontOutline)
	nameplate.SLE_targetcount:SetText()
end

function N:UpdateCount(event, unit, force)
	if E.db.sle.nameplates.targetcount == nil or not E.db.sle.nameplates.targetcount.enable then return end
	if (not strfind(unit, 'raid') and not strfind(unit, 'party') and not (unit == 'player' and force) and not N.TestSoloTarget) or strfind(unit, 'pet') then return end
	local isGrouped = IsInRaid() or IsInGroup()
	local target

	--Forced update of the roster. Usually on load
	if force and isGrouped then N:UpdateRoster() end

	for _, frame in pairs(GetNamePlates()) do
		if(frame and frame.unitFrame) then
			local plate = frame.unitFrame

			--Reset couunter
			plate.SLE_targetcount:SetText('')
			plate.SLE_TargetedByCounter = 0

			--If in group, then update counter
			if isGrouped then
				for _, unitid in pairs(N.GroupMembers) do --For every unit in roster
					if not UnitIsUnit(unitid, 'player') and plate.unit then
						target = format('%starget', unitid) --Get group member's target
						plate.guid = UnitGUID(plate.unit) --Find unit's guid

						if plate.guid and UnitExists(target) then --If target exists and plate actually has unit, then someone actually targets this plate
							if UnitGUID(target) == plate.guid then
								plate.SLE_TargetedByCounter = plate.SLE_TargetedByCounter + 1
							end
						end
					end
				end
			end

			--If debug mode is set
			if N.TestSoloTarget then
				plate.guid = UnitGUID(plate.unit)

				if plate.guid and UnitExists('target') then
					if UnitGUID('target') == plate.guid then
						plate.SLE_TargetedByCounter = plate.SLE_TargetedByCounter + 1
					end
				end
			end
			if not (plate.SLE_TargetedByCounter == 0) then
				plate.SLE_targetcount:SetText(format('[%d]', plate.SLE_TargetedByCounter))
			end
		end
	end
end

--Adding people to roster table
local function AddToRoster(unitId)
	local unitName = UnitName(unitId)
	if unitName then N.GroupMembers[unitName] = unitId end
end

function N:UpdateRoster()
	wipe(N.GroupMembers)

	local groupSize = IsInRaid() and GetNumGroupMembers() or IsInGroup() and GetNumSubgroupMembers() or 0
	local groupType = IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'

	for index = 1, groupSize do
		AddToRoster(groupType..index)
	end

	if groupType == 'party' then
		AddToRoster('player')
	end
end

--Set a timer. cause on group update info about new member is not immidiately available
function N:StartRosterUpdate()
	if not rosterTimer then
		rosterTimer = N:ScheduleTimer(N.UpdateRoster, 1)
	end
end

function N:NamePlateCallBackSLE(nameplate, event, unit)
	if not nameplate then return end

	if event == 'NAME_PLATE_UNIT_ADDED' then
		--If nameplate is shown, update counter cause someone may have been targeting this bastard offscreen
		N:UpdateCount(nil, 'player', true)
	elseif event == 'NAME_PLATE_UNIT_REMOVED' then
		--Nameplate is hidden, reset everything
		if nameplate.SLE_threatInfo then
			nameplate.SLE_threatInfo:SetText('')
		end
		if nameplate.SLE_targetcount then
			nameplate.SLE_targetcount:SetText('')
			nameplate.SLE_TargetedByCounter = 0
		end
	end
end

--Creating additional nameplate elements
function N:CreateNameplate(frame)
	if not frame then return end

	if not frame.SLE_threatInfo then
		N:CreateThreatIndicator(frame)
	end
	if not frame.SLE_targetcount then
		N:CreateTargetCounter(frame)
	end
end


function N:UpdatePlate(nameplate)
	N.db = E.db.sle.nameplates
	if nameplate.SLE_threatInfo then
		nameplate.SLE_threatInfo:FontTemplate(E.LSM:Fetch('font', N.db.threat.font), N.db.threat.size, N.db.threat.fontOutline)
		nameplate.SLE_threatInfo:SetPoint('BOTTOMLEFT', nameplate.Health, 'BOTTOMLEFT', N.db.threat.xoffset, N.db.threat.yoffset)
		if not N.db.threat.enable then nameplate.SLE_threatInfo:SetText('') end
	end

	if nameplate.SLE_targetcount then
		nameplate.SLE_targetcount:FontTemplate(E.LSM:Fetch('font', N.db.targetcount.font), N.db.targetcount.size, N.db.targetcount.fontOutline)
		nameplate.SLE_targetcount:SetPoint('BOTTOMRIGHT', nameplate.Health, 'BOTTOMRIGHT', N.db.targetcount.xoffset, N.db.targetcount.yoffset)
		if N.db.targetcount.enable then N:UpdateCount(nil, 'player', true) else nameplate.SLE_targetcount:SetText(''); nameplate.SLE_TargetedByCounter = 0 end
	end
end

function N:Initialize()
	if not SLE.initialized or not E.private.nameplates.enable then return end
	N.db = E.db.sle.nameplates

	--Hooking to ElvUI's nameplates
	hooksecurefunc(NP, 'StylePlate', N.CreateNameplate)
	hooksecurefunc(NP, 'UpdatePlate', N.UpdatePlate)

	N:RegisterEvent('GROUP_ROSTER_UPDATE', 'StartRosterUpdate')
	N:RegisterEvent('UNIT_TARGET', 'UpdateCount')
	hooksecurefunc(NP, 'NamePlateCallBack', N.NamePlateCallBackSLE)

	--This function call is to update target count, cause right after creating it doesn't show up
	-- E:Delay(.3, function() N:UpdateCount(nil, 'player', true) end)

	function N:ForUpdateAll()
		N.db = E.db.sle.nameplates
		N:UpdateCount(nil, 'player', true)
	end
	N:ForUpdateAll()
end

SLE:RegisterModule(N:GetName())
