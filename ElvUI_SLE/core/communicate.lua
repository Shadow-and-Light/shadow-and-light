local SLE, T, E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local strsplit = string.split
local UnitLevel = UnitLevel
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNGetFriendInfo = BNGetFriendInfo
local BNGetNumFriends = BNGetNumFriends
local BNSendGameData = BNSendGameData
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local CreateFrame = CreateFrame
local ID

--Building user list for dev tool
local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == 'CHAT_MSG_ADDON' then
		if prefix == 'SLE_DEV_REQ' then
			message = 'wut?'
			C_ChatInfo_SendAddonMessage('SLE_USER_REQ', message, channel)
		elseif prefix == 'SLE_USER_INFO' then
			message = UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version;
			C_ChatInfo_SendAddonMessage('SLE_DEV_INFO', message, channel)
		end
	elseif event == 'BN_CHAT_MSG_ADDON' then
		if (sender == E.myname..'-'..E.myrealm:gsub(' ','')) then return end

		if prefix == 'SLE_DEV_REQ' then
			local _, numBNetOnline = BNGetNumFriends()
			for i = 1, numBNetOnline do
				local presenceID, _, _, _, _, toonID, client, isOnline = BNGetFriendInfo(i)
				if isOnline and client == BNET_CLIENT_WOW then
					message, ID = strsplit('#', message)

					if message == 'userlist' then
						message = UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version;
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
