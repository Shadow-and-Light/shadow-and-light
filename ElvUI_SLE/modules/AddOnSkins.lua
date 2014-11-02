if not AddOnSkins then return end
local AS = unpack(AddOnSkins)
local E = unpack(ElvUI)

function AS:EmbedSystem_WindowResize()
	if UnitAffectingCombat('player') or not AS.EmbedSystemCreated then return end
	local ChatPanel = AS:CheckOption('EmbedRightChat') and RightChatPanel or LeftChatPanel
	local ChatTab = AS:CheckOption('EmbedRightChat') and RightChatTab or LeftChatTab
	local ChatData = AS:CheckOption('EmbedRightChat') and RightChatDataPanel or LeftChatDataPanel
	local TopLeft = ChatData == RightChatDataPanel and (E.db.datatexts.rightChatPanel and 'TOPLEFT' or 'BOTTOMLEFT') or ChatData == LeftChatDataPanel and (E.db.datatexts.leftChatPanel and 'TOPLEFT' or 'BOTTOMLEFT')
	local yOffset = (ChatData == RightChatDataPanel and E.db.datatexts.rightChatPanel and (E.PixelMode and 1 or 0)) or (ChatData == LeftChatDataPanel and E.db.datatexts.leftChatPanel and (E.PixelMode and 1 or 0)) or (E.PixelMode and 0 or -1)

	EmbedSystem_MainWindow:SetParent(ChatPanel)
	EmbedSystem_MainWindow:ClearAllPoints()

	if E.db.sle.datatext.chathandle then
		local xOffset, yOffset = select(4, ChatTab:GetPoint())
		EmbedSystem_MainWindow:SetPoint('BOTTOMLEFT', ChatPanel, 'BOTTOMLEFT', -xOffset, -yOffset)
	else
		EmbedSystem_MainWindow:SetPoint('BOTTOMLEFT', ChatData, TopLeft, 0, yOffset)
	end

	EmbedSystem_MainWindow:SetPoint('TOPRIGHT', ChatTab, AS:CheckOption('EmbedBelowTop') and 'BOTTOMRIGHT' or 'TOPRIGHT', 0, AS:CheckOption('EmbedBelowTop') and -1 or 0)

	EmbedSystem_LeftWindow:SetSize(AS:CheckOption('EmbedLeftWidth'), EmbedSystem_MainWindow:GetHeight())
	EmbedSystem_RightWindow:SetSize((EmbedSystem_MainWindow:GetWidth() - AS:CheckOption('EmbedLeftWidth')) - 1, EmbedSystem_MainWindow:GetHeight())

	EmbedSystem_LeftWindow:SetPoint('LEFT', EmbedSystem_MainWindow, 'LEFT', 0, 0)
	EmbedSystem_RightWindow:SetPoint('RIGHT', EmbedSystem_MainWindow, 'RIGHT', 0, 0)

	-- Dynamic Range
	if IsAddOnLoaded('ElvUI_Config') then
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.min = floor(EmbedSystem_MainWindow:GetWidth() * .25)
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.max = floor(EmbedSystem_MainWindow:GetWidth() * .75)
	end
end
