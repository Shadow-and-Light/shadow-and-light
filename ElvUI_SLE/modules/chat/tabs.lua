local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local CH = E:GetModule('Chat')
local _G = _G
--GLOBALS: hooksecurefunc

local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_GetCurrentChatFrameID = FCF_GetCurrentChatFrameID
local PanelTemplates_TabResize = PanelTemplates_TabResize
local GENERAL_CHAT_DOCK = GENERAL_CHAT_DOCK

C.SelectedStrings = {
	["DEFAULT"] = "|cff%02x%02x%02x>|r %s |cff%02x%02x%02x<|r",
	["SQUARE"] = "|cff%02x%02x%02x[|r %s |cff%02x%02x%02x]|r",
	["HALFDEFAULT"] = "|cff%02x%02x%02x>|r %s",
	["CHECKBOX"] = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Criteria-Check:%s|t%s]],
	["ARROWRIGHT"] = [[|TInterface\BUTTONS\UI-SpellbookIcon-NextPage-Up:%s|t%s]],
	["ARROWDOWN"] = [[|TInterface\BUTTONS\UI-MicroStream-Green:%s|t%s]],
}

function C:ApplySelectedTabIndicator(tab, title)
	local color = C.db.tab.color
	if C.db.tab.style == "DEFAULT" or C.db.tab.style == "SQUARE" then
		tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, title, color.r * 255, color.g * 255, color.b * 255))
	elseif C.db.tab.style == "HALFDEFAULT" then
		tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, title))
	else
		tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], (E.db.chat.tabFontSize + 12), title))
	end
	tab.hasBracket = true
end

function C:SetSelectedTab(isForced)
	if C.CreatedFrames == 0 then C:DelaySetSelectedTab() return end
	local selectedId = _G["GeneralDockManager"].selected:GetID()
	
	--Set/Remove brackets and set alpha of chat tabs
	for chatID = 1, C.CreatedFrames do
		local tab = _G[T.format("ChatFrame%sTab", chatID)]
		if tab.isDocked then
			--Brackets
			if selectedId == tab:GetID() and C.db.tab.select then
				local title = FCF_GetChatWindowInfo(tab:GetID())
				if tab.hasBracket ~= true or isForced then C:ApplySelectedTabIndicator(tab, title) end
			else
				if tab.hasBracket == true then
					local tabText = tab.isTemporary and tab.origText or (FCF_GetChatWindowInfo(tab:GetID()))
					tab.text:SetText(tabText)
					tab.hasBracket = false
				end
			end
		end
		--Prevent chat tabs changing width on each click.
		if C.db.tab.resize then
			PanelTemplates_TabResize(tab, tab.isTemporary and 20 or 10, nil, nil, nil, tab.textWidth);
		else
			FCFDock_UpdateTabs(GENERAL_CHAT_DOCK, true)
		end
	end
end

function C:OpenTemporaryWindow()
	local chatID = FCF_GetCurrentChatFrameID()
	local tab = _G[T.format("ChatFrame%sTab", chatID)]
	tab.origText = (FCF_GetChatWindowInfo(tab:GetID()))
	E:Delay(0.2, function() C:SetSelectedTab(); C:SetTabWidth() end)
end

function C:SetTabWidth()
	if C.db.tab.resize then
		for chatID = 1, C.CreatedFrames do
			local tab = _G[T.format("ChatFrame%sTab",  chatID)]
			PanelTemplates_TabResize(tab, tab.isTemporary and 20 or 10, nil, nil, nil, tab.textWidth);
		end
	else
		FCFDock_UpdateTabs(GENERAL_CHAT_DOCK, true)
	end
end

function C:DelaySetSelectedTab()
	E:Delay(0.2, function() C:SetSelectedTab(); C:SetTabWidth() end)
end

function C:InitTabs()
	hooksecurefunc("FCFDockOverflowListButton_OnClick", C.SetSelectedTab)
	hooksecurefunc("FCF_Close", C.SetSelectedTab)
	hooksecurefunc("FCF_OpenNewWindow", C.DelaySetSelectedTab)
	hooksecurefunc("FCF_OpenTemporaryWindow", C.OpenTemporaryWindow)
	hooksecurefunc("FCF_DockUpdate", C.SetTabWidth)

	C:DelaySetSelectedTab()
end