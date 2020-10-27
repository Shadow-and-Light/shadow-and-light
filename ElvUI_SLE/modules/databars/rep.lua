local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:GetModule("DataBars")
local EDB = E:GetModule('DataBars')

--GLOBALS: hooksecurefunc
local _G = _G
local format = format
local strMatchCombat = {}
-- local guildName
local abs = math.abs
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
-- local ExpandFactionHeader, CollapseFactionHeader = ExpandFactionHeader, CollapseFactionHeader
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
-- local next = next

--strings and shit
local FACTION_STANDING_INCREASED = FACTION_STANDING_INCREASED
local FACTION_STANDING_INCREASED_GENERIC = FACTION_STANDING_INCREASED_GENERIC
local FACTION_STANDING_INCREASED_BONUS = FACTION_STANDING_INCREASED_BONUS
local FACTION_STANDING_INCREASED_DOUBLE_BONUS = FACTION_STANDING_INCREASED_DOUBLE_BONUS
local FACTION_STANDING_INCREASED_ACH_BONUS = FACTION_STANDING_INCREASED_ACH_BONUS
-- local FACTION_STANDING_CHANGED = FACTION_STANDING_CHANGED
-- local FACTION_STANDING_CHANGED_GUILD = FACTION_STANDING_CHANGED_GUILD
local FACTION_STANDING_DECREASED = FACTION_STANDING_DECREASED
local FACTION_STANDING_DECREASED_GENERIC = FACTION_STANDING_DECREASED_GENERIC

local FACTION_BAR_COLORS = FACTION_BAR_COLORS

DB.RepIncreaseStrings = {}
DB.RepDecreaseStrings = {}
DB.factionVars = {}
DB.factions = 0

DB.RepIncreaseStyles = {
	["STYLE1"] = "|T"..DB.Icons.Rep..":%s|t %s: +%s.",
	["STYLE2"] = "|T"..DB.Icons.Rep..":%s|t %s: |cff0CD809+%s|r.",
}

DB.RepDecreaseStyles = {
	["STYLE1"] = "|T"..DB.Icons.Rep..":%s|t %s: %s.",
	["STYLE2"] = "|T"..DB.Icons.Rep..":%s|t %s: |cffD80909%s|r.",
}


local a, b, c, d = "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1", "%%%%[ds]", "(.-)"
local formatFactionStanding = function(str) return str:gsub(a, b):gsub(c, d) end

tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_GENERIC)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_BONUS)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_DOUBLE_BONUS)))
tinsert(strMatchCombat, (formatFactionStanding(FACTION_STANDING_INCREASED_ACH_BONUS)))

local backupColor = FACTION_BAR_COLORS[1]
local FactionStandingLabelUnknown = UNKNOWN

local function UpdateReputation()
	if not SLE.initialized or not E.db.sle.databars.rep.longtext then return end
	-- local bar = self.ReputationBar
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
			local friendID, friendRep, friendMaxRep, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
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
			standingLabel = _G["FACTION_STANDING_LABEL"..ID]
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

function DB:FilterReputation(event, message, ...)
	local faction, rep, bonus
	if DB.db.rep and DB.db.rep.chatfilter.enable then
		for i, v in ipairs(DB.RepIncreaseStrings) do
			faction, rep, bonus = strmatch(message, DB.RepIncreaseStrings[i])
			if faction then
				return true
			end
		end
		for i, v in ipairs(DB.RepDecreaseStrings) do
			faction, rep = strmatch(message, DB.RepDecreaseStrings[i])
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

DB.RepChatFrames = {}
function DB:NewRepString(event, ...)
	if not DB.db.rep or not DB.db.rep.chatfilter.enable then return end
	local stop = false
	local tempfactions = GetNumFactions()
	if (tempfactions > DB.factions) then
		DB:ScanFactions()
		DB.factions = tempfactions
	end
	if DB.db.rep.chatfilter.chatframe == "AUTO" then
		wipe(DB.RepChatFrames)
		for i = 1, NUM_CHAT_WINDOWS do
			if SLE:SimpleTable(_G["ChatFrame"..i]["messageTypeList"], "COMBAT_FACTION_CHANGE") then
				tinsert(DB.RepChatFrames, "ChatFrame"..i)
			end
		end
	end
	for factionIndex = 1, GetNumFactions() do
		local StyleTable = nil
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID = GetFactionInfo(factionIndex)
		local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
		local currentRank, maxRank = GetFriendshipReputationRanks(factionID);

		if (not isHeader or hasRep) and DB.factionVars[name] then
			if DB.factionVars[name].isParagon then
				local currentValue = C_Reputation_GetFactionParagonInfo(factionID);
				barValue = currentValue
			end
			local diff = barValue - DB.factionVars[name].Value

			if diff > 0 then
				StyleTable = "RepIncreaseStyles"
			elseif diff < 0 then
				StyleTable = "RepDecreaseStyles"
			end
			if StyleTable then
				--  TODO:  local change doesnt do anything revisit this
				local change = abs(barValue - DB.factionVars[name].Value)

				if DB.db.rep.chatfilter.chatframe == "AUTO" then
					for n = 1, #(DB.RepChatFrames) do
						local chatframe = _G[DB.RepChatFrames[n]]
						chatframe:AddMessage(format(DB[StyleTable][DB.db.rep.chatfilter.style] , DB.db.rep.chatfilter.iconsize, name, diff))

						if not E.db.sle.databars.rep.chatfilter.showAll then
							stop = true
							break
						end
					end
				else
					local chatframe = _G[DB.db.rep.chatfilter.chatframe]
					chatframe:AddMessage(format(DB[StyleTable][DB.db.rep.chatfilter.style] , DB.db.rep.chatfilter.iconsize, name, diff))

					if not E.db.sle.databars.rep.chatfilter.showAll then
						stop = true
						break
					end
				end
				DB.factionVars[name].Value = barValue

				if stop then return end
			end
		end
	end
end

function DB:RepInit()
	DB:PopulateRepPatterns()
	hooksecurefunc(E:GetModule('DataBars'), "ReputationBar_Update", UpdateReputation)
	EDB:UpdateReputation()
end