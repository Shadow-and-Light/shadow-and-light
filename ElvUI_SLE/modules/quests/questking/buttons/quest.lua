local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local IsShiftKeyDown = IsShiftKeyDown
local IsAltKeyDown = IsAltKeyDown
local RemoveQuestWatch = RemoveQuestWatch
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestWatchInfo = GetQuestWatchInfo
local GetQuestWatchIndex = GetQuestWatchIndex
local IsQuestSequenced = IsQuestSequenced
local GetQuestLogRequiredMoney = GetQuestLogRequiredMoney
local GetMoneyString = GetMoneyString
local GetNumQuestWatches = GetNumQuestWatches

local prev_GetNumQuestLogEntries = 0
local prev_GetNumQuestWatches = 0

local buildQuestSortTable
local setButtonToQuest
local headerList = {}
local questSortTable = {}
local mouseHandlerQuest = {}

local function Replace()
	local QuestKing = _G["QuestKing"]
	local WatchButton = QuestKing.WatchButton
	local getObjectiveColor = QuestKing.GetObjectiveColor
	local getQuestTaggedTitle = QuestKing.GetQuestTaggedTitle
	local matchObjective = QuestKing.MatchObjective
	local matchObjectiveRep = QuestKing.MatchObjectiveRep
	-- options
	local opt = QuestKing.options
	local opt_colors = opt.colors
	local opt_itemAnchorSide = opt.itemAnchorSide
	local opt_showCompletedObjectives = opt.showCompletedObjectives
	
	local function QuestKingClickTemplate(button, mouse)
		if (IsShiftKeyDown()) and (_G["ClassicQuestLog"]) then
			SelectQuestLogEntry(button.questLogIndex)
			if _G["ClassicQuestLog"]:IsVisible() then
				_G["ClassicQuestLog"]:OnShow()
			else
				_G["ClassicQuestLog"]:SetShown(true)
			end
			return
		end

		if IsAltKeyDown() then
			if mouse == "RightButton" then
				RemoveQuestWatch(button.questLogIndex)
				QuestKing:UpdateTracker()
				return
			else
				if _G["QuestKingDBPerChar"].collapsedQuests[button.questID] then
					_G["QuestKingDBPerChar"].collapsedQuests[button.questID] = nil
				else
					_G["QuestKingDBPerChar"].collapsedQuests[button.questID] = true
				end
				QuestKing:UpdateTracker()
				return
			end
		end

		if mouse == "RightButton" then
			-- WORLDMAP_SETTINGS.selectedQuestId = button.questID
			if (GetSuperTrackedQuestID() == button.questID) then
				QuestKing:SetSuperTrackedQuestID(0)
				QuestKing:UpdateTracker()
			else
				QuestKing:SetSuperTrackedQuestID(button.questID)
				QuestKing:UpdateTracker()
			end
			-- QuestPOIUpdateIcons()
			-- if WorldMapFrame:IsShown() then
			-- 	HideUIPanel(WorldMapFrame)
			-- 	ShowUIPanel(WorldMapFrame)
			-- end
		else
			-- if (QuestLogFrame:IsShown()) and (QuestLogFrame.selectedIndex == button.questLogIndex) then
			-- 	HideUIPanel(QuestLogFrame)
			-- else
			-- 	QuestLog_OpenToQuest(button.questLogIndex)
			-- 	ShowUIPanel(QuestLogFrame)
			-- end
			QuestObjectiveTracker_OpenQuestMap(nil, button.questLogIndex)
		end	
	end

	local function BlizzlikeClickTemplate(button, mouse)
		if (not IsShiftKeyDown()) and (_G["ClassicQuestLog"]) then
			SelectQuestLogEntry(button.questLogIndex)
			if _G["ClassicQuestLog"]:IsVisible() then
				_G["ClassicQuestLog"]:OnShow()
			else
				_G["ClassicQuestLog"]:SetShown(true)
			end
			return
		end
		if IsShiftKeyDown() then
			if mouse == "RightButton" then
				if (GetSuperTrackedQuestID() == button.questID) then
					QuestKing:SetSuperTrackedQuestID(0)
					QuestKing:UpdateTracker()
				else
					QuestKing:SetSuperTrackedQuestID(button.questID)
					QuestKing:UpdateTracker()
				end
				return
			else
				RemoveQuestWatch(button.questLogIndex)
				QuestKing:UpdateTracker()
				return
			end
		end
		if IsControlKeyDown() then 
			if _G["QuestKingDBPerChar"].collapsedQuests[button.questID] then
				_G["QuestKingDBPerChar"].collapsedQuests[button.questID] = nil
			else
				_G["QuestKingDBPerChar"].collapsedQuests[button.questID] = true
			end
			QuestKing:UpdateTracker()
			return
		end
		if mouse == "RightButton" then
			ObjectiveTracker_ToggleDropDown(button, QuestObjectiveTracker_OnOpenDropDown)
		else
			CloseDropDownMenus();
			if _G["ClassicQuestLog"] then
				SelectQuestLogEntry(button.questLogIndex)
				if _G["ClassicQuestLog"]:IsVisible() then
					_G["ClassicQuestLog"]:OnShow()
				else
					_G["ClassicQuestLog"]:SetShown(true)
				end
				return
			else
				QuestObjectiveTracker_OpenQuestMap(nil, button.questLogIndex)
				return
			end
		end
	end

	function buildQuestSortTable ()
		for k,v in T.pairs(questSortTable) do
			T.twipe(questSortTable[k])
		end
		T.twipe(headerList)
		
		local numEntries = GetNumQuestLogEntries()
		local currentHeader = "(Unknown 0)"
		
		local numQuests = 0
		for i = 1, numEntries do
			local title, _, _, isHeader, isCollapsed, _, _, questID = GetQuestLogTitle(i)
			if (not title) or (title == "") then
				title = T.format("(Unknown %d)", i)
			end

			if (isHeader) then

				if not questSortTable[title] then
					questSortTable[title] = {}
				end

				if (title ~= currentHeader) then
					-- new header found
					-- note: quest "Safe Passage" in Frostfire Ridge is under a duplicate zone header
					currentHeader = title
					T.tinsert(headerList, title)
				end

			elseif (not isHeader) and (IsQuestWatched(i)) then
				if (not questSortTable[currentHeader]) then
					questSortTable[currentHeader] = {}
				end

				T.tinsert(questSortTable[currentHeader], i)
			end
			
			if (not isHeader) then
				numQuests = numQuests + 1
			end
		end
		
		-- totalQuestCount = numQuests
	end

	function setButtonToQuest(button, questLogIndex)
		button.mouseHandler = mouseHandlerQuest

		local questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(questLogIndex)

		button.questLogIndex = questLogIndex
		button.questID = questID

		local collapseObjectives = QuestKingDBPerChar.collapsedQuests[questID]

		-- set title
		local taggedTitle = getQuestTaggedTitle(questLogIndex)

		if (GetSuperTrackedQuestID() == questID) then
			local icon = E.private.sle.skins.QuestKing.trackerIcon == "DEFAULT" and [[Interface\Scenarios\ScenarioIcon-Combat]] or E.private.sle.skins.QuestKing.trackerIcon == "CUSTOM" and E.private.sle.skins.QuestKing.trackerIconCustom or QK.Icons[E.private.sle.skins.QuestKing.trackerIcon]
			local size =  E.private.sle.skins.QuestKing.trackerSize
			taggedTitle = taggedTitle .. " |T"..icon..":"..size..":"..size..":-1:0|t"
		end

		if (isComplete == -1) then
			button.title:SetFormattedTextIcon("|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0:0:1:0|t %s", taggedTitle)
		else
			button.title:SetTextIcon(taggedTitle)
		end

		-- add objectives
		local numObj = GetNumQuestLeaderBoards(questLogIndex) or 0
		local completedObj = 0
		local displayedObj = 0

		for i = 1, numObj do
			local objectiveDesc, objectiveType, objectiveIsDone = GetQuestLogLeaderBoard(i, questLogIndex)

			if (objectiveIsDone) then
				completedObj = completedObj + 1
			end

			local displayObjective = true
			if (collapseObjectives) then
				-- hide for collapsed quest
				displayObjective = false
			elseif (isComplete == 1) and (opt_showCompletedObjectives ~= "always") then
				-- hide for complete quest (unless show type is "always")
				displayObjective = false
			elseif (objectiveIsDone) and (opt_showCompletedObjectives == false) then
				-- hide for completed objectives if showCompletedObjectives is false
				displayObjective = false
			elseif (objectiveDesc == nil) then
				-- hide invalid objectives
				displayObjective = false
			end

			-- types:
			-- event, reputation, item, log(Direbrew's Dire Brew), monster, object?, spell(Frost Nova)
			if (displayObjective) then
				local quantCur, quantMax, quantName = matchObjective(objectiveDesc)

				if (objectiveType == "reputation") then
					quantCur, quantMax, quantName = matchObjectiveRep(objectiveDesc)

					local r, g, b = getObjectiveColor(objectiveIsDone and 1 or 0)
					local line
					if (not quantName) then
						line = button:AddLine(T.format("  %s", objectiveDesc), nil, r, g, b)
					else
						line = button:AddLine(T.format("  %s", quantName), T.format(": %s / %s", quantCur, quantMax), r, g, b)
					end

					objectiveIsDone = not not objectiveIsDone
					if ((line._lastQuant == false) and (objectiveIsDone == true)) then
						line:Flash()
					end
					line._lastQuant = objectiveIsDone

					displayedObj = displayedObj + 1

				elseif (not quantName) or (objectiveType == "spell") then
					if ((displayObjective) or (not objectiveIsDone)) then
						local r, g, b = getObjectiveColor(objectiveIsDone and 1 or 0)
						local line = button:AddLine(T.format("  %s", objectiveDesc), nil, r, g, b)

						---- FIXME: test this!
						objectiveIsDone = not not objectiveIsDone
						if ((line._lastQuant == false) and (objectiveIsDone == true)) then
							line:Flash()
						end
						line._lastQuant = objectiveIsDone

						displayedObj = displayedObj + 1
					end

				else
					if ((displayObjective) or (not objectiveIsDone)) then
						local r, g, b = getObjectiveColor(quantCur / quantMax)
						local line = button:AddLine(T.format("  %s", quantName), T.format(": %s/%s", quantCur, quantMax), r, g, b)

						local lastQuant = line._lastQuant
						if ((lastQuant) and (quantCur > lastQuant)) then
							line:Flash()
						end
						line._lastQuant = quantCur

						displayedObj = displayedObj + 1
					end
				end
			end
			
		end

		-- money
		local requiredMoney = GetQuestLogRequiredMoney(questLogIndex)
		if (requiredMoney > 0) then
			QuestKing.watchMoney = true
			local playerMoney = GetMoney()

			-- not sure about this, but the default watch frame does it
			-- (fake completion for gold-requiring connectors when gold req is met and no event begins)
			if (numObj == 0 and playerMoney >= requiredMoney and not startEvent) then
				isComplete = 1
			end

			numObj = numObj + 1 -- (questking only) ensure all gold-requiring quests aren't marked as connectors

			if (not collapseObjectives) then -- hide entirely if objectives are collapsed
				if playerMoney >= requiredMoney then
					-- show met gold amounts only for incomplete quests
					if (isComplete ~= 1) and (opt_showCompletedObjectives) then
						local r, g, b = getObjectiveColor(1)
						button:AddLine(L["SLE_QUESTKING_Required"]..GetMoneyString(requiredMoney), nil, r, g, b)
					end
				else
					-- always show unmet gold amount
					local r, g, b = getObjectiveColor(0)
					button:AddLine(L["SLE_QUESTKING_Required"]..GetMoneyString(requiredMoney), nil, r, g, b)
				end
			end
		end

		local _, _, _, _, _, _, _, _, failureTime, timeElapsed = GetQuestWatchInfo(GetQuestWatchIndex(questLogIndex))

		-- timer
		if (failureTime) then
			if (timeElapsed) then
				local timerBar = button:AddTimerBar(failureTime, T.GetTime() - timeElapsed)
				timerBar:SetStatusBarColor(opt_colors.QuestTimer[1], opt_colors.QuestTimer[2], opt_colors.QuestTimer[3])
			end
		end

		-- set title colour
		if (isComplete == -1) then
			-- failed
			button.title:SetTextColor(opt_colors.ObjectiveFailed[1], opt_colors.ObjectiveFailed[2], opt_colors.ObjectiveFailed[3])
		elseif (isComplete == 1) then
			if GetQuestLogIsAutoComplete(questLogIndex) then
				-- autocomplete
				button.title:SetTextColor(opt_colors.QuestCompleteAuto[1], opt_colors.QuestCompleteAuto[2], opt_colors.QuestCompleteAuto[3])
			elseif (numObj == 0) then
				-- connector quest [type c] (complete, 0/0 objectives)
				button.title:SetTextColor(opt_colors.QuestConnector[1], opt_colors.QuestConnector[2], opt_colors.QuestConnector[3])
			else
				-- completed quest (complete, n/n objectives)
				button.title:SetTextColor(opt_colors.ObjectiveComplete[1], opt_colors.ObjectiveComplete[2], opt_colors.ObjectiveComplete[3])
			end
		else
			if numObj == 0 then
				-- connector quest [type i] (incomplete, 0/0 objectives)
				button.title:SetTextColor(opt_colors.QuestConnector[1], opt_colors.QuestConnector[2], opt_colors.QuestConnector[3])
			elseif numObj == completedObj then
				-- unknown state (incomplete, n/n objectives where n>0)
				button.title:SetTextColor(1, 0, 1)
			else
				-- incomplete quest (incomplete, n/m objectives where m>n)
				local color = GetQuestDifficultyColor(level)
				button.title:SetTextColor(color.r, color.g, color.b)
			end
		end

		if collapseObjectives then
			button.title:SetAlpha(0.6)
		end

		-- add item button
		local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex)
		local itemButton
		if opt_itemAnchorSide and item and ((isComplete ~= 1) or (showItemWhenComplete)) then
			if T.InCombatLockdown() then
				QuestKing:StartCombatTimer()
			else
				itemButton = button:SetItemButton(questLogIndex, link, item, charges, displayedObj)
			end

		else
			if (button.itemButton) then
				if T.InCombatLockdown() then
					QuestKing:StartCombatTimer()
				else
					button:RemoveItemButton()
				end
			end
		end

		if (button.fresh) then
			if (QuestKing.newlyAddedQuests[questID]) then
				button:Pulse(0.9, 0.6, 0.2)
				QuestKing.newlyAddedQuests[questID] = nil
			end
		end

		-- quests enter a state of unknown completion (isComplete == nil) when zoning between instances.
		-- since they also has no objectives in this state, we completely ignore completion changes for quests with no objectives
		if (numObj > 0) then
			if (isComplete == 1) and (button._questCompleted == false) then
				button:Pulse(0.2, 0.6, 0.9)
				QuestKing:OnQuestObjectivesCompleted(questID)
			end
			button._questCompleted = not not (isComplete == 1)
		end	

		-- animate sequenced quests
		if ((not button.fresh) and IsQuestSequenced(questID)) then
			local lastNumObj = button._lastNumObj

			if ((lastNumObj) and (lastNumObj > 0) and (numObj > lastNumObj)) then
				-- do animations [FIXME: test this]
				PlaySound("UI_QuestRollingForward_01")
				local lines = button.lines
				for i = 1, #lines do
					if (i > lastNumObj) then
						local line = lines[i]
						line:Glow(opt_colors.ObjectiveChangedGlow[1], opt_colors.ObjectiveChangedGlow[2], opt_colors.ObjectiveChangedGlow[3])
					end
				end
			end
			button._lastNumObj = numObj
		end

	end

	function QuestKing:UpdateTrackerQuests()
		local headerName, questLogIndex
		for i = 1, #headerList do
			headerName = headerList[i]
			-- header
			if #questSortTable[headerName] > 0 then
				local button = QuestKing.WatchButton:GetKeyed("collapser", headerName)
				button._headerName = headerName
				
				--|TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2:red:green:blue|t
				--[[Altered part to allow for using S&L's objective tracker skin options for colors]]
				local SLE_HeaderColor = E.db.sle.skins.objectiveTracker.colorHeader
				if QuestKingDBPerChar.collapsedHeaders[headerName] then
					button.title:SetTextIcon("|TInterface\\AddOns\\QuestKing\\textures\\UI-SortArrow_sm_right:8:8:0:-1:0:0:0:0:0:0:1:1:1|t "..headerName)
				else
					button.title:SetTextIcon("|TInterface\\AddOns\\QuestKing\\textures\\UI-SortArrow_sm_down:8:8:0:-1:0:0:0:0:0:0:1:1:1|t "..headerName)
				end
				button.title:SetTextColor(SLE_HeaderColor.r, SLE_HeaderColor.g, SLE_HeaderColor.b)
			end

			-- quests
			
			if not QuestKingDBPerChar.collapsedHeaders[headerName] then
				for j = 1, #questSortTable[headerName] do
					questLogIndex = questSortTable[headerName][j]
					local _,_,_,_,_,_,_, questID = GetQuestLogTitle(questLogIndex)
					local button = QuestKing.WatchButton:GetKeyed("quest", questID)
					setButtonToQuest(button, questLogIndex)
				end
			end
		end

	end

	function QuestKing:CheckQuestSortTable (forceBuild)
		if (forceBuild) then
			buildQuestSortTable()
			prev_GetNumQuestLogEntries = GetNumQuestLogEntries()
			prev_GetNumQuestWatches = GetNumQuestWatches()
		else
			local numEntries = GetNumQuestLogEntries()
			local numWatches = GetNumQuestWatches()

			if (numEntries ~= prev_GetNumQuestLogEntries) or (numWatches ~= prev_GetNumQuestWatches) then
				buildQuestSortTable()
				prev_GetNumQuestLogEntries = numEntries
				prev_GetNumQuestWatches = numWatches
			end
		end
	end

	function mouseHandlerQuest:TitleButtonOnEnter (motion)
		local button = self.parent

		local link = GetQuestLink(button.questLogIndex)
		if link then
			_G["GameTooltip"]:SetOwner(self, E.private.sle.skins.QuestKing.tooltipAnchor)

			if opt.tooltipScale then
				if not _G["GameTooltip"].__QuestKingPreviousScale then
					_G["GameTooltip"].__QuestKingPreviousScale = GameTooltip:GetScale()
				end
				_G["GameTooltip"]:SetScale(E.private.sle.skins.QuestKing.enable and E.private.sle.skins.QuestKing.tooltipScale or opt.tooltipScale)
			end

			_G["GameTooltip"]:SetHyperlink(link)
			_G["GameTooltip"]:Show()
		end
	end

	function mouseHandlerQuest:TitleButtonOnClick (mouse, down)
		local button = self.parent

		if (IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
			local questLink = GetQuestLink(button.questLogIndex)
			if (questLink) then
				ChatEdit_InsertLink(questLink)
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