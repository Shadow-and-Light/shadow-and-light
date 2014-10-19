local E, L, V, P, G = unpack(ElvUI);
local SLE = E:GetModule('SLE');
local ACD = LibStub("AceConfigDialog-3.0")

local bnettesttbl = {}
function SLE:GetBNetInfo()
	local _, numBNetOnline = BNGetNumFriends()
	for i = 1, numBNetOnline do
		local presenceID, presenceName, _, _, _, _, client, isOnline = BNGetFriendInfo(i)
		if isOnline and client == BNET_CLIENT_WOW then
			BNSendGameData(presenceID, 'SLE_DEV_REQ', 'slesay#'..presenceID)
		end
	end
end

local function Login(self, event)
	self:UnregisterEvent(event)
	if SLE:Auth() then
		local selectedChannel = ''
		local UserListCache = {}
		local highestVersion = tonumber(SLE.version)
		local flag = 'SLE_DEV_SAYS'
		local addonChannel = 'GUILD'
		local addonTarget = ""
		local output = 'SAY'
		local text = ''
		local wtarget = ""
		local bnetP

		function SLE:delete(...)
			local _, id = ...
			id = tostring(id)
			bnettesttbl[id] = nil
		end
		SLE:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE', 'delete')

		RegisterAddonMessagePrefix('SLE_DEV_INFO')

		local f = CreateFrame('Frame')
		f:RegisterEvent('CHAT_MSG_ADDON')
		f:RegisterEvent('BN_CHAT_MSG_ADDON')
		f:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
		f:RegisterEvent('PLAYER_ENTERING_WORLD')
		f:SetScript('OnEvent', function(self, event, prefix, message, channel, sender)
			if event == 'BN_FRIEND_ACCOUNT_ONLINE' or event == 'BN_FRIEND_ACCOUNT_OFFLINE' then
				SLE:GetBNetInfo()
			end

			if event == 'PLAYER_ENTERING_WORLD' then
				SLE:GetBNetInfo()
			end

			if prefix == 'SLE_DEV_INFO' then
				if event == 'CHAT_MSG_ADDON' or event == 'BN_CHAT_MSG_ADDON' then
					if not message:find("SLEinfo") then
						local userLevel, userClass, userName, userRealm, userVersion = strsplit('#', message)
						if (userName == E.myname and userRealm == E.myrealm) then return end;

						userVersion = tonumber(userVersion)

						if userVersion > highestVersion then
							highestVersion = userVersion
						end

						local id = #UserListCache + 1;

						for i=1,#UserListCache do
							if (UserListCache[i].userName == userName and UserListCache[i].userRealm == userRealm) then
								id = i;
								break;
							end
						end

						UserListCache[id] = {
							['userLevel'] = userLevel,
							['userClass'] = userClass,
							['userName'] = userName,
							['userRealm'] = userRealm,
							['userVersion'] = userVersion,
						}

						if (IsAddOnLoaded("ElvUI_Config")) then
							ACD:SelectGroup('ElvUI', 'sle', 'developer', 'userList')
						end
					else
						local _, numBNetOnline = BNGetNumFriends()
						for i = 1, numBNetOnline do
							local presenceID, presenceName, _, _, toon, _, _, _ = BNGetFriendInfo(i)
							message = message:gsub("SLEinfo", '')
							local pid = tonumber(message)
							if pid == presenceID then
								bnettesttbl[message] = presenceName;
							end
						end
					end
				end
			end
		end)

		local function configTable()
			E.Options.args.sle.args.developer = {
				order = 999,
				type = 'group',
				name = "Developer",
				childGroups = 'tab',
				args = {
					header = {
						order = 1,
						type = "header",
						name = "Evil Overlord Control Panel",
					},
					testdesc = {
						order = 2,
						type = "description",
						name = "WTF are you doing here, asshole?!",
					},
					userList = {
						order = 3,
						type = "group",
						name = "User List",
						args = {
							listheader = {
								order = 1,
								type = "header",
								name = "List of possible victims",
							},
							List = {
								type = 'select',
								name = 'Choose a channel',
								order = 2,
								get = function() return selectedChannel end,
								set = function(_, value)
									selectedChannel = value
								end,
								values = {
									[''] = ' ',
									['GUILD'] = 'Guild',
									['INSTANCE_CHAT'] = 'Instance',
									['PARTY'] = 'Party',
									['RAID'] = 'Raid',
									['BNET'] = 'BNet',
								},
							},
							submitbutton = {
								type = 'execute',
								order = 3,
								name = function()
									return selectedChannel ~= '' and "Update List" or "Clear List"
								end,
								func = function(info, value)
									UserListCache = {} -- Clear Cache

									if selectedChannel == 'BNET' then
										local _, numBNetOnline = BNGetNumFriends()
										for i = 1, numBNetOnline do
											local presenceID, _, _, _, _, _, client, isOnline = BNGetFriendInfo(i)
											if isOnline and client == BNET_CLIENT_WOW then
												BNSendGameData(presenceID, 'SLE_DEV_REQ', 'userlist')
											end
										end
									elseif selectedChannel ~= '' then
										SendAddonMessage('SLE_DEV_REQ', 'userlist', selectedChannel)
									end
								end,
							},
							Space = {
								type = 'description',
								name = ' ',
								order = 4,
							},
							userList = {
								type = 'group',
								name = function()
									return 'Userlist : '..selectedChannel
								end,
								order = 5,
								guiInline = true,
								args = {},
								hidden = function() return selectedChannel == '' end,
							},
						},
					},
					devdiaggroup = {
						order = 5,
						type = "group",
						name = "Tech and shit",
						args = {
							subgroup = {
								order = 1,
								type = "header",
								name = "Some tech stuff",
							},
							cpuprofiling = {
								order = 2,
								type = 'execute',
								name = "CPU Profiling",
								func = function() SetCVar("scriptProfile", GetCVar("scriptProfile") == "1" and 0 or 1); ReloadUI() end,
							},
						},
					},
					devgroupone = {
						order = 500,
						type = "group",
						name = "Test Group",
						args = {
							subgroup = {
								order = 1,
								type = "header",
								name = "Dafuq we have this?",
							},
						},
					},
				},
			}

			for i = 1, 40 do
				E.Options.args.sle.args.developer.args.userList.args.userList.args[tostring(i)] = {
					type = 'description',
					order = i,
					name = function()
						if UserListCache[i] then
							local Level = GetQuestDifficultyColor(UserListCache[i]['userLevel'])
							Level = format('|cff%02x%02x%02x%s|r', Level.r *255, Level.g *255, Level.b *255, UserListCache[i]['userLevel'])

							local ClassColor = '|c'..RAID_CLASS_COLORS[(UserListCache[i]['userClass'])]['colorStr']
							local UserName = ClassColor..UserListCache[i]['userName']..'|r'

							local UserRealm = UserListCache[i]['userRealm']

							local UserVersion = UserListCache[i]['userVersion']
							UserVersion = (UserVersion == highestVersion and '|cffceff00' or '|cffff5678')..UserVersion

							local Icon = '';
							local realm = UserRealm:gsub(' ','');
							if (SLE.SpecialChatIcons[realm] and SLE.SpecialChatIcons[realm][UserListCache[i]['userName']]) then
								Icon = SLE.SpecialChatIcons[realm][UserListCache[i]['userName']];
						
							end
							return Level..'  '..UserName.. '|cffffffff - '..UserRealm..' : '..UserVersion..Icon
						else
							return ' '
						end
					end,
					hidden = function() return not UserListCache[i] end,
				}
			end
		end

		table.insert(E.SLEConfigs, configTable)
	end
end
local f = CreateFrame("Frame", "SLE_Dev_load", UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", Login)