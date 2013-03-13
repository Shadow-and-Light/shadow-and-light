local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local M = E:GetModule('Misc');

function M:UpdateExperience(event)
	local bar = self.expBar

	if(UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled() then
		bar:Hide()
	else
		bar:Show()
		
		local cur, max = self:GetXP('player')
		bar.statusBar:SetMinMaxValues(0, max)
		bar.statusBar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
		bar.statusBar:SetValue(cur)
		
		local rested = GetXPExhaustion()
		local text = ''
		local textFormat = E.db.general.experience.textFormat
		
		if rested and rested > 0 then
			bar.rested:SetMinMaxValues(0, max)
			bar.rested:SetValue(math.min(cur + rested, max))
			
			if E.db.sle.exprep.explong then
				if textFormat == 'PERCENT' then
					text = string.format('%d%%  '..L['Rested:']..' %d%%', cur / max * 100, rested / max * 100)
				elseif textFormat == 'CURMAX' then
					text = string.format('%s - %s  '..L['Rested:']..' %s', cur, max, rested)
				elseif textFormat == 'CURPERC' then
					text = string.format('%s - %d%%  '..L['Rested:']..' %s [%d%%]', cur, cur / max * 100, rested, rested / max * 100)
				end
			else
				if textFormat == 'PERCENT' then
					text = string.format('%d%% R:%d%%', cur / max * 100, rested / max * 100)
				elseif textFormat == 'CURMAX' then
					text = string.format('%s - %s R:%s', E:ShortValue(cur), E:ShortValue(max), E:ShortValue(rested))
				elseif textFormat == 'CURPERC' then
					text = string.format('%s - %d%% R:%s [%d%%]', E:ShortValue(cur), cur / max * 100, E:ShortValue(rested), rested / max * 100)
				end
			end
		else
			bar.rested:SetMinMaxValues(0, 1)
			bar.rested:SetValue(0)	

			if E.db.sle.exprep.explong then
				if textFormat == 'PERCENT' then
					text = string.format('%d%%', cur / max * 100)
				elseif textFormat == 'CURMAX' then
					text = string.format('%s - %s', cur, max)
				elseif textFormat == 'CURPERC' then
					text = string.format('%s - %d%%', cur, cur / max * 100)
				end			
			else
				if textFormat == 'PERCENT' then
					text = string.format('%d%%', cur / max * 100)
				elseif textFormat == 'CURMAX' then
					text = string.format('%s - %s', E:ShortValue(cur), E:ShortValue(max))
				elseif textFormat == 'CURPERC' then
					text = string.format('%s - %d%%', E:ShortValue(cur), cur / max * 100)
				end	
			end
		end
		
		bar.text:SetText(text)
	end
	
	self:UpdateExpRepAnchors()
end

function M:UpdateReputation(event)
	local bar = self.repBar
	
	local ID = 100
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();

	if not name then
		bar:Hide()
	else
		bar:Show()

		local text = ''
		local textFormat = E.db.general.reputation.textFormat		
		local color = FACTION_BAR_COLORS[reaction]
		bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)	

		bar.statusBar:SetMinMaxValues(0, max - min)
		bar.statusBar:SetValue(value - min)
		
		for i=1, numFactions do
			local factionName, _, standingID = GetFactionInfo(i);
			if factionName == name then
				ID = standingID
			end
		end
		
		
		if E.db.sle.exprep.replong then
			if textFormat == 'PERCENT' then
				text = string.format('%d%% [%s]', ((value - min) / (max - min) * 100), _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURMAX' then
				text = string.format('%s - %s [%s]', value - min, max - min, _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURPERC' then
				text = string.format('%s - %d%% [%s]', value - min, ((value - min) / (max - min) * 100), _G['FACTION_STANDING_LABEL'..ID])
			end		
		else
			if textFormat == 'PERCENT' then
				text = string.format('%d%% [%s]', ((value - min) / (max - min) * 100), _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURMAX' then
				text = string.format('%s - %s [%s]', E:ShortValue(value - min), E:ShortValue(max - min), _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURPERC' then
				text = string.format('%s: %s - %d%% [%s]', name, E:ShortValue(value - min), ((value - min) / (max - min) * 100), _G['FACTION_STANDING_LABEL'..ID])
			end	
		end
		
		bar.text:SetText(text)		
	end
	
	self:UpdateExpRepAnchors()
end

function M:AutoTrackRep(event, msg)
	if not E.private.sle.exprep.autotrack then return end

	local find, gsub, format = string.find, string.gsub, string.format
	local factionIncreased = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
	local factionChanged = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
	local factionDecreased = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
	local standing = ('%s:'):format(STANDING)
	local reputation = ('%s:'):format(REPUTATION)

	local _, _, faction, amount = find(msg, factionIncreased)
	if not faction then _, _, faction, amount = find(msg, factionChanged) or find(msg, factionDecreased) end
	if faction then
		if faction == GUILD_REPUTATION then
			faction = GetGuildInfo("player")
		end

		local active = GetWatchedFactionInfo()
		for factionIndex = 1, GetNumFactions() do
			local name = GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				-- check if watch has been disabled by user
				local inactive = IsFactionInactive(factionIndex) or SetWatchedFactionIndex(factionIndex)
				break
			end
		end
	end
end

hooksecurefunc(M, "Initialize", function(self,...)
	M:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", 'AutoTrackRep')
end)