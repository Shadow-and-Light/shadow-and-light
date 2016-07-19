local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local DTP = SLE:GetModule('Datatexts')


local function configTable()
	if not SLE.initialized then return end

	local function CreateDPConfig(i)
		local config = {
			order = 10 + i, type = "group", name = L["SLE_DataPanel_"..i],
			get = function(info) return E.db.sle.datatexts["panel"..i][ info[#info] ] end,
			args = {
				enabled = {
					order = 1, type = "toggle",
					name = L["Enable"], desc = L["Show/Hide this panel."],
					set = function(info, value)E.db.sle.datatexts["panel"..i].enabled = value; DTP:Toggle(i) end
				},
				width = {
					order = 2, type = "range",
					name = L["Width"], desc = L["Sets size of this panel"],
					disabled = function() return not E.db.sle.datatexts["panel"..i].enabled end,
					min = 50, max = (E.eyefinity or E.screenwidth)/2, step = 1,
					set = function(info, value) E.db.sle.datatexts["panel"..i].width = value; DTP:Size(i) end,
				},
				hide = {
					order = 3, type = "toggle",
					name = L["Hide panel background"],
					desc = L["Don't show this panel, only datatexts assinged to it"],
					disabled = function() return not E.db.sle.datatexts["panel"..i].enabled end,
					get = function(info) return E.db.sle.datatexts["panel"..i].noback end,
					set = function(info, value) E.db.sle.datatexts["panel"..i].noback = value; E:StaticPopup_Show('CONFIG_RL') end,
				},
				transparent = {
					order = 4, type = 'toggle', name = L["Panel Transparency"],
					disabled = function() return not E.db.sle.datatexts["panel"..i].enabled or E.db.sle.datatexts["panel"..i].noback end,
					set = function(info, value) E.db.sle.datatexts["panel"..i].transparent = value; DTP:Template(i) end,
				},
				pethide = {
					order = 5, type = 'toggle',
					name = L["Hide in Pet Batlle"],
					desc = L["Show/Hide this frame during Pet Battles."],
					set = function(info, value) E.db.sle.datatexts["panel"..i].pethide = value; DTP:PetHide(i) end,
				},
				mouseover = {
					order = 6, type = 'toggle', name = L["Mouseover"],
					disabled = function() return not E.db.sle.datatexts["panel"..i].enabled end,
					set = function(info, value) E.db.sle.datatexts["panel"..i].mouseover = value; DTP:Mouseover(i) end,
				},
				alpha = {
					order = 12, type = 'range',
					name = L["Alpha"], isPercent = true,
					min = 0, max = 1, step = 0.01,
					set = function(info, value) E.db.sle.datatexts["panel"..i].alpha = value; DTP:Alpha(i) end,
				},
			},
		}
		return config
	end

	local function CreateChatConfig(i, chat)
		local name = T.strlower(chat)
		local db = chat == "LeftChat" and "leftChatPanel" or "rightChatPanel"
		local config = {
			order = 18 + i, type = "group", name = L[chat],
			args = {
				enabled = {
					order = 1, type = "toggle",
					name = L["Enable"], desc = L["Show/Hide this panel."],
					get = function(info) return E.db.datatexts[db] end,
					set = function(info, value) 
						E.db.datatexts[db] = value;
						if E.db[chat.."PanelFaded"] then
							E.db[chat.."PanelFaded"] = true;
							Hide[chat]()
						end
						E:GetModule('Chat'):UpdateAnchors()
						E:GetModule('Layout'):ToggleChatPanels()
						E:GetModule('Bags'):PositionBagFrames()
					end
				},
				width = {
					order = 2, type = "range",
					name = L["Width"], desc = L["Sets size of this panel"],
					disabled = function() return not E.db.datatexts[db] end,
					min = 150, max = (E.eyefinity or E.screenwidth)/2, step = 1,
					get = function(info) return E.db.sle.datatexts[name].width end,
					set = function(info, value) E.db.sle.datatexts[name].width = value; DTP:ChatResize() end,
				},
				alpha = {
					order = 12, type = 'range',
					name = L["Alpha"], isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.db.sle.datatexts[name].alpha end,
					set = function(info, value) E.db.sle.datatexts[name].alpha = value; DTP:ChatResize() end,
				},
			},
		}
		return config
	end

	--Datatext panels
	E.Options.args.sle.args.modules.args.datatext = {
		order = 8, type = "group", name = L["DataTexts"],
		childGroups = "tab",
		args = {
			panels = {
				type = "group",
				name = L["Datatexts"],
				order = 1,
				args = {
					header = { order = 1, type = "header", name = L["Additional Datatext Panels"] },
					intro = { order = 2, type = "description", name = L["DP_DESC"] },
					Reset = {
						order = 3,
						type = 'execute',
						name = L["Restore Defaults"],
						desc = L["Reset these options to defaults"],
						func = function() E:GetModule('SLE'):Reset(nil, nil, true) end,
					},
					spacer = { order = 4, type = 'description', name = "" },
					chathandle = {
						order = 7,
						type = "toggle",
						name = L["Override Chat DT Panels"],
						desc = L["This will have S&L handle chat datatext panels and place them below the left & right chat panels.\n\n|cffFF0000Note:|r When you first enabled, you may need to move the chat panels up to see your datatext panels."],
						get = function(info) return E.db.sle.datatexts.chathandle end,
						set = function(info, value) E.db.sle.datatexts.chathandle = value; E:GetModule('Layout'):ToggleChatPanels(); E.Chat:PositionChat(true) end,
						disabled = function() return T.IsAddOnLoaded("ElvUI_TukUIStyle") end,
					},
					panel1 = CreateDPConfig(1),
					panel2 = CreateDPConfig(2),
					panel3 = CreateDPConfig(3),
					panel4 = CreateDPConfig(4),
					panel5 = CreateDPConfig(5),
					panel6 = CreateDPConfig(6),
					panel7 = CreateDPConfig(7),
					panel8 = CreateDPConfig(8),
					leftchat = CreateChatConfig(1, "LeftChat"),
					rightchat = CreateChatConfig(1, "RightChat"),
				},
			},
		},
	}

	E.Options.args.sle.args.modules.args.datatext.args.sldatatext = {
		order = 2, type = "group", name = L["S&L Datatexts"],
		args = {
			header = { order = 1, type = "header", name = L["Datatext Options"] },
			intro = { order = 2, type = "description",
				name = L["Some datatexts that Shadow & Light are supplied with, has settings that can be modified to alter the displayed information."]
			},
			spacer = { order = 3, type = 'description', name = "" },
		},
	}
end

T.tinsert(SLE.Configs, configTable)