local SLE, T, E = unpack(select(2, ...))
local DB = SLE:GetModule('DataBars')
local EDB = E:GetModule('DataBars')

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

local function ReputationBar_Update()
	if not SLE.initialized or not E.db.sle.databars.reputation.longtext then return end

	local bar = EDB.StatusBars.Reputation
	local ID
	local isFriend, friendText, standingLabel
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();

	if name then
		local text = ''
		local textFormat = E.db.databars.reputation.textFormat
		local color = FACTION_BAR_COLORS[reaction] or backupColor
		local maxMinDiff = max - min
		if (maxMinDiff == 0) then maxMinDiff = 1 end

		bar:SetMinMaxValues(min, max)
		bar:SetValue(value)
		bar:SetStatusBarColor(color.r, color.g, color.b)

		for i=1, numFactions do
			local factionName, _, standingID,_,_,_,_,_,_,_,_,_,_, factionID = GetFactionInfo(i);
			local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
			if factionName == name then
				if friendID ~= nil then
					isFriend = true
					friendText = friendTextLevel
				else
					ID = standingID
				end
			end
		end

		if ID then
			standingLabel = _G['FACTION_STANDING_LABEL'..ID]
		else
			standingLabel = FactionStandingLabelUnknown
		end

		if textFormat == 'PERCENT' then
			text = format('%s: %d%% [%s]', name, ((value - min) / (maxMinDiff) * 100), isFriend and friendText or standingLabel)
		elseif textFormat == 'CURMAX' then
			text = format('%s: %s - %s [%s]', name, (value - min), (maxMinDiff), isFriend and friendText or standingLabel)
		elseif textFormat == 'CURPERC' then
			text = format('%s: %s - %d%% [%s]', name, (value - min), ((value - min) / (maxMinDiff) * 100), isFriend and friendText or standingLabel)
		elseif textFormat == 'CUR' then
			text = format('%s: %s [%s]', name, (value - min), isFriend and friendText or standingLabel)
		elseif textFormat == 'REM' then
			text = format('%s: %s [%s]', name, ((maxMinDiff) - (value-min)), isFriend and friendText or standingLabel)
		elseif textFormat == 'CURREM' then
			text = format('%s: %s - %s [%s]', name, (value - min), ((maxMinDiff) - (value-min)), isFriend and friendText or standingLabel)
		elseif textFormat == 'CURPERCREM' then
			text = format('%s: %s - %d%% (%s) [%s]', name, (value - min), ((value - min) / (maxMinDiff) * 100), ((maxMinDiff) - (value-min)), isFriend and friendText or standingLabel)
		end

		bar.text:SetText(text)
	end
end

function DB:PopulateRepPatterns()
	local symbols = {'%.$','%(','%)','|3%-7%%%(%%s%%%)','%%s([^%%])','%+','%%d','%%.1f','%%.','%%(','%%)','(.-)','(.-)%1','%%+','(%%d-)','(%%d-)'}
	local pattern
	pattern = T.rgsub(FACTION_STANDING_INCREASED, unpack(symbols));
	tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_INCREASED_ACH_BONUS, unpack(symbols));
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
	DB.factions = GetNumFactions();
	for i = 1, DB.factions do
		local name, _, standingID, _, _, barValue, _, _, isHeader, _, hasRep, _, _, factionID = GetFactionInfo(i)

		if (not isHeader or hasRep) and name then
			DB.factionVars[name] = DB.factionVars[name] or {}
			DB.factionVars[name].Standing = standingID
			if C_Reputation_IsFactionParagon(factionID) then
				local currentValue = C_Reputation_GetFactionParagonInfo(factionID);
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
				local currentValue = C_Reputation_GetFactionParagonInfo(factionID);
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
