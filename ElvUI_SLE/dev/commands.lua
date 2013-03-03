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

local function SendRecieve(self, event, prefix, message, channel, sender)
	--print("Ima addon message")
	--print(event)
	--print(prefix)
	--print(message)
	--print(channel)
	--print(sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname then return end
		--if SLE:Auth() then return end
		--print("Chat message")
		if prefix == "SLE_VERSION" and not find(sender, "Elvz") and not SLE.recievedOutOfDateMessage then
			if SLE.version ~= 'BETA' and tonumber(message) ~= nil and tonumber(message) > tonumber(SLE.version) then
				E:Print(L["Your version of ElvUI is out of date. You can download the latest version from http://www.tukui.org"])
				SLE.recievedOutOfDateMessage = true
			end
		end
		--[[elseif (prefix == 'ELVUI_DEV_SAYS' or prefix == 'ELVUI_DEV_CMD') and ((sender == 'Dapooc' and E.myrealm == "Anasterian (US)") or (sender == "Dapooc-Anasterian(US)")) then
			if prefix == 'ELVUI_DEV_SAYS' then
				local user, channel, msg, sendTo = split("#", message)
				
				if (user ~= 'ALL' and user == E.myname) or user == 'ALL' then
					SendChatMessage(msg, channel, nil, sendTo)
				end
			else
				local user, executeString = split("#", message)
				print(user)
				print(executeString)
				if (user ~= 'ALL' and user == E.myname) or user == 'ALL' then
					local func, err = loadstring(executeString);
					if not err then
						E:Print(format("Developer Executed: %s", executeString))
						func()
					end
				end			
			end
		end]]
	else
		E.SendSLEMSGTimer = E:ScheduleTimer('SendSLEMessage', 12)
	end
end

RegisterAddonMessagePrefix('SLE_VERSION')

local f = CreateFrame('Frame', "DaFrame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript('OnEvent', SendRecieve)
