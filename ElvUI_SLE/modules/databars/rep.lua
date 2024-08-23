local unpack = unpack
local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DB = SLE.DataBars
local EDB = E.DataBars

--GLOBALS: hooksecurefunc
local _G = _G
local format, ipairs = format, ipairs
local GetFriendshipReputation = GetFriendshipReputation or C_GossipInfo.GetFriendshipReputation
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_IsMajorFaction = C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = C_MajorFactions and C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions and C_MajorFactions.HasMaximumRenown
local GetWatchedFactionInfo = GetWatchedFactionInfo
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local GetFactionInfo, GetNumFactions = GetFactionInfo, GetNumFactions

local FACTION_STANDING_INCREASED = FACTION_STANDING_INCREASED
local FACTION_STANDING_INCREASED_GENERIC = FACTION_STANDING_INCREASED_GENERIC
local FACTION_STANDING_INCREASED_BONUS = FACTION_STANDING_INCREASED_BONUS
local FACTION_STANDING_INCREASED_DOUBLE_BONUS = FACTION_STANDING_INCREASED_DOUBLE_BONUS
local FACTION_STANDING_INCREASED_ACH_BONUS = FACTION_STANDING_INCREASED_ACH_BONUS
local FACTION_STANDING_DECREASED = FACTION_STANDING_DECREASED
local FACTION_STANDING_DECREASED_GENERIC = FACTION_STANDING_DECREASED_GENERIC

-- local FACTION_STANDING_CHANGED_ACCOUNT_WIDE = FACTION_STANDING_CHANGED_ACCOUNT_WIDE
local REPUTATION_STATUS_BAR_LABEL_ACCOUNT_WIDE = REPUTATION_STATUS_BAR_LABEL_ACCOUNT_WIDE
local FACTION_STANDING_INCREASED_ACCOUNT_WIDE = FACTION_STANDING_INCREASED_ACCOUNT_WIDE
local FACTION_STANDING_INCREASED_GENERIC_ACCOUNT_WIDE = FACTION_STANDING_INCREASED_GENERIC_ACCOUNT_WIDE
-- local FACTION_STANDING_INCREASED_BONUS = FACTION_STANDING_INCREASED_BONUS
-- local FACTION_STANDING_INCREASED_DOUBLE_BONUS = FACTION_STANDING_INCREASED_DOUBLE_BONUS
local FACTION_STANDING_INCREASED_ACH_BONUS_ACCOUNT_WIDE = FACTION_STANDING_INCREASED_ACH_BONUS_ACCOUNT_WIDE
local FACTION_STANDING_DECREASED_ACCOUNT_WIDE = FACTION_STANDING_DECREASED_ACCOUNT_WIDE
local FACTION_STANDING_DECREASED_GENERIC_ACCOUNT_WIDE = FACTION_STANDING_DECREASED_GENERIC_ACCOUNT_WIDE

local a, b, c, d = '([%(%)%.%%%+%-%*%?%[%^%$])', '%%%1', '%%%%[ds]', '(.-)'
local formatFactionStanding = function(str) return str:gsub(a, b):gsub(c, d) end
local strMatchCombat = {}

DB.RepChatFrames = {}
DB.RepIncreaseStrings = {}
DB.RepIncreaseStringsWarband = {}
DB.RepDecreaseStrings = {}
DB.RepDecreaseStringsWarband = {}
DB.factionVars = {}
DB.factions = 0
DB.RepIncreaseStyles = {
	STYLE1 = '|T'..DB.Icons.Rep..':%s|t %s: +%s.',
	STYLE2 = '|T'..DB.Icons.Rep..':%s|t %s: |cff0CD809+%s|r.',
}
DB.RepDecreaseStyles = {
	STYLE1 = '|T'..DB.Icons.Rep..':%s|t %s: %s.',
	STYLE2 = '|T'..DB.Icons.Rep..':%s|t %s: |cffD80909%s|r.',
}

tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_GENERIC)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_BONUS)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_DOUBLE_BONUS)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_ACH_BONUS)))

local function GetValues(curValue, minValue, maxValue)
	local maximum = maxValue - minValue
	local current, diff = curValue - minValue, maximum

	if diff == 0 then diff = 1 end -- prevent a division by zero

	if current == maximum then
		return 1, 1, 100, true
	else
		return current, maximum, current / diff * 100
	end
end

local function ReputationBar_Update()
	if not SLE.initialized or not E.db.sle.databars.reputation.longtext then return end
	local bar = EDB.StatusBars.Reputation
	if not bar.db.enable or bar:ShouldHide() then return end

	local data = E:GetWatchedFactionInfo()
	local name, reaction, currentReactionThreshold, nextReactionThreshold, currentStanding, factionID = data.name, data.reaction, data.currentReactionThreshold, data.nextReactionThreshold, data.currentStanding, data.factionID
	local displayString, textFormat, standing, rewardPending, _ = '', EDB.db.reputation.textFormat

	if reaction == 0 then
		reaction = 1
	end

	local info = E.Retail and factionID and GetFriendshipReputation(factionID)

	if info and info.friendshipFactionID and info.friendshipFactionID > 0 then
		standing, currentReactionThreshold, nextReactionThreshold, currentStanding = info.reaction, info.reactionThreshold or 0, info.nextThreshold or huge, info.standing or 1
	end

	if not standing and factionID and C_Reputation_IsFactionParagon(factionID) then
		local current, threshold
		current, threshold, _, rewardPending = C_Reputation_GetFactionParagonInfo(factionID)

		if current and threshold then
			standing, currentReactionThreshold, nextReactionThreshold, currentStanding, reaction = L["Paragon"], 0, threshold, current % threshold, 9
		end
	end

	if not standing and factionID and E.Retail and C_Reputation_IsMajorFaction(factionID) then
		local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
		local renownColor = EDB.db.colors.factionColors[10]
		local renownHex = E:RGBToHex(renownColor.r, renownColor.g, renownColor.b)

		reaction, currentReactionThreshold, nextReactionThreshold = 10, 0, majorFactionData.renownLevelThreshold
		currentStanding = C_MajorFactions_HasMaximumRenown(factionID) and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
		standing = format('%s%s %s|r', renownHex, RENOWN_LEVEL_LABEL, majorFactionData.renownLevel)
	end

	if not standing then
		standing = _G['FACTION_STANDING_LABEL'..reaction] or UNKNOWN
	end

	local total = nextReactionThreshold == huge and 1 or nextReactionThreshold -- we need to correct the min/max of friendship factions to display the bar at 100%

	if name then
		local current, maximum, percent, capped = GetValues(currentStanding, currentReactionThreshold, total)

		if capped and textFormat ~= 'NONE' then -- show only name and standing on exalted
			displayString = format('%s: [%s]', name, standing)
		elseif textFormat == 'PERCENT' then
			displayString = format('%s: %d%% [%s]', name, percent, standing)
		elseif textFormat == 'CURMAX' then
			displayString = format('%s: %s - %s [%s]', name, current, maximum, standing)
		elseif textFormat == 'CURPERC' then
			displayString = format('%s: %s - %d%% [%s]', name, current, percent, standing)
		elseif textFormat == 'CUR' then
			displayString = format('%s: %s [%s]', name, current, standing)
		elseif textFormat == 'REM' then
			displayString = format('%s: %s [%s]', name, maximum - current, standing)
		elseif textFormat == 'CURREM' then
			displayString = format('%s: %s - %s [%s]', name, current, maximum - current, standing)
		elseif textFormat == 'CURPERCREM' then
			displayString = format('%s: %s - %d%% (%s) [%s]', name, current, percent, maximum - current, standing)
		end
	end

	bar.text:SetText(displayString)
end

function DB:PopulateRepPatterns()
	--Simpy formatting here. Prob shouldn't touch
	local symbols = {'%.$','%%.','%(','%%(','%)','%%)','|3%-[71]%%%(%%s%%%)','(.-)','%%s([^%%])','(.-)%1','%+','%%+','%%d', '(%%d-)','%%.1f','([%%d.]-)'}
	local pattern
	--When rep increases
	pattern = T.rgsub(FACTION_STANDING_INCREASED, unpack(symbols))
	tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_INCREASED_ACH_BONUS, unpack(symbols))
	tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_INCREASED_ACCOUNT_WIDE, unpack(symbols))
	tinsert(DB.RepIncreaseStringsWarband, pattern)

	pattern = T.rgsub(FACTION_STANDING_INCREASED_ACH_BONUS_ACCOUNT_WIDE, unpack(symbols))
	tinsert(DB.RepIncreaseStringsWarband, pattern)
	--When rep decreases
	pattern = T.rgsub(FACTION_STANDING_DECREASED, unpack(symbols))
	tinsert(DB.RepDecreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED_GENERIC, unpack(symbols))
	tinsert(DB.RepDecreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED_ACCOUNT_WIDE, unpack(symbols))
	tinsert(DB.RepDecreaseStringsWarband, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED_GENERIC_ACCOUNT_WIDE, unpack(symbols))
	tinsert(DB.RepDecreaseStringsWarband, pattern)
end

local function sendMessage(chatWindowsCache, newMessage) --Sending message in chat. TODO: check if we can actually send messages in respective chats
	local db = E.db.sle.databars.reputation.chatfilter
	local chatframe

	if db.chatframe == 'AUTO' then
		for num = 1, #(chatWindowsCache) do
			chatframe = _G[chatWindowsCache[num]]
			chatframe:AddMessage(newMessage)
		end
	else
		chatframe = _G[db.chatframe]
		chatframe:AddMessage(newMessage)
	end
end

local chatWindowsCache = {}
function DB:FilterReputation(_, message, ...)
	local db = E.db.sle.databars.reputation.chatfilter
	local newMessage, faction, value

	if db.chatframe == 'AUTO' then
		wipe(chatWindowsCache)
		for i = 1, NUM_CHAT_WINDOWS do
			if SLE:SimpleTable(_G['ChatFrame'..i]['messageTypeList'], 'COMBAT_FACTION_CHANGE') then
				tinsert(chatWindowsCache, 'ChatFrame'..i)
			end
		end
	end

	if DB.db.reputation and DB.db.reputation.chatfilter.enable then
		local increase = DB['RepIncreaseStyles'][db.style.increase] or DB['RepIncreaseStyles']['STYLE1']
		local decrease = DB['RepDecreaseStyles'][db.style.decrease] or DB['RepDecreaseStyles']['STYLE1']
		--Characterr rep
		for i in ipairs(DB.RepIncreaseStrings) do
			faction, value = strmatch(message, DB.RepIncreaseStrings[i])
			if faction then
				newMessage = format(increase, db.iconsize, faction, value)
				sendMessage(chatWindowsCache, newMessage)

				return true
			end
		end

		for i in ipairs(DB.RepDecreaseStrings) do
			faction, value = strmatch(message, DB.RepDecreaseStrings[i])
			if faction then
				newMessage = format(decrease, db.iconsize, faction, value)
				sendMessage(chatWindowsCache, newMessage)

				return true
			end
		end
		--Warband rep
		for i in ipairs(DB.RepIncreaseStringsWarband) do
			faction, value = strmatch(message, DB.RepIncreaseStringsWarband[i])
			if faction then
				newMessage = format(increase, db.iconsize, REPUTATION_STATUS_BAR_LABEL_ACCOUNT_WIDE.." "..faction, value)
				sendMessage(chatWindowsCache, newMessage)

				return true
			end
		end

		for i in ipairs(DB.RepDecreaseStringsWarband) do
			faction, value = strmatch(message, DB.RepDecreaseStringsWarband[i])
			if faction then
				newMessage = format(decrease, db.iconsize, REPUTATION_STATUS_BAR_LABEL_ACCOUNT_WIDE.." "..faction, value)
				sendMessage(chatWindowsCache, newMessage)

				return true
			end
		end
	end
end

function DB:ScanFactions()
	DB.factions = GetNumFactions()
	for i = 1, DB.factions do
		local name, _, standingID, _, _, barValue, _, _, isHeader, _, hasRep, _, _, factionID = GetFactionInfo(i)

		if (not isHeader or hasRep) and name then
			DB.factionVars[name] = DB.factionVars[name] or {}
			DB.factionVars[name].Standing = standingID
			if C_Reputation_IsFactionParagon(factionID) then
				local currentValue = C_Reputation_GetFactionParagonInfo(factionID)
				DB.factionVars[name].Value = currentValue
				DB.factionVars[name].isParagon = true
			else
				DB.factionVars[name].Value = barValue
			end
		end
	end
end

function DB:RepInit()
	if type(E.db.sle.databars.reputation.chatfilter.style) ~= 'table' then E.db.sle.databars.reputation.chatfilter.style = {}; E:CopyTable(E.db.sle.databars.reputation.chatfilter.style, P.sle.databars.reputation.chatfilter.style) end
	DB:PopulateRepPatterns()
	hooksecurefunc(EDB, 'ReputationBar_Update', ReputationBar_Update)
	EDB:ReputationBar_Update()
end
