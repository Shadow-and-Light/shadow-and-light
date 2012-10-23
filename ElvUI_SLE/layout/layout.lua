local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local LO = E:GetModule('Layout');
local DTP = E:GetModule('DTPanels');

local PANEL_HEIGHT = 22;
local SIDE_BUTTON_WIDTH = 16;

LO.ToggleChatPanelsSLE = LO.ToggleChatPanels
function LO:ToggleChatPanels()
	LO.ToggleChatPanelsSLE(self)

	if E.db.chat.panelBackdrop == 'SHOWBOTH' then
		LeftChatPanel.backdrop:Show()
		LeftChatTab:Show()
		RightChatPanel.backdrop:Show()
		RightChatTab:Show()		

		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, -21) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, -1) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - E.db.sle.datatext.chatright.width - 16, -21) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, -1)	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -21)
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -21)
	elseif E.db.chat.panelBackdrop == 'HIDEBOTH' then
		LeftChatPanel.backdrop:Hide()
		LeftChatTab:Hide()
		RightChatPanel.backdrop:Hide()
		RightChatTab:Hide()		
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, -21) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, -1) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - E.db.sle.datatext.chatright.width - 16, -21) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, -1)	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -21)
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -21)
	elseif E.db.chat.panelBackdrop == 'LEFT' then
		LeftChatPanel.backdrop:Show()
		LeftChatTab:Show()
		RightChatPanel.backdrop:Hide()
		RightChatTab:Hide()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, -21) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, -1) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - E.db.sle.datatext.chatright.width - 16, -21) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, -1)	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -21)
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -21)
	else
		LeftChatPanel.backdrop:Hide()
		LeftChatTab:Hide()
		RightChatPanel.backdrop:Show()
		RightChatTab:Show()	
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, -21) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, -1) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - E.db.sle.datatext.chatright.width - 16, -21) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, -1)	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -21)
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -21)
	end
end

LO.CreateChatPanelsSLE = LO.CreateChatPanels
function LO:CreateChatPanels()
	LO.CreateChatPanelsSLE(self)
	--Left Chat
	--LeftChatPanel:Point('BOTTOMLEFT', E.UIParent, 0, 21) --Prevents chat from moving
	
	--Left Chat Tab
	LeftChatTab:Point('TOPLEFT', LeftChatPanel, 'TOPLEFT', 2, -2)
	LeftChatTab:Point('BOTTOMRIGHT', LeftChatPanel, 'TOPRIGHT', -2, -PANEL_HEIGHT)
	
	--Preventing left chat datapanel fading
	ChatFrame1EditBox:Hide()
	
	--Right Chat
	--RightChatPanel:Point('BOTTOMRIGHT', E.UIParent, 0, 21) --Prevents chat from moving
	
	--Right Chat Tab
	RightChatTab:Point('TOPRIGHT', RightChatPanel, 'TOPRIGHT', -2, -2)
	RightChatTab:Point('BOTTOMLEFT', RightChatPanel, 'TOPLEFT', 2, -PANEL_HEIGHT)
end

--Repositioning function for editbox
function LO:EditboxPos()
	if not E.private.chat.enable then return end
	for i = 1, NUM_CHAT_WINDOWS do
		local editbox = _G["ChatFrame"..i.."EditBox"]
		local parent
		if E.db.sle.chat.editbox == "Down" then
			parent = LeftChatDataPanel
		else
			parent = LeftChatTab
		end
		editbox:ClearAllPoints()
		editbox:SetPoint("TOPLEFT", parent, "TOPLEFT")
		editbox:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	end
end
