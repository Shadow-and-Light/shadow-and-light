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

local function ZoneTextPos()
	_G.SubZoneTextString:ClearAllPoints()
	if ( _G.PVPInfoTextString:GetText() == '' ) then
		_G.SubZoneTextString:SetPoint('TOP', 'ZoneTextString', 'BOTTOM', 0, -E.db.sle.media.fonts.subzone.offset)
	else
		_G.SubZoneTextString:SetPoint('TOP', 'PVPInfoTextString', 'BOTTOM', 0, -E.db.sle.media.fonts.subzone.offset)
	end
end

local function MakeFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

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

function M:SetBlizzFonts()
	if not E.private.general.replaceBlizzFonts then return end
	local db = E.db.sle.media.fonts

	for frame, option in pairs(fontFrames) do
		if _G[frame] then
			_G[frame]:SetFont(E.LSM:Fetch('font', db[option].font), db[option].size, frame ~= 'QuestFont' and db[option].outline or '')
		end
	end

	--Objective Frame
	if SLE._Compatibility['ElvUI_MerathilisUI'] and E.db.mui.blizzard.objectiveTracker.enable then return end

	local COLOR
	if E.db.sle.skins.objectiveTracker.classHeader then
		COLOR = ClassColor
	else
		COLOR = E.db.sle.skins.objectiveTracker.colorHeader
	end

	if not _G.ObjectiveTrackerFrame.SLEHookedFonts then
		hooksecurefunc('ObjectiveTracker_Update', function(reason, id)
			local widgetFrames = _G.ScenarioStageBlock.WidgetContainer.widgetFrames
			if widgetFrames then
				for widgetID, frame in pairs(widgetFrames) do
					if skinnableWidgets[widgetID] and (frame and frame.HeaderText) then
						frame.HeaderText:SetFont(E.LSM:Fetch('font', db.objectiveTracker.scenarioStage.HeaderText.font), db.objectiveTracker.scenarioStage.HeaderText.fontSize, db.objectiveTracker.scenarioStage.HeaderText.fontOutline)
						if frame.Timer and frame.Timer.Text then
							frame.Timer.Text:SetFont(E.LSM:Fetch('font', db.objectiveTracker.scenarioStage.TimerText.font), db.objectiveTracker.scenarioStage.TimerText.fontSize, db.objectiveTracker.scenarioStage.TimerText.fontOutline)
						end
					end
				end
			end

			-- _G["ObjectiveTrackerFrame"].HeaderMenu.Title:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.ScenarioStageBlock.Stage:SetFont(E.LSM:Fetch('font', db.objectiveTracker.scenarioStage.HeaderText.font), db.objectiveTracker.scenarioStage.HeaderText.fontSize, db.objectiveTracker.scenarioStage.HeaderText.fontOutline)
			_G.ObjectiveTrackerBlocksFrame.CampaignQuestHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.ObjectiveTrackerBlocksFrame.ProfessionHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.WORLD_QUEST_TRACKER_MODULE.Header.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
			_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
		end)
		_G.ObjectiveTrackerFrame.SLEHookedFonts = true
	end

	local widgetFrames = _G.ScenarioStageBlock.WidgetContainer.widgetFrames
	if widgetFrames then
		for widgetID, frame in pairs(widgetFrames) do
			if skinnableWidgets[widgetID] and (frame and frame.HeaderText) then
				frame.HeaderText:SetFont(E.LSM:Fetch('font', db.objectiveTracker.scenarioStage.HeaderText.font), db.objectiveTracker.scenarioStage.HeaderText.fontSize, db.objectiveTracker.scenarioStage.HeaderText.fontOutline)
				if frame.Timer and frame.Timer.Text then
					frame.Timer.Text:SetFont(E.LSM:Fetch('font', db.objectiveTracker.scenarioStage.TimerText.font), db.objectiveTracker.scenarioStage.TimerText.fontSize, db.objectiveTracker.scenarioStage.TimerText.fontOutline)
				end
			end
		end
	end
	_G.ScenarioStageBlock.Stage:SetFont(E.LSM:Fetch('font', db.objectiveTracker.scenarioStage.HeaderText.font), db.objectiveTracker.scenarioStage.HeaderText.fontSize, db.objectiveTracker.scenarioStage.HeaderText.fontOutline)
	-- _G.ScenarioStageBlock.Stage:SetTextColor(COLOR.r, COLOR.g, COLOR.b)

	_G.ObjectiveTrackerFrame.HeaderMenu.Title:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.ObjectiveTrackerBlocksFrame.CampaignQuestHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.ObjectiveTrackerBlocksFrame.ProfessionHeader.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.WORLD_QUEST_TRACKER_MODULE.Header.Text:SetFont(E.LSM:Fetch('font', db.objectiveHeader.font), db.objectiveHeader.size, db.objectiveHeader.outline)
	_G.ObjectiveTrackerFrame.HeaderMenu.Title:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.ObjectiveTrackerBlocksFrame.CampaignQuestHeader.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.ObjectiveTrackerBlocksFrame.AchievementHeader.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.ObjectiveTrackerBlocksFrame.ScenarioHeader.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.ObjectiveTrackerBlocksFrame.ProfessionHeader.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)
	_G.WORLD_QUEST_TRACKER_MODULE.Header.Text:SetTextColor(COLOR.r, COLOR.g, COLOR.b)

	MakeFont(_G.ObjectiveFont, E.LSM:Fetch('font', db.objective.font), db.objective.size, db.objective.outline)
	if M.BonusObjectiveBarText then M.BonusObjectiveBarText:SetFont(E.LSM:Fetch('font', db.objective.font), db.objective.size, db.objective.outline) end

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
