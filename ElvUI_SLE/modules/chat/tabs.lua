local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local CH = E:GetModule('Chat')
local _G = _G
--GLOBALS: hooksecurefunc

local FCFDockScrollFrame_JumpToTab = FCFDockScrollFrame_JumpToTab
local FCF_GetCurrentChatFrameID = FCF_GetCurrentChatFrameID
local FCFDock_GetSelectedWindow = FCFDock_GetSelectedWindow
local FCFTab_UpdateAlpha = FCFTab_UpdateAlpha
local FCFTab_UpdateColors = FCFTab_UpdateColors
local FCFDock_ScrollToSelectedTab = FCFDock_ScrollToSelectedTab
local FCFDock_CalculateTabSize = FCFDock_CalculateTabSize
local PanelTemplates_TabResize = PanelTemplates_TabResize

--This variable is used to see if overflow button should be shown when using non-blizz width
C.TotalTabsWidth = 0

--Styles for selected indicator
C.SelectedStrings = {
	["DEFAULT"] = "|cff%02x%02x%02x>|r %s |cff%02x%02x%02x<|r",
	["SQUARE"] = "|cff%02x%02x%02x[|r %s |cff%02x%02x%02x]|r",
	["HALFDEFAULT"] = "|cff%02x%02x%02x>|r %s",
	["CHECKBOX"] = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Criteria-Check:%s|t%s]],
	["ARROWRIGHT"] = [[|TInterface\BUTTONS\UI-SpellbookIcon-NextPage-Up:%s|t%s]],
	["ARROWDOWN"] = [[|TInterface\BUTTONS\UI-MicroStream-Green:%s|t%s]],
}

--Apply selected indicator to tab
function C:ApplySelectedTabIndicator(tab, title)
	local color = C.db.tab.color
	if C.db.tab.style == "DEFAULT" or C.db.tab.style == "SQUARE" then
		tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, title, color.r * 255, color.g * 255, color.b * 255))
	elseif C.db.tab.style == "HALFDEFAULT" then
		tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], color.r * 255, color.g * 255, color.b * 255, title))
	else
		tab.text:SetText(T.format(C.SelectedStrings[C.db.tab.style], (E.db.chat.tabFontSize + 12), title))
	end
end

--Full update tabs function. Hooking to it allows to set size and selection at the same time.
--Most of the content is default blizz function with sligh modifications
function C:FCFDock_UpdateTabs(dock, forceUpdate)
	if ( not dock.isDirty and not forceUpdate ) then --No changes have been made since the last update.
		return;
	end

	local scrollChild = dock.scrollFrame:GetScrollChild();
	local lastDockedStaticTab = nil;
	local lastDockedDynamicTab = nil;

	local numDynFrames = 0;	--Number of dynamicly sized frames.
	local selectedDynIndex = nil;

	C.TotalTabsWidth = 0 --Reseting saved combined width

	for index, chatFrame in T.ipairs(dock.DOCKED_CHAT_FRAMES) do
		local chatTab = _G[chatFrame:GetName().."Tab"];
		if chatTab.text then chatTab.text:SetText(chatFrame.name) end --Reseting tab name
		if ( chatFrame == FCFDock_GetSelectedWindow(dock) ) and C.db.tab.select then --Tab is selected and option is enabled
			C:ApplySelectedTabIndicator(chatTab, chatFrame.name)
		end

		--Resizing tabs, don't need to do that if blizz sizing is selected
		if C.db.tab.resize ~= "Blizzard" then
			local width = (C.db.tab.resize == "None" and chatTab.origWidth) or (C.db.tab.resize == "Title" and chatTab.textWidth) or (C.db.tab.resize == "Custom" and C.db.tab.customWidth)
			C.TotalTabsWidth = C.TotalTabsWidth + width
			if ( chatFrame.isStaticDocked ) then
				chatTab:SetParent(dock);
				PanelTemplates_TabResize(chatTab, chatTab.isTemporary and 20 or 10, nil, nil, nil, width);
				if ( lastDockedStaticTab ) then
					chatTab:SetPoint("LEFT", lastDockedStaticTab, "RIGHT", 0, 0);
				else
					chatTab:SetPoint("LEFT", dock, "LEFT", 0, 0);
				end
				lastDockedStaticTab = chatTab;
			else
				chatTab:SetParent(scrollChild);
				numDynFrames = numDynFrames + 1;

				if ( FCFDock_GetSelectedWindow(dock) == chatFrame ) then
					selectedDynIndex = numDynFrames;
				end

				if ( lastDockedDynamicTab ) then
					chatTab:SetPoint("LEFT", lastDockedDynamicTab, "RIGHT", 0, 0);
				else
					chatTab:SetPoint("LEFT", scrollChild, "LEFT", 0, 0);
				end
				lastDockedDynamicTab = chatTab;
			end
		end
	end

	--If blizz sizing is selected then messing around with scroll frame is unnessesary
	if C.db.tab.resize == "Blizzard" then
		dock.scrollFrame:SetPoint("BOTTOMRIGHT", dock, "BOTTOMRIGHT", 0, 3);
		return
	end
	local dynTabSize, origOverflow = FCFDock_CalculateTabSize(dock, numDynFrames); --Usually this returns "hasOverflow" as well, but I use my own variable for that
	local hasOverflow = C.TotalTabsWidth > E.db.chat.panelWidth

	--Dynamically resize tabs
	for index, chatFrame in T.ipairs(dock.DOCKED_CHAT_FRAMES) do
		if ( not chatFrame.isStaticDocked ) then
			local chatTab = _G[chatFrame:GetName().."Tab"];
			PanelTemplates_TabResize(chatTab, chatTab.sizePadding or 0, dynTabSize);
		end
	end

	dock.scrollFrame:SetPoint("LEFT", lastDockedStaticTab, "RIGHT", 0, 0);
	if ( hasOverflow or origOverflow) then
		dock.overflowButton:Show();
	else
		dock.overflowButton:Hide();
	end
	dock.scrollFrame:SetPoint("BOTTOMRIGHT", dock, "BOTTOMRIGHT", 0, 3);

	--Cache some of this data on the scroll frame for animating to the selected tab.
	dock.scrollFrame.dynTabSize = dynTabSize;
	dock.scrollFrame.numDynFrames = numDynFrames;
	dock.scrollFrame.selectedDynIndex = selectedDynIndex;

	dock.isDirty = false;

	--This may be needed to return for check in FCFDock_OnUpdate
	-- return FCFDock_ScrollToSelectedTab(dock)
end

function C:InitTabs()
	if C.db.tab.resize == true then C.db.tab.resize = "None" end

	--Getting initial chat tabs width, so other stuff will work
	if C.CreatedFrames == 0 then
		--Not all tabs have been styled yet
		E:Delay(0.2, C.InitTabs)
		return
	else
		for id = 1, C.CreatedFrames do _G["ChatFrame"..id.."Tab"].origWidth = _G["ChatFrame"..id.."Tab"]:GetWidth() end
	end

	--Hooking to chat updating function
	hooksecurefunc("FCFDock_UpdateTabs", function(dock, forceUpdate) C:FCFDock_UpdateTabs(dock, forceUpdate) end)
	--Without this hooked previous hook will never execute automatically apart from specific situations
	hooksecurefunc("FCFDock_SelectWindow", function(dock, chatFrame) FCFDock_UpdateTabs(dock, true) end)

	--Calling in update after hooks. Why 2 times? No idea, doesn't work otherwise
	FCF_DockUpdate()
	FCF_DockUpdate()

	--Repositioning of dock frame
	GeneralDockManagerScrollFrame:SetHeight(20)
	GeneralDockManagerScrollFrame:Point("BOTTOMRIGHT", GeneralDockManager, "BOTTOMRIGHT",0,3)
end