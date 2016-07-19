local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end
local ACHIEVEMENTS = ACHIEVEMENTS
local achievementTimers = {}
local achievementTimersMeta = {}

local mouseHandlerAchievement = {}

local function Replace()
local QuestKing = _G["QuestKing"]
local WatchButton = QuestKing.WatchButton
local opt = QuestKing.options
local opt_colors = opt.colors

	local function QuestKingClickTemplate(button, mouse)
		if IsAltKeyDown() then
			if mouse == "RightButton" then
				RemoveTrackedAchievement(button.id)
				QuestKing:UpdateTracker()
				return
			else
				if _G["QuestKingDBPerChar"].collapsedAchievements[button.id] then
					_G["QuestKingDBPerChar"].collapsedAchievements[button.id] = nil
				else
					_G["QuestKingDBPerChar"].collapsedAchievements[button.id] = true
				end
				QuestKing:UpdateTracker()
				return
			end
		end	

		if (not AchievementFrame) then AchievementFrame_LoadUI() end
		
		if (not AchievementFrame:IsShown()) then
			AchievementFrame_ToggleAchievementFrame()
			AchievementFrame_SelectAchievement(button.id)
		else
			if (AchievementFrameAchievements.selection ~= button.id) then
				AchievementFrame_SelectAchievement(button.id)
			else
				AchievementFrame_ToggleAchievementFrame()
			end
		end	
	end

	local function BlizzlikeClickTemplate(button, mouse)
		if IsShiftKeyDown() then
			if mouse == "RightButton" then
				if (GetSuperTrackedQuestID() == button.id) then
					QuestKing:SetSuperTrackedQuestID(0)
					QuestKing:UpdateTracker()
				else
					QuestKing:SetSuperTrackedQuestID(button.id)
					QuestKing:UpdateTracker()
				end
				return
			else
				RemoveTrackedAchievement(button.id)
				QuestKing:UpdateTracker()
				return
			end
		end
		if IsControlKeyDown() then 
			if _G["QuestKingDBPerChar"].collapsedAchievements[button.id] then
				_G["QuestKingDBPerChar"].collapsedAchievements[button.id] = nil
			else
				_G["QuestKingDBPerChar"].collapsedAchievements[button.id] = true
			end
			QuestKing:UpdateTracker()
			return
		end
		if (not AchievementFrame) then AchievementFrame_LoadUI() end
		if mouse == "RightButton" then
			ObjectiveTracker_ToggleDropDown(button, AchievementObjectiveTracker_OnOpenDropDown)
		else
			if (not AchievementFrame:IsShown()) then
				AchievementFrame_ToggleAchievementFrame()
				AchievementFrame_SelectAchievement(button.id)
			else
				if (AchievementFrameAchievements.selection ~= button.id) then
					AchievementFrame_SelectAchievement(button.id)
				else
					AchievementFrame_ToggleAchievementFrame()
				end
			end
		end
	end

	function QuestKing:UpdateTrackerAchievements()
		local trackedAchievements = { GetTrackedAchievements() }
		local numTrackedAchievements = #trackedAchievements

		-- header
		local showAchievements = true
		local SLE_HeaderColor = E.db.sle.skins.objectiveTracker.colorHeader
		if (QuestKingDBPerChar.displayMode == "combined") then
			local headerName = "|T"..QK.Icons["Achievement_small"]..":14|t "..ACHIEVEMENTS.." |T"..QK.Icons["Achievement_small"]..":14|t"
			if numTrackedAchievements > 0 then
				local button = WatchButton:GetKeyed("collapser", "Achievements")
				button._headerName = headerName

				if QuestKingDBPerChar.collapsedHeaders[headerName] then
					button.title:SetTextIcon("|TInterface\\AddOns\\QuestKing\\textures\\UI-SortArrow_sm_right:8:8:0:-1:0:0:0:0:0:0:1:1:1|t "..headerName)
				else
					button.title:SetTextIcon("|TInterface\\AddOns\\QuestKing\\textures\\UI-SortArrow_sm_down:8:8:0:-1:0:0:0:0:0:0:1:1:1|t "..headerName)
				end
				button.title:SetTextColor(SLE_HeaderColor.r, SLE_HeaderColor.g, SLE_HeaderColor.b)
			end

			if QuestKingDBPerChar.collapsedHeaders[headerName] then
				showAchievements = false
			end
		elseif (inScenario) and (QuestKingDBPerChar.displayMode == "achievements") then
			local achheader = WatchButton:GetKeyed("header", "Achievements")
			achheader.title:SetText(headerName)
			achheader.title:SetTextColor(SLE_HeaderColor.r, SLE_HeaderColor.g, SLE_HeaderColor.b)
		end

		-- achievements
		if showAchievements then
			for i = 1, numTrackedAchievements do
				local achievementID = trackedAchievements[i]
				
				local button = WatchButton:GetKeyed("achievement", achievementID)
				setButtonToAchievement(button, achievementID)
			end
		end
	end

	function setButtonToAchievement (button, achievementID)
		button.mouseHandler = mouseHandlerAchievement

		local id, achievementName, points, achievemntCompleted, _, _, _, achievementDesc, flags, image, rewardText, isGuildAch = GetAchievementInfo(achievementID)	
		button.id = achievementID

		local collapseCriteria = QuestKingDBPerChar.collapsedAchievements[achievementID]

		-- set title
		button.title:SetText(achievementName)
		if completed then
			button.title:SetTextColor(opt_colors.AchievementTitleComplete[1], opt_colors.AchievementTitleComplete[2], opt_colors.AchievementTitleComplete[3])
		else
			if isGuildAch then
				button.title:SetTextColor(opt_colors.AchievementTitleGuild[1], opt_colors.AchievementTitleGuild[2], opt_colors.AchievementTitleGuild[3])
			else
				button.title:SetTextColor(opt_colors.AchievementTitle[1], opt_colors.AchievementTitle[2], opt_colors.AchievementTitle[3])
			end
		end
		
		if collapseCriteria then
			button.title:SetAlpha(0.6)
		end
		
		-- criteria setup
		local numCriteria = GetAchievementNumCriteria(achievementID)
		local foundTimer = false
		local timeNow -- avoid multiple calls to GetTime()

		-- no criteria
		if (numCriteria == 0) then
			if (not collapseCriteria) then
				button:AddLine("  "..achievementDesc, nil, opt_colors.AchievementDescription[1], opt_colors.AchievementDescription[2], opt_colors.AchievementDescription[3]) -- no criteria exist, show desc line
			end
		end

		-- criteria loop
		for i = 1, numCriteria do
			local _
			local criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, name, flags, assetID, quantityString, criteriaID, eligible, duration, elapsed = GetAchievementCriteriaInfo(achievementID, i)
			
			-- set string
			if (bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
				criteriaString = quantityString
			else
				if (criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID) then -- meta achievement
					_, criteriaString = GetAchievementInfo(assetID)
				end
			end

			-- display criteria depending on timer state
			-- kinda wanna seperate this out, but display is dependent on timer logic (e.g. timeLeft > 0 forces display)

			--[[
			local timerTable = achievementTimers[criteriaID]
			if (timerTable) then
				duration = timerTable.duration
				elapsed = GetTime() - timerTable.startTime
			end
			if ((timerTable) and (duration) and (elapsed) and (elapsed < duration)) then
			--]]
			if ((duration) and (elapsed) and (elapsed < duration)) then
				foundTimer = true

				-- timer is running, force showing criteria
				if criteriaCompleted then
					button:AddLine("  "..criteriaString, nil, opt_colors.AchievementCriteriaComplete[1], opt_colors.AchievementCriteriaComplete[2], opt_colors.AchievementCriteriaComplete[3]) -- timer running, force showing completed objective
				else
					button:AddLine("  "..criteriaString, nil, opt_colors.AchievementCriteria[1], opt_colors.AchievementCriteria[2], opt_colors.AchievementCriteria[3]) -- timer running, force showing normal objective
				end
				
				-- adding timer line
				local timerBar = button:AddTimerBar(duration, GetTime() - elapsed)
				timerBar:SetStatusBarColor(opt_colors.AchievementTimer[1], opt_colors.AchievementTimer[2], opt_colors.AchievementTimer[3])
				
			else
				-- no timer exists / timer expired

				local timerTable = achievementTimers[criteriaID]
				if (timerTable) then
					achievementTimers[criteriaID] = nil
					achievementTimersMeta[achievementID] = nil
				end

				if (not criteriaCompleted) and (not collapseCriteria) then
					button:AddLine("  "..criteriaString, nil, opt_colors.AchievementCriteria[1], opt_colors.AchievementCriteria[2], opt_colors.AchievementCriteria[3]) -- no timer, show normally unless completed/collapsed
				end
			end
			
		end

		-- show "meta" timer if there is a timer on this achievement, but no associated criteria are found in GetAchievementNumCriteria (Salt and Pepper?)
		-- multiple timers would be a problem (it sets/unsets with whichever criteria timer fires last), but it's better than nothing
		if ((foundTimer == false) and (achievementTimersMeta[achievementID])) then
			local timerTable = achievementTimersMeta[achievementID]
			local duration = timerTable.duration
			local elapsed = GetTime() - timerTable.startTime

			if ((duration) and (elapsed) and (elapsed < duration)) then
				foundTimer = true

				local timerBar = button:AddTimerBar(timerTable.duration, timerTable.startTime)
				timerBar:SetStatusBarColor(opt_colors.AchievementTimerMeta[1], opt_colors.AchievementTimerMeta[2], opt_colors.AchievementTimerMeta[3])
			end
		end

		-- D(achievementName, foundTimer)

		if (foundTimer == false) then
			button:SetBackdropColor(0, 0, 0, 0)
			button:SetScript("OnUpdate", nil)
		else
			button.title:SetTextColor(opt_colors.AchievementTimedTitle[1], opt_colors.AchievementTimedTitle[2], opt_colors.AchievementTimedTitle[3])
			button:SetBackdropColor(opt_colors.AchievementTimedBackground[1], opt_colors.AchievementTimedBackground[2], opt_colors.AchievementTimedBackground[3], opt_colors.AchievementTimedBackground[4])
		end
		
	end

	function mouseHandlerAchievement:TitleButtonOnEnter (motion)
		local button = self.parent

		local link = GetAchievementLink(button.id)
		if link then
			_G["GameTooltip"]:SetOwner(self, E.private.sle.skins.QuestKing.tooltipAnchor)

			if opt.tooltipScale then
				if not GameTooltip.__QuestKingPreviousScale then
					GameTooltip.__QuestKingPreviousScale = GameTooltip:GetScale()
				end
				GameTooltip:SetScale(opt.tooltipScale)
			end

			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end

	function mouseHandlerAchievement:TitleButtonOnClick (mouse, down)
		local button = self.parent

		if (IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
			local achievementLink = GetAchievementLink(button.id)
			if (achievementLink) then
				ChatEdit_InsertLink(achievementLink)
				return
			end
		end
		if E.private.sle.skins.QuestKing.clickTemplate == "QuestKing" then
			QuestKingClickTemplate(button, mouse)
		elseif E.private.sle.skins.QuestKing.clickTemplate == "Blizzlike" then
			BlizzlikeClickTemplate(button, mouse)
		end
	end
end

T.tinsert(QK.Replaces, Replace)