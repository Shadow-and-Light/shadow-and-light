local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local EM = SLE.EquipManager

--GLOBALS: unpack, select, CreateFrame, CharacterFrame
local _G = _G
local format = format
local UnitEffectiveLevel = UnitEffectiveLevel
local C_EquipmentSet = C_EquipmentSet
local GetRealZoneText = GetRealZoneText
local C_Calendar = C_Calendar
local C_DateAndTime = C_DateAndTime
local time = time
local IsSpellKnown = IsSpellKnown
local C_Spell_GetSpellInfo = C_Spell.GetSpellInfo
local C_PvP_IsActiveBattlefield = C_PvP.IsActiveBattlefield
local C_PvP_IsPVPMap = C_PvP.IsPVPMap
local C_PvP_IsArena = C_PvP.IsArena
local C_PvP_IsMatchConsideredArena = C_PvP.IsMatchConsideredArena
local C_PvP_IsWarModeDesired = C_PvP.IsWarModeDesired
local UnitIsPVP = UnitIsPVP

EM.Conditions = {}
EM.Processing = false

local Difficulties = {
	[1] = 'normal', --5ppl normal
	[2] = 'heroic', --5ppl heroic
	[3] = 'normal', --10ppl raid
	[4] = 'normal', --25ppl raid
	[5] = 'heroic', --10ppl heroic raid
	[6] = 'heroic', --25ppl heroic raid
	[7] = 'lfr', --25ppl LFR
	[8] = 'challenge', --5ppl challenge
	[9] = 'normal', --40ppl raid
	[11] = 'heroic', --Heroic scenario
	[12] = 'normal', --Normal scenario
	[14] = 'normal', --10-30ppl normal
	[15] = 'heroic', --13-30ppl heroic
	[16] = 'mythic', --20ppl mythic
	[17] = 'lfr', --10-30 LFR
	[23] = 'mythic', --5ppl mythic
	[24] = 'timewalking', --Timewalking
	[33] = 'timewalking', -- Timewalking Raids
	[34] = 'pvp',
	[38] = 'normal', -- Normal Scenario (Islands)
	[39] = 'heroic', -- Heroic Scenario (Islands)
	[40] = 'mythic', -- Mythic Scenario (Islands)
	[45] = 'pvp', -- PvP Scenario (Islands)
	[147] = 'normal', -- Warfront
	[149] = 'heroic', -- Heroic Warfront
	[150] = 'timewalking', -- Timewalking Campaign (Chromie Time)
	[151] = 'timewalking', -- LFR Timewalking Raids
	[152] = 'horrificvision', -- Horrific Vision of Stormwind|Orgrimmar
	[167] = 'torghast', -- Torghast
}

--Table of tags conditions for gear switching
EM.TagsTable = {
	--self explanatory
	['solo'] = function()
		if IsInGroup() then
			return false
		else
			return true
		end
	end,
	--if in party. Can use [party:size] with size as an argument. If group size equals to provided number. Without number true for any group
	['party'] = function(size)
		size = tonumber(size)
		if IsInGroup() then
			if size then
				if size == GetNumGroupMembers() then
					return true
				else
					return false
				end
			else
				return true
			end
		else
			return false
		end
	end,
	--if in raid. Can use [raid:size] with size as an argument. If raid size equals to provided number. Without number true for any raid
	['raid'] = function(size)
		size = tonumber(size)
		if IsInRaid() then
			if size then
				if size == GetNumGroupMembers() then
					return true
				else
					return false
				end
			else
				return true
			end
		else
			return false
		end
	end,
	--if spec index. Index is required. 1, 2, 3 or 4 (for droodz)
	['spec'] = function(index)
		index = tonumber(index)
		if not index then return false end
		if index == GetSpecialization() then
			return true
		else
			return false
		end
	end,
	--Talent selected. [talent:spell id|name]
	['talent'] = function(idOrName)
		local activeConfigID = C_ClassTalents.GetActiveConfigID()
		local configInfo = C_Traits.GetConfigInfo(activeConfigID)
		local treeID = configInfo.treeIDs[1]
		local nodeIDs = C_Traits.GetTreeNodes(treeID)
		local passed = false
		for _, nodeID in next, nodeIDs do
			local nodeInfo = C_Traits.GetNodeInfo(activeConfigID, nodeID)
			for _, entryID in next, nodeInfo.entryIDs do
				local entryInfo = C_Traits.GetEntryInfo(activeConfigID, entryID)
				local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
				local purchased = nodeInfo.ranksPurchased > 0
				passed = purchased and (definitionInfo.spellID == tonumber(idOrName) or C_Spell_GetSpellInfo(definitionInfo.spellID).spellID == idOrName)
				if passed then break end
			end
			if passed then break end
		end
		return passed
	end,
	['spell'] = function(idOrName)
		local isNum = tonumber(idOrName)
		local isKnown
		if isNum then
			return IsSpellKnown(idOrName)
		else
			return IsSpellKnown(C_Spell_GetSpellInfo(idOrName).spellID)
		end
		return false
	end,
	--If in instanse. Optional arg [instance:type] - party, raid, scenario
	['instance'] = function(dungeonType)
		local inInstance, InstanceType = IsInInstance()
		if inInstance then
			if dungeonType then
				if InstanceType == dungeonType then
					return true
				else
					return false
				end
			else
				if InstanceType == 'pvp' or InstanceType == 'arena' then
					return false
				else
					return true
				end
			end
		else
			return false
		end
	end,
	--If in pvp zone. [pvp:type] - pvp, arena
	['pvp'] = function(pvpType)
		if C_PvP_IsActiveBattlefield() then --IsActiveBattlefield returns true for both instanced pvp and for world pvp zones
			if C_PvP_IsPVPMap() then --Seems to be true only for instanced pvp
				if pvpType then
					local instType = (C_PvP_IsArena() or C_PvP_IsMatchConsideredArena()) and 'arena' or 'pvp'

					if instType == pvpType then
						return true
					else
						return false
					end
				else
					return true
				end
			else
				if UnitIsPVP("player") then
					return true
				else
					return false
				end
			end
		else
			return false
		end
	end,
	--Instance difficulty. normal, heroic, etc
	['difficulty'] = function(difficulty)
		if not IsInInstance() or not difficulty then return false end
		local difID = select(3, GetInstanceInfo())
		if difficulty == Difficulties[difID] then
			return true
		else
			return false
		end
	end,
	['effectivelevel'] = function(level)
		local _level = UnitEffectiveLevel('player')
		return _level == tonumber(level)
	end,
	--Well, it's just true :D
	['NoCondition'] = function()
		return true
	end,
	['warmode'] = function()
		return C_PvP_IsWarModeDesired()
	end,
	['event'] = function(ids)
		if not ids or ids == "" then
			return false
		end
		local currentTime = C_DateAndTime.GetCurrentCalendarTime()
		local passed = false
		local function convertDateToTime(inTbl)
			-- time() complains if day is not set so copy the monthDay field to day
			inTbl.day = inTbl.monthDay
			return time(inTbl)
		end
		local now = convertDateToTime(currentTime)
		for id in string.gmatch(ids, "([^/]+)") do
			local eventInfo = C_Calendar.GetEventIndexInfo(id)
			if eventInfo and eventInfo.offsetMonths <= 0 then
				local holidayInfo = C_Calendar.GetHolidayInfo(eventInfo.offsetMonths, eventInfo.monthDay, eventInfo.eventIndex)
				local startTime = convertDateToTime(holidayInfo.startTime)
				local endTime = convertDateToTime(holidayInfo.endTime)
				if not passed then
					passed = now > startTime and now < endTime
				end
				if passed then
					break
				end
			end
		end

		return passed
	end,
}

--Building up set data
function EM:BuildingConditions(option)
	if not option then return end --if no condition string is passed, return
	local pattern = '%[(.-)%]([^;]+)'
	local SetInfo = {
		options = {}, --tag/args combos for set
		set = '', --Set name
	}
	local condition

	while option:match(pattern) do --If matched that means eligible condition tag is found, e.g. [tag:arg]
		condition, option = option:match(pattern)
		if not(condition and option) then return end
		tinsert(SetInfo.options, condition)
	end
	SetInfo.set = option:gsub('^%s*', '')
	tinsert(EM.Conditions, SetInfo)
end

--Function to setup a table of calls for conditions provided by user
function EM:TagsProcess(msg)
	if msg == '' then return end --No conditions were passed. Whya the hell this module is even enabled then?!
	wipe(EM.Conditions)
	local MsgSections = { (';'):split(msg) } --Splitting message (e.g. option line) to short parts by a separator symbol ";"

	--Cycling through table to add conditions contained in every section to the table
	for i, v in ipairs(MsgSections) do
		local section = MsgSections[i]
		EM:BuildingConditions(section)
	end
	--Going trought conditions to build actual function calls into conditions table
	for i = 1, #EM.Conditions do
		local SetInfo = EM.Conditions[i]
		if #SetInfo.options == 0 then --if number of options (tag/arg combos) is 0 this means that's the last "if everything else failed" type of call.
			SetInfo.options[1] = {commands = {{condition = 'NoCondition', args = {}}}}
		else
			for index = 1, #SetInfo.options do
				local condition = SetInfo.options[index] --Getting the string
				local ConditionList = { (','):split(condition) } --Making it to a set of conditions to check
				local CommandsInfo = {} --Table for functions to check + arguments to pass
				for j = 1, #ConditionList do
					local tagString = ConditionList[j]; --Getting the full tag "tag:args"
					if tagString then --If it exists. Otherwise how the fuck it happened to be in the table in the first place, but better be safe than sorry.
						local command, argument = (':'):split(tagString) --Split actual core tag from arguments
						local argTable = {} --List of arguments to pass later
						if argument and strfind(argument, '%.') then --If dot is found then warn the user of a typo. This is a high class establishment, we use commas here.
							SLE:Print(L["SLE_EM_TAG_DOT_WARNING"], 'error')
						else
							if argument and ('/'):split(argument) then --if tag happened to have 2+ argumants
								local former
								while argument and ('/'):split(argument) do
									former, argument = ('/'):split(argument)
									tinsert(argTable, former)
								end
							else
								tinsert(argTable, argument)
							end

							--Find the tag in provided tag list
							local tag = command:match('^%s*(.+)%s*$')
							if EM.TagsTable[tag] then --If tag is registered, add stuff to the table
								tinsert(CommandsInfo, { condition = command:match('^%s*(.+)%s*$'), args = argTable })
							elseif tag:sub(1,2) == 'no' and EM.TagsTable[tag:sub(3,-1)] then
								tinsert(CommandsInfo, { condition =  command:match('^%s*no(.+)%s*$'), args = argTable, negate = true })
							else
								--We don't use that kind of tag in this neighborhood
								SLE:Print(format(L["SLE_EM_TAG_INVALID"], tag), 'error')
								--Wipe the table and stop executing cause since one tag is wrong the string will fail to execute anyways
								wipe(EM.Conditions)
								return
							end
						end
					end
				end
				--Raplce general info with determained function calls and arguments
				SetInfo.options[index] = {commands = CommandsInfo}
			end
		end
	end
end

--Checking if some tag condition is true for the provided conditions table
function EM:TagsConditionsCheck(data)
	for _, tagInfo in ipairs(data) do
		for _, option in ipairs(tagInfo.options) do
			if not option.commands then return end --if for some unimaginable reason this is missing, better stop doing everything
			local matches = 0 --Number of conditions passed in this tag check
			for _, conditionInfo in ipairs(option.commands) do
				--Getting function that determines if condition is met
				local tagFunc = conditionInfo['condition']
				--If tag contains nil (tho previous checks should have this covere already) or not actually a function
				if not EM.TagsTable[tagFunc] or type(EM.TagsTable[tagFunc]) ~= 'function' then
					SLE:Print(format(L["SLE_EM_TAG_INVALID"], tagFunc), 'error')
					return nil
				end
				--Getting arguments table and use it to call a tag check
				local args = conditionInfo['args']
				local result = EM.TagsTable[tagFunc](unpack(args))
				if conditionInfo['negate'] then
					result = not result
				end
				--if check returns true then we have a match
				if result then
					matches = matches + 1
				else
					matches = 0
					break
				end
				--if every check matches then this condition is met, returning result
				if matches == #option.commands then return tagInfo.set end
			end
		end
	end
end

local equippedSets = {}

--Equipping stuff
local function DelayedEquip()
	--Figuring out the hell should be equipped
	wipe(equippedSets)
	local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
	--If any actual equip set is on
	for index = 1, C_EquipmentSet.GetNumEquipmentSets() do
		local name, _, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[index])
		if isEquipped then --Set found
			tinsert(equippedSets, name)
		end
	end
	--What actually should be equipped, based on tags
	local trueSet = EM:TagsConditionsCheck(EM.Conditions)
	--If something should be equipped
	if trueSet then
		--Get id
		local SetID = C_EquipmentSet.GetEquipmentSetID(trueSet)
		if SetID then
			--If it is not what's equipped right now, then put it on.
			if #equippedSets == 0 or not tContains(equippedSets, trueSet) then
				C_EquipmentSet.UseEquipmentSet(SetID)
			end
		else
			--if id of specifiet set is not peresent (e.g. no set named like trueSet exists), you should probably revisit your tag line
			SLE:Print(format(L["SLE_EM_SET_NOT_EXIST"], trueSet), 'error')
		end
	end

	--Usualy it takes around a second to equip everything
	E:Delay(1, function() EM.Processing = false end)
end

local function Equip(event, ...)
	--If equip is in process or lock button is checked, then return
	if EM.Processing or EM.lock then return end
	--Only equip stuff on first load
	if event == 'PLAYER_ENTERING_WORLD' then EM:UnregisterEvent(event) end
	EM.Processing = true

	--Don't try to equip in combat. it wouldn't work anyways
	if InCombatLockdown() then
		EM:RegisterEvent('PLAYER_REGEN_ENABLED', Equip)
		EM.Processing = false
		return
	end
	if event == 'PLAYER_REGEN_ENABLED' then
		EM:UnregisterEvent(event)
	end

	--apparently new spel knows statuses are available a bit after the spec switch => a bit of a delay
	E:Delay(1, DelayedEquip)
end



--Creating a lock button. Prevents gear from auto equip
function EM:CreateLock()
	if _G.SLE_Equip_Lock_Button or not EM.db.lockbutton then return end
	local button = CreateFrame('Button', 'SLE_Equip_Lock_Button', _G.PaperDollFrame)
	button:Size(20, 20)
	button:Point('BOTTOMLEFT', _G.CharacterFrame, 'BOTTOMLEFT', 4, 4)
	button:SetFrameLevel(_G.CharacterModelScene:GetFrameLevel() + 2)
	button:SetScript('OnEnter', function(self)
		_G.GameTooltip:SetOwner(self)
		_G.GameTooltip:AddLine(L["SLE_EM_LOCK_TOOLTIP"])
		_G.GameTooltip:Show()
	end)
	button:SetScript('OnLeave', function(self)
		_G.GameTooltip:Hide()
	end)
	E.Skins:HandleButton(button)

	button.Icon = button:CreateTexture(nil, 'OVERLAY')
	button.Icon:SetAllPoints()
	button.Icon:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\lock]])
	button.Icon:SetVertexColor(0, 1, 0)

	button:SetScript('OnClick', function()
		EM.lock = not EM.lock
		button.Icon:SetVertexColor(EM.lock and 1 or 0, EM.lock and 0 or 1, 0)
	end)
end

function EM:UpdateTags()
	EM:TagsProcess(EM.db.conditions)
	Equip()
end

EM.Events = {}
function EM:RegisterNewEvent(event)
	if not EM.Events[event] then
		EM:RegisterEvent(event, Equip)
		EM.Events[event] = true
	end
end

function EM:Initialize()
	EM.db = E.private.sle.equip
	if not SLE.initialized or not EM.db.enable then return end
	EM.lock = false

	EM:RegisterNewEvent('PLAYER_ENTERING_WORLD')
	EM:RegisterNewEvent('LOADING_SCREEN_DISABLED')
	EM:RegisterNewEvent('ACTIVE_TALENT_GROUP_CHANGED')
	EM:RegisterNewEvent('SPELLS_CHANGED')
	EM:RegisterNewEvent('PLAYER_LEVEL_CHANGED')
	EM:RegisterNewEvent('GROUP_ROSTER_UPDATE')
	EM:RegisterNewEvent('PLAYER_FLAGS_CHANGED')

	--Initial apply options
	EM:TagsProcess(EM.db.conditions)

	EM:CreateLock()
end

SLE:RegisterModule(EM:GetName())
