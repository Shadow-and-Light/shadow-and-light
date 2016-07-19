local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local QK = SLE:GetModule("QuestKingSkinner")
local _G = _G

if not SLE._Compatibility["QuestKing"] then return end

local function Replace()
	local QuestKing = _G["QuestKing"]
	local rewardQueue = {}
	local animatingData

	function QuestKing:AddReward (button, questID, xp, money)
		local data = {}
		data.button = button
		data.questID = questID

		-- save all the rewards
		data.rewards = {}

		-- xp
		if ((not xp) and (questID)) then
			xp = GetQuestLogRewardXP(questID)
		end

		if ((xp) and (xp > 0) and (UnitLevel("player") < MAX_PLAYER_LEVEL)) then
			local t = {}
			t.label = xp
			t.texture = "Interface\\Icons\\XP_Icon"
			t.count = 0
			t.font = "NumberFontNormal"
			tinsert(data.rewards, t)
		end
		
		if (questID) then
			-- currencies
			local numCurrencies = GetNumQuestLogRewardCurrencies(questID)
			for i = 1, numCurrencies do
				local name, texture, count = GetQuestLogRewardCurrencyInfo(i, questID)
				local t = {}
				t.label = name
				t.texture = texture
				t.count = count
				t.font = "GameFontHighlightSmall"
				tinsert(data.rewards, t)
			end

			-- items
			local numItems = GetNumQuestLogRewards(questID)
			for i = 1, numItems do
				local name, texture, count, quality, isUsable = GetQuestLogRewardInfo(i, questID)
				local t = { }
				t.label = name
				t.texture = texture
				t.count = count
				t.font = "GameFontHighlightSmall"
				tinsert(data.rewards, t)
			end	
		end

		-- money
		if ((not money) and (questID)) then
			money = GetQuestLogRewardMoney(questID)
		end
		if (money) and (money > 0) then
			local t = {}
			t.label = GetMoneyString(money)
			t.texture = "Interface\\Icons\\inv_misc_coin_01"
			t.count = 0
			t.font = "GameFontHighlight"
			tinsert(data.rewards, t)
		end

		-- try to play it
		if (#data.rewards > 0) then
			tinsert(rewardQueue, data)
			QuestKing:AnimateReward()
		elseif (questID) then
			C_Timer.After(10, function ()
				QuestKing:ClearDummyTask(questID)
				QuestKing:UpdateTracker()
			end)
		end
	end
	
	local function IsFramePositionedLeft(frame)
		local x = frame:GetCenter()
		local screenWidth = GetScreenWidth()
		local screenHeight = GetScreenHeight()
		local positionedLeft = false

		if x and x < (screenWidth / 2) then
			positionedLeft = true;
		end

		return positionedLeft;
	end

	function QuestKing:AnimateReward (block)
		local rewardsFrame = QuestKing_RewardsFrame

		if (rewardsFrame.Anim:IsPlaying()) then
			return
		end

		if (#rewardQueue == 0) then
			rewardsFrame:Hide()
			return
		end

		local data = tremove(rewardQueue, 1)
		animatingData = data

		local button = data.button
		if ((not button) or (not button:IsVisible())) then
			button = QuestKing.Tracker
			data.button = button
		end

		-- rewardsFrame:SetParent(button)
		rewardsFrame:ClearAllPoints()
		-- rewardsFrame:SetPoint("TOPRIGHT", button, "TOPLEFT", 10, -4)
		local scale = QuestKing.Tracker:GetScale()

		if E.db.general.bonusObjectivePosition == "RIGHT" or (E.db.general.bonusObjectivePosition == "AUTO" and IsFramePositionedLeft(ObjectiveTrackerFrame)) then
			rewardsFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", button:GetRight() * scale - 10, button:GetTop() * scale + 0)
		else
			rewardsFrame:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", button:GetLeft() * scale + 10, button:GetTop() * scale + 0)
		end
		rewardsFrame:Show()

		local numRewards = #data.rewards
		local contentsHeight = 12 + numRewards * 36

		rewardsFrame.Anim.RewardsBottomAnim:SetOffset(0, -contentsHeight)
		rewardsFrame.Anim.RewardsShadowAnim:SetToScale(0.8, contentsHeight / 16)
		rewardsFrame.Anim:Play()

		PlaySoundKitID(45142) --UI_BonusEventSystemVignettes

		-- configure reward frames
		for i = 1, numRewards do
			local rewardItem = rewardsFrame.Rewards[i]
			if (not rewardItem) then
				rewardItem = CreateFrame("FRAME", nil, rewardsFrame, "QuestKing_RewardTemplate")
				rewardItem:SetPoint("TOPLEFT", rewardsFrame.Rewards[i-1], "BOTTOMLEFT", 0, -4)
			end

			local rewardData = data.rewards[i]
			if (rewardData.count > 1) then
				rewardItem.Count:Show()
				rewardItem.Count:SetText(rewardData.count)
			else
				rewardItem.Count:Hide()
			end

			rewardItem.Label:SetFontObject(rewardData.font)
			rewardItem.Label:SetText(rewardData.label)
			rewardItem.ItemIcon:SetTexture(rewardData.texture)
			rewardItem:Show()

			if (rewardItem.Anim:IsPlaying()) then
				rewardItem.Anim:Stop()
			end

			rewardItem.Anim:Play()
		end

		-- hide unused reward items
		for i = numRewards + 1, #rewardsFrame.Rewards do
			rewardsFrame.Rewards[i]:Hide()
		end
	end

	function QuestKing_OnAnimateRewardDone()
		local completedData = animatingData
		if (completedData.questID) then
			local questID = completedData.questID
			C_Timer.After(3, function ()
				QuestKing:ClearDummyTask(questID)
				QuestKing:UpdateTracker()
			end)
		end

		animatingData = nil
		QuestKing:AnimateReward()
	end
	
	QuestKing_RewardsFrame.Anim:SetScript("OnFinished", QuestKing_OnAnimateRewardDone)
end

T.tinsert(QK.Replaces, Replace)