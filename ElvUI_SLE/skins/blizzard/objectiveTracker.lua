local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E.Skins
local Sk = SLE.Skins
local ENH = SLE.EnhancedShadows

-- GLOBALS: C_Scenario, BonusObjectiveTrackerProgressBar_PlayFlareAnim, hooksecurefunc, CreateFrame
local _G = _G

local IsAddOnLoaded = IsAddOnLoaded
local ScenarioStageBlock = ScenarioStageBlock
local ScenarioProvingGroundsBlock = ScenarioProvingGroundsBlock
local ScenarioProvingGroundsBlockAnim = ScenarioProvingGroundsBlockAnim

local classColor = RAID_CLASS_COLORS[E.myclass]
local width = 190
local dummy = function() return end
local underlines = {}
local skinnableWidgets = {
	[1217] = true, --Alliance warfront BfA
	[1329] = true, --Horde warfront BfA
	[2319] = true,
	[3302] = true,
}
local Chest3_Mult = 0.6
local Chest2_Mult = 0.8

function Sk:Update_ObjectiveTrackerUnderlinesVisibility()
	local exe = E.db.sle.skins.objectiveTracker.underline and 'Show' or 'Hide'
	for i = 1, #underlines do
		underlines[i][exe](underlines[i])
	end
end

function Sk:Update_ObjectiveTrackerUnderlinesColor()
	local colorBar
	if E.db.sle.skins.objectiveTracker.underlineClass then
		colorBar = classColor
	else
		colorBar = E.db.sle.skins.objectiveTracker.underlineColor
	end
	for i = 1, #underlines do
		underlines[i].Texture:SetVertexColor(colorBar.r, colorBar.g, colorBar.b)
	end
end

-- Objective Tracker Bar
local function skinObjectiveBar(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon
	local flare = progressBar.FullBarFlare1


	if not progressBar.sle_skinned then
		local label = bar.Label

		bar.BarBG:Hide()
		bar.BarFrame:Hide()
		bar.BarFrame2:Hide()
		bar.BarFrame3:Hide()
		bar.BarGlow:Kill()

		bar:SetStatusBarTexture(E.LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
		local COLOR
		if E.private.sle.skins.objectiveTracker.class then
			COLOR = classColor
		else
			COLOR = E.private.sle.skins.objectiveTracker.color
		end
		bar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
		bar:CreateBackdrop('Transparent')
		bar.backdrop:Point("TOPLEFT", bar, -1, 1)
		bar.backdrop:Point("BOTTOMRIGHT", bar, 1, -1)
		bar:SetFrameStrata('HIGH')

		flare:Hide()

		label:ClearAllPoints()
		label:SetPoint("CENTER", bar, "CENTER", 0, -1)
		label:FontTemplate(E.LSM:Fetch('font', E.db.sle.media.fonts.objective.font), E.db.sle.media.fonts.objective.size, E.db.sle.media.fonts.objective.outline)
		SLE.Media.BonusObjectiveBarText = label

		BonusObjectiveTrackerProgressBar_PlayFlareAnim = dummy
		progressBar.sle_skinned = true
	end

	bar.IconBG:Hide()
end

-- Objective Tracker from ObbleYeah - Modified to fit my style

-- Timer bars. Seems to work atm. must still take a look at it.
local function SkinTimerBar(self, block, line)
	local tb = self.usedTimerBars[block] and self.usedTimerBars[block][line]

	if tb and tb:IsShown() and not tb.skinned then
		tb.Bar.BorderMid:Hide()
		tb.Bar:StripTextures()
		tb.Bar:CreateBackdrop('Transparent')
		tb.Bar.backdrop:Point('TOPLEFT', tb.Bar, -1, 1)
		tb.Bar.backdrop:Point('BOTTOMRIGHT', tb.Bar, 1, -1)
		tb.Bar:SetStatusBarTexture(E.LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
		local COLOR
		if E.private.sle.skins.objectiveTracker.class then
			COLOR = classColor
		else
			COLOR = E.private.sle.skins.objectiveTracker.color
		end
		tb.Bar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
		tb.skinned = true
	end
end

-- Scenario buttons
local function SkinScenarioButtons()
	local block = ScenarioStageBlock

	--  TODO:  Shouldn't need this since you aren't using any of the variables u set Darth
	-- local _, currentStage, numStages, flags = C_Scenario.GetInfo()

	-- we have to independently resize the artwork
	-- because we're messing with the tracker width >_>
	if not block.SLE_Block then
		block.SLE_Block = CreateFrame('Frame', 'ScenarioStageBlock_SLE_Block', block)
		block.SLE_Block:ClearAllPoints()
		block.SLE_Block:Point('TOPLEFT', block, 5, -5)
		block.SLE_Block:Point('BOTTOMRIGHT', block.NormalBG, -5, 0)
		block.SLE_Block:CreateBackdrop('Transparent', nil, nil, nil, nil, nil, true)
		block.SLE_Block:SetFrameStrata('BACKGROUND')

		ENH:ProcessShadow(block.SLE_Block, nil, block.SLE_Block:GetFrameLevel(), E.db.sle.shadows.objectiveframe)
		ENH:HandleObjectiveFrame()

		block.SLE_Block.Logo = block.SLE_Block:CreateTexture(nil, 'OVERLAY')
		block.SLE_Block.Logo:SetPoint('BOTTOMRIGHT', block.SLE_Block, 'BOTTOMRIGHT', -5, 7)
		block.SLE_Block.Logo:SetPoint('TOPLEFT', block.SLE_Block, 'TOPRIGHT', -75, -7)
		block.SLE_Block.Logo:SetAlpha(0.3)

		block.SLE_Block:Hide()

		Sk.additionalTextures['ScenarioLogo'] = block.SLE_Block.Logo
		Sk:UpdateAdditionalTexture(Sk.additionalTextures['ScenarioLogo'], SLE.ScenarioBlockLogos[E.private.sle.skins.objectiveTracker.skinnedTextureLogo] or E.private.sle.skins.objectiveTracker.customTextureLogo)
	end

	if not E.private.sle.skins.objectiveTracker.scenarioBG then
		-- pop-up artwork
		block.NormalBG:Hide()

		-- pop-up final artwork
		block.FinalBG:Hide()

		if E.private.sle.skins.objectiveTracker.BGbackdrop then block.SLE_Block:Show() end
	end

	-- pop-up glow
	block.GlowTexture:Size(width + 20, 75)
	block.GlowTexture.AlphaAnim.Play = dummy
end

--Challengemode/M+
-- local function Scenario_ChallengeMode_ShowBlock(timerID, elapsedTime, timeLimit)
local function SkinChallengeModeBlock(timerID, elapsedTime, timeLimit)
	local block = ScenarioChallengeModeBlock

	if not block.SLE_Block then
		block.SLE_Block = CreateFrame('Frame', 'ScenarioStageBlock_SLE_Block', block)
		block.SLE_Block:ClearAllPoints()
		block.SLE_Block:Point('TOPLEFT', block, 5, -5)
		block.SLE_Block:Point('BOTTOMRIGHT', block.NormalBG, -13, 0)
		block.SLE_Block:CreateBackdrop('Transparent', nil, nil, nil, nil, nil, true)
		block.SLE_Block:SetFrameStrata('BACKGROUND')

		ENH:ProcessShadow(block.SLE_Block, nil, block.SLE_Block:GetFrameLevel(), E.db.sle.shadows.objectiveframe)
		ENH:HandleObjectiveFrame()

		block.SLE_Block.Logo = block.SLE_Block:CreateTexture(nil, 'OVERLAY')
		block.SLE_Block.Logo:SetPoint('TOPLEFT', block.SLE_Block, 'TOPRIGHT', -75, -7)
		block.SLE_Block.Logo:SetPoint('BOTTOMRIGHT', block.SLE_Block, 'BOTTOMRIGHT', -5, 7)
		block.SLE_Block.Logo:SetAlpha(0.3)

		block.SLE_Block:Hide()

		Sk.additionalTextures["ChallengeModeLogo"] = block.SLE_Block.Logo
		Sk:UpdateAdditionalTexture(Sk.additionalTextures["ChallengeModeLogo"], SLE.ScenarioBlockLogos[E.private.sle.skins.objectiveTracker.skinnedTextureLogo] or E.private.sle.skins.objectiveTracker.customTextureLogo)

		block.SLE_OverlayFrame = CreateFrame("Frame", "ScenarioStageBlock_SLE_Overlay", block)
		block.SLE_OverlayFrame.LimitText = block.SLE_OverlayFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
		block.SLE_OverlayFrame.LimitText:SetPoint("LEFT", block.TimeLeft, "RIGHT", 10, -2)
		block.SLE_OverlayFrame.LimitText2 = block.SLE_OverlayFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
		block.SLE_OverlayFrame.LimitText2:SetPoint("LEFT", block.SLE_OverlayFrame.LimitText, "RIGHT", 4, 0)
		block.SLE_OverlayFrame.LimitText:Hide()
		block.SLE_OverlayFrame.LimitText2:Hide()

		block.SLE_OverlayFrame.Mark2 = block.SLE_OverlayFrame:CreateTexture(nil,"OVERLAY")
		block.SLE_OverlayFrame.Mark2:SetPoint("TOPLEFT", block.StatusBar, "TOPLEFT", block.StatusBar:GetWidth() * (1 - Chest2_Mult) - 4, block.StatusBar:GetHeight())
		block.SLE_OverlayFrame.Mark2:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		block.SLE_OverlayFrame.Mark2:SetWidth(5)
		block.SLE_OverlayFrame.Mark2:SetBlendMode("ADD")
		block.SLE_OverlayFrame.Mark2:SetHeight(block.StatusBar:GetHeight()*3)

		block.SLE_OverlayFrame.Mark3 = block.SLE_OverlayFrame:CreateTexture(nil,"OVERLAY")
		block.SLE_OverlayFrame.Mark3:SetPoint("TOPLEFT", block.StatusBar, "TOPLEFT", block.StatusBar:GetWidth() * (1 - Chest3_Mult) - 4, block.StatusBar:GetHeight())
		block.SLE_OverlayFrame.Mark3:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		block.SLE_OverlayFrame.Mark3:SetWidth(5)
		block.SLE_OverlayFrame.Mark3:SetBlendMode("ADD")
		block.SLE_OverlayFrame.Mark3:SetHeight(block.StatusBar:GetHeight()*3)

		block.SLE_OverlayFrame.Mark3:SetShown(false)
		block.SLE_OverlayFrame.Mark2:SetShown(false)
	end

	if not E.private.sle.skins.objectiveTracker.scenarioBG then
		for i = 1, block:GetNumRegions() do
			local region = select(i, block:GetRegions())
			if region and region:IsObjectType('Texture') then --and region:IsObjectType(which) then
				if region:GetAtlas() == "ChallengeMode-Timer" then region:SetAlpha(0) end
			end
		end
		block.TimerBG:Kill()
		block.TimerBGBack:Kill()

		if E.private.sle.skins.objectiveTracker.BGbackdrop then block.SLE_Block:Show() end
	end
	local COLOR
	if E.private.sle.skins.objectiveTracker.class then
		COLOR = classColor
	else
		COLOR = E.private.sle.skins.objectiveTracker.color
	end
	S:HandleStatusBar(block.StatusBar, {COLOR.r, COLOR.g, COLOR.b})
end

local function UpdateChallengeModeTime(block, elapsedTime)
	if not block.SLE_Block then return end

	local time3 = block.timeLimit * Chest3_Mult
	local time2 = block.timeLimit * Chest2_Mult

	if E.private.sle.skins.objectiveTracker.keyTimers.showMarks then
		block.SLE_OverlayFrame.Mark3:SetShown(elapsedTime < time3)
		block.SLE_OverlayFrame.Mark2:SetShown(elapsedTime < time2)
	else
		block.SLE_OverlayFrame.Mark3:SetShown(false)
		block.SLE_OverlayFrame.Mark2:SetShown(false)
	end

	local timervalue, formatID, nextUpdate, remainder

	if elapsedTime < time3 then --3 chest timer
		timervalue, formatID, nextUpdate, remainder = E:GetTimeInfo(time3 - elapsedTime, 0, 60, 3600)
		block.SLE_OverlayFrame.LimitText:SetText(format(E.TimeFormats[formatID][1], timervalue, remainder))
		block.SLE_OverlayFrame.LimitText:SetTextColor(1, 0.843, 0)
		block.SLE_OverlayFrame.LimitText:Show()
		--2 chest timer if needed
		if E.private.sle.skins.objectiveTracker.keyTimers.showBothTimers then
			timervalue, formatID, nextUpdate, remainder = E:GetTimeInfo(time2 - elapsedTime, 0, 60, 3600)
			block.SLE_OverlayFrame.LimitText2:SetText(format(E.TimeFormats[formatID][1], timervalue, remainder))
			block.SLE_OverlayFrame.LimitText2:SetTextColor(0.78, 0.78, 0.812)
			block.SLE_OverlayFrame.LimitText2:Show()
		else
			block.SLE_OverlayFrame.LimitText2:Hide()
		end
	elseif elapsedTime < time2 then --2 chest timer
		timervalue, formatID, nextUpdate, remainder = E:GetTimeInfo(time2 - elapsedTime, 0, 60, 3600)
		block.SLE_OverlayFrame.LimitText:SetText(format(E.TimeFormats[formatID][1], timervalue, remainder))
		block.SLE_OverlayFrame.LimitText:SetTextColor(0.78, 0.78, 0.812)
		block.SLE_OverlayFrame.LimitText:Show()
		block.SLE_OverlayFrame.LimitText2:Hide()
	else
		block.SLE_OverlayFrame.LimitText:Hide()
		block.SLE_OverlayFrame.LimitText2:Hide()
	end
end

local function SkinAffixes(block,affixes)
	local num = #affixes
	for i = 1, num do
		local affixFrame = block.Affixes[i]
		local affixID = affixes[i]
		if affixFrame then
			if not affixFrame.SLE_Icon then
				affixFrame.SLE_Icon = affixFrame:CreateTexture(nil, "OVERLAY")
				affixFrame.SLE_Icon:SetAllPoints()
			end
			affixFrame:StripTextures()
			local _, _, filedataid = C_ChallengeMode.GetAffixInfo(affixID)
			affixFrame.SLE_Icon:SetTexture(filedataid)
			affixFrame.SLE_Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end
	end
end

--! Don't see a need for this, leaving commented out til after dbl checking b/c we are doinng this for no reason from what i can see since this is part of wow's functions
-- function ScenarioChallengeModeAffixMixin:SetUp(affixID)
-- 	local _, _, filedataid = C_ChallengeMode.GetAffixInfo(affixID)
-- 	SetPortraitToTexture(self.Portrait, filedataid)

-- 	self.affixID = affixID

-- 	self:Show()
-- end

-- Proving grounds
local function SkinProvingGroundButtons()
	local block = ScenarioProvingGroundsBlock
	local sb = block.StatusBar
	local anim = ScenarioProvingGroundsBlockAnim

	block.MedalIcon:Size(42, 42)
	block.MedalIcon:ClearAllPoints()
	block.MedalIcon:SetPoint("TOPLEFT", block, 20, -10)

	block.WaveLabel:ClearAllPoints()
	block.WaveLabel:SetPoint("LEFT", block.MedalIcon, "RIGHT", 3, 0)

	block.BG:Hide()
	block.BG:Size(width + 21, 75)

	block.GoldCurlies:Hide()
	block.GoldCurlies:ClearAllPoints()
	block.GoldCurlies:SetPoint("TOPLEFT", block.BG, 6, -6)
	block.GoldCurlies:SetPoint("BOTTOMRIGHT", block.BG, -6, 6)

	anim.BGAnim:Hide()
	anim.BGAnim:Size(width + 45, 85)
	anim.BorderAnim:Size(width + 21, 75)
	anim.BorderAnim:Hide()
	anim.BorderAnim:ClearAllPoints()
	anim.BorderAnim:SetPoint("TOPLEFT", block.BG, 8, -8)
	anim.BorderAnim:SetPoint("BOTTOMRIGHT", block.BG, -8, 8)

	-- Timer
	sb:StripTextures()
	sb:CreateBackdrop('Transparent')
	sb.backdrop:Point('TOPLEFT', sb, -1, 1)
	sb.backdrop:Point('BOTTOMRIGHT', sb, 1, -1)
	sb:SetStatusBarTexture(E.LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
	local COLOR
	if E.private.sle.skins.objectiveTracker.class then
		COLOR = classColor
	else
		COLOR = E.private.sle.skins.objectiveTracker.color
	end
	sb:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
	sb:ClearAllPoints()
	sb:SetPoint('TOPLEFT', block.MedalIcon, 'BOTTOMLEFT', -4, -5)
	sb:Size(200, 15)
end

local function ObjectiveReskin()
	if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.sle.skins.objectiveTracker.enable ~= true then return end
		-- Objective Tracker Bar
		hooksecurefunc(_G["BONUS_OBJECTIVE_TRACKER_MODULE"], "AddProgressBar", skinObjectiveBar)
		-- World Quests can be bonus objective type
		hooksecurefunc(_G["WORLD_QUEST_TRACKER_MODULE"], "AddProgressBar", skinObjectiveBar)

		-- ProgressBar in the ObjectiveTacker
		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line, questID)
			local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line]
			if progressBar and progressBar:IsShown() and not progressBar.skinned then
				progressBar.Bar:StripTextures()
				progressBar.Bar:SetStatusBarTexture(E.LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
				local COLOR
				if E.private.sle.skins.objectiveTracker.class then
					COLOR = classColor
				else
					COLOR = E.private.sle.skins.objectiveTracker.color
				end
				progressBar.Bar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
				progressBar.Bar:CreateBackdrop('Transparent')
				progressBar.Bar.backdrop:SetPoint('TOPLEFT', progressBar.Bar, -1, 1)
				progressBar.Bar.backdrop:SetPoint('BOTTOMRIGHT', progressBar.Bar, 1, -1)
				progressBar.skinned = true
			end
		end)
		-- scenario
		hooksecurefunc(_G["DEFAULT_OBJECTIVE_TRACKER_MODULE"], "AddTimerBar", SkinTimerBar)
		hooksecurefunc(_G["SCENARIO_CONTENT_TRACKER_MODULE"], "Update", SkinScenarioButtons)
		hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenarioButtons)
		hooksecurefunc("Scenario_ChallengeMode_ShowBlock", SkinChallengeModeBlock)
		if E.private.sle.skins.objectiveTracker.keyTimers.enable then hooksecurefunc("Scenario_ChallengeMode_UpdateTime", UpdateChallengeModeTime) end
		hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", SkinAffixes)
		hooksecurefunc(ScenarioStageBlock.WidgetContainer, "CreateWidget", function(self, widgetID, widgetType, widgetTypeInfo, widgetInfo)
			-- print(widgetID, widgetType, widgetTypeInfo, widgetInfo)
			local widgetFrame = self.widgetFrames[widgetID]

			if skinnableWidgets[widgetID] then
				if not E.private.sle.skins.objectiveTracker.scenarioBG then
					for i = 1, widgetFrame:GetNumRegions() do
						local region = select(i, widgetFrame:GetRegions())
						if region and region:IsObjectType('Texture') then
							region:SetAlpha(0)
						end
					end
				end
			end
		end)
		-- Another ProgressBar in the ObjectiveTracker counting as Scenario (e.g. Legion Pre-Event)
		hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", function(self, block, line, criteriaIndex)
			local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line]
			if progressBar and progressBar:IsShown() and not progressBar.skinned then
				progressBar.Bar:StripTextures()
				progressBar.Bar:SetStatusBarTexture(E.LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
				local COLOR
				if E.private.sle.skins.objectiveTracker.class then
					COLOR = classColor
				else
					COLOR = E.private.sle.skins.objectiveTracker.color
				end
				progressBar.Bar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
				progressBar.Bar:CreateBackdrop()
				progressBar.Bar.backdrop:SetPoint('TOPLEFT', progressBar.Bar, -1, 1)
				progressBar.Bar.backdrop:SetPoint('BOTTOMRIGHT', progressBar.Bar, 1, -1)
				progressBar.skinned = true
				ScenarioTrackerProgressBar_PlayFlareAnim = dummy
			end
		end)
		-- proving grounds
		hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGroundButtons)

		--Doing Underlines
		local flat = [[Interface\AddOns\ElvUI\media\textures\Minimalist]]
		local height = E.private.sle.skins.objectiveTracker.underlineHeight
		_G["ObjectiveTrackerBlocksFrame"].CampaignQuestHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].CampaignQuestHeader, flat, true, height)
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].QuestHeader, flat, true, height)
		_G["ObjectiveTrackerBlocksFrame"].AchievementHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].AchievementHeader, flat, true, height)
		_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.SLE_Underline = Sk:CreateUnderline(_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header, flat, true, height)
		_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader, flat, true, height)
		_G["WORLD_QUEST_TRACKER_MODULE"].Header.SLE_Underline = Sk:CreateUnderline(_G["WORLD_QUEST_TRACKER_MODULE"].Header, flat, true, height)

		tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].CampaignQuestHeader.SLE_Underline)
		tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].QuestHeader.SLE_Underline)
		tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].AchievementHeader.SLE_Underline)
		tinsert(underlines, _G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.SLE_Underline)
		tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.SLE_Underline)
		tinsert(underlines, _G["WORLD_QUEST_TRACKER_MODULE"].Header.SLE_Underline)

		Sk:Update_ObjectiveTrackerUnderlinesVisibility()
		Sk:Update_ObjectiveTrackerUnderlinesColor()

		local MawBuffsBlock = ScenarioBlocksFrame.MawBuffsBlock
		if MawBuffsBlock and E.private.sle.skins.objectiveTracker.torghastPowers.enable then
			local numRegions = MawBuffsBlock.Container:GetNumRegions()
			for i = 1, numRegions do
				local region = select(i, MawBuffsBlock.Container:GetRegions())
				if region and region.IsObjectType and region:IsObjectType('Texture') then
					region:SetAlpha(0)
				end
			end
			-- MawBuffsBlock:SetTemplate('Transparent')
			if not MawBuffsBlock.SLE_Block then
				MawBuffsBlock.SLE_Block = CreateFrame('Frame', 'MawBuffsBlock_SLE_Block', MawBuffsBlock.Container)
				MawBuffsBlock.SLE_Block:ClearAllPoints()
				MawBuffsBlock.SLE_Block:Point('TOPLEFT', MawBuffsBlock)
				MawBuffsBlock.SLE_Block:Point('BOTTOMRIGHT', MawBuffsBlock)
				MawBuffsBlock.SLE_Block:SetTemplate('Transparent')
				MawBuffsBlock.SLE_Block:SetFrameStrata('BACKGROUND')

				ENH:ProcessShadow(MawBuffsBlock.SLE_Block, nil, MawBuffsBlock.SLE_Block:GetFrameLevel(), E.db.sle.shadows.torghastPowers)
			end

			MawBuffsBlock.Container.List:StripTextures()
			MawBuffsBlock.Container.List:SetTemplate('Transparent')
			ENH:ProcessShadow(MawBuffsBlock.Container.List, nil, MawBuffsBlock.Container.List:GetFrameLevel(), E.db.sle.shadows.torghastPowers)
		end

		-- SoD Raid
		local MawBuffsBelowMinimapFrame = _G.MawBuffsBelowMinimapFrame
		if MawBuffsBelowMinimapFrame and E.private.sle.skins.objectiveTracker.torghastPowers.enable then
			local numRegions = MawBuffsBelowMinimapFrame.Container:GetNumRegions()
			for i = 1, numRegions do
				local region = select(i, MawBuffsBelowMinimapFrame.Container:GetRegions())
				if region and region.IsObjectType and region:IsObjectType('Texture') then
					region:SetAlpha(0)
				end
			end
			-- MawBuffsBelowMinimapFrame:SetTemplate('Transparent')
			if not MawBuffsBelowMinimapFrame.SLE_Block then
				MawBuffsBelowMinimapFrame.SLE_Block = CreateFrame('Frame', 'MawBuffsBelowMinimapFrame_SLE_Block', MawBuffsBelowMinimapFrame.Container)
				MawBuffsBelowMinimapFrame.SLE_Block:ClearAllPoints()
				MawBuffsBelowMinimapFrame.SLE_Block:Point('TOPLEFT', MawBuffsBelowMinimapFrame)
				MawBuffsBelowMinimapFrame.SLE_Block:Point('BOTTOMRIGHT', MawBuffsBelowMinimapFrame)
				MawBuffsBelowMinimapFrame.SLE_Block:SetTemplate('Transparent')
				MawBuffsBelowMinimapFrame.SLE_Block:SetFrameStrata('BACKGROUND')

				ENH:ProcessShadow(MawBuffsBelowMinimapFrame.SLE_Block, nil, MawBuffsBelowMinimapFrame.SLE_Block:GetFrameLevel(), E.db.sle.shadows.torghastPowers)
			end

			MawBuffsBelowMinimapFrame.Container.List:StripTextures()
			MawBuffsBelowMinimapFrame.Container.List:SetTemplate('Transparent')
			ENH:ProcessShadow(MawBuffsBelowMinimapFrame.Container.List, nil, MawBuffsBelowMinimapFrame.Container.List:GetFrameLevel(), E.db.sle.shadows.torghastPowers)
		end
	end
end

hooksecurefunc(S, "Initialize", ObjectiveReskin)
