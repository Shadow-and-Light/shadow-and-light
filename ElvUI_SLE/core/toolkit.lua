local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local _G = _G
local getmetatable = getmetatable
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

--Adding a lot of shit from global functions--
T.format = format
T.strlower = strlower
T.random = random
--Time/date
T.date = date
T.time = time
T.difftime = difftime
T.GetTime = GetTime
--Unit infos
T.UnitLevel = UnitLevel
T.UnitClass = UnitClass
T.UnitRace = UnitRace
T.UnitName = UnitName
T.GetUnitName = GetUnitName
T.UnitFactionGroup = UnitFactionGroup
T.UnitAura = UnitAura
T.UnitBuff = UnitBuff
T.UnitDebuff = UnitDebuff
T.GetSpecialization = GetSpecialization
T.GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
T.GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
T.GetActiveSpecGroup = GetActiveSpecGroup
T.GetAverageItemLevel = GetAverageItemLevel
T.UnitStat = UnitStat
T.UnitIsPlayer = UnitIsPlayer
T.UnitInRaid = UnitInRaid
T.UnitInParty = UnitInParty
T.UnitPVPName = UnitPVPName
T.UnitIsAFK = UnitIsAFK
T.UnitExists = UnitExists
T.UnitIsConnected = UnitIsConnected
T.UnitIsUnit = UnitIsUnit
T.UnitGUID = UnitGUID
T.UnitCanAttack = UnitCanAttack
T.UnitDetailedThreatSituation = UnitDetailedThreatSituation
T.GetThreatStatusColor = GetThreatStatusColor
T.CanInspect = CanInspect
T.GetStatistic = GetStatistic
T.GetComparisonStatistic = GetComparisonStatistic
T.GetAchievementInfo = GetAchievementInfo
T.UnitHonor = UnitHonor
T.UnitHonorMax = UnitHonorMax
T.UnitHonorLevel = UnitHonorLevel
T.GetMaxPlayerHonorLevel = GetMaxPlayerHonorLevel
--Class
T.GetNumClasses = GetNumClasses
T.GetClassInfo = GetClassInfo
-- T.
--Items
T.GetInventoryItemLink = GetInventoryItemLink
T.GetInventorySlotInfo = GetInventorySlotInfo
T.GetInventoryItemDurability = GetInventoryItemDurability
T.GetInventoryItemQuality = GetInventoryItemQuality
T.GetItemInfo = GetItemInfo
T.GetItemIcon = GetItemIcon
T.GetItemCooldown = GetItemCooldown
T.GetItemCount = GetItemCount
T.IsEquippableItem = IsEquippableItem
T.GetItemQualityColor = GetItemQualityColor
T.GetInventoryItemID = GetInventoryItemID
-- T.
--XP
T.IsXPUserDisabled = IsXPUserDisabled
T.GetMaxPlayerLevel = GetMaxPlayerLevel
T.GetXPExhaustion = GetXPExhaustion
--rep
T.GetWatchedFactionInfo = GetWatchedFactionInfo
T.GetNumFactions = GetNumFactions
T.IsFactionInactive = IsFactionInactive
T.SetWatchedFactionIndex = SetWatchedFactionIndex
--Social
T.IsInGuild = IsInGuild
T.GuildRoster = GuildRoster
T.GetGuildInfo = GetGuildInfo
T.GetNumGuildMembers = GetNumGuildMembers
T.GetGuildRosterInfo = GetGuildRosterInfo
T.GetGuildRosterMOTD = GetGuildRosterMOTD
T.CanEditOfficerNote = CanEditOfficerNote
T.CanEditPublicNote = CanEditPublicNote
T.InviteUnit = InviteUnit
--Professions
T.GetProfessions = GetProfessions
T.GetProfessionInfo = GetProfessionInfo
T.GetTradeSkillNumReagents = GetTradeSkillNumReagents
T.GetTradeSkillReagentInfo = GetTradeSkillReagentInfo
--Screen stuff
T.GetScreenWidth = GetScreenWidth
T.GetScreenHeight = GetScreenHeight
T.GetMouseFocus = GetMouseFocus
--Spells
T.GetSpellCooldown = GetSpellCooldown
T.GetSpellInfo = GetSpellInfo
T.IsSpellKnown = IsSpellKnown
T.GetSpellBookItemInfo = GetSpellBookItemInfo
--Tables
T.pairs = pairs
T.ipairs = ipairs
T.tinsert = tinsert
T.tremove = tremove
T.tcopy = table.copy
T.twipe = table.wipe
T.unpack = unpack
T.select = select
T.sort = sort
--Camera
T.FlipCameraYaw = FlipCameraYaw
--Instance
T.IsInInstance = IsInInstance
T.GetLFGDungeonEncounterInfo = GetLFGDungeonEncounterInfo
T.GetInstanceInfo = GetInstanceInfo
--Combat
T.InCombatLockdown = InCombatLockdown
--PvP
T.GetNumWorldPVPAreas = GetNumWorldPVPAreas
T.GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
T.GetNumBattlefieldScores = GetNumBattlefieldScores
T.GetBattlefieldScore = GetBattlefieldScore
T.CanPrestige = CanPrestige
--Map
T.GetZoneText = GetZoneText
T.GetRealZoneText = GetRealZoneText
T.GetMinimapZoneText = GetMinimapZoneText
T.GetMapNameByID = GetMapNameByID
T.GetSubZoneText = GetSubZoneText
T.GetPlayerMapPosition = GetPlayerMapPosition
T.GetZonePVPInfo = GetZonePVPInfo
--Currency
T.GetCurrencyListSize = GetCurrencyListSize
T.GetCurrencyInfo = GetCurrencyInfo

T.error = error
T.type = type
T.GetInboxHeaderInfo = GetInboxHeaderInfo
--Addons
T.IsAddOnLoaded = IsAddOnLoaded
T.DisableAddOn = DisableAddOn

T.GetQuestDifficultyColor = GetQuestDifficultyColor

--Strings
T.split = string.split
T.join = string.join
T.match = string.match
T.strlen = string.len
T.gsub = gsub
T.find = string.find
T.print = print
T.upper = string.upper
T.StringToUpper = function(str)
	return (T.gsub(str, "^%l", T.upper))
end
--Math
T.floor = floor
T.tonumber = tonumber
--Groups
T.IsInGroup = IsInGroup
T.IsInRaid = IsInRaid
T.IsPartyLFG = IsPartyLFG
T.GetNumSubgroupMembers = GetNumSubgroupMembers
T.GetNumGroupMembers = GetNumGroupMembers
T.UnitGroupRolesAssigned = UnitGroupRolesAssigned
T.GetRaidRosterInfo = GetRaidRosterInfo
--Friend
T.BNGetNumFriends = BNGetNumFriends
T.BNGetFriendInfo = BNGetFriendInfo
T.BNGetGameAccountInfo = BNGetGameAccountInfo --6.2.4
T.BNGetFriendIndex = BNGetFriendIndex
T.GetFriendInfo = GetFriendInfo
T.GetNumFriends = GetNumFriends
--Equip
T.UseEquipmentSet = UseEquipmentSet
T.GetEquipmentSetInfo = GetEquipmentSetInfo
T.GetNumEquipmentSets = GetNumEquipmentSets
T.GetEquipmentSetLocations = GetEquipmentSetLocations
--Quests
T.GetQuestLogTitle = GetQuestLogTitle
T.GetNumQuestLogEntries = GetNumQuestLogEntries
--Loot
T.GetNumLootItems = GetNumLootItems
T.GetLootSlotInfo = GetLootSlotInfo
T.GetLootSlotType = GetLootSlotType
T.GetLootSlotLink = GetLootSlotLink
T.GetLootRollItemInfo = GetLootRollItemInfo
T.GetLootRollItemLink = GetLootRollItemLink
--Factions
T.GetFactionInfo = GetFactionInfo
T.GetFriendshipReputation = GetFriendshipReputation
T.GetFriendshipReputationRanks = GetFriendshipReputationRanks
--Bags
T.GetContainerNumSlots = GetContainerNumSlots
T.GetContainerItemID = GetContainerItemID
T.GetContainerItemInfo = GetContainerItemInfo
T.GetContainerItemLink = GetContainerItemLink

T.GetTradeTargetItemLink = GetTradeTargetItemLink

T.GetSpell = function(id)
	local name = T.GetSpellInfo(id)
	return name
end

--Some of Simpy's herecy bullshit
T.rgsub = function(pattern,...)
	local z =  T.select('#',...)
	local x = T.floor(z/2)
	local s;
	for i = 1,x do
		z = T.select(i,...)
		if T.match(pattern,z) then
			s = T.select(i+x,...)
			pattern = T.gsub(pattern,z,s)
		end 
	end 
	return pattern 
end

T.SafeHookScript = function (frame, handlername, newscript)
	local oldValue = frame:GetScript(handlername);
	frame:SetScript(handlername, newscript);
	return oldValue;
end

--Search in a table like {"arg1", "arg2", "arg3"}
function SLE:SimpleTable(table, item)
	for i = 1, #table do
		if table[i] == item then  
			return true 
		end
	end

	return false
end
--Search in a table like {["stuff"] = {}, ["stuff2"] = {} }
function SLE:ValueTable(table, item)
	for i, _ in T.pairs(table) do
		if i == item then return true end
	end

	return false
end

function SLE:GetIconFromID(type, id)
	local path
	if type == "item" then
		path = T.select(10, T.GetItemInfo(id))
	elseif type == "spell" then
		path = T.select(3, T.GetSpellInfo(id))
	elseif type == "achiev" then
		path = T.select(10, T.GetAchievementInfo(id))
	end
	return path or nil
end

--For searching stuff in bags
function SLE:BagSearch(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, T.GetContainerNumSlots(container) do
			if itemId == T.GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

--Additional tutorials if any
function SLE:AddTutorials()
end

--S&L print
function SLE:Print(msg)
	T.print(E["media"].hexvaluecolor..'S&L:|r', msg)
end

function SLE:ErrorPrint(msg)
	T.print("|cffFF0000S&L Error:|r", msg)
end

--A function to ensure any files which set movers will be recognised as text by git.
function SLE:SetMoverPosition(mover, anchor, parent, point, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(anchor, parent, point, x, y)
	E:SaveMoverPosition(mover)
end

--Function for generating a text when ElvUI version is way outdated
function SLE:MismatchText()
	local text = T.format(L["MSG_SLE_ELV_OUTDATED"],SLE.elvV,SLE.elvR)
	return text
end

--For when we dramatically change some options
function SLE:FixDatabase()
end

--When we need to get mutiple modules in a file
function SLE:GetElvModules(...)
	local returns = {}
	local num = T.select("#", ...) --Getting the number of modules passed
	for i = 1, num do
		local name = T.select(i, ...)
		if T.type(name) == "string" then --Checking if *cough* someone send not string as a module name
			local mod = E:GetModule(name)
			T.tinsert(returns, #(returns)+1, mod);
		else
			T.error([[Usage: SLE:GetElvModules(): expected a string as a module name got a ]]..T.type(name), 2)
		end
	end
	return T.unpack(returns) --Returning modules back
end

function SLE:GetModules(...)
	local returns = {}
	local num = T.select("#", ...)
	for i = 1, num do
		local name = T.select(i, ...)
		if T.type(name) == "string" then
			local mod = SLE:GetModule(name)
			T.tinsert(returns, #(returns)+1, mod);
		else
			T.error([[Usage: SLE:GetModules(): expected a string as a module name got a ]]..T.type(name), 2)
		end
	end
	return T.unpack(returns)
end

--Trying to determine the region player is in, not entirely reliable cause based on a client not an actual region id
local GetCurrentRegion = GetCurrentRegion
function SLE:GetRegion()
	local rid = GetCurrentRegion()
	local region = {
		[1] = "US",
		[2] = "KR",
		[3] = "EU",
		[4] = "TW",
		[5] = "CN",
	}
	SLE.region = region[rid]
	if not SLE.region then 
		SLE.region = T.format("An error happened. Your region is unknown. Realm: %s. RID: %s. Please report your realm name and the region you are playing in to |cff1784d1Shadow & Light|r authors.", E.myrealm, rid)
		SLE:Print(SLE.region)
		SLE.region = ""
	end
end

--Registering and loading modules
SLE["RegisteredModules"] = {}
function SLE:RegisterModule(name)
	if self.initialized then
		self:GetModule(name):Initialize()
	else
		self["RegisteredModules"][#self["RegisteredModules"] + 1] = name
	end
end

local GetCVarBool = GetCVarBool
local pcall = pcall
local ScriptErrorsFrame_OnError = ScriptErrorsFrame_OnError
function SLE:InitializeModules()
	for _, module in T.pairs(SLE["RegisteredModules"]) do
		local module = self:GetModule(module)
		if module.Initialize then
			local _, catch = pcall(module.Initialize, module)

			if catch and GetCVarBool('scriptErrors') == true then
				ScriptErrorsFrame_OnError(catch, false)
			end
		end
	end
end

--[[
Updating alongside with ElvUI. SLE:UpdateAll() is hooked to E:UpdateAll()
Modules are supposed to provide a function(s) to call when profile change happens (or global update is called).
Provided functions should be named Module:ForUpdateAll() or otherwise stored in SLE.UpdateFunctions table (when there is no need of reassigning settings table.
Each modules insert their functions in respective files.
]]
local collectgarbage = collectgarbage
SLE.UpdateFunctions = {}
function SLE:UpdateAll()
	if not SLE.initialized then return end

	for _, name in T.pairs(SLE["RegisteredModules"]) do
		local module = SLE:GetModule(name)
		if module.ForUpdateAll then
			module:ForUpdateAll()
		else
			if SLE.UpdateFunctions[name] then
				SLE.UpdateFunctions[name]()
			end
		end
	end

	if not SLE._Compatibility["oRA3"] then SLE:GetModule("BlizzRaid"):CreateAndUpdateIcons() end

	SLE:SetCompareItems()

	collectgarbage('collect');
end

--New API
local function LevelUpBG(frame, topcolor, bottomcolor)
	frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
	frame.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.bg:SetPoint('CENTER')
	frame.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	frame.bg:SetVertexColor(1, 1, 1, 0.7)

	frame.lineTop = frame:CreateTexture(nil, 'BACKGROUND')
	frame.lineTop:SetDrawLayer('BACKGROUND', 2)
	frame.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.lineTop:SetPoint("TOP", frame.bg)
	frame.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	frame.lineTop:Size(frame:GetWidth(), 7)

	frame.lineBottom = frame:CreateTexture(nil, 'BACKGROUND')
	frame.lineBottom:SetDrawLayer('BACKGROUND', 2)
	frame.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.lineBottom:SetPoint("BOTTOM", frame.bg)
	frame.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	frame.lineBottom:Size(frame:GetWidth(), 7)

	local ColorCode = {
		["red"] = {1, 0, 0},
		["green"] = {0, 1, 0},
		["blue"] = {0.15, 0.3, 1},
		
	}
	if topcolor then
		if T.type(topcolor) == "table" then
			frame.lineTop:SetVertexColor(T.unpack(topcolor), 1)
		elseif T.type(topcolor) == "string" then
			if ColorCode[topcolor] then
				local r, g, b = T.unpack(ColorCode[topcolor])
				frame.lineTop:SetVertexColor(r, g, b, 1)
			else
				T.error(T.format("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, |cffFF0000topcolor|r, bottomcolor). |cffFFFF00\"%s\"|r is not a supported color.", topcolor))
				return
			end
		else
			T.error("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, |cffFF0000topcolor|r, bottomcolor).")
			return
		end
	end
	if bottomcolor then
		if T.type(bottomcolor) == "table" then
			frame.lineBottom:SetVertexColor(T.unpack(bottomcolor), 1)
		elseif T.type(bottomcolor) == "string" then
			if ColorCode[bottomcolor] then
				local r, g, b = T.unpack(ColorCode[bottomcolor])
				frame.lineBottom:SetVertexColor(r, g, b, 1)
			else
				T.error(T.format("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, [topcolor, |cffFF0000bottomcolor|r). |cffFFFF00\"%s\"|r is not a supported color.", topcolor))
				return
			end
		else
			T.error("Invalid color setting in |cff00FFFFLevelUpBG|r(frame, [topcolor, |cffFF0000bottomcolor|r).")
			return
		end
	end
end

--Add API
local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.LevelUpBG then mt.LevelUpBG = LevelUpBG end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end