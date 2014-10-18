local E, L, V, P, G = unpack(ElvUI); 
local SLE = E:GetModule('SLE');
local split = string.split

--The list of authorized toons
local Authors = {
	["Illidan"] = {
		--Darth's toon
		["Darthpred"] = true
	},
	["ВечнаяПесня"] = {
		--Darth's toons
		["Дартпредатор"] = true,
		["Алея"] = true,
		["Ваззули"] = true,
		["Сиаранна"] = true,
		["Джатон"] = true,
		["Фикстер"] = true,
		["Киландра"] = true,
		["Нарджо"] = true,
		["Келинира"] = true,
		["Крениг"] = true,
		["Мейжи"] = true
	},
	["Spirestone"] = {
		["Sifupooc"] = true,
		["Dapooc"] = true,
		["Lapooc"] = true,
		["Warpooc"] = true,
		["Repooc"] = true,
		["Cursewordz"] = true,
	},
	["WyrmrestAccord"] = {
		["Kitalie"] = true,
		["Sagome"] = true,
		["Ainy"] = true,
		["Norinael"] = true,
		["Tritalie"] = true,
		["Myun"] = true,
		["Nevaleigh"] = true,
		["Celenii"] = true,
		["Varysa"] = true,
		["Caylasena"] = true,
		["Arillora"] = true,
	},
	--Normal PTR
	["Anasterian(US)"] = {
		["Dapooc"] = true,
	},
	["Brill(EU)"] = {
		["Дартпредатор"] = true,
	},
}

function SLE:Auth(sender)
	local senderName, senderRealm

	if sender then
		senderName, senderRealm = string.split('-', sender)
	else
		senderName = E.myname
	end

	senderRealm = senderRealm or E.myrealm
	senderRealm = senderRealm:gsub(' ', '')
	if Authors[senderRealm] and Authors[senderRealm][senderName] then
		return Authors[senderRealm][senderName]
	end

	return false
end

local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname.."-"..E.myrealm:gsub(' ','') then return end
		
		if prefix == 'SLE_DEV_REQ' and SLE:Auth(sender) then
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
					--local messageS
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

RegisterAddonMessagePrefix('SLE_DEV_REQ')

local f = CreateFrame('Frame', "DaFrame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("BN_CHAT_MSG_ADDON")
f:SetScript('OnEvent', SendRecieve)