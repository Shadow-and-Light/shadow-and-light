local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local NAME = NAME
local function configTable()
	if not SLE.initialized then return end

	E.Options.args.sle.args.modules.args.chat.args.tabs = {
		order = 15,
		type = "group",
		name = L["Tabs"],
		-- guiInline = true,
		get = function(info) return E.db.sle.chat.tab[ info[#info] ] end,
		set = function(info, value) E.db.sle.chat.tab[ info[#info] ] = value; C:SetSelectedTab(true) end,
		args = {
			select = {
				order = 1,
				type = "toggle",
				name = L["Selected Indicator"],
				desc = L["Shows you which of docked chat tabs is currently selected."],
			},
			style = {
				order = 2,
				type = "select",
				name = L["Style"],
				disabled = function() return not E.db.sle.chat.tab.select end,
				values = {
					["DEFAULT"] = "|cff0CD809>|r "..NAME.." |cff0CD809<|r",
					["SQUARE"] = "|cff0CD809[|r "..NAME.." |cff0CD809]|r",
					["HALFDEFAULT"] = "|cff0CD809>|r "..NAME,
					["CHECKBOX"] = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Criteria-Check:26|t]]..NAME,
					["ARROWRIGHT"] = [[|TInterface\BUTTONS\UI-SpellbookIcon-NextPage-Up:26|t]]..NAME,
					["ARROWDOWN"] = [[|TInterface\BUTTONS\UI-MicroStream-Green:26|t]]..NAME,
				}
			},
			color = {
				type = 'color',
				order = 3,
				name = L["Color"],
				hasAlpha = false,
				disabled = function() return not E.db.sle.chat.tab.select or not (E.db.sle.chat.tab.style == "DEFAULT" or E.db.sle.chat.tab.style == "SQUARE" or E.db.sle.chat.tab.style == "HALFDEFAULT") end,
				get = function(info)
					local t = E.db.sle.chat.tab[ info[#info] ]
					local d = P.sle.chat.tab[info[#info]]
					return t.r, t.g, t.b, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					E.db.sle.chat.tab[ info[#info] ] = {}
					local t = E.db.sle.chat.tab[ info[#info] ]
					t.r, t.g, t.b = r, g, b
					C:SetSelectedTab(true)
				end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)