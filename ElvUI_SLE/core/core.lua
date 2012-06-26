local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB

function E:SendRecieve(event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname then return end

		if prefix == "ElvUIVC" and sender ~= 'Elv' and not string.find(sender, 'Elv%-') then
			if tonumber(message) > tonumber(E.version) then
				E:Print(L["Your version of ElvUI is out of date. You can download the latest version from www.tukui.org"])
				self:UnregisterEvent("CHAT_MSG_ADDON")
				self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
				self:UnregisterEvent("RAID_ROSTER_UPDATE")
			end
		end
	else
		E:ScheduleTimer('SendMessage', 12)
	end
end