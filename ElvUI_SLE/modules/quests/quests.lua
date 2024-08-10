local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local Q = SLE.Quests

local C_Item_GetItemInfo = C_Item.GetItemInfo
local _G = _G

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
			local price = select(11, C_Item_GetItemInfo(link))
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

	Q:RegisterEvent('QUEST_COMPLETE')

	function Q:ForUpdateAll()
		Q.db = E.db.sle.quests
	end
end

SLE:RegisterModule(Q:GetName())
