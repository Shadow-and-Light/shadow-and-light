local SLE, T, E, L, V, P, G = unpack(select(2, ...))

local function configTable()
	if not SLE.initialized then return end
	
	local function CreateQuestion(i, text)
		local question = {
			type = 'group', name = '', order = i, guiInline = true,
			args = {
				q = { order = 1, type = 'description', fontSize = 'medium', name = text },
			},
		}
		return question
	end
	--Main options group
	E.Options.args.sle.args.help = {
		type = 'group',
		name = L["About/Help"],
		order = 100,
		childGroups = 'tab',
		args = {
			about = {
				type = 'group', name = L["About"], order = 1,
				args = {
					content = { order = 1, type = 'description', fontSize = 'medium', name = L["SLE_DESC"] },
				},
			},
			faq = {
				type = 'group',
				name = 'FAQ',
				order = 5,
				childGroups = "select",
				args = {
					desc = {
						order = 1,
						type = 'description',
						fontSize = 'medium',
						name = L["FAQ_DESC"],
					},
					elvui = {
						type = 'group', order = 1, name = "ElvUI",
						args = {
							q1 = CreateQuestion(1, L["FAQ_Elv_1"]),
							q2 = CreateQuestion(2, L["FAQ_Elv_2"]),
							q3 = CreateQuestion(3, L["FAQ_Elv_3"]),
							q4 = CreateQuestion(4, L["FAQ_Elv_4"]),
							q5 = CreateQuestion(5, L["FAQ_Elv_5"]),
						},
					},
					sle = {
						type = 'group', order = 2, name = "Shadow & Light",
						args = {
							q1 = CreateQuestion(1, L["FAQ_sle_1"]),
							q2 = CreateQuestion(2, L["FAQ_sle_2"]),
							q3 = CreateQuestion(3, L["FAQ_sle_3"]),
							q4 = CreateQuestion(4, L["FAQ_sle_4"]),
							q5 = CreateQuestion(5, L["FAQ_sle_5"]),
						},
					},
				},
			},
			links = {
				type = 'group',
				name = L["Links"],
				order = 10,
				args = {
					desc = {
						order = 1, type = 'description', fontSize = 'medium', name = L["LINK_DESC"]
					},
					tukuilink = {
						order = 2, type = 'input', width = 'full', name = 'TukUI.org',
						get = function(info) return 'http://www.tukui.org/addons/index.php?act=view&id=42' end,
					},
					wowilink = {
						order = 3, type = 'input', width = 'full', name = 'WoWInterface',
						get = function(info) return 'http://www.wowinterface.com/downloads/info20927-ElvUIShadowLight.html' end,
					},
					curselink= {
						order = 4, type = 'input', width = 'full', name = 'Curse.com',
						get = function(info) return 'http://www.curse.com/addons/wow/shadow-and-light-edit' end,
					},
					gitlablink = {
						order = 5, type = 'input', width = 'full', name = L["GitLab Link / Report Errors"],
						get = function(info) return 'http://git.tukui.org/repooc/elvui-shadowandlight' end,
					},
				},
			},
			--Credits
			credits = {
				order = 400,
				type = 'group',
				name = L["Credits"],
				args = {
					creditheader = { order = 1, type = "header", name = L["Credits"] },
					credits = {
						order = 2,
						type = "description",
						name = L["ELVUI_SLE_CREDITS"]..'\n\n\n'..L["Submodules and Coding:"]..'\n\n'..L["ELVUI_SLE_CODERS"]..'\n\n\n'..L["Other Support:"]..'\n\n'..L["ELVUI_SLE_MISC"],
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)