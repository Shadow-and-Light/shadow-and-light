if not AddOnSkins then return end
local AS = unpack(AddOnSkins)
local E = unpack(ElvUI)

function AS:EmbedSystem_WindowResize()
	if UnitAffectingCombat('player') or not AS.EmbedSystemCreated then return end
	local ChatPanel = AS:CheckOption('EmbedRightChat') and RightChatPanel or LeftChatPanel
	local ChatTabSize = AS:CheckOption('EmbedBelowTop') and RightChatTab:GetHeight() + (E.Border * 2) or 0

	local DataTextSize = 0

	if not E.db.sle.datatext.chathandle then
		if AS:CheckOption('EmbedRightChat') and E.db.datatexts.rightChatPanel then
			DataTextSize = RightChatDataPanel:GetHeight() + (E.PixelMode and 1 or 2)
		elseif not AS:CheckOption('EmbedRightChat') and E.db.datatexts.leftChatPanel then
			DataTextSize = LeftChatDataPanel:GetHeight() + (E.Border * 2)
		end
	end

	local Width, Height, X, Y

	if E.PixelMode then
		Width = 6
		Height = (E.Border * 3) + ChatTabSize + DataTextSize + 3 
		X = 0
		Y = E.Border + DataTextSize + 2
	else
		Width = 10
		Height = (E.Border * 3) + ChatTabSize + DataTextSize + 3
		X = 0
		Y = E.Border + DataTextSize + 2
	end

	EmbedSystem_MainWindow:SetParent(ChatPanel)
	EmbedSystem_MainWindow:SetTemplate()
	EmbedSystem_MainWindow:SetBackdropBorderColor(1,0,0)
	EmbedSystem_MainWindow:SetBackdropColor(1,0,0)

	EmbedSystem_MainWindow:SetSize(ChatPanel:GetWidth() - Width, ChatPanel:GetHeight() - Height)
	EmbedSystem_LeftWindow:SetSize(AS:CheckOption('EmbedLeftWidth'), EmbedSystem_MainWindow:GetHeight())
	EmbedSystem_RightWindow:SetSize((EmbedSystem_MainWindow:GetWidth() - AS:CheckOption('EmbedLeftWidth')) - 1, EmbedSystem_MainWindow:GetHeight())

	EmbedSystem_LeftWindow:SetPoint('LEFT', EmbedSystem_MainWindow, 'LEFT', 0, 0)
	EmbedSystem_RightWindow:SetPoint('RIGHT', EmbedSystem_MainWindow, 'RIGHT', 0, 0)
	EmbedSystem_MainWindow:SetPoint('BOTTOM', ChatPanel, 'BOTTOM', X, Y)

	-- Dynamic Range
	if IsAddOnLoaded('ElvUI_Config') then
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.min = floor(EmbedSystem_MainWindow:GetWidth() * .25)
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.max = floor(EmbedSystem_MainWindow:GetWidth() * .75)
	end
end