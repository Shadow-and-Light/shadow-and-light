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
		RightChatPanel.backdrop:Show()

		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels()
	elseif E.db.chat.panelBackdrop == 'HIDEBOTH' then
		LeftChatPanel.backdrop:Hide()
		RightChatPanel.backdrop:Hide()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels(true, true)
	elseif E.db.chat.panelBackdrop == 'LEFT' then
		LeftChatPanel.backdrop:Show()
		RightChatPanel.backdrop:Hide()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels(true)
	else
		LeftChatPanel.backdrop:Hide()
		RightChatPanel.backdrop:Show()
		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, (E.PixelMode and -19 or -21)) --lower line of datapanel
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMLEFT', 16 + E.db.sle.datatext.chatleft.width, (E.PixelMode and 1 or -1)) --upper line of datapanel		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMRIGHT', - (E.db.sle.datatext.chatright.width + 16), (E.PixelMode and -19 or -21)) --lower-left corner of right datapanel
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, (E.PixelMode and 1 or -1))	--upper-right corner of right datapanel	
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, (E.PixelMode and -19 or -21))
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, (E.PixelMode and -19 or -21))
		LO:ToggleChatTabPanels(nil, true)
	end
end

LO.CreateChatPanelsSLE = LO.CreateChatPanels
function LO:CreateChatPanels()
	LO.CreateChatPanelsSLE(self)
	
	--Left Chat Tab
	LeftChatTab:Point('TOPLEFT', LeftChatPanel, 'TOPLEFT', 2, -2)
	LeftChatTab:Point('BOTTOMRIGHT', LeftChatPanel, 'TOPRIGHT', -2, -PANEL_HEIGHT)
	
	--Preventing left chat datapanel fading
	ChatFrame1EditBox:Hide()
	
	--Right Chat Tab
	RightChatTab:Point('TOPRIGHT', RightChatPanel, 'TOPRIGHT', -2, -2)
	RightChatTab:Point('BOTTOMLEFT', RightChatPanel, 'TOPLEFT', 2, -PANEL_HEIGHT)
end
