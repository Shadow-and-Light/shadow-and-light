local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:GetModule("DataBars")

local _G = _G
local strMatchCombat = {}
local guildName
local abs = math.abs
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local ExpandFactionHeader, CollapseFactionHeader = ExpandFactionHeader, CollapseFactionHeader
local next = next
local collapsed = {}

--strings and shit
local GUILD = GUILD
local FACTION_STANDING_INCREASED = FACTION_STANDING_INCREASED
local FACTION_STANDING_INCREASED_GENERIC = FACTION_STANDING_INCREASED_GENERIC
local FACTION_STANDING_INCREASED_BONUS = FACTION_STANDING_INCREASED_BONUS
local FACTION_STANDING_INCREASED_DOUBLE_BONUS = FACTION_STANDING_INCREASED_DOUBLE_BONUS
local FACTION_STANDING_INCREASED_ACH_BONUS = FACTION_STANDING_INCREASED_ACH_BONUS
local FACTION_STANDING_CHANGED = FACTION_STANDING_CHANGED
local FACTION_STANDING_CHANGED_GUILD = FACTION_STANDING_CHANGED_GUILD
local FACTION_STANDING_CHANGED_GUILDNAME = FACTION_STANDING_CHANGED_GUILDNAME
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

T.tinsert(strMatchCombat, (T.gsub(FACTION_STANDING_INCREASED,"%%%d?%$?s", "(.+)")))
T.tinsert(strMatchCombat, (T.gsub(FACTION_STANDING_INCREASED_GENERIC,"%%%d?%$?s", "(.+)")))
T.tinsert(strMatchCombat, (T.gsub(FACTION_STANDING_INCREASED_BONUS,"%%%d?%$?s", "(.+)")))
T.tinsert(strMatchCombat, (T.gsub(FACTION_STANDING_INCREASED_DOUBLE_BONUS,"%%%d?%$?s", "(.+)")))
T.tinsert(strMatchCombat, (T.gsub(FACTION_STANDING_INCREASED_ACH_BONUS,"%%%d?%$?s", "(.+)")))
local strChangeMatch = (T.gsub(FACTION_STANDING_CHANGED,"%%%d?%$?s", "(.+)"))
local strGuildChangeMatch = {}
T.tinsert(strGuildChangeMatch, (T.gsub(FACTION_STANDING_CHANGED_GUILD,"%%%d?%$?s", "(.+)")))
T.tinsert(strGuildChangeMatch, (T.gsub(FACTION_STANDING_CHANGED_GUILDNAME,"%%%d?%$?s", "(.+)")))

local backupColor = FACTION_BAR_COLORS[1]
local FactionStandingLabelUnknown = UNKNOWN
local function UpdateReputation(self, event)
	if not E.db.sle.databars.rep.longtext or not SLE.initialized then return end
	local bar = self.repBar
	local ID
	local isFriend, friendText, standingLabel
	local name, reaction, min, max, value = T.GetWatchedFactionInfo()
	local numFactions = T.GetNumFactions();

	if name then
		local text = ''
		local textFormat = E.db.databars.reputation.textFormat
		local color = FACTION_BAR_COLORS[reaction] or backupColor
		bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)

		bar.statusBar:SetMinMaxValues(min, max)
		bar.statusBar:SetValue(value)

		for i=1, numFactions do
			local factionName, _, standingID,_,_,_,_,_,_,_,_,_,_, factionID = T.GetFactionInfo(i);
			local friendID, friendRep, friendMaxRep, _, _, _, friendTextLevel = T.GetFriendshipReputation(factionID);
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
			text = T.format('%s: %d%% [%s]', name, ((value - min) / (max - min) * 100), isFriend and friendText or _G["FACTION_STANDING_LABEL"..ID])
		elseif textFormat == 'CURMAX' then
			text = T.format('%s: %s - %s [%s]', name, value - min, max - min, isFriend and friendText or _G["FACTION_STANDING_LABEL"..ID])
		elseif textFormat == 'CURPERC' then
			text = T.format('%s: %s - %d%% [%s]', name, value - min, ((value - min) / (max - min) * 100), isFriend and friendText or _G["FACTION_STANDING_LABEL"..ID])
		end

		bar.text:SetText(text)
	end
end

function DB:ChatMsgCombat(event, ...)
	if not DB.db.rep.autotrack then return end

	local messg = ...
	local found
	for i, v in T.ipairs(strMatchCombat) do
		found = (T.match(messg,strMatchCombat[i]))
		if found then
			if GUILD and guildName and (found == GUILD) then
				found = guildName
			end
			break
		end
	end
	if found then
		DB:setWatchedFaction(found)
	end
end

function DB:CombatTextUpdate(event, ...)
	if not DB.db.rep.autotrack then return end

	local messagetype, faction, amount = ...
	if messagetype ~= "FACTION" then return end
	if (not amount) or (amount < 0) then return end
	if GUILD and faction and guildName and (faction == GUILD) then
		faction = guildName
	end
	if faction then
		DB:setWatchedFaction(faction)
	end
end

function DB:ChatMsgSys(event, ...)
	if not DB.db.rep.autotrack then return end

	local messg = ...
	local found
	local newfaction = (T.match(messg,strChangeMatch)) and T.select(2,T.match(messg,strChangeMatch))
	if newfaction then
		if guildName and (newfaction == GUILD) then
			found = guildName
		else
			found = newfaction
		end
	else
		local guildfaction
		for i, v in T.ipairs(strGuildChangeMatch) do
			guildfaction = (T.match(messg,strGuildChangeMatch[i]))
			if guildfaction then
				break
			end
		end
		if guildfaction and guildName then
			found = guildName
		end
	end
	if found then
		DB:setWatchedFaction(found)
	end
end

function DB:PlayerRepLogin()
	if T.IsInGuild() then
		guildName = (T.GetGuildInfo("player"))
		if not guildName then 
			DB:RegisterEvent("GUILD_ROSTER_UPDATE", 'PlayerGuildRosterUpdate')
		end
	end
end

function DB:PlayerGuildRosterUpdate()
	if not SLE.initialized  then return end
	if T.IsInGuild() then
		guildName = (T.GetGuildInfo("player"))
	end
	if guildName then
		DB:UnregisterEvent("GUILD_ROSTER_UPDATE")
	end
end

function DB:PlayerGuildRepUdate()
	if T.IsInGuild() then
		guildName = (T.GetGuildInfo("player"))
		if not guildName then 
			DB:RegisterEvent("GUILD_ROSTER_UPDATE", 'PlayerGuildRosterUpdate')
		end
	else
		guildName = nil
	end
end

function DB:setWatchedFaction(faction)
	if not SLE.initialized then return end
	T.twipe(collapsed)
	local i,j = 1, T.GetNumFactions()
	while i <= j do
		local name,_,_,_,_,_,_,_,isHeader,isCollapsed,_,isWatched = T.GetFactionInfo(i)
		if name == faction then
			if not (isWatched or T.IsFactionInactive(i)) then
				T.SetWatchedFactionIndex(i)
			end
			break
		end
		if isHeader and isCollapsed then
			ExpandFactionHeader(i)
			collapsed[i] = true
			j = T.GetNumFactions()
		end
		i = i+1
	end
	if next(collapsed) then
		for k=i,1,-1 do
			if collapsed[k] then
				CollapseFactionHeader(k)
			end
		end
	end
end

function DB:PopulateRepPatterns()
	local symbols = {'%.$','%(','%)','|3%-7%%%(%%s%%%)','%%s([^%%])','%+','%%d','%%.1f','%%.','%%(','%%)','(.-)','(.-)%1','%%+','(%%d-)','(%%d-)'}
	local pattern
	pattern = T.rgsub(FACTION_STANDING_INCREASED, T.unpack(symbols));
	T.tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_INCREASED_ACH_BONUS, T.unpack(symbols));
	T.tinsert(DB.RepIncreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED, T.unpack(symbols))
	T.tinsert(DB.RepDecreaseStrings, pattern)

	pattern = T.rgsub(FACTION_STANDING_DECREASED_GENERIC, T.unpack(symbols))
	T.tinsert(DB.RepDecreaseStrings, pattern)
end

function DB:FilterReputation(event, message, ...)
	local faction, rep, bonus
	if DB.db.rep.chatfilter.enable then
		for i, v in T.ipairs(DB.RepIncreaseStrings) do
			faction, rep, bonus = T.match(message, DB.RepIncreaseStrings[i])
			if faction then
				return true
			end
		end
		for i, v in T.ipairs(DB.RepDecreaseStrings) do
			faction, rep = T.match(message, DB.RepDecreaseStrings[i])
			if faction then
				return true
			end
		end
		return false, message, ...
	end
	return false, message, ...
end

function DB:ScanFactions()
	self.factions = T.GetNumFactions();
	for i = 1, self.factions do
		local name, _, standingID, _, _, barValue, _, _, isHeader, _, hasRep = T.GetFactionInfo(i)
		if (not isHeader or hasRep) then
			self.factionVars[name] = {}
			self.factionVars[name].Standing = standingID
			self.factionVars[name].Value = barValue
		end
	end
end
DB.RepChatFrames = {}
function DB:NewRepString(event, ...)
	if not DB.db.rep.chatfilter.enable then return end
	local stop = false
	local tempfactions = T.GetNumFactions()
	if (tempfactions > self.factions) then
		self:ScanFactions()
		self.factions = tempfactions
	end
	if DB.db.rep.chatfilter.chatframe == "AUTO" then
		T.twipe(DB.RepChatFrames)
		for i = 1, NUM_CHAT_WINDOWS do
			if SLE:SimpleTable(_G["ChatFrame"..i]["messageTypeList"], "COMBAT_FACTION_CHANGE") then
				T.tinsert(DB.RepChatFrames, "ChatFrame"..i)
			end
		end
	end
	for factionIndex = 1, T.GetNumFactions() do
		local StyleTable = nil
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID = T.GetFactionInfo(factionIndex)
		local friendID, _, _, _, _, _, friendTextLevel = T.GetFriendshipReputation(factionID);
		local currentRank, maxRank = T.GetFriendshipReputationRanks(factionID);
		if (not isHeader or hasRep) and self.factionVars[name] then
			local diff = barValue - self.factionVars[name].Value
			if diff > 0 then
				StyleTable = "RepIncreaseStyles"
			elseif diff < 0 then
				StyleTable = "RepDecreaseStyles"
			end
			if StyleTable then
				local change = abs(barValue - self.factionVars[name].Value)
				if DB.db.rep.chatfilter.chatframe == "AUTO" then
					for n = 1, #(DB.RepChatFrames) do
						local chatframe = _G[DB.RepChatFrames[n]]
						chatframe:AddMessage(T.format(DB[StyleTable][DB.db.rep.chatfilter.style] , DB.db.rep.chatfilter.iconsize, name, diff))
						if not E.db.sle.databars.rep.chatfilter.showAll then stop = true; break end
					end
				else
					local chatframe = _G[DB.db.rep.chatfilter.chatframe]
					chatframe:AddMessage(T.format(DB[StyleTable][DB.db.rep.chatfilter.style] , DB.db.rep.chatfilter.iconsize, name, diff))
					if not E.db.sle.databars.rep.chatfilter.showAll then stop = true; break end
				end
				self.factionVars[name].Value = barValue
				if stop then return end
			end
		end
	end
end

function DB:RepInit()
	DB:PopulateRepPatterns()
	hooksecurefunc(E:GetModule('DataBars'), "UpdateReputation", UpdateReputation)
end