local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local AFK = E.AFK
local S = SLE.Screensaver

--GLOBALS: unpack, select, format, random, date, tinsert, type, tonumber, hooksecurefunc, UnitPVPName, UnitClass, UnitRace, RANK, LEVEL, CreateFrame, CreateAnimationGroup, C_Timer, SendChatMessage, RAID_CLASS_COLORS, GetScreenWidth, GetScreenHeight, IsInGuild, GetGuildInfo, FlipCameraYaw

local testTimer  --was AnimTime before
local format, random, date, tinsert, tonumber = format, random, date, tinsert, tonumber
local UnitPVPName, UnitClass = UnitPVPName, UnitClass
local GetExpansionDisplayInfo, GetClientDisplayExpansionLevel = GetExpansionDisplayInfo, GetClientDisplayExpansionLevel
local RANK, LEVEL = RANK, LEVEL
local C_Timer, CreateAnimationGroup = C_Timer, CreateAnimationGroup
local TipNum, OldTip, degree = 1, 0, 0
local timerLastUpdate = 0
local tipsLastUpdate = 0
local total_seconds = 0
local degreeMultyplier = 10

S.Animations = {}
S.Fading = {}

local function currentDateTime()
	local month = SLE.Russian and SLE.RuMonths[tonumber(date('%m'))] or date('%B')
	local week = SLE.Russian and SLE.RuWeek[tonumber(date('%w'))+1] or date('%A')

	AFK.AFKMode.SL_Date:SetText(date('%d')..' '..month..', |cff00AAFF'..week..'|r')

	local time
	if S.db.defaultTexts.SL_Time.hour24 then
		time = format('%s', date('%H|cff00AAFF:|r%M|cff00AAFF:|r%S'))
	else
		time = format('%s', date('%I|cff00AAFF:|r%M|cff00AAFF:|r%S %p'))
	end

	AFK.AFKMode.SL_Time:SetText(time)
end

S.CustomGraphicsDefaults = {
	enable = true,
	path = '',
	width = 150,
	height = 150,
	inversePoint = false,
	anchorPoint = 'CENTER',
	attachTo = 'SL_TopPanel',
	xOffset = 0,
	yOffset = 0,
	alpha = 1,
	drawLayer = 'ARTWORK',
	drawLevel = 1,
}

local newDBEntry = false
local function UpdateCustomGraphicsDefaults()
	local db = E.db.sle.afk.customGraphics

	for name in pairs(db) do
		if name then
			-- Added Alpha Option
			if db[name].alpha == nil then
				db[name].alpha = S.CustomGraphicsDefaults.alpha
				newDBEntry = true
			end

			-- Added Draw Layer
			if db[name].drawLayer == nil then
				db[name].drawLayer = S.CustomGraphicsDefaults.drawLayer
				newDBEntry = true
			end
			-- Added Draw Level
			if db[name].drawLevel == nil then
				db[name].drawLevel = S.CustomGraphicsDefaults.drawLevel
				newDBEntry = true
			end
		end
	end
	if newDBEntry then
		SLE:Print('S&L AFK: Your custom graphics database entries have been updated with new defaults.', 'info')
		newDBEntry = false
	end
end

S.afkMusic = {
	CLASS = {
		['WARRIOR'] = 1417334,
		['PALADIN'] = 1417342, --443289
		['HUNTER'] = 1417326,
		['ROGUE'] = 1417273,
		['PRIEST'] = 1417367,
		['DEATHKNIGHT'] = 229831,
		['SHAMAN'] = 528163,
		['MAGE'] = 1417264,
		['WARLOCK'] = 1417356,
		['MONK'] = 642138,
		['DRUID'] = 1417312,
		['DEMONHUNTER'] = 1417290,
		['EVOKER'] = 1417290,
	},
	RACIAL = {
		['Human'] = 53210,
		['Gnome'] = 369055,
		['NightElf'] = 441709,
		['KulTiran'] = 1781897,
		['Dwarf'] = 298910,
		['Draenei'] = 53284,
		['Worgen'] = 441525,
		['VoidElf'] = 1864282,
		['LightforgedDraenei'] = 1864285,
		['DarkIronDwarf'] = 441566,
		['Mechagnome'] = 3028751,
		['Orc'] = 441713,
		['Scourge'] = 53217,
		['Tauren'] = 441788,
		['Troll'] = 371378,
		['Goblin'] = 441627,
		['BloodElf'] = 53473,
		['Pandaren'] = 642246,
		['Nightborne'] = 1477339,
		['HighmountainTauren'] = 1417319,
		['ZandalariTroll'] = 2844635,
		['Vulpera'] = 3260632,
		['MagharOrc'] = 2146630,
		['Dracthyr'] = 2146630,
	},
}

local originalMusicSetting
function S:RunAFKMusic()
	if S.db.musicSelection == 'NONE' then return end

	local selectionData = S.db.musicSelection == 'CLASS' and E.myclass or E.myrace
	if not S.afkMusic[S.db.musicSelection][selectionData] then return end

	if AFK.isSLAFK then
		originalMusicSetting = GetCVar('Sound_EnableMusic')
		if originalMusicSetting == '0' then SetCVar('Sound_EnableMusic', 1) end

		PlayMusic(S.afkMusic[S.db.musicSelection][selectionData])
	else
		StopMusic()
		SetCVar('Sound_EnableMusic', originalMusicSetting)
	end
end

--Template functons for animation types
function S:SlideIn(frame)
	if not frame.anim then frame.anim = CreateAnimationGroup(frame) end
	if not frame.anim.SlideIn then
		frame.anim.SlideIn = frame.anim:CreateAnimation('Move')
		frame.anim.SlideIn:SetRounded(false)
		tinsert(S.Animations, frame.anim.SlideIn)
	end
end

function S:SlideSide(frame)
	if not frame.anim then frame.anim = CreateAnimationGroup(frame) end
	if not frame.anim.SlideSide then
		frame.anim.SlideSide = frame.anim:CreateAnimation('Move')
		frame.anim.SlideSide:SetRounded(false)
		tinsert(S.Animations, frame.anim.SlideSide)
	end
end

function S:FadeIn(frame)
	if not frame.anim then frame.anim = CreateAnimationGroup(frame) end
	if not frame.anim.FadeIn then
		frame.anim.FadeIn = frame.anim:CreateAnimation('Fade')
		frame.anim.FadeIn:SetChange(1)
		tinsert(S.Animations, frame.anim.FadeIn)
		if frame ~= AFK.AFKMode.SL_TopPanel or frame ~= AFK.AFKMode.SL_BottomPanel then
			tinsert(S.Fading, frame.anim.FadeIn)
		end
	end
end

--* Creat & Update Animations
function S:SetupAnimations()
	if not AFK.AFKMode.SL_TopPanel.anim then
		S:SlideIn(AFK.AFKMode.SL_TopPanel)
		S:SlideSide(AFK.AFKMode.SL_TopPanel)
		S:FadeIn(AFK.AFKMode.SL_TopPanel)

		S:SlideIn(AFK.AFKMode.SL_BottomPanel)
		S:SlideSide(AFK.AFKMode.SL_BottomPanel)
		S:FadeIn(AFK.AFKMode.SL_BottomPanel)

		if S.db.playermodel.enable then S:FadeIn(AFK.AFKMode.bottom.model) end

		for name in pairs(S.db.defaultGraphics) do
			if name == 'exPack' then
				S:FadeIn(AFK.AFKMode[name].texture)
			else
				S:FadeIn(AFK.AFKMode[name])
			end
		end

		for name in pairs(S.db.customGraphics) do
			if name then
				S:FadeIn(AFK.AFKMode['SL_CustomGraphics_'..name])
			end
		end

		for name in pairs(S.db.defaultTexts) do
			if name then
				S:FadeIn(AFK.AFKMode[name])
			end
		end

		S:FadeIn(AFK.AFKMode.chat)
	end

	--* Slide In Animation
	AFK.AFKMode.SL_TopPanel.anim.SlideIn:SetEasing(S.db.animBounce and 'Bounce' or 'None')
	AFK.AFKMode.SL_BottomPanel.anim.SlideIn:SetEasing(S.db.animBounce and 'Bounce' or 'None')

	--* Slide Side Animation
	AFK.AFKMode.SL_TopPanel.anim.SlideSide:SetEasing(S.db.animBounce and 'Bounce' or 'None')
	AFK.AFKMode.SL_BottomPanel.anim.SlideSide:SetEasing(S.db.animBounce and 'Bounce' or 'None')

	S:SetupType()
end

function S:Show()
	if not S.db.enable then return end

	if AFK.AFKMode.SL_TestModel:IsShown() then S:TestHide() end
	-- TipNum = random(1, #L["SLE_TIPS"])

	-- --Resizing chat
	-- AFK.AFKMode.chat:SetHeight(AFK.AFKMode.SL_TopPanel:GetHeight())
	AFK.AFKMode.chat:SetShown(S.db.chat.show)

	--Positioning model
	if S.db.playermodel.enable then
		AFK.AFKMode.bottom.model:SetAnimation(S.db.playermodel.anim)
		AFK.AFKMode.bottom.model:SetScript('OnAnimFinished', S.AnimFinished)
	else
		AFK.AFKMode.bottom.model:SetScript('OnAnimFinished', nil)
	end
	AFK.AFKMode.bottom.model:SetShown(S.db.playermodel.enable)

	AFK.AFKMode.bottom.model:SetCamDistanceScale(S.db.playermodel.distance)
	if AFK.AFKMode.bottom.model:GetFacing() ~= (S.db.playermodel.rotation / 60) then
		AFK.AFKMode.bottom.model:SetFacing(S.db.playermodel.rotation / 60)
	end

	--* Animations
	local screenWidth = ceil(GetScreenWidth())
	local topSpace = S.db.panels.top.width > 0 and (screenWidth-S.db.panels.top.width)/2 or 0
	local bottomSpace = S.db.panels.bottom.width > 0 and (screenWidth-S.db.panels.bottom.width)/2 or 0
	if S.db.animTime > 0 then
		if S.db.animType == 'SlideIn' then
			AFK.AFKMode.SL_TopPanel.anim.SlideIn:SetOffset(0, -S.db.panels.top.height)
			AFK.AFKMode.SL_BottomPanel.anim.SlideIn:SetOffset(0, S.db.panels.bottom.height)
		elseif S.db.animType == 'SlideSide' then
			AFK.AFKMode.SL_TopPanel.anim.SlideSide:SetOffset(screenWidth-topSpace, 0)
			AFK.AFKMode.SL_BottomPanel.anim.SlideSide:SetOffset(-(screenWidth-bottomSpace), 0)
		end

		AFK.AFKMode.SL_TopPanel.anim[S.db.animType]:SetDuration(S.db.animTime)
		AFK.AFKMode.SL_BottomPanel.anim[S.db.animType]:SetDuration(S.db.animTime)
		for i = 1, #(S.Fading) do
			S.Fading[i]:SetDuration(S.db.animTime)
		end

		AFK.AFKMode.SL_TopPanel.anim[S.db.animType]:Play()
		AFK.AFKMode.SL_BottomPanel.anim[S.db.animType]:Play()
		for i = 1, #(S.Fading) do
			S.Fading[i]:Play()
		end
	end
end

function S:Hide()
	if not S.db.enable or not E.db.general.afk then return end
	for i = 1, #(S.Animations) do --To avoid weird shit like S:SetupType was ignored when animations were interrupted in the go
		S.Animations[i]:Stop()
	end

	local alpha = (S.db.animTime > 0 and 0) or 1

	-- Default Logos
	for name in pairs(S.db.defaultGraphics) do
		if name == 'exPack' then
			AFK.AFKMode[name].texture:SetAlpha(alpha)
		else
			AFK.AFKMode[name]:SetAlpha(alpha)
		end
	end

	-- AFK.AFKMode.bottom.model:SetAlpha(S.db.enable and alpha or 1)
	AFK.AFKMode.bottom.model:SetAlpha(alpha)

	-- Default Texts
	for name in pairs(S.db.defaultTexts) do
		if name then
			AFK.AFKMode[name]:SetAlpha(alpha)
		end
	end

	-- Custom Graphics
	for name in pairs(S.db.customGraphics) do
		if name then
			AFK.AFKMode['SL_CustomGraphics_'..name]:SetAlpha((S.db.animTime > 0 and 0) or S.db.customGraphics[name].alpha)
		end
	end

	S:SetupType()
end

function S:SetupType()
	local enable = E.db.general.afk and S.db.enable
	if not enable then return end

	local screenWidth = ceil(GetScreenWidth())
	local topSpace = S.db.panels.top.width > 0 and (screenWidth-S.db.panels.top.width)/2 or 0
	local bottomSpace = S.db.panels.bottom.width > 0 and (screenWidth-S.db.panels.bottom.width)/2 or 0

	AFK.AFKMode.SL_TopPanel:ClearAllPoints()
	AFK.AFKMode.SL_BottomPanel:ClearAllPoints()

	if S.db.animTime > 0 then
		if S.db.animType == 'SlideIn' then
			AFK.AFKMode.SL_TopPanel:Point('BOTTOM', AFK.AFKMode, 'TOP', 0, E.Border)
			AFK.AFKMode.SL_BottomPanel:Point('TOP', AFK.AFKMode, 'BOTTOM', 0, -E.Border)

			AFK.AFKMode.SL_TopPanel:SetAlpha(1)
			AFK.AFKMode.SL_BottomPanel:SetAlpha(1)
		elseif S.db.animType == 'SlideSide' then
			AFK.AFKMode.SL_TopPanel:Point('TOP', AFK.AFKMode, 'TOP', -(screenWidth-topSpace), E.Border)
			AFK.AFKMode.SL_BottomPanel:Point('BOTTOM', AFK.AFKMode, 'BOTTOM', screenWidth-bottomSpace, -E.Border)

			AFK.AFKMode.SL_TopPanel:SetAlpha(1)
			AFK.AFKMode.SL_BottomPanel:SetAlpha(1)
		else
			AFK.AFKMode.SL_TopPanel:Point('TOP', AFK.AFKMode, 'TOP', 0, E.Border)
			AFK.AFKMode.SL_BottomPanel:Point('BOTTOM', AFK.AFKMode, 'BOTTOM', 0, -E.Border)

			AFK.AFKMode.SL_TopPanel:SetAlpha(0)
			AFK.AFKMode.SL_BottomPanel:SetAlpha(0)
		end
	else
		AFK.AFKMode.SL_TopPanel:Point('TOP', AFK.AFKMode, 'TOP', 0, E.Border)
		AFK.AFKMode.SL_BottomPanel:Point('BOTTOM', AFK.AFKMode, 'BOTTOM', 0, -E.Border)

		AFK.AFKMode.SL_TopPanel:SetAlpha(1)
		AFK.AFKMode.SL_BottomPanel:SetAlpha(1)
	end
end

--Testing model positioning
function S:TestShow()
	if testTimer then testTimer:Cancel() end

	AFK.AFKMode.SL_TestModel:Show()
	AFK.AFKMode.SL_TestModel:SetUnit('player')
	AFK.AFKMode.SL_TestModel:SetCamDistanceScale(S.db.playermodel.distance)
	if AFK.AFKMode.SL_TestModel:GetFacing() ~= (S.db.playermodel.rotation / 60) then
		AFK.AFKMode.SL_TestModel:SetFacing(S.db.playermodel.rotation / 60)
	end
	AFK.AFKMode.SL_TestModel:SetAnimation(S.db.playermodel.anim)
	AFK.AFKMode.SL_TestModel:SetScript('OnAnimFinished', S.AnimTestFinished)

	AFK.AFKMode.SL_BottomPanel:ClearAllPoints()
	AFK.AFKMode.SL_BottomPanel:Point('BOTTOM', AFK.AFKMode, 'BOTTOM', 0, -E.Border)

	testTimer = C_Timer.NewTimer(10, S.TestHide)
end

function S:TestHide()
	S:SetupType()
	AFK.AFKMode.SL_TestModel:Hide()
end

function S:AnimFinished()
	AFK.AFKMode.bottom.model:SetAnimation(S.db.playermodel.anim)
end

function S:AnimTestFinished()
	AFK.AFKMode.SL_TestModel:SetAnimation(S.db.playermodel.anim)
end

function S:KeyScript()--Dealing with on key down script
	-- if not S.db.enable or not E.db.general.afk then return end

	-- if S.db.enable and not S.db.keydown then
	-- 	AFK.AFKMode:SetScript('OnKeyDown', nil)

	-- elseif S.db.keydown then
	-- 	AFK.AFKMode:SetScript('OnKeyDown', S.OnKeyDown)
	-- end

	if S.db.enable then
		if S.db.keydown then
			AFK.AFKMode:SetScript('OnKeyDown', S.OnKeyDown)
		elseif not S.db.keydown then
			AFK.AFKMode:SetScript('OnKeyDown', nil)
		end
	else
		AFK.AFKMode:SetScript('OnKeyDown', S.OnKeyDown)
	end



	-- if S.db.keydown then
	-- 	--Default script for key detection. Ignores modifires and screenshot button
	-- 	AFK.AFKMode:SetScript('OnKeyDown', S.OnKeyDown)
	-- else
	-- 	-- SLE:Print('KeyScript Fired')
	-- 	AFK.AFKMode:SetScript('OnKeyDown', nil)
	-- end
end

function S:AbortAFK()
	if UnitIsAFK('player') then SendChatMessage('' ,'AFK' ) end
end

function S:SetAFK(status)
	if not E.db.sle.afk.enable or not E.db.general.afk then return end

	if status then
		MoveViewLeftStop() -- Stop ElvUI's Camera

		S.SL_startTime = GetTime()
		S:UpdateTextStrings()

		-- Own model animation
		-- AFK.AFKMode.bottom.model:SetUnit('player')
		AFK.AFKMode.bottom.model:SetAnimation(S.db.playermodel.anim)

		AFK.isSLAFK = true
		S:RunAFKMusic()
	elseif AFK.isSLAFK then
		FlipCameraYaw(-degree)
		degree = 0
		total_seconds = 0
		if S.db.defaultTexts.SL_AFKTimePassed.countdown then
			AFK.AFKMode.SL_AFKTimePassed:SetText('30:00')
		else
			AFK.AFKMode.SL_AFKTimePassed:SetText('00:00')
		end

		AFK.isSLAFK = false
		S:RunAFKMusic()
	end
end
hooksecurefunc(AFK, 'SetAFK', S.SetAFK)

function S:CreateUpdatePanels()
	local enable = E.db.general.afk and S.db.enable

	--* Top Panel
	do
		if not AFK.AFKMode.SL_TopPanel then
			AFK.AFKMode.SL_TopPanel = CreateFrame('Frame', nil, AFK.AFKMode, 'BackdropTemplate')
		end
		local width = S.db.panels.top.width == 0 and GetScreenWidth() or S.db.panels.top.width

		AFK.AFKMode.SL_TopPanel:SetFrameLevel(0)
		AFK.AFKMode.SL_TopPanel:SetTemplate(S.db.panels.top.template, true)
		AFK.AFKMode.SL_TopPanel:Point('TOP', AFK.AFKMode, 'TOP', 0, E.Border)
		AFK.AFKMode.SL_TopPanel:Width(width)
		AFK.AFKMode.SL_TopPanel:Height(S.db.panels.top.height)
		AFK.AFKMode.SL_TopPanel:SetTemplate(S.db.panels.top.template, true)
		AFK.AFKMode.SL_TopPanel:SetShown(enable)
	end

	--* Bottom Panel
	do
		if not AFK.AFKMode.SL_BottomPanel then
			AFK.AFKMode.SL_BottomPanel = CreateFrame('Frame', nil, AFK.AFKMode, 'BackdropTemplate')
		end
		local width = S.db.panels.bottom.width == 0 and GetScreenWidth() or S.db.panels.bottom.width

		AFK.AFKMode.SL_BottomPanel:SetFrameLevel(0)
		AFK.AFKMode.SL_BottomPanel:SetTemplate(S.db.panels.bottom.template, true)
		AFK.AFKMode.SL_BottomPanel:Point('BOTTOM', AFK.AFKMode, 'BOTTOM', 0, -E.Border)
		AFK.AFKMode.SL_BottomPanel:Width(width)
		AFK.AFKMode.SL_BottomPanel:Height(S.db.panels.bottom.height)
		AFK.AFKMode.SL_BottomPanel:SetTemplate(S.db.panels.bottom.template, true)
		AFK.AFKMode.SL_BottomPanel:SetShown(enable)
	end

	if not AFK.AFKMode.SL_ScrollFrame then
		AFK.AFKMode.SL_ScrollFrame = CreateFrame('ScrollingMessageFrame', nil, AFK.AFKMode)
	end
	AFK.AFKMode.SL_ScrollFrame:SetHeight(S.db.defaultTexts.SL_ScrollFrame.size+6)
	-- AFK.AFKMode.SL_ScrollFrame.bg:SetHeight(S.db.defaultTexts.SL_ScrollFrame.size+20)
	AFK.AFKMode.SL_ScrollFrame:SetFading(false)
	AFK.AFKMode.SL_ScrollFrame:SetFadeDuration(0)
	AFK.AFKMode.SL_ScrollFrame:SetTimeVisible(1)
	AFK.AFKMode.SL_ScrollFrame:SetMaxLines(1)
	AFK.AFKMode.SL_ScrollFrame:SetSpacing(2)
	AFK.AFKMode.SL_ScrollFrame:SetWidth(AFK.AFKMode.SL_BottomPanel:GetWidth()/2)

	--Update Chat
	AFK.AFKMode.chat:SetHeight(AFK.AFKMode.SL_TopPanel:GetHeight())
	AFK.AFKMode.chat:ClearAllPoints()
	AFK.AFKMode.chat:Point(S.db.chat.inversePoint and E.InversePoints[S.db.chat.anchorPoint] or S.db.chat.anchorPoint, AFK.AFKMode[S.db.chat.attachTo], S.db.chat.anchorPoint, S.db.chat.xOffset, S.db.chat.yOffset)
end

function S:CreateTextStrings()
	for element in next, E.db.sle.afk.defaultTexts do
		if element and element ~= 'SL_ScrollFrame' and not AFK.AFKMode[element] then
			AFK.AFKMode[element] = AFK.AFKMode:CreateFontString(nil, 'OVERLAY')
		end
	end
end

function S:UpdateTextOptions()
	local db = S.db.defaultTexts

	-- for element in next, E.db.sle.afk.defaultTexts do
	-- 	if element and element ~= 'SL_ScrollFrame' and not AFK.AFKMode[element] then
	-- 		AFK.AFKMode[element] = AFK.AFKMode:CreateFontString(nil, 'OVERLAY')
	-- 	end
	-- end

	for element in next, db do
		if element then
			local enable = (E.db.general.afk and S.db.enable and db[element].enable)

			AFK.AFKMode[element]:ClearAllPoints()
			AFK.AFKMode[element]:Point(db[element].inversePoint and E.InversePoints[db[element].anchorPoint] or db[element].anchorPoint, AFK.AFKMode[db[element].attachTo], db[element].anchorPoint, db[element].xOffset, db[element].yOffset)
			AFK.AFKMode[element]:FontTemplate(E.LSM:Fetch('font', db[element].font), db[element].size, db[element].outline)
			AFK.AFKMode[element]:SetShown(enable)

			if element == 'SL_ScrollFrame' then
				AFK.AFKMode.SL_ScrollFrame:LevelUpBG()
			end
		end
	end

	S:UpdateTextStrings()
end

function S:UpdateTextStrings()
	local level, name, classColor = E.mylevel, UnitPVPName('player'), E:ClassColor(E.myclass)
	local GuildName, GuildRank = GetGuildInfo('player')

	currentDateTime()

	AFK.AFKMode.SL_AFKMessage:SetText('|cff00AAFF'..L["You Are Away From Keyboard for"]..'|r')
	AFK.AFKMode.SL_AFKTimePassed:SetTextColor(1, 1, 1)
	AFK.AFKMode.SL_SubText:SetText(L["Take care of yourself, Master!"])
	AFK.AFKMode.SL_PlayerName:SetTextColor(classColor.r, classColor.g, classColor.b)
	AFK.AFKMode.SL_PlayerName:SetText(format('%s', name))
	AFK.AFKMode.SL_PlayerClass:SetTextColor(classColor.r, classColor.g, classColor.b)
	AFK.AFKMode.SL_PlayerClass:SetText(E.myLocalizedClass)
	AFK.AFKMode.SL_PlayerLevel:SetTextColor(1, 1, 1)
	AFK.AFKMode.SL_PlayerLevel:SetText(format('%s %s', LEVEL, level))
	AFK.AFKMode.SL_GuildName:SetTextColor(0.7, 0.7, 0.7)
	AFK.AFKMode.SL_GuildName:SetText(format(GuildName and '|cff00AAFF<%s>|r' or '', GuildName)) --Setting good looking guild name line
	AFK.AFKMode.SL_GuildRank:SetTextColor(1, 1, 1)
	AFK.AFKMode.SL_GuildRank:SetText(GuildRank or '')

	TipNum = random(1, #L["SLE_TIPS"])
	AFK.AFKMode.SL_ScrollFrame:AddMessage(L["SLE_TIPS"][TipNum], 1, 1, 1)
end

function S:CreateSetupCustomGraphics()
	UpdateCustomGraphicsDefaults()
	for name in next, E.db.sle.afk.customGraphics do
		if not AFK.AFKMode['SL_CustomGraphics_'..name] then
			S:CreateCustomGraphic(name)
		end
		S:UpdateCustomGraphic(name)
	end
end

function S:CreateCustomGraphic(name)
	if not name then return end

	if not AFK.AFKMode['SL_CustomGraphics_'..name] then
		AFK.AFKMode['SL_CustomGraphics_'..name] = AFK.AFKMode:CreateTexture(nil, 'ARTWORK')
	end
end

function S:UpdateCustomGraphics()
	for name in next, E.db.sle.afk.customGraphics do
		if AFK.AFKMode['SL_CustomGraphics_'..name] then
			S:UpdateCustomGraphic(name)
		end
	end
end

function S:UpdateCustomGraphic(name)
	if not name then return end

	if not AFK.AFKMode['SL_CustomGraphics_'..name] then
		S:CreateCustomGraphic(name)
	end

	local db = S.db.customGraphics
	local element = 'SL_CustomGraphics_'..name
	local enable = S.db.enable and S.db.customGraphics[name].enable

	AFK.AFKMode[element]:SetSize(db[name].width, db[name].height)
	AFK.AFKMode[element]:SetTexture(db[name].path)
	AFK.AFKMode[element]:SetAlpha(db[name].alpha)
	AFK.AFKMode[element]:SetDrawLayer(db[name].drawLayer, db[name].drawLevel)
	AFK.AFKMode[element]:ClearAllPoints()
	AFK.AFKMode[element]:Point(db[name].inversePoint and E.InversePoints[db[name].anchorPoint] or db[name].anchorPoint, AFK.AFKMode[db[name].attachTo], db[name].anchorPoint, db[name].xOffset, db[name].yOffset)
	AFK.AFKMode[element]:SetShown(enable)
end

function S:DeleteCustomGraphic(name)
	if E.db.sle.afk.customGraphics[name] then
		E.db.sle.afk.customGraphics[name] = nil
		AFK.AFKMode['SL_CustomGraphics_'..name]:SetTexture(nil)
		AFK.AFKMode['SL_CustomGraphics_'..name]:Hide()
	end
end

function S:SetupDefaultGraphics()
	for name in next, E.db.sle.afk.defaultGraphics do
		if name and not AFK.AFKMode[name] then
			if name == 'exPack' then
				AFK.AFKMode.exPack = CreateFrame('Button', nil, AFK.AFKMode.SL_TopPanel)
				AFK.AFKMode.exPack:SetScript('OnClick', S.AbortAFK) --Allow to exit afk screen by clicking on the crest
				AFK.AFKMode.exPack.texture = AFK.AFKMode:CreateTexture(nil, 'OVERLAY')
			elseif name == 'slLogo' then
				AFK.AFKMode.slLogo = AFK.AFKMode:CreateTexture(nil, 'OVERLAY')
			else
				AFK.AFKMode[name] = AFK.AFKMode:CreateTexture(nil, 'ARTWORK')
			end
		end
	end
end

function S:UpdateDefaultGraphics()
	local db = S.db.defaultGraphics

	for element in next, E.db.sle.afk.defaultGraphics do
		if element then
			local enable = S.db.enable and db[element].enable

			AFK.AFKMode[element]:ClearAllPoints()
			AFK.AFKMode[element]:Point(db[element].inversePoint and E.InversePoints[db[element].anchorPoint] or db[element].anchorPoint, AFK.AFKMode[db[element].attachTo], db[element].anchorPoint, db[element].xOffset, db[element].yOffset)
			AFK.AFKMode[element]:SetSize(db[element].width, db[element].height)

			if element == 'exPack' then
				AFK.AFKMode[element].texture:SetShown(enable)
			else
				AFK.AFKMode[element]:SetShown(enable)
			end
		end
	end

	AFK.AFKMode.classCrest:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\classes\\'..db.classCrest.styleOptions..'\\'..E.myclass)

	local path = 'Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\expansion\\'..db.exPack.styleOptions..'\\'..db.exPack.expansion
	if db.exPack.expansion == 'auto' or not SLE:TextureExists(path) then
		AFK.AFKMode.exPack.texture:SetTexture(GetExpansionDisplayInfo(GetClientDisplayExpansionLevel()).logo)
	else
		AFK.AFKMode.exPack.texture:SetTexture(path)
	end
	AFK.AFKMode.exPack.texture:SetAllPoints(AFK.AFKMode.exPack)
	AFK.AFKMode.factionCrest:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\factioncrest\\'..db.factionCrest.styleOptions..'\\'..E.myfaction)
	AFK.AFKMode.factionLogo:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\factionlogo\\'..db.factionLogo.styleOptions..'\\'..E.myfaction)
	AFK.AFKMode.raceCrest:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\race\\'..db.raceCrest.styleOptions..'\\'..E.myrace)
	AFK.AFKMode.slLogo:SetTexture([[Interface\AddOns\ElvUI_SLE\media\textures\afk\addonlogos\sl\original\S&L]])
	AFK.AFKMode.benikuiLogo:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\addonlogos\\benikui\\'..db.benikuiLogo.styleOptions..'\\BenikUI')
	AFK.AFKMode.merauiLogo:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\addonlogos\\meraui\\'..db.merauiLogo.styleOptions..'\\MerathilisUI')
	AFK.AFKMode.elvuiLogo:SetTexture('Interface\\AddOns\\ElvUI_SLE\\media\\textures\\afk\\addonlogos\\elvui\\'..db.elvuiLogo.styleOptions..'\\ElvUI')
end

function S:CreateUpdateModelElements(skip)
	AFK.AFKMode.bottom.modelHolder:ClearAllPoints()
	if S.db.enable then
		AFK.AFKMode.bottom.model:SetScript('OnUpdate', nil)
		AFK.AFKMode.bottom.model:SetParent(AFK.AFKMode)
		AFK.AFKMode.bottom.modelHolder:Point('BOTTOMRIGHT', AFK.AFKMode.SL_BottomPanel, 'BOTTOMRIGHT', -200+S.db.playermodel.holderXoffset, (220 + S.db.playermodel.holderYoffset))
	else
		AFK.AFKMode.bottom.model:SetScript('OnUpdate', S.OrigModelOnUpdate)
		AFK.AFKMode.bottom.model:SetParent(AFK.AFKMode.bottom.modelHolder)
		AFK.AFKMode.bottom.model:SetAlpha(1)
		AFK.AFKMode.bottom.modelHolder:Point('BOTTOMRIGHT', AFK.AFKMode.bottom, 'BOTTOMRIGHT', -200, 220)
	end

	if skip then return end
	--S&L Test Model
	if not AFK.AFKMode.SL_TestModel then
		AFK.AFKMode.SL_TestModel = CreateFrame('PlayerModel', 'SLE_ScreenTestModel', E.UIParent)
	end
	-- AFK.AFKMode.SL_TestModel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
	AFK.AFKMode.SL_TestModel:Size(GetScreenWidth() * 2, GetScreenHeight() * 2)
	AFK.AFKMode.SL_TestModel:Point('CENTER', AFK.AFKMode.bottom.model)
	AFK.AFKMode.SL_TestModel:Hide()
end

function S:Toggle()
	if S.db.enable then
		AFK.AFKMode.bottom:Hide() --* Hide ElvUI's Bottom Panel
		AFK.AFKMode.bottom.LogoTop:Hide() --* Hide ElvUI's Top Logo Piece
		AFK.AFKMode.bottom.LogoBottom:Hide() --* Hide ElvUI's Bottom Logo Piece
		if not AFK.AFKMode:GetScript('OnUpdate') then
			AFK.AFKMode:SetScript('OnUpdate', function(_, elapsed)
				if not AFK.isAFK then return end

				timerLastUpdate = timerLastUpdate + elapsed

				if (timerLastUpdate > 1.0) then
					total_seconds = total_seconds + 1

					local minutes = floor(total_seconds/60)
					local neg_seconds = -total_seconds % 60
					local seconds = total_seconds % 60

					if S.db.defaultTexts.SL_AFKTimePassed.countdown then
						if minutes - 29 == 0 and floor(neg_seconds) == 0 then
							AFK.AFKMode.SL_AFKTimePassed:SetFormattedText("%s: |cfff0ff0000:00|r", L["Logout Timer"])
						else
							AFK.AFKMode.SL_AFKTimePassed:SetFormattedText("%02d:%02d", minutes -29, neg_seconds)
						end
					else
						AFK.AFKMode.SL_AFKTimePassed:SetFormattedText('%02d:%02d', minutes, seconds)
					end

					currentDateTime()
					timerLastUpdate = 0
				end

				tipsLastUpdate = tipsLastUpdate + elapsed
				if tipsLastUpdate > S.db.tipThrottle then
					TipNum = random(1, #L["SLE_TIPS"])

					while TipNum == OldTip do
						TipNum = random(1, #L["SLE_TIPS"])
					end

					AFK.AFKMode.SL_ScrollFrame:AddMessage(L["SLE_TIPS"][TipNum], 1, 1, 1)
					OldTip = TipNum

					tipsLastUpdate = 0
				end

				FlipCameraYaw(elapsed * degreeMultyplier)
				degree = degree + elapsed * degreeMultyplier
			end)
		end
		S:CreateUpdatePanels()
		S:CreateTextStrings()
		S:UpdateTextOptions()
		S:SetupDefaultGraphics()
		S:UpdateDefaultGraphics()
		S:CreateSetupCustomGraphics()
		-- S:ModelHolderPos()
		S:CreateUpdateModelElements()
		S:SetupAnimations()
	-- else
	-- 	AFK.AFKMode:SetScript('OnUpdate', nil)
	-- 	AFK.AFKMode.bottom:Show() --* Show ElvUI's Bottom Panel
	-- 	AFK.AFKMode.bottom.LogoTop:Show() --* Show ElvUI's Top Logo Piece
	-- 	AFK.AFKMode.bottom.LogoBottom:Show() --* Show ElvUI's Bottom Logo Piece
	end
	-- S:CreateUpdatePanels()
	-- S:CreateTextStrings()
	-- S:UpdateTextOptions()
	-- S:SetupDefaultGraphics()
	-- S:UpdateDefaultGraphics()
	-- S:CreateSetupCustomGraphics()
	-- -- S:ModelHolderPos()
	-- S:CreateUpdateModelElements()
	-- S:SetupAnimations()
end

function S:Initialize()
	if not SLE.initialized then return end

	S.db = E.db.sle.afk
	S.OnKeyDown = AFK.AFKMode:GetScript('OnKeyDown')
	S.OrigModelOnUpdate = AFK.AFKMode.bottom.model:GetScript('OnUpdate')

	if not S.db.enable then return end

	function S:ForUpdateAll()
		S.db = E.db.sle.afk

		S:Toggle()
		S:Hide()
		S:KeyScript()
	end

	S:ForUpdateAll()

	AFK.AFKMode:HookScript('OnShow', S.Show)
	AFK.AFKMode:HookScript('OnHide', S.Hide)
end

SLE:RegisterModule(S:GetName())
