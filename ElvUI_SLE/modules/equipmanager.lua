local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local EM = SLE:NewModule('EquipManager', 'AceHook-3.0', 'AceEvent-3.0')
local GetRealZoneText = GetRealZoneText
EM.Processing = false
EM.ErrorShown = false

--GLOBALS: CreateFrame, CharacterFrame, SLASH_FISH1, SlashCmdList
local C_EquipmentSet = C_EquipmentSet
local _G = _G
local gsub = gsub

EM.SetData = {}

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
}

EM.TagsTable = {
	["solo"] = function() if T.IsInGroup() then return false; else return true; end end,
	["party"] = function(size)
		size = T.tonumber(size)
		if T.IsInGroup() then
			if size then
				if size == T.GetNumGroupMembers() then return true; else return false; end
			else
				return true
			end
		else
			return false
		end
	end,
	["raid"] = function(size)
		size = T.tonumber(size)
		if T.IsInRaid() then
			if size then
				if size == T.GetNumGroupMembers() then return true; else return false; end
			else
				return true
			end
		else
			return false
		end
	end,
	["spec"] = function(index)
		local index = T.tonumber(index)
		if not index then return false end
		if index == T.GetSpecialization() then return true; else return false; end
	end,
	["talent"] = function(tier, column)
		if not (tier or column) then return false end
		if not (T.tonumber(tier) or T.tonumber(column)) then return false end
		if tier < 0 or tier > 7 then SLE:ErrorPrint(T.format(L["SLE_EM_TAG_INVALID_TALENT_TIER"], tier)) return false end
		if column < 0 or column > 3 then SLE:ErrorPrint(T.format(L["SLE_EM_TAG_INVALID_TALENT_COLUMN"], column)) return false end
		local index = T.GetSpecialization()
		local _, _, _, selected = GetTalentInfo(tier, column, index)
		if selected then
			return true
		else
			return false
		end
	end,
	["instance"] = function(dungeonType)
		local inInstance, InstanceType = T.IsInInstance()
		if inInstance then
			if dungeonType then
				if InstanceType == dungeonType then return true; else return false; end
			else
				if InstanceType == "pvp" or InstanceType == "arena" then return false; else return true; end
			end
		else
			return false
		end
	end,
	["pvp"] = function(pvpType)
		local inInstance, InstanceType = T.IsInInstance()
		if inInstance then
			if pvpType and (InstanceType == "pvp" or InstanceType == "arena") then
				if InstanceType == pvpType then return true; else return false; end
			else
				if InstanceType == "pvp" or InstanceType == "arena" then return true; else return false; end
			end
		else
			for i = 1, T.GetNumWorldPVPAreas() do
				local _, localizedName, isActive, canQueue = T.GetWorldPVPAreaInfo(i)
				if (T.GetRealZoneText() == localizedName and isActive) or (T.GetRealZoneText() == localizedName and canQueue) then return true end
			end
			return false
		end
	end,
	["difficulty"] = function(difficulty)
		if not T.IsInInstance() then return false end
		if not difficulty then return false end
		local difID = T.select(3, T.GetInstanceInfo())
		if difficulty == Difficulties[difID] then
			return true;
		else
			return false;
		end
	end,
}

function EM:ConditionTable(option)
	if not option then return end
	local pattern = "%[(.-)%]([^;]+)"
	local Conditions = {
		["options"] = {},
		["set"] = "",
	}
	local condition
	while option:match(pattern) do
		condition, option = option:match(pattern)
		if not(condition and option) then return end
		T.tinsert(Conditions.options, condition)
	end
	Conditions.set = option:gsub("^%s*", "")
	T.tinsert(EM.SetData, Conditions)
end

function EM:TagsProcess(msg)
	T.twipe(EM.SetData)
	local split_msg = { (";"):split(msg) }

	for i, v in T.ipairs(split_msg) do
		local split = split_msg[i]
		EM:ConditionTable(split)
	end
	for i = 1, #EM.SetData do
		local Conditions = EM.SetData[i]
		for index = 1, #Conditions.options do
			local condition = Conditions.options[index]
			local cnd_table = { (","):split(condition) }
			local parsed_cmds = {};
			for j = 1, #cnd_table do
				local cnd = cnd_table[j];
				if cnd then
					local command, argument = (":"):split(cnd)
					local argTable = {}
					if T.find(argument, "%.") then
						SLE:ErrorPrint(L["SLE_EM_TAG_DOT_WARNING"])
					else
						if ("/"):split(argument) then
							local put
							while argument and ("/"):split(argument) do
								put, argument = ("/"):split(argument)
								T.tinsert(argTable, put)
							end
						else
							T.tinsert(argTable, argument)
						end
						
						local tag = command:match("^%s*(.+)%s*$")
						if EM.TagsTable[tag] then
							T.tinsert(parsed_cmds, { cmd = command:match("^%s*(.+)%s*$"), arg = argTable })
						else
							SLE:ErrorPrint(T.format(L["SLE_EM_TAG_INVALID"], tag))
							T.twipe(EM.SetData)
							return
						end
					end
				end
			end
			Conditions.options[index] = {cmds = parsed_cmds}
		end
	end
end

function EM:TagsConditionsCheck(data)
	for index,tagInfo in T.ipairs(data) do 
		local ok = true
		for _, option in T.ipairs(tagInfo.options) do
			if not option.cmds then return end
			local matches = 0
			for conditionIndex,conditionInfo in T.ipairs(option.cmds) do
				local func = conditionInfo["cmd"]
				if not EM.TagsTable[func] then
					SLE:ErrorPrint(T.format(L["SLE_EM_TAG_INVALID"], func))
					return nil
				end
				local arg = conditionInfo["arg"]
				local result = EM.TagsTable[func](T.unpack(arg))
				if result then 
					matches = matches + 1
				else
					matches = 0
					break 
				end
				if matches == #option.cmds then return tagInfo.set end
			end
		end
	end
end

local function Equip(event)
	if EM.Processing or EM.lock then return end
	if event == "ZONE_CHANGED" and EM.db.onlyTalent then return end
	EM.Processing = true
	local inCombat = false
	E:Delay(1, function() EM.Processing = false end)
	if T.InCombatLockdown() then
		EM:RegisterEvent("PLAYER_REGEN_ENABLED", Equip)
		inCombat = true
	end
	if event == "PLAYER_REGEN_ENABLED" then
		EM:UnregisterEvent(event)
		EM.ErrorShown = false
	end

	local equippedSet
	local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()
	for index = 1, C_EquipmentSet.GetNumEquipmentSets() do
		local name, _, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[index]);
		if isEquipped then
			equippedSet = name
			break
		end
	end
	local trueSet = EM:TagsConditionsCheck(EM.SetData)
	-- print("trueSet:", trueSet)
	if trueSet then
		local SetID = C_EquipmentSet.GetEquipmentSetID(trueSet)
		if SetID then
			if not equippedSet or (equippedSet and trueSet ~= equippedSet) then
				C_EquipmentSet.UseEquipmentSet(SetID)
			end
		else
			SLE:ErrorPrint(T.format(L["SLE_EM_SET_NOT_EXIST"], trueSet))
		end
	end
end

function EM:CreateLock()
	if _G["SLE_Equip_Lock_Button"] or not EM.db.lockbutton then return end
	local button = CreateFrame("Button", "SLE_Equip_Lock_Button", CharacterFrame)
	button:Size(20, 20)
	button:Point("BOTTOMLEFT", _G["CharacterFrame"], "BOTTOMLEFT", 4, 4)
	button:SetFrameLevel(_G["CharacterModelFrame"]:GetFrameLevel() + 2)
	button:SetScript("OnEnter", function(self)
		_G["GameTooltip"]:SetOwner(self)
		_G["GameTooltip"]:AddLine(L["SLE_EM_LOCK_TOOLTIP"])
		_G["GameTooltip"]:Show()
	end)
	button:SetScript("OnLeave", function(self)
		_G["GameTooltip"]:Hide() 
	end)
	E:GetModule("Skins"):HandleButton(button)

	button.TitleText = button:CreateFontString(nil, "OVERLAY")
	button.TitleText:FontTemplate()
	button.TitleText:SetPoint("BOTTOMLEFT", button, "TOPLEFT", 0, 0)
	button.TitleText:SetJustifyH("LEFT")
	button.TitleText:SetText(L["SLE_EM_LOCK_TITLE"])

	button.Icon = button:CreateTexture(nil, "OVERLAY")
	button.Icon:SetAllPoints()
	button.Icon:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\lock]])
	button.Icon:SetVertexColor(0, 1, 0)

	button:SetScript("OnClick", function()
		EM.lock = not EM.lock
		button.Icon:SetVertexColor(EM.lock and 1 or 0, EM.lock and 0 or 1, 0)
	end)
end

function EM:UpdateTags()
	EM:TagsProcess(EM.db.conditions)
	Equip()
end

function EM:Initialize()
	EM.db = E.private.sle.equip
	EM.lock = false
	if not SLE.initialized then return end
	if not EM.db.enable then return end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", Equip)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", Equip)
	self:RegisterEvent("ZONE_CHANGED", Equip)

	EM:TagsProcess(EM.db.conditions)

	self:CreateLock()
end

SLE:RegisterModule(EM:GetName())

