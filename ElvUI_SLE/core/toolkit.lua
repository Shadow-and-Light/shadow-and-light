local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local _G = _G
local getmetatable = getmetatable
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

--This shit should be in Alphabetical Order to make it easier to see what is here or not... DARTH!
T.GetBuildInfo = GetBuildInfo
T.GetTalentLink = GetTalentLink
T.GetPlayerInfoByGUID = GetPlayerInfoByGUID
T.GetCursorPosition = GetCursorPosition
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
T.UnitEffectiveLevel = UnitEffectiveLevel
T.UnitClass = UnitClass
T.UnitRace = UnitRace
T.UnitName = UnitName
T.UnitInVehicle = UnitInVehicle
T.UnitFullName = UnitFullName
T.GetUnitName = GetUnitName
T.UnitFactionGroup = UnitFactionGroup
T.UnitAura = UnitAura
T.UnitBuff = UnitBuff
T.UnitDebuff = UnitDebuff
T.GetSpecialization = GetSpecialization
T.GetSpecializationInfo = GetSpecializationInfo
T.GetSpecializationInfoByID = GetSpecializationInfoByID
T.GetSpecializationRole = GetSpecializationRole
T.GetTalentInfo = GetTalentInfo
T.GetTalentInfoByID = GetTalentInfoByID
T.GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
T.GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
T.GetSpecialization = GetSpecialization
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
T.UnitIsVisible = UnitIsVisible
T.UnitIsDeadOrGhost = UnitIsDeadOrGhost
T.HasInspectHonorData = HasInspectHonorData
T.GetInspectSpecialization = GetInspectSpecialization
T.SetSmallGuildTabardTextures = SetSmallGuildTabardTextures
T.GetInventoryItemTexture = GetInventoryItemTexture
--Class
T.GetNumClasses = GetNumClasses
T.GetClassInfo = GetClassInfo
-- T.
--Items
T.IsUsableItem = IsUsableItem
T.GetInventoryItemLink = GetInventoryItemLink
T.GetInventorySlotInfo = GetInventorySlotInfo
T.GetInventoryItemDurability = GetInventoryItemDurability
T.GetInventoryItemQuality = GetInventoryItemQuality
T.GetItemInfo = GetItemInfo
T.GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
T.GetBuybackItemLink = GetBuybackItemLink
T.GetItemIcon = GetItemIcon
T.GetItemCooldown = GetItemCooldown
T.GetItemCount = GetItemCount
T.IsEquippableItem = IsEquippableItem
T.GetItemQualityColor = GetItemQualityColor
T.GetInventoryItemID = GetInventoryItemID
T.SetItemRef = SetItemRef
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
T.GuildInfoGuildRoster = C_GuildInfo.GuildRoster
T.GetNumGuildMembers = GetNumGuildMembers
T.GetGuildRosterInfo = GetGuildRosterInfo
T.GetGuildRosterMOTD = GetGuildRosterMOTD
T.GetGuildLogoInfo = GetGuildLogoInfo
T.GetInspectGuildInfo = GetInspectGuildInfo
T.CanEditOfficerNote = CanEditOfficerNote
T.CanEditPublicNote = CanEditPublicNote
T.SetGuildRosterSelection = SetGuildRosterSelection
T.InviteUnit = InviteUnit
T.ToggleGuildFrame = ToggleGuildFrame
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
T.sort = table.sort
T.tconcat = table.concat
T.next = next
T.wipe = wipe
T.tContains = tContains
--Camera
T.FlipCameraYaw = FlipCameraYaw
--Instance
T.IsInInstance = IsInInstance
T.GetLFGDungeonNumEncounters = GetLFGDungeonNumEncounters
T.GetLFGDungeonEncounterInfo = GetLFGDungeonEncounterInfo
T.GetInstanceInfo = GetInstanceInfo
T.IsLFGDungeonJoinable = IsLFGDungeonJoinable
--Combat
T.InCombatLockdown = InCombatLockdown
--PvP
T.GetNumWorldPVPAreas = GetNumWorldPVPAreas
T.GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
T.GetNumBattlefieldScores = GetNumBattlefieldScores
T.GetBattlefieldScore = GetBattlefieldScore
T.GetPVPLifetimeStats = GetPVPLifetimeStats
T.GetPersonalRatedInfo = GetPersonalRatedInfo
T.GetInspectArenaData = GetInspectArenaData
T.GetInspectRatedBGData = GetInspectRatedBGData
T.GetInspectHonorData = GetInspectHonorData
--Map
T.GetZoneText = GetZoneText
T.GetRealZoneText = GetRealZoneText
T.GetMinimapZoneText = GetMinimapZoneText
T.GetMapNameByID = C_Map.GetMapInfo
T.GetCurrentMapAreaID = C_Map.GetCurrentMapAreaID
T.GetSubZoneText = GetSubZoneText
T.GetBestMapForUnit = C_Map.GetBestMapForUnit
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
T.SendAddonMessage = SendAddonMessage

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
T.lower = string.lower
T.StringToUpper = function(str)
	return (T.gsub(str, "^%l", T.upper))
end
T.strfind = strfind
T.strjoin = strjoin
T.strsplit = strsplit
--Math
T.floor = floor
T.tonumber = tonumber
T.tostring = tostring
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
T.BNGetFriendGameAccountInfo = BNGetFriendGameAccountInfo --8.2.5
T.BNGetFriendIndex = BNGetFriendIndex
T.BNet_GetValidatedCharacterName = BNet_GetValidatedCharacterName
T.GetFriendInfo = GetFriendInfo
T.GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
T.GetNumFriends = C_FriendList.GetNumFriends
T.GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends
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
function SLE:Print(msg, type)
	if type == "error" then
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin("", "|cffff0000S&L Error:|r ", msg))
	elseif type == "warning" then
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin("", "|cffd3cf00S&L Warning:|r ", msg))
	elseif type == "info" then
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin("", "|cff14adcdS&L Info:|r ", msg))
	else
		(_G[E.db.general.messageRedirect] or DEFAULT_CHAT_FRAME):AddMessage(strjoin("", E["media"].hexvaluecolor, "S&L Message:|r ", msg))
	end
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

--To get stuff from item link. Got this from suspctz
function SLE:GetItemSplit(itemLink)
	local itemString = T.match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}

	-- Split data into a table
	for _, v in T.ipairs({T.split(":", itemString)}) do
	if v == "" then
		itemSplit[#itemSplit + 1] = 0
	else
		itemSplit[#itemSplit + 1] = T.tonumber(v)
	end
	end

	return itemSplit
end

--Reseting shit
function SLE:Reset(group)
	if not group then print("U wot m8?") end
	if group == "unitframes" or group == "all" then
		E.db.sle.roleicons = "ElvUI"
		E.db.sle.powtext = false
	end
	if group == "backgrounds" or group == "all" then
		E:CopyTable(E.db.sle.backgrounds, P.sle.backgrounds)
		E:ResetMovers(L["SLE_BG_1_Mover"])
		E:ResetMovers(L["SLE_BG_2_Mover"])
		E:ResetMovers(L["SLE_BG_3_Mover"])
		E:ResetMovers(L["SLE_BG_4_Mover"])
	end
	if group == "datatexts" or group == "all" then
		E:CopyTable(E.db.sle.datatexts, P.sle.datatexts)
		E:CopyTable(E.db.sle.dt, P.sle.dt)
		E:ResetMovers(L["SLE_DataPanel_1"])
		E:ResetMovers(L["SLE_DataPanel_2"])
		E:ResetMovers(L["SLE_DataPanel_3"])
		E:ResetMovers(L["SLE_DataPanel_4"])
		E:ResetMovers(L["SLE_DataPanel_5"])
		E:ResetMovers(L["SLE_DataPanel_6"])
		E:ResetMovers(L["SLE_DataPanel_7"])
		E:ResetMovers(L["SLE_DataPanel_8"])
	end
	if group == "marks" or group == "all" then
		E:CopyTable(E.db.sle.raidmarkers, P.sle.raidmarkers)
		E:ResetMovers(L['Raid Marker Bar'])
	end
	if group == "all" then
		E:CopyTable(E.db.sle, P.sle)
		E:ResetMovers("PvP")
		E:ResetMovers(L["S&L UI Buttons"])
		E:ResetMovers(L["Error Frame"])
		E:ResetMovers(L["Pet Battle Status"])
		E:ResetMovers(L["Pet Battle AB"])
		E:ResetMovers(L["Farm Seed Bars"])
		E:ResetMovers(L["Farm Tool Bar"])
		E:ResetMovers(L["Farm Portal Bar"])
		E:ResetMovers(L["Garrison Tools Bar"])
		E:ResetMovers(L["Ghost Frame"])
		E:ResetMovers(L["Raid Utility"])
	end
	E:UpdateAll()
end

function SLE:GetMapInfo(id, arg)
	if not arg then return end
	local MapInfo
	if T.MapInfoTable[id] then
		MapInfo = T.MapInfoTable[id]
	else
		MapInfo = C_Map.GetMapInfo(id)
		T.MapInfoTable[id] = MapInfo
	end
	if not MapInfo then return UNKNOWN end
	if arg == "all" then return MapInfo["name"], MapInfo["mapID"], MapInfo["parentMapID"], MapInfo["mapType"] end
	return MapInfo[arg]
end

--Some texture magic. Thanks Semlar for this
SLE.TestTextureFrame = CreateFrame("Frame")
SLE.TestTextureFrame.texture = SLE.TestTextureFrame:CreateTexture()

function SLE:TextureExists(path, realTerxture, fallbackPath, holderFrame, modTestFrame, modTestTexture)
	if not path or path == "" then return end
	if not realTerxture or realTerxture == "" then return end
	local f = holderFrame or modTestFrame or SLE.TestTextureFrame
	local tx = modTestTexture or SLE.TestTextureFrame.texture
	tx.realTexture = realTerxture
	tx:SetPoint("BOTTOMRIGHT", E.UIParent, "TOPRIGHT") -- The texture has to be "visible", but not necessarily on-screen (you can also set its alpha to 0)
	f:SetAllPoints(tx)

	f:SetScript("OnSizeChanged", function(self, width, height)
			 local size = format("%.0f%.0f", width, height) -- The floating point numbers need to be rounded or checked like "width < 8.1 and width > 7.9"
			 if size == "11"  then
				-- print(tx:GetTexture(), "doesn't exist or can't be determined")
				tx.realTexture:SetTexture(fallbackPath or "")
				-- print(tx.realTexture:GetTexture())
			 -- else
				-- print(tx:GetTexture(), "exists")
			 end
	end)
	tx:SetTexture(path)
	tx:SetSize(0,0) -- Size must be set after every SetTexture
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
function SLE:GetRegion()
	local lib = LibStub("LibRealmInfo")
	if not GetPlayerInfoByGUID(E.myguid) then return end
	local rid, _, _, _, _, _, region = lib:GetRealmInfoByGUID(E.myguid)
	SLE.region = region
	if not SLE.region then
		if not IsTestBuild() then
			SLE.region = T.format("An error happened. Your region is unknown. Realm: %s. RID: %s. Please report your realm name and the region you are playing in to |cff1784d1Shadow & Light|r authors.", E.myrealm, rid or "nil")
			SLE:Print(SLE.region)
		end
		SLE.region = "PTR"
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
				if E.wowbuild < 24330 then --7.2
					ScriptErrorsFrame_OnError(catch, false)
				end
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

--Movable buttons in config stuff. Some Simpy's billshit applied
local function MovableButton_Match(s,v)
	local m1, m2, m3, m4 = "^"..v.."$", "^"..v..",", ","..v.."$", ","..v..","
	return (T.match(s, m1) and m1) or (T.match(s, m2) and m2) or (T.match(s, m3) and m3) or (T.match(s, m4) and v..",")
end
function SLE:MovableButtonSettings(db, key, value, remove, movehere)
	local str = db[key]
	if not db or not str or not value then return end
	local found = MovableButton_Match(str, E:EscapeString(value))
	if found and movehere then
		local tbl, sv, sm = {T.split(",", str)}
		for i in T.ipairs(tbl) do
			if tbl[i] == value then sv = i elseif tbl[i] == movehere then sm = i end
			if sv and sm then break end
		end
		T.tremove(tbl, sm);
		T.tinsert(tbl, sv, movehere);

		db[key] = T.tconcat(tbl,',')

	elseif found and remove then
		db[key] = T.gsub(str, found, "")
	elseif not found and not remove then
		db[key] = (str == '' and value) or (str..","..value)
	end
end

function SLE:CreateMovableButtons(Order, Name, CanRemove, db, key)
	local moveItemFrom, moveItemTo
	local config = {
		order = Order,
		dragdrop = true,
		type = "multiselect",
		name = Name,
		dragOnLeave = function() end, --keep this here
		dragOnEnter = function(info)
			moveItemTo = info.obj.value
		end,
		dragOnMouseDown = function(info)
			moveItemFrom, moveItemTo = info.obj.value, nil
		end,
		dragOnMouseUp = function(info)
			SLE:MovableButtonSettings(db, key, moveItemTo, nil, moveItemFrom) --add it in the new spot
			moveItemFrom, moveItemTo = nil, nil
		end,
		stateSwitchGetText = function(info, TEXT)
			local text = T.GetItemInfo(T.tonumber(TEXT))
			info.userdata.text = text
			return text
		end,
		stateSwitchOnClick = function(info)
			SLE:MovableButtonSettings(db, key, moveItemFrom)
		end,
		values = function()
			local str = db[key]
			if str == "" then return nil end
			return {T.split(",",str)}
		end,
		get = function(info, value)
			local str = db[key]
			if str == "" then return nil end
			local tbl = {T.split(",",str)}
			return tbl[value]
		end,
		set = function(info, value) end,
	}
	if CanRemove then --This allows to remove shit
		config.dragOnClick = function(info)
			SLE:MovableButtonSettings(db, key, moveItemFrom, true)
		end
	end
	return config
end

--New API
local function LevelUpBG(frame, topcolor, bottomcolor)
	if not frame then return end
	frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
	frame.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	frame.bg:SetPoint('CENTER')
	frame.bg:Point("TOPLEFT", frame, 0, 8)
	frame.bg:Point("BOTTOMRIGHT", frame, 0, -2)
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

--AF stuff
function SLE:IsFoolsDay()
	if T.find(date(), '04/01/') and not E.global.aprilFoolsSLE and not T.IsAddOnLoaded("ElvUI_SLE_Dev") then
		return true;
	else
		return false;
	end
end

function SLE:CreateSplashScreen()
	local f = CreateFrame('Frame', 'SLE_SplashScreen', E.UIParent)
	f:Size(400, 200)
	f:SetPoint('CENTER')
	f:SetFrameStrata('TOOLTIP')
	f:LevelUpBG()
	f:SetAlpha(0)

	f.logo = f:CreateTexture(nil, 'OVERLAY')
	f.logo:Size(240, 60)
	f.logo:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\SLE_Banner]])
	f.logo:Point('TOP', f, 'TOP', 0. -80)

	f.version = f:CreateFontString(nil, 'OVERLAY')
	f.version:FontTemplate(nil, 14, nil)
	f.version:Point('TOP', f.logo, 'BOTTOM', 0, -20)
	f.version:SetText(L["SLE_BENIK_AF"])
end

local function HideSplashScreen()
	SLE_SplashScreen:Hide()
	E:Delay(0.5, function() assert(false, L["SLE_ERRORS_AF"][random(#L["SLE_ERRORS_AF"])]) end)
	E.global.aprilFoolsSLE = true
end

local function FadeSplashScreen()
	E:Delay(10, function()
		E:UIFrameFadeOut(SLE_SplashScreen, 1, 1, 0)
		SLE_SplashScreen.fadeInfo.finishedFunc = HideSplashScreen
	end)
end

function SLE:ShowSplashScreen()
	E:UIFrameFadeIn(SLE_SplashScreen, 2, 0, 1)
	SLE_SplashScreen.fadeInfo.finishedFunc = FadeSplashScreen
end