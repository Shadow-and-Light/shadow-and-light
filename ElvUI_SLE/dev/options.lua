local E, L, V, P, G, _ = unpack(ElvUI);
local SLE = E:GetModule('SLE');

local selectedChannel = ''
local currentSLEVersion = GetAddOnMetadata('ElvUI_SLE', 'Version')
local UserListCache = {
	[1] = {
		['userLevel'] = 90,
		['userClass'] = E.myclass,
		['userName'] = E.myname,
		['userRealm'] = E.myrealm,
		['userVersion'] = '1.66',
	},
	[2] = {
		['userLevel'] = 90,
		['userClass'] = 'PALADIN',
		['userName'] = 'Arstraea',
		['userRealm'] = 'Hellscream',
		['userVersion'] = '1.65',
	},
}

local function getlist(channel)
	print(channel.." was selected")
end

if SLE:CheckFlag(nil, 'SLEAUTHOR') then
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
								['GUILD'] = 'GUILD',
								['INSTANCE'] = 'INSTANCE',
								['PARTY'] = 'PARTY',
								['RAID'] = 'RAID',
								['BATTLEGROUND'] = 'BATTLEGROUND',
							},
						},
						submitbutton = {
							type = 'execute',
							order = 3,
							name = "Update List",
							func = function(info, value) getlist(selectedChannel) end,
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
						UserVersion = (UserVersion == currentSLEVersion and '|cffceff00' or '|cffff5678')..UserVersion
						
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