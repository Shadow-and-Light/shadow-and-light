local SLE, T, E, L, V, P, G = unpack(select(2, ...))

--  GLOBALS: unpack, select, tinsert

--* Leave here as there is no need for translation
L["ELVUI_SLE_DONORS"] = [[Anthony Ross
Bogdan Vozniuk
Christopher Yallalee
Chun Kim
Cyntia McCarthy
Jason Grier
Jeremy G.
Joe Quarles
Jonathan Sweet
Katherine Clarkson
Marguerite F
Nicholas Caldecutt
Richard Gardner
Tony Ellis
Justin]]
L["ELVUI_SLE_PATRONS"] = [[Ali A
Andre E.
Jeremy G.
Mark K.
Peter aka Pete
Sean G.
Syed
TherapyWOW
Thurin]]
L["ELVUI_SLE_CODERS"] = [[Elv
Tukz
Affinitii
Arstraea
Azilroka
Benik, The Slacker
Blazeflack
Boradan
Camealion
Merathilis, The Confused
Nils Ruesch
Omega1970
Pvtschlag
Shenzo
Simpy, The Heretic
Sinaris
Swordyy
Whiro]]


local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

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
		name = L["About/Help"]..[[ |TInterface\MINIMAP\TRACKING\OBJECTICONS:14:14:0:0:256:64:60:90:32:64|t]],
		order = 90,
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["About/Help"], 1),
			about = {
				type = 'group', name = L["About"].." "..E.NewSign, order = 2,
				args = {
					content = ACH:Description("\n"..L["SLE_DESC"], 2, "medium"),
				},
			},
			faq = {
				type = 'group',
				name = [[FAQ |TInterface\MINIMAP\TRACKING\OBJECTICONS:14:14:0:0:256:64:60:90:32:64|t]],
				order = 5,
				childGroups = "select",
				args = {
					desc = ACH:Description(L["FAQ_DESC"], 1, "medium"),
					elvui = {
						type = 'group', order = 10, name = "ElvUI",
						args = {
							q1 = CreateQuestion(1, L["FAQ_Elv_1"]),
							q2 = CreateQuestion(2, L["FAQ_Elv_2"]),
							q3 = CreateQuestion(3, L["FAQ_Elv_3"]),
							q4 = CreateQuestion(4, L["FAQ_Elv_4"]),
							q5 = CreateQuestion(5, L["FAQ_Elv_5"]),
						},
					},
					sle = {
						type = 'group', order = 20, name = "Shadow & Light",
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
				name = L["Links"]..[[ |TInterface\MINIMAP\TRACKING\FlightMaster:16:16|t]],
				order = 10,
				args = {
					desc = ACH:Description(L["LINK_DESC"], 1, "medium"),
					tukuilink = {
						order = 2, type = 'input', width = 'full', name = "TukUI.org",
						get = function(info) return "https://www.tukui.org/addons.php?id=38" end,
					},
					curselink= {
						order = 3, type = 'input', width = 'full', name = "Curse.com",
						get = function(info) return "https://www.curseforge.com/wow/addons/elvui-shadow-light" end,
					},
					gitlablink = {
						order = 4, type = 'input', width = 'full', name = L["GitLab Link / Report Errors"],
						get = function(info) return "https://git.tukui.org/shadow-and-light/shadow-and-light" end,
					},
					patreon = {
						order = 10, type = 'input', width = 'full', name = "Patreon |TInterface\\MONEYFRAME\\UI-GoldIcon:14:14|t",
						get = function(info) return "https://patreon.com/shadow_and_light" end,
					},
					donate = {
						order = 11, type = 'input', width = 'full', name = L["Donate"].." |TInterface\\MONEYFRAME\\UI-GoldIcon:14:14|t",
						get = function(info) return "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EJB4DRU7QZYMG&source=url" end,
					},
				},
			},
			patrons = {
				order = 100,
				type = 'group',
				-- name = L["Patrons"]..[[ |TInterface\MONEYFRAME\UI-GoldIcon:14:14|t]],
				name = L["Patrons"]..[[ |TInterface\BUTTONS\UI-GroupLoot-Coin-Up:16:16|t]],
				args = {
					header = ACH:Header(L["Patreons"], 1),
					patrons = {
						order = 2,
						type = "group",
						guiInline = true,
						name = L["Patrons"],
						args = {
							desc = ACH:Description(L["ELVUI_SLE_PATREON_TITLE"]..'\n\n', 1),
							list = ACH:Description(L["ELVUI_SLE_PATRONS"], 2, nil, nil, nil, nil, nil, "half"),
						},
					},
					donors = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Donors"],
						args = {
							desc = ACH:Description(L["ELVUI_SLE_DONORS_TITLE"]..'\n\n', 1),
							list = ACH:Description(L["ELVUI_SLE_DONORS"], 2, nil, nil, nil, nil, nil, "half"),
						},
					},
				},
			},
			--Credits
			credits = {
				order = 400,
				type = 'group',
				name = L["Credits"]..[[ |TInterface\AddOns\ElvUI_SLE\media\textures\Chat_Test:14:14|t]],
				args = {
					header = ACH:Header(L["Credits"], 1),
					desc = ACH:Description(L["ELVUI_SLE_CREDITS"].."\n\n", 2),
					coding = {
						order = 3,
						type = "group",
						guiInline = true,
						name = L["Submodules and Coding:"],
						args = {
							list = ACH:Description(L["ELVUI_SLE_CODERS"], 1),
						},
					},
					misc = {
						order = 4,
						type = "group",
						guiInline = true,
						name = L["Other Support:"],
						args = {
							list = ACH:Description(L["ELVUI_SLE_MISC"], 2),
						},
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)