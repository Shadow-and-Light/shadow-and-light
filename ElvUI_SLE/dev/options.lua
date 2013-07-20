local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE');
local ACD = LibStub("AceConfigDialog-3.0")

if SLE:CheckFlag(nil, 'SLEAUTHOR') then
	local selectedChannel = ''
	local UserListCache = {}
	local highestVersion = tonumber(SLE.version)

	RegisterAddonMessagePrefix('SLE_DEV_INFO')

	local f = CreateFrame('Frame')
	f:RegisterEvent('CHAT_MSG_ADDON')
	f:SetScript('OnEvent', function(self, event, prefix, message, channel, sender)
		if event == 'CHAT_MSG_ADDON' and prefix == 'SLE_DEV_INFO' then
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
		end
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

								if selectedChannel ~= '' then
									SendAddonMessage('SLE_DEV_REQ', 'GIVE ME YOUR INFO RIGHT NOW!!!!', selectedChannel)
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
				devgroupone = {
					order = 4,
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

						return Level..'  '..UserName.. '|cffffffff - '..UserRealm..' : '..UserVersion
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