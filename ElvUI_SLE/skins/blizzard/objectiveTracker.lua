local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins');
local Sk = SLE:GetModule("Skins")
local _G = _G
-- Cache global variables
-- GLOBALS: C_Scenario, BonusObjectiveTrackerProgressBar_PlayFlareAnim, hooksecurefunc, CreateFrame
-- Lua functions
local unpack = unpack

local ScenarioStageBlock = ScenarioStageBlock
local ScenarioProvingGroundsBlock = ScenarioProvingGroundsBlock
local ScenarioProvingGroundsBlockAnim = ScenarioProvingGroundsBlockAnim

local classColor = RAID_CLASS_COLORS[E.myclass]
local width = 190
local dummy = function() return end
local underlines = {}

function Sk:Update_ObjectiveTrackerUnderlinesVisibility()
	local exe = E.db.sle.skins.objectiveTracker.underline and "Show" or "Hide"
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


	if not progressBar.styled then
		local label = bar.Label

		bar.BarBG:Hide()
		bar.BarFrame:Hide()
		bar.BarFrame2:Hide()
		bar.BarFrame3:Hide()
		bar.BarGlow:Kill()
		bar:SetSize(225, 18)

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
		SLE:GetModule("Media").BonusObjectiveBarText = label

		BonusObjectiveTrackerProgressBar_PlayFlareAnim = dummy
		progressBar.styled = true
	end

	if icon then icon:Hide() end
	bar.IconBG:Hide()
end

-- Objective Tracker from ObbleYeah - Modified to fit my style

-- Timer bars. Seems to work atm. must still take a look at it.
local function SkinTimerBar(self, block, line, duration, startTime)
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
	local _, currentStage, numStages, flags = C_Scenario.GetInfo()

	-- we have to independently resize the artwork
	-- because we're messing with the tracker width >_>
	if not E.private.sle.skins.objectiveTracker.scenarioBG then
		-- pop-up artwork
		block.NormalBG:Hide()

		-- pop-up final artwork
		block.FinalBG:Hide()
	end

	-- pop-up glow
	block.GlowTexture:SetSize(width+20, 75)
	block.GlowTexture.AlphaAnim.Play = dummy
end

-- Proving grounds
local function SkinProvingGroundButtons()
	local block = ScenarioProvingGroundsBlock
	local sb = block.StatusBar
	local anim = ScenarioProvingGroundsBlockAnim

	block.MedalIcon:SetSize(42, 42)
	block.MedalIcon:ClearAllPoints()
	block.MedalIcon:SetPoint("TOPLEFT", block, 20, -10)

	block.WaveLabel:ClearAllPoints()
	block.WaveLabel:SetPoint("LEFT", block.MedalIcon, "RIGHT", 3, 0)

	block.BG:Hide()
	block.BG:SetSize(width + 21, 75)

	block.GoldCurlies:Hide()
	block.GoldCurlies:ClearAllPoints()
	block.GoldCurlies:SetPoint("TOPLEFT", block.BG, 6, -6)
	block.GoldCurlies:SetPoint("BOTTOMRIGHT", block.BG, -6, 6)

	anim.BGAnim:Hide()
	anim.BGAnim:SetSize(width + 45, 85)
	anim.BorderAnim:SetSize(width + 21, 75)
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
	sb:SetSize(200, 15)

	-- Create a little border around the Bar.
	-- local sb2 = sb:GetParent():CreateTexture(nil, 'BACKGROUND')
	-- sb2:SetPoint('TOPLEFT', sb, -1, 1)
	-- sb2:SetPoint('BOTTOMRIGHT', sb, 1, -1)
	-- sb2:SetTexture(E.LSM:Fetch('statusbar', E.private.sle.skins.objectiveTracker.texture))
	-- sb2:SetAlpha(0.5)
	-- sb2:SetVertexColor(unpack(E.media.backdropcolor))
end

local function ObjectiveReskin()
	if T.IsAddOnLoaded("Blizzard_ObjectiveTracker") then
		-- _G["ObjectiveTrackerFrame"]:CreateBackdrop()
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.sle.skins.objectiveTracker.enable ~= true then return end
		-- Objective Tracker Bar
		hooksecurefunc(_G["BONUS_OBJECTIVE_TRACKER_MODULE"], "AddProgressBar", skinObjectiveBar) 
		-- World Quests can be bonus objective type
		hooksecurefunc(_G["WORLD_QUEST_TRACKER_MODULE"], "AddProgressBar", skinObjectiveBar)
		-- ProgressBar in the ObjectiveTacker
		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line, questID)
			local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line];
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
				progressBar.Bar.backdrop:Point('TOPLEFT', Bar, -1, 1)
				progressBar.Bar.backdrop:Point('BOTTOMRIGHT', Bar, 1, -1)
				progressBar.skinned = true
			end
		end)
		-- scenario
		hooksecurefunc(_G["DEFAULT_OBJECTIVE_TRACKER_MODULE"], "AddTimerBar", SkinTimerBar)
		hooksecurefunc(_G["SCENARIO_CONTENT_TRACKER_MODULE"], "Update", SkinScenarioButtons)
		hooksecurefunc("ScenarioBlocksFrame_OnLoad", SkinScenarioButtons)
		-- Another ProgressBar in the ObjectiveTracker counting as Scenario (e.g. Legion Pre-Event)
		hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", function(self, block, line, criteriaIndex)
			local progressBar = self.usedProgressBars[block] and self.usedProgressBars[block][line];
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
				progressBar.Bar.backdrop:Point('TOPLEFT', Bar, -1, 1)
				progressBar.Bar.backdrop:Point('BOTTOMRIGHT', Bar, 1, -1)
				progressBar.skinned = true
				ScenarioTrackerProgressBar_PlayFlareAnim = dummy
			end
		end)
		-- proving grounds
		hooksecurefunc("Scenario_ProvingGrounds_ShowBlock", SkinProvingGroundButtons)

		--Doing Underlines
		local flat = [[Interface\AddOns\ElvUI\media\textures\Minimalist]]
		local height = E.private.sle.skins.objectiveTracker.underlineHeight
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].QuestHeader, flat, true, height)
		_G["ObjectiveTrackerBlocksFrame"].AchievementHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].AchievementHeader, flat, true, height)
		_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.SLE_Underline = Sk:CreateUnderline(_G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header, flat, true, height)
		_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.SLE_Underline = Sk:CreateUnderline(_G["ObjectiveTrackerBlocksFrame"].ScenarioHeader, flat, true, height)

		T.tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].QuestHeader.SLE_Underline)
		T.tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].AchievementHeader.SLE_Underline)
		T.tinsert(underlines, _G['BONUS_OBJECTIVE_TRACKER_MODULE'].Header.SLE_Underline)
		T.tinsert(underlines, _G["ObjectiveTrackerBlocksFrame"].ScenarioHeader.SLE_Underline)

		Sk:Update_ObjectiveTrackerUnderlinesVisibility()
		Sk:Update_ObjectiveTrackerUnderlinesColor()
	end
end
hooksecurefunc(S, "Initialize", ObjectiveReskin)