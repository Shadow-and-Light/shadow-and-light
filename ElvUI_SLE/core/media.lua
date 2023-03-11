local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local M = SLE.Media

--GLOBALS: hooksecurefunc
local _G = _G
local random = random
local FadingFrame_Show = FadingFrame_Show

M.Zones = L["SLE_MEDIA_ZONES"]
M.PvPInfo = L["SLE_MEDIA_PVP"]
M.Subzones = L["SLE_MEDIA_SUBZONES"]
M.PVPArena = L["SLE_MEDIA_PVPARENA"]

local ClassColor = RAID_CLASS_COLORS[E.myclass]

local Colors = {
	[1] = {0.41, 0.8, 0.94}, -- sanctuary
	[2] = {1.0, 0.1, 0.1}, -- hostile
	[3] = {0.1, 1.0, 0.1}, --friendly
	[4] = {1.0, 0.7, 0}, --contested
	[5] = {1.0, 0.9294, 0.7607}, --white
}

local skinnableWidgets = {
	[1217] = true, --Alliance warfront BfA
	[1329] = true, --Horde warfront BfA
	[2319] = true,
	[3302] = true,
	[4324] = true,
}

local fontFrames = {
	ZoneTextString = 'zone', -- Zone Name
	SubZoneTextString = 'subzone', -- SubZone Name
	PVPInfoTextString = 'pvp', -- PvP status for main zone
	PVPArenaTextString = 'pvp', -- PvP status for subzone
	SendMailBodyEditBox = 'mail', --Writing letter text
	-- OpenMailBodyText = 'mail',  -- Received letter text --! Seems to be bugged atm
	QuestFont = 'gossip', -- Quest Log/Petitions --! Looks terrible with an outline set, so it is skipped in M:SetBLizzFonts()
	QuestFont_Super_Huge = 'questFontSuperHuge', -- Not Sure Which One This Is
	QuestFont_Enormous = 'questFontSuperHuge', -- Not Sure Which One This Is
}

local objectiveFrames = {
	ObjectiveTrackerBlocksFrame = { 'CampaignQuestHeader', 'QuestHeader', 'AchievementHeader', 'ScenarioHeader', 'ProfessionHeader', 'MonthlyActivitiesHeader' },
	BONUS_OBJECTIVE_TRACKER_MODULE = 'Header',
	WORLD_QUEST_TRACKER_MODULE = 'Header',
}

local function ZoneTextPos()
	_G.SubZoneTextString:ClearAllPoints()
	if ( _G.PVPInfoTextString:GetText() == '' ) then
		_G.SubZoneTextString:SetPoint('TOP', 'ZoneTextString', 'BOTTOM', 0, -E.db.sle.media.fonts.subzone.offset)
	else
		_G.SubZoneTextString:SetPoint('TOP', 'PVPInfoTextString', 'BOTTOM', 0, -E.db.sle.media.fonts.subzone.offset)
	end
end

local function MakeFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:FontTemplate(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

local function SetObjectiveFrameFonts()
	local db = E.db.sle.media.fonts
	local COLOR

	if E.db.sle.skins.objectiveTracker.classHeader then
		COLOR = ClassColor
	else
		COLOR = E.db.sle.skins.objectiveTracker.colorHeader
	end

	for frame, children in pairs(objectiveFrames) do
		if _G[frame] then
			if type(children) == 'table' then
				for _, child in pairs(children) do
					if _G[frame][child] then
						_G[frame][child].Text:FontTemplate(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.fontSize, db.objectiveHeader.fontOutline)
						_G[frame][child].Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
					end
				end
			else
				_G[frame][children].Text:FontTemplate(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.fontSize, db.objectiveHeader.fontOutline)
				_G[frame][children].Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end

	local widgetFrames = _G.ScenarioStageBlock.WidgetContainer.widgetFrames
	if widgetFrames then
		for widgetID, frame in pairs(widgetFrames) do
			if skinnableWidgets[widgetID] and (frame and frame.HeaderText) then
				frame.HeaderText:FontTemplate(E.LSM:Fetch('font', db.scenarioStage.HeaderText.font), db.scenarioStage.HeaderText.fontSize, db.scenarioStage.HeaderText.fontOutline)
				if frame.Timer and frame.Timer.Text then
					frame.Timer.Text:FontTemplate(E.LSM:Fetch('font', db.scenarioStage.TimerText.font), db.scenarioStage.TimerText.fontSize, db.scenarioStage.TimerText.fontOutline)
				end
			end
		end
	end

	_G.ScenarioStageBlock.Stage:FontTemplate(E.LSM:Fetch('font', db.scenarioStage.HeaderText.font), db.scenarioStage.HeaderText.fontSize, db.scenarioStage.HeaderText.fontOutline)
end

function M:SetBlizzFonts()
	if not E.private.general.replaceBlizzFonts then return end
	local db = E.db.sle.media.fonts

	for frame, option in pairs(fontFrames) do
		if _G[frame] then
			if frame == 'QuestFont' then
				_G[frame]:FontTemplate(E.LSM:Fetch('font', db[option].font), db[option].fontSize, 'NONE')
				_G[frame]:SetShadowOffset(0, 0)
				_G[frame]:SetShadowColor(0, 0, 0, 0)
			else
				_G[frame]:FontTemplate(E.LSM:Fetch('font', db[option].font), db[option].fontSize, db[option].fontOutline)
			end
		end
	end

	--* Objective Frame
	-- Try to reduce addon conflicts when MerathilisUI addon is enabled as well as their option to alter the objective tracker is enabled
	if SLE._Compatibility['ElvUI_MerathilisUI'] and E.db.mui.blizzard.objectiveTracker.enable then return end

	local COLOR
	if E.db.sle.skins.objectiveTracker.classHeader then
		COLOR = ClassColor
	else
		COLOR = E.db.sle.skins.objectiveTracker.colorHeader
	end

	if not _G.ObjectiveTrackerFrame.SLEHookedFonts then
		hooksecurefunc('ObjectiveTracker_Update', SetObjectiveFrameFonts)
		_G.ObjectiveTrackerFrame.SLEHookedFonts = true
	end

	SetObjectiveFrameFonts()
	MakeFont(_G.ObjectiveFont, E.LSM:Fetch('font', db.objective.font), db.objective.fontSize, db.objective.fontOutline)

	-- _G.ScenarioStageBlock.Stage:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.ObjectiveTrackerFrame.HeaderMenu.Title:FontTemplate(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.fontSize, db.objectiveHeader.fontOutline)
	_G.ObjectiveTrackerFrame.HeaderMenu.Title:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	if M.BonusObjectiveBarText then M.BonusObjectiveBarText:FontTemplate(E.LSM:Fetch('font', db.objective.font), db.objective.fontSize, db.objective.fontOutline) end
end

function M:TextShow()
	local z, i, a, s, c = random(1, #M.Zones), random(1, #M.PvPInfo), random(1, #M.PVPArena), random(1, #M.Subzones), random(1, #Colors)
	local red, green, blue = unpack(Colors[c])

	--Setting texts--
	_G.ZoneTextString:SetText(M.Zones[z])
	_G.PVPInfoTextString:SetText(M.PvPInfo[i])
	_G.PVPArenaTextString:SetText(M.PVPArena[a])
	_G.SubZoneTextString:SetText(M.Subzones[s])

	ZoneTextPos()

	--Applying colors--
	_G.ZoneTextString:SetTextColor(red, green, blue)
	_G.PVPInfoTextString:SetTextColor(red, green, blue)
	_G.PVPArenaTextString:SetTextColor(red, green, blue)
	_G.SubZoneTextString:SetTextColor(red, green, blue)

	FadingFrame_Show(_G.ZoneTextFrame)
	FadingFrame_Show(_G.SubZoneTextFrame)
end

function M:Initialize()
	if not SLE.initialized or not E.private.sle.media.enable then return end
	hooksecurefunc(E, 'UpdateBlizzardFonts', M.SetBlizzFonts)
	hooksecurefunc('SetZoneText', ZoneTextPos)
	M.SetBlizzFonts()
end

SLE:RegisterModule(M:GetName())
