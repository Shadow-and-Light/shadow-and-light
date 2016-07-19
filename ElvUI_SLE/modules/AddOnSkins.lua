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

	_G["EmbedSystem_MainWindow"]:SetParent(ChatPanel)
	_G["EmbedSystem_MainWindow"]:ClearAllPoints()

	if E.db.sle.datatexts.chathandle then
		local xOffset, yOffset = select(4, ChatTab:GetPoint())
		_G["EmbedSystem_MainWindow"]:SetPoint('BOTTOMLEFT', ChatPanel, 'BOTTOMLEFT', -xOffset, -yOffset)
	else
		_G["EmbedSystem_MainWindow"]:SetPoint('BOTTOMLEFT', ChatData, TopLeft, 0, yOffset)
	end

	_G["EmbedSystem_MainWindow"]:SetPoint('TOPRIGHT', ChatTab, AS:CheckOption('EmbedBelowTop') and 'BOTTOMRIGHT' or 'TOPRIGHT', 0, AS:CheckOption('EmbedBelowTop') and -1 or 0)

	_G["EmbedSystem_LeftWindow"]:SetSize(AS:CheckOption('EmbedLeftWidth'), _G["EmbedSystem_MainWindow"]:GetHeight())
	_G["EmbedSystem_RightWindow"]:SetSize((_G["EmbedSystem_MainWindow"]:GetWidth() - AS:CheckOption('EmbedLeftWidth')) - 1, _G["EmbedSystem_MainWindow"]:GetHeight())

	_G["EmbedSystem_LeftWindow"]:SetPoint('LEFT', _G["EmbedSystem_MainWindow"], 'LEFT', 0, 0)
	_G["EmbedSystem_RightWindow"]:SetPoint('RIGHT', _G["EmbedSystem_MainWindow"], 'RIGHT', 0, 0)

	-- Dynamic Range
	if IsAddOnLoaded('ElvUI_Config') then
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.min = floor(_G["EmbedSystem_MainWindow"]:GetWidth() * .25)
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.max = floor(_G["EmbedSystem_MainWindow"]:GetWidth() * .75)
	end
end
