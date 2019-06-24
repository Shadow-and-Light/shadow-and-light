if not AddOnSkins then return end
local AS = unpack(AddOnSkins)
local E = unpack(ElvUI)
local _G = _G
local floor = floor
local UnitAffectingCombat = UnitAffectingCombat
local IsAddOnLoaded = IsAddOnLoaded
local select = select


function AS:EmbedSystem_WindowResize()
	if UnitAffectingCombat('player') or not AS.EmbedSystemCreated then return end
	local ChatPanel = AS:CheckOption('EmbedRightChat') and _G["RightChatPanel"] or _G["LeftChatPanel"]
	local ChatTab = AS:CheckOption('EmbedRightChat') and _G["RightChatTab"] or _G["LeftChatTab"]
	local ChatData = AS:CheckOption('EmbedRightChat') and _G["RightChatDataPanel"] or _G["LeftChatDataPanel"]
	local TopLeft = ChatData == _G["RightChatDataPanel"] and (E.db.datatexts.rightChatPanel and 'TOPLEFT' or 'BOTTOMLEFT') or ChatData == _G["LeftChatDataPanel"] and (E.db.datatexts.leftChatPanel and 'TOPLEFT' or 'BOTTOMLEFT')
	local yOffset = (ChatData == _G["RightChatDataPanel"] and E.db.datatexts.rightChatPanel and (1 - E.Spacing)) or (ChatData == _G["LeftChatDataPanel"] and E.db.datatexts.leftChatPanel and (1 - E.Spacing)) or (-E.Spacing)
	local xOffset
	local Main, Left, Right = _G["EmbedSystem_MainWindow"], _G["EmbedSystem_LeftWindow"], _G["EmbedSystem_RightWindow"]
	Main:SetParent(ChatPanel)
	Main:ClearAllPoints()

	if E.db.sle.datatexts.chathandle then
		xOffset, yOffset = select(4, ChatTab:GetPoint())
		Main:SetPoint('BOTTOMLEFT', ChatPanel, 'BOTTOMLEFT', 0, -1)
	else
		Main:SetPoint('BOTTOMLEFT', ChatData, TopLeft, 0, yOffset)
	end

	Main:SetPoint('TOPRIGHT', ChatTab, AS:CheckOption('EmbedBelowTop') and 'BOTTOMRIGHT' or 'TOPRIGHT', xOffset or 0, AS:CheckOption('EmbedBelowTop') and -1 or -yOffset)

	Left:SetSize(AS:CheckOption('EmbedLeftWidth'), Main:GetHeight())
	Right:SetSize((Main:GetWidth() - AS:CheckOption('EmbedLeftWidth')), Main:GetHeight())

	Left:SetPoint('LEFT', Main, 'LEFT', 0, 0)
	Right:SetPoint('RIGHT', Main, 'RIGHT', 0, 0)

	-- Dynamic Range
	if IsAddOnLoaded('ElvUI_OptionsUI') then
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.min = floor(Main:GetWidth() * .25)
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.max = floor(Main:GetWidth() * .75)
	end
end