local E, L, V, P, G = unpack(ElvUI); 
local SLE = E:GetModule('SLE');
local split = string.split

local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if prefix == 'SLE_DEV_REQ' then 
			local message = "wut?"
			SendAddonMessage('SLE_USER_REQ', message, channel)
		elseif prefix == 'SLE_USER_INFO' then
			local message = UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version;
			SendAddonMessage('SLE_DEV_INFO', message, channel)
		end
	elseif event == "BN_CHAT_MSG_ADDON" then
		if (sender == E.myname.."-"..E.myrealm:gsub(' ','')) then return end

		if prefix == 'SLE_DEV_REQ' then
			local _, numBNetOnline = BNGetNumFriends()
			for i = 1, numBNetOnline do
				local presenceID, _, _, _, _, _, client, isOnline = BNGetFriendInfo(i)
				if isOnline and client == BNET_CLIENT_WOW then
					local message, ID = split("#", message)

					if message == 'userlist' then
						message = UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version;
					elseif message == 'slesay' then
						message = "SLEinfo"..ID
					end
					BNSendGameData(presenceID, 'SLE_DEV_INFO', message)
				end
			end
		end
	end
end

RegisterAddonMessagePrefix('SLE_USER_INFO')

local f = CreateFrame('Frame', "SLE_Comm_Frame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("BN_CHAT_MSG_ADDON")
f:SetScript('OnEvent', SendRecieve)