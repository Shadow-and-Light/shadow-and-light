local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local _G = _G
--GLOBALS: hooksecurefunc

local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_GetCurrentChatFrameID = FCF_GetCurrentChatFrameID
local PanelTemplates_TabResize = PanelTemplates_TabResize

C.SelectedStrings = {
	["DEFAULT"] = "|cff%02x%02x%02x>|r %s |cff%02x%02x%02x<|r",
	["SQUARE"] = "|cff%02x%02x%02x[|r %s |cff%02x%02x%02x]|r",
	["HALFDEFAULT"] = "|cff%02x%02x%02x>|r %s",
	["CHECKBOX"] = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Criteria-Check:%s|t%s]],
	["ARROWRIGHT"] = [[|TInterface\BUTTONS\UI-SpellbookIcon-NextPage-Up:%s|t%s]],
	["ARROWDOWN"] = [[|TInterface\BUTTONS\UI-MicroStream-Green:%s|t%s]],
}
function C:SetSelectedTab(isForced)
	local selectedId = _G["GeneralDockManager"].selected:GetID()

	--Set/Remove brackets and set alpha of chat tabs
	for i=1, C.CreatedFrames do
		local tab = _G[T.format("ChatFrame%sTab", i)]
		if tab.isDocked then
			--Brackets
			if selectedId == tab:GetID() and C.db.tab.select then
				if tab.hasBracket ~= true or isForced then
					local color = C.db.tab.color
					if C.db.tab.style == "DEFAULT" or C.db.tab.style == "SQUARE" then
						tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, (FCF_GetChatWindowInfo(tab:GetID())), color.r * 255, color.g * 255, color.b * 255))
					elseif C.db.tab.style == "HALFDEFAULT" then
						tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, (FCF_GetChatWindowInfo(tab:GetID()))))
					else
						tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], (E.db.chat.tabFontSize + 12), (FCF_GetChatWindowInfo(tab:GetID()))))
					end
					tab.hasBracket = true
				end
			else
				if tab.hasBracket == true then
					local tabText = tab.isTemporary and tab.origText or (FCF_GetChatWindowInfo(tab:GetID()))
					tab.text:SetText(tabText)
					tab.hasBracket = false
				end
			end
		end

		--Prevent chat tabs changing width on each click.
		PanelTemplates_TabResize(tab, tab.isTemporary and 20 or 10, nil, nil, nil, tab.textWidth);
	end
end

function C:OpenTemporaryWindow()
	local chatID = FCF_GetCurrentChatFrameID()
	local tab = _G[T.format("ChatFrame%sTab", chatID)]
	tab.origText = (FCF_GetChatWindowInfo(tab:GetID()))
	E:Delay(0.2, function() C:SetSelectedTab() end)
end

function C:DelaySetSelectedTab()
	C:ScheduleTimer('SetSelectedTab', 1)
end

function C:SetTabWidth()
	for i=1, C.CreatedFrames do
		local tab = _G[T.format("ChatFrame%sTab", i)]
		PanelTemplates_TabResize(tab, tab.isTemporary and 20 or 10, nil, nil, nil, tab.textWidth);
	end
end

function C:InitTabs()
	hooksecurefunc("FCFDockOverflowListButton_OnClick", C.SetSelectedTab)
	hooksecurefunc("FCF_Close", C.SetSelectedTab)
	hooksecurefunc("FCF_OpenNewWindow", C.DelaySetSelectedTab)
	hooksecurefunc("FCF_OpenTemporaryWindow", C.OpenTemporaryWindow)
	hooksecurefunc("FCF_DockUpdate", C.SetTabWidth)
	C:SetSelectedTab()
end