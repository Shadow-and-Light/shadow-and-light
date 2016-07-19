local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local MM = SLE:GetModule("Minimap")
local MINIMAP_LABEL = MINIMAP_LABEL
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.minimap = {
		type = "group",
		name = MINIMAP_LABEL,
		order = 13,
		childGroups = 'tab',
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Minimap Options"],
			},
			intro = {
				order = 2,
				type = 'description',
				name = L["MINIMAP_DESC"],
			},
			combat = {
				type = "toggle",
				name = L["Hide In Combat"],
				order = 3,
				desc = L["Hide minimap in combat."],
				disabled = false,
				get = function(info) return E.db.sle.minimap.combat end,
				set = function(info, value) E.db.sle.minimap.combat = value; MM:HideMinimapRegister() end,
			},
			alpha = {
				order = 4,
				type = 'range',
				name = L["Minimap Alpha"],
				isPercent = true,
				min = 0.3, max = 1, step = 0.01,
				get = function(info) return E.db.sle.minimap.alpha end,
				set = function(info, value) E.db.sle.minimap.alpha = value; MM:MinimapTransparency() end,
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)