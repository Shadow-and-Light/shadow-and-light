local E, L, V, P, G = unpack(ElvUI);
local M = E:GetModule('Misc');

local strMatchCombat = {}
local tinsert, gsub, format = tinsert, string.gsub, format
local GetXPExhaustion = GetXPExhaustion
local SetMinMaxValues = SetMinMaxValues
local GetFactionInfo = GetFactionInfo
local GetGuildInfo = GetGuildInfo

tinsert(strMatchCombat, (gsub(FACTION_STANDING_INCREASED,"%%%d?%$?s", "(.+)")))
tinsert(strMatchCombat, (gsub(FACTION_STANDING_INCREASED_GENERIC,"%%%d?%$?s", "(.+)")))
tinsert(strMatchCombat, (gsub(FACTION_STANDING_INCREASED_BONUS,"%%%d?%$?s", "(.+)")))
tinsert(strMatchCombat, (gsub(FACTION_STANDING_INCREASED_DOUBLE_BONUS,"%%%d?%$?s", "(.+)")))
tinsert(strMatchCombat, (gsub(FACTION_STANDING_INCREASED_ACH_BONUS,"%%%d?%$?s", "(.+)")))
local strChangeMatch = (gsub(FACTION_STANDING_CHANGED,"%%%d?%$?s", "(.+)"))
local strGuildChangeMatch = {}
tinsert(strGuildChangeMatch, (gsub(FACTION_STANDING_CHANGED_GUILD,"%%%d?%$?s", "(.+)")))
tinsert(strGuildChangeMatch, (gsub(FACTION_STANDING_CHANGED_GUILDNAME,"%%%d?%$?s", "(.+)")))

local collapsed = {}
local guildName

local function UpdateExperience(self, event)
	if not E.db.sle.exprep.explong then return end
	local bar = self.expBar

	if not UnitLevel('player') == MAX_PLAYER_LEVEL or not IsXPUserDisabled() then
		local cur, max = self:GetXP('player')
		local rested = GetXPExhaustion()
		local text = ''
		local textFormat = E.db.general.experience.textFormat

		if rested and rested > 0 then
				if textFormat == 'PERCENT' then
					text = format('%d%%  '..L['Rested:']..' %d%%', cur / max * 100, rested / max * 100)
				elseif textFormat == 'CURMAX' then
					text = format('%s - %s  '..L['Rested:']..' %s', cur, max, rested)
				elseif textFormat == 'CURPERC' then
					text = format('%s - %d%%  '..L['Rested:']..' %s [%d%%]', cur, cur / max * 100, rested, rested / max * 100)
				end
		else
				if textFormat == 'PERCENT' then
					text = format('%d%%', cur / max * 100)
				elseif textFormat == 'CURMAX' then
					text = format('%s - %s', cur, max)
				elseif textFormat == 'CURPERC' then
					text = format('%s - %d%%', cur, cur / max * 100)
				end
		end

		bar.text:SetText(text)
	end
end

local backupColor = FACTION_BAR_COLORS[1]
local FactionStandingLabelUnknown = UNKNOWN
local function UpdateReputation(self, event)
	if not E.db.sle.exprep.replong then return end
	local bar = self.repBar
	local ID
	local isFriend, friendText, standingLabel
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();

	if name then
		local text = ''
		local textFormat = E.db.general.reputation.textFormat
		local color = FACTION_BAR_COLORS[reaction] or backupColor
		bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)

		bar.statusBar:SetMinMaxValues(min, max)
		bar.statusBar:SetValue(value)

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
			standingLabel = _G['FACTION_STANDING_LABEL'..ID]
		else
			standingLabel = FactionStandingLabelUnknown
		end

		if textFormat == 'PERCENT' then
			text = format('%s: %d%% [%s]', name, ((value - min) / (max - min) * 100), isFriend and friendText or _G['FACTION_STANDING_LABEL'..ID])
		elseif textFormat == 'CURMAX' then
			text = format('%s: %s - %s [%s]', name, value - min, max - min, isFriend and friendText or _G['FACTION_STANDING_LABEL'..ID])
		elseif textFormat == 'CURPERC' then
			text = format('%s: %s - %d%% [%s]', name, value - min, ((value - min) / (max - min) * 100), isFriend and friendText or _G['FACTION_STANDING_LABEL'..ID])
		end

		bar.text:SetText(text)
	end
end

function M:ChatMsgCombat(event, ...)
	if not E.private.sle.exprep.autotrack then return end

	local messg = ...
	local found
	for i, v in ipairs(strMatchCombat) do
		found = (string.match(messg,strMatchCombat[i]))
		if found then
			if GUILD and guildName and (found == GUILD) then
				found = guildName
			end
			break
		end
	end
	if found then
		M:setWatchedFaction(found)
	end
end

function M:CombatTextUpdate(event, ...)
	if not E.private.sle.exprep.autotrack then return end

	local messagetype, faction, amount = ...
	if messagetype ~= "FACTION" then return end
	if (not amount) or (amount < 0) then return end
	if GUILD and faction and guildName and (faction == GUILD) then
		faction = guildName
	end
	if faction then
		M:setWatchedFaction(faction)
	end
end

function M:ChatMsgSys(event, ...)
	if not E.private.sle.exprep.autotrack then return end

	local messg = ...
	local found
	local newfaction = (string.match(messg,strChangeMatch)) and select(2,string.match(messg,strChangeMatch))
	if newfaction then
		if guildName and (newfaction == GUILD) then
			found = guildName
		else
			found = newfaction
		end
	else
		local guildfaction
		for i, v in ipairs(strGuildChangeMatch) do
			guildfaction = (string.match(messg,strGuildChangeMatch[i]))
			if guildfaction then
				break
			end
		end
		if guildfaction and guildName then
			found = guildName
		end
	end
	if found then
		M:setWatchedFaction(found)
	end
end

function M:PlayerRepLogin()
	if IsInGuild() then
		guildName = (GetGuildInfo("player"))
		if not guildName then 
			M:RegisterEvent("GUILD_ROSTER_UPDATE", 'PlayerGuildRosterUpdate')
		end
	end
end

function M:PlayerGuildRosterUpdate()
	if IsInGuild() then
		guildName = (GetGuildInfo("player"))
	end
	if guildName then
		M:UnregisterEvent("GUILD_ROSTER_UPDATE")
	end
end

function M:PlayerGuildRepUdate()
	if IsInGuild() then
		guildName = (GetGuildInfo("player"))
		if not guildName then 
			M:RegisterEvent("GUILD_ROSTER_UPDATE", 'PlayerGuildRosterUpdate')
		end
	else
		guildName = nil
	end
end

function M:setWatchedFaction(faction)
	wipe(collapsed)
	local i,j = 1, GetNumFactions()
	while i <= j do
		local name,_,_,_,_,_,_,_,isHeader,isCollapsed,_,isWatched = GetFactionInfo(i)
		if name == faction then
			if not (isWatched or IsFactionInactive(i)) then
				SetWatchedFactionIndex(i)
			end
			break
		end
		if isHeader and isCollapsed then
			ExpandFactionHeader(i)
			collapsed[i] = true
			j = GetNumFactions()
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

hooksecurefunc(M, "Initialize", function(self,...)
	M:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", 'ChatMsgCombat')
	M:RegisterEvent("COMBAT_TEXT_UPDATE", 'CombatTextUpdate')
	M:RegisterEvent("CHAT_MSG_SYSTEM", 'ChatMsgSys')
	M:RegisterEvent("PLAYER_LOGIN", 'PlayerRepLogin')
	M:RegisterEvent("PLAYER_GUILD_UPDATE", 'PlayerGuildRepUdate')
end)

hooksecurefunc(M, "UpdateExperience", UpdateExperience)
hooksecurefunc(M, "UpdateReputation", UpdateReputation)