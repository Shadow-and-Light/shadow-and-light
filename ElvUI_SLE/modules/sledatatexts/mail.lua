local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DT = E:GetModule('DataTexts')
local DTP = SLE:GetModule('Datatexts')
local HAVE_MAIL_FROM = HAVE_MAIL_FROM

local Mail_Icon = [[|TInterface\MINIMAP\TRACKING\Mailbox.blp:14:14|t]];
local frame = MiniMapMailFrame
local OldShow = frame.Show
local HasNewMail = HasNewMail
local GetInboxNumItems = GetInboxNumItems
local GetLatestThreeSenders = GetLatestThreeSenders
local Read;
local AddLine = AddLine

local function MakeIconString()
	local str = ""
		str = str..Mail_Icon

	return str
end

function DTP:MailUp(newmail)
	if not E.db.sle.dt.mail.icon then
		frame:Hide()
		frame.Show = nil
	else
		if not frame.Show then
			frame.Show = OldShow
		end
		if newmail then
			frame:Show()
		end
	end
end

local unreadMail
local function OnEvent(self, event, ...)
	local newMail = false

	if event == "UPDATE_PENDING_MAIL" or event == "PLAYER_ENTERING_WORLD" or event =="PLAYER_LOGIN" then

		newMail = HasNewMail() 

		if unreadMail ~= newMail then
			unreadMail = newMail
		end

		DTP:MailUp(newMail)

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_LOGIN")
	end

	if event == "MAIL_INBOX_UPDATE" or event == "MAIL_SHOW" or event == "MAIL_CLOSED" then
		for i = 1, GetInboxNumItems() do
			local _, _, _, _, _, _, _, _, wasRead = T.GetInboxHeaderInfo(i);
			if( not wasRead ) then
				newMail = true;
				break;
			end
		end
	end

	if newMail then
		self.text:SetText(MakeIconString()..L["New Mail"])
		Read = false;
	else
		self.text:SetText(L["No Mail"])
		Read = true;
	end

end

local function OnUpdate(self)
	OnEvent(self, "UPDATE_PENDING_MAIL")
	self:SetScript("OnUpdate", nil)
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	local sender1, sender2, sender3 = GetLatestThreeSenders()

	if not Read then
		DT.tooltip:AddLine(HAVE_MAIL_FROM)
		if sender1 then DT.tooltip:AddLine("    "..sender1) end
		if sender2 then DT.tooltip:AddLine("    "..sender2) end
		if sender3 then DT.tooltip:AddLine("    "..sender3) end
	end
	DT.tooltip:Show()
end

function DTP:CreateMailDT()
	DT:RegisterDatatext('S&L Mail', {'PLAYER_ENTERING_WORLD', 'MAIL_INBOX_UPDATE', 'UPDATE_PENDING_MAIL', 'MAIL_CLOSED', 'PLAYER_LOGIN','MAIL_SHOW'}, OnEvent, OnUpdate, nil, OnEnter)
end