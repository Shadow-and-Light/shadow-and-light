local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local MM = SLE:GetModule("Minimap")
local DTP = SLE:GetModule('Datatexts')

local MINIMAP_LABEL = MINIMAP_LABEL

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.minimap = {
		type = "group",
		name = MINIMAP_LABEL,
		order = 1,
		childGroups = 'tab',
		args = {
			header = ACH:Header(L["Minimap Options"], 1),
			desc = ACH:Description(L["MINIMAP_DESC"], 2),
			elvuibars = {
				type = "group",
				name = L["General"],
				order = 3,
				guiInline = true,
				args = {
					combat = {
						type = "toggle",
						name = L["Hide In Combat"],
						order = 1,
						desc = L["Hide minimap in combat."],
						disabled = false,
						get = function(info) return E.db.sle.minimap[info[#info]] end,
						set = function(info, value) E.db.sle.minimap[info[#info]] = value; MM:HideMinimapRegister() end,
					},
					rectangle = {
						type = "toggle",
						name = L["Rectangle Minimap"],
						order = 1,
						desc = L["This provides a rectangle shape for ElvUI's minimap.  Please note, due to some limitations, you can not put this flush at the top of the screen."],
						get = function(info) return E.private.sle.minimap[info[#info]] end,
						set = function(info, value) E.private.sle.minimap[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					hideicon = {
						order = 1,
						type = "toggle",
						name = L["Hide Minimap Mail Icon"],
						get = function(info) return E.db.sle.minimap.mail[info[#info]] end,
						set = function(info, value) E.db.sle.minimap.mail[info[#info]] = value; DTP:MailUp() end,
					}
				},
			},
		},
	}

	--*Override ElvUI Minimap size options as we don't want them to use to small of a map and have to reload after changing the setting
	if E.private.sle.minimap.rectangle then
		E.Options.args.maps.args.minimap.args.generalGroup.args.size = {
			order = 2,
			type = "range",
			name = L["Size"],
			desc = L["Adjust the size of the minimap."],
			min = 150, max = 500, step = 1,
			get = function(info) return E.db.general.minimap[info[#info]] end,
			set = function(info, value) E.db.general.minimap[info[#info]] = value; MM:UpdateSettings(); E:StaticPopup_Show("PRIVATE_RL") end,
			disabled = function() return not E.private.general.minimap.enable end,
		}
	end
end

tinsert(SLE.Configs, configTable)
