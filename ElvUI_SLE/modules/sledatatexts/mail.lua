local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local DTP = SLE:GetModule('Datatexts')

local pairs, strjoin = pairs, strjoin
local HasNewMail = HasNewMail
local GetLatestThreeSenders = GetLatestThreeSenders
local HAVE_MAIL_FROM = HAVE_MAIL_FROM
local MAIL_LABEL = MAIL_LABEL

local icon = [[|TInterface\MINIMAP\TRACKING\Mailbox.blp:14:14|t]];
local displayString, lastPanel = ''

function DTP:MailUp()
	if not E.db.sle.dt.mail.showicon then
		-- print(E.db.sle.dt.mail.showicon)
		_G.MiniMapMailFrame:Hide()
		-- _G.MiniMapMailFrame.Show = nil
	else
		-- if not _G.MiniMapMailFrame.Show then
		-- 	_G.MiniMapMailFrame.Show = OldShow
		-- end
		if HasNewMail() then
			_G.MiniMapMailFrame:Show()
		end
	end
end

local function OnEvent(self)
	DTP:MailUp()
	lastPanel = self
	self.text:SetFormattedText(displayString, HasNewMail() and icon..L["New Mail"] or L["No Mail"])
end

local function OnEnter(self)
	local senders = { GetLatestThreeSenders() }
	if #senders > 0 then
		DT:SetupTooltip(self)
		DT.tooltip:AddLine(HasNewMail() and HAVE_MAIL_FROM or MAIL_LABEL, 1, 1, 1)
		DT.tooltip:AddLine(' ')
		for _, sender in pairs(senders) do
			DT.tooltip:AddLine("    "..sender)
		end

		DT.tooltip:Show()
	end
end

local function ValueColorUpdate(hex)
	displayString = strjoin(hex, "%s|r")

	if lastPanel then OnEvent(lastPanel) end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('S&L Mail', 'S&L', {'PLAYER_ENTERING_WORLD', 'MAIL_INBOX_UPDATE', 'UPDATE_PENDING_MAIL', 'MAIL_CLOSED','MAIL_SHOW'}, OnEvent, nil, nil, OnEnter)
