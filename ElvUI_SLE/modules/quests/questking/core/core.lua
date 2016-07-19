local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local function Replace()
	local QuestKing = _G["QuestKing"]
	local WatchButton = QuestKing.WatchButton
	local Tracker = QuestKing.Tracker
	local opt = QuestKing.options
	local opt_colors = opt.colors

	function QuestKing:UpdateTracker(forceBuild, postCombat)
		--D("!QuestKing:UpdateTracker")

		QuestKing:CheckQuestSortTable(forceBuild)
		QuestKing.watchMoney = false

		QuestKing:PreCheckQuestTracking()

		WatchButton:StartOrder()

		-- titlebar
		local trackerCollapsed = QuestKingDBPerChar.trackerCollapsed
		if (trackerCollapsed == 2) then
			QuestKing_TrackerMinimizeButton.label:SetText("x")
		elseif (trackerCollapsed == 1) then
			QuestKing_TrackerMinimizeButton.label:SetText("+")
		else
			QuestKing_TrackerMinimizeButton.label:SetText("-")
		end

		if (QuestKingDBPerChar.trackerCollapsed <= 1) then
			QuestKing:UpdateTrackerPopups()

			-- challenge timers
			QuestKing:UpdateTrackerChallengeTimers()

			-- scenarios
			local inScenario = C_Scenario.IsInScenario()
			if inScenario then
				QuestKing:UpdateTrackerScenarios()
			end

			-- bonus objectives
			QuestKing:UpdateTrackerBonusObjectives()
		end
		
		local displayMode = QuestKingDBPerChar.displayMode

		if (trackerCollapsed == 0) then
			if (displayMode == "combined") or (displayMode == "achievements") then
				QuestKing:UpdateTrackerAchievements()
			end

			if (displayMode == "combined") or (displayMode == "quests") then
				QuestKing:UpdateTrackerQuests()
			end
		end

		local numAch = GetNumTrackedAchievements()
		local numWatches = GetNumQuestWatches()
		local totalLogLines, totalQuestCount = GetNumQuestLogEntries()

		if displayMode == "combined" then
			QuestKing_TrackerModeButton.label:SetText("C")
			if numAch > 0 then
				Tracker.titlebarText:SetText(format("%d/%d | %d", totalQuestCount, MAX_QUESTS, numAch))
			else
				Tracker.titlebarText:SetText(format("%d/%d", totalQuestCount, MAX_QUESTS))
			end
			if (numWatches == 0) and (numAch == 0) then
				Tracker.titlebarText:SetTextColor(opt_colors.TrackerTitlebarTextDimmed[1], opt_colors.TrackerTitlebarTextDimmed[2], opt_colors.TrackerTitlebarTextDimmed[3])
			else
				Tracker.titlebarText:SetTextColor(opt_colors.TrackerTitlebarText[1], opt_colors.TrackerTitlebarText[2], opt_colors.TrackerTitlebarText[3])
			end

		elseif displayMode == "achievements" then
			QuestKing_TrackerModeButton.label:SetText("A")
			Tracker.titlebarText:SetText(numAch)
			if (numAch == 0) then
				Tracker.titlebarText:SetTextColor(opt_colors.TrackerTitlebarTextDimmed[1], opt_colors.TrackerTitlebarTextDimmed[2], opt_colors.TrackerTitlebarTextDimmed[3])
			else
				Tracker.titlebarText:SetTextColor(opt_colors.TrackerTitlebarText[1], opt_colors.TrackerTitlebarText[2], opt_colors.TrackerTitlebarText[3])
			end

		else
			QuestKing_TrackerModeButton.label:SetText("Q")
			Tracker.titlebarText:SetText(format("%d/%d", totalQuestCount, MAX_QUESTS))
			if (numWatches == 0) then
				Tracker.titlebarText:SetTextColor(opt_colors.TrackerTitlebarTextDimmed[1], opt_colors.TrackerTitlebarTextDimmed[2], opt_colors.TrackerTitlebarTextDimmed[3])
			else
				Tracker.titlebarText:SetTextColor(opt_colors.TrackerTitlebarText[1], opt_colors.TrackerTitlebarText[2], opt_colors.TrackerTitlebarText[3])
			end		
		end


		-- LAYOUT
		local requestOrder = WatchButton.requestOrder
		local requestCount = WatchButton.requestCount
		local lastShown = nil
		for i = 1, requestCount do
			-- loop over watch buttons
			local button = requestOrder[i]
			button:ClearAllPoints()
			
			-- layout shown buttons
			if (lastShown == nil) then
				button:SetPoint("TOPLEFT", Tracker.titlebar, "BOTTOMLEFT", 0, -1)
			else
				if (button.type == "header") or (button.type == "collapser") then
					button:SetPoint("TOPLEFT", lastShown, "BOTTOMLEFT", 0, -4)
				elseif (lastShown.type == "header") or (lastShown.type == "collapser") then
					button:SetPoint("TOPLEFT", lastShown, "BOTTOMLEFT", 0, -3)
				else
					button:SetPoint("TOPLEFT", lastShown, "BOTTOMLEFT", 0, -2)
				end
			end
			button:Render()

			lastShown = button
		end

		if (postCombat) then -- we already check for combat in timer func, no need here
			local freePool = WatchButton.freePool
			for i = 1, #freePool do
				local button = freePool[i]
				if (button.itemButton) then
					button:RemoveItemButton()
				end
			end
		end

		WatchButton:FreeUnused()
		
		Tracker:Resize(lastShown)

		QuestKing:PostCheckQuestTracking()

		local hooks = QuestKing.updateHooks
		if (#hooks) then
			for i = 1, #hooks do
				hooks[i]()
			end
		end
	end
end

T.tinsert(QK.Replaces, Replace)