local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNSendGameData = BNSendGameData
local SendAddonMessage = SendAddonMessage


--Building user list for dev tool
local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if prefix == 'SLE_DEV_REQ' then 
			local message = "wut?"
			SendAddonMessage('SLE_USER_REQ', message, channel)
		elseif prefix == 'SLE_USER_INFO' then
			local message = T.UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version;
			SendAddonMessage('SLE_DEV_INFO', message, channel)
		end
	elseif event == "BN_CHAT_MSG_ADDON" then
		if (sender == E.myname.."-"..E.myrealm:gsub(' ','')) then return end

		if prefix == 'SLE_DEV_REQ' then
			local _, numBNetOnline = T.BNGetNumFriends()
			for i = 1, numBNetOnline do
				local presenceID, _, _, _, _, _, client, isOnline = T.BNGetFriendInfo(i)
				if isOnline and client == BNET_CLIENT_WOW then
					local message, ID = T.split("#", message)

					if message == 'userlist' then
						message = T.UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version;
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