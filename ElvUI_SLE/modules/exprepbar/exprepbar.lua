--Credits to Benik
--Exp/Rep bar text mod
local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local M = E:GetModule('Misc');

local BAR_WIDTH --Set post load so we can set it to a percent of your screen width.
local BAR_HEIGHT = 10 -- was 9
local TOPBAR_HEIGHT = ((BAR_HEIGHT) * 3)+1 -- was ((BAR_HEIGHT + 2) * 4) + BAR_HEIGHT
local showRepBar, showExpBar = false, false
local RBRWidth = ((E.MinimapSize - 6) / 6 + 4)

local function GetXP(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

local function OnClick()
	if E.db['UpperRepExpBarFaded'] then
		E.db['UpperRepExpBarFaded'] = nil
		UpperRepExpBar:Show()
		UIFrameFadeIn(UpperRepExpBar, 0.2, UpperRepExpBar:GetAlpha(), 1)
		M:UpdateExpBar()
		M:UpdateRepBar()			
	else
		E.db['UpperRepExpBarFaded'] = true
		UIFrameFadeOut(UpperRepExpBar, 0.2, UpperRepExpBar:GetAlpha(), 0)
		UpperRepExpBar.fadeInfo.finishedFunc = OnFade
	end	
end

local function OnLeave()
	if E.db['UpperRepExpBarFaded'] then
		UIFrameFadeOut(UpperRepExpBar, 0.2, UpperRepExpBar:GetAlpha(), 0)
		UpperRepExpBar.fadeInfo.finishedFunc = OnFade
	end	
	
	GameTooltip:Hide()
end

local function OnEnter()
	if E.db['UpperRepExpBarFaded'] then
		UpperRepExpBar:Show()
		UIFrameFadeIn(UpperRepExpBar, 0.2, UpperRepExpBar:GetAlpha(), 1)
		M:UpdateExpBar()
		M:UpdateRepBar()		
	end
end

local function OnFade()
	UpperRepExpBar:Hide()
end

function M:GetNumShownBars()
	local shownBars = 0
	if showRepBar and showExpBar then
		shownBars = 2
	elseif (showRepBar and not showExpBar) or (not showRepBar and showExpBar) then
		shownBars = 1
	end

	return shownBars
end

function M:PositionBars(num)
	if num == 1 then
		UpperRepExpBarHolder:Height(TOPBAR_HEIGHT / 2)
		UpperRepExpBar:Height(TOPBAR_HEIGHT / 2)
		UpperRepExpBar.left:Height(TOPBAR_HEIGHT / 2)
		UpperRepExpBar.right:Height(TOPBAR_HEIGHT / 2)
	else
		UpperRepExpBarHolder:Height(TOPBAR_HEIGHT)
		UpperRepExpBar:Height(TOPBAR_HEIGHT)
		UpperRepExpBar.left:Height(TOPBAR_HEIGHT)
		UpperRepExpBar.right:Height(TOPBAR_HEIGHT)
	end
	
	UpperRepExpBarHolder:Show()
	
	if num == 2 then
		UpperRepExpBar:Show()
		UpperReputationBar:ClearAllPoints()
		UpperExperienceBar:ClearAllPoints()	
		UpperExperienceBar:SetPoint('CENTER', UpperRepExpBar.bottom, 'CENTER')
		UpperReputationBar:SetPoint('CENTER', UpperRepExpBar.middle, 'CENTER')
	elseif num == 1 then
		UpperRepExpBar:Show()
		if showRepBar then
			UpperReputationBar:ClearAllPoints()
			UpperReputationBar:SetPoint('CENTER', UpperRepExpBar.bottom, 'CENTER')
		else
			UpperExperienceBar:ClearAllPoints()			
			UpperExperienceBar:SetPoint('CENTER', UpperRepExpBar.bottom, 'CENTER')
		end
	elseif UpperRepExpBarHolder:IsShown() then
		UpperRepExpBarHolder:Hide()
	end
end

local function ExpOnEnter(self)
	OnEnter()
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_BOTTOM', 0 -4)
	
	local cur, max = GetXP('player')
	local rested = GetXPExhaustion()
	GameTooltip:AddLine(L['Experience'])
	GameTooltip:AddLine(' ')
	
	GameTooltip:AddDoubleLine(L['XP:'], string.format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine(L['Remaining:'], string.format(' %d (%d%% - %d '..L['Bars']..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)	
	
	if rested then
		GameTooltip:AddDoubleLine(L['Rested:'], string.format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)	
	end
	
	GameTooltip:Show()
end

function M:UpdateExpBar(event)
	local bar = UpperExperienceBar
	if not bar then
		bar = CreateFrame('StatusBar', 'UpperExperienceBar', UpperRepExpBar)
		bar:Size(BAR_WIDTH + RBRWidth, BAR_HEIGHT)
		bar:CreateBackdrop('Default')
		bar:SetStatusBarTexture(E.media.normTex)
		bar:SetFrameLevel(UpperRepExpBar:GetFrameLevel() + 3)
		bar:SetStatusBarColor(0, 0.4, 1, .8) -- (0, 0.4, 1, .8)
		
		-- Set the text --
		bar.txt = bar:CreateFontString(nil,'OVERLAY')
		bar.txt:FontTemplate(nil, 11) -- change fontsize here
		bar.txt:Point('CENTER', UpperExperienceBar, 'CENTER', 0, 0)
		bar.txt:SetJustifyH('CENTER')
		bar.txt:SetJustifyV('MIDDLE')
		------------------
		bar:EnableMouse(true)
		bar:SetScript('OnMouseDown', OnClick)	
		bar:SetScript('OnEnter', ExpOnEnter)
		bar:SetScript('OnLeave', OnLeave)
		
		bar.rested = CreateFrame('StatusBar', 'UpperExperienceRestedBar', UpperExperienceBar)
		bar.rested:Size(bar:GetSize())
		bar.rested:SetAllPoints()
		bar.rested:SetStatusBarTexture(E.media.normTex)
		bar.rested:SetStatusBarColor(1, 0, 1, 0.2)
	end

	if(UnitLevel('player') == MAX_PLAYER_LEVEL) then
		bar:Hide()
		showExpBar = false
	elseif IsXPUserDisabled() then
		bar:Hide()
		showExpBar = false
	else
		bar:Show()
		showExpBar = true
		
		local cur, max = GetXP('player')
		local rested = GetXPExhaustion()
		local xprest
		if rested and rested > 0 then
			bar.rested:SetMinMaxValues(0, max)
			bar.rested:SetValue(math.min(cur + rested, max))
			xprest = E:ShortValue(rested)
		else
			bar.rested:SetMinMaxValues(0, 1)
			bar.rested:SetValue(0)	
		end
		
		bar:SetMinMaxValues(0, max)
		bar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
		bar:SetValue(cur)
		-- enable text
		if E.db.dpe.xprepinfo.enabled then
			M:CreateExpTextString()
		end
	end
	
	M:PositionBars(self:GetNumShownBars())
end

local function RepOnEnter(self)
	OnEnter()
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_BOTTOM', 0 -4)
	
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	if name then
		GameTooltip:AddLine(name)
		GameTooltip:AddLine(' ')
		
		GameTooltip:AddDoubleLine(STANDING..':', _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
		GameTooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
	end
	GameTooltip:Show()
end

function M:UpdateRepBar(event)
	local bar = UpperReputationBar
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	if not bar then
		bar = CreateFrame('StatusBar', 'UpperReputationBar', UpperRepExpBar)
		bar:Size(BAR_WIDTH + RBRWidth, BAR_HEIGHT)
		bar:CreateBackdrop('Default')
		bar:SetStatusBarTexture(E.media.normTex)
		bar:SetFrameLevel(UpperRepExpBar:GetFrameLevel() + 3)
		bar:EnableMouse(true)
		bar:SetScript('OnMouseDown', OnClick)	
		bar:SetScript('OnEnter', RepOnEnter)
		bar:SetScript('OnLeave', OnLeave)
		-- set the text
		bar.txt = bar:CreateFontString(nil,'OVERLAY')
		bar.txt:FontTemplate(nil, 11) -- change fontsize here
		bar.txt:Point('CENTER', UpperReputationBar, 'CENTER', 0, 0)
		bar.txt:SetJustifyH('CENTER')
		bar.txt:SetJustifyV('MIDDLE')
		----------------------------
	end
	
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	if not name then
		bar:Hide()
		showRepBar = false
	else
		bar:Show()
		showRepBar = true
		
		local color = FACTION_BAR_COLORS[reaction]
		bar:SetStatusBarColor(color.r, color.g, color.b)	

		bar:SetMinMaxValues(min, max)
		bar:SetValue(value)
		-- enable text
		if E.db.dpe.xprepinfo.enabled then
			M:CreateRepTextString()
		end
	end
		
	M:PositionBars(self:GetNumShownBars())
end

function M:UpdateExpRepBarAnchor()
	UpperRepExpBarHolder:ClearAllPoints()
	if E.db.general.expRepPos == 'TOP_SCREEN' then
		BAR_WIDTH = E.eyefinity or E.UIParent:GetWidth(); BAR_WIDTH = BAR_WIDTH / 5
		UpperRepExpBarHolder:Point('TOP', E.UIParent, 'TOP', 0, -25)  
		UpperRepExpBarHolder:SetParent(E.UIParent)
		
	else
		BAR_WIDTH = E.MinimapSize+1 -- strange... should be fine without this +1 but it's needed :(
		UpperRepExpBarHolder:Point('TOP', MMHolder, 'BOTTOM', 1, -4)  
		UpperRepExpBarHolder:SetParent(Minimap)
	end
	
	UpperRepExpBarHolder:SetFrameLevel(0)
	UpperRepExpBarHolder:Size(BAR_WIDTH - 30 + RBRWidth, TOPBAR_HEIGHT)

	if UpperReputationBar then
		UpperReputationBar:Size(BAR_WIDTH + RBRWidth, BAR_HEIGHT)
		if E.db.dpe.xprepinfo.enabled then
			M:CreateRepTextString()
		else
			UpperReputationBar.txt:SetText('')
		end
	end
	
	if UpperExperienceBar then
		UpperExperienceBar:Size(BAR_WIDTH + RBRWidth, BAR_HEIGHT)
		if E.db.dpe.xprepinfo.enabled then
			M:CreateExpTextString()
		else
			UpperExperienceBar.txt:SetText('')
		end
	end	
	
	self:PositionBars(self:GetNumShownBars())

end

function M:CreateExpTextString()
	local cur, max = GetXP('player')
	local rested = GetXPExhaustion()
	local xprest
	if rested and rested > 0 then
		UpperExperienceBar.rested:SetMinMaxValues(0, max)
		UpperExperienceBar.rested:SetValue(math.min(cur + rested, max))
		xprest = E:ShortValue(rested)
	else
		UpperExperienceBar.rested:SetMinMaxValues(0, 1)
		UpperExperienceBar.rested:SetValue(0)	
	end
	
	if E.db.general.expRepPos == "TOP_SCREEN" and E.db.dpe.xprepinfo.xprepdet then
		if E.db.dpe.xprepinfo.xprest and rested and rested > 0 then
			UpperExperienceBar.txt:SetText(LEVEL_ABBR..' '..string.format('%s XP: %d / %d (%d%%)', UnitLevel('player'), cur, max, cur/max * 100)..' + '..L['Rested:']..xprest)
		else
			UpperExperienceBar.txt:SetText(LEVEL_ABBR..' '..string.format('%s XP: %d / %d (%d%%)', UnitLevel('player'), cur, max, cur/max * 100))
		end
	else
		UpperExperienceBar.txt:SetText('XP:'..string.format(' %d / %d (%d%%)', cur, max, cur/max * 100))
	end
end

function M:CreateRepTextString()
	local name, reaction, min, max, value = GetWatchedFactionInfo()

	if not name then
		return
	else
		if E.db.general.expRepPos == "TOP_SCREEN" and E.db.dpe.xprepinfo.xprepdet then
			if E.db.dpe.xprepinfo.repreact then
				UpperReputationBar.txt:SetText(name..': '..format('%d / %d ('.._G['FACTION_STANDING_LABEL'..reaction]..' '..'%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
			else
				UpperReputationBar.txt:SetText(name..': '..format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
			end
		else
			UpperReputationBar.txt:SetText(name..': '..format('%d%%', (value - min) / (max - min) * 100))
		end
	end
end


function M:LoadExpRepBar()
	local holder = CreateFrame('Button', 'UpperRepExpBarHolder', E.UIParent)
	holder:Point('TOP', E.UIParent, 'TOP', 0, 2)  
	holder:SetScript('OnEnter', OnEnter)
	holder:SetScript('OnLeave', OnLeave)	
	holder:SetScript('OnClick', OnClick)	
	holder:SetFrameStrata('BACKGROUND')
	
	local bar = CreateFrame('Frame', 'UpperRepExpBar', holder)
	bar:SetAllPoints(holder)
	bar:Hide()
		
	bar.left = CreateFrame('Frame', nil, bar)
	bar.left:Point('RIGHT', bar, 'LEFT')
	bar.left:Width(2)
	bar.left:Height(30)
	bar.left:SetTemplate('Default')
	bar.left:SetFrameLevel(bar:GetFrameLevel())
	bar.left:Hide()
	
	bar.right = CreateFrame('Frame', nil, bar)
	bar.right:Point('LEFT', bar, 'RIGHT')
	bar.right:Width(2)
	bar.right:Height(30)
	bar.right:SetTemplate('Default')
	bar.right:SetFrameLevel(bar:GetFrameLevel())
	bar.right:Hide()
	
	bar.bottom = CreateFrame('Frame', nil, bar)
	bar.bottom:SetTemplate('Default', true)
	bar.bottom:Point('BOTTOM', bar, 'BOTTOM', 0, BAR_HEIGHT + 2)
	bar.bottom:Width(bar:GetWidth() + 2)
	bar.bottom:Height(2)
	bar.bottom:SetFrameLevel(bar:GetFrameLevel())
	
	bar.middle = CreateFrame('Frame', nil, bar)
	bar.middle:Point('CENTER', bar, 'CENTER', 0, BAR_HEIGHT + 2)
	bar.middle:Width(bar:GetWidth() + 2)
	bar.middle:Height(2)
	bar.middle:SetFrameLevel(bar:GetFrameLevel())

	self:UpdateExpRepBarAnchor()

	--Register experience bar related events..
	if UnitLevel('player') ~= MAX_PLAYER_LEVEL then
		self:RegisterEvent('PLAYER_XP_UPDATE', 'UpdateExpBar')
		self:RegisterEvent('PLAYER_LEVEL_UP', 'UpdateExpBar')
		self:RegisterEvent("DISABLE_XP_GAIN", 'UpdateExpBar')
		self:RegisterEvent("ENABLE_XP_GAIN", 'UpdateExpBar')
		self:RegisterEvent('UPDATE_EXHAUSTION', 'UpdateExpBar')
		self:UpdateExpBar()
	end

	--Reputation Events
	self:RegisterEvent('UPDATE_FACTION', 'UpdateRepBar')
	OnLeave()
end