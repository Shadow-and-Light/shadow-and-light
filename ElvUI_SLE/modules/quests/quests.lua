local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Q = SLE:NewModule("Quests", "AceEvent-3.0")
local B = LibStub("LibBabble-SubZone-3.0")
local BL = B:GetLookupTable()
local ObjectiveTracker_Expand, ObjectiveTracker_Collapse = ObjectiveTracker_Expand, ObjectiveTracker_Collapse
local statedriver = {
	["FULL"] = function(frame) 
		ObjectiveTracker_Expand()
		frame:Show()
	end,
	["COLLAPSED"] = function(frame)
		ObjectiveTracker_Collapse()
		frame:Show()
	end,
	["HIDE"] = function(frame)
		frame:Hide()
	end,
}

function Q:ChangeState(event)
	if T.InCombatLockdown() then self:RegisterEvent("PLAYER_REGEN_ENABLED", "ChangeState") return end
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	if not Q.db then return end
	if not Q.db.visibility then return end

	if T.GetZoneText() == BL.Frostwall or T.GetZoneText() == BL.Lunarfall then
		statedriver[Q.db.visibility.garrison](Q.frame)
	elseif IsResting() then
		statedriver[Q.db.visibility.rested](Q.frame)
	else
		local instance, instanceType = T.IsInInstance()
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
			statedriver["FULL"](Q.frame)
		end
		
	end
end

function Q:SelectQuestReward(index)
	local frame = QuestInfoFrame.rewardsFrame;

	local button = QuestInfo_GetRewardButton(frame, index)
	if (button.type == "choice") then
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetOutside(button.Icon)

		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then
			QuestInfoItemHighlight:SetPoint("TOPLEFT", button, "TOPLEFT", -8, 7);
		else
			button.Name:SetTextColor(1, 1, 0)
		end
		QuestInfoItemHighlight:Show()

		-- set choice
		QuestInfoFrame.itemChoice = button:GetID()
	end
end

function Q:QUEST_COMPLETE()
	if not Q.db.autoReward then return end
	local choice, highest = 1, 0
	local num = GetNumQuestChoices()

	if num <= 0 then return end -- no choices

	for index = 1, num do
		local link = GetQuestItemLink("choice", index);
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
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ChangeState")
	self:RegisterEvent("PLAYER_UPDATE_RESTING", "ChangeState")

	self:RegisterEvent("QUEST_COMPLETE");

	function Q:ForUpdateAll()
		Q.db = E.db.sle.quests
		Q:ChangeState()
	end
end

SLE:RegisterModule(Q:GetName())