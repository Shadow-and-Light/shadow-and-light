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
					text = string.format('%d%% '..L['Rested:']..' %d%%', cur / max * 100, rested / max * 100)
				elseif textFormat == 'CURMAX' then
					text = string.format('%s - %s '..L['Rested:']..' %s', cur, max, rested)
				elseif textFormat == 'CURPERC' then
					text = string.format('%s - %d%% '..L['Rested:']..' [%d%%]', cur, cur / max * 100, rested, rested / max * 100)
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

		bar.statusBar:SetMinMaxValues(min, max)
		bar.statusBar:SetValue(value)
		
		for i=1, numFactions do
			local factionName, _, standingID = GetFactionInfo(i);
			if factionName == name then
				ID = standingID
			end
		end
		
		
		if E.db.sle.exprep.replong then
			if textFormat == 'PERCENT' then
				text = string.format('%d%% [%s]', value / max * 100, _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURMAX' then
				text = string.format('%s - %s [%s]', value, max, _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURPERC' then
				text = string.format('%s - %d%% [%s]', value, value / max * 100, _G['FACTION_STANDING_LABEL'..ID])
			end		
		else
			if textFormat == 'PERCENT' then
				text = string.format('%d%% [%s]', value / max * 100, _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURMAX' then
				text = string.format('%s - %s [%s]', E:ShortValue(value), E:ShortValue(max), _G['FACTION_STANDING_LABEL'..ID])
			elseif textFormat == 'CURPERC' then
				text = string.format('%s - %d%% [%s]', E:ShortValue(value), value / max * 100, _G['FACTION_STANDING_LABEL'..ID])
			end	
		end
		
		bar.text:SetText(text)		
	end
	
	self:UpdateExpRepAnchors()
end