local E, L, V, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local CH = E:GetModule('Chat')

local selectedName
local selectedChannel
local names
local channels

--Options for selected name
local function UpdateName(reset)
	if not selectedName or not E.private['namelist'][selectedName] or reset then
		E.Options.args.nameplate.args.nameGroup = nil
		if not reset then
			return
		end
	end
	
	E.Options.args.dpe.args.chat.args.nameGroup = {
		type = 'group',
		name = selectedName,
		guiInline = true,
		order = -10,	
		args = {},	
	}
	
	E.Options.args.dpe.args.chat.args.nameGroup.args.info = {
		order = 1,
		type = "description",
		name = L["You can delete selected name from the list here by clicking the button below"],
	}
	
	E.Options.args.dpe.args.chat.args.nameGroup.args.delete = {
		order = 2,
		type = "execute",
		name = L["Remove Name"],
		desc = L["Delete this name from the list"],
		func = function() CH:DeleteName() end,
	}	
end

--Options for selected channel
local function UpdateChannel(reset)
	if not selectedChannel or not E.private['channellist'][selectedChannel] or reset then
		E.Options.args.nameplate.args.channelGroup = nil
		if not reset then
			return
		end
	end
	
	E.Options.args.dpe.args.chat.args.channelGroup = {
		type = 'group',
		name = selectedChannel,
		guiInline = true,
		order = -20,	
		args = {},	
	}
	
	E.Options.args.dpe.args.chat.args.channelGroup.args.info = {
		order = 1,
		type = "description",
		name = L["You can delete selected channel from the list here by clicking the button below"],
	}
	
	E.Options.args.dpe.args.chat.args.channelGroup.args.delete = {
		order = 2,
		type = "execute",
		name = L["Remove Channel"],
		desc = L["Delete this channel from the list"],
		func = function() CH:DeleteChannel() end,
	}	
end

function CH:DeleteName()
	E.private['namelist'][selectedName] = nil
	selectedName = nil;
	E.Options.args.dpe.args.chat.args.nameGroup = nil
	UpdateName()
	CH:NamesListUpdate()
end

function CH:DeleteChannel()
	E.private['channellist'][selectedChannel] = nil
	selectedChannel = nil;
	E.Options.args.dpe.args.chat.args.channelGroup = nil
	UpdateChannel()
	CH:ChannelListUpdate()
end

E.Options.args.dpe.args.chat = {
	order = 8,
	type = "group",
	name = L["Chat"],
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Chat options"],
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				chatwindowfade = {
					order = 1,
					type = "toggle",
					name = L["Chat Fade"],
					desc = L["Enable/disable the text fading in the chat window."],
					get = function(info) return E.db.dpe.chat.fade end,
					set = function(info, value) E.db.dpe.chat.fade = value; CH:FadeUpdate() end, 
				},
				editboxhistory = {
					order = 2,
					type = "range",
					name = L["Chat Editbox History"],
					desc = L["Amount of messages to save. Set to 0 to disable."],
					min = 0, max = 20, step = 1,
					get = function(info) return E.db.chat.editboxhistory end,
					set = function(info, value)	E.db.chat.editboxhistory = value; end,
				},
			},
		},
		warning = {
			order = 3,
			type = "group",
			name = L["Name Highlight"],
			guiInline = true,
			args = {
				info = {
					order = 1,
					type = "description",
					name = L["TOON_DESC"],
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					get = function(info) return E.db.dpe.chat.namehighlight end,
					set = function(info, value) E.db.dpe.chat.namehighlight = value; end
				},
				soundenable = {
					order = 3,
					type = "toggle",
					name = L["Enable sound"],
					desc = L["Play sound when your name is mentioned in chat."],
					disabled = function() return not E.db.dpe.chat.namehighlight end,
					get = function(info) return E.db.dpe.chat.sound end,
					set = function(info, value) E.db.dpe.chat.sound = value; end
				},
				sound = {
					type = "select", dialogControl = 'LSM30_Sound',
					order = 4,
					name = L["Sound"],
					desc = L["Sound that will play when your name is mentioned in chat."],
					disabled = function() return not E.db.dpe.chat.sound or not E.db.dpe.chat.namehighlight end,
					values = AceGUIWidgetLSMlists.sound,
					get = function(info) return E.db.dpe.chat.warningsound end,
					set = function(info, value) E.db.dpe.chat.warningsound = value; end		
				},
				timer = {
					order = 5,
					type = "range",
					name = L['Timer'],
					desc = L['Sound will be played only once in this number of seconds.'],
					min = 1, max = 20, step = 1,
					disabled = function() return not E.db.dpe.chat.sound or not E.db.dpe.chat.namehighlight end,
					get = function(info) return E.private.channelcheck.time end,
					set = function(info, value) E.private.channelcheck.time = value; end,
				},
				spacer1 = {
					order = 6,
					type = "description",
					name = "",
				},
				spacer2 = {
					order = 7,
					type = "description",
					name = "",
				},
				addName = {
					type = 'input',
					order = 8,
					name = L['Add Name'],
					desc = L["Add a name different from your current character's to be looked for"],
					disabled = function() return not E.db.dpe.chat.namehighlight end,
					get = function(info) return "" end,
					set = function(info, value) 
						if value:match("^%s*$") then
							E:Print(L['Invalid name entered!'])
						return
						elseif E.private['namelist'][value] then
							E:Print(L['Name already exists!'])
						return end
					
						E.Options.args.dpe.args.chat.args.nameGroup = nil
						E.private['namelist'][value] = {};	
						E.private['namelist'][value].enable = true
						UpdateName()
						CH:NamesListUpdate()
					end,
				},
				selectName = {
					order = 9,
					type = 'select',
					name = L['Names list'],
					get = function(info) return selectedName end,
					set = function(info, value) selectedName = value; UpdateName(true) end,	
					disabled = function() return not E.db.dpe.chat.namehighlight end,
					values = function()
						names = {}
						for name in pairs(E.private.namelist) do
							names[name] = name
						end
						return names
					end,
				},
				channels = {
					order = 10,
					type = "group",
					name = L["Channels"],
					guiInline = true,
					disabled = function() return not E.db.dpe.chat.namehighlight end,
					args = {
						say = {
							order = 1,
							type = "toggle",
							name = SAY,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.say end,
							set = function(info, value) E.private.channelcheck.say = value; CH:SetChannelsCheck() end,
						},
						yell = {
							order = 2,
							type = "toggle",
							name = YELL,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.yell end,
							set = function(info, value) E.private.channelcheck.yell = value; CH:SetChannelsCheck() end,
						},
						party = {
							order = 3,
							type = "toggle",
							name = PARTY,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.party end,
							set = function(info, value) E.private.channelcheck.party = value; CH:SetChannelsCheck() end,
						},
						raid = {
							order = 4,
							type = "toggle",
							name = RAID,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.raid end,
							set = function(info, value) E.private.channelcheck.raid = value; CH:SetChannelsCheck() end,
						},
						battleground = {
							order = 5,
							type = "toggle",
							name = BATTLEGROUND,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.battleground end,
							set = function(info, value) E.private.channelcheck.battleground = value; CH:SetChannelsCheck() end,
						},
						guild = {
							order = 6,
							type = "toggle",
							name = GUILD,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.guild end,
							set = function(info, value) E.private.channelcheck.guild = value; CH:SetChannelsCheck() end,
						},
						officer = {
							order = 7,
							type = "toggle",
							name = OFFICER,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.officer end,
							set = function(info, value) E.private.channelcheck.officer = value; CH:SetChannelsCheck() end,
						},
						general = {
							order = 8,
							type = "toggle",
							name = GENERAL,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.general end,
							set = function(info, value) E.private.channelcheck.general = value; end, 
						},
						trade = {
							order = 9,
							type = "toggle",
							name = TRADE,
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.trade end,
							set = function(info, value) E.private.channelcheck.trade = value; end, 
						},
						defense = {
							order = 10,
							type = "toggle",
							name = L["Defense"],
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.defense end,
							set = function(info, value) E.private.channelcheck.defense = value; end,
						},
						lfg = {
							order = 11,
							type = "toggle",
							name = L['LFG'],
							desc = L["Enable/disable checking of this channel."],
							get = function(info) return E.private.channelcheck.lfg end,
							set = function(info, value) E.private.channelcheck.lfg = value; end,
						},
						spacer = {
							order = 12,
							type = "description",
							name = "",
						},
						addChannel = {
							type = 'input',
							order = 13,
							name = L['Add channel'],
							desc = L["Add a custom channel name."],
							get = function(info) return "" end,
							set = function(info, value) 
								if value:match("^%s*$") then
									E:Print(L['Invalid channel entered!'])
								return
								elseif E.private['channellist'][value] then
									E:Print(L['Channel already exists!'])
								return end
							
								E.Options.args.dpe.args.chat.args.channelGroup = nil
								E.private['channellist'][value] = {};	
								E.private['channellist'][value].enable = true
								UpdateChannel()
								CH:ChannelListUpdate()
							end,
						},
						selectChannel = {
							order = 14,
							type = 'select',
							name = L['Channels list'],
							get = function(info) return selectedChannel end,
							set = function(info, value) selectedChannel = value; UpdateChannel(true) end,							
							values = function()
								channels = {}
								for channel in pairs(E.private.channellist) do
									channels[channel] = channel
								end
								return channels
							end,
						},
					},
				},
			},
		},
	},
}
