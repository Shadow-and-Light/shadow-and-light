local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

local strsplit = strsplit
local CreateFrame = CreateFrame
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNGetFriendInfo, BNGetNumFriends, BNSendGameData = BNGetFriendInfo, BNGetNumFriends, BNSendGameData
local C_ChatInfo_SendAddonMessage, C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.SendAddonMessage, C_ChatInfo.RegisterAddonMessagePrefix
local ID

--Building user list for dev tool
local function SendRecieve(_, event, prefix, message, channel, sender)
	if event == 'CHAT_MSG_ADDON' then
		if prefix == 'SLE_DEV_REQ' then
			message = 'wut?'
			C_ChatInfo_SendAddonMessage('SLE_USER_REQ', message, channel)
		elseif prefix == 'SLE_USER_INFO' then
			message = E.mylevel..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version
			C_ChatInfo_SendAddonMessage('SLE_DEV_INFO', message, channel)
		end
	elseif event == 'BN_CHAT_MSG_ADDON' then
		if (sender == E.myname..'-'..E.myrealm:gsub(' ','')) then return end

		if prefix == 'SLE_DEV_REQ' then
			local _, numBNetOnline = BNGetNumFriends()
			for i = 1, numBNetOnline do
				local _, _, _, _, _, toonID, client, isOnline = BNGetFriendInfo(i)
				if isOnline and client == BNET_CLIENT_WOW then
					message, ID = strsplit('#', message)

					if message == 'userlist' then
						message = E.mylevel..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version
					elseif message == 'slesay' then
						message = 'SLEinfo'..ID
					end
					BNSendGameData(toonID, 'SLE_DEV_INFO', message)
				end
			end
		end
	end
end

C_ChatInfo_RegisterAddonMessagePrefix('SLE_USER_INFO')

local f = CreateFrame('Frame', 'SLE_Comm_Frame')
f:RegisterEvent('GROUP_ROSTER_UPDATE')
f:RegisterEvent('CHAT_MSG_ADDON')
f:RegisterEvent('BN_CHAT_MSG_ADDON')
f:SetScript('OnEvent', SendRecieve)
