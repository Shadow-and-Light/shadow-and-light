local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)

-- GLOBALS: unpack, select, tinsert

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
Chris X.
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
Eltreum
Merathilis, The Confused
Nihilistzsche
Nils Ruesch
Omega1970
Pvtschlag
Releaf
Roxanne
Shenzo
Simpy, The Heretic
Sinaris
Swordyy]]

L["ELVUI_SLE_DARTH_SAVIORS"] = [[Alenka B.
Alexander H.
Alexander P.
Alexander S.
Allen G.
Andrew R.
Andrew W.
Angela N.
Annastacia Mrani A.
Daniel B
Daniel N.
Daniel V.
Eveline E.
Frank R.
Geir Olav U.
Henry N.
Jackie C.
Jakub M.
Jee Hun P.
Jesse S.
Jhon Delgado C.
Juergen B.
Kasper B.
Kathrine C.
Kenneth H.
Kevin G.
Kimberly S.
Kristófer H.
Kylie E.
Leon D.
Lucas Nascimento B.
Maarten M.
Mario S.
Mark L.
Martin P.
Mathis L.
Natasha F.
Nikita K.
No Bogey Disc Golf LLC
Patric K.
Patrick M.
Patrizia R.
psyjer69
Ricardo Pedraza G.
Richard A.
Rogier B.
Ruben A.
Steffen N.
Thomas K.
Tiit T.
Todd H.
Wesley C.]]

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

	E.Options.args.sle.args.help = {
		type = 'group',
		name = L["About/Help"]..[[ |TInterface\MINIMAP\TRACKING\OBJECTICONS:14:14:0:0:256:64:60:90:32:64|t]],
		order = 90,
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["About/Help"], 1),
			about = {
				type = 'group', name = L["About"]..' '..E.NewSign, order = 2,
				args = {
					content = ACH:Description('\n'..L["SLE_DESC"], 2, 'medium'),
				},
			},
			faq = {
				type = 'group',
				name = [[FAQ |TInterface\MINIMAP\TRACKING\OBJECTICONS:14:14:0:0:256:64:60:90:32:64|t]],
				order = 5,
				childGroups = 'select',
				args = {
					desc = ACH:Description(L["FAQ_DESC"], 1, 'medium'),
					elvui = {
						type = 'group', order = 10, name = 'ElvUI',
						args = {
							q1 = CreateQuestion(1, L["FAQ_Elv_1"]),
							q2 = CreateQuestion(2, L["FAQ_Elv_2"]),
							q3 = CreateQuestion(3, L["FAQ_Elv_3"]),
							q4 = CreateQuestion(4, L["FAQ_Elv_4"]),
							q5 = CreateQuestion(5, L["FAQ_Elv_5"]),
						},
					},
					sle = {
						type = 'group', order = 20, name = 'Shadow & Light',
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
					desc = ACH:Description(L["LINK_DESC"], 1, 'medium'),
					tukuilink = {
						order = 2, type = 'input', width = 'full', name = 'Wago Addons',
						get = function() return 'https://addons.wago.io/addons/shadow-and-light' end,
					},
					curselink= {
						order = 3, type = 'input', width = 'full', name = 'Curseforge.com',
						get = function() return 'https://www.curseforge.com/wow/addons/elvui-shadow-light' end,
					},
					githublink = {
						order = 4, type = 'input', width = 'full', name = L["GitLab Link / Report Errors"],
						get = function() return 'https://github.com/Shadow-and-Light/shadow-and-light' end,
					},
					discord = {
						order = 5, type = 'input', width = 'full', name = L["Discord"],
						get = function() return 'https://discord.gg/zspjRWp' end,
					},
				},
			},
			patrons = {
				order = 100,
				type = 'group',
				name = L["Patrons"]..[[ |TInterface\BUTTONS\UI-GroupLoot-Coin-Up:16:16|t]],
				args = {
					header = ACH:Header(L["Patreons"], 1),
					patrons = {
						order = 2,
						type = 'group',
						guiInline = true,
						name = L["Patrons"],
						args = {
							desc = ACH:Description(L["ELVUI_SLE_PATREON_TITLE"]..'\n\n', 1),
							list = ACH:Description(L["ELVUI_SLE_PATRONS"], 2, nil, nil, nil, nil, nil, 'half'),
						},
					},
					donors = {
						order = 3,
						type = 'group',
						guiInline = true,
						name = L["Donors"],
						args = {
							desc = ACH:Description(L["ELVUI_SLE_DONORS_TITLE"]..'\n\n', 1),
							list = ACH:Description(L["ELVUI_SLE_DONORS"], 2, nil, nil, nil, nil, nil, 'half'),
						},
					},
				},
			},
			credits = {
				order = 400,
				type = 'group',
				name = L["Credits"]..[[ |TInterface\AddOns\ElvUI_SLE\media\textures\chat\Chat_Test:14:14|t]],
				args = {
					header = ACH:Header(L["Credits"], 1),
					desc = ACH:Description(L["ELVUI_SLE_CREDITS"]..'\n\n', 2),
					coding = {
						order = 3,
						type = 'group',
						guiInline = true,
						name = L["Submodules and Coding:"],
						args = {
							list = ACH:Description(L["ELVUI_SLE_CODERS"], 1),
						},
					},
					misc = {
						order = 4,
						type = 'group',
						guiInline = true,
						name = L["Other Support:"],
						args = {
							list = ACH:Description(L["ELVUI_SLE_MISC"], 2),
						},
					},
				},
			},
			DarthThanks = {
				order = 401,
				type = 'group',
				name = L["Darth's Thanks"],
				args = {
					--header = ACH:Header(L["Darth Saviors"], 1),
					list = {
						order = 2,
						type = 'group',
						guiInline = true,
						name = "",
						args = {
							desc = ACH:Description(L["ELVUI_SLE_DARTH_SAVIORS_DESC"]..'\n\n', 1),
							list = ACH:Description(L["ELVUI_SLE_DARTH_SAVIORS"], 2, nil, nil, nil, nil, nil, 'full'),
						},
					},
				},
			}
		},
	}
end

tinsert(SLE.Configs, configTable)
