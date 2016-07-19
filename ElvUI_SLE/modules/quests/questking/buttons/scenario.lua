local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local mouseHandlerScenario = {}

local function Replace()
	local QuestKing = _G["QuestKing"]
	local WatchButton = QuestKing.WatchButton
	local getObjectiveColor = QuestKing.GetObjectiveColor
	local opt = QuestKing.options
	local opt_colors = opt.colors

	function QuestKing:UpdateTrackerScenarios ()
		local scenarioName, currentStage, numStages, flags, hasBonusStep, isBonusStepComplete, completed, xp, money = C_Scenario.GetInfo()
		local inChallengeMode = bit.band(flags, SCENARIO_FLAG_CHALLENGE_MODE) == SCENARIO_FLAG_CHALLENGE_MODE;
		local inProvingGrounds = bit.band(flags, SCENARIO_FLAG_PROVING_GROUNDS) == SCENARIO_FLAG_PROVING_GROUNDS;
		local dungeonDisplay = bit.band(flags, SCENARIO_FLAG_USE_DUNGEON_DISPLAY) == SCENARIO_FLAG_USE_DUNGEON_DISPLAY;
		-- D("updateTrackerScenarios:", dungeonDisplay)

		local _, _, _, _, _, _, _, mapID = GetInstanceInfo()
		if (mapID == 1148) then
			inProvingGrounds = true
		end
		
		if (inProvingGrounds) then
			local diffID, currWave, maxWave, duration = C_Scenario.GetProvingGroundsInfo()
			if (duration ~= 0) then
				return
			end
		end

		local stageName, stageDescription, numCriteria = C_Scenario.GetStepInfo()
		local inChallengeMode = C_Scenario.IsChallengeMode()
		local SLE_HeaderColor = E.db.sle.skins.objectiveTracker.colorHeader
		if (currentStage > 0) then
			if (currentStage <= numStages) then
				-- scenario type header
				local header = WatchButton:GetKeyed("header", scenarioName)

				if (inProvingGrounds) then
					header.title:SetText(TRACKER_HEADER_PROVINGGROUNDS)
				else
					local displayText = TRACKER_HEADER_SCENARIO

					if (dungeonDisplay) then
						displayText = TRACKER_HEADER_DUNGEON
					elseif (inChallengeMode) then
						displayText = CHALLENGE_MODE
					end

					if (numStages > 1) then
						if (currentStage == numStages) then
							header.title:SetFormattedText("%s: "..SCENARIO_STAGE_FINAL, displayText)
						else
							header.title:SetFormattedText("%s: "..SCENARIO_STAGE_STATUS, displayText, currentStage, numStages)
						end
					else
						header.title:SetText(displayText)
					end
				end
				header.title:SetTextColor(SLE_HeaderColor.r, SLE_HeaderColor.g, SLE_HeaderColor.b)

				-- scenario stage
				local button = WatchButton:GetKeyed("scenario", scenarioName)
				QuestKing.SetButtonToScenario(button)

			elseif (currentStage > numStages) then
				-- scenario complete header
				local header = WatchButton:GetKeyed("header", scenarioName)
				if (not inChallengeMode) then
					if (dungeonDisplay) then
						header.title:SetText(DUNGEON_COMPLETED)
					else
						header.title:SetText(SCENARIO_COMPLETED)
					end
				else
					header.title:SetText(CHALLENGE_MODE_COMPLETED)
				end
				header.title:SetTextColor(SLE_HeaderColor.r, SLE_HeaderColor.g, SLE_HeaderColor.b)
			end
		end
	end

	function QuestKing.SetButtonToScenario(button, stepIndex)
		button.mouseHandler = mouseHandlerScenario

		local scenarioName, currentStage, numStages, flags, hasBonusStep, isBonusStepComplete, completed, xp, money = C_Scenario.GetInfo()

		if (not stepIndex) then
			stepIndex = currentStage
		end
		button.stepIndex = stepIndex

		local lastStepIndex = button._lastStepIndex
		local isNewStep = false
		if (lastStepIndex) and (stepIndex > lastStepIndex) and (not button.fresh) then
			isNewStep = true
			-- D("isNewStep")
		end
		button._lastStepIndex = stepIndex

		local stageName, stageDescription, numCriteria, stepFailed, isBonusStep, isForCurrentStepOnly = C_Scenario.GetStepInfo(stepIndex)

		-- pre-parse
		local stepFinished = (numCriteria > 0) and true or false
		for i = 1, numCriteria do
			local criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, criteriaFailed = C_Scenario.GetCriteriaInfoByStep(stepIndex, i)
			if (not criteriaCompleted) then
				stepFinished = false
			end
		end

		if (stepFailed) then
			button.title:SetFormattedTextIcon("|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0:0:1:0|t %s", stageName)
			button.title:SetTextColor(opt_colors.ObjectiveFailed[1], opt_colors.ObjectiveFailed[2], opt_colors.ObjectiveFailed[3])
			stepFinished = true
		elseif (stepFinished) then
			button.title:SetFormattedTextIcon("|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0:0:1:1|t %s", stageName)
			button.title:SetTextColor(opt_colors.ObjectiveComplete[1], opt_colors.ObjectiveComplete[2], opt_colors.ObjectiveComplete[3])
		else
			button.title:SetText(stageName)
			button.title:SetTextColor(opt_colors.ScenarioStageTitle[1], opt_colors.ScenarioStageTitle[2], opt_colors.ScenarioStageTitle[3])
		end

		if (not stepFinished) then
			for i = 1, numCriteria do
				local criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, criteriaFailed = C_Scenario.GetCriteriaInfoByStep(stepIndex, i)
				local line

				if (criteriaCompleted) then
					if (opt_showCompletedObjectives) then
						line = button:AddLine(
							format("  %s", criteriaString),
							format(": %s/%s", quantity, totalQuantity),
							opt_colors.ObjectiveGradientComplete[1], opt_colors.ObjectiveGradientComplete[2], opt_colors.ObjectiveGradientComplete[3])
					end
				elseif (criteriaFailed) then
					line = button:AddLineIcon(
						format("  |TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t %s", criteriaString),
						format(": %s/%s", quantity, totalQuantity),
						opt_colors.ObjectiveFailed[1], opt_colors.ObjectiveFailed[2], opt_colors.ObjectiveFailed[3])
				else
					local r, g, b = getObjectiveColor(quantity / totalQuantity)
					line = button:AddLine(
						format("  %s", criteriaString),
						format(": %s/%s", quantity, totalQuantity),
						r, g, b)
				end
				if not line then return end
				local lastQuant = line._lastQuant
				if ((lastQuant) and (quantity > lastQuant) and (not isNewStep)) then
					-- line:Glow(opt_colors.ObjectiveProgressFlash[1], opt_colors.ObjectiveProgressFlash[2], opt_colors.ObjectiveProgressFlash[3])
					line:Flash()
				end
				line._lastQuant = quantity

				if ((duration) and (elapsed) and (elapsed < duration)) then
					local timerBar = button:AddTimerBar(duration, GetTime() - elapsed)
					local COLOR
					if E.private.sle.skins.objectiveTracker.class then
						COLOR = classColor
					else
						COLOR = E.private.sle.skins.objectiveTracker.color
					end
					timerBar:SetStatusBarColor(COLOR.r, COLOR.g, COLOR.b)
				end
			end

			if (isNewStep) or (button.fresh) then
				local lines = button.lines
				for i = 1, #lines do
					local line = lines[i]
					line:Glow(0.1, 0.7, 0.4)
				end
				-- D("glowed lines")
			end
		end
	end

	function mouseHandlerScenario:TitleButtonOnEnter (motion)
		local button = self.parent
		local stepIndex = button.stepIndex

		local scenarioName, currentStage, numStages, flags, hasBonusStep, isBonusStepComplete, completed, xp, money = C_Scenario.GetInfo()
		local stageName, stageDescription, numCriteria, stepFailed, isBonusStep, isForCurrentStepOnly = C_Scenario.GetStepInfo(stepIndex)

		_G["GameTooltip"]:SetOwner(self, E.private.sle.skins.QuestKing.tooltipAnchor)

		if opt.tooltipScale then
			if not GameTooltip.__QuestKingPreviousScale then
				GameTooltip.__QuestKingPreviousScale = GameTooltip:GetScale()
			end
			GameTooltip:SetScale(opt.tooltipScale)
		end

		GameTooltip:AddLine(scenarioName, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
		GameTooltip:AddLine(stageName, opt_colors.ScenarioStageTitle[1], opt_colors.ScenarioStageTitle[2], opt_colors.ScenarioStageTitle[3], 1)

		if (isBonusStep) then
			GameTooltip:AddLine("Bonus Objective", 1, 0.914, 0.682, 1)
		else
			GameTooltip:AddLine(string.format(SCENARIO_STAGE_STATUS, currentStage, numStages), 1, 0.914, 0.682, 1)
		end
		GameTooltip:AddLine(" ")

		GameTooltip:AddLine(stageDescription, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")

		GameTooltip:AddLine(QUEST_TOOLTIP_REQUIREMENTS, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
		for i = 1, numCriteria do
			local criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, criteriaFailed = C_Scenario.GetCriteriaInfoByStep(stepIndex, i)
			if criteriaCompleted then
				GameTooltip:AddLine(format("- %s: %s/%s |cff808080(%s)|r", criteriaString, quantity, totalQuantity, COMPLETE), 0.2, 0.9, 0.2)
			elseif criteriaFailed then
				GameTooltip:AddLine(format("- %s: %s/%s |cff808080(%s)|r", criteriaString, quantity, totalQuantity, FAILED), 1, 0.2, 0.2)
			else
				GameTooltip:AddLine(format("- %s: %s/%s", criteriaString, quantity, totalQuantity), 1, 1, 1)
			end

		end

		local blankLine = false

		if (isBonusStep) then
			local questID = C_Scenario.GetBonusStepRewardQuestID(stepIndex)
			if (not HaveQuestData(questID)) then
				-- GameTooltip:AddLine(RETRIEVING_DATA, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			else
				-- xp
				local xp = GetQuestLogRewardXP(questID)
				if ( xp > 0 ) then
					if (not blankLine) then GameTooltip:AddLine(" "); blankLine = true end
					GameTooltip:AddLine(string.format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, xp), 1, 1, 1)
				end

				-- currency		
				local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID)
				for i = 1, numQuestCurrencies do
					local name, texture, numItems = GetQuestLogRewardCurrencyInfo(i, questID)
					local text = string.format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name)
					if (not blankLine) then GameTooltip:AddLine(" "); blankLine = true end
					GameTooltip:AddLine(text, 1, 1, 1)
				end

				-- items
				local numQuestRewards = GetNumQuestLogRewards(questID)
				for i = 1, numQuestRewards do
					local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i, questID)
					local text

					if (numItems > 1) then
						text = string.format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name)
					elseif (texture) and (name) then
						text = string.format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
					end

					if (text) then
						local color = ITEM_QUALITY_COLORS[quality]
						if (not blankLine) then GameTooltip:AddLine(" "); blankLine = true end
						GameTooltip:AddLine(text, color.r, color.g, color.b)
					end
				end

				-- money
				local money = GetQuestLogRewardMoney(questID)
				if (money > 0) then
					if (not blankLine) then GameTooltip:AddLine(" "); blankLine = true end
					SetTooltipMoney(GameTooltip, money, nil)
				end			
			end
		else
			if (xp > 0) then
				if (not blankLine) then GameTooltip:AddLine(" "); blankLine = true end
				GameTooltip:AddLine(string.format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, xp), 1, 1, 1)
		  end
		  if (money > 0) then
			if (not blankLine) then GameTooltip:AddLine(" "); blankLine = true end
				SetTooltipMoney(GameTooltip, money, nil)
		  end
		end

		GameTooltip:Show()
	end

end

T.tinsert(QK.Replaces, Replace)