local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Q = SLE.Quests
local ObjectiveTracker_Expand, ObjectiveTracker_Collapse = ObjectiveTracker_Expand, ObjectiveTracker_Collapse
local IsResting = IsResting
local _G = _G

local HeaderMenuMinimizeButton = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
local QuestHeaderMinimizeButton = _G.ObjectiveTrackerBlocksFrame.QuestHeader.MinimizeButton
local statedriver = {
	FULL = function(frame)
		ObjectiveTracker_Expand()
		if E.private.skins.blizzard.enable and E.private.skins.blizzard.objectiveTracker then HeaderMenuMinimizeButton.tex:SetTexture([[Interface\AddOns\ElvUI\Core\Media\Textures\MinusButton]]) end
		if ObjectiveTrackerBlocksFrame.QuestHeader.module.collapsed then
			ObjectiveTracker_MinimizeModuleButton_OnClick(QuestHeaderMinimizeButton)
		end
		frame:Show()
	end,
	COLLAPSED = function(frame)
		ObjectiveTracker_Collapse()
		if E.private.skins.blizzard.enable and E.private.skins.blizzard.objectiveTracker then HeaderMenuMinimizeButton.tex:SetTexture([[Interface\AddOns\ElvUI\Core\Media\Textures\PlusButton]]) end
		frame:Show()
	end,
	COLLAPSED_QUESTS = function(frame)
		if not ObjectiveTrackerBlocksFrame.QuestHeader.module.collapsed then
			ObjectiveTracker_MinimizeModuleButton_OnClick(QuestHeaderMinimizeButton)
		end
		frame:Show()
	end,
	HIDE = function(frame)
		frame:Hide()
	end,
}

function Q:ChangeState(event)
	if not Q.db or not Q.db.visibility or not Q.db.visibility.enable then return end
	if InCombatLockdown() and event ~= 'PLAYER_REGEN_DISABLED' then return end
	local inCombat = event == 'PLAYER_REGEN_DISABLED' and true or false

	if inCombat and Q.db.visibility.combat ~= 'NONE' then
		statedriver[Q.db.visibility.combat](Q.frame)
	elseif C_Garrison.IsPlayerInGarrison(2) then
		statedriver[Q.db.visibility.garrison](Q.frame)
	elseif C_Garrison.IsPlayerInGarrison(3) then --here be order halls
		statedriver[Q.db.visibility.orderhall](Q.frame)
	elseif IsResting() then
		statedriver[Q.db.visibility.rested](Q.frame)
	else
		local instance, instanceType = IsInInstance()
		if instance then
			if instanceType == 'pvp' then
				statedriver[Q.db.visibility.bg](Q.frame)
			elseif instanceType == 'arena' then
				statedriver[Q.db.visibility.arena](Q.frame)
			elseif instanceType == 'party' then
				statedriver[Q.db.visibility.dungeon](Q.frame)
			elseif instanceType == 'scenario' then
				statedriver[Q.db.visibility.scenario](Q.frame)
			elseif instanceType == 'raid' then
				statedriver[Q.db.visibility.raid](Q.frame)
			end
		else
			statedriver['FULL'](Q.frame)
		end
	end
	if WorldQuestTrackerAddon and SLE._Compatibility['WorldQuestTracker'] then -- and WorldQuestTrackerAddon then
		local y = 0
		for i = 1, #ObjectiveTrackerFrame.MODULES do
			local module = ObjectiveTrackerFrame.MODULES[i]
			if (module.Header:IsShown()) then
				y = y + module.contentsHeight
			end
		end
		if (ObjectiveTrackerFrame.collapsed) then
			WorldQuestTrackerAddon.TrackerHeight = 20
		else
			WorldQuestTrackerAddon.TrackerHeight = y
		end

		WorldQuestTrackerAddon.RefreshTrackerAnchor()
	end
end

function Q:SelectQuestReward(index)
	local frame = QuestInfoFrame.rewardsFrame

	local button = QuestInfo_GetRewardButton(frame, index)
	if (button.type == 'choice') then
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetOutside(button.Icon)

		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then
			QuestInfoItemHighlight:SetPoint('TOPLEFT', button, 'TOPLEFT', -8, 7)
		else
			button.Name:SetTextColor(1, 1, 0)
		end
		QuestInfoItemHighlight:Show()

		-- Set Choice
		_G.QuestInfoFrame.itemChoice = button:GetID()
	end
end

function Q:QUEST_COMPLETE()
	if not Q.db.autoReward then return end
	local choice, highest = 1, 0
	local num = GetNumQuestChoices()

	if num <= 0 then return end -- no choices

	for index = 1, num do
		local link = GetQuestItemLink('choice', index)
		if link then
			local price = select(11, GetItemInfo(link))
			if price and price > highest then
				highest = price
				choice = index
			end
		end
	end

	Q:SelectQuestReward(choice)
end

function Q:Initialize()
	if not SLE.initialized then return end
	Q.db = E.db.sle.quests
	Q.frame = ObjectiveTrackerFrame

	Q:RegisterEvent('LOADING_SCREEN_DISABLED', 'ChangeState')
	Q:RegisterEvent('PLAYER_UPDATE_RESTING', 'ChangeState')
	Q:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'ChangeState')
	Q:RegisterEvent('PLAYER_REGEN_ENABLED', 'ChangeState')
	Q:RegisterEvent('PLAYER_REGEN_DISABLED', 'ChangeState')

	Q:RegisterEvent('QUEST_COMPLETE')

	function Q:ForUpdateAll()
		Q.db = E.db.sle.quests
		Q:ChangeState()
	end
end

SLE:RegisterModule(Q:GetName())
