local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end
local addHeader
local setButtonToBonusTask
local mouseHandlerBonusTask = {}

local function Replace()
	local QuestKing = _G["QuestKing"]
	local WatchButton = QuestKing.WatchButton
	local getQuestTaggedTitle = QuestKing.GetQuestTaggedTitle
	local getObjectiveColor = QuestKing.GetObjectiveColor
	local opt = QuestKing.options
	local opt_colors = opt.colors

	function setButtonToBonusTask (button, questID)
		button.mouseHandler = mouseHandlerBonusTask

		local questIndex = GetQuestLogIndexByID(questID)
		button.questID = questID
		button.questIndex = questIndex

		local taggedTitle, level = getQuestTaggedTitle(questIndex, true)
		local color = GetQuestDifficultyColor(level)

		if (GetSuperTrackedQuestID() == questID) then
			taggedTitle = taggedTitle .. " |TInterface\\Scenarios\\ScenarioIcon-Combat:10:10:-1:0|t"
		end	

		button.title:SetTextIcon(taggedTitle)
		button.title:SetTextColor(color.r, color.g, color.b)

		local isInArea, isOnMap, numObjectives = GetTaskInfo(questID)
		local useNonBonusHeader = false
		
		for i = 1, numObjectives do
			local desc, objectiveType, isDone, displayAsObjective = GetQuestObjectiveInfo(questID, i, false)
			useNonBonusHeader = useNonBonusHeader or displayAsObjective

			if (desc == nil) then desc = "Unknown" end

			local quantCur, quantMax, quantName = QuestKing.MatchObjective(desc)

			if (objectiveType == "progressbar") then
				local percent = GetQuestProgressBarPercent(questID)

				local objectiveFraction = isDone and 1 or (percent / 100)
				if (objectiveFraction >= 1) and (not isDone) then
					objectiveFraction = 0.999
				end

				local r, g, b = getObjectiveColor(objectiveFraction)
				button:AddLine(format("  %s", desc), nil, r, g, b)

				local progressBar = button:AddProgressBar()
				progressBar:SetPercent(percent)
			elseif (quantName) then
				local r, g, b = getObjectiveColor(quantCur / quantMax)
				local line = button:AddLine(format("  %s", quantName), format(": %s/%s", quantCur, quantMax), r, g, b)		

				local lastQuant = line._lastQuant
				if ((lastQuant) and (quantCur > lastQuant)) then
					line:Flash()
				end
				line._lastQuant = quantCur
			else
				local r, g, b = getObjectiveColor(isDone and 1 or 0)
				button:AddLine(format("  %s", desc), nil, r, g, b)
			end

		end

		if (useNonBonusHeader) and (button._previousHeader)  then
			button._previousHeader.title:SetText(TRACKER_HEADER_OBJECTIVE)
		end

		if (button.fresh) then
			local lines = button.lines
			for i = 1, #lines do
				local line = lines[i]
				line:Glow(opt_colors.ObjectiveAlertGlow[1], opt_colors.ObjectiveAlertGlow[2], opt_colors.ObjectiveAlertGlow[3])
			end
		end
		-- button.titleButton:EnableMouse(false)
		-- button:EnableMouse(true)
	end
	
	function addHeader ()
		local header = WatchButton:GetKeyed("header", "Bonus Objectives")
		header.title:SetText(TRACKER_HEADER_BONUS_OBJECTIVES)
		local SLE_HeaderColor = E.db.sle.skins.objectiveTracker.colorHeader
		if E.private.sle.skins.QuestKing.enable then
			header.title:SetTextColor(SLE_HeaderColor.r, SLE_HeaderColor.g, SLE_HeaderColor.b)
		else
			header.title:SetTextColor(opt_colors.SectionHeader[1], opt_colors.SectionHeader[2], opt_colors.SectionHeader[3])
		end
		return header
	end

	function QuestKing:UpdateTrackerBonusObjectives ()
		local tasksTable = GetTasksTable()
		local header

		if (dummyTaskID) then
			header = addHeader()

			local button = WatchButton:GetKeyed("bonus_task_dummy", questID)
			button._previousHeader = header
			setButtonToDummyTask(button, questID)
		end

		for i = 1, #tasksTable do
			local questID = tasksTable[i]
			local isInArea, isOnMap, numObjectives = GetTaskInfo(questID)

			if (isInArea) and (questID ~= dummyTaskID) then
				if (not header) then
					header = addHeader()
				end

				local button = WatchButton:GetKeyed("bonus_task", questID)
				button._previousHeader = header
				setButtonToBonusTask(button, questID)
			end
		end

		local inScenario = C_Scenario.IsInScenario()
		if (not inScenario) then return end

		local tblBonusSteps = C_Scenario.GetBonusSteps()

		-- do superseding stuff
		supersededObjectives = C_Scenario.GetSupersededObjectives()
		if (supersededObjectives) and (opt.hideSupersedingObjectives) then
			local hiddenSteps = {}

			for i = 1, #tblBonusSteps do
				local bonusStepIndex = tblBonusSteps[i]
				local supersededIndex = getSupersedingStep(bonusStepIndex)
				if (supersededIndex) then
					local _, _, numCriteria, stepFailed = C_Scenario.GetStepInfo(bonusStepIndex)
					local completed = true
					if stepFailed then
						completed = false
					else
						for criteriaIndex = 1, numCriteria do
							local criteriaString, _, criteriaCompleted = C_Scenario.GetCriteriaInfoByStep(bonusStepIndex, criteriaIndex)
							if (criteriaString) and (not criteriaCompleted) then
								completed = false
								break
							end
						end
					end

					if (not completed) then
						hiddenSteps[#hiddenSteps+1] = supersededIndex
					end
				end
			end

			if (hiddenSteps) then
				-- dumptable(hiddenSteps)
				for i = 1, #hiddenSteps do
					tDeleteItem(tblBonusSteps, hiddenSteps[i])
				end
			end
		end

		for i = 1, #tblBonusSteps do
			-- each bonus step
			local bonusStepIndex = tblBonusSteps[i]

			if (not header) then
				header = addHeader()
			end

			local button = WatchButton:GetKeyed("bonus_step", bonusStepIndex)
			button._previousHeader = header
			QuestKing.SetButtonToScenario(button, bonusStepIndex)
		end
	end
	
	function mouseHandlerBonusTask:TitleButtonOnClick (mouse, down)
		local button = self.parent

		if (IsModifiedClick("CHATLINK")) and (ChatEdit_GetActiveWindow()) then
			local questLink = GetQuestLink(button.questIndex)
			if (questLink) then
				ChatEdit_InsertLink(questLink)
				return
			end
		end

		if (IsShiftKeyDown()) and (ClassicQuestLog) then
			SelectQuestLogEntry(button.questIndex)
			if ClassicQuestLog:IsVisible() then
				ClassicQuestLog:OnShow()
			else
				ClassicQuestLog:SetShown(true)
			end
			return
		end	

		if (mouse == "RightButton") then
			if (GetSuperTrackedQuestID() == button.questID) then
				QuestKing:SetSuperTrackedQuestID(0)
				QuestKing:UpdateTracker()
			else
				QuestKing:SetSuperTrackedQuestID(button.questID)
				QuestKing:UpdateTracker()
			end
		else
			QuestObjectiveTracker_OpenQuestMap(nil, button.questIndex)
		end
	end

	function mouseHandlerBonusTask:TitleButtonOnEnter (motion)
		local button = self.parent

		local questID = button.questID

		if ((HaveQuestData(questID)) and (GetQuestLogRewardXP(questID) == 0) and (GetNumQuestLogRewardCurrencies(questID) == 0)
				and (GetNumQuestLogRewards(questID) == 0) and (GetQuestLogRewardMoney(questID) == 0)) then
			GameTooltip:Hide()
			return
		end

		GameTooltip:ClearAllPoints()
		-- GameTooltip:SetPoint("TOPRIGHT", block, "TOPLEFT", 0, 0);
		-- GameTooltip:SetOwner(block, "ANCHOR_PRESERVE");
		_G["GameTooltip"]:SetOwner(self, E.private.sle.skins.QuestKing.tooltipAnchor)
		GameTooltip:SetText(REWARDS, 1, 0.831, 0.380)

		if (not HaveQuestData(questID)) then
			GameTooltip:AddLine(RETRIEVING_DATA, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else	
			GameTooltip:AddLine(BONUS_OBJECTIVE_TOOLTIP_DESCRIPTION, 1, 1, 1, 1)
			GameTooltip:AddLine(" ")
			
			-- xp
			local xp = GetQuestLogRewardXP(questID)
			if (xp > 0) then
				GameTooltip:AddLine(string.format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, xp), 1, 1, 1)
			end
			
			-- currency		
			local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID)
			for i = 1, numQuestCurrencies do
				local name, texture, numItems = GetQuestLogRewardCurrencyInfo(i, questID)
				local text = string.format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name)
				GameTooltip:AddLine(text, 1, 1, 1)
			end
			
			-- items
			local numQuestRewards = GetNumQuestLogRewards(questID)
			for i = 1, numQuestRewards do
				local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i, questID)
				local text
				if (numItems > 1) then
					text = string.format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name)
				elseif (texture and name) then
					text = string.format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
				end
				if (text) then
					local color = ITEM_QUALITY_COLORS[quality]
					GameTooltip:AddLine(text, color.r, color.g, color.b)
				end
			end

			-- money
			local money = GetQuestLogRewardMoney(questID)
			if (money > 0) then
				SetTooltipMoney(GameTooltip, money, nil)
			end
		end

		GameTooltip:Show()	
	end
end

T.tinsert(QK.Replaces, Replace)