local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE');
local ACD = LibStub("AceConfigDialog-3.0")

local bnettesttbl = {}
function SLE:GetBNetInfo()
		--print("sent")
		local _, numBNetOnline = BNGetNumFriends()
		for i = 1, numBNetOnline do
			local presenceID, presenceName, _, _, _, _, client, isOnline = BNGetFriendInfo(i)
			if isOnline and client == BNET_CLIENT_WOW then
				BNSendGameData(presenceID, 'SLE_DEV_REQ', 'slesay#'..presenceID)
			end
		end
end

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
	local bnetP = ""
	

	RegisterAddonMessagePrefix('SLE_DEV_INFO')

	local f = CreateFrame('Frame')
	f:RegisterEvent('CHAT_MSG_ADDON')
	f:RegisterEvent('BN_CHAT_MSG_ADDON')
	f:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
	f:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
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
					
					ACD:SelectGroup('ElvUI', 'sle', 'developer', 'userList')
				else
					--print("WTF")
					local _, numBNetOnline = BNGetNumFriends()
					for i = 1, numBNetOnline do
						local presenceID, presenceName, _, _, toon, _, _, _ = BNGetFriendInfo(i)
						message = message:gsub("SLEinfo", '')
						--if message == toon then 
							bnettesttbl[message] = presenceName; 
							--print("Da table: ", bnettesttbl[presenceID])
						--end
					end
				end
			end
		end
		--[[
		if event == 'BN_CHAT_MSG_ADDON' and prefix == 'SLE_DEV_INFO' then
			print("Hi")
			local userLevel, userClass, userName, userRealm, userVersion = strsplit('#', message)
			userVersion = tonumber(userVersion)

			if userVersion > highestVersion then
				highestVersion = userVersion
			end
			
			UserListCache[#UserListCache + 1] = {
				['userLevel'] = userLevel,
				['userClass'] = userClass,
				['userName'] = userName,
				['userRealm'] = userRealm,
				['userVersion'] = userVersion,
			}
			
			ACD:SelectGroup('ElvUI', 'sle', 'developer', 'userList')
		end]]
	end)

	local function configTable()
		E.Options.args.sle.args.developer = {
			order = 999,
			type = 'group',
			name = "Developer",
			childGroups = 'tree',
			args = {
				header = {
					order = 1,
					type = "header",
					name = "Developer Header",
				},
				testdesc = {
					order = 2,
					type = "description",
					name = "devdesc",
				},
				userList = {
					order = 3,
					type = "group",
					name = "User List",
					args = {
						listheader = {
							order = 1,
							type = "header",
							name = "User List2",
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
				devcommand = {
					order = 500,
					type = "group",
					name = "Commands",
					args = {
						header = {
							order = 1,
							type = "header",
							name = "Developer commands execution GUI",
						},
						desc = {
							order = 2,
							type = 'description',
							name = "The GUI for executing old /slesays and /slecmd without typing all the shit mannually.",
						},
						flag = {
							type = 'select',
							name = 'Addon message type',
							order = 3,
							get = function() return flag end,
							set = function(_, value)
								flag = value
							end,
							values = {
								['SLE_DEV_SAYS'] = 'S&L Says',
								['SLE_DEV_CMD'] = 'S&L Command',
							},
						},
						channel = {
							type = 'select',
							name = 'Addon message channel',
							order = 4,
							get = function() return addonChannel end,
							set = function(_, value)
								addonChannel = value
								--if addonChannel == "BNET" then
								--	SLE:GetBNetInfo()
								--end
							end,
							values = {
								['GUILD'] = 'Guild',
								['INSTANCE_CHAT'] = 'Instance',
								['PARTY'] = 'Party',
								['RAID'] = 'Raid',
								['WHISPER'] = 'Whisper',
								['BNET'] = 'BNet',
							},
						},
						bnetlist = {
							type = 'select',
							name = 'BNet List',
							order = 5,
							get = function() return bnetP end,
							set = function(_, value)
								bnetP = value
								--if addonChannel == "BNET" then
								--	SLE:GetBNetInfo()
								--end
							end,
							values = function()
								SLE:GetBNetInfo()
								return bnettesttbl
							end,
						},
						target = {
							order = 6,
							type = 'input',
							width = 'full',
							name = 'Unit to send message to',
							get = function() return addonTarget end,
							set = function(_, value)
								addonTarget = value
							end,
						},
						message = {
							order = 7,
							type = "group",
							name = 'Message',
							guiInline = true,
							args = {
								channel = {
									type = 'select',
									order = 1,
									name = 'Output channel (S&L Says only)',
									disabled = function() return flag ~= 'SLE_DEV_SAYS' end,
									get = function() return output end,
									set = function(_, value)
										output = value
									end,
									values = {
										['GUILD'] = 'Guild',
										['INSTANCE_CHAT'] = 'Instance',
										['PARTY'] = 'Party',
										['RAID'] = 'Raid',
										['SAY'] = "Say",
										['YELL'] = "Yell",
										['WHISPER'] = "Whisper",
									},
								},
								message = {
									type = 'input',
									order = 2,
									width = 'full',
									name = 'Message to send/Script to execute',
									get = function() return text end,
									set = function(_, value)
										text = value
									end,
								},
								whispTarget = {
									type = 'input',
									order = 3,
									width = 'full',
									name = 'Whisper target (S&L Says with whisper only)',
									disabled = function() return (flag ~= 'SLE_DEV_SAYS') or (flag == 'SLE_DEV_SAYS' and output ~= 'WHISPER') end,
									get = function() return wtarget end,
									set = function(_, value)
										wtarget = value
									end,
								},
							},
						},
						submitbutton = {
							type = 'execute',
							order = 8,
							name = "Execute command",
							desc = "Unleash the chaos!!!",
							func = function ()
								SLE:Print('Trying to execute this command...')
								E:sleCommand(flag, addonChannel, addonTarget, output, text, wtarget, bnetP)
							end,
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
							name = "Sub Group 2",
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