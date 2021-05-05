local SLE, T, E, L = unpack(select(2, ...))
local DB = SLE.DataBars
local EDB = E.DataBars

--GLOBALS: hooksecurefunc
local _G = _G
local format, ipairs = format, ipairs
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local GetWatchedFactionInfo, GetFactionInfo, GetFriendshipReputation, GetNumFactions = GetWatchedFactionInfo, GetFactionInfo, GetFriendshipReputation, GetNumFactions

local FACTION_STANDING_INCREASED = FACTION_STANDING_INCREASED
local FACTION_STANDING_INCREASED_GENERIC = FACTION_STANDING_INCREASED_GENERIC
local FACTION_STANDING_INCREASED_BONUS = FACTION_STANDING_INCREASED_BONUS
local FACTION_STANDING_INCREASED_DOUBLE_BONUS = FACTION_STANDING_INCREASED_DOUBLE_BONUS
local FACTION_STANDING_INCREASED_ACH_BONUS = FACTION_STANDING_INCREASED_ACH_BONUS
local FACTION_STANDING_DECREASED = FACTION_STANDING_DECREASED
local FACTION_STANDING_DECREASED_GENERIC = FACTION_STANDING_DECREASED_GENERIC
local FactionStandingLabelUnknown = UNKNOWN
local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local backupColor = FACTION_BAR_COLORS[1]
local a, b, c, d = '([%(%)%.%%%+%-%*%?%[%^%$])', '%%%1', '%%%%[ds]', '(.-)'
local formatFactionStanding = function(str) return str:gsub(a, b):gsub(c, d) end
local strMatchCombat = {}

DB.RepChatFrames = {}
DB.RepIncreaseStrings = {}
DB.RepDecreaseStrings = {}
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

	local displayString, textFormat, label = '', EDB.db.reputation.textFormat
	local name, reaction, minValue, maxValue, curValue, factionID = GetWatchedFactionInfo()
	local friendshipID, _, _, _, _, _, standingText, _, nextThreshold = GetFriendshipReputation(factionID)

	if friendshipID then
		reaction, label = 5, standingText

		if not nextThreshold then
			minValue, maxValue, curValue = 0, 1, 1
		end
	elseif C_Reputation_IsFactionParagon(factionID) then
		local current, threshold
		current, threshold = C_Reputation_GetFactionParagonInfo(factionID)

		if current and threshold then
			label, minValue, maxValue, curValue, reaction = L["Paragon"], 0, threshold, current % threshold, 9
		end
	end

	if not label then label = _G['FACTION_STANDING_LABEL'..reaction] or UNKNOWN end

	bar:SetMinMaxValues(minValue, maxValue)
	bar:SetValue(curValue)

	local current, maximum, percent, capped = GetValues(curValue, minValue, maxValue)

	if textFormat == 'PERCENT' then
		displayString = format('%s: %d%% [%s]', name, percent, label)
	elseif textFormat == 'CURMAX' then
		displayString = format('%s: %s - %s [%s]', name, current, maximum, label)
	elseif textFormat == 'CURPERC' then
		displayString = format('%s: %s - %d%% [%s]', name, current, percent, label)
	elseif textFormat == 'CUR' then
		displayString = format('%s: %s [%s]', name, current, label)
	elseif textFormat == 'REM' then
		displayString = format('%s: %s [%s]', name, maximum - current, label)
	elseif textFormat == 'CURREM' then
		displayString = format('%s: %s - %s [%s]', name, current, maximum - current, label)
	elseif textFormat == 'CURPERCREM' then
		displayString = format('%s: %s - %d%% (%s) [%s]', name, current, percent, (maximum - current), label)
	end

	bar.text:SetText(displayString)
end

function DB:PopulateRepPatterns()
	local symbols = {'%.$','%(','%)','|3%-7%%%(%%s%%%)','%%s([^%%])','%+','%%d','%%.1f','%%.','%%(','%%)','(.-)','(.-)%1','%%+','(%%d-)','(%%d-)'}
	local pattern
	pattern = T.rgsub(FACTION_STANDING_INCREASED, unpack(symbols))
	tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_INCREASED_ACH_BONUS, unpack(symbols))
	tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED, unpack(symbols))
	tinsert(DB.RepDecreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED_GENERIC, unpack(symbols))
	tinsert(DB.RepDecreaseStrings, pattern)
end

function DB:FilterReputation(_, message, ...)
	if DB.db.reputation and DB.db.reputation.chatfilter.enable then
		for i in ipairs(DB.RepIncreaseStrings) do
			local faction = strmatch(message, DB.RepIncreaseStrings[i])
			if faction then
				return true
			end
		end
		for i in ipairs(DB.RepDecreaseStrings) do
			local faction= strmatch(message, DB.RepDecreaseStrings[i])
			if faction then
				return true
			end
		end
		return false, message, ...
	end
	return false, message, ...
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

function DB:NewRepString()
	if not E.db.sle.databars.reputation or not E.db.sle.databars.reputation.chatfilter.enable then return end
	local tempfactions = GetNumFactions()
	if (tempfactions > DB.factions) then
		DB:ScanFactions()
		DB.factions = tempfactions
	end
	if E.db.sle.databars.reputation.chatfilter.chatframe == 'AUTO' then
		wipe(DB.RepChatFrames)
		for i = 1, NUM_CHAT_WINDOWS do
			if SLE:SimpleTable(_G['ChatFrame'..i]['messageTypeList'], 'COMBAT_FACTION_CHANGE') then
				tinsert(DB.RepChatFrames, 'ChatFrame'..i)
			end
		end
	end
	for factionIndex = 1, GetNumFactions() do
		local StyleTable = nil
		local name, _, _, _, _, barValue, _, _, isHeader, _, hasRep, _, _, factionID = GetFactionInfo(factionIndex)

		if (not isHeader or hasRep) and DB.factionVars[name] then
			if DB.factionVars[name].isParagon then
				local currentValue = C_Reputation_GetFactionParagonInfo(factionID)
				barValue = currentValue
			end
			local diff = barValue - DB.factionVars[name].Value

			if diff > 0 then
				StyleTable = 'RepIncreaseStyles'
			elseif diff < 0 then
				StyleTable = 'RepDecreaseStyles'
			end
			if StyleTable then
				local repMessage = format(DB[StyleTable][E.db.sle.databars.reputation.chatfilter.style] , E.db.sle.databars.reputation.chatfilter.iconsize, name, diff)
				local chatframe
				if E.db.sle.databars.reputation.chatfilter.chatframe == 'AUTO' then
					for n = 1, #(DB.RepChatFrames) do
						chatframe = _G[DB.RepChatFrames[n]]
						chatframe:AddMessage(repMessage)
					end
				else
					chatframe = _G[E.db.sle.databars.reputation.chatfilter.chatframe]
					chatframe:AddMessage(repMessage)
				end
				DB.factionVars[name].Value = barValue

				if E.db.sle.databars.reputation.chatfilter.showAll then return end
			end
		end
	end
end

function DB:RepInit()
	DB:PopulateRepPatterns()
	hooksecurefunc(EDB, 'ReputationBar_Update', ReputationBar_Update)
	EDB:ReputationBar_Update()
end
