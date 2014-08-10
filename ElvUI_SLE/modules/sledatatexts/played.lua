local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local format, GetTime, ChatFrame_TimeBreakDown, InCombatLockdown = format, GetTime, ChatFrame_TimeBreakDown, InCombatLockdown
local PlayedTimeFormatFull = '%d '..L["D"]..' %02d:%02d:%02d'
local PlayedTimeFormatNoDay = '%02d:%02d:%02d'
local TotalPlayTime, LevelPlayTime, SessionPlayTime, LevelPlayedOffset, LastLevelTime
local MyRealm = E.myrealm
local MyName = E.myname
local MyClass = E.myclass
local AddLine, AddDoubleLine = AddLine, AddDoubleLine

local OnEnter = function(self)
	if not InCombatLockdown() and SessionPlayTime then
	DT:SetupTooltip(self)
		local SessionDay, SessionHour, SessionMinute, SessionSecond = ChatFrame_TimeBreakDown(GetTime() - SessionPlayTime)
		local TotalDay, TotalHour, TotalMinute, TotalSecond = ChatFrame_TimeBreakDown(TotalPlayTime + (GetTime() - SessionPlayTime))
		local LevelDay, LevelHour, LevelMinute, LevelSecond = ChatFrame_TimeBreakDown(LevelPlayTime + (GetTime() - LevelPlayTimeOffset))
		local LastLevelDay, LastLevelHour, LastLevelMinute, LastLevelSecond = ChatFrame_TimeBreakDown(LastLevelTime)
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(TIME_PLAYED_MSG, 1, 1, 1)
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["Session:"], SessionDay > 0 and format(PlayedTimeFormatFull, SessionDay, SessionHour, SessionMinute, SessionSecond) or format(PlayedTimeFormatNoDay, SessionHour, SessionMinute, SessionSecond), 1, 1, 1, 1, 1, 1)
		if LastLevelSecond > 0 then
			DT.tooltip:AddDoubleLine(L["Previous Level:"], LastLevelDay > 0 and format(PlayedTimeFormatFull, LastLevelDay. LastLevelHour, LastLevelMinute, LastLevelSecond) or format(PlayedTimeFormatNoDay, LastLevelHour, LastLevelMinute, LastLevelSecond), 1, 1, 1, 1, 1, 1)
		end
		DT.tooltip:AddDoubleLine(LEVEL..':', LevelDay > 0 and format(PlayedTimeFormatFull, LevelDay, LevelHour, LevelMinute, LevelSecond) or format(PlayedTimeFormatNoDay, LevelHour, LevelMinute, LevelSecond), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(TOTAL..':', TotalDay > 0 and format(PlayedTimeFormatFull, TotalDay, TotalHour, TotalMinute, TotalSecond) or format(PlayedTimeFormatNoDay, TotalHour, TotalMinute, TotalSecond), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(L["Account Time Played"], 1, 1, 1)
		DT.tooltip:AddLine(' ')
		local Class, Level, AccountDay, AccountHour, AccountMinute, AccountSecond, TotalAccountTime
		for player, subtable in pairs(ElvDB['sle']['TimePlayed'][MyRealm]) do
			for k, v in pairs(subtable) do
				if k == 'TotalTime' then
					AccountDay, AccountHour, AccountMinute, AccountSecond = ChatFrame_TimeBreakDown(v)
					TotalAccountTime = (TotalAccountTime or 0) + v
				end
				if k == 'Class' then Class = v end
				if k == 'Level' then Level = v end
			end
			local color = RAID_CLASS_COLORS[Class]
			DT.tooltip:AddDoubleLine(format('%s |cFFFFFFFF- %s %d', player, LEVEL, Level), format(PlayedTimeFormatFull, AccountDay, AccountHour, AccountMinute, AccountSecond), color.r, color.g, color.b, 1, 1, 1)
		end
		DT.tooltip:AddLine(' ')
		local TotalAccountDay, TotalAccountHour, TotalAccountMinute, TotalAccountSecond = ChatFrame_TimeBreakDown(TotalAccountTime)
		DT.tooltip:AddDoubleLine(TOTAL, format(PlayedTimeFormatFull, TotalAccountDay, TotalAccountHour, TotalAccountMinute, TotalAccountSecond), 1, 0, 1, 1, 1, 1)
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(L["Reset Data: Hold Shift + Right Click"])
		DT.tooltip:Show()
	end
end

local ElapsedTimer = 0
local OnUpdate = function(self, elapsed)
	ElapsedTimer = ElapsedTimer + elapsed
	if (not self.text) then
		local text = self:CreateFontString(nil, 'OVERLAY')
		text:SetFont(DataText.Font, DataText.Size, DataText.Flags)
		text:SetText(TIME_PLAYED_MSG)
		self.text = text
	end
	
	if TotalPlayTime and LevelPlayTime and SessionPlayTime then
		local Day, Hour, Minute, Second
		if UnitLevel('player') ~= MAX_PLAYER_LEVEL then
			Day, Hour, Minute, Second = ChatFrame_TimeBreakDown(LevelPlayTime + (GetTime() - LevelPlayTimeOffset))
		else
			Day, Hour, Minute, Second = ChatFrame_TimeBreakDown(TotalPlayTime + (GetTime() - SessionPlayTime))
		end
		if Day > 0 then
			self.text:SetFormattedText('%d '..L["D"]..' %02d:%02d', Day, Hour, Minute)
		else
			self.text:SetFormattedText('%02d:%02d', Hour, Minute)
		end
	else
		if ElapsedTimer > 1 and not self.Requested then
			self.Requested = true
			RequestTimePlayed()
		end
	end
end

local OnEvent = function(self, event, ...)
	if not ElvDB['sle'] then ElvDB['sle'] = {} end
	if not ElvDB['sle']['TimePlayed'] then ElvDB['sle']['TimePlayed'] = {} end
	if not ElvDB['sle']['TimePlayed'][MyRealm] then ElvDB['sle']['TimePlayed'][MyRealm] = {} end
	if not ElvDB['sle']['TimePlayed'][MyRealm][MyName] then ElvDB['sle']['TimePlayed'][MyRealm][MyName] = {} end
	ElvDB['sle']['TimePlayed'][MyRealm][MyName]['Class'] = MyClass
	ElvDB['sle']['TimePlayed'][MyRealm][MyName]['Level'] = UnitLevel('player')
	LastLevelTime = ElvDB['sle']['TimePlayed'][MyRealm][MyName]['LastLevelTime'] or 0
	if event == 'TIME_PLAYED_MSG' then
		local TotalTime, LevelTime = ...
		TotalPlayTime = TotalTime
		LevelPlayTime = LevelTime
		if SessionPlayTime == nil then SessionPlayTime = GetTime() end
		LevelPlayTimeOffset = GetTime()
		ElvDB['sle']['TimePlayed'][MyRealm][MyName]['TotalTime'] = TotalTime
		ElvDB['sle']['TimePlayed'][MyRealm][MyName]['LevelTime'] = LevelTime
	end
	if event == 'PLAYER_LEVEL_UP' then
		LastLevelTime = floor(LevelPlayTime + (GetTime() - LevelPlayTimeOffset))
		ElvDB['sle']['TimePlayed'][MyRealm][MyName]['LastLevelTime'] = LastLevelTime
		LevelPlayTime = 1
		LevelPlayTimeOffset = GetTime()
		ElvDB['sle']['TimePlayed'][MyRealm][MyName]['Level'] = UnitLevel('player')
	end
	if event == 'PLAYER_ENTERING_WORLD' then
		self:UnregisterEvent(event)
		if not IsAddOnLoaded('DataStore_Characters') then
			RequestTimePlayed()
		end
	end
	if event == 'PLAYER_LOGOUT' then
		RequestTimePlayed()
	end
end

local function Reset()
	ElvDB['sle']['TimePlayed'][MyRealm] = {}
	ElvDB['sle']['TimePlayed'][MyRealm][MyName] = {}
	ElvDB['sle']['TimePlayed'][MyRealm][MyName]['Level'] = UnitLevel('player')
	ElvDB['sle']['TimePlayed'][MyRealm][MyName]['LastLevelTime'] = LastLevelTime
	ElvDB['sle']['TimePlayed'][MyRealm][MyName]['Class'] = MyClass
	RequestTimePlayed()
	print(': Time Played has been reset!')
end

local OnMouseDown = function(self, button)
	if button == 'RightButton' then
		if IsShiftKeyDown()then
			Reset()
		end
	end
end
DT:RegisterDatatext('S&L Time Played', {'TIME_PLAYED_MSG', 'PLAYER_LEVEL_UP', 'PLAYER_ENTERING_WORLD' , 'PLAYER_LOGOUT'}, OnEvent, OnUpdate, OnMouseDown, OnEnter, OnLeave)